/**
 * 我的列表页面
 */

import { UserList, MusicInfo } from '../types/Music';
import { storage } from '../utils/StorageUtil';
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { playerService } from '../services/PlayerService';

/**
 * 我的列表页面组件
 */
@Component
export struct MyListPage {
  @State userLists: UserList[] = [];
  @State currentListId: string = '';

  /**
   * 页面初始化
   */
  async aboutToAppear(): Promise<void> {
    await this.loadUserLists();
  }

  /**
   * 加载用户列表
   */
  private async loadUserLists(): Promise<void> {
    try {
      const savedLists = await storage.getObject<UserList[]>('user_lists');
      if (savedLists && savedLists.length > 0) {
        this.userLists = savedLists;
      } else {
        // 创建默认列表
        this.userLists = [
          {
            id: 'default',
            title: '默认列表',
            name: '默认列表',
            cover: '',
            songCount: 0,
            listData: [],
            createAt: Date.now(),
            updateAt: Date.now()
          },
          {
            id: 'favorite',
            title: '我喜欢的音乐',
            name: '我喜欢的音乐',
            cover: '',
            songCount: 0,
            listData: [],
            createAt: Date.now(),
            updateAt: Date.now()
          }
        ];
        await this.saveUserLists();
      }
    } catch (error) {
      console.error('Load user lists failed:', error);
      // 使用默认列表
      this.userLists = [
        {
          id: 'default',
          title: '默认列表',
          name: '默认列表',
          cover: '',
          songCount: 0,
          listData: [],
          createAt: Date.now(),
          updateAt: Date.now()
        }
      ];
    }
  }

  /**
   * 保存用户列表
   */
  private async saveUserLists(): Promise<void> {
    try {
      await storage.setObject('user_lists', this.userLists);
    } catch (error) {
      console.error('Save user lists failed:', error);
    }
  }

  /**
   * 创建新列表
   */
  private async createNewList(): Promise<void> {
    try {
      const listName = await promptAction.showDialog({
        title: '创建新列表',
        message: '请输入列表名称',
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '确定', color: '#FF6B6B' }
        ]
      });

      if (listName && listName.index === 1) {
        const newList: UserList = {
          id: `list_${Date.now()}`,
          title: '新列表',
          name: '新列表',
          cover: '',
          songCount: 0,
          listData: [],
          createAt: Date.now(),
          updateAt: Date.now()
        };

        this.userLists.push(newList);
        await this.saveUserLists();
      }
    } catch (error) {
      console.error('Create new list failed:', error);
    }
  }

  /**
   * 删除列表
   */
  private async deleteList(listId: string): Promise<void> {
    try {
      const list = this.userLists.find(l => l.id === listId);
      if (!list) {
        return;
      }

      // 确认删除
      const result = await promptAction.showDialog({
        title: '确认删除',
        message: `确定要删除"${list.name}"列表吗？`,
        buttons: [
          { text: '取消', color: '#999999' },
          { text: '删除', color: '#FF4444' }
        ]
      });

      if (result && result.index === 1) {
        this.userLists = this.userLists.filter(l => l.id !== listId);
        await this.saveUserLists();
      }
    } catch (error) {
      console.error('Delete list failed:', error);
    }
  }

  /**
   * 打开列表
   */
  private openList(list: UserList): void {
    // 跳转到歌单详情页面
    router.pushUrl({
      url: 'pages/SongListDetailPage',
      params: {
        listInfo: {
          id: list.id,
          name: list.name,
          title: list.title,
          source: 'local',
          description: `${list.name} - ${list.songCount}首歌曲`,
          songCount: list.songCount
        }
      }
    });
  }

  /**
   * 播放列表
   */
  private async playList(list: UserList): Promise<void> {
    if (!list.listData || list.listData.length === 0) {
      console.log('List is empty');
      return;
    }

    try {
      // 设置播放列表并播放第一首
      playerService.setPlayList(list.listData, 0);
      await playerService.playMusic(list.listData[0]);

      // 跳转到播放详情页面
      router.pushUrl({
        url: 'pages/PlayerDetailPage',
        params: {
          music: list.listData[0]
        }
      });
    } catch (error) {
      console.error('Play list failed:', error);
    }
  }

  /**
   * 格式化时间
   */
  private formatDate(timestamp: number): string {
    if (!timestamp) return '';
    const date = new Date(timestamp);
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  }

  /**
   * 构建页面
   */
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('我的列表')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('新建')
          .fontSize(14)
          .onClick(() => {
            this.createNewList();
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 列表内容
      if (this.userLists.length === 0) {
        Column() {
          Text('📋')
            .fontSize(80)
            .margin({ top: 40 })

          Text('暂无列表')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 16 })

          Button('创建第一个列表')
            .margin({ top: 24 })
            .onClick(() => {
              this.createNewList();
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.userLists, (list: UserList, index: number) => {
            ListItem() {
              this.buildListItem(list, index)
            }
          }, (list: UserList) => list.id)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 12 })
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  /**
   * 构建列表项
   */
  @Builder
  buildListItem(list: UserList, index: number) {
    Row() {
      // 列表图标
      Column() {
        Text((list.title || list.name || '').substring(0, 1))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
      }
      .width(50)
      .height(50)
      .borderRadius(8)
      .backgroundColor(this.getListColor(index))
      .justifyContent(FlexAlign.Center)

      // 列表信息
      Column() {
        Text(list.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        if (list.listData) {
          Text(`${list.listData.length} 首歌曲`)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
        }

        if (list.updateAt) {
          Text(`更新于 ${this.formatDate(list.updateAt)}`)
            .fontSize(12)
            .fontColor('#CCCCCC')
            .margin({ top: 2 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })

      // 播放按钮
      if (list.listData && list.listData.length > 0) {
        Button('播放')
          .fontSize(14)
          .backgroundColor('#FF6B6B')
          .fontColor('#FFFFFF')
          .margin({ right: 8 })
          .onClick(() => {
            this.playList(list);
          })
      }

      // 操作按钮
      Button('编辑')
        .fontSize(14)
        .backgroundColor('#F0F0F0')
        .fontColor('#333333')
        .margin({ right: 8 })
        .onClick(() => {
          console.log('Edit list:', list.id);
        })

      Button('删除')
        .fontSize(14)
        .backgroundColor('#FFE5E5')
        .fontColor('#FF4444')
        .onClick(() => {
          this.deleteList(list.id);
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .onClick(() => {
      this.openList(list);
    })
  }

  /**
   * 获取列表颜色
   */
  private getListColor(index: number): string {
    const colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEEAD', '#FFD93D', '#6C5CE7', '#A29BFE'];
    return colors[index % colors.length];
  }
}
