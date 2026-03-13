/**
 * 歌词视图组件
 */
@Component
export struct LyricView {
  @Prop lyrics: LyricLine[] = [] // 歌词列表
  @Prop currentTime: number = 0 // 当前播放时间(秒)
  @State currentIndex: number = 0 // 当前歌词索引

  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.updateCurrentIndex()
  }

  // 更新当前歌词索引
  updateCurrentIndex(): void {
    let index = 0
    for (let i = 0; i < this.lyrics.length; i++) {
      if (this.currentTime >= this.lyrics[i].time) {
        index = i
      } else {
        break
      }
    }
    this.currentIndex = index

    // 滚动到当前歌词
    if (this.lyrics.length > 0) {
      this.scroller.scrollToIndex(index, true)
    }
  }

  build() {
    if (this.lyrics.length === 0) {
      // 无歌词时显示提示
      Column() {
        Text('暂无歌词')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else {
      // 歌词列表
      List({ scroller: this.scroller }) {
        ForEach(this.lyrics, (item: LyricLine, index: number) => {
          ListItem() {
            Text(item.text)
              .fontSize(index === this.currentIndex ? 16 : 14)
              .fontColor(index === this.currentIndex ? ThemeConfig.Colors.primary : '#999999')
              .fontWeight(index === this.currentIndex ? FontWeight.Medium : FontWeight.Regular)
              .textAlign(TextAlign.Center)
              .width('100%')
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
          }
        }, (item: LyricLine, index: number) => `${index}_${item.time}`)
      }
      .width('100%')
      .height(300)
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .alignListItem(ListItemAlign.Center)
      .clip(true)
    }
  }
}

/**
 * 歌词行数据结构
 */
export interface LyricLine {
  time: number // 时间(秒)
  text: string // 歌词文本
}
