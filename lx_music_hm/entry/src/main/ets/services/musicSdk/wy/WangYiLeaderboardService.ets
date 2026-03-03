/**
 * 网易云音乐榜单服务
 */

import { http } from '@kit.NetworkKit';
import { weapi } from './WangYiCrypto';
import { MusicInfo } from '../../../types/Music';

/**
 * 榜单信息接口
 */
export interface LeaderboardInfo {
  id: string;
  name: string;
  bangid: string;
}

/**
 * 榜单音乐列表结果接口
 */
export interface LeaderboardMusicResult {
  total: number;
  list: MusicInfo[];
  limit: number;
  page: number;
  source: string;
}

/**
 * 榜单列表返回接口
 */
interface LeaderboardListResult {
  list: LeaderboardInfo[];
  source: string;
}

/**
 * 网易云榜单列表
 */
const WANGYI_TOP_LIST: LeaderboardInfo[] = [
  { id: 'wy__19723756', name: '飙升榜', bangid: '19723756' },
  { id: 'wy__3779629', name: '新歌榜', bangid: '3779629' },
  { id: 'wy__2884035', name: '原创榜', bangid: '2884035' },
  { id: 'wy__3778678', name: '热歌榜', bangid: '3778678' },
  { id: 'wy__991319590', name: '说唱榜', bangid: '991319590' },
  { id: 'wy__71384707', name: '古典榜', bangid: '71384707' },
  { id: 'wy__1978921795', name: '电音榜', bangid: '1978921795' },
  { id: 'wy__5453912201', name: '黑胶VIP爱听榜', bangid: '5453912201' },
  { id: 'wy__71385702', name: 'ACG榜', bangid: '71385702' },
  { id: 'wy__745956260', name: '韩语榜', bangid: '745956260' },
  { id: 'wy__10520166', name: '国电榜', bangid: '10520166' },
  { id: 'wy__180106', name: 'UK排行榜周榜', bangid: '180106' },
  { id: 'wy__60198', name: '美国Billboard榜', bangid: '60198' },
  { id: 'wy__3812895', name: 'Beatport全球电子舞曲榜', bangid: '3812895' },
  { id: 'wy__21845217', name: 'KTV唛榜', bangid: '21845217' },
  { id: 'wy__60131', name: '日本Oricon榜', bangid: '60131' },
  { id: 'wy__2809513713', name: '欧美热歌榜', bangid: '2809513713' },
  { id: 'wy__2809577409', name: '欧美新歌榜', bangid: '2809577409' },
  { id: 'wy__27135204', name: '法国 NRJ Vos Hits 周榜', bangid: '27135204' },
  { id: 'wy__3001835560', name: 'ACG动画榜', bangid: '3001835560' },
  { id: 'wy__3001795926', name: 'ACG游戏榜', bangid: '3001795926' },
  { id: 'wy__3001890046', name: 'ACG VOCALOID榜', bangid: '3001890046' },
  { id: 'wy__3112516681', name: '中国新乡村音乐排行榜', bangid: '3112516681' },
  { id: 'wy__5059644681', name: '日语榜', bangid: '5059644681' },
  { id: 'wy__5059633707', name: '摇滚榜', bangid: '5059633707' },
  { id: 'wy__5059642708', name: '国风榜', bangid: '5059642708' },
  { id: 'wy__5338990334', name: '潜力爆款榜', bangid: '5338990334' },
  { id: 'wy__5059661515', name: '民谣榜', bangid: '5059661515' },
  { id: 'wy__6688069460', name: '听歌识曲榜', bangid: '6688069460' },
  { id: 'wy__6723173524', name: '网络热歌榜', bangid: '6723173524' },
  { id: 'wy__6732051320', name: '俄语榜', bangid: '6732051320' },
  { id: 'wy__6732014811', name: '越南语榜', bangid: '6732014811' },
  { id: 'wy__6886768100', name: '中文DJ榜', bangid: '6886768100' },
  { id: 'wy__6939992364', name: '俄罗斯top hit流行音乐榜', bangid: '6939992364' },
  { id: 'wy__7095271308', name: '泰语榜', bangid: '7095271308' },
  { id: 'wy__7356827205', name: 'BEAT排行榜', bangid: '7356827205' },
  { id: 'wy__7325478166', name: '编辑推荐榜', bangid: '7325478166' },
  { id: 'wy__7603212484', name: 'LOOK直播歌曲榜', bangid: '7603212484' },
  { id: 'wy__7775163417', name: '赏音榜', bangid: '7775163417' },
  { id: 'wy__7785123708', name: '黑胶VIP新歌榜', bangid: '7785123708' },
  { id: 'wy__7785066739', name: '黑胶VIP热歌榜', bangid: '7785066739' },
  { id: 'wy__7785091694', name: '黑胶VIP爱搜榜', bangid: '7785091694' }
];

