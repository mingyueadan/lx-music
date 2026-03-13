import UIAbility from '@ohos.app.ability.UIAbility'
import window from '@ohos.window'
import { Store } from '../store/Store'

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // 初始化应用状态
    await Store.init()
  }

  onDestroy(): void {
    // 清理资源
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // 设置主窗口
    windowStage.loadContent('pages/HomePage', (err) => {
      if (err.code) {
        return
      }
    })
  }

  onWindowStageDestroy(): void {
    // 主窗口销毁
  }

  onForeground(): void {
    // 应用前台
  }

  onBackground(): void {
    // 应用后台
  }
}
