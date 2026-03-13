import preferences from '@ohos.data.preferences'

/**
 * 存储服务
 * 统一管理应用数据持久化
 */
export class StorageService {
  private static instance: StorageService
  private preferences: preferences.Preferences | null = null

  private constructor() {
  }

  static getInstance(): StorageService {
    if (!StorageService.instance) {
      StorageService.instance = new StorageService()
    }
    return StorageService.instance
  }

  /**
   * 初始化存储服务
   */
  async init(context: Context): Promise<void> {
    try {
      this.preferences = await preferences.getPreferences(context, 'lx_music_hm_store')
      console.log('[StorageService] 初始化成功')
    } catch (error) {
      console.error('[StorageService] 初始化失败:', error)
      throw error
    }
  }

  /**
   * 保存数据
   * @param key 键
   * @param value 值
   */
  async put(key: string, value: preferences.ValueType): Promise<void> {
    if (!this.preferences) {
      console.error('[StorageService] 存储未初始化')
      return
    }

    try {
      await this.preferences.put(key, value)
      await this.preferences.flush()
      console.log(`[StorageService] 保存数据成功: ${key}`)
    } catch (error) {
      console.error('[StorageService] 保存数据失败:', error)
      throw error
    }
  }

  /**
   * 获取数据
   * @param key 键
   * @param defaultValue 默认值
   */
  async get(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {
    if (!this.preferences) {
      console.error('[StorageService] 存储未初始化')
      return defaultValue
    }

    try {
      const value = await this.preferences.get(key, defaultValue)
      console.log(`[StorageService] 获取数据成功: ${key}`)
      return value
    } catch (error) {
      console.error('[StorageService] 获取数据失败:', error)
      return defaultValue
    }
  }

  /**
   * 删除数据
   * @param key 键
   */
  async delete(key: string): Promise<void> {
    if (!this.preferences) {
      console.error('[StorageService] 存储未初始化')
      return
    }

    try {
      await this.preferences.delete(key)
      await this.preferences.flush()
      console.log(`[StorageService] 删除数据成功: ${key}`)
    } catch (error) {
      console.error('[StorageService] 删除数据失败:', error)
      throw error
    }
  }

  /**
   * 清空所有数据
   */
  async clear(): Promise<void> {
    if (!this.preferences) {
      console.error('[StorageService] 存储未初始化')
      return
    }

    try {
      await this.preferences.clear()
      await this.preferences.flush()
      console.log('[StorageService] 清空数据成功')
    } catch (error) {
      console.error('[StorageService] 清空数据失败:', error)
      throw error
    }
  }

  /**
   * 检查键是否存在
   * @param key 键
   */
  async has(key: string): Promise<boolean> {
    if (!this.preferences) {
      console.error('[StorageService] 存储未初始化')
      return false
    }

    try {
      return await this.preferences.has(key)
    } catch (error) {
      console.error('[StorageService] 检查键失败:', error)
      return false
    }
  }
}
