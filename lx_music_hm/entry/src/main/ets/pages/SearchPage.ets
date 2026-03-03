/**
 * 搜索页面
 * 对应 React Native 版本的 Search 页面
 */

import { MusicInfo, HotSearch, MusicSearchResult, SearchType } from '../types/Music';
import { playerService, PlayerEventType } from '../services/PlayerService';
import { SettingManager } from '../utils/SettingManager';
import router from '@ohos.router';
import { WangYiMusicService } from '../services/musicSdk/wy/WangYiMusicService';

/**
 * 搜索状态
 */
interface SearchState {
  temp_source: string;
  source: string;
  searchType: SearchType;
}

/**
 * 搜索信息
 */
interface SearchInfo {
  searchText: string;
  source: string;
  searchType: SearchType;
}

/**
 * 搜索页面组件
 */
@Entry
@Component
struct SearchPage {
  @State searchKeyword: string = '';
  @State searchResults: MusicInfo[] = [];
  @State hotSearches: HotSearch[] = [];
  @State tipList: string[] = [];
  @State isSearching: boolean = false;
  @State isLoading: boolean = false;
  @State showTipList: boolean = false;
  @State currentMusic: MusicInfo | null = null;
  
  @State searchSources: string[] = ['wy', 'tx', 'kg', 'kw', 'mg', 'bd'];
  @State currentSource: string = 'wy';
  @State searchType: SearchType = 'music';
  @State layoutHeight: number = 0;

  private searchController: SearchController = new SearchController();
  private searchInfo: SearchInfo = {
    searchText: '',
    source: 'wy',
    searchType: 'music'
  };
  private debounceTimer: number = -1;

  /**
   * 页面初始化
   */
  aboutToAppear(): void {
    this.loadSearchSettings();
    this.loadHotSearch();
    
    // 监听播放器状态变化
    playerService.on(PlayerEventType.PLAYLIST_CHANGED, (event) => {
      this.currentMusic = playerService.getCurrentMusic();
    });
  }

  /**
   * 加载搜索设置
   */
  private async loadSearchSettings(): Promise<void> {
    try {
      const settings = await SettingManager.getSearchSettings();
      this.currentSource = settings.source || 'wy';
      this.searchType = settings.type || 'music';
      this.searchInfo.source = this.currentSource;
      this.searchInfo.searchType = this.searchType;
    } catch (error) {
      console.error('Load search settings failed:', error);
    }
  }

  /**
   * 加载热搜
   */
  private async loadHotSearch(): Promise<void> {
    try {
      this.hotSearches = await WangYiMusicService.getHotSearch();
    } catch (error) {
      console.error('Load hot search failed:', error);
      // 使用默认热搜数据
      this.hotSearches = [
        { keyword: '周杰伦' },
        { keyword: '林俊杰' },
        { keyword: '邓紫棋' },
        { keyword: '薛之谦' },
        { keyword: '毛不易' },
        { keyword: '李荣浩' },
        { keyword: '华晨宇' },
        { keyword: '张杰' },
        { keyword: '陈奕迅' },
        { keyword: '王力宏' }
      ];
    }
  }

