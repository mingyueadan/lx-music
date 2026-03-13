/**
 * 卡片组件
 */
@Component
export struct Card {
  @Prop padding: number = 16
  @Prop margin: number = 0
  @Prop borderRadius: number = 12
  @Prop elevation: number = 2
  @Prop backgroundColor: ResourceColor = '#FFFFFF'

  build() {
    Column() {
      this.contentBuilder()
    }
    .width('100%')
    .padding(this.padding)
    .margin(this.margin)
    .backgroundColor(this.backgroundColor)
    .borderRadius(this.borderRadius)
    .shadow({
      radius: this.elevation,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder contentBuilder() {
    // 子组件内容
  }
}
