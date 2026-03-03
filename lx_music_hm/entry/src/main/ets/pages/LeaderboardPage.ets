/**
 * 榜单页面
 * 对应 React Native 版本的 Leaderboard 页面
 */

import { Leaderboard, LeaderboardInfo as PageLeaderboardInfo, MusicInfo } from '../types/Music';
import { playerService, PlayerEventType } from '../services/PlayerService';
import { wangYiLeaderboardService, LeaderboardInfo as WYLeaderboardInfo } from '../services/musicSdk/wy/WangYiLeaderboardService';
import router from '@ohos.router';

/**
 * 榜单项接口
 */
interface LeaderboardItem {
  id: string;
  name: string;
  bangid?: string;
}

/**
 * 榜单页面组件
 */
@Component
export struct LeaderboardPage {
  @State currentSource: string = 'wy';
  @State currentBoardId: string = '';
  @State currentBoardName: string = '';
  @State leaderboards: PageLeaderboardInfo[] = [];
  @State isLoading: boolean = true;
  @State showBoardList: boolean = false;
  @State musicList: MusicInfo[] = [];
  @State isLoadingMusic: boolean = false;

  private sources: string[] = ['wy', 'tx', 'kg', 'kw', 'mg', 'bd'];

  /**
   * 页面初始化
   */
  aboutToAppear(): void {
    this.loadLeaderboards('wy');

    // 监听播放器事件
    playerService.on(PlayerEventType.PLAYLIST_CHANGED, (event) => {
      // 处理播放列表变化
    });
  }

  /**
   * 页面销毁
   */
  aboutToDisappear(): void {
    playerService.off(PlayerEventType.PLAYLIST_CHANGED);
  }

  /**
   * 加载榜单列表
   */
  private async loadLeaderboards(source: string): Promise<void> {
    this.isLoading = true;
    this.currentSource = source;

    try {
      let boards: PageLeaderboardInfo[] = [];

      // 只有网易云有榜单API
      if (source === 'wy') {
        const result = await wangYiLeaderboardService.getLeaderboards();
        boards = result.list.map((board: WYLeaderboardInfo): PageLeaderboardInfo => {
          const leaderboardInfo: PageLeaderboardInfo = {
            id: board.id,
            title: board.name,
            name: board.name,
            source: source,
            img: '',
            listenNum: 0,
            description: ''
          };
          return leaderboardInfo;
        });
      } else {
        // 其他音源使用模拟数据
        boards = this.getMockLeaderboards(source);
      }

      this.leaderboards = boards;

      // 默认选择第一个榜单
      if (boards.length > 0) {
        this.currentBoardId = boards[0].id;
        this.currentBoardName = boards[0].name;
        await this.loadBoardMusic(source, boards[0].id, '');
      }

      this.isLoading = false;
    } catch (error) {
      console.error('Load leaderboards failed:', error);
      // 出错时使用模拟数据
      const boards = this.getMockLeaderboards(source);
      this.leaderboards = boards;
      if (boards.length > 0) {
        this.currentBoardId = boards[0].id;
        this.currentBoardName = boards[0].name;
        this.musicList = this.getMockMusicList(source, boards[0].id);
      }
      this.isLoading = false;
    }
  }

