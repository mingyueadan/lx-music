/**
 * 音乐列表组件
 */
@Component
export struct MusicList {
  @Prop musicList: MusicInfo[] = []
  @Prop showIndex: boolean = true
  @Prop currentMusicId: string = ''
  onMusicClick?: (music: MusicInfo, index: number) => void
  onMoreClick?: (music: MusicInfo) => void

  build() {
    if (this.musicList.length === 0) {
      // 空状态
      Column() {
        Text('暂无数据')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else {
      // 音乐列表
      List() {
        ForEach(this.musicList, (music: MusicInfo, index: number) => {
          ListItem() {
            this.MusicListItem(music, index)
          }
        }, (music: MusicInfo, index: number) => `${music.songId || index}`)
      }
      .width('100%')
      .height('100%')
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Auto)
      .divider({ strokeWidth: 1, color: 'rgba(0, 0, 0, 0.05)' })
    }
  }

  @Builder MusicListItem(music: MusicInfo, index: number) {
    Row() {
      // 序号或播放图标
      if (this.showIndex) {
        if (music.songId === this.currentMusicId) {
          Text('🎵')
            .fontSize(16)
            .width(30)
        } else {
          Text(`${index + 1}`)
            .fontSize(14)
            .fontColor('#999999')
            .width(30)
        }
      }

      // 歌曲信息
      Column() {
        Text(music.songname || '未知歌曲')
          .fontSize(15)
          .fontWeight(music.songId === this.currentMusicId ? FontWeight.Medium : FontWeight.Regular)
          .fontColor(music.songId === this.currentMusicId ? ThemeConfig.Colors.primary : '#000000')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(`${music.singername || '未知歌手'} - ${music.albumname || '未知专辑'}`)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })

      // 更多按钮
      Button() {
        Text('⋯')
          .fontSize(20)
          .fontColor('#999999')
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width(40)
      .height(40)
      .onClick(() => {
        this.onMoreClick?.(music)
      })
    }
    .width('100%')
    .padding({ left: 16, right: 8, top: 12, bottom: 12 })
    .onClick(() => {
      this.onMusicClick?.(music, index)
    })
  }
}
