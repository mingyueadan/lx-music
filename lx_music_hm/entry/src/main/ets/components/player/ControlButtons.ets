/**
 * 播放控制按钮组组件
 */
@Component
export struct ControlButtons {
  @State playMode: string = 'loop' // 播放模式: loop, random, single
  @State isPlaying: boolean = false
  @State isList: boolean = false

  onPlayModeChange?: (mode: string) => void
  onPrevious?: () => void
  onPlayPause?: () => void
  onNext?: () => void
  onListToggle?: () => void

  build() {
    Row() {
      // 播放模式按钮
      Button() {
        Text(this.getPlayModeIcon())
          .fontSize(20)
          .fontColor('#666666')
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .onClick(() => {
        this.cyclePlayMode()
      })

      Blank()

      // 上一首按钮
      Button() {
        Text('⏮')
          .fontSize(24)
          .fontColor('#666666')
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(48)
      .height(48)
      .onClick(() => {
        this.onPrevious?.()
      })

      // 播放/暂停按钮
      Button() {
        Text(this.isPlaying ? '⏸' : '▶')
          .fontSize(32)
          .fontColor('#FFFFFF')
      }
      .type(ButtonType.Circle)
      .backgroundColor(ThemeConfig.Colors.primary)
      .width(64)
      .height(64)
      .onClick(() => {
        this.onPlayPause?.()
      })

      // 下一首按钮
      Button() {
        Text('⏭')
          .fontSize(24)
          .fontColor('#666666')
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(48)
      .height(48)
      .onClick(() => {
        this.onNext?.()
      })

      Blank()

      // 播放列表按钮
      Button() {
        Text('📋')
          .fontSize(20)
          .fontColor('#666666')
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .onClick(() => {
        this.onListToggle?.()
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }

  // 获取播放模式图标
  private getPlayModeIcon(): string {
    switch (this.playMode) {
      case 'loop':
        return '🔁'
      case 'random':
        return '🔀'
      case 'single':
        return '🔂'
      default:
        return '🔁'
    }
  }

  // 切换播放模式
  private cyclePlayMode(): void {
    const modes = ['loop', 'random', 'single']
    const currentIndex = modes.indexOf(this.playMode)
    const nextIndex = (currentIndex + 1) % modes.length
    this.playMode = modes[nextIndex]
    this.onPlayModeChange?.(this.playMode)
  }
}
