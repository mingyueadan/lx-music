import { PlayerService } from '../services/PlayerService'
import { SettingManager } from '../utils/SettingManager'
import { MusicService } from '../services/MusicService'
import { StorageService } from '../services/StorageService'
import { NetworkService } from '../services/NetworkService'

/**
 * 全局状态管理
 * 统一管理所有服务的单例实例
 */
export class Store {
  static readonly player = PlayerService.getInstance()
  static readonly setting = SettingManager.getInstance()
  static readonly music = MusicService.getInstance()
  static readonly storage = StorageService.getInstance()
  static readonly network = NetworkService.getInstance()

  /**
   * 初始化所有服务
   */
  static async init(context?: Context): Promise<void> {
    try {
      console.log('[Store] 开始初始化服务')

      // 初始化播放器服务
      await this.player.init()
      console.log('[Store] 播放器服务初始化完成')

      // 初始化设置服务
      await this.setting.init()
      console.log('[Store] 设置服务初始化完成')

      // 初始化存储服务
      if (context) {
        await this.storage.init(context)
        console.log('[Store] 存储服务初始化完成')
      }

      console.log('[Store] 所有服务初始化完成')
    } catch (error) {
      console.error('[Store] 初始化失败:', error)
      throw error
    }
  }

  /**
   * 清理所有服务
   */
  static async cleanup(): Promise<void> {
    try {
      console.log('[Store] 开始清理服务')

      await this.player.release()
      console.log('[Store] 播放器服务清理完成')

      console.log('[Store] 所有服务清理完成')
    } catch (error) {
      console.error('[Store] 清理失败:', error)
    }
  }
}
