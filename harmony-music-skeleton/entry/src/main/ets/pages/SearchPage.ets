import router from '@ohos.router'
import { MusicModel } from '../models/MusicModel'

@Entry
@Component
export struct SearchPage {
  @State searchKeyword: string = ''
  @State searchResults: MusicModel[] = []
  @State isSearching: boolean = false

  private async searchMusic(): Promise<void> {
    if (!this.searchKeyword.trim()) return

    this.isSearching = true

    try {
      // TODO: 实际搜索逻辑
      console.log('搜索:', this.searchKeyword)

      // 模拟搜索结果
      await new Promise(resolve => setTimeout(resolve, 1000))

      this.searchResults = []
    } catch (error) {
      console.error('搜索失败:', error)
    } finally {
      this.isSearching = false
    }
  }

  private handleMusicClick(music: MusicModel): void {
    router.pushUrl({
      url: 'pages/PlayerPage',
      params: {
        musicId: music.id
      }
    })
  }

  build() {
    Column() {
      // 搜索栏
      Row() {
        Button('返回')
          .onClick(() => {
            router.back()
          })

        TextInput({ placeholder: '搜索音乐、歌手、专辑' })
          .layoutWeight(1)
          .margin({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.searchKeyword = value
          })

        Button('搜索')
          .onClick(() => {
            this.searchMusic()
          })
      }
      .width('100%')
      .height(60)
      .padding(16)

      // 搜索结果
      if (this.isSearching) {
        Text('搜索中...')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 20 })
      } else if (this.searchResults.length === 0) {
        Text('暂无搜索结果')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 20 })
      } else {
        List() {
          ForEach(this.searchResults, (music: MusicModel, index: number) => {
            ListItem() {
              Row() {
                if (music.picUrl) {
                  Image(music.picUrl)
                    .width(60)
                    .height(60)
                    .borderRadius(8)
                    .margin({ right: 16 })
                }

                Column() {
                  Text(music.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)

                  Text(music.singer)
                    .fontSize(14)
                    .fontColor('#999999')
                    .margin({ top: 4 })
                    .maxLines(1)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Text(music.getFormattedDuration())
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .height(80)
              .padding({ left: 16, right: 16 })
              .onClick(() => {
                this.handleMusicClick(music)
              })
            }
          }, (music: MusicModel) => music.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: '#E0E0E0',
          startMargin: 16,
          endMargin: 16
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
