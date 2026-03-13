# 鸿蒙音乐应用开发规范

> 基于 lx-music-mobile 项目架构制定的鸿蒙应用开发规范

## 目录

1. [项目结构规范](#1-项目结构规范)
2. [技术栈选择](#2-技术栈选择)
3. [代码组织规范](#3-代码组织规范)
4. [命名规范](#4-命名规范)
5. [状态管理规范](#5-状态管理规范)
6. [路由管理规范](#6-路由管理规范)
7. [样式规范](#7-样式规范)
8. [资源管理规范](#8-资源管理规范)
9. [性能优化规范](#9-性能优化规范)
10. [错误处理规范](#10-错误处理规范)
11. [测试规范](#11-测试规范)
12. [文档规范](#12-文档规范)
13. [版本管理规范](#13-版本管理规范)
14. [最佳实践](#14-最佳实践)

---

## 1. 项目结构规范

### 1.1 推荐的项目结构

```
harmony-music/
├── entry/                          # 主模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/                # ArkTS源代码
│   │   │   │   ├── entryability/   # 应用入口
│   │   │   │   │   └── EntryAbility.ets
│   │   │   │   ├── pages/          # 页面组件
│   │   │   │   │   ├── HomePage.ets
│   │   │   │   │   ├── PlayerPage.ets
│   │   │   │   │   ├── SearchPage.ets
│   │   │   │   │   └── SettingPage.ets
│   │   │   │   ├── components/     # 公共组件
│   │   │   │   │   ├── common/     # 通用组件
│   │   │   │   │   │   ├── Button.ets
│   │   │   │   │   │   ├── Text.ets
│   │   │   │   │   │   ├── Input.ets
│   │   │   │   │   │   ├── Dialog.ets
│   │   │   │   │   │   └── Modal.ets
│   │   │   │   │   ├── player/     # 播放器组件
│   │   │   │   │   │   ├── PlayerBar.ets
│   │   │   │   │   │   ├── Progress.ets
│   │   │   │   │   │   ├── LyricView.ets
│   │   │   │   │   │   └── ControlButtons.ets
│   │   │   │   │   └── music/      # 音乐组件
│   │   │   │   │       ├── MusicItem.ets
│   │   │   │   │       ├── MusicList.ets
│   │   │   │   │       └── SearchTipList.ets
│   │   │   │   ├── services/       # 服务层
│   │   │   │   │   ├── MusicService.ets
│   │   │   │   │   ├── PlayerService.ets
│   │   │   │   │   ├── StorageService.ets
│   │   │   │   │   ├── NetworkService.ets
│   │   │   │   │   └── SyncService.ets
│   │   │   │   ├── utils/          # 工具函数
│   │   │   │   │   ├── commonUtils.ets
│   │   │   │   │   ├── dateUtils.ets
│   │   │   │   │   ├── fileUtils.ets
│   │   │   │   │   └── requestUtils.ets
│   │   │   │   ├── models/         # 数据模型
│   │   │   │   │   ├── MusicModel.ets
│   │   │   │   │   ├── PlayListModel.ets
│   │   │   │   │   └── UserModel.ets
│   │   │   │   ├── constants/      # 常量定义
│   │   │   │   │   ├── AppConstants.ets
│   │   │   │   │   ├── StorageConstants.ets
│   │   │   │   │   └── PlayerConstants.ets
│   │   │   │   ├── config/         # 配置文件
│   │   │   │   │   ├── AppConfig.ets
│   │   │   │   │   └── ThemeConfig.ets
│   │   │   │   ├── event/          # 事件系统
│   │   │   │   │   ├── EventEmitter.ets
│   │   │   │   │   ├── AppEvent.ets
│   │   │   │   │   └── PlayerEvent.ets
│   │   │   │   └── plugins/        # 插件系统
│   │   │   │       ├── LyricPlugin.ets
│   │   │   │       ├── StoragePlugin.ets
│   │   │   │       └── SyncPlugin.ets
│   │   │   └── resources/          # 资源文件
│   │   │       ├── base/
│   │   │       │   ├── element/
│   │   │       │   │   ├── string.json
│   │   │       │   │   ├── color.json
│   │   │       │   │   └── float.json
│   │   │       │   ├── media/
│   │   │       │   │   ├── icon.png
│   │   │       │   │   └── background.png
│   │   │       │   └── profile/
│   │   │       │       └── main_pages.json
│   │   │       ├── zh_CN/          # 中文资源
│   │   │       │   └── element/
│   │   │       │       └── string.json
│   │   │       └── en_US/          # 英文资源
│   │   │           └── element/
│   │   │               └── string.json
│   │   └── ohosTest/               # 测试代码
│   │       └── ets/
│   │           └── test/
│   │               └── MusicService.test.ets
│   ├── build-profile.json5        # 构建配置
│   └── module.json5               # 模块配置
├── oh_modules/                     # 依赖模块
├── build-profile.json5            # 项目构建配置
├── hvigorfile.ts                  # 构建脚本
├── oh-package.json5               # 项目依赖配置
└── README.md                      # 项目说明
```

### 1.2 目录组织原则

- **按功能模块划分**: 将相关功能的代码放在同一目录下
- **分层清晰**: pages、components、services、utils、models各司其职
- **可扩展性**: 预留扩展空间,便于后续功能添加
- **资源本地化**: 支持多语言资源文件

### 1.3 多模块项目结构

对于大型项目,推荐使用多模块架构:

```
harmony-music/
├── entry/                          # 主模块(应用入口)
├── features/                       # 功能模块
│   ├── player/                     # 播放器功能模块
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── ets/
│   │   │   │   │   ├── pages/
│   │   │   │   │   ├── components/
│   │   │   │   │   ├── services/
│   │   │   │   │   └── models/
│   │   │   │   └── resources/
│   │   │   └── ohosTest/
│   │   ├── build-profile.json5
│   │   └── module.json5
│   ├── search/                     # 搜索功能模块
│   │   └── ...
│   ├── user/                       # 用户功能模块
│   │   └── ...
│   └── sync/                       # 同步功能模块
│       └── ...
├── common/                         # 公共模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/
│   │   │   │   ├── components/     # 公共组件
│   │   │   │   ├── services/       # 公共服务
│   │   │   │   ├── utils/          # 公共工具
│   │   │   │   ├── models/         # 公共模型
│   │   │   │   ├── constants/      # 公共常量
│   │   │   │   ├── config/         # 公共配置
│   │   │   │   └── event/          # 事件系统
│   │   │   └── resources/
│   │   └── ohosTest/
│   ├── build-profile.json5
│   └── module.json5
├── oh_modules/
├── build-profile.json5
├── hvigorfile.ts
└── oh-package.json5
```

### 1.4 模块间依赖规范

- **单向依赖**: 功能模块可以依赖公共模块,但不能相互依赖
- **接口隔离**: 模块间通过接口通信,降低耦合度
- **依赖注入**: 使用依赖注入管理模块间的依赖关系
- **版本管理**: 模块版本号需要同步更新

---

## 2. 技术栈选择

### 2.1 核心框架

| 技术 | 版本 | 用途 |
|------|------|------|
| ArkTS | 最新版 | 主要开发语言 |
| ArkUI | 最新版 | UI框架 |
| Stage模型 | - | 应用开发模型 |

### 2.2 主要依赖库

#### 网络请求
```typescript
// oh-package.json5
{
  "dependencies": {
    "@ohos/axios": "^2.2.0"
  }
}
```

#### 数据存储
```typescript
{
  "dependencies": {
    "@ohos/datastore": "^1.0.0",
    "@ohos/preferences": "^1.0.0"
  }
}
```

#### 媒体播放
```typescript
{
  "dependencies": {
    "@ohos/multimedia.media": "^1.0.0",
    "@ohos/multimedia.audio": "^1.0.0"
  }
}
```

#### 工具库
```typescript
{
  "dependencies": {
    "@ohos/crypto-js": "^4.1.1",
    "@ohos/zlib": "^1.0.0",
    "@ohos/pinyin": "^1.0.0"
  }
}
```

### 2.3 开发环境要求

- **DevEco Studio**: 4.0+
- **Node.js**: 16.x+
- **HarmonyOS SDK**: API 9+
- **HarmonyOS设备/模拟器**: API 9+

### 2.4 完整依赖配置示例

```json5
// oh-package.json5
{
  "name": "harmony-music",
  "version": "1.0.0",
  "description": "鸿蒙音乐播放器应用",
  "main": "",
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    // 网络请求
    "@ohos/axios": "^2.2.0",

    // 数据存储
    "@ohos/datastore": "^1.0.0",
    "@ohos/preferences": "^1.0.0",
    "@ohos/fileio": "^1.0.0",

    // 媒体播放
    "@ohos/multimedia.media": "^1.0.0",
    "@ohos/multimedia.audio": "^1.0.0",

    // 工具库
    "@ohos/crypto-js": "^4.1.1",
    "@ohos/zlib": "^1.0.0",
    "@ohos/pinyin": "^1.0.0",
    "@ohos/lottie": "^1.0.0",

    // UI组件
    "@ohos/swiper": "^1.0.0",
    "@ohos/pulltorefresh": "^1.0.0",

    // 其他
    "@ohos/common": "^1.0.0",
    "jsencrypt": "^3.3.2"
  },
  "devDependencies": {
    "@ohos/hypium": "1.0.6",
    "@ohos/hamock": "1.0.0"
  }
}
```

### 2.5 构建配置示例

```json5
// build-profile.json5
{
  "apiType": "stageMode",
  "buildOption": {
    "externalNativeOptions": {
      "path": "./src/main/cpp/CMakeLists.txt",
      "arguments": "",
      "cppFlags": "",
      "abiFilters": [
        "armeabi-v7a",
        "arm64-v8a"
      ]
    },
    "arkOptions": {
      "obfuscation": {
        "ruleOptions": {
          "enable": true,
          "files": [
            "./obfuscation-rules.txt"
          ]
        }
      }
    }
  },
  "targets": [
    {
      "name": "default",
      "runtimeOS": "HarmonyOS"
    }
  ]
}
```

### 2.6 技术选型原则

#### 2.6.1 框架选择
- **优先使用官方组件**: 使用ArkUI官方提供的组件,保证兼容性和性能
- **避免过度封装**: 不对基础组件进行过度封装,保持代码简洁
- **考虑性能**: 选择性能优秀的第三方库

#### 2.6.2 依赖管理
- **最小化依赖**: 只引入必要的依赖,减少包体积
- **版本锁定**: 锁定依赖版本,避免不兼容问题
- **定期更新**: 定期更新依赖,修复安全漏洞

#### 2.6.3 兼容性考虑
- **API版本**: 确保兼容HarmonyOS API 9+
- **设备适配**: 支持手机、平板等不同设备
- **系统版本**: 兼容HarmonyOS 3.0及以上版本

---

## 3. 代码组织规范

### 3.1 组件组织

#### 基础组件
```typescript
// components/common/Button.ets
@Component
export struct Button {
  @Prop title: string = ''
  @Prop type: 'primary' | 'secondary' | 'danger' = 'primary'
  @Prop disabled: boolean = false
  onClick?: () => void

  build() {
    Button(this.title)
      .type(ButtonType.Normal)
      .enabled(!this.disabled)
      .onClick(() => {
        this.onClick?.()
      })
  }
}
```

#### 业务组件
```typescript
// components/player/PlayerBar.ets
@Component
export struct PlayerBar {
  @State isPlaying: boolean = false
  @State progress: number = 0
  @State currentTime: string = '00:00'
  @State totalTime: string = '00:00'

  build() {
    Row() {
      // 播放控制UI
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
  }
}
```

### 3.2 服务层组织

```typescript
// services/MusicService.ets
import { http } from '@kit.NetworkKit'
import { MusicModel } from '../models/MusicModel'

/**
 * 音乐服务类
 * 负责音乐搜索、信息获取等业务逻辑
 */
export class MusicService {
  private static instance: MusicService
  private readonly baseUrl = 'https://api.example.com'

  private constructor() {}

  static getInstance(): MusicService {
    if (!MusicService.instance) {
      MusicService.instance = new MusicService()
    }
    return MusicService.instance
  }

  /**
   * 搜索音乐
   * @param keyword 搜索关键词
   * @param page 页码
   * @param limit 每页数量
   * @returns 音乐列表
   */
  async searchMusic(keyword: string, page: number = 1, limit: number = 20): Promise<MusicModel[]> {
    const url = `${this.baseUrl}/search`
    const params = {
      keyword: keyword,
      page: page,
      limit: limit
    }

    try {
      const response = await http.createHttp().request(url, {
        method: http.RequestMethod.GET,
        extraData: params
      })

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string)
        return data.data.map((item: any) => new MusicModel(item))
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      console.error('搜索音乐失败:', error)
      throw error
    }
  }
}
```

### 3.3 工具函数组织

```typescript
// utils/commonUtils.ets
/**
 * 通用工具函数
 */
export class CommonUtils {
  /**
   * 生成随机ID
   */
  static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2)
  }

  /**
   * 格式化时间
   */
  static formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  /**
   * 防抖函数
   */
  static debounce<T extends (...args: any[]) => any>(func: T, delay: number): T {
    let timer: number
    return ((...args: any[]) => {
      clearTimeout(timer)
      timer = setTimeout(() => func(...args), delay)
    }) as T
  }
}
```

### 3.4 数据模型组织

```typescript
// models/MusicModel.ets
/**
 * 音乐数据模型
 */
export class MusicModel {
  id: string
  name: string
  singer: string
  album: string
  duration: number
  url: string
  picUrl: string

  constructor(data: Partial<MusicModel> = {}) {
    this.id = data.id || ''
    this.name = data.name || ''
    this.singer = data.singer || ''
    this.album = data.album || ''
    this.duration = data.duration || 0
    this.url = data.url || ''
    this.picUrl = data.picUrl || ''
  }

  /**
   * 获取格式化的时长
   */
  getFormattedDuration(): string {
    const mins = Math.floor(this.duration / 60)
    const secs = Math.floor(this.duration % 60)
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }
}
```

### 3.5 代码组织最佳实践

#### 3.5.1 单一职责原则
每个类/函数应该只有一个改变的理由:

```typescript
// ❌ 不推荐: 一个类承担多个职责
export class MusicManager {
  async searchMusic(keyword: string): Promise<MusicModel[]> {
    // 搜索逻辑
  }

  async playMusic(music: MusicModel): Promise<void> {
    // 播放逻辑
  }

  async saveMusic(music: MusicModel): Promise<void> {
    // 存储逻辑
  }
}

// ✅ 推荐: 拆分为多个职责单一的类
export class MusicService {
  async searchMusic(keyword: string): Promise<MusicModel[]> {
    // 搜索逻辑
  }
}

export class PlayerService {
  async playMusic(music: MusicModel): Promise<void> {
    // 播放逻辑
  }
}

export class StorageService {
  async saveMusic(music: MusicModel): Promise<void> {
    // 存储逻辑
  }
}
```

#### 3.5.2 依赖注入
使用依赖注入提高可测试性:

```typescript
// 定义接口
export interface IMusicService {
  searchMusic(keyword: string): Promise<MusicModel[]>
}

// 实现类
export class MusicService implements IMusicService {
  async searchMusic(keyword: string): Promise<MusicModel[]> {
    // 实现
  }
}

// 使用依赖注入
export class SearchViewModel {
  private musicService: IMusicService

  constructor(musicService: IMusicService) {
    this.musicService = musicService
  }

  async search(keyword: string): Promise<MusicModel[]> {
    return await this.musicService.searchMusic(keyword)
  }
}

// 在应用中注入
const musicService = new MusicService()
const searchViewModel = new SearchViewModel(musicService)
```

#### 3.5.3 错误处理
统一错误处理机制:

```typescript
// 自定义错误类
export class MusicError extends Error {
  constructor(
    message: string,
    public code: number,
    public context?: string
  ) {
    super(message)
    this.name = 'MusicError'
  }
}

// 在服务中使用
export class MusicService {
  async searchMusic(keyword: string): Promise<MusicModel[]> {
    try {
      if (!keyword || keyword.trim().length === 0) {
        throw new MusicError('搜索关键词不能为空', 400, 'MusicService.searchMusic')
      }

      // 搜索逻辑
    } catch (error) {
      if (error instanceof MusicError) {
        throw error
      }
      throw new MusicError('搜索失败', 500, 'MusicService.searchMusic')
    }
  }
}
```

#### 3.5.4 配置管理
配置与代码分离:

```typescript
// config/AppConfig.ets
export class AppConfig {
  static readonly API_BASE_URL = 'https://api.example.com'
  static readonly API_TIMEOUT = 10000
  static readonly MAX_RETRY_COUNT = 3
  static readonly CACHE_EXPIRE_TIME = 5 * 60 * 1000

  static readonly MUSIC = {
    DEFAULT_VOLUME: 0.8,
    MAX_VOLUME: 1.0,
    MIN_VOLUME: 0.0,
    SUPPORTED_FORMATS: ['mp3', 'flac', 'wav', 'm4a']
  }

  static readonly PLAYER = {
    BUFFER_SIZE: 1024 * 1024, // 1MB
    PRELOAD_COUNT: 3
  }
}

// 在代码中使用
export class MusicService {
  private readonly baseUrl = AppConfig.API_BASE_URL
  private readonly timeout = AppConfig.API_TIMEOUT

  async searchMusic(keyword: string): Promise<MusicModel[]> {
    const response = await http.createHttp().request(
      `${this.baseUrl}/search`,
      {
        method: http.RequestMethod.GET,
        connectTimeout: this.timeout
      }
    )
    // ...
  }
}
```

### 3.6 目录结构详细说明

#### 3.6.1 components目录

```
components/
├── common/                 # 通用基础组件
│   ├── Button.ets
│   ├── Text.ets
│   ├── Input.ets
│   ├── Dialog.ets
│   ├── Modal.ets
│   └── index.ets          # 统一导出
├── player/                # 播放器相关组件
│   ├── PlayerBar.ets      # 播放器底部栏
│   ├── Progress.ets       # 进度条组件
│   ├── LyricView.ets      # 歌词视图
│   ├── ControlButtons.ets # 控制按钮组
│   └── index.ets
├── music/                 # 音乐相关组件
│   ├── MusicItem.ets      # 音乐列表项
│   ├── MusicList.ets      # 音乐列表
│   ├── SearchTipList.ets  # 搜索提示列表
│   └── index.ets
└── user/                  # 用户相关组件
    ├── UserAvatar.ets     # 用户头像
    ├── UserProfile.ets    # 用户资料
    └── index.ets
```

#### 3.6.2 services目录

```
services/
├── MusicService.ets       # 音乐服务
├── PlayerService.ets      # 播放器服务
├── StorageService.ets     # 存储服务
├── NetworkService.ets     # 网络服务
├── SyncService.ets        # 同步服务
└── UserService.ets        # 用户服务
```

#### 3.6.3 utils目录

```
utils/
├── commonUtils.ets        # 通用工具
├── dateUtils.ets          # 日期工具
├── fileUtils.ets          # 文件工具
├── requestUtils.ets       # 请求工具
├── validationUtils.ets    # 验证工具
└── encryptionUtils.ets    # 加密工具
```

---

## 4. 命名规范

### 4.1 文件命名

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 组件文件 | PascalCase.ets | Button.ets, PlayerBar.ets |
| 服务文件 | PascalCaseService.ets | MusicService.ets, PlayerService.ets |
| 工具文件 | camelCaseUtils.ets | commonUtils.ets, dateUtils.ets |
| 模型文件 | PascalCaseModel.ets | MusicModel.ets, UserModel.ets |
| 常量文件 | camelCaseConstants.ets | AppConstants.ets, StorageConstants.ets |
| 配置文件 | camelCaseConfig.ets | AppConfig.ets, ThemeConfig.ets |

### 4.2 变量命名

```typescript
// 常量使用UPPER_CASE
const HEADER_HEIGHT = 42
const LIST_ITEM_HEIGHT = 54
const MAX_RETRY_COUNT = 3

// 普通变量使用camelCase
let fontSize = 15
let currentIndex = 0

const musicInfo: MusicModel = {
  id: '123',
  name: '歌曲名',
  singer: '歌手'
}

// 接口使用PascalCase
interface MusicInfo {
  id: string
  name: string
  singer: string
  album?: string
  duration: number
}

// 枚举使用PascalCase
enum PlayMode {
  LIST_LOOP = 'listLoop',
  RANDOM = 'random',
  SINGLE_LOOP = 'singleLoop',
  SEQUENTIAL = 'sequential'
}

// 类型别名使用PascalCase
type MusicList = MusicModel[]
type PlayState = 'playing' | 'paused' | 'stopped'
```

### 4.3 函数命名

```typescript
// 动词开头,camelCase
export const getRandom = (min: number, max: number): number => {
  return Math.floor(Math.random() * (max - min)) + min
}

export const getData = async<T>(key: string): Promise<T | null> => {
  // 实现
}

export const updateUserList = (list: UserList[]): void => {
  // 实现
}

// 事件处理函数使用handle前缀
const handlePress = (): void => {
  // 实现
}

const handleChange = (value: string): void => {
  // 实现
}

const handleSubmit = async(): Promise<void> => {
  // 实现
}

// 异步函数使用async前缀(可选)
const asyncLoadData = async(): Promise<void> => {
  // 实现
}

// 布尔值判断函数使用is/has/can前缀
const isValid = (value: string): boolean => {
  // 实现
}

const hasPermission = (user: User): boolean => {
  // 实现
}

const canPlay = (music: MusicModel): boolean => {
  // 实现
}
```

### 4.4 组件命名

```typescript
// 组件使用PascalCase
@Component
export struct Button {
  // 组件实现
}

@Component
export struct PlayerBar {
  // 组件实现
}

// 组件Props接口使用PascalCase + Props后缀
interface ButtonProps {
  title: string
  type?: 'primary' | 'secondary'
  disabled?: boolean
  onClick?: () => void
}

// 组件类型使用PascalCase + Type后缀
export interface BtnType {
  measure: (callback: Function) => void
}
```

---

## 5. 状态管理规范

### 5.1 状态管理模式

采用**事件驱动的状态管理模式**,参考 lx-music-mobile 的架构:

```typescript
// event/EventEmitter.ets
/**
 * 事件发射器基类
 */
export class EventEmitter {
  private listeners: Map<string, Array<(...args: any[]) => void>> = new Map()

  /**
   * 订阅事件
   */
  on(eventName: string, listener: (...args: any[]) => void): void {
    if (!this.listeners.has(eventName)) {
      this.listeners.set(eventName, [])
    }
    this.listeners.get(eventName)?.push(listener)
  }

  /**
   * 取消订阅
   */
  off(eventName: string, listener: (...args: any[]) => void): void {
    const targetListeners = this.listeners.get(eventName)
    if (!targetListeners) return
    const index = targetListeners.indexOf(listener)
    if (index >= 0) {
      targetListeners.splice(index, 1)
    }
  }

  /**
   * 触发事件
   */
  emit(eventName: string, ...args: any[]): void {
    const targetListeners = this.listeners.get(eventName)
    if (!targetListeners) return
    targetListeners.forEach(listener => {
      listener(...args)
    })
  }
}
```

### 5.2 状态管理实现

```typescript
// services/PlayerService.ets
import { EventEmitter } from '../event/EventEmitter'

/**
 * 播放器状态管理
 */
export class PlayerService extends EventEmitter {
  private static instance: PlayerService

  private _isPlaying: boolean = false
  private _currentMusic: MusicModel | null = null
  private _progress: number = 0
  private _volume: number = 1.0
  private _playMode: PlayMode = PlayMode.LIST_LOOP

  private constructor() {
    super()
  }

  static getInstance(): PlayerService {
    if (!PlayerService.instance) {
      PlayerService.instance = new PlayerService()
    }
    return PlayerService.instance
  }

  // Getter
  get isPlaying(): boolean {
    return this._isPlaying
  }

  get currentMusic(): MusicModel | null {
    return this._currentMusic
  }

  get progress(): number {
    return this._progress
  }

  // Setter with event emission
  set isPlaying(value: boolean) {
    if (this._isPlaying !== value) {
      this._isPlaying = value
      this.emit('playStateChanged', value)
    }
  }

  set currentMusic(value: MusicModel | null) {
    if (this._currentMusic !== value) {
      this._currentMusic = value
      this.emit('musicChanged', value)
    }
  }

  set progress(value: number) {
    if (this._progress !== value) {
      this._progress = value
      this.emit('progressChanged', value)
    }
  }

  /**
   * 播放音乐
   */
  async playMusic(music: MusicModel): Promise<void> {
    try {
      // 播放逻辑
      this.currentMusic = music
      this.isPlaying = true
    } catch (error) {
      console.error('播放失败:', error)
      throw error
    }
  }

  /**
   * 暂停播放
   */
  pauseMusic(): void {
    this.isPlaying = false
  }

  /**
   * 设置播放模式
   */
  setPlayMode(mode: PlayMode): void {
    this._playMode = mode
    this.emit('playModeChanged', mode)
  }
}
```

### 5.3 组件中使用状态

```typescript
// pages/PlayerPage.ets
import { PlayerService } from '../services/PlayerService'

@Entry
@Component
export struct PlayerPage {
  @State isPlaying: boolean = false
  @State progress: number = 0
  @State currentMusic: MusicModel | null = null

  private playerService: PlayerService = PlayerService.getInstance()

  aboutToAppear(): void {
    // 订阅状态变化
    this.playerService.on('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.on('progressChanged', (progress: number) => {
      this.progress = progress
    })

    this.playerService.on('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })

    // 初始化状态
    this.isPlaying = this.playerService.isPlaying
    this.progress = this.playerService.progress
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

    this.playerService.off('musicChanged', (music: MusicModel | null) => {
      this.currentMusic = music
    })
  }

  private handlePlayPause(): void {
    if (this.isPlaying) {
      this.playerService.pauseMusic()
    } else if (this.currentMusic) {
      this.playerService.playMusic(this.currentMusic)
    }
  }

  build() {
    Column() {
      Text(this.currentMusic?.name || '暂无播放')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      Text(this.currentMusic?.singer || '')
        .fontSize(16)
        .margin({ top: 8 })

      Button(this.isPlaying ? '暂停' : '播放')
        .onClick(() => {
          this.handlePlayPause()
        })
        .margin({ top: 32 })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
```

### 5.4 状态管理最佳实践

#### 5.4.1 状态持久化
将状态持久化到本地存储:

```typescript
// services/SettingService.ets
import { preferences } from '@kit.ArkData'

export class SettingService extends EventEmitter {
  private static instance: SettingService
  private prefs: preferences.Preferences | null = null

  private _theme: string = 'light'
  private _volume: number = 0.8
  private _playMode: PlayMode = PlayMode.LIST_LOOP

  private constructor() {
    super()
  }

  static getInstance(): SettingService {
    if (!SettingService.instance) {
      SettingService.instance = new SettingService()
    }
    return SettingService.instance
  }

  async init(): Promise<void> {
    this.prefs = await preferences.getPreferences(getContext(), 'settings')
    await this.loadSettings()
  }

  private async loadSettings(): Promise<void> {
    if (!this.prefs) return

    this._theme = await this.prefs.get('theme', 'light') as string
    this._volume = await this.prefs.get('volume', 0.8) as number
    this._playMode = await this.prefs.get('playMode', PlayMode.LIST_LOOP) as PlayMode
  }

  private async saveSetting(key: string, value: any): Promise<void> {
    if (!this.prefs) return
    await this.prefs.put(key, value)
    await this.prefs.flush()
  }

  get theme(): string {
    return this._theme
  }

  set theme(value: string) {
    if (this._theme !== value) {
      this._theme = value
      this.saveSetting('theme', value)
      this.emit('themeChanged', value)
    }
  }

  get volume(): number {
    return this._volume
  }

  set volume(value: number) {
    if (this._volume !== value) {
      this._volume = value
      this.saveSetting('volume', value)
      this.emit('volumeChanged', value)
    }
  }
}
```

#### 5.4.2 状态派生
从基础状态派生出计算属性:

```typescript
// services/PlayerService.ets
export class PlayerService extends EventEmitter {
  private _playList: MusicModel[] = []
  private _currentIndex: number = 0

  get playList(): MusicModel[] {
    return this._playList
  }

  get currentIndex(): number {
    return this._currentIndex
  }

  set currentIndex(value: number) {
    if (this._currentIndex !== value) {
      this._currentIndex = value
      this.emit('indexChanged', value)
    }
  }

  // 派生状态: 当前播放的音乐
  get currentMusic(): MusicModel | null {
    if (this._playList.length === 0) return null
    return this._playList[this._currentIndex]
  }

  // 派生状态: 下一首音乐
  get nextMusic(): MusicModel | null {
    if (this._playList.length === 0) return null
    const nextIndex = (this._currentIndex + 1) % this._playList.length
    return this._playList[nextIndex]
  }

  // 派生状态: 上一首音乐
  get previousMusic(): MusicModel | null {
    if (this._playList.length === 0) return null
    const prevIndex = (this._currentIndex - 1 + this._playList.length) % this._playList.length
    return this._playList[prevIndex]
  }

  // 派生状态: 总时长
  get totalDuration(): number {
    return this._playList.reduce((sum, music) => sum + music.duration, 0)
  }
}
```

#### 5.4.3 状态批量更新
批量更新状态,减少渲染次数:

```typescript
// services/PlayerService.ets
export class PlayerService extends EventEmitter {
  private _isPlaying: boolean = false
  private _progress: number = 0
  private _duration: number = 0

  /**
   * 批量更新播放状态
   */
  updatePlayState(params: {
    isPlaying?: boolean
    progress?: number
    duration?: number
  }): void {
    let changed = false

    if (params.isPlaying !== undefined && this._isPlaying !== params.isPlaying) {
      this._isPlaying = params.isPlaying
      changed = true
    }

    if (params.progress !== undefined && this._progress !== params.progress) {
      this._progress = params.progress
      changed = true
    }

    if (params.duration !== undefined && this._duration !== params.duration) {
      this._duration = params.duration
      changed = true
    }

    if (changed) {
      this.emit('playStateChanged', {
        isPlaying: this._isPlaying,
        progress: this._progress,
        duration: this._duration
      })
    }
  }
}
```

#### 5.4.4 状态调试
添加状态调试工具:

```typescript
// utils/debugUtils.ets
export class DebugUtils {
  /**
   * 监听状态变化并输出日志
   */
  static logStateChanges(service: EventEmitter, serviceName: string): void {
    const originalOn = service.on.bind(service)

    service.on = function(eventName: string, listener: Function) {
      console.log(`[${serviceName}] Subscribed to event: ${eventName}`)

      const wrappedListener = (...args: any[]) => {
        console.log(`[${serviceName}] Event triggered: ${eventName}`, args)
        listener(...args)
      }

      return originalOn(eventName, wrappedListener)
    }
  }

  /**
   * 输出当前状态
   */
  static logState(service: any, serviceName: string): void {
    console.log(`[${serviceName}] Current state:`, JSON.stringify(service, null, 2))
  }
}

// 使用
DebugUtils.logStateChanges(PlayerService.getInstance(), 'PlayerService')
```

### 5.5 多状态管理

对于复杂应用,可以按模块划分状态管理:

```typescript
// store/index.ets
import { PlayerService } from '../services/PlayerService'
import { SettingService } from '../services/SettingService'
import { UserService } from '../services/UserService'

export class Store {
  static readonly player = PlayerService.getInstance()
  static readonly setting = SettingService.getInstance()
  static readonly user = UserService.getInstance()

  /**
   * 初始化所有服务
   */
  static async init(): Promise<void> {
    await this.setting.init()
    await this.user.init()
    await this.player.init()
  }
}

// 在组件中使用
@Entry
@Component
export struct HomePage {
  @State isPlaying: boolean = false
  @State theme: string = 'light'

  aboutToAppear(): void {
    // 使用统一的Store访问状态
    Store.player.on('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    Store.setting.on('themeChanged', (theme: string) => {
      this.theme = theme
    })
  }

  build() {
    Column() {
      // 页面UI
    }
  }
}
```

---

## 6. 路由管理规范

### 6.1 路由配置

```typescript
// config/RouterConfig.ets
import router from '@ohos.router'

/**
 * 路由配置
 */
export class RouterConfig {
  // 路由路径常量
  static readonly HOME = 'pages/HomePage'
  static readonly PLAYER = 'pages/PlayerPage'
  static readonly SEARCH = 'pages/SearchPage'
  static readonly SETTING = 'pages/SettingPage'
  static readonly SONG_LIST = 'pages/SongListPage'

  /**
   * 导航到首页
   */
  static navigateToHome(): void {
    router.replaceUrl({
      url: this.HOME
    })
  }

  /**
   * 导航到播放器页面
   */
  static navigateToPlayer(music: MusicModel): void {
    router.pushUrl({
      url: this.PLAYER,
      params: {
        musicId: music.id
      }
    })
  }

  /**
   * 导航到搜索页面
   */
  static navigateToSearch(keyword?: string): void {
    router.pushUrl({
      url: this.SEARCH,
      params: {
        keyword: keyword || ''
      }
    })
  }

  /**
   * 返回上一页
   */
  static navigateBack(): void {
    router.back()
  }

  /**
   * 清空路由栈并导航到指定页面
   */
  static navigateToRoot(url: string): void {
    router.clear()
    router.replaceUrl({
      url: url
    })
  }
}
```

### 6.2 页面参数传递

```typescript
// 发送参数页面
Button('播放音乐')
  .onClick(() => {
    router.pushUrl({
      url: 'pages/PlayerPage',
      params: {
        musicId: '123',
        listId: '456',
        autoPlay: true
      }
    })
  })

// 接收参数页面
@Entry
@Component
export struct PlayerPage {
  @State musicId: string = ''
  @State listId: string = ''
  @State autoPlay: boolean = false

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>
    this.musicId = params['musicId'] as string
    this.listId = params['listId'] as string
    this.autoPlay = params['autoPlay'] as boolean
  }

  build() {
    // 页面UI
  }
}
```

### 6.3 路由守卫

```typescript
// utils/routerGuard.ets
import router from '@ohos.router'
import { StorageService } from '../services/StorageService'

/**
 * 路由守卫
 */
export class RouterGuard {
  /**
   * 检查登录状态
   */
  static async checkLogin(): Promise<boolean> {
    const token = await StorageService.getInstance().getData('token')
    return !!token
  }

  /**
   * 导航守卫方法
   */
  static async navigateWithAuth(url: string, params?: Object): Promise<void> {
    const isLoggedIn = await this.checkLogin()

    if (!isLoggedIn) {
      // 未登录,跳转到登录页
      router.pushUrl({
        url: 'pages/LoginPage',
        params: {
          redirectUrl: url,
          redirectParams: params
        }
      })
      return
    }

    // 已登录,正常导航
    router.pushUrl({
      url: url,
      params: params
    })
  }
}
```

### 6.4 路由最佳实践

#### 6.4.1 路由参数类型安全
定义路由参数类型:

```typescript
// types/RouterParams.ets
export interface PlayerPageParams {
  musicId: string
  listId?: string
  autoPlay?: boolean
  startTime?: number
}

export interface SearchPageParams {
  keyword?: string
  type?: 'music' | 'artist' | 'album'
}

export interface SongListPageParams {
  listId: string
  listName: string
}

// 在页面中使用
@Entry
@Component
export struct PlayerPage {
  @State musicId: string = ''
  @State listId: string = ''
  @State autoPlay: boolean = false

  aboutToAppear(): void {
    const params = router.getParams() as PlayerPageParams
    this.musicId = params.musicId
    this.listId = params.listId || ''
    this.autoPlay = params.autoPlay ?? false
  }

  build() {
    // 页面UI
  }
}
```

#### 6.4.2 路由拦截器
实现路由拦截器:

```typescript
// utils/routerInterceptor.ets
import router from '@ohos.router'

type RouterInterceptor = (url: string, params?: Object) => boolean

export class RouterInterceptor {
  private static interceptors: RouterInterceptor[] = []

  /**
   * 添加拦截器
   */
  static add(interceptor: RouterInterceptor): void {
    this.interceptors.push(interceptor)
  }

  /**
   * 移除拦截器
   */
  static remove(interceptor: RouterInterceptor): void {
    const index = this.interceptors.indexOf(interceptor)
    if (index >= 0) {
      this.interceptors.splice(index, 1)
    }
  }

  /**
   * 执行拦截
   */
  static async intercept(url: string, params?: Object): Promise<boolean> {
    for (const interceptor of this.interceptors) {
      const result = await interceptor(url, params)
      if (!result) {
        return false
      }
    }
    return true
  }

  /**
   * 导航(带拦截)
   */
  static async navigate(url: string, params?: Object): Promise<void> {
    const canNavigate = await this.intercept(url, params)
    if (canNavigate) {
      router.pushUrl({ url, params })
    }
  }
}

// 使用示例
RouterInterceptor.add((url: string, params?: Object) => {
  // 拦截登录页
  if (url === 'pages/LoginPage') {
    const token = StorageService.getInstance().getData('token')
    if (token) {
      // 已登录,跳转到首页
      router.replaceUrl({ url: 'pages/HomePage' })
      return false
    }
  }
  return true
})
```

#### 6.4.3 路由动画
自定义路由转场动画:

```typescript
// utils/routerAnimation.ets
import router from '@ohos.router'

export class RouterAnimation {
  /**
   * 淡入淡出动画
   */
  static fade(): router.RouterOptions {
    return {
      url: '',
      params: {},
      animation: {
        pageTransitionDuration: 300,
        // 淡入淡出动画
      }
    }
  }

  /**
   * 从右侧滑入
   */
  static slideFromRight(): router.RouterOptions {
    return {
      url: '',
      params: {},
      animation: {
        pageTransitionDuration: 300,
        // 从右侧滑入动画
      }
    }
  }

  /**
   * 从底部滑入
   */
  static slideFromBottom(): router.RouterOptions {
    return {
      url: '',
      params: {},
      animation: {
        pageTransitionDuration: 300,
        // 从底部滑入动画
      }
    }
  }
}
```

#### 6.4.4 路由缓存
实现路由缓存:

```typescript
// utils/routerCache.ets
import router from '@ohos.router'

export class RouterCache {
  private static cache: Map<string, any> = new Map()

  /**
   * 缓存页面数据
   */
  static set(key: string, data: any): void {
    this.cache.set(key, data)
  }

  /**
   * 获取缓存数据
   */
  static get(key: string): any {
    return this.cache.get(key)
  }

  /**
   * 清除缓存
   */
  static clear(key?: string): void {
    if (key) {
      this.cache.delete(key)
    } else {
      this.cache.clear()
    }
  }

  /**
   * 导航并缓存数据
   */
  static navigateWithCache(url: string, params?: Object, cacheKey?: string, cacheData?: any): void {
    if (cacheKey && cacheData !== undefined) {
      this.set(cacheKey, cacheData)
    }
    router.pushUrl({ url, params })
  }
}

// 使用示例
// 在页面A中
RouterCache.navigateWithCache(
  'pages/PlayerPage',
  { musicId: '123' },
  'musicList',
  musicList
)

// 在页面B中
const musicList = RouterCache.get('musicList')
```

### 6.5 深度链接处理

```typescript
// utils/deepLink.ets
import router from '@ohos.router'

export class DeepLink {
  /**
   * 处理深度链接
   */
  static handle(uri: string): void {
    const url = new URL(uri)
    const path = url.pathname
    const params = Object.fromEntries(url.searchParams.entries())

    switch (path) {
      case '/music':
        this.handleMusicLink(params)
        break
      case '/playlist':
        this.handlePlaylistLink(params)
        break
      case '/user':
        this.handleUserLink(params)
        break
      default:
        console.warn('Unknown deep link:', uri)
    }
  }

  /**
   * 处理音乐链接
   */
  private static handleMusicLink(params: Record<string, string>): void {
    const musicId = params.id
    if (musicId) {
      router.pushUrl({
        url: 'pages/PlayerPage',
        params: { musicId, autoPlay: true }
      })
    }
  }

  /**
   * 处理歌单链接
   */
  private static handlePlaylistLink(params: Record<string, string>): void {
    const listId = params.id
    if (listId) {
      router.pushUrl({
        url: 'pages/SongListPage',
        params: { listId }
      })
    }
  }

  /**
   * 处理用户链接
   */
  private static handleUserLink(params: Record<string, string>): void {
    const userId = params.id
    if (userId) {
      router.pushUrl({
        url: 'pages/UserPage',
        params: { userId }
      })
    }
  }
}
```

---

## 7. 样式规范

### 7.1 样式定义

```typescript
// 使用@Styles定义可复用样式
@Component
export struct MusicItem {
  @Styles itemStyle() {
    .width('100%')
    .height(54)
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('app.color.content_background'))
    .borderRadius(8)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Styles titleStyle() {
    .fontSize(16)
    .fontColor($r('app.color.font_primary'))
    .fontWeight(FontWeight.Medium)
  }

  @Styles subtitleStyle() {
    .fontSize(14)
    .fontColor($r('app.color.font_secondary'))
    .margin({ top: 4 })
  }

  build() {
    Row() {
      Column() {
        Text(this.musicInfo.name)
          .titleStyle()

        Text(this.musicInfo.singer)
          .subtitleStyle()
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text(this.musicInfo.durationStr)
        .fontSize(12)
        .fontColor($r('app.color.font_hint'))
    }
    .itemStyle()
    .onClick(() => {
      // 点击事件
    })
  }
}
```

### 7.2 主题配置

```typescript
// config/ThemeConfig.ets
/**
 * 主题配置
 */
export class ThemeConfig {
  // 颜色配置
  static readonly Colors = {
    primary: '#4CAF50',
    primaryDark: '#388E3C',
    primaryLight: '#C8E6C9',
    secondary: '#FF9800',
    background: '#FFFFFF',
    surface: '#F5F5F5',
    error: '#F44336',
    success: '#4CAF50',
    warning: '#FF9800',
    info: '#2196F3',

    // 文字颜色
    fontPrimary: 'rgba(0, 0, 0, 0.87)',
    fontSecondary: 'rgba(0, 0, 0, 0.60)',
    fontHint: 'rgba(0, 0, 0, 0.38)',
    fontDisabled: 'rgba(0, 0, 0, 0.26)',

    // 分割线
    divider: 'rgba(0, 0, 0, 0.12)',

    // 阴影
    shadow: 'rgba(0, 0, 0, 0.24)'
  }

  // 字体配置
  static readonly Typography = {
    displayLarge: { fontSize: 57, fontWeight: FontWeight.Regular },
    displayMedium: { fontSize: 45, fontWeight: FontWeight.Regular },
    displaySmall: { fontSize: 36, fontWeight: FontWeight.Regular },
    headlineLarge: { fontSize: 32, fontWeight: FontWeight.Regular },
    headlineMedium: { fontSize: 28, fontWeight: FontWeight.Regular },
    headlineSmall: { fontSize: 24, fontWeight: FontWeight.Regular },
    titleLarge: { fontSize: 22, fontWeight: FontWeight.Medium },
    titleMedium: { fontSize: 16, fontWeight: FontWeight.Medium },
    titleSmall: { fontSize: 14, fontWeight: FontWeight.Medium },
    bodyLarge: { fontSize: 16, fontWeight: FontWeight.Regular },
    bodyMedium: { fontSize: 14, fontWeight: FontWeight.Regular },
    bodySmall: { fontSize: 12, fontWeight: FontWeight.Regular },
    labelLarge: { fontSize: 14, fontWeight: FontWeight.Medium },
    labelMedium: { fontSize: 12, fontWeight: FontWeight.Medium },
    labelSmall: { fontSize: 11, fontWeight: FontWeight.Medium }
  }

  // 间距配置
  static readonly Spacing = {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48
  }

  // 圆角配置
  static readonly BorderRadius = {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    full: 9999
  }
}
```

### 7.3 响应式设计

```typescript
// utils/screenUtils.ets
/**
 * 屏幕适配工具
 */
export class ScreenUtils {
  private static screenWidth: number = 0
  private static screenHeight: number = 0
  private static density: number = 1

  /**
   * 初始化屏幕信息
   */
  static init(): void {
    this.screenWidth = display.getDefaultDisplaySync().width
    this.screenHeight = display.getDefaultDisplaySync().height
    this.density = display.getDefaultDisplaySync().densityDPI / 160
  }

  /**
   * 获取屏幕宽度
   */
  static getScreenWidth(): number {
    return this.screenWidth
  }

  /**
   * 获取屏幕高度
   */
  static getScreenHeight(): number {
    return this.screenHeight
  }

  /**
   * dp转px
   */
  static dp2px(dp: number): number {
    return dp * this.density
  }

  /**
   * px转dp
   */
  static px2dp(px: number): number {
    return px / this.density
  }

  /**
   * 根据屏幕宽度计算比例
   */
  static getScale(value: number, baseWidth: number = 375): number {
    return (value * this.screenWidth) / baseWidth
  }
}

// 在组件中使用
@Component
export struct ResponsiveComponent {
  build() {
    Column() {
      Text('响应式布局')
        .fontSize(ScreenUtils.getScale(16))
        .padding({
          left: ScreenUtils.getScale(16),
          right: ScreenUtils.getScale(16)
        })
    }
    .width(ScreenUtils.getScale(375))
  }
}
```

---

## 8. 资源管理规范

### 8.1 资源文件组织

```
resources/
├── base/
│   ├── element/
│   │   ├── string.json        # 字符串资源
│   │   ├── color.json         # 颜色资源
│   │   ├── float.json         # 尺寸资源
│   │   └── boolean.json       # 布尔资源
│   ├── media/
│   │   ├── icon.png           # 图标资源
│   │   ├── background.png     # 背景资源
│   │   └── music_placeholder.png
│   └── profile/
│       └── main_pages.json    # 页面配置
├── zh_CN/                     # 简体中文
│   └── element/
│       └── string.json
├── zh_TW/                     # 繁体中文
│   └── element/
│       └── string.json
└── en_US/                     # 英文
    └── element/
        └── string.json
```

### 8.2 字符串资源

```json
// resources/base/element/string.json
{
  "string": [
    {
      "name": "app_name",
      "value": "音乐播放器"
    },
    {
      "name": "home_title",
      "value": "首页"
    },
    {
      "name": "player_title",
      "value": "播放器"
    },
    {
      "name": "search_placeholder",
      "value": "搜索音乐、歌手、专辑"
    },
    {
      "name": "play",
      "value": "播放"
    },
    {
      "name": "pause",
      "value": "暂停"
    },
    {
      "name": "next",
      "value": "下一首"
    },
    {
      "name": "previous",
      "value": "上一首"
    }
  ]
}
```

### 8.3 颜色资源

```json
// resources/base/element/color.json
{
  "color": [
    {
      "name": "primary",
      "value": "#4CAF50"
    },
    {
      "name": "primary_dark",
      "value": "#388E3C"
    },
    {
      "name": "content_background",
      "value": "#FFFFFF"
    },
    {
      "name": "font_primary",
      "value": "#000000"
    },
    {
      "name": "font_secondary",
      "value": "#99000000"
    },
    {
      "name": "font_hint",
      "value": "#61000000"
    },
    {
      "name": "divider",
      "value": "#1F000000"
    }
  ]
}
```

### 8.4 尺寸资源

```json
// resources/base/element/float.json
{
  "float": [
    {
      "name": "spacing_xs",
      "value": "4vp"
    },
    {
      "name": "spacing_sm",
      "value": "8vp"
    },
    {
      "name": "spacing_md",
      "value": "16vp"
    },
    {
      "name": "spacing_lg",
      "value": "24vp"
    },
    {
      "name": "spacing_xl",
      "value": "32vp"
    },
    {
      "name": "font_size_large",
      "value": "24fp"
    },
    {
      "name": "font_size_medium",
      "value": "16fp"
    },
    {
      "name": "font_size_small",
      "value": "14fp"
    }
  ]
}
```

### 8.5 在代码中使用资源

```typescript
// 使用字符串资源
Text($r('app.string.app_name'))
Button($r('app.string.play'))

// 使用颜色资源
Text('标题')
  .fontColor($r('app.color.font_primary'))

Column() {
  // 内容
}
  .backgroundColor($r('app.color.content_background'))

// 使用尺寸资源
Text('文本')
  .fontSize($r('app.float.font_size_medium'))
  .padding({
    left: $r('app.float.spacing_md'),
    right: $r('app.float.spacing_md')
  })

// 使用媒体资源
Image($r('app.media.icon'))
  .width(32)
  .height(32)
```

### 8.6 国际化支持

```typescript
// utils/i18nUtils.ets
/**
 * 国际化工具
 */
export class I18nUtils {
  /**
   * 获取当前语言
   */
  static getCurrentLanguage(): string {
    return i18n.System.getSystemLanguage()
  }

  /**
   * 设置语言
   */
  static setLanguage(language: string): void {
    i18n.System.setSystemLanguage(language)
  }

  /**
   * 获取本地化字符串
   */
  static getString(key: string): string {
    return $r(`app.string.${key}`).toString()
  }

  /**
   * 格式化字符串
   */
  static formatString(key: string, ...args: string[]): string {
    let str = this.getString(key)
    args.forEach((arg, index) => {
      str = str.replace(`{${index}}`, arg)
    })
    return str
  }
}

// 使用示例
Text(I18nUtils.getString('app_name'))
Text(I18nUtils.formatString('search_result_count', '100'))
```

---

## 9. 性能优化规范

### 9.1 组件优化

#### 使用@Reusable标记可复用组件

```typescript
@Reusable
@Component
export struct MusicListItem {
  @Prop musicInfo: MusicModel
  @Prop index: number

  build() {
    Row() {
      Text(`${this.index + 1}. ${this.musicInfo.name}`)
      Text(this.musicInfo.singer)
    }
    .width('100%')
    .height(54)
  }
}
```

#### 使用@Observed和@ObjectLink处理对象变化

```typescript
// 定义可观察的类
@Observed
class MusicModel {
  public id: string
  public name: string
  public singer: string
  public progress: number = 0

  constructor(id: string, name: string, singer: string) {
    this.id = id
    this.name = name
    this.singer = singer
  }
}

// 在组件中使用@ObjectLink
@Component
export struct MusicDetail {
  @ObjectLink musicInfo: MusicModel

  build() {
    Column() {
      Text(this.musicInfo.name)
      Text(this.musicInfo.singer)
      Text(`进度: ${this.musicInfo.progress}%`)
    }
  }
}
```

#### 使用LazyForEach优化列表渲染

```typescript
@Entry
@Component
export struct MusicListPage {
  @State musicList: MusicModel[] = []

  aboutToAppear(): void {
    this.loadMusicList()
  }

  private loadMusicList(): void {
    // 加载音乐列表
  }

  build() {
    List() {
      LazyForEach(this.musicList, (item: MusicModel, index: number) => {
        ListItem() {
          MusicListItem({
            musicInfo: item,
            index: index
          })
        }
      }, (item: MusicModel, index: number) => item.id)
    }
    .width('100%')
    .height('100%')
  }
}
```

### 9.2 内存优化

#### 图片加载优化

```typescript
// 使用合适的图片尺寸和格式
Image($r('app.media.album_cover'))
  .width(100)
  .height(100)
  .objectFit(ImageFit.Cover)
  .borderRadius(8)
  .onError(() => {
    // 加载失败时显示占位图
  })

// 使用缓存
Image(musicInfo.picUrl)
  .width(100)
  .height(100)
  .cache(true)  // 启用缓存
  .objectFit(ImageFit.Cover)
```

#### 数据懒加载

```typescript
@Entry
@Component
export struct SearchPage {
  @State searchResults: MusicModel[] = []
  @State currentPage: number = 1
  @State isLoading: boolean = false
  @State hasMore: boolean = true

  private async loadMore(): Promise<void> {
    if (this.isLoading || !this.hasMore) return

    this.isLoading = true
    try {
      const results = await MusicService.getInstance()
        .searchMusic(this.keyword, this.currentPage, 20)

      if (results.length === 0) {
        this.hasMore = false
      } else {
        this.searchResults.push(...results)
        this.currentPage++
      }
    } catch (error) {
      console.error('加载失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  build() {
    List() {
      LazyForEach(this.searchResults, (item: MusicModel) => {
        ListItem() {
          MusicListItem({ musicInfo: item })
        }
      }, (item: MusicModel) => item.id)

      if (this.hasMore) {
        ListItem() {
          Text('加载中...')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(16)
        }
        .onAppear(() => {
          this.loadMore()
        })
      }
    }
    .onReachEnd(() => {
      this.loadMore()
    })
  }
}
```

### 9.3 网络请求优化

#### 请求缓存

```typescript
// services/NetworkService.ets
export class NetworkService {
  private cache: Map<string, { data: any, timestamp: number }> = new Map()
  private readonly cacheTimeout = 5 * 60 * 1000 // 5分钟缓存

  async request(url: string, options?: http.HttpRequestOptions): Promise<any> {
    // 检查缓存
    const cached = this.cache.get(url)
    if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
      return cached.data
    }

    // 发起请求
    const response = await http.createHttp().request(url, options)

    if (response.responseCode === 200) {
      const data = JSON.parse(response.result as string)

      // 缓存结果
      this.cache.set(url, {
        data: data,
        timestamp: Date.now()
      })

      return data
    } else {
      throw new Error(`请求失败: ${response.responseCode}`)
    }
  }
}
```

#### 请求取消

```typescript
@Entry
@Component
export struct SearchPage {
  private httpRequest?: http.HttpRequest
  private searchKeyword: string = ''

  private async search(keyword: string): Promise<void> {
    // 取消之前的请求
    if (this.httpRequest) {
      this.httpRequest.destroy()
    }

    this.searchKeyword = keyword

    try {
      this.httpRequest = http.createHttp()
      const response = await this.httpRequest.request(
        `https://api.example.com/search?keyword=${keyword}`,
        {
          method: http.RequestMethod.GET,
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: 10000,
          readTimeout: 10000
        }
      )

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string)
        this.searchResults = data.data
      }
    } catch (error) {
      console.error('搜索失败:', error)
    }
  }

  aboutToDisappear(): void {
    // 组件销毁时取消请求
    if (this.httpRequest) {
      this.httpRequest.destroy()
    }
  }

  build() {
    // 页面UI
  }
}
```

### 9.4 渲染优化

#### 避免不必要的渲染

```typescript
@Component
export struct PlayerBar {
  @State isPlaying: boolean = false
  @State progress: number = 0

  // 使用@Watch监听变化,只在必要时更新
  @Watch('onProgressChange')
  @State currentTime: number = 0

  private onProgressChange(): void {
    // 只在进度变化时更新时间显示
    this.currentTime = this.progress
  }

  build() {
    Row() {
      // 播放控制UI
    }
  }
}
```

#### 使用条件渲染减少组件树

```typescript
@Entry
@Component
export struct PlayerPage {
  @State showLyrics: boolean = false

  build() {
    Column() {
      // 切换按钮
      Button(this.showLyrics ? '显示封面' : '显示歌词')
        .onClick(() => {
          this.showLyrics = !this.showLyrics
        })

      // 条件渲染
      if (this.showLyrics) {
        LyricView()
      } else {
        AlbumCover()
      }
    }
  }
}
```

### 9.5 性能监控

#### 性能指标收集

```typescript
// utils/performanceMonitor.ets
export class PerformanceMonitor {
  private static metrics: Map<string, number[]> = new Map()

  /**
   * 开始计时
   */
  static startTimer(label: string): number {
    return Date.now()
  }

  /**
   * 结束计时
   */
  static endTimer(label: string, startTime: number): void {
    const duration = Date.now() - startTime

    if (!this.metrics.has(label)) {
      this.metrics.set(label, [])
    }

    this.metrics.get(label)?.push(duration)

    // 输出日志
    console.log(`[Performance] ${label}: ${duration}ms`)
  }

  /**
   * 获取平均耗时
   */
  static getAverage(label: string): number {
    const times = this.metrics.get(label)
    if (!times || times.length === 0) return 0

    const sum = times.reduce((acc, time) => acc + time, 0)
    return sum / times.length
  }

  /**
   * 获取最大耗时
   */
  static getMax(label: string): number {
    const times = this.metrics.get(label)
    if (!times || times.length === 0) return 0

    return Math.max(...times)
  }

  /**
   * 清除统计数据
   */
  static clear(): void {
    this.metrics.clear()
  }
}

// 使用示例
const startTime = PerformanceMonitor.startTimer('music_search')
await musicService.searchMusic(keyword)
PerformanceMonitor.endTimer('music_search', startTime)
```

#### 内存监控

```typescript
// utils/memoryMonitor.ets
import { process } from '@kit.ArkTS'

export class MemoryMonitor {
  private static isMonitoring: boolean = false
  private static intervalId: number = 0

  /**
   * 开始监控
   */
  static start(interval: number = 5000): void {
    if (this.isMonitoring) return

    this.isMonitoring = true
    this.intervalId = setInterval(() => {
      this.logMemoryInfo()
    }, interval)
  }

  /**
   * 停止监控
   */
  static stop(): void {
    if (!this.isMonitoring) return

    clearInterval(this.intervalId)
    this.isMonitoring = false
  }

  /**
   * 记录内存信息
   */
  private static logMemoryInfo(): void {
    const memoryInfo = process.getCurrentProcessInfo()

    console.log('[Memory Monitor]', {
      pid: memoryInfo.pid,
      memoryUsed: `${(memoryInfo.memoryUsed / 1024 / 1024).toFixed(2)} MB`,
      memoryMax: `${(memoryInfo.memoryMax / 1024 / 1024).toFixed(2)} MB`,
      memoryRatio: `${((memoryInfo.memoryUsed / memoryInfo.memoryMax) * 100).toFixed(2)}%`
    })

    // 内存使用率超过80%时发出警告
    if (memoryInfo.memoryUsed / memoryInfo.memoryMax > 0.8) {
      console.warn('[Memory Monitor] Memory usage is high!')
    }
  }
}
```

#### FPS监控

```typescript
// utils/fpsMonitor.ets
export class FpsMonitor {
  private static frameCount: number = 0
  private static lastTime: number = 0
  private static fps: number = 0
  private static intervalId: number = 0
  private static isMonitoring: boolean = false

  /**
   * 开始监控
   */
  static start(): void {
    if (this.isMonitoring) return

    this.isMonitoring = true
    this.frameCount = 0
    this.lastTime = Date.now()

    this.intervalId = setInterval(() => {
      this.calculateFps()
    }, 1000)
  }

  /**
   * 停止监控
   */
  static stop(): void {
    if (!this.isMonitoring) return

    clearInterval(this.intervalId)
    this.isMonitoring = false
  }

  /**
   * 记录帧
   */
  static tick(): void {
    this.frameCount++
  }

  /**
   * 计算FPS
   */
  private static calculateFps(): void {
    const now = Date.now()
    const elapsed = now - this.lastTime

    if (elapsed >= 1000) {
      this.fps = Math.round((this.frameCount * 1000) / elapsed)
      console.log(`[FPS Monitor] FPS: ${this.fps}`)

      // FPS低于30时发出警告
      if (this.fps < 30) {
        console.warn('[FPS Monitor] FPS is low!')
      }

      this.frameCount = 0
      this.lastTime = now
    }
  }

  /**
   * 获取当前FPS
   */
  static getFps(): number {
    return this.fps
  }
}
```

### 9.6 启动优化

#### 延迟加载

```typescript
// utils/lazyLoad.ets
export class LazyLoad {
  /**
   * 延迟初始化
   */
  static async init<T>(factory: () => T | Promise<T>, delay: number = 0): Promise<T> {
    if (delay > 0) {
      await new Promise(resolve => setTimeout(resolve, delay))
    }
    return await factory()
  }
}

// 使用示例
@Entry
@Component
export struct HomePage {
  @State isLoaded: boolean = false

  aboutToAppear(): void {
    // 延迟加载非关键资源
    LazyLoad.init(() => {
      return this.loadSecondaryResources()
    }, 1000)
  }

  private async loadSecondaryResources(): Promise<void> {
    // 加载次要资源
    this.isLoaded = true
  }

  build() {
    Column() {
      // 主要内容
      if (this.isLoaded) {
        // 次要内容
      }
    }
  }
}
```

#### 预加载

```typescript
// utils/preload.ets
export class Preload {
  private static preloadQueue: Array<() => Promise<void>> = []

  /**
   * 添加预加载任务
   */
  static add(task: () => Promise<void>): void {
    this.preloadQueue.push(task)
  }

  /**
   * 执行预加载
   */
  static async execute(): Promise<void> {
    const tasks = [...this.preloadQueue]
    this.preloadQueue = []

    await Promise.all(tasks.map(task => task()))
  }
}

// 使用示例
Preload.add(async () => {
  await musicService.preloadMusicList()
})

Preload.add(async () => {
  await userService.loadUserInfo()
})

// 在应用启动时执行
Preload.execute()
```

### 9.7 最佳实践总结

#### 9.7.1 组件优化清单

- ✅ 使用@Reusable标记可复用的列表项组件
- ✅ 使用@Observed和@ObjectLink处理对象变化
- ✅ 使用LazyForEach渲染长列表
- ✅ 避免在build方法中进行复杂计算
- ✅ 使用条件渲染减少组件树
- ✅ 合理使用@Watch监听状态变化
- ✅ 避免不必要的状态更新

#### 9.7.2 内存优化清单

- ✅ 及时释放不再使用的资源
- ✅ 使用图片缓存和压缩
- ✅ 实现数据懒加载
- ✅ 定期清理缓存
- ✅ 避免内存泄漏
- ✅ 使用WeakMap存储临时数据

#### 9.7.3 网络优化清单

- ✅ 实现请求缓存
- ✅ 使用请求取消避免重复请求
- ✅ 设置合理的超时时间
- ✅ 使用CDN加速资源加载
- ✅ 压缩请求数据
- ✅ 实现重试机制

#### 9.7.4 渲染优化清单

- ✅ 减少不必要的渲染
- ✅ 使用虚拟滚动
- ✅ 优化图片加载
- ✅ 避免深层嵌套
- ✅ 使用硬件加速
- ✅ 优化动画性能

---

## 10. 错误处理规范

### 10.1 统一错误处理

```typescript
// utils/errorHandler.ets
/**
 * 错误处理器
 */
export class ErrorHandler {
  /**
   * 处理错误
   */
  static handleError(error: Error, context: string): void {
    console.error(`[${context}] Error:`, error.message)

    // 记录错误日志
    this.logError(error, context)

    // 显示用户友好的错误信息
    this.showErrorToast(error.message)

    // 上报错误
    this.reportError(error, context)
  }

  /**
   * 记录错误日志
   */
  private static logError(error: Error, context: string): void {
    const logData = {
      timestamp: new Date().toISOString(),
      context: context,
      message: error.message,
      stack: error.stack
    }

    // 保存到本地日志
    // ...
  }

  /**
   * 显示错误提示
   */
  private static showErrorToast(message: string): void {
    promptAction.showToast({
      message: this.getErrorMessage(message),
      duration: 2000
    })
  }

  /**
   * 获取用户友好的错误信息
   */
  private static getErrorMessage(message: string): string {
    // 根据错误类型返回友好的提示信息
    const errorMap: Record<string, string> = {
      'network': '网络连接失败,请检查网络设置',
      'timeout': '请求超时,请稍后重试',
      'permission': '权限不足,请在设置中开启相关权限',
      'not_found': '未找到相关内容',
      'server_error': '服务器错误,请稍后重试'
    }

    for (const key in errorMap) {
      if (message.toLowerCase().includes(key)) {
        return errorMap[key]
      }
    }

    return '操作失败,请稍后重试'
  }

  /**
   * 上报错误
   */
  private static reportError(error: Error, context: string): void {
    // 上报到错误监控平台
    // ...
  }
}
```

### 10.2 异步错误处理

```typescript
// 在服务中使用错误处理
export class MusicService {
  async searchMusic(keyword: string, page: number = 1): Promise<MusicModel[]> {
    try {
      const response = await http.createHttp().request(
        `https://api.example.com/search?keyword=${keyword}&page=${page}`,
        {
          method: http.RequestMethod.GET
        }
      )

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string)
        return data.data.map((item: any) => new MusicModel(item))
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      ErrorHandler.handleError(error as Error, 'MusicService.searchMusic')
      throw error
    }
  }
}

// 在组件中使用错误处理
@Entry
@Component
export struct SearchPage {
  @State searchResults: MusicModel[] = []
  @State isLoading: boolean = false
  @State errorMessage: string = ''

  private async search(keyword: string): Promise<void> {
    this.isLoading = true
    this.errorMessage = ''

    try {
      this.searchResults = await MusicService.getInstance().searchMusic(keyword)
    } catch (error) {
      this.errorMessage = (error as Error).message
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress()
          .width(50)
          .height(50)
      } else if (this.errorMessage) {
        Text(this.errorMessage)
          .fontColor(Color.Red)
          .padding(16)
      } else {
        List() {
          // 搜索结果列表
        }
      }
    }
  }
}
```

### 10.3 边界情况处理

```typescript
// 处理空数据
export class MusicService {
  async getMusicDetail(id: string): Promise<MusicModel | null> {
    if (!id) {
      ErrorHandler.handleError(new Error('音乐ID不能为空'), 'MusicService.getMusicDetail')
      return null
    }

    try {
      const response = await http.createHttp().request(
        `https://api.example.com/music/${id}`,
        {
          method: http.RequestMethod.GET
        }
      )

      if (response.responseCode === 200) {
        const data = JSON.parse(response.result as string)
        return new MusicModel(data.data)
      } else if (response.responseCode === 404) {
        console.warn('音乐不存在')
        return null
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      ErrorHandler.handleError(error as Error, 'MusicService.getMusicDetail')
      return null
    }
  }
}

// 处理网络超时
export class NetworkService {
  async requestWithTimeout(url: string, timeout: number = 10000): Promise<any> {
    return Promise.race([
      http.createHttp().request(url),
      new Promise((_, reject) => {
        setTimeout(() => reject(new Error('请求超时')), timeout)
      })
    ])
  }
}
```

---

## 11. 测试规范

### 11.1 单元测试

```typescript
// ohosTest/ets/test/MusicService.test.ets
import { describe, it, expect, beforeEach } from '@ohos/hypium'
import { MusicService } from '../../../main/ets/services/MusicService'

export default function MusicServiceTest() {
  describe('MusicService', () => {
    let musicService: MusicService

    beforeEach(() => {
      musicService = MusicService.getInstance()
    })

    it('should search music successfully', async () => {
      const results = await musicService.searchMusic('测试', 1, 10)

      expect(results.length).assertGreaterThan(0)
      expect(results[0].name).assertEqual('测试歌曲')
    })

    it('should handle empty keyword', async () => {
      try {
        await musicService.searchMusic('', 1, 10)
        expect(true).assertEqual(false) // 不应该执行到这里
      } catch (error) {
        expect(error).not.toBeNull()
      }
    })

    it('should get music detail', async () => {
      const music = await musicService.getMusicDetail('123')

      expect(music).not.toBeNull()
      expect(music?.id).assertEqual('123')
    })
  })
}
```

### 11.2 组件测试

```typescript
// ohosTest/ets/test/MusicItem.test.ets
import { describe, it, expect } from '@ohos/hypium'
import { MusicItem } from '../../../main/ets/components/music/MusicItem'

export default function MusicItemTest() {
  describe('MusicItem', () => {
    it('should render music info correctly', () => {
      const musicInfo = new MusicModel({
        id: '123',
        name: '测试歌曲',
        singer: '测试歌手',
        duration: 180
      })

      const component = MusicItem.create({
        musicInfo: musicInfo
      })

      expect(component.musicInfo.name).assertEqual('测试歌曲')
      expect(component.musicInfo.singer).assertEqual('测试歌手')
    })

    it('should handle click event', () => {
      let clicked = false

      const musicInfo = new MusicModel({
        id: '123',
        name: '测试歌曲',
        singer: '测试歌手'
      })

      const component = MusicItem.create({
        musicInfo: musicInfo,
        onClick: () => {
          clicked = true
        }
      })

      component.onClick()
      expect(clicked).assertTrue()
    })
  })
}
```

### 11.3 集成测试

```typescript
// ohosTest/ets/test/PlayerFlow.test.ets
import { describe, it, expect } from '@ohos/hypium'
import { PlayerService } from '../../../main/ets/services/PlayerService'
import { MusicService } from '../../../main/ets/services/MusicService'

export default function PlayerFlowTest() {
  describe('Player Flow', () => {
    it('should play music flow', async () => {
      const musicService = MusicService.getInstance()
      const playerService = PlayerService.getInstance()

      // 搜索音乐
      const results = await musicService.searchMusic('测试', 1, 1)
      expect(results.length).assertGreaterThan(0)

      // 播放音乐
      await playerService.playMusic(results[0])
      expect(playerService.isPlaying).assertTrue()
      expect(playerService.currentMusic?.id).assertEqual(results[0].id)

      // 暂停播放
      playerService.pauseMusic()
      expect(playerService.isPlaying).assertFalse()
    })
  })
}
```

---

## 12. 文档规范

### 12.1 代码注释

#### 文件头注释

```typescript
/**
 * @file MusicService.ets
 * @description 音乐服务类,负责音乐搜索、信息获取等业务逻辑
 * @author 开发者姓名
 * @date 2024-01-01
 * @version 1.0.0
 */
```

#### 类注释

```typescript
/**
 * 音乐服务类
 * 负责音乐搜索、信息获取、播放列表管理等业务逻辑
 *
 * @example
 * ```typescript
 * const musicService = MusicService.getInstance()
 * const results = await musicService.searchMusic('测试')
 * ```
 */
export class MusicService {
  // 实现
}
```

#### 方法注释

```typescript
/**
 * 搜索音乐
 *
 * @param keyword - 搜索关键词
 * @param page - 页码,默认为1
 * @param limit - 每页数量,默认为20
 * @returns 音乐列表
 * @throws {Error} 当网络请求失败时抛出异常
 *
 * @example
 * ```typescript
 * const results = await musicService.searchMusic('周杰伦', 1, 10)
 * console.log(`找到 ${results.length} 首歌曲`)
 * ```
 */
async searchMusic(keyword: string, page: number = 1, limit: number = 20): Promise<MusicModel[]> {
  // 实现
}
```

#### 属性注释

```typescript
export class MusicModel {
  /** 音乐ID */
  id: string

  /** 歌曲名称 */
  name: string

  /** 歌手名称 */
  singer: string

  /** 专辑名称 */
  album: string

  /** 歌曲时长(秒) */
  duration: number

  /** 音乐URL */
  url: string

  /** 封面图片URL */
  picUrl: string
}
```

### 12.2 README文档

```markdown
# 音乐播放器

## 项目简介

这是一个基于鸿蒙系统的音乐播放器应用,支持在线音乐播放、搜索、收藏等功能。

## 功能特性

- 🎵 在线音乐播放
- 🔍 音乐搜索
- ❤️ 收藏管理
- 📝 歌词显示
- 🌙 深色模式
- 🌍 多语言支持

## 技术栈

- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **应用模型**: Stage模型
- **API版本**: API 9+

## 安装运行

### 环境要求

- DevEco Studio 4.0+
- Node.js 16.x+
- HarmonyOS SDK API 9+

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/xxx/harmony-music.git
cd harmony-music
```

2. 安装依赖
```bash
npm install
```

3. 运行项目
- 在DevEco Studio中打开项目
- 连接HarmonyOS设备或启动模拟器
- 点击运行按钮

## 项目结构

```
harmony-music/
├── entry/              # 主模块
├── oh_modules/         # 依赖模块
└── build-profile.json5 # 构建配置
```

## 开发规范

详见 [开发规范文档](./docs/development-guide.md)

## 贡献指南

欢迎提交Issue和Pull Request!

## 许可证

MIT License
```

### 12.3 API文档

```markdown
# API文档

## MusicService

音乐服务类,提供音乐搜索、信息获取等功能。

### 方法

#### searchMusic(keyword, page, limit)

搜索音乐。

**参数:**

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| keyword | string | 是 | - | 搜索关键词 |
| page | number | 否 | 1 | 页码 |
| limit | number | 否 | 20 | 每页数量 |

**返回值:**

`Promise<MusicModel[]>` - 音乐列表

**示例:**

```typescript
const musicService = MusicService.getInstance()
const results = await musicService.searchMusic('周杰伦', 1, 10)
console.log(results)
```

#### getMusicDetail(id)

获取音乐详情。

**参数:**

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | string | 是 | - | 音乐ID |

**返回值:**

`Promise<MusicModel | null>` - 音乐详情,不存在时返回null

**示例:**

```typescript
const musicService = MusicService.getInstance()
const music = await musicService.getMusicDetail('123')
if (music) {
  console.log(music.name)
}
```
```

---

## 13. 版本管理规范

### 13.1 版本号规范

采用语义化版本(Semantic Versioning): `MAJOR.MINOR.PATCH`

- **MAJOR**: 主版本号,不兼容的API修改
- **MINOR**: 次版本号,向下兼容的功能性新增
- **PATCH**: 修订号,向下兼容的问题修正

示例: `1.2.3`

### 13.2 module.json5配置

```json
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "$string:module_desc",
    "mainElement": "EntryAbility",
    "deviceTypes": [
      "default",
      "tablet"
    ],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "description": "$string:entry_ability_desc",
        "icon": "$media:icon",
        "label": "$string:entry_ability_label",
        "startWindowIcon": "$media:icon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": [
              "entity.system.home"
            ],
            "actions": [
              "action.system.home"
            ]
          }
        ]
      }
    ],
    "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET",
        "reason": "$string:internet_permission_reason",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      },
      {
        "name": "ohos.permission.GET_NETWORK_INFO",
        "reason": "$string:network_info_permission_reason",
        "usedScene": {
          "abilities": [
            "EntryAbility"
          ],
          "when": "inuse"
        }
      }
    ]
  }
}
```

### 13.3 oh-package.json5配置

```json
{
  "name": "harmony-music",
  "version": "1.0.0",
  "description": "鸿蒙音乐播放器应用",
  "main": "",
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "@ohos/axios": "^2.2.0",
    "@ohos/datastore": "^1.0.0"
  },
  "devDependencies": {
    "@ohos/hypium": "1.0.6"
  }
}
```

### 13.4 版本发布流程

1. **更新版本号**
   - 修改 `oh-package.json5` 中的版本号
   - 修改 `module.json5` 中的应用版本

2. **更新CHANGELOG**
   ```markdown
   # 更新日志

   ## [1.0.0] - 2024-01-01

   ### 新增
   - 在线音乐播放功能
   - 音乐搜索功能
   - 收藏管理功能

   ### 修复
   - 修复播放器崩溃问题
   - 修复歌词显示错位问题

   ### 优化
   - 优化启动速度
   - 优化内存占用
   ```

3. **构建发布包**
   ```bash
   # 构建HAP包
   hvigorw assembleHap
   ```

4. **测试验证**
   - 功能测试
   - 性能测试
   - 兼容性测试

5. **发布应用**
   - 上传到华为应用市场
   - 发布更新说明

---

## 14. 最佳实践

### 14.1 代码示例

#### 良好的代码组织

```typescript
// ✅ 推荐: 清晰的代码组织
@Entry
@Component
export struct PlayerPage {
  // ==================== 状态定义 ====================
  @State isPlaying: boolean = false
  @State progress: number = 0
  @State currentTime: string = '00:00'
  @State totalTime: string = '00:00'

  // ==================== 服务引用 ====================
  private playerService: PlayerService = PlayerService.getInstance()
  private musicService: MusicService = MusicService.getInstance()

  // ==================== 生命周期 ====================
  aboutToAppear(): void {
    this.initPlayer()
    this.setupEventListeners()
  }

  aboutToDisappear(): void {
    this.cleanupEventListeners()
  }

  // ==================== 初始化方法 ====================
  private initPlayer(): void {
    this.isPlaying = this.playerService.isPlaying
    this.progress = this.playerService.progress
  }

  private setupEventListeners(): void {
    this.playerService.on('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.on('progressChanged', (progress: number) => {
      this.progress = progress
      this.currentTime = CommonUtils.formatTime(progress)
    })
  }

  private cleanupEventListeners(): void {
    this.playerService.off('playStateChanged', (isPlaying: boolean) => {
      this.isPlaying = isPlaying
    })

    this.playerService.off('progressChanged', (progress: number) => {
      this.progress = progress
    })
  }

  // ==================== 事件处理 ====================
  private handlePlayPause(): void {
    if (this.isPlaying) {
      this.playerService.pauseMusic()
    } else {
      this.playerService.resumeMusic()
    }
  }

  private handlePrevious(): void {
    this.playerService.playPrevious()
  }

  private handleNext(): void {
    this.playerService.playNext()
  }

  private handleSeek(progress: number): void {
    this.playerService.seekTo(progress)
  }

  // ==================== UI构建 ====================
  build() {
    Column() {
      // 歌曲信息
      this.buildMusicInfo()

      // 进度条
      this.buildProgressBar()

      // 控制按钮
      this.buildControlButtons()
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  @Builder
  buildMusicInfo() {
    Column() {
      Text(this.playerService.currentMusic?.name || '暂无播放')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      Text(this.playerService.currentMusic?.singer || '')
        .fontSize(16)
        .fontColor($r('app.color.font_secondary'))
        .margin({ top: 8 })
        .textAlign(TextAlign.Center)
    }
    .margin({ top: 32 })
  }

  @Builder
  buildProgressBar() {
    Column() {
      Slider({
        value: this.progress,
        min: 0,
        max: this.playerService.duration
      })
        .blockColor($r('app.color.primary'))
        .trackColor($r('app.color.divider'))
        .selectedColor($r('app.color.primary'))
        .showSteps(false)
        .onChange((value: number) => {
          this.handleSeek(value)
        })

      Row() {
        Text(this.currentTime)
        Text(this.totalTime)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 8 })
    }
    .margin({ top: 32 })
  }

  @Builder
  buildControlButtons() {
    Row() {
      Button('上一首')
        .onClick(() => {
          this.handlePrevious()
        })

      Button(this.isPlaying ? '暂停' : '播放')
        .width(80)
        .height(80)
        .borderRadius(40)
        .backgroundColor($r('app.color.primary'))
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
    .margin({ top: 32 })
  }
}
```

### 14.2 性能最佳实践

#### 1. 避免频繁的状态更新

```typescript
// ❌ 不推荐: 频繁更新状态
@Entry
@Component
export struct BadExample {
  @State progress: number = 0

  build() {
    Column() {
      Text(`进度: ${this.progress}%`)
    }
    .onAppear(() => {
      // 每秒更新60次,造成性能问题
      setInterval(() => {
        this.progress += 1
      }, 16)
    })
  }
}

// ✅ 推荐: 使用防抖或节流
@Entry
@Component
export struct GoodExample {
  @State progress: number = 0

  build() {
    Column() {
      Text(`进度: ${this.progress}%`)
    }
    .onAppear(() => {
      // 使用节流,每秒只更新10次
      const throttledUpdate = CommonUtils.throttle(() => {
        this.progress += 1
      }, 100)

      setInterval(throttledUpdate, 16)
    })
  }
}
```

#### 2. 合理使用@State和@Prop

```typescript
// ✅ 推荐: 根据场景选择合适的状态装饰器
@Component
export struct MusicItem {
  // 父组件传递的数据,使用@Prop
  @Prop musicInfo: MusicModel

  // 组件内部状态,使用@State
  @State isPlaying: boolean = false

  // 不需要响应式的数据,使用普通属性
  private itemHeight: number = 54

  build() {
    Row() {
      Text(this.musicInfo.name)
      Button(this.isPlaying ? '暂停' : '播放')
        .onClick(() => {
          this.isPlaying = !this.isPlaying
        })
    }
    .height(this.itemHeight)
  }
}
```

#### 3. 使用LazyForEach优化长列表

```typescript
// ✅ 推荐: 使用LazyForEach渲染长列表
@Entry
@Component
export struct MusicListPage {
  @State musicList: MusicModel[] = []

  build() {
    List() {
      LazyForEach(this.musicList, (item: MusicModel, index: number) => {
        ListItem() {
          MusicListItem({
            musicInfo: item,
            index: index
          })
        }
      }, (item: MusicModel, index: number) => item.id)
    }
    .cachedCount(10) // 缓存10个列表项
  }
}
```

### 14.3 安全最佳实践

#### 1. 输入验证

```typescript
// ✅ 推荐: 对用户输入进行验证
export class SearchService {
  async search(keyword: string): Promise<MusicModel[]> {
    // 验证输入
    if (!keyword || keyword.trim().length === 0) {
      throw new Error('搜索关键词不能为空')
    }

    if (keyword.length > 100) {
      throw new Error('搜索关键词过长')
    }

    // 过滤特殊字符
    const sanitizedKeyword = keyword.replace(/[<>\"']/g, '')

    // 执行搜索
    return await this.doSearch(sanitizedKeyword)
  }
}
```

#### 2. 敏感数据保护

```typescript
// ✅ 推荐: 使用加密存储敏感数据
export class StorageService {
  private readonly ENCRYPTION_KEY = 'your-encryption-key'

  async saveToken(token: string): Promise<void> {
    // 加密token
    const encryptedToken = this.encrypt(token)

    // 保存到安全存储
    await preferences.getPreferences(getContext(), 'secure_store')
      .then((prefs) => {
        return prefs.put('token', encryptedToken)
      })
  }

  async getToken(): Promise<string | null> {
    try {
      const prefs = await preferences.getPreferences(getContext(), 'secure_store')
      const encryptedToken = await prefs.get('token', '') as string

      if (!encryptedToken) return null

      // 解密token
      return this.decrypt(encryptedToken)
    } catch (error) {
      console.error('获取token失败:', error)
      return null
    }
  }

  private encrypt(data: string): string {
    // 实现加密逻辑
    return data
  }

  private decrypt(data: string): string {
    // 实现解密逻辑
    return data
  }
}
```

#### 3. 网络安全

```typescript
// ✅ 推荐: 使用HTTPS和证书验证
export class NetworkService {
  private readonly BASE_URL = 'https://api.example.com'

  async request(url: string, options?: http.HttpRequestOptions): Promise<any> {
    const fullUrl = `${this.BASE_URL}${url}`

    const defaultOptions: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      },
      // 启用证书验证
      caPath: '/etc/ssl/certs/ca-certificates.crt',
      // 设置超时
      connectTimeout: 10000,
      readTimeout: 10000
    }

    const mergedOptions = { ...defaultOptions, ...options }

    try {
      const response = await http.createHttp().request(fullUrl, mergedOptions)

      if (response.responseCode === 200) {
        return JSON.parse(response.result as string)
      } else {
        throw new Error(`请求失败: ${response.responseCode}`)
      }
    } catch (error) {
      ErrorHandler.handleError(error as Error, 'NetworkService.request')
      throw error
    }
  }
}
```

### 14.4 可维护性最佳实践

#### 1. 单一职责原则

```typescript
// ✅ 推荐: 每个类/函数只负责一件事
// MusicService只负责音乐相关业务
export class MusicService {
  async searchMusic(keyword: string): Promise<MusicModel[]> {
    // 搜索逻辑
  }

  async getMusicDetail(id: string): Promise<MusicModel> {
    // 获取详情逻辑
  }
}

// PlayerService只负责播放相关业务
export class PlayerService {
  async playMusic(music: MusicModel): Promise<void> {
    // 播放逻辑
  }

  pauseMusic(): void {
    // 暂停逻辑
  }
}

// StorageService只负责数据存储
export class StorageService {
  async saveData(key: string, value: any): Promise<void> {
    // 存储逻辑
  }

  async getData(key: string): Promise<any> {
    // 读取逻辑
  }
}
```

#### 2. 依赖注入

```typescript
// ✅ 推荐: 使用依赖注入提高可测试性
export interface IMusicService {
  searchMusic(keyword: string): Promise<MusicModel[]>
  getMusicDetail(id: string): Promise<MusicModel>
}

export class MusicService implements IMusicService {
  // 实现
}

export class SearchViewModel {
  private musicService: IMusicService

  constructor(musicService: IMusicService) {
    this.musicService = musicService
  }

  async search(keyword: string): Promise<MusicModel[]> {
    return await this.musicService.searchMusic(keyword)
  }
}

// 使用
const musicService = new MusicService()
const searchViewModel = new SearchViewModel(musicService)
```

#### 3. 配置与代码分离

```typescript
// ✅ 推荐: 将配置与代码分离
// config/AppConfig.ets
export class AppConfig {
  static readonly API_BASE_URL = 'https://api.example.com'
  static readonly API_TIMEOUT = 10000
  static readonly MAX_RETRY_COUNT = 3
  static readonly CACHE_EXPIRE_TIME = 5 * 60 * 1000
}

// 在代码中使用
export class NetworkService {
  async request(url: string): Promise<any> {
    const fullUrl = `${AppConfig.API_BASE_URL}${url}`

    return await http.createHttp().request(fullUrl, {
      connectTimeout: AppConfig.API_TIMEOUT
    })
  }
}
```

---

## 总结

本开发规范基于 lx-music-mobile 项目的架构和最佳实践,结合鸿蒙平台特性制定,涵盖了项目结构、技术选型、代码组织、命名规范、状态管理、路由管理、样式规范、资源管理、性能优化、错误处理、测试、文档、版本管理等多个方面。

遵循本规范可以:
- 提高代码质量和可维护性
- 统一团队开发风格
- 提升应用性能
- 便于团队协作
- 降低维护成本

建议团队成员在开发过程中严格遵循本规范,并根据实际情况不断完善和优化。
