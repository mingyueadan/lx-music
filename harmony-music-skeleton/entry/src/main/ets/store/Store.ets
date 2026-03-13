import { PlayerService } from '../services/PlayerService'
import { SettingService } from '../services/SettingService'
import { UserService } from '../services/UserService'

/**
 * 全局状态管理
 */
export class Store {
  static readonly player = PlayerService.getInstance()
  static readonly setting = SettingService.getInstance()
  static readonly user = UserService.getInstance()

  /**
   * 初始化所有服务
   */
  static async init(): Promise<void> {
    try {
      console.log('[Store] 开始初始化服务')

      // 初始化设置服务
      await this.setting.init()
      console.log('[Store] 设置服务初始化完成')

      // 初始化用户服务
      await this.user.init()
      console.log('[Store] 用户服务初始化完成')

      // 初始化播放器服务
      await this.player.init()
      console.log('[Store] 播放器服务初始化完成')

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
