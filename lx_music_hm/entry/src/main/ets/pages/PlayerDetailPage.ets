/**
 * 播放详情页面
 * 对应 React Native 版本的 PlayDetail 页面
 */

import { MusicInfo } from '../types/Music';
import { playerService, PlayerEventType, PlayState, PlayStateData, ProgressData, PlaylistData } from '../services/PlayerService';
import router from '@ohos.router';

/**
 * 歌词行接口
 */
interface LyricLine {
  time: number;
  text: string;
}

/**
 * 播放详情页面组件
 */
@Entry
@Component
struct PlayerDetailPage {
  @State currentMusic: MusicInfo | null = null;
  @State isPlaying: boolean = false;
  @State currentPageIndex: number = 0; // 0: 封面页, 1: 歌词页
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State lyricLines: LyricLine[] = [];
  @State currentLyricIndex: number = 0;
  @State volume: number = 80;

  private swiperController: SwiperController = new SwiperController();

  /**
   * 页面初始化
   */
  aboutToAppear(): void {
    // 从路由参数获取当前音乐
    const params = router.getParams() as Record<string, Object>;
    if (params?.['music']) {
      this.currentMusic = params['music'] as MusicInfo;
    }
    
    // 获取播放器当前音乐
    const music = playerService.getCurrentMusic();
    if (music) {
      this.currentMusic = music;
    }
    
    // 监听播放器事件
    playerService.on(PlayerEventType.STATE_CHANGE, (event) => {
      const stateData = event.data as PlayStateData;
      this.isPlaying = stateData.state === PlayState.PLAYING;
    });

    playerService.on(PlayerEventType.PROGRESS_CHANGE, (event) => {
      const progressData = event.data as ProgressData;
      this.currentTime = progressData.time;
      this.duration = this.duration;
      this.updateCurrentLyricIndex();
    });

    playerService.on(PlayerEventType.PLAYLIST_CHANGED, (event) => {
      const playlistData = event.data as PlaylistData;
      if (playlistData.list.length > 0 && playlistData.index >= 0) {
        this.currentMusic = playlistData.list[playlistData.index];
        this.loadLyric();
      }
    });
    
    // 加载歌词
    this.loadLyric();
  }

  /**
   * 页面销毁
   */
  aboutToDisappear(): void {
    // 移除事件监听
    playerService.off(PlayerEventType.STATE_CHANGE);
    playerService.off(PlayerEventType.PROGRESS_CHANGE);
    playerService.off(PlayerEventType.PLAYLIST_CHANGED);
  }

  /**
   * 加载歌词
   */
  private async loadLyric(): Promise<void> {
    if (!this.currentMusic) {
      this.lyricLines = [];
      return;
    }
    
    try {
      // TODO: 从音乐SDK加载歌词
      // 暂时使用模拟数据
      this.lyricLines = [
        { time: 0, text: '暂无歌词' },
        { time: 5, text: '第一句歌词' },
        { time: 10, text: '第二句歌词' },
        { time: 15, text: '第三句歌词' },
        { time: 20, text: '第四句歌词' }
      ];
    } catch (error) {
      console.error('Load lyric failed:', error);
      this.lyricLines = [];
    }
  }

  /**
   * 更新当前歌词索引
   */
  private updateCurrentLyricIndex(): void {
    if (this.lyricLines.length === 0) {
      this.currentLyricIndex = 0;
      return;
    }
    
    for (let i = this.lyricLines.length - 1; i >= 0; i--) {
      if (this.currentTime >= this.lyricLines[i].time) {
        this.currentLyricIndex = i;
        return;
      }
    }
    this.currentLyricIndex = 0;
  }

