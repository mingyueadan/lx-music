# LX Music HarmonyOS

洛雪音乐 HarmonyOS 版本 - 基于 HarmonyOS NEXT 开发的音乐播放应用。

## 项目简介

本项目是 lx-music-mobile（React Native 版本）的 HarmonyOS 移植版本，实现了音乐搜索、播放、榜单、我的列表等核心功能。

## 技术栈

- **开发框架**: HarmonyOS NEXT
- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **播放器**: AVPlayer (@ohos.multimedia.media)
- **存储**: Preferences (@ohos.data.preferences)

## 项目结构

```
lx_music_hm/
├── entry/src/main/ets/
│   ├── pages/                    # 页面组件
│   │   ├── HomePage.ets          # 主页面（搜索、热搜）
│   │   ├── MyListPage.ets        # 我的列表
│   │   ├── LeaderboardPage.ets   # 榜单页面
│   │   ├── SettingPage.ets       # 设置页面
│   │   ├── PlayerDetailPage.ets  # 播放详情
│   │   └── SongListDetailPage.ets # 歌曲列表详情
│   ├── components/               # 公共组件
│   │   └── PlayerControlBar.ets  # 播放器控制栏
│   ├── types/                     # 类型定义
│   │   └── Music.d.ts             # 音乐相关类型
│   ├── utils/                     # 工具类
│   │   ├── StorageUtil.ets        # 存储工具
│   │   ├── SettingManager.ets     # 设置管理器
│   │   └── RequestUtil.ets        # 网络请求工具
│   └── services/                  # 服务层
│       ├── PlayerService.ets      # 播放器服务
│       └── musicSdk/              # 音乐SDK
│           ├── MusicSdkBase.ets   # SDK基类
│           ├── WangYiMusicSdk.ets # 网易云SDK
│           └── TencentMusicSdk.ets # 腾讯SDK
└── resources/                     # 资源文件
```

## 主要功能

### 已实现功能

- ✅ **搜索功能**: 热搜展示、关键词搜索
- ✅ **榜单页面**: 热歌榜、新歌榜、原创榜等
- ✅ **我的列表**: 用户收藏的歌单
- ✅ **设置页面**: 音源管理、播放设置、界面设置
- ✅ **播放器**: 基于AVPlayer的音乐播放功能
- ✅ **播放控制**: 播放/暂停、上一首、下一首、进度控制
- ✅ **数据持久化**: 用户设置的保存和读取

### 待完善功能

- ⏳ **真实API对接**: 实现真实的音乐API调用
- ⏳ **歌词显示**: 完善播放详情页的歌词功能
- ⏳ **下载功能**: 音乐下载管理
- ⏳ **更多音源**: 完善酷狗、酷我、咪咕等SDK

## 开发说明

### 编译运行

1. 使用 DevEco Studio 打开项目
2. 连接 HarmonyOS 设备或启动模拟器
3. 点击运行按钮编译并安装应用

### 依赖权限

需要在 `module.json5` 中配置以下权限：

```json5
{
  "requestPermissions": [
    {
      "name": "ohos.permission.INTERNET"
    }
  ]
}
```

## 架构说明

### 播放器服务 (PlayerService)

播放器服务是应用的核心组件，负责：

- 管理播放列表和当前播放状态
- 提供播放、暂停、停止、跳转等控制接口
- 监听播放器状态变化并通知UI更新
- 基于 HarmonyOS AVPlayer 实现

### 设置管理器 (SettingManager)

设置管理器统一管理用户设置：

- 播放设置（自动播放、播放模式、音质、音量）
- 音源设置（网易云、腾讯、酷狗等）
- 界面设置（深色模式）
- 支持设置持久化存储

### 音乐SDK (MusicSDK)

音乐SDK提供统一的音乐服务接口：

- 基类 `MusicSdkBase` 定义通用接口
- 各音源SDK（网易云、腾讯等）继承基类实现具体功能
- 支持搜索、榜单、歌曲详情、歌词等功能

## 许可证

MIT

## 致谢

感谢 [lx-music-mobile](https://github.com/lyswhut/lx-music-mobile) 项目提供的原始实现。
