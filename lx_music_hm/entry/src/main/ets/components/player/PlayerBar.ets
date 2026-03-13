/**
 * 播放器底部控制栏组件
 */
@Component
export struct PlayerBar {
  @State isPlaying: boolean = false
  @State progress: number = 0
  @State currentMusic: MusicInfo | null = null
  @State currentTime: string = '00:00'
  @State totalTime: string = '00:00'

  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear(): void {
    // 订阅播放器状态变化
    this.playerService.on(PlayerEventType.PLAY_STATE_CHANGED, (data: PlayerEventData) => {
      this.isPlaying = data.isPlaying || false
    })

    this.playerService.on(PlayerEventType.MUSIC_CHANGED, (data: PlayerEventData) => {
      this.currentMusic = data.music as MusicInfo
    })

    this.playerService.on(PlayerEventType.PROGRESS_CHANGED, (data: PlayerEventData) => {
      this.progress = data.progress || 0
      this.currentTime = this.formatTime(this.progress)
    })

    // 初始化状态
    this.isPlaying = this.playerService.isPlaying
    this.currentMusic = this.playerService.currentMusic
    this.progress = this.playerService.progress
    this.currentTime = this.formatTime(this.progress)
    this.totalTime = this.formatTime(this.playerService.duration)
  }

  aboutToDisappear(): void {
    // 取消订阅
    this.playerService.off(PlayerEventType.PLAY_STATE_CHANGED)
    this.playerService.off(PlayerEventType.MUSIC_CHANGED)
    this.playerService.off(PlayerEventType.PROGRESS_CHANGED)
  }

  private formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  private handlePlayPause(): void {
    if (this.isPlaying) {
      this.playerService.pause()
    } else {
      this.playerService.play()
    }
  }

  build() {
    Row() {
      // 缩略图
      Image(this.currentMusic?.img || '')
        .width(48)
        .height(48)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
        .backgroundColor('#F5F5F5')

      // 歌曲信息
      Column() {
        Text(this.currentMusic?.songname || '暂无播放')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.currentMusic?.singername || '')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 2 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })

      // 播放控制
      Button(this.isPlaying ? '暂停' : '播放')
        .fontSize(12)
        .onClick(() => {
          this.handlePlayPause()
        })
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 16, topRight: 16 })
    .shadow({ radius: 8, color: 'rgba(0, 0, 0, 0.1)' })
  }
}
