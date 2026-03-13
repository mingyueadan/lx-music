/**
 * 进度条组件
 */
@Component
export struct Progress {
  @Prop progress: number = 0 // 当前进度 0-1
  @Prop duration: number = 0 // 总时长(秒)
  @Prop showTime: boolean = true // 是否显示时间
  @Prop editable: boolean = true // 是否可拖动
  onSeek?: (progress: number) => void

  @State currentProgress: number = 0
  @State isDragging: boolean = false

  aboutToAppear(): void {
    this.currentProgress = this.progress
  }

  build() {
    Column() {
      // 进度条
      Row() {
        // 进度背景
        Stack({ alignContent: Alignment.Start }) {
          // 背景槽
          Row()
            .width('100%')
            .height(4)
            .backgroundColor('rgba(0, 0, 0, 0.1)')
            .borderRadius(2)

          // 进度条
          Row()
            .width(`${this.currentProgress * 100}%`)
            .height(4)
            .backgroundColor(ThemeConfig.Colors.primary)
            .borderRadius(2)

          // 拖动滑块
          if (this.editable) {
            Circle()
              .width(12)
              .height(12)
              .fill(ThemeConfig.Colors.primary)
              .position({ x: `${this.currentProgress * 100}%` })
              .translate({ x: -6, y: 0 })
          }
        }
        .width('100%')
        .height(12)
        .margin({ right: this.showTime ? 12 : 0 })
        .onClick((event: ClickEvent) => {
          if (this.editable && this.duration > 0) {
            const rect = event.target as ComponentUtils.Component
            const x = event.x
            const width = rect.area.width
            const newProgress = Math.max(0, Math.min(1, x / width))
            this.currentProgress = newProgress
            this.onSeek?.(newProgress)
          }
        })
      }
      .width('100%')

      // 时间显示
      if (this.showTime) {
        Row() {
          Text(this.formatTime(this.currentProgress * this.duration))
            .fontSize(12)
            .fontColor('#999999')

          Blank()

          Text(this.formatTime(this.duration))
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ top: 4 })
      }
    }
    .width('100%')
  }

  private formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }
}
