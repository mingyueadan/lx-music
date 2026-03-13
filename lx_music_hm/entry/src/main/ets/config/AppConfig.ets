/**
 * 应用配置类
 * 统一管理应用的配置参数
 */
export class AppConfig {
  // API配置
  static readonly API_BASE_URL = 'https://api.example.com'
  static readonly API_TIMEOUT = 15000
  static readonly MAX_RETRY_COUNT = 3
  static readonly CACHE_EXPIRE_TIME = 5 * 60 * 1000 // 5分钟

  // 播放器配置
  static readonly PLAYER = {
    DEFAULT_VOLUME: 0.8,
    MAX_VOLUME: 1.0,
    MIN_VOLUME: 0.0,
    BUFFER_SIZE: 1024 * 1024, // 1MB
    PRELOAD_COUNT: 3,
  }

  // 缓存配置
  static readonly CACHE = {
    MUSIC_CACHE_SIZE: 200 * 1024 * 1024, // 200MB
    IMAGE_CACHE_SIZE: 50 * 1024 * 1024, // 50MB
    EXPIRE_TIME: 7 * 24 * 60 * 60 * 1000, // 7天
  }

  // 主题配置
  static readonly THEME = {
    DEFAULT_THEME: 'light',
    SUPPORTED_THEMES: ['light', 'dark', 'auto'],
  }

  // 分页配置
  static readonly PAGINATION = {
    DEFAULT_PAGE_SIZE: 20,
    MAX_PAGE_SIZE: 100,
  }

  // 音乐质量配置
  static readonly MUSIC_QUALITY = {
    LOW: '128k',
    STANDARD: '320k',
    HIGH: 'flac',
    HIRES: 'flac24bit',
  }

  // 播放模式配置
  static readonly PLAY_MODE = {
    LOOP: 'loop',
    RANDOM: 'random',
    SINGLE: 'single',
  }
}
