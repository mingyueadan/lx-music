import { EventEmitter } from '../event/EventEmitter'
import { preferences } from '@kit.ArkData'

/**
 * 设置服务
 */
export class SettingService extends EventEmitter {
  private static instance: SettingService
  private prefs: preferences.Preferences | null = null

  private _theme: string = 'light'
  private _volume: number = 0.8
  private _playMode: string = 'listLoop'

  private constructor() {
    super()
  }

  static getInstance(): SettingService {
    if (!SettingService.instance) {
      SettingService.instance = new SettingService()
    }
    return SettingService.instance
  }

  /**
   * 初始化设置服务
   */
  async init(): Promise<void> {
    try {
      this.prefs = await preferences.getPreferences(getContext(), 'settings')
      await this.loadSettings()
      console.log('[SettingService] 初始化完成')
    } catch (error) {
      console.error('[SettingService] 初始化失败:', error)
      throw error
    }
  }

  /**
   * 加载设置
   */
  private async loadSettings(): Promise<void> {
    if (!this.prefs) return

    this._theme = await this.prefs.get('theme', 'light') as string
    this._volume = await this.prefs.get('volume', 0.8) as number
    this._playMode = await this.prefs.get('playMode', 'listLoop') as string

    console.log('[SettingService] 加载设置:', {
      theme: this._theme,
      volume: this._volume,
      playMode: this._playMode
    })
  }

  /**
   * 保存设置
   */
  private async saveSetting(key: string, value: any): Promise<void> {
    if (!this.prefs) return
    await this.prefs.put(key, value)
    await this.prefs.flush()
  }

  // Getters and Setters
  get theme(): string {
    return this._theme
  }

  set theme(value: string) {
    if (this._theme !== value) {
      this._theme = value
      this.saveSetting('theme', value)
      this.emit('themeChanged', value)
      console.log('[SettingService] 主题变更:', value)
    }
  }

  get volume(): number {
    return this._volume
  }

  set volume(value: number) {
    if (this._volume !== value) {
      this._volume = value
      this.saveSetting('volume', value)
      this.emit('volumeChanged', value)
      console.log('[SettingService] 音量变更:', value)
    }
  }

  get playMode(): string {
    return this._playMode
  }

  set playMode(value: string) {
    if (this._playMode !== value) {
      this._playMode = value
      this.saveSetting('playMode', value)
      this.emit('playModeChanged', value)
      console.log('[SettingService] 播放模式变更:', value)
    }
  }
}