  /**
   * 格式化时间
   */
  private formatTime(seconds: number): string {
    if (!seconds || seconds < 0) return '00:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  /**
   * 播放/暂停
   */
  private async togglePlay(): Promise<void> {
    try {
      if (this.isPlaying) {
        await playerService.pause();
      } else {
        await playerService.resume();
      }
    } catch (error) {
      console.error('Toggle play failed:', error);
    }
  }

  /**
   * 上一首
   */
  private async playPrevious(): Promise<void> {
    try {
      await playerService.playPrev();
    } catch (error) {
      console.error('Play previous failed:', error);
    }
  }

  /**
   * 下一首
   */
  private async playNext(): Promise<void> {
    try {
      await playerService.playNext();
    } catch (error) {
      console.error('Play next failed:', error);
    }
  }

  /**
   * 跳转进度
   */
  private async seekTo(time: number): Promise<void> {
    try {
      await playerService.seek(time);
      this.currentTime = time;
      this.updateCurrentLyricIndex();
    } catch (error) {
      console.error('Seek to failed:', error);
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
      // 顶部导航栏
      this.buildHeader()

      // 主内容区 - 使用Swiper切换封面和歌词
      Swiper(this.swiperController) {
        // 封面页
        Column() {
          this.buildCoverPage()
        }

        // 歌词页
        Column() {
          this.buildLyricPage()
        }
      }
      .index(this.currentPageIndex)
      .loop(false)
      .indicator(false)
      .layoutWeight(1)
      .onChange((index: number) => {
        this.currentPageIndex = index;
      })

      // 页面指示器
      Row() {
        Circle({ width: 6, height: 6 })
          .fill(this.currentPageIndex === 0 ? '#FF6B6B' : '#E0E0E0')
          .margin({ right: 8 })

        Circle({ width: 6, height: 6 })
          .fill(this.currentPageIndex === 1 ? '#FF6B6B' : '#E0E0E0')
      }
      .width('100%')
      .height(20)
      .justifyContent(FlexAlign.Center)

      // 播放控制
      this.buildPlayerControls()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建顶部导航栏
   */
  @Builder
  buildHeader() {
    Row() {
      Button('返回')
        .fontSize(14)
        .backgroundColor(Color.Transparent)
        .fontColor('#333333')
        .onClick(() => {
          router.back();
        })

      if (this.currentMusic) {
        Column() {
          Text(this.currentMusic.songname || '未知歌曲')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.currentMusic.singername || '未知歌手')
            .fontSize(12)
            .fontColor('#999999')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 16, right: 16 })
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
  }

  /**
   * 构建封面页
   */
  @Builder
  buildCoverPage() {
    Column() {
      // 专辑封面
      if (this.currentMusic?.img) {
        Image(this.currentMusic.img)
          .width(280)
          .height(280)
          .borderRadius(16)
          .objectFit(ImageFit.Cover)
          .shadow({
            radius: 20,
            color: 'rgba(0, 0, 0, 0.2)',
            offsetX: 0,
            offsetY: 8
          })
      } else {
        // 默认封面
        Text('♪')
          .fontSize(80)
          .fontColor('#E0E0E0')
          .width(280)
          .height(280)
          .textAlign(TextAlign.Center)
          .borderRadius(16)
          .backgroundColor('#FFFFFF')
          .shadow({
            radius: 20,
            color: 'rgba(0, 0, 0, 0.2)',
            offsetX: 0,
            offsetY: 8
          })
      }

      // 歌曲信息
      if (this.currentMusic) {
        Column() {
          Text(this.currentMusic.songname || '未知歌曲')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 32 })

          Text(this.currentMusic.singername || '未知歌手')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 8 })

          Row() {
            Text(this.currentMusic.albumname || '未知专辑')
              .fontSize(12)
              .fontColor('#CCCCCC')
              .margin({ top: 4 })

            if (this.currentMusic.source) {
              Text(this.getSourceName(this.currentMusic.source))
                .fontSize(11)
                .fontColor('#FF6B6B')
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .backgroundColor('rgba(255, 107, 107, 0.1)')
                .borderRadius(4)
                .margin({ left: 8, top: 4 })
            }
          }
        }
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 构建歌词页
   */
  @Builder
  buildLyricPage() {
    Column() {
      if (this.lyricLines.length === 0) {
        Text('暂无歌词')
          .fontSize(16)
          .fontColor('#CCCCCC')
          .margin({ top: 100 })
      } else {
        List({ space: 16 }) {
          ForEach(this.lyricLines, (line: LyricLine, index: number) => {
            ListItem() {
              Text(line.text)
                .fontSize(16)
                .fontWeight(this.currentLyricIndex === index ? FontWeight.Medium : FontWeight.Normal)
                .fontColor(this.currentLyricIndex === index ? '#FF6B6B' : '#CCCCCC')
                .textAlign(TextAlign.Center)
                .width('100%')
            }
          }, (line: LyricLine, index: number) => `${index}_${line.time}`)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 32, right: 32 })
        .alignListItem(ListItemAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建播放控制
   */
  @Builder
  buildPlayerControls() {
    Column() {
      // 进度条
      Column() {
        Slider({
          value: this.currentTime,
          min: 0,
          max: this.duration || 100,
          step: 1,
          style: SliderStyle.OutSet
        })
          .width('100%')
          .blockColor('#FF6B6B')
          .trackColor('#E0E0E0')
          .selectedColor('#FF6B6B')
          .showSteps(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.seekTo(value);
          })

        Row() {
          Text(this.formatTime(this.currentTime))
            .fontSize(12)
            .fontColor('#999999')

          Blank()

          Text(this.formatTime(this.duration))
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .width('100%')
      .padding({ left: 32, right: 32 })
      .margin({ top: 16 })

      // 播放按钮
      Row() {
        // 上一首
        Button() {
          Text('⏮')
            .fontSize(24)
            .fontColor('#333333')
        }
        .width(48)
        .height(48)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.playPrevious();
        })

        // 播放/暂停
        Button() {
          Image(this.isPlaying ? $r('sys.media.ohos_ic_public_pause') : $r('sys.media.ohos_ic_public_play'))
            .width(40)
            .height(40)
            .fillColor('#FFFFFF')
        }
        .width(64)
        .height(64)
        .backgroundColor('#FF6B6B')
        .borderRadius(32)
        .margin({ left: 24, right: 24 })
        .onClick(() => {
          this.togglePlay();
        })

        // 下一首
        Button() {
          Image($r('sys.media.ohos_ic_public_play_next'))
            .width(24)
            .height(24)
            .fillColor('#333333')
        }
        .width(48)
        .height(48)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.playNext();
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 24, bottom: 32 })

      // 音量控制
      Row() {
        Image($r('sys.media.ohos_ic_public_minus'))
          .width(20)
          .height(20)
          .fillColor('#999999')

        Slider({
          value: this.volume,
          min: 0,
          max: 100,
          step: 1,
          style: SliderStyle.OutSet
        })
          .width('60%')
          .blockColor('#FF6B6B')
          .trackColor('#E0E0E0')
          .selectedColor('#FF6B6B')
          .showSteps(false)
          .margin({ left: 16, right: 16 })
          .onChange((value: number, mode: SliderChangeMode) => {
            this.volume = value;
            // TODO: 设置播放器音量
          })

        Image($r('sys.media.ohos_ic_public_add'))
          .width(20)
          .height(20)
          .fillColor('#999999')
      }
      .width('100%')
      .padding({ left: 32, right: 32 })
      .margin({ bottom: 24 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 24, topRight: 24 })
    .padding({ top: 24, bottom: 24 })
  }
}
