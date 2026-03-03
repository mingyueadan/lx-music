/**
 * 音乐相关类型定义
 * 基于 lx-music-mobile 项目结构完善
 */

/**
 * 音乐信息接口
 */
export interface MusicInfo {
  id: string;
  title: string;
  artist: string;
  album: string;
  cover: string;
  duration: number;
  source: string;
  url?: string;
  songname?: string;
  singername?: string;
  albumname?: string;
  img?: string;
  songmid?: string;
  interval?: string;
  albumId?: string;
  types?: MusicType[];
  _types?: Record<string, MusicType>;
  typeUrl?: Record<string, string>;
  lrc?: string;
}

/**
 * 搜索类型枚举
 */
export enum SearchType {
  MUSIC = 'music',
  SONG_LIST = 'songlist',
  USER_LIST = 'userlist'
}

/**
 * 音乐类型信息
 */
export interface MusicType {
  type: string;
  size?: string | null;
}

/**
 * 热搜数据接口
 */
export interface HotSearch {
  keyword: string;
  hot?: number;
}

/**
 * 音乐搜索结果接口
 */
export interface MusicSearchResult {
  list: MusicInfo[];
  total: number;
  limit?: number;
  page?: number;
  source?: string;
}

/**
 * 歌单信息接口
 */
export interface SongListInfo {
  id: string;
  title: string;
  cover: string;
  author: string;
  description: string;
  songCount: number;
  name?: string;
  author?: string;
  img?: string;
  desc?: string;
  play_count?: string;
}

/**
 * 榜单信息接口
 */
export interface Leaderboard {
  id: string;
  title: string;
  cover: string;
  description: string;
  name?: string;
  source?: string;
  img?: string;
  listenNum?: number;
  songList?: MusicInfo[];
  bangid?: string;
  listenCount?: number;
}

/**
 * 用户列表接口
 */
export interface UserList {
  id: string;
  title: string;
  cover: string;
  songCount: number;
  name?: string;
  listData?: MusicInfo[];
  createAt?: number;
  updateAt?: number;
  location?: string;
}

/**
 * 歌词数据接口
 */
export interface LyricInfo {
  lrc: string;
  lxlyric?: string;
  tlyric?: string;
  rlyric?: string;
  translation?: string;
}

/**
 * 音乐详情接口
 */
export interface MusicDetail {
  songmid: string;
  songname: string;
  singername: string;
  albumname: string;
  interval?: number;
  img?: string;
}

/**
 * 评论信息接口
 */
export interface Comment {
  id: string;
  text: string;
  time: number;
  timeStr?: string;
  location?: string;
  userName: string;
  avatar: string;
  userId: string;
  likedCount?: number;
  rootId?: string;
  reply?: Comment[];
}

/**
 * 评论结果接口
 */
export interface CommentResult {
  comments: Comment[];
  total: number;
  page?: number;
  limit?: number;
  maxPage?: number;
  source?: string;
}

/**
 * 标签信息接口
 */
export interface Tag {
  id: string;
  name: string;
  parent_id?: string;
  parent_name?: string;
  source?: string;
}

/**
 * 标签分类接口
 */
export interface TagCategory {
  name: string;
  list?: Tag[];
}

/**
 * 标签结果接口
 */
export interface TagResult {
  tags?: TagCategory[];
  hotTag?: Tag[];
  source?: string;
}

/**
 * 播放模式枚举
 */
export enum PlayMode {
  LOOP = 'loop',           // 列表循环
  RANDOM = 'random',       // 随机播放
  SINGLE = 'single'          // 单曲循环
}

/**
 * 音乐质量枚举
 */
export enum MusicQuality {
  LOW = '128k',           // 低音质
  STANDARD = '320k',       // 标准音质
  HIGH = 'flac',           // 高音质
  HIRES = 'flac24bit'      // 超高音质
}

/**
 * 音源枚举
 */
export enum MusicSource {
  WY = 'wy',               // 网易云
  TX = 'tx',               // 腾讯
  XM = 'xm'                // 虾米(已禁用)
}

/**
 * 用户信息接口
 */
export interface UserInfo {
  id: string;
  name: string;
  avatar: string;
}

/**
 * 设置接口
 */
export interface Setting {
  // 播放设置
  autoPlay?: boolean;
  playMode?: PlayMode;
  quality?: MusicQuality;
  volume?: number;
  
  // 音源设置
  musicSources?: MusicSource[];
  
  // 界面设置
  darkMode?: boolean;
  
  // 其他设置
  enableLyric?: boolean;
  enableComment?: boolean;
}

/**
 * 下载项接口
 */
export interface DownloadItem {
  id: string;
  musicInfo: MusicInfo;
  quality: MusicQuality;
  progress: number;
  status: 'pending' | 'downloading' | 'completed' | 'failed';
  filePath?: string;
  fileSize?: number;
  downloadedSize?: number;
}

/**
 * 下载列表接口
 */
export interface DownloadList {
  list: DownloadItem[];
  total: number;
}

/**
 * 同步数据接口
 */
export interface SyncData {
  userId?: string;
  token?: string;
  myList?: UserList[];
  dislikeList?: string[];
  setting?: Setting;
  syncTime?: number;
}

/**
 * API 响应基础接口
 */
export interface ApiResponse<T = any> {
  code: number;
  message?: string;
  data?: T;
}

/**
 * 音乐搜索参数接口
 */
export interface MusicSearchParams {
  keyword: string;
  page: number;
  limit?: number;
}

/**
 * 歌单搜索参数接口
 */
export interface SongListSearchParams {
  keyword: string;
  page: number;
  limit?: number;
}

/**
 * 排行榜获取参数接口
 */
export interface LeaderboardParams {
  page?: number;
  limit?: number;
}

/**
 * 评论获取参数接口
 */
export interface CommentParams {
  songmid: string;
  page: number;
  limit?: number;
  type?: 'hot' | 'normal';
}

/**
 * 榜单信息接口（用于页面展示）
 */
export interface LeaderboardInfo {
  id: string;
  title: string;
  name: string;
  source: string;
  img: string;
  listenNum: number;
  description: string;
}
