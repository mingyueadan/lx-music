/**
 * 设置页面
 * 对应 React Native 版本的 Setting 页面
 */

import { settingManager, UserSettings } from '../utils/SettingManager';
import { SettingManager } from '../utils/SettingManager';
import { SearchType } from '../types/Music';

/**
 * 设置项接口
 */
interface SettingItem {
  id: string;
  title: string;
  value: string | number;
  displayValue?: string;
  type: 'switch' | 'select' | 'slider' | 'info' | 'link' | 'action';
  checked?: boolean;
  options?: string[];
  min?: number;
  max?: number;
  action?: string;
  icon?: string;
}

/**
 * 设置页面组件
 */
@Component
export struct SettingPage {
  @State settings: UserSettings = {
    darkMode: false,
    autoPlay: true,
    playMode: 'loop',
    defaultQuality: '320',
    volume: 80,
    selectedSources: ['wy', 'tx'],
    searchSettings: {
      type: SearchType.MUSIC,
      source: 'wy',
      temp_source: 'wy'
    }
  };
  @State isLoading: boolean = true;
  @State searchHistory: string[] = [];
  @State isShowHistory: boolean = true;
  @State isShowHotSearch: boolean = true;

  /**
   * 页面初始化
   */
  async aboutToAppear(): Promise<void> {
    try {
      await settingManager.init();
      this.settings = settingManager.getSettings();
      this.searchHistory = await settingManager.getSearchHistory();
      this.isLoading = false;
    } catch (error) {
      console.error('SettingPage init failed:', error);
      this.isLoading = false;
    }
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .margin({ top: 40 })

          Text('正在加载设置...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 16 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 0 }) {
            // 播放设置
            this.buildPlayerSettings()

            // 搜索设置
            this.buildSearchSettings()

            // 音源设置
            this.buildSourceSettings()

            // 界面设置
            this.buildUISettings()

            // 列表设置
            this.buildListSettings()

            // 数据管理
            this.buildDataManagement()

            // 关于
            this.buildAbout()
          }
          .padding({ left: 16, right: 16, top: 16, bottom: 32 })
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建播放设置
   */
  @Builder
  buildPlayerSettings() {
    Column({ space: 0 }) {
      Text('播放设置')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'autoPlay',
          title: '自动播放',
          value: this.settings.autoPlay ? '已开启' : '已关闭',
          type: 'switch',
          checked: this.settings.autoPlay
        })
        this.buildSettingItem({
          id: 'playMode',
          title: '播放模式',
          value: this.getPlayModeName(),
          type: 'select',
          options: ['循环播放', '随机播放', '单曲循环']
        })
        this.buildSettingItem({
          id: 'defaultQuality',
          title: '默认音质',
          value: this.getQualityName(),
          type: 'select',
          options: ['128k', '192k', '320k', 'FLAC']
        })
        this.buildSettingItem({
          id: 'volume',
          title: '音量',
          displayValue: `${this.settings.volume}%`,
          type: 'slider',
          min: 0,
          max: 100,
          value: this.settings.volume
        })
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建搜索设置
   */
  @Builder
  buildSearchSettings() {
    Column({ space: 0 }) {
      Text('搜索设置')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'searchType',
          title: '搜索类型',
          value: this.settings.searchSettings.type === 'music' ? '音乐' : '歌单',
          type: 'select',
          options: ['音乐', '歌单']
        })
        this.buildSettingItem({
          id: 'showHistory',
          title: '显示搜索历史',
          value: this.isShowHistory ? '已开启' : '已关闭',
          type: 'switch',
          checked: this.isShowHistory
        })
        this.buildSettingItem({
          id: 'showHotSearch',
          title: '显示热搜',
          value: this.isShowHotSearch ? '已开启' : '已关闭',
          type: 'switch',
          checked: this.isShowHotSearch
        })
        this.buildSettingItem({
          id: 'clearHistory',
          title: '清空搜索历史',
          value: '',
          type: 'action',
          action: '清空'
        })
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建音源设置
   */
  @Builder
  buildSourceSettings() {
    Column({ space: 0 }) {
      Text('音源设置')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSourceItem('wy', '网易云音乐', this.settings.selectedSources.includes('wy'))
        this.buildSourceItem('tx', '腾讯音乐', this.settings.selectedSources.includes('tx'))
        this.buildSourceItem('kg', '酷狗音乐', this.settings.selectedSources.includes('kg'))
        this.buildSourceItem('kw', '酷我音乐', this.settings.selectedSources.includes('kw'))
        this.buildSourceItem('mg', '咪咕音乐', this.settings.selectedSources.includes('mg'))
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建界面设置
   */
  @Builder
  buildUISettings() {
    Column({ space: 0 }) {
      Text('界面设置')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'darkMode',
          title: '深色模式',
          value: this.settings.darkMode ? '已开启' : '已关闭',
          type: 'switch',
          checked: this.settings.darkMode
        })
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建列表设置
   */
  @Builder
  buildListSettings() {
    Column({ space: 0 }) {
      Text('列表设置')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'clickPlay',
          title: '点击播放',
          value: '已开启',
          type: 'switch',
          checked: true
        })
        this.buildSettingItem({
          id: 'showAlbum',
          title: '显示专辑名',
          value: '已开启',
          type: 'switch',
          checked: true
        })
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建数据管理
   */
  @Builder
  buildDataManagement() {
    Column({ space: 0 }) {
      Text('数据管理')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'clearCache',
          title: '清除缓存',
          value: '',
          type: 'action',
          action: '清除'
        })
        this.buildSettingItem({
          id: 'resetSettings',
          title: '重置设置',
          value: '',
          type: 'action',
          action: '重置'
        })
      }

      Divider()
        .color('#E0E0E0')
        .margin({ top: 8 })
    }
    .width('100%')
  }