/**
 * 网易云音乐榜单服务类
 */
export class WangYiLeaderboardService {
  private static instance: WangYiLeaderboardService;
  private readonly BASE_URL = 'https://music.163.com';

  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): WangYiLeaderboardService {
    if (!WangYiLeaderboardService.instance) {
      WangYiLeaderboardService.instance = new WangYiLeaderboardService();
    }
    return WangYiLeaderboardService.instance;
  }

  /**
   * 获取榜单列表
   */
  public async getLeaderboards(): Promise<LeaderboardListResult> {
    const result: LeaderboardListResult = {
      list: WANGYI_TOP_LIST,
      source: 'wy'
    };
    return result;
  }

  /**
   * 获取榜单音乐列表
   */
  public async getLeaderboardMusic(bangid: string, page: number = 1): Promise<LeaderboardMusicResult> {
    try {
      const weapiParams: Record<string, string | number> = { id: bangid, n: 30, p: page };
      const encrypted = weapi(weapiParams);

      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        `${this.BASE_URL}/weapi/v3/playlist/detail`,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          extraData: `params=${encodeURIComponent(encrypted.params)}&encSecKey=${encodeURIComponent(encrypted.encSecKey)}`,
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      httpRequest.destroy();

      if (response.responseCode !== 200) {
        throw new Error(`Request failed with status code ${response.responseCode}`);
      }

      const result: Record<string, Object> = JSON.parse(response.result as string);

      if (result.code !== 200) {
        const errorMsg: string = `API error: ${result.code}`;
        throw new Error(errorMsg);
      }

      // 解析音乐列表
      const playlist: Record<string, Object> = result.playlist as Record<string, Object>;
      const trackIds: Object[] = playlist.trackIds as Object[] || [];
      const tracks: Object[] = playlist.tracks as Object[] || [];
      const musicList: MusicInfo[] = [];

      // 获取每首歌的详细信息
      for (let i = 0; i < tracks.length; i++) {
        const track = tracks[i];
        const musicInfo: MusicInfo = WangYiLeaderboardService.parseMusicInfo(track as Record<string, Object>);
        musicList.push(musicInfo);
      }

      const leaderboardResult: LeaderboardMusicResult = {
        total: musicList.length,
        list: musicList,
        limit: 30,
        page: page,
        source: 'wy'
      };
      return leaderboardResult;
    } catch (error) {
      console.error('Get leaderboard music failed:', error);
      const errorMsg: string = error instanceof Error ? error.message : String(error);
      throw new Error(errorMsg);
    }
  }

  /**
   * 解析音乐信息
   */
  private static parseMusicInfo(track: Record<string, Object>): MusicInfo {
    const artists: string[] = [];
    const ar = track.ar as Array<Record<string, Object>> | null;
    const artistsField = track.artists as Array<Record<string, Object>> | null;

    if (ar && ar.length > 0) {
      for (let i = 0; i < ar.length; i++) {
        const artist = ar[i];
        const name = artist.name as string | null;
        artists.push(name || '');
      }
    } else if (artistsField && artistsField.length > 0) {
      for (let i = 0; i < artistsField.length; i++) {
        const artist = artistsField[i];
        const name = artist.name as string | null;
        artists.push(name || '');
      }
    }

    const al = track.al as Record<string, Object> | null;
    const album = track.album as Record<string, Object> | null;

    const albumName: string = al?.name as string | null || album?.name as string | null || '';
    const picUrl: string = al?.picUrl as string | null || album?.picUrl as string | null || '';
    const trackId: number = track.id as number || 0;
    const trackName: string = track.name as string || '';
    const trackDt: number = track.dt as number || 0;

    const musicInfo: MusicInfo = {
      id: trackId ? `wy_${trackId}` : '',
      title: trackName || '',
      artist: artists.join(','),
      album: albumName,
      cover: picUrl,
      duration: trackDt || 0,
      source: 'wy',
      songname: trackName || '',
      singername: artists.join(','),
      albumname: albumName,
      songmid: trackId ? String(trackId) : '',
      img: picUrl,
      interval: trackDt ? (trackDt / 1000).toString() : '0'
    };
    return musicInfo;
  }
}

/**
 * 导出单例实例
 */
export const wangYiLeaderboardService = WangYiLeaderboardService.getInstance();