  /**
   * 获取模拟榜单数据
   */
  private getMockLeaderboards(source: string): PageLeaderboardInfo[] {
    const sourceMap: Record<string, PageLeaderboardInfo[]> = {
      'wy': [
        { id: 'wy_hot', title: '热歌榜', name: '热歌榜', source: 'wy', img: '', listenNum: 12345678, description: '热歌榜单' },
        { id: 'wy_new', title: '新歌榜', name: '新歌榜', source: 'wy', img: '', listenNum: 56789012, description: '新歌榜单' },
        { id: 'wy_original', title: '原创榜', name: '原创榜', source: 'wy', img: '', listenNum: 34567890, description: '原创榜单' },
        { id: 'wy_soar', title: '飙升榜', name: '飙升榜', source: 'wy', img: '', listenNum: 78901234, description: '飙升榜单' },
        { id: 'wy_billboard', title: '云音乐榜', name: '云音乐榜', source: 'wy', img: '', listenNum: 90123456, description: '云音乐榜' }
      ],
      'tx': [
        { id: 'tx_hot', title: '热歌榜', name: '热歌榜', source: 'tx', img: '', listenNum: 23456789, description: '热歌榜单' },
        { id: 'tx_new', title: '新歌榜', name: '新歌榜', source: 'tx', img: '', listenNum: 67890123, description: '新歌榜单' },
        { id: 'tx_original', title: '原创榜', name: '原创榜', source: 'tx', img: '', listenNum: 45678901, description: '原创榜单' },
        { id: 'tx_billboard', title: '巅峰榜', name: '巅峰榜', source: 'tx', img: '', listenNum: 12345678, description: '巅峰榜单' }
      ],
      'kg': [
        { id: 'kg_hot', title: 'TOP500', name: 'TOP500', source: 'kg', img: '', listenNum: 345678901, description: 'TOP500榜单' },
        { id: 'kg_new', title: '新歌榜', name: '新歌榜', source: 'kg', img: '', listenNum: 23456789, description: '新歌榜单' },
        { id: 'kg_billboard', title: '飙升榜', name: '飙升榜', source: 'kg', img: '', listenNum: 56789012, description: '飙升榜单' }
      ],
      'kw': [
        { id: 'kw_hot', title: '热歌榜', name: '热歌榜', source: 'kw', img: '', listenNum: 45678901, description: '热歌榜单' },
        { id: 'kw_new', title: '新歌榜', name: '新歌榜', source: 'kw', img: '', listenNum: 67890123, description: '新歌榜单' },
        { id: 'kw_billboard', title: '榜单', name: '榜单', source: 'kw', img: '', listenNum: 12345678, description: '榜单' }
      ],
      'mg': [
        { id: 'mg_hot', title: '热歌榜', name: '热歌榜', source: 'mg', img: '', listenNum: 56789012, description: '热歌榜单' },
        { id: 'mg_billboard', title: '新歌榜', name: '新歌榜', source: 'mg', img: '', listenNum: 78901234, description: '新歌榜单' }
      ],
      'bd': [
        { id: 'bd_hot', title: '热歌榜', name: '热歌榜', source: 'bd', img: '', listenNum: 67890123, description: '热歌榜单' },
        { id: 'bd_billboard', title: '榜单', name: '榜单', source: 'bd', img: '', listenNum: 345678901, description: '榜单' }
      ]
    };

    return sourceMap[source] || [];
  }

  /**
   * 加载榜单音乐
   */
  private async loadBoardMusic(source: string, boardId: string, bangid?: string): Promise<void> {
    this.isLoadingMusic = true;
    this.currentBoardId = boardId;

    try {
      const board = this.leaderboards.find(b => b.id === boardId);
      if (board) {
        this.currentBoardName = board.name;
      }

      // 只有网易云有榜单API
      if (source === 'wy' && bangid) {
        const result = await wangYiLeaderboardService.getLeaderboardMusic(bangid, 1);
        this.musicList = result.list;
      } else {
        // 其他音源使用模拟数据
        this.musicList = this.getMockMusicList(source, boardId);
      }

      this.isLoadingMusic = false;
    } catch (error) {
      console.error('Load board music failed:', error);
      // 出错时使用模拟数据
      this.musicList = this.getMockMusicList(source, boardId);
      this.isLoadingMusic = false;
    }
  }

  /**
   * 获取模拟音乐列表
   */
  private getMockMusicList(source: string, boardId: string): MusicInfo[] {
    // 返回模拟音乐列表
    const mockMusic = (index: number): MusicInfo => ({
      id: `${source}_${boardId}_${index}`,
      title: `歌曲${index + 1}`,
      artist: '歌手',
      album: '专辑',
      cover: '',
      duration: 0,
      source: source,
      songname: `歌曲${index + 1}`,
      singername: '歌手',
      albumname: '专辑',
      songmid: `${source}_${boardId}_${index}`,
      img: '',
      interval: '0'
    });

    const list: MusicInfo[] = [];
    for (let i = 0; i < 20; i++) {
      list.push(mockMusic(i));
    }
    return list;
  }

