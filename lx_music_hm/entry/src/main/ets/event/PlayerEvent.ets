/**
 * 播放器事件类型定义
 */
export enum PlayerEventType {
  PLAY_STATE_CHANGED = 'playStateChanged',
  MUSIC_CHANGED = 'musicChanged',
  PROGRESS_CHANGED = 'progressChanged',
  VOLUME_CHANGED = 'volumeChanged',
  PLAY_MODE_CHANGED = 'playModeChanged',
  PLAYLIST_CHANGED = 'playlistChanged',
  ERROR = 'error',
}

/**
 * 播放器事件数据接口
 */
export interface PlayerEventData {
  isPlaying?: boolean
  music?: Object
  progress?: number
  volume?: number
  playMode?: string
  error?: Error
}
