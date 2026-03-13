# 鸿蒙音乐播放器

> 基于 lx-music-mobile 项目架构的鸿蒙音乐播放器应用

## 项目简介

这是一个基于鸿蒙系统开发的音乐播放器应用,提供完整的音乐播放、搜索、收藏等功能。

## 功能特性

### 核心功能
- 🎵 在线音乐播放
- 🔍 音乐搜索
- ❤️ 收藏管理
- 📝 歌词显示
- 🎯 播放列表管理
- 🔄 播放模式切换
- 📦 本地音乐管理

### 高级功能
- 🌙 深色模式
- 🌍 多语言支持
- ☁️ 数据同步
- 📊 播放统计
- 🔊 音效设置
- 🎨 主题切换

## 技术栈

- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **应用模型**: Stage模型
- **API版本**: API 9+

## 项目结构

```
harmony-music/
├── entry/                          # 主模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/                # ArkTS源代码
│   │   │   │   ├── entryability/   # 应用入口
│   │   │   │   ├── pages/          # 页面组件
│   │   │   │   ├── components/     # 公共组件
│   │   │   │   ├── services/       # 服务层
│   │   │   │   ├── utils/          # 工具函数
│   │   │   │   ├── models/         # 数据模型
│   │   │   │   ├── constants/      # 常量定义
│   │   │   │   ├── config/         # 配置文件
│   │   │   │   ├── event/          # 事件系统
│   │   │   │   └── store/          # 状态管理
│   │   │   └── resources/          # 资源文件
│   │   └── ohosTest/               # 测试代码
│   ├── build-profile.json5
│   └── module.json5
├── oh_modules/
├── build-profile.json5
├── hvigorfile.ts
└── oh-package.json5
```

## 安装运行

### 环境要求

- DevEco Studio 4.0+
- Node.js 16.x+
- HarmonyOS SDK API 9+
- HarmonyOS设备/模拟器

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

## 核心模块

### 播放器模块 (PlayerService)
负责音乐播放的核心功能,包括播放/暂停/停止、进度控制、音量控制等。

### 音乐模块 (MusicService)
负责音乐数据的获取和管理,包括音乐搜索、信息获取、URL获取等。

### 存储模块 (StorageService)
负责数据的持久化存储,包括用户设置、播放列表、收藏列表等。

### 网络模块 (NetworkService)
负责网络请求管理,包括HTTP请求封装、请求缓存、请求重试等。

### 同步模块 (SyncService)
负责多端数据同步,包括数据同步、冲突检测、冲突解决等。

## 开发规范

详见 [开发规范文档](../harmony-app-development-guide.md)

## 开发计划

### 第一阶段: 基础框架搭建 (Week 1-2)
- 创建项目结构
- 配置开发环境
- 实现基础路由
- 创建基础组件库
- 实现状态管理框架

### 第二阶段: 核心功能开发 (Week 3-6)
- 实现播放器服务
- 实现音乐搜索功能
- 实现播放列表管理
- 实现歌词显示
- 实现播放控制

### 第三阶段: 高级功能开发 (Week 7-10)
- 实现收藏功能
- 实现数据同步
- 实现主题切换
- 实现多语言支持
- 实现用户系统

### 第四阶段: 优化与测试 (Week 11-12)
- 性能优化
- 内存优化
- 单元测试
- 集成测试
- UI测试

## 贡献指南

欢迎提交Issue和Pull Request!

## 许可证

MIT License

## 联系方式

- 作者: Your Name
- 邮箱: your.email@example.com

---

**注意**: 本项目基于 lx-music-mobile 项目架构,仅供学习参考使用。
