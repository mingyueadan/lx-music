import router from '@ohos.router'

/**
 * 路由配置类
 * 统一管理应用的路由跳转
 */
export class RouterConfig {
  // 路由路径常量
  static readonly HOME = 'pages/HomePage'
  static readonly SEARCH = 'pages/SearchPage'
  static readonly PLAYER = 'pages/PlayerDetailPage'
  static readonly SETTING = 'pages/SettingPage'
  static readonly MY_LIST = 'pages/MyListPage'
  static readonly LEADERBOARD = 'pages/LeaderboardPage'
  static readonly SONG_LIST = 'pages/SongListDetailPage'

  /**
   * 导航到首页
   */
  static navigateToHome(): void {
    router.replaceUrl({ url: this.HOME })
  }

  /**
   * 导航到播放器页面
   */
  static navigateToPlayer(params?: Object): void {
    router.pushUrl({ url: this.PLAYER, params })
  }

  /**
   * 导航到搜索页面
   */
  static navigateToSearch(params?: Object): void {
    router.pushUrl({ url: this.SEARCH, params })
  }

  /**
   * 导航到设置页面
   */
  static navigateToSetting(): void {
    router.pushUrl({ url: this.SETTING })
  }

  /**
   * 导航到我的列表页面
   */
  static navigateToMyList(): void {
    router.pushUrl({ url: this.MY_LIST })
  }

  /**
   * 导航到榜单页面
   */
  static navigateToLeaderboard(): void {
    router.pushUrl({ url: this.LEADERBOARD })
  }

  /**
   * 导航到歌单详情页面
   */
  static navigateToSongList(listId: string): void {
    router.pushUrl({ url: this.SONG_LIST, params: { listId } })
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
    router.replaceUrl({ url })
  }
}
