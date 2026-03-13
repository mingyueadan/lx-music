/**
 * 对话框组件
 */
@Component
export struct AppDialog {
  @Prop title: string = ''
  @Prop content: string = ''
  @Prop show: boolean = false
  @Prop confirmText: string = '确定'
  @Prop cancelText: string = '取消'
  @Prop showCancel: boolean = true
  onConfirm?: () => void
  onCancel?: () => void

  build() {
    if (this.show) {
      Stack() {
        // 背景遮罩
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0, 0, 0, 0.5)')
          .onClick(() => {
            this.onCancel?.()
          })

        // 对话框内容
        Column() {
          // 标题
          if (this.title) {
            Text(this.title)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#000000')
              .margin({ bottom: 12 })
          }

          // 内容
          Text(this.content)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 24 })

          // 按钮组
          Row() {
            if (this.showCancel) {
              Button(this.cancelText)
                .fontSize(14)
                .fontColor('#666666')
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
                .layoutWeight(1)
                .margin({ right: 12 })
                .onClick(() => {
                  this.onCancel?.()
                })
            }

            Button(this.confirmText)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor(ThemeConfig.Colors.primary)
              .borderRadius(8)
              .layoutWeight(this.showCancel ? 1 : 2)
              .onClick(() => {
                this.onConfirm?.()
              })
          }
          .width('100%')
        }
        .width('80%')
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
    }
  }
}
