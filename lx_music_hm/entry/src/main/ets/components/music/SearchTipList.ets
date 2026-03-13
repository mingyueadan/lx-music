/**
 * 搜索提示列表组件
 */
@Component
export struct SearchTipList {
  @Prop tips: string[] = []
  @Prop keyword: string = ''
  onTipClick?: (tip: string) => void

  build() {
    if (this.tips.length === 0) {
      Column() {
        Text('暂无搜索建议')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .height(100)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else {
      List() {
        ForEach(this.tips, (tip: string, index: number) => {
          ListItem() {
            Row() {
              // 搜索图标
              Text('🔍')
                .fontSize(16)
                .margin({ right: 8 })

              // 提示文本
              Text(this.highlightKeyword(tip))
                .fontSize(14)
                .fontColor('#666666')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .layoutWeight(1)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          }
          .onClick(() => {
            this.onTipClick?.(tip)
          })
        }, (tip: string, index: number) => `${index}_${tip}`)
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Auto)
      .divider({ strokeWidth: 1, color: 'rgba(0, 0, 0, 0.05)' })
    }
  }

  // 高亮关键词
  private highlightKeyword(text: string): string {
    if (!this.keyword || this.keyword.trim() === '') {
      return text
    }
    return text
  }
}
