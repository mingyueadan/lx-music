/**
 * HarmonyOS 存储工具
 * 基于 @ohos.data.preferences 实现
 */

import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

/**
 * 存储工具类
 */
export class StorageUtil {
  private static instance: StorageUtil;
  private preferences: preferences.Preferences | null = null;
  private storeName: string = 'lx_music_store';

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): StorageUtil {
    if (!StorageUtil.instance) {
      StorageUtil.instance = new StorageUtil();
    }
    return StorageUtil.instance;
  }

  /**
   * 初始化存储
   */
  public async init(context: common.UIAbilityContext): Promise<void> {
    try {
      this.preferences = await preferences.getPreferences(context, this.storeName);
    } catch (error) {
      console.error('StorageUtil init failed:', error);
      throw new Error('StorageUtil init failed');
    }
  }

  /**
   * 存储数据
   */
  public async set(key: string, value: string | number | boolean): Promise<void> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      await this.preferences.put(key, value);
      await this.preferences.flush();
    } catch (error) {
      console.error(`StorageUtil set failed for key ${key}:`, error);
      throw new Error(`StorageUtil set failed for key ${key}`);
    }
  }

  /**
   * 获取数据
   */
  public async get(key: string, defaultValue?: preferences.ValueType): Promise<preferences.ValueType | undefined> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      return await this.preferences.get(key, defaultValue);
    } catch (error) {
      console.error(`StorageUtil get failed for key ${key}:`, error);
      return defaultValue;
    }
  }

  /**
   * 删除数据
   */
  public async remove(key: string): Promise<void> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      await this.preferences.delete(key);
      await this.preferences.flush();
    } catch (error) {
      console.error(`StorageUtil remove failed for key ${key}:`, error);
      throw new Error(`StorageUtil remove failed for key ${key}`);
    }
  }

  /**
   * 清空所有数据
   */
  public async clear(): Promise<void> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      await this.preferences.clear();
      await this.preferences.flush();
    } catch (error) {
      console.error('StorageUtil clear failed:', error);
      throw new Error('StorageUtil clear failed');
    }
  }

  /**
   * 存储对象（JSON 序列化）
   */
  public async setObject<T>(key: string, value: T): Promise<void> {
    try {
      const jsonStr = JSON.stringify(value);
      await this.preferences?.put(key, jsonStr);
      await this.preferences?.flush();
    } catch (error) {
      console.error(`StorageUtil setObject failed for key ${key}:`, error);
      throw new Error(`StorageUtil setObject failed for key ${key}`);
    }
  }

  /**
   * 获取对象（JSON 反序列化）
   */
  public async getObject<T>(key: string, defaultValue?: T): Promise<T | undefined> {
    try {
      const jsonStr = await this.preferences?.get(key, '');
      if (jsonStr && typeof jsonStr === 'string') {
        return JSON.parse(jsonStr) as T;
      }
      return defaultValue;
    } catch (error) {
      console.error(`StorageUtil getObject failed for key ${key}:`, error);
      return defaultValue;
    }
  }

  /**
   * 检查键是否存在
   */
  public async has(key: string): Promise<boolean> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      return await this.preferences.has(key);
    } catch (error) {
      console.error(`StorageUtil has failed for key ${key}:`, error);
      return false;
    }
  }

  /**
   * 获取所有键
   */
  public async getAll(): Promise<preferences.Preferences> {
    if (!this.preferences) {
      throw new Error('StorageUtil not initialized');
    }
    try {
      return this.preferences;
    } catch (error) {
      console.error('StorageUtil getAll failed:', error);
      return this.preferences;
    }
  }
}

/**
 * 导出单例实例
 */
export const storage = StorageUtil.getInstance();
