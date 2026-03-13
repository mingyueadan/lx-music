import router from '@ohos.router'
import { Store } from '../store/Store'
import { PlayerService } from '../services/PlayerService'
import { MusicModel } from '../models/MusicModel'

@Entry
@Component
export struct HomePage {
  @State isPlaying: boolean = false
  @State currentMusic: MusicModel | null = null

  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear(): void {
    // 订阅播放器状态变化
    this.playerService.on('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.on('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })

    // 初始化状态
    this.isPlaying = this.playerService.isPlaying
    this.currentMusic = this.playerService.currentMusic
  }

  aboutToDisappear(): void {
    // 取消订阅
    this.playerService.off('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.off('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })
  }

  private navigateToPlayer(): void {
    router.pushUrl({
      url: 'pages/PlayerPage'
    })
  }

  private navigateToSearch(): void {
    router.pushUrl({
      url: 'pages/SearchPage'
    })
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('音乐播放器')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .justifyContent(FlexAlign.Center)

      // 主要内容区域
      Column() {
        Text('欢迎使用音乐播放器')
          .fontSize(20)
          .margin({ top: 100 })

        if (this.currentMusic) {
          Column() {
            Text('正在播放:')
              .fontSize(16)
              .margin({ top: 20 })

            Text(this.currentMusic.name)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8 })

            Text(this.currentMusic.singer)
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 4 })
          }
          .margin({ top: 40 })
        }

        // 功能按钮
        Row() {
          Button('搜索音乐')
            .onClick(() => {
              this.navigateToSearch()
            })

          if (this.currentMusic) {
            Button('播放器')
              .onClick(() => {
                this.navigateToPlayer()
              })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ top: 60 })
      }
      .layoutWeight(1)

      // 底部播放栏
      if (this.currentMusic) {
        Row() {
          Column() {
            Text(this.currentMusic.name)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .maxLines(1)

            Text(this.currentMusic.singer)
              .fontSize(12)
              .fontColor('#999999')
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Button(this.isPlaying ? '暂停' : '播放')
            .onClick(() => {
              if (this.isPlaying) {
                this.playerService.pauseMusic()
              } else {
                this.playerService.resumeMusic()
              }
            })
        }
        .width('100%')
        .height(60)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
