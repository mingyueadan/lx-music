/**
 * LX Music HarmonyOS 应用入口 - 简化版本
 */

import { settingManager } from './utils/SettingManager';
import { storage } from './utils/StorageUtil';
import { playerService } from './services/PlayerService';

/**
 * 应用主入口
 */
@Entry
@Component
struct LXMusicApp {
  @State isInitialized: boolean = false;
  @State initMessage: string = '正在初始化...';

  /**
   * 应用启动
   */
  async aboutToAppear(): Promise<void> {
    console.log('LX Music HarmonyOS starting...');
    
    try {
      // 初始化存储
      this.initMessage = '初始化存储...';
      await storage.init(this.getUIContext());
      
      // 初始化设置
      this.initMessage = '加载用户设置...';
      await settingManager.init();
      
      // 初始化播放器
      this.initMessage = '初始化播放器...';
      await playerService.init();
      
      this.isInitialized = true;
      console.log('LX Music HarmonyOS started successfully');
    } catch (error) {
      console.error('LX Music initialization failed:', error);
      this.initMessage = '初始化失败，请重试';
      // 即使初始化失败也显示主页面
      setTimeout(() => {
        this.isInitialized = true;
      }, 1000);
    }
  }

  /**
   * 构建页面
   */
  build() {
    if (!this.isInitialized) {
      // 启动页
      this.buildSplashScreen()
    } else {
      // 主应用
      MainPage()
    }
  }

  /**
   * 构建启动页
   */
  @Builder
  buildSplashScreen() {
    Column() {
      Text('洛雪音乐')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 100 })

      Text('HarmonyOS 版本')
        .fontSize(16)
        .fontColor('#999999')
        .margin({ top: 8 })

      LoadingProgress()
        .width(40)
        .height(40)
        .margin({ top: 40 })

      Text(this.initMessage)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
  }
}

/**
 * 主页面组件
 */
@Component
struct MainPage {
  build() {
    Navigation() {
      HomePage()
    }
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
  }
}

/**
 * 导出首页组件
 */
export { HomePage } from './pages/HomePage';
