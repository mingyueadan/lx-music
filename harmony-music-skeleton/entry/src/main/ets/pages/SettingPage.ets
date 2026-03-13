import router from '@ohos.router'
import { Store } from '../store/Store'
import { SettingService } from '../services/SettingService'

@Entry
@Component
export struct SettingPage {
  @State theme: string = 'light'
  @State volume: number = 0.8

  private settingService: SettingService = SettingService.getInstance()

  aboutToAppear(): void {
    // 订阅设置变化
    this.settingService.on('themeChanged', (theme: string) => {
      this.theme = theme
    })

    this.settingService.on('volumeChanged', (volume: number) => {
      this.volume = volume
    })

    // 初始化状态
    this.theme = this.settingService.theme
    this.volume = this.settingService.volume
  }

  aboutToDisappear(): void {
    // 取消订阅
    this.settingService.off('themeChanged', (theme: string) => {
      this.theme = theme
    })

    this.settingService.off('volumeChanged', (volume: number) => {
      this.volume = volume
    })
  }

  private handleThemeChange(theme: string): void {
    this.settingService.theme = theme
  }

  private handleVolumeChange(value: number): void {
    this.settingService.volume = value
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('返回')
          .onClick(() => {
            router.back()
          })

        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })

      // 设置列表
      Column() {
        // 主题设置
        Column() {
          Text('主题')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 16 })

          Row() {
            Text('浅色')
              .fontSize(14)

            Radio({ value: 'light', group: 'theme' })
              .checked(this.theme === 'light')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.handleThemeChange('light')
                }
              })
              .margin({ left: 8 })

            Text('深色')
              .fontSize(14)
              .margin({ left: 16 })

            Radio({ value: 'dark', group: 'theme' })
              .checked(this.theme === 'dark')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.handleThemeChange('dark')
                }
              })
              .margin({ left: 8 })
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ top: 16 })

        // 音量设置
        Column() {
          Text('音量')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 16 })

          Slider({
            value: this.volume * 100,
            min: 0,
            max: 100
          })
            .blockColor('#4CAF50')
            .trackColor('#E0E0E0')
            .selectedColor('#4CAF50')
            .showSteps(false)
            .onChange((value: number) => {
              this.handleVolumeChange(value / 100)
            })

          Text(`${Math.round(this.volume * 100)}%`)
            .fontSize(14)
            .fontColor('#999999')
            .textAlign(TextAlign.Center)
            .width('100%')
            .margin({ top: 8 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ top: 16 })

        // 关于
        Column() {
          Text('关于')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 16 })

          Text('音乐播放器 v1.0.0')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ top: 16 })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
