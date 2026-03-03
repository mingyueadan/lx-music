/**
 * 首页
 * 对应 React Native 版本的 Home 页面
 */

import { MusicInfo, HotSearch, MusicSearchResult } from '../types/Music';
import { MyListPage } from './MyListPage';
import { LeaderboardPage } from './LeaderboardPage';
import { SettingPage } from './SettingPage';
import { playerService, PlayerEventType } from '../services/PlayerService';
import router from '@ohos.router';

/**
 * 首页组件
 */
@Entry
@Component
struct HomePage {
  @State currentTab: number = 0;
  @State searchKeyword: string = '';
  @State searchResults: MusicInfo[] = [];
  @State hotSearches: HotSearch[] = [];
  @State isSearching: boolean = false;
  @State isLoading: boolean = false;
  @State currentMusic: MusicInfo | null = null;

  private searchController: SearchController = new SearchController();

  /**
   * 页面初始化
   */
  aboutToAppear(): void {
    this.loadHotSearch();
    
    // 监听播放器状态变化
    playerService.on(PlayerEventType.PLAYLIST_CHANGED, (event) => {
      this.currentMusic = playerService.getCurrentMusic();
    });
  }

  /**
   * 加载热搜
   */
  private async loadHotSearch(): Promise<void> {
    try {
      // TODO: 从API加载热搜数据
      // 暂时使用模拟数据
      this.hotSearches = [
        { keyword: '周杰伦' },
        { keyword: '林俊杰' },
        { keyword: '邓紫棋' },
        { keyword: '薛之谦' },
        { keyword: '毛不易' },
        { keyword: '李荣浩' },
        { keyword: '华晨宇' },
        { keyword: '张杰' }
      ];
    } catch (error) {
      console.error('Load hot search failed:', error);
    }
  }

  /**
   * 执行搜索
   */
  private async doSearch(): Promise<void> {
    if (!this.searchKeyword || this.searchKeyword.trim().length === 0) {
      return;
    }

    this.isSearching = true;
    this.isLoading = true;

    try {
      // TODO: 从API搜索音乐
      // 暂时使用模拟数据
      this.searchResults = [];
    } catch (error) {
      console.error('Search failed:', error);
      this.searchResults = [];
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 处理热搜点击
   */
  private onHotSearchClick(keyword: string): void {
    this.searchKeyword = keyword;
    this.doSearch();
  }

  /**
   * 处理歌曲点击
   */
  private async onSongClick(music: MusicInfo): Promise<void> {
    this.currentMusic = music;
    
    // 设置播放列表并播放
    playerService.setPlayList([music], 0);
    try {
      await playerService.playMusic(music);
    } catch (error) {
      console.error('Play music failed:', error);
      // 如果播放失败，仍然跳转到详情页
      router.pushUrl({
        url: 'pages/PlayerDetailPage',
        params: {
          music: music
        }
      });
    }
  }

  /**
   * 获取音源名称
   */
  private getSourceName(source: string): string {
    const sourceMap: Record<string, string> = {
      'wy': '网易云',
      'tx': '腾讯',
      'kg': '酷狗',
      'kw': '酷我',
      'mg': '咪咕',
      'bd': '百度',
      'xm': '喜马拉雅'
    };
    return sourceMap[source] || source;
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('洛雪音乐 HarmonyOS')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 主内容区
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          this.buildSearchView()
        }.tabBar('搜索')

        TabContent() {
          MyListPage()
        }.tabBar('我的')

        TabContent() {
          LeaderboardPage()
        }.tabBar('榜单')

        TabContent() {
          SettingPage()
        }.tabBar('设置')
      }
      .barHeight(50)
      .layoutWeight(1)

      // 播放器控制栏（待实现）
      Text('播放器控制栏待实现')
        .width('100%')
        .height(60)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建搜索视图
   */
  @Builder
  buildSearchView() {
    Column() {
      // 搜索框
      Row() {
        Search({
          value: this.searchKeyword,
          placeholder: '搜索音乐、歌手、专辑',
          controller: this.searchController
        })
          .searchButton('搜索')
          .width('100%')
          .backgroundColor('#F0F0F0')
          .borderRadius(8)
          .onSubmit(() => {
            this.doSearch();
          })
          .onChange((value: string) => {
            this.searchKeyword = value;
            if (!value) {
              this.isSearching = false;
              this.searchResults = [];
            }
          })
      }
      .width('100%')
      .padding(16)

      // 内容区
      Scroll() {
        Column() {
          if (this.isLoading) {
            // 加载状态
            this.buildLoadingView()
          } else if (this.isSearching) {
            // 搜索结果
            this.buildSearchResults()
          } else {
            // 热搜
            this.buildHotSearchView()
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建热搜视图
   */
  @Builder
  buildHotSearchView() {
    Column() {
      Text('热搜')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      if (this.hotSearches.length === 0) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#999999')
          .padding(16)
      } else {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.hotSearches, (item: HotSearch, index: number) => {
            Text(item.keyword)
              .fontSize(14)
              .fontColor('#333333')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
              .margin({ right: 12, bottom: 12 })
              .onClick(() => {
                this.onHotSearchClick(item.keyword);
              })
          }, (item: HotSearch) => item.keyword)
        }
        .padding(16)

        Text('支持网易云音乐、腾讯音乐等音源')
          .fontSize(14)
          .fontColor('#CCCCCC')
          .margin({ top: 20 })
      }
    }
    .width('100%')
  }

  /**
   * 构建搜索结果
   */
  @Builder
  buildSearchResults() {
    Column() {
      if (this.searchResults.length === 0) {
        Text('无搜索结果')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 40 })
      } else {
        List({ space: 1 }) {
          ForEach(this.searchResults, (music: MusicInfo, index: number) => {
            ListItem() {
              Row() {
                // 序号
                Text(`${index + 1}`)
                  .fontSize(14)
                  .fontColor('#999999')
                  .width(30)

                // 歌曲信息
                Column() {
                  Text(music.songname || '未知歌曲')
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`${music.singername || '未知歌手'} - ${music.albumname || '未知专辑'}`)
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ top: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                // 音源标识
                Text(this.getSourceName(music.source))
                  .fontSize(11)
                  .fontColor('#999999')
                  .padding({ left: 6, right: 6, top: 3, bottom: 3 })
                  .backgroundColor('#F0F0F0')
                  .borderRadius(4)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                this.onSongClick(music);
              })
            }
          }, (music: MusicInfo) => music.songmid)
        }
        .width('100%')
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }
    }
    .width('100%')
  }

  /**
   * 构建加载视图
   */
  @Builder
  buildLoadingView() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#FF6B6B')
        .margin({ top: 40 })

      Text('搜索中...')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
