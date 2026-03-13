import { EventEmitter } from '../event/EventEmitter'
import { MusicModel, PlayMode } from '../models/MusicModel'

/**
 * 播放器服务
 */
export class PlayerService extends EventEmitter {
  private static instance: PlayerService

  private _isPlaying: boolean = false
  private _currentMusic: MusicModel | null = null
  private _progress: number = 0
  private _duration: number = 0
  private _volume: number = 0.8
  private _playMode: PlayMode = PlayMode.LIST_LOOP
  private _playList: MusicModel[] = []
  private _currentIndex: number = 0

  private constructor() {
    super()
  }

  static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService()
    }
    return PlayerService.instance
  }

  /**
   * 初始化播放器
   */
  async init(): Promise<void> {
    console.log('[PlayerService] 初始化播放器')
    // TODO: 初始化AVPlayer
  }

  /**
   * 播放音乐
   */
  async playMusic(music: MusicModel): Promise<void> {
    try {
      this._currentMusic = music
      this._isPlaying = true

      this.emit('musicChanged', music)
      this.emit('playStateChanged', true)

      console.log('[PlayerService] 播放音乐:', music.name)
      // TODO: 实际播放逻辑
    } catch (error) {
      console.error('[PlayerService] 播放失败:', error)
      throw error
    }
  }

  /**
   * 暂停播放
   */
  pauseMusic(): void {
    this._isPlaying = false
    this.emit('playStateChanged', false)
    console.log('[PlayerService] 暂停播放')
    // TODO: 实际暂停逻辑
  }

  /**
   * 恢复播放
   */
  resumeMusic(): void {
    this._isPlaying = true
    this.emit('playStateChanged', true)
    console.log('[PlayerService] 恢复播放')
    // TODO: 实际恢复逻辑
  }

  /**
   * 停止播放
   */
  stopMusic(): void {
    this._isPlaying = false
    this._progress = 0
    this.emit('playStateChanged', false)
    this.emit('progressChanged', 0)
    console.log('[PlayerService] 停止播放')
    // TODO: 实际停止逻辑
  }

  /**
   * 设置播放模式
   */
  setPlayMode(mode: PlayMode): void {
    this._playMode = mode
    this.emit('playModeChanged', mode)
    console.log('[PlayerService] 设置播放模式:', mode)
  }

  /**
   * 设置音量
   */
  setVolume(volume: number): void {
    this._volume = Math.max(0, Math.min(1, volume))
    this.emit('volumeChanged', this._volume)
    console.log('[PlayerService] 设置音量:', this._volume)
    // TODO: 实际设置音量逻辑
  }

  /**
   * 跳转到指定位置
   */
  seekTo(time: number): void {
    this._progress = time
    this.emit('progressChanged', time)
    console.log('[PlayerService] 跳转到:', time)
    // TODO: 实际跳转逻辑
  }

  /**
   * 下一首
   */
  nextMusic(): void {
    if (this._playList.length === 0) return

    switch (this._playMode) {
      case PlayMode.LIST_LOOP:
      case PlayMode.SEQUENTIAL:
        this._currentIndex = (this._currentIndex + 1) % this._playList.length
        break
      case PlayMode.RANDOM:
        this._currentIndex = Math.floor(Math.random() * this._playList.length)
        break
      case PlayMode.SINGLE_LOOP:
        // 不切换
        break
    }

    const nextMusic = this._playList[this._currentIndex]
    if (nextMusic) {
      this.playMusic(nextMusic)
    }
  }

  /**
   * 上一首
   */
  previousMusic(): void {
    if (this._playList.length === 0) return

    this._currentIndex = (this._currentIndex - 1 + this._playList.length) % this._playList.length

    const prevMusic = this._playList[this._currentIndex]
    if (prevMusic) {
      this.playMusic(prevMusic)
    }
  }

  /**
   * 设置播放列表
   */
  setPlayList(list: MusicModel[], startIndex: number = 0): void {
    this._playList = list
    this._currentIndex = startIndex
    this.emit('playListChanged', list)
    console.log('[PlayerService] 设置播放列表, 长度:', list.length)
  }

  /**
   * 释放播放器
   */
  async release(): Promise<void> {
    this.stopMusic()
    this.clear()
    console.log('[PlayerService] 释放播放器')
    // TODO: 实际释放逻辑
  }

  // Getters
  get isPlaying(): boolean {
    return this._isPlaying
  }

  get currentMusic(): MusicModel | null {
    return this._currentMusic
  }

  get progress(): number {
    return this._progress
  }

  get duration(): number {
    return this._duration
  }

  get volume(): number {
    return this._volume
  }

  get playMode(): PlayMode {
    return this._playMode
  }

  get playList(): MusicModel[] {
    return this._playList
  }

  get currentIndex(): number {
    return this._currentIndex
  }

  // 派生状态
  get nextMusic(): MusicModel | null {
    if (this._playList.length === 0) return null
    const nextIndex = (this._currentIndex + 1) % this._playList.length
    return this._playList[nextIndex]
  }

  get previousMusic(): MusicModel | null {
    if (this._playList.length === 0) return null
    const prevIndex = (this._currentIndex - 1 + this._playList.length) % this._playList.length
    return this._playList[prevIndex]
  }
}