  /**
   * 构建关于
   */
  @Builder
  buildAbout() {
    Column({ space: 0 }) {
      Text('关于')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 24, bottom: 8 })
        .width('100%')

      Column({ space: 1 }) {
        this.buildSettingItem({
          id: 'version',
          title: '版本信息',
          value: 'v1.0.0',
          type: 'info'
        })
        this.buildSettingItem({
          id: 'license',
          title: '开源协议',
          value: 'MIT',
          type: 'info'
        })
        this.buildSettingItem({
          id: 'github',
          title: '项目地址',
          value: 'GitHub',
          type: 'link'
        })
      }
    }
    .width('100%')
  }

  /**
   * 构建音源项
   */
  @Builder
  buildSourceItem(source: string, name: string, enabled: boolean) {
    Row() {
      Text('🎵')
        .fontSize(24)
        .margin({ right: 12 })

      Text(name)
        .fontSize(16)
        .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: enabled })
        .onChange((isOn: boolean) => {
          this.onSourceChange(source, isOn);
        })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
  }

  /**
   * 构建设置项
   */
  @Builder
  buildSettingItem(item: SettingItem) {
    Row() {
      if (item.icon) {
        Image($r(`sys.media.${item.icon}`))
          .width(24)
          .height(24)
          .margin({ right: 12 })
          .fillColor('#FF6B6B')
      }

      Text(item.title)
        .fontSize(16)
        .layoutWeight(1)

      if (item.type === 'switch') {
        Toggle({ type: ToggleType.Switch, isOn: item.checked })
          .onChange((isOn: boolean) => {
            this.onSettingChange(item.id, isOn);
          })
      } else if (item.type === 'slider') {
        Slider({
          value: item.value as number,
          min: item.min,
          max: item.max,
          style: SliderStyle.OutSet
        })
          .width(120)
          .blockColor('#FF6B6B')
          .trackColor('#E0E0E0')
          .selectedColor('#FF6B6B')
          .onChange((value: number) => {
            this.onSliderChange(item.id, value);
          })
      } else if (item.type === 'action') {
        Button(item.action)
          .fontSize(14)
          .fontColor('#FF6B6B')
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (item.action) {
              this.onActionClick(item.id, item.action);
            }
          })
      } else if (item.type === 'link') {
        Row() {
          Text(item.value ? item.value.toString() : '')
            .fontSize(14)
            .fontColor('#FF6B6B')

          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(16)
            .height(16)
            .margin({ left: 8 })
            .fillColor('#CCCCCC')
        }
      } else {
        Text(item.displayValue || item.value.toString())
          .fontSize(14)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
  }

  /**
   * 处理音源变化
   */
  private async onSourceChange(source: string, enabled: boolean): Promise<void> {
    if (enabled) {
      await settingManager.addSource(source);
    } else {
      await settingManager.removeSource(source);
    }
    this.settings.selectedSources = settingManager.getSelectedSources();
  }

  /**
   * 处理设置变化
   */
  private async onSettingChange(id: string, value: boolean): Promise<void> {
    switch (id) {
      case 'autoPlay':
        await settingManager.setAutoPlay(value);
        this.settings.autoPlay = value;
        break;
      case 'darkMode':
        await settingManager.setDarkMode(value);
        this.settings.darkMode = value;
        break;
      case 'showHistory':
        this.isShowHistory = value;
        break;
      case 'showHotSearch':
        this.isShowHotSearch = value;
        break;
      case 'clickPlay':
      case 'showAlbum':
        // TODO: 实现列表设置
        break;
    }
  }

  /**
   * 处理滑块变化
   */
  private async onSliderChange(id: string, value: number): Promise<void> {
    if (id === 'volume') {
      await settingManager.setVolume(value);
      this.settings.volume = value;
    }
  }

  /**
   * 处理操作点击
   */
  private async onActionClick(id: string, action: string): Promise<void> {
    switch (id) {
      case 'clearHistory':
        await settingManager.clearSearchHistory();
        this.searchHistory = [];
        break;
      case 'clearCache':
        // TODO: 实现清除缓存
        console.log('Clear cache');
        break;
      case 'resetSettings':
        await settingManager.reset();
        this.settings = settingManager.getSettings();
        break;
    }
  }

  /**
   * 获取播放模式名称
   */
  private getPlayModeName(): string {
    const modeMap: Record<string, string> = {
      'loop': '循环播放',
      'random': '随机播放',
      'single': '单曲循环'
    };
    return modeMap[this.settings.playMode] || '循环播放';
  }

  /**
   * 获取音质名称
   */
  private getQualityName(): string {
    return this.settings.defaultQuality;
  }
}
