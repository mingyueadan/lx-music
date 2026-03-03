/**
 * 音乐 SDK 基类
 * 定义音乐SDK的通用接口
 */

import { MusicInfo, MusicSearchResult, MusicDetail, LyricInfo, Leaderboard, HotSearch, Comment } from '../../types/Music';

/**
 * 音乐SDK基类
 */
export abstract class MusicSdkBase {
  /**
   * 音乐搜索
   */
  abstract musicSearch(keyword: string, page: number, limit: number): Promise<MusicSearchResult>;

  /**
   * 获取音乐播放URL
   */
  abstract getMusicUrl(songmid: string, quality?: string): Promise<string>;

  /**
   * 获取音乐详情
   */
  abstract getMusicDetail(songmid: string): Promise<MusicDetail>;

  /**
   * 获取歌词
   */
  abstract getLyric(songmid: string): Promise<LyricInfo>;

  /**
   * 歌单搜索
   */
  abstract songListSearch(keyword: string, page: number, limit: number): Promise<Object>;

  /**
   * 获取歌单详情
   */
  abstract songListDetail(listId: string): Promise<Object>;

  /**
   * 获取排行榜列表
   */
  abstract getLeaderboardList(): Promise<Leaderboard[]>;

  /**
   * 获取排行榜详情
   */
  abstract getLeaderboardDetail(leaderboardId: string): Promise<Leaderboard>;

  /**
   * 获取热搜
   */
  abstract getHotSearch(): Promise<Object>;

  /**
   * 获取评论
   */
  abstract getComment(songmid: string, page: number, limit: number): Promise<Object>;

  /**
   * 获取音源标识
   */
  abstract getSource(): string;
}
