/**
 * 空状态组件
 */
@Component
export struct EmptyState {
  @Prop icon: string = '📭'
  @Prop message: string = '暂无数据'
  @Prop description: string = ''
  @Prop actionText: string = ''
  @Prop showAction: boolean = false
  onAction?: () => void

  build() {
    Column() {
      // 图标
      Text(this.icon)
        .fontSize(64)
        .margin({ bottom: 16 })

      // 提示文字
      Text(this.message)
        .fontSize(16)
        .fontColor('#999999')
        .margin({ bottom: 8 })

      // 描述文字
      if (this.description) {
        Text(this.description)
          .fontSize(14)
          .fontColor('#CCCCCC')
          .margin({ bottom: 24 })
      }

      // 操作按钮
      if (this.showAction && this.actionText) {
        Button(this.actionText)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor(ThemeConfig.Colors.primary)
          .borderRadius(8)
          .padding({ left: 24, right: 24 })
          .onClick(() => {
            this.onAction?.()
          })
      }
    }
    .width('100%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
