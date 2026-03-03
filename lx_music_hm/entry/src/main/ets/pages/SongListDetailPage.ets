/**
 * 歌曲列表详情页面
 */

import { MusicInfo, SongListInfo } from '../types/Music';
import { playerService } from '../services/PlayerService';
import { WangYiSongListService } from '../services/musicSdk/wy/WangYiSongListService';
import router from '@ohos.router';

/**
 * 歌曲列表详情页面组件
 */
@Entry
@Component
struct SongListDetailPage {
  @State listInfo: SongListInfo | null = null;
  @State songList: MusicInfo[] = [];
  @State isLoading: boolean = true;

  /**
   * 页面初始化
   */
  aboutToAppear(): void {
    // 从路由参数获取列表信息
    const params = router.getParams() as Record<string, Object>;
    if (params?.['listInfo']) {
      this.listInfo = params['listInfo'] as SongListInfo;
      this.loadSongList();
    }
  }

  /**
   * 加载歌曲列表
   */
  private async loadSongList(): Promise<void> {
    this.isLoading = true;
    try {
      if (!this.listInfo?.id) {
        throw new Error('歌单ID不存在');
      }

      // 根据音源加载歌单详情
        const listSource: string = this.listInfo.id.startsWith('wy__') ? 'wy' : 'local';

      if (listSource === 'wy') {
          const result = await WangYiSongListService.getSongListDetail(this.listInfo.id, 1);
        this.songList = result.list;

        // 更新列表信息
        if (result.info) {
          const listInfo: SongListInfo = {
            id: result.info.id,
            title: result.info.title,
            name: result.info.name,
            cover: result.info.cover,
            img: result.info.img,
            author: result.info.author,
            description: result.info.description,
            desc: result.info.desc,
            songCount: result.info.songCount,
          };
          this.listInfo = listInfo;
        }
      } else {
        // 其他音源暂未实现
        this.songList = [];
      }
    } catch (error) {
      console.error('加载歌曲列表失败:', error);
      this.songList = [];
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 处理歌曲点击
   */
  private async onSongClick(music: MusicInfo): Promise<void> {
    try {
      // 设置播放列表
      playerService.setPlayList(this.songList, this.songList.indexOf(music));

      // 播放音乐
      await playerService.playMusic(music);

      // 跳转到播放详情页面
      router.pushUrl({
        url: 'pages/PlayerDetailPage',
        params: {
          music: music
        }
      });
    } catch (error) {
      console.error('播放音乐失败:', error);
    }
  }

  /**
   * 播放全部
   */
  private async playAll(): Promise<void> {
    if (this.songList.length === 0) {
      return;
    }

    try {
      // 设置播放列表
      playerService.setPlayList(this.songList, 0);

      // 播放第一首
      await playerService.playMusic(this.songList[0]);

      // 跳转到播放详情页面
      router.pushUrl({
        url: 'pages/PlayerDetailPage',
        params: {
          music: this.songList[0]
        }
      });
    } catch (error) {
      console.error('播放全部失败:', error);
    }
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button('返回')
          .fontSize(14)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text(this.listInfo?.title || '歌曲列表')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Button('⋯')
          .fontSize(14)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            console.log('More options');
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 主内容区
      Scroll() {
        Column() {
          if (this.isLoading) {
            // 加载状态
            this.buildLoadingView()
          } else {
            // 列表信息
            this.buildListInfo()

            // 歌曲列表
            this.buildSongList()
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建列表信息
   */
  @Builder
  buildListInfo() {
    Column() {
      // 封面图
      if (this.listInfo?.cover) {
        Image(this.listInfo.cover)
          .width(160)
          .height(160)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
          .margin({ top: 24 })
      }

      // 标题
      Text(this.listInfo?.name || '未知列表')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16 })

      // 歌曲列表标题
      Text(this.listInfo?.title || '歌曲列表')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 8 })

      // 操作按钮
      Row() {
        Button('播放全部')
          .fontSize(14)
          .backgroundColor('#FF6B6B')
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .onClick(() => {
            this.playAll();
          })

        Button('收藏')
          .fontSize(14)
          .backgroundColor('#F0F0F0')
          .layoutWeight(1)
          .margin({ left: 12 })
          .onClick(() => {
            console.log('Favorite');
          })
      }
      .width('100%')
      .padding(24)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
    .padding({ bottom: 16 })
    .margin({ bottom: 8 })
  }

  /**
   * 构建歌曲列表
   */
  @Builder
  buildSongList() {
    Column() {
      Text(`共 ${this.songList.length} 首歌曲`)
        .fontSize(14)
        .fontColor('#999999')
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 12 })

      if (this.songList.length === 0) {
        Text('暂无歌曲')
          .fontSize(14)
          .fontColor('#999999')
          .padding(16)
      } else {
        List({ space: 1 }) {
          ForEach(this.songList, (music: MusicInfo, index: number) => {
            ListItem() {
              Row() {
                // 序号
                Text(`${index + 1}`)
                  .fontSize(14)
                  .fontColor('#999999')
                  .width(40)

                // 歌曲信息
                Column() {
                  Text(music.songname || '未知歌曲')
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(music.singername || '未知歌手')
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ top: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                // 时长
                Text(this.formatDuration(music.interval ? Number(music.interval) : 0))
                  .fontSize(12)
                  .fontColor('#999999')
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                this.onSongClick(music);
              })
            }
          })
        }
        .width('100%')
        .divider({ strokeWidth: 1, color: '#F0F0F0' })
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
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

      Text('加载中...')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 格式化时长
   */
  private formatDuration(seconds: number): string {
    if (!seconds || seconds < 0) return '00:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
}
