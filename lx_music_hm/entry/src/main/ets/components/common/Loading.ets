/**
 * 加载中组件
 */
@Component
export struct Loading {
  @State message: string = '加载中...'

  build() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color(ThemeConfig.Colors.primary)

      Text(this.message)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 12 })
    }
    .width('100%')
    .height(120)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
