/**
 * 播放器服务
 * 基于 HarmonyOS AVPlayer 实现
 */

import media from '@ohos.multimedia.media';
import { MusicInfo, MusicQuality } from '../types/Music';
import { WangYiMusicUrlService } from './musicSdk/wy/WangYiMusicUrlService';

/**
 * 播放状态枚举
 */
export enum PlayState {
  IDLE = 'idle',           // 空闲
  LOADING = 'loading',     // 加载中
  PLAYING = 'playing',     // 播放中
  PAUSED = 'paused',       // 暂停
  COMPLETED = 'completed', // 完成
  ERROR = 'error'          // 错误
}

/**
 * 播放器事件类型
 */
export enum PlayerEventType {
  STATE_CHANGE = 'playerStateChange',
  PROGRESS_CHANGE = 'playerProgressChange',
  ERROR = 'playerError',
  BUFFERING_START = 'playerBufferingStart',
  BUFFERING_END = 'playerBufferingEnd',
  PLAYLIST_CHANGED = 'playlistChanged'
}

/**
 * 播放列表数据接口
 */
export interface PlaylistData {
  list: MusicInfo[];
  index: number;
}

/**
 * 播放状态数据接口
 */
export interface PlayStateData {
  state: PlayState;
}

/**
 * 播放进度数据接口
 */
export interface ProgressData {
  time: number;
}

/**
 * 错误数据接口
 */
export interface ErrorData {
  error: Error | null;
}

/**
 * 播放器事件数据接口
 */
export interface PlayerEventData {
  type: PlayerEventType;
  data?: PlaylistData | PlayStateData | ProgressData | ErrorData;
}

/**
 * 播放器回调函数类型
 */
export type PlayerEventCallback = (data: PlayerEventData) => void;

/**
 * 播放器服务类
 */
