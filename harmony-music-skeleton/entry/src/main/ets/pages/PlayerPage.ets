import router from '@ohos.router'
import { Store } from '../store/Store'
import { PlayerService } from '../services/PlayerService'
import { MusicModel } from '../models/MusicModel'

@Entry
@Component
export struct PlayerPage {
  @State isPlaying: boolean = false
  @State progress: number = 0
  @State duration: number = 0
  @State currentMusic: MusicModel | null = null

  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear(): void {
    // 订阅播放器状态变化
    this.playerService.on('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.on('progressChanged', (progress: number) => {
      this.progress = progress
    })

    this.playerService.on('durationChanged', (duration: number) => {
      this.duration = duration
    })

    this.playerService.on('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })

    // 初始化状态
    this.isPlaying = this.playerService.isPlaying
    this.progress = this.playerService.progress
    this.duration = this.playerService.duration
    this.currentMusic = this.playerService.currentMusic
  }

  aboutToDisappear(): void {
    // 取消订阅
    this.playerService.off('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.off('progressChanged', (progress: number) => {
      this.progress = progress
    })

    this.playerService.off('durationChanged', (duration: number) => {
      this.duration = duration
    })

    this.playerService.off('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })
  }

  private handlePlayPause(): void {
    if (this.isPlaying) {
      this.playerService.pauseMusic()
    } else {
      this.playerService.resumeMusic()
    }
  }

  private handlePrevious(): void {
    this.playerService.previousMusic()
  }

  private handleNext(): void {
    this.playerService.nextMusic()
  }

  private handleSeek(value: number): void {
    this.playerService.seekTo(value)
  }

  private formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  build() {
    Column() {
      // 返回按钮
      Row() {
        Button('返回')
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')
      .padding(16)

      // 专辑封面
      if (this.currentMusic?.picUrl) {
        Image(this.currentMusic.picUrl)
          .width(300)
          .height(300)
          .borderRadius(16)
          .margin({ top: 40 })
      } else {
        Image($r('app.media.icon'))
          .width(300)
          .height(300)
          .borderRadius(16)
          .margin({ top: 40 })
      }

      // 歌曲信息
      Column() {
        Text(this.currentMusic?.name || '暂无播放')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)

        Text(this.currentMusic?.singer || '')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 8 })
          .maxLines(1)
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .margin({ top: 40 })

      // 进度条
      Column() {
        Slider({
          value: this.progress,
          min: 0,
          max: this.duration > 0 ? this.duration : 100
        })
          .blockColor('#4CAF50')
          .trackColor('#E0E0E0')
          .selectedColor('#4CAF50')
          .showSteps(false)
          .onChange((value: number) => {
            this.handleSeek(value)
          })

        Row() {
          Text(this.formatTime(this.progress))
          Text(this.formatTime(this.duration))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 8 })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .margin({ top: 40 })

      // 控制按钮
      Row() {
        Button('上一首')
          .onClick(() => {
            this.handlePrevious()
          })

        Button(this.isPlaying ? '暂停' : '播放')
          .width(80)
          .height(80)
          .borderRadius(40)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            this.handlePlayPause()
          })

        Button('下一首')
          .onClick(() => {
            this.handleNext()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ top: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
