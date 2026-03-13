/**
 * 应用事件类型定义
 */
export enum AppEventType {
  THEME_CHANGED = 'themeChanged',
  LANGUAGE_CHANGED = 'languageChanged',
  SETTINGS_CHANGED = 'settingsChanged',
}

/**
 * 应用事件数据接口
 */
export interface AppEventData {
  theme?: string
  language?: string
  settings?: Object
}