export class PlayerService {
  private static instance: PlayerService;
  private avPlayer: media.AVPlayer | null = null;
  private currentMusic: MusicInfo | null = null;
  private playList: MusicInfo[] = [];
  private currentIndex: number = -1;
  private playState: PlayState = PlayState.IDLE;
  private eventCallbacks: Map<PlayerEventType, PlayerEventCallback[]> = new Map();

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService();
    }
    return PlayerService.instance;
  }

  /**
   * 初始化播放器
   */
  private async initPlayer(): Promise<void> {
    if (this.avPlayer) {
      return;
    }

    try {
      this.avPlayer = await media.createAVPlayer();
      this.setupPlayerListeners();
    } catch (error) {
      console.error('Init player failed:', error);
      throw new Error('Init player failed');
    }
  }

  /**
   * 设置播放器监听器
   */
  private setupPlayerListeners(): void {
    if (!this.avPlayer) {
      return;
    }

    // 状态变化监听
    this.avPlayer.on('stateChange', (state) => {
      console.log('Player state changed:', state);
      switch (state) {
        case 'initialized':
          this.updatePlayState(PlayState.LOADING);
          break;
        case 'playing':
          this.updatePlayState(PlayState.PLAYING);
          break;
        case 'paused':
          this.updatePlayState(PlayState.PAUSED);
          break;
        case 'completed':
          this.updatePlayState(PlayState.COMPLETED);
          break;
        case 'error':
          this.updatePlayState(PlayState.ERROR);
          break;
        case 'released':
          this.updatePlayState(PlayState.IDLE);
          break;
      }
    });

    // 进度更新监听
    this.avPlayer.on('timeUpdate', (time) => {
      const progressData: ProgressData = { time };
      this.emitEvent(PlayerEventType.PROGRESS_CHANGE, progressData);
    });

    // 错误监听
    this.avPlayer.on('error', (err) => {
      console.error('Player error:', err);
      const errorData: ErrorData = { error: err as Error };
      this.emitEvent(PlayerEventType.ERROR, errorData);
    });
  }

  /**
   * 播放音乐
   */
  public async playMusic(music: MusicInfo): Promise<void> {
    try {
      await this.initPlayer();

      this.currentMusic = music;
      this.updatePlayState(PlayState.LOADING);

      // 获取音乐URL
      const url = await this.getMusicUrl(music);

      // 设置URL并播放
      this.avPlayer!.url = url;
      await this.avPlayer!.prepare();
      await this.avPlayer!.play();
    } catch (error) {
      console.error('Play music failed:', error);
      this.updatePlayState(PlayState.ERROR);
      throw new Error('Play music failed');
    }
  }

  /**
   * 获取音乐URL
   */
  private async getMusicUrl(music: MusicInfo): Promise<string> {
    try {
      const quality: MusicQuality = MusicQuality.STANDARD;
      switch (music.source) {
        case 'wy':
          return await WangYiMusicUrlService.getMusicUrl(music.songmid || '', quality);
        default:
          throw new Error(`Unsupported music source: ${music.source}`);
      }
    } catch (error) {
      console.error('Get music URL failed:', error);
      throw new Error('Get music URL failed');
    }
  }

  /**
   * 暂停播放
   */
  public async pause(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.pause();
    } catch (error) {
      console.error('Pause failed:', error);
      throw new Error('Pause failed');
    }
  }

  /**
   * 继续播放
   */
  public async resume(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.play();
    } catch (error) {
      console.error('Resume failed:', error);
      throw new Error('Resume failed');
    }
  }

  /**
   * 停止播放
   */
  public async stop(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.stop();
      this.updatePlayState(PlayState.IDLE);
    } catch (error) {
      console.error('Stop failed:', error);
      throw new Error('Stop failed');
    }
  }

  /**
   * 跳转到指定位置
   */
  public async seek(time: number): Promise<void> {
    if (!this.avPlayer) {
      return;
    }

    try {
      await this.avPlayer.seek(time);
    } catch (error) {
      console.error('Seek failed:', error);
      throw new Error('Seek failed');
    }
  }

  /**
   * 设置播放列表
   */
  public setPlayList(list: MusicInfo[], index: number): void {
    this.playList = list;
    this.currentIndex = index;

    const playlistData: PlaylistData = { list, index };
    this.emitEvent(PlayerEventType.PLAYLIST_CHANGED, playlistData);
  }

  /**
   * 播放下一首
   */
  public async playNext(): Promise<void> {
    if (this.playList.length === 0) {
      return;
    }

    this.currentIndex = (this.currentIndex + 1) % this.playList.length;
    await this.playMusic(this.playList[this.currentIndex]);
  }

  /**
   * 播放上一首
   */
  public async playPrev(): Promise<void> {
    if (this.playList.length === 0) {
      return;
    }

    this.currentIndex = (this.currentIndex - 1 + this.playList.length) % this.playList.length;
    await this.playMusic(this.playList[this.currentIndex]);
  }

  /**
   * 获取当前播放状态
   */
  public getPlayState(): PlayState {
    return this.playState;
  }

  /**
   * 获取当前音乐
   */
  public getCurrentMusic(): MusicInfo | null {
    return this.currentMusic;
  }

  /**
   * 获取播放列表
   */
  public getPlayList(): MusicInfo[] {
    return this.playList;
  }

  /**
   * 获取当前索引
   */
  public getCurrentIndex(): number {
    return this.currentIndex;
  }

  /**
   * 获取总时长
   */
  public getDuration(): number {
    if (!this.avPlayer) {
      return 0;
    }
    return this.avPlayer.duration;
  }

  /**
   * 获取当前播放时间
   */
  public getCurrentTime(): number {
    if (!this.avPlayer) {
      return 0;
    }
    return this.avPlayer.currentTime;
  }

  /**
   * 更新播放状态
   */
  private updatePlayState(state: PlayState): void {
    this.playState = state;
    const stateData: PlayStateData = { state };
    this.emitEvent(PlayerEventType.STATE_CHANGE, stateData);
  }

  /**
   * 发送事件
   */
  private emitEvent(type: PlayerEventType, data?: PlaylistData | PlayStateData | ProgressData | ErrorData): void {
    const callbacks = this.eventCallbacks.get(type);
    if (callbacks) {
      callbacks.forEach(callback => {
        const eventData: PlayerEventData = { type, data };
        callback(eventData);
      });
    }
  }

  /**
   * 注册事件监听
   */
  public on(event: PlayerEventType, callback: PlayerEventCallback): void {
    if (!this.eventCallbacks.has(event)) {
      this.eventCallbacks.set(event, []);
    }
    this.eventCallbacks.get(event)?.push(callback);
  }

  /**
   * 移除事件监听
   */
  public off(event: PlayerEventType, callback?: PlayerEventCallback): void {
    if (!callback) {
      this.eventCallbacks.delete(event);
      return;
    }
    const callbacks = this.eventCallbacks.get(event);
    if (callbacks) {
      const index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.splice(index, 1);
      }
    }
  }
}

/**
 * 导出单例实例
 */
export const playerService = PlayerService.getInstance();
