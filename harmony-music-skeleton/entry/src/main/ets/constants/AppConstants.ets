/**
 * 应用常量定义
 */
export class AppConstants {
  // 应用信息
  static readonly APP_NAME = '音乐播放器'
  static readonly APP_VERSION = '1.0.0'

  // 路由路径
  static readonly ROUTES = {
    HOME: 'pages/HomePage',
    PLAYER: 'pages/PlayerPage',
    SEARCH: 'pages/SearchPage',
    SETTING: 'pages/SettingPage',
    PLAYLIST: 'pages/PlaylistPage'
  }

  // 存储键
  static readonly STORAGE_KEYS = {
    THEME: 'theme',
    VOLUME: 'volume',
    PLAY_MODE: 'playMode',
    USER_INFO: 'userInfo',
    PLAYLISTS: 'playlists',
    FAVORITES: 'favorites'
  }

  // API配置
  static readonly API = {
    BASE_URL: 'https://api.example.com',
    TIMEOUT: 10000,
    MAX_RETRY: 3
  }

  // 播放器配置
  static readonly PLAYER = {
    DEFAULT_VOLUME: 0.8,
    MIN_VOLUME: 0.0,
    MAX_VOLUME: 1.0,
    BUFFER_SIZE: 1024 * 1024, // 1MB
    PRELOAD_COUNT: 3
  }

  // 缓存配置
  static readonly CACHE = {
    EXPIRE_TIME: 5 * 60 * 1000, // 5分钟
    MAX_SIZE: 100 * 1024 * 1024 // 100MB
  }
}
