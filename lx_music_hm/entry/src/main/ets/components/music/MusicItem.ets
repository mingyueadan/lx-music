/**
 * 音乐列表项组件
 */
@Component
export struct MusicItem {
  @Prop music: MusicInfo
  @Prop index: number = 0
  @Prop showIndex: boolean = true
  onClick?: (music: MusicInfo) => void

  build() {
    Row() {
      if (this.showIndex) {
        Text(`${this.index + 1}`)
          .fontSize(14)
          .fontColor('#999999')
          .width(30)
      }

      Column() {
        Text(this.music.songname || '未知歌曲')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(`${this.music.singername || '未知歌手'} - ${this.music.albumname || '未知专辑'}`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .onClick(() => {
      this.onClick?.(this.music)
    })
  }
}
