/**
 * 设置管理器
 * 统一管理用户设置的保存和读取
 */

import { storage } from './StorageUtil';
import { SearchType } from '../types/Music';

/**
 * 搜索设置接口
 */
export interface SearchSettings {
  type: SearchType;
  source: string;
  temp_source: string;
}

/**
 * 用户设置接口
 */
export interface UserSettings {
  darkMode: boolean;
  autoPlay: boolean;
  playMode: 'loop' | 'random' | 'single';
  defaultQuality: '128' | '192' | '320' | 'flac';
  volume: number;
  selectedSources: string[];
  searchSettings: SearchSettings;
}

/**
 * 默认设置
 */
const DEFAULT_SETTINGS: UserSettings = {
  darkMode: false,
  autoPlay: true,
  playMode: 'loop',
  defaultQuality: '320',
  volume: 80,
  selectedSources: ['wy', 'tx'],
  searchSettings: {
    type: SearchType.MUSIC,
    source: 'wy',
    temp_source: 'wy'
  }
};

/**
 * 设置管理器类
 */
export class SettingManager {
  private static instance: SettingManager;
  private settings: UserSettings = DEFAULT_SETTINGS;
  private readonly STORAGE_KEY = 'user_settings';

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): SettingManager {
    if (!SettingManager.instance) {
      SettingManager.instance = new SettingManager();
    }
    return SettingManager.instance;
  }

  /**
   * 初始化设置
   */
  public async init(): Promise<void> {
    try {
      const savedSettings = await storage.getObject<UserSettings>(this.STORAGE_KEY);
      if (savedSettings) {
        // 手动合并设置，避免使用展开语法
        this.settings.darkMode = savedSettings.darkMode !== undefined ? savedSettings.darkMode : DEFAULT_SETTINGS.darkMode;
        this.settings.autoPlay = savedSettings.autoPlay !== undefined ? savedSettings.autoPlay : DEFAULT_SETTINGS.autoPlay;
        this.settings.playMode = savedSettings.playMode || DEFAULT_SETTINGS.playMode;
        this.settings.defaultQuality = savedSettings.defaultQuality || DEFAULT_SETTINGS.defaultQuality;
        this.settings.volume = savedSettings.volume !== undefined ? savedSettings.volume : DEFAULT_SETTINGS.volume;
        this.settings.selectedSources = savedSettings.selectedSources && savedSettings.selectedSources.length > 0 
          ? savedSettings.selectedSources 
          : DEFAULT_SETTINGS.selectedSources;
      }
    } catch (error) {
      console.error('SettingManager init failed:', error);
      this.settings = DEFAULT_SETTINGS;
    }
  }

  /**
   * 保存设置
   */
  public async save(): Promise<void> {
    try {
      await storage.setObject(this.STORAGE_KEY, this.settings);
    } catch (error) {
      console.error('SettingManager save failed:', error);
    }
  }

  /**
   * 获取所有设置
   */
  public getSettings(): UserSettings {
    // 返回副本，避免外部修改
    const result: UserSettings = {
      darkMode: this.settings.darkMode,
      autoPlay: this.settings.autoPlay,
      playMode: this.settings.playMode,
      defaultQuality: this.settings.defaultQuality,
      volume: this.settings.volume,
      selectedSources: [...this.settings.selectedSources],
      searchSettings: {
        type: this.settings.searchSettings.type,
        source: this.settings.searchSettings.source,
        temp_source: this.settings.searchSettings.temp_source
      }
    };
    return result;
  }

  /**
   * 更新设置
   */
  public async updateSettings(newSettings: Partial<UserSettings>): Promise<void> {
    // 手动合并设置
    if (newSettings.darkMode !== undefined) {
      this.settings.darkMode = newSettings.darkMode;
    }
    if (newSettings.autoPlay !== undefined) {
      this.settings.autoPlay = newSettings.autoPlay;
    }
    if (newSettings.playMode !== undefined) {
      this.settings.playMode = newSettings.playMode;
    }
    if (newSettings.defaultQuality !== undefined) {
      this.settings.defaultQuality = newSettings.defaultQuality;
    }
    if (newSettings.volume !== undefined) {
      this.settings.volume = newSettings.volume;
    }
    if (newSettings.selectedSources !== undefined) {
      this.settings.selectedSources = newSettings.selectedSources;
    }
    await this.save();
  }

  /**
   * 获取深色模式
   */
  public getDarkMode(): boolean {
    return this.settings.darkMode;
  }

  /**
   * 设置深色模式
   */
  public async setDarkMode(enabled: boolean): Promise<void> {
    this.settings.darkMode = enabled;
    await this.save();
  }

  /**
   * 获取自动播放
   */
  public getAutoPlay(): boolean {
    return this.settings.autoPlay;
  }

  /**
   * 设置自动播放
   */
  public async setAutoPlay(enabled: boolean): Promise<void> {
    this.settings.autoPlay = enabled;
    await this.save();
  }

  /**
   * 获取播放模式
   */
  public getPlayMode(): 'loop' | 'random' | 'single' {
    return this.settings.playMode;
  }

  /**
   * 设置播放模式
   */
  public async setPlayMode(mode: 'loop' | 'random' | 'single'): Promise<void> {
    this.settings.playMode = mode;
    await this.save();
  }

  /**
   * 获取默认音质
   */
  public getDefaultQuality(): '128' | '192' | '320' | 'flac' {
    return this.settings.defaultQuality;
  }

  /**
   * 设置默认音质
   */
  public async setDefaultQuality(quality: '128' | '192' | '320' | 'flac'): Promise<void> {
    this.settings.defaultQuality = quality;
    await this.save();
  }

  /**
   * 获取音量
   */
  public getVolume(): number {
    return this.settings.volume;
  }

  /**
   * 设置音量
   */
  public async setVolume(volume: number): Promise<void> {
    this.settings.volume = Math.max(0, Math.min(100, volume));
    await this.save();
  }

  /**
   * 获取选中的音源
   */
  public getSelectedSources(): string[] {
    return [...this.settings.selectedSources];
  }

  /**
   * 设置选中的音源
   */
  public async setSelectedSources(sources: string[]): Promise<void> {
    this.settings.selectedSources = [...sources];
    await this.save();
  }

  /**
   * 添加音源
   */
  public async addSource(source: string): Promise<void> {
    if (!this.settings.selectedSources.includes(source)) {
      this.settings.selectedSources.push(source);
      await this.save();
    }
  }

  /**
   * 移除音源
   */
  public async removeSource(source: string): Promise<void> {
    this.settings.selectedSources = this.settings.selectedSources.filter(s => s !== source);
    await this.save();
  }

  /**
   * 重置所有设置
   */
  public async reset(): Promise<void> {
    this.settings = DEFAULT_SETTINGS;
    await this.save();
  }

  /**
   * 获取搜索设置
   */
  public getSearchSettings(): SearchSettings {
    return {
      type: this.settings.searchSettings.type,
      source: this.settings.searchSettings.source,
      temp_source: this.settings.searchSettings.temp_source
    };
  }

  /**
   * 保存搜索设置
   */
  public async saveSearchSettings(settings: Partial<SearchSettings>): Promise<void> {
    if (settings.type !== undefined) {
      this.settings.searchSettings.type = settings.type;
    }
    if (settings.source !== undefined) {
      this.settings.searchSettings.source = settings.source;
    }
    if (settings.temp_source !== undefined) {
      this.settings.searchSettings.temp_source = settings.temp_source;
    }
    await this.save();
  }

  /**
   * 获取搜索历史
   */
  public async getSearchHistory(): Promise<string[]> {
    try {
      const history = await storage.get('search_history');
      if (typeof history === 'string' && history) {
        return JSON.parse(history);
      }
      if (Array.isArray(history)) {
        return history as string[];
      }
      return [];
    } catch (error) {
      console.error('Get search history failed:', error);
      return [];
    }
  }

  /**
   * 保存搜索历史
   */
  public async saveSearchHistory(history: string[]): Promise<void> {
    try {
      await storage.set('search_history', JSON.stringify(history));
    } catch (error) {
      console.error('Save search history failed:', error);
    }
  }

  /**
   * 清空搜索历史
   */
  public async clearSearchHistory(): Promise<void> {
    try {
      await storage.set('search_history', JSON.stringify([]));
    } catch (error) {
      console.error('Clear search history failed:', error);
    }
  }
}

/**
 * 导出单例实例
 */
export const settingManager = SettingManager.getInstance();