  /**
   * 格式化播放量
   */
  private formatPlayCount(count: number): string {
    if (count >= 100000000) {
      return `${(count / 100000000).toFixed(1)}亿`;
    } else if (count >= 10000) {
      return `${(count / 10000).toFixed(1)}万`;
    }
    return count.toString();
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
   * 处理音源切换
   */
  private onSourceChange(source: string): void {
    this.currentSource = source;
    this.showBoardList = false;
    this.loadLeaderboards(source);
  }

  /**
   * 处理榜单选择
   */
  private onBoardSelect(board: Leaderboard): void {
    this.currentBoardId = board.id || '';
    this.currentBoardName = board.name || '';
    this.showBoardList = false;
    const bangid = board.id?.replace('wy__', '') || '';
    this.loadBoardMusic(board.source || '', board.id || '', bangid);
  }

  /**
   * 处理歌曲点击
   */
  private async onSongClick(music: MusicInfo): Promise<void> {
    try {
      // 设置播放列表并播放
      playerService.setPlayList([music], 0);
      await playerService.playMusic(music);

      // 跳转到播放页面
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
   * 构建页面
   */
  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 主内容区
      Column() {
        // 标题栏
        Row() {
          Text('榜单')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)

          // 音源选择按钮
          Button(this.getSourceName(this.currentSource))
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#F0F0F0')
            .borderRadius(16)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .onClick(() => {
              this.showBoardList = true;
            })

          // 榜单选择按钮
          Button(this.currentBoardName || '选择榜单')
            .fontSize(14)
            .fontColor('#333333')
            .backgroundColor('#F0F0F0')
            .borderRadius(16)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .margin({ left: 8 })
            .onClick(() => {
              this.showBoardList = true;
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor('#FFFFFF')

        // 内容区
        if (this.isLoading) {
          this.buildLoadingView()
        } else if (this.isLoadingMusic) {
          this.buildMusicLoadingView()
        } else {
          this.buildMusicListView()
        }
      }
      .width('100%')
      .height('100%')

      // 音源选择弹窗
      if (this.showBoardList) {
        this.buildSourceSelector()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5F')
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

      Text('正在加载榜单...')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 构建音乐加载视图
   */
  @Builder
  buildMusicLoadingView() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color('#FF6B6B')
        .margin({ top: 40 })

      Text(`正在加载${this.currentBoardName}...`)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 构建音乐列表视图
   */
  @Builder
  buildMusicListView() {
    Column() {
      // 榜单信息
      Row() {
        Text(this.currentBoardName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text(this.getSourceName(this.currentSource))
          .fontSize(12)
          .fontColor('#999999')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('rgba(0, 0, 0, 0.05)')
          .borderRadius(8)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      // 音乐列表
      if (this.musicList.length === 0) {
        Text('暂无歌曲')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 40 })
          .width('100%')
          .textAlign(TextAlign.Center)
      } else {
        List({ space: 1 }) {
          ForEach(this.musicList, (music: MusicInfo, index: number) => {
            ListItem() {
              Row() {
                // 序号
                Text(`${index + 1}`)
                  .fontSize(14)
                  .fontColor('#999999')
                  .width(30)

                // 歌曲信息
                Column() {
                  Text(music.songname || music.title || '未知歌曲')
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Row() {
                    Text(music.singername || music.artist || '未知歌手')
                      .fontSize(12)
                      .fontColor('#999999')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text(' - ' + (music.albumname || music.album || '未知专辑'))
                      .fontSize(12)
                      .fontColor('#CCCCCC')
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                this.onSongClick(music);
              })
            }
          }, (music: MusicInfo, index: number) => music.songmid || music.id || `${index}`)
        }
        .width('100%')
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  /**
   * 构建音源选择器
   */
  @Builder
  buildSourceSelector() {
    Column() {
      // 遮罩层
      Row()
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('rgba(0, 0, 0, 0.3)')
        .onClick(() => {
          this.showBoardList = false;
        })

      // 选择面板
      Column() {
        // 音源选择
        Text('选择音源')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 24, bottom: 12 })

        Column({ space: 1 }) {
          ForEach(this.sources, (source: string) => {
            Row() {
              Text(this.getSourceName(source))
                .fontSize(16)
                .layoutWeight(1)

              if (this.currentSource === source) {
                Image($r('sys.media.ohos_ic_public_ok'))
                  .width(20)
                  .height(20)
                  .fillColor('#FF6B6B')
              }
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              if (this.currentSource !== source) {
                this.onSourceChange(source);
              }
            })
          }, (source: string) => source)

          Divider()

          // 榜单选择
          Text('选择榜单')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 16 })

          Column({ space: 1 }) {
            ForEach(this.leaderboards, (board: Leaderboard) => {
              Row() {
                Text(board.name)
                  .fontSize(16)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                if (this.currentBoardId === board.id) {
                  Image($r('sys.media.ohos_ic_public_ok'))
                    .width(20)
                    .height(20)
                    .fillColor('#FF6B6B')
                }
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                if (this.currentBoardId !== board.id) {
                  this.onBoardSelect(board);
                }
              })
            }, (board: Leaderboard) => board.id)
          }
        }
      }
      .width('80%')
      .height(400)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .padding({ left: 16, right: 16, top: 24, bottom: 24 })
      .margin({ top: 16 })
      .shadow({
        radius: 16,
        color: 'rgba(0, 0, 0, 0.2)',
        offsetX: 0,
        offsetY: 4
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