  /**
   * 执行搜索
   */
  private async doSearch(keyword: string): Promise<void> {
    if (!keyword || keyword.trim().length === 0) {
      return;
    }

    this.isSearching = true;
    this.isLoading = true;
    this.showTipList = false;
    this.searchInfo.searchText = keyword;

    try {
      // TODO: 从API搜索音乐
      // 暂时使用模拟数据
      if (this.searchType === 'music') {
        this.searchResults = await this.searchMusic(keyword, this.currentSource);
      } else {
        // 歌单搜索待实现
        this.searchResults = [];
      }
      
      // 保存搜索历史
      await this.saveSearchHistory(keyword);
    } catch (error) {
      console.error('Search failed:', error);
      this.searchResults = [];
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 搜索音乐
   */
  private async searchMusic(keyword: string, source: string): Promise<MusicInfo[]> {
    try {
      // 根据音源选择对应的搜索服务
      if (source === 'wy') {
        const result = await WangYiMusicService.search(keyword, 1, 30);
        return result.list;
      } else if (source === 'tx') {
        // TODO: 添加腾讯音乐搜索
        return [];
      } else {
        // 其他音源暂未实现
        return [];
      }
    } catch (error) {
      console.error('搜索音乐失败:', error);
      return [];
    }
  }

  /**
   * 保存搜索历史
   */
  private async saveSearchHistory(keyword: string): Promise<void> {
    try {
      const history = await SettingManager.getSearchHistory();
      const newHistory = [keyword, ...history.filter(item => item !== keyword)].slice(0, 50);
      await SettingManager.saveSearchHistory(newHistory);
    } catch (error) {
      console.error('Save search history failed:', error);
    }
  }

  /**
   * 提示搜索（防抖）
   */
  private tipSearch(keyword: string): void {
    if (this.debounceTimer !== -1) {
      clearTimeout(this.debounceTimer);
    }
    
    if (!keyword || keyword.trim().length === 0) {
      this.tipList = [];
      return;
    }

    this.debounceTimer = setTimeout(async () => {
      try {
        // TODO: 调用提示搜索API
        // 暂时使用模拟数据
        this.tipList = [];
        this.showTipList = true;
      } catch (error) {
        console.error('Tip search failed:', error);
        this.tipList = [];
      }
    }, 200);
  }

  /**
   * 处理热搜点击
   */
  private onHotSearchClick(keyword: string): void {
    this.searchKeyword = keyword;
    this.doSearch(keyword);
  }

  /**
   * 处理提示词点击
   */
  private onTipClick(keyword: string): void {
    this.searchKeyword = keyword;
    this.showTipList = false;
    this.doSearch(keyword);
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
      router.pushUrl({
        url: 'pages/PlayerDetailPage',
        params: {
          music: music
        }
      });
    } catch (error) {
      console.error('Play music failed:', error);
    }
  }

  /**
   * 处理音源切换
   */
  private onSourceChange(source: string): void {
    this.currentSource = source;
    this.searchInfo.source = source;
    SettingManager.saveSearchSettings({ source });
    
    // 如果正在搜索，重新搜索
    if (this.isSearching && this.searchInfo.searchText) {
      this.doSearch(this.searchInfo.searchText);
    }
  }

  /**
   * 处理搜索类型切换
   */
  private onSearchTypeChange(type: SearchType): void {
    this.searchType = type;
    this.searchInfo.searchType = type;
    SettingManager.saveSearchSettings({ type });
    
    // 清空搜索结果
    this.searchResults = [];
    this.isSearching = false;
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
      'xm': '喜马拉雅',
      'all': '全部'
    };
    return sourceMap[source] || source;
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 搜索头部
      this.buildSearchHeader()

      // 主内容区
      Stack({ alignContent: Alignment.Top }) {
        // 搜索结果/热搜
        if (this.isSearching) {
          this.buildSearchResults()
        } else {
          this.buildHotSearchView()
        }

        // 提示列表
        if (this.showTipList) {
          this.buildTipList()
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建搜索头部
   */
  @Builder
  buildSearchHeader() {
    Column() {
      // 搜索类型和音源选择
      Row() {
        // 搜索类型
        Row() {
          Text(this.searchType === 'music' ? '音乐' : '歌单')
            .fontSize(14)
            .fontColor('#333333')
          
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .width(12)
            .height(12)
            .margin({ left: 4 })
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F0F0F0')
        .borderRadius(16)
        .onClick(() => {
          // TODO: 显示搜索类型选择器
          this.onSearchTypeChange(this.searchType === 'music' ? 'songlist' : 'music');
        })

        Blank()

        // 音源选择
        Row() {
          Text(this.getSourceName(this.currentSource))
            .fontSize(14)
            .fontColor('#333333')
          
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .width(12)
            .height(12)
            .margin({ left: 4 })
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('#F0F0F0')
        .borderRadius(16)
        .onClick(() => {
          // TODO: 显示音源选择器
          const currentIndex = this.searchSources.indexOf(this.currentSource);
          const nextIndex = (currentIndex + 1) % this.searchSources.length;
          this.onSourceChange(this.searchSources[nextIndex]);
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      // 搜索框
      Row() {
        Search({
          value: this.searchKeyword,
          placeholder: '搜索音乐、歌手、专辑',
          controller: this.searchController
        })
          .searchButton('搜索')
          .width('100%')
          .height(40)
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .placeholderColor('#CCCCCC')
          .textFont({ size: 15 })
          .onSubmit(() => {
            this.doSearch(this.searchKeyword);
          })
          .onChange((value: string) => {
            this.searchKeyword = value;
            if (!value) {
              this.isSearching = false;
              this.searchResults = [];
              this.showTipList = false;
            } else {
              this.tipSearch(value);
            }
          })
          .onFocus(() => {
            if (this.searchKeyword) {
              this.tipSearch(this.searchKeyword);
            }
          })
          .onBlur(() => {
            if (this.debounceTimer !== -1) {
              clearTimeout(this.debounceTimer);
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
  }

  /**
   * 构建热搜视图
   */
  @Builder
  buildHotSearchView() {
    Scroll() {
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
              Text(`${index + 1} ${item.keyword}`)
                .fontSize(14)
                .fontColor(index < 3 ? '#FF6B6B' : '#333333')
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
    .width('100%')
    .height('100%')
  }

  /**
   * 构建搜索结果
   */
  @Builder
  buildSearchResults() {
    Column() {
      if (this.isLoading) {
        // 加载状态
        this.buildLoadingView()
      } else if (this.searchResults.length === 0) {
        // 无结果
        Column() {
          Text('无搜索结果')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 40 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 搜索结果列表
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
          }, (music: MusicInfo) => music.songmid || `${music.songname}_${music.singername}`)
        }
        .width('100%')
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建提示列表
   */
  @Builder
  buildTipList() {
    Column() {
      ForEach(this.tipList, (item: string, index: number) => {
        Row() {
          Image($r('sys.media.ohos_ic_public_search'))
            .width(16)
            .height(16)
            .margin({ right: 12 })

          Text(item)
            .fontSize(14)
            .fontColor('#333333')
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          this.onTipClick(item);
        })
      }, (item: string, index: number) => `${index}_${item}`)

      // 遮罩层
      Row()
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('rgba(0, 0, 0, 0.3)')
        .onClick(() => {
          this.showTipList = false;
        })
    }
    .width('100%')
    .height('100%')
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
