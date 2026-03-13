/**
 * 音乐数据模型
 */
export class MusicModel {
  id: string
  name: string
  singer: string
  album: string
  duration: number
  url: string
  picUrl: string

  constructor(data: Partial<MusicModel> = {}) {
    this.id = data.id || ''
    this.name = data.name || ''
    this.singer = data.singer || ''
    this.album = data.album || ''
    this.duration = data.duration || 0
    this.url = data.url || ''
    this.picUrl = data.picUrl || ''
  }

  /**
   * 获取格式化的时长
   */
  getFormattedDuration(): string {
    const mins = Math.floor(this.duration / 60)
    const secs = Math.floor(this.duration % 60)
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  /**
   * 转换为JSON对象
   */
  toJSON(): Object {
    return {
      id: this.id,
      name: this.name,
      singer: this.singer,
      album: this.album,
      duration: this.duration,
      url: this.url,
      picUrl: this.picUrl
    }
  }

  /**
   * 从JSON对象创建
   */
  static fromJSON(json: any): MusicModel {
    return new MusicModel(json)
  }
}

/**
 * 播放模式枚举
 */
export enum PlayMode {
  LIST_LOOP = 'listLoop',
  RANDOM = 'random',
  SINGLE_LOOP = 'singleLoop',
  SEQUENTIAL = 'sequential'
}
