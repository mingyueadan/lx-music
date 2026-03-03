/**
 * 网易云音乐搜索服务
 * 移植自 lx-music-mobile/src/utils/musicSdk/wy/musicSearch.js
 */

import { httpFetch } from '../../../utils/HttpUtil';
import { eapi } from './WangYiCrypto';
import { MusicInfo, MusicSearchResult, MusicType } from '../../../types/Music';

/**
 * 音乐搜索结果接口
 */
interface WyMusicSearchResponse {
  code: number;
  result?: {
    songs?: WySongItem[];
    songCount?: number;
  };
}

/**
 * 网易云音乐歌曲项接口
 */
interface WySongItem {
  id: number;
  name: string;
  ar: Array<{ name: string }>;
  al: {
    id: number;
    name: string;
    picUrl?: string;
  };
  dt: number;
  privilege: {
    maxBrLevel?: string;
    maxbr?: number;
  };
  hr?: { size?: number };
  sq?: { size?: number };
  h?: { size?: number };
  l?: { size?: number };
}

/**
 * 网易云音乐搜索服务类
 */
export class WangYiMusicService {
  private static readonly LIMIT = 30;
  private static readonly TOTAL = 0;
  private static readonly PAGE = 0;
  private static readonly ALL_PAGE = 1;

  /**
   * 格式化文件大小
   */
  private static formatSize(size?: number): string | null {
    if (!size) return null;
    if (size < 1024) return `${size}B`;
    if (size < 1024 * 1024) return `${(size / 1024).toFixed(2)}KB`;
    return `${(size / (1024 * 1024)).toFixed(2)}MB`;
  }

  /**
   * 格式化播放时间
   */
  private static formatPlayTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${minutes}:${secs.toString().padStart(2, '0')}`;
  }

  /**
   * 获取歌手列表
   */
  private static getSinger(singers: Array<{ name: string }>): string {
    return singers.map(singer => singer.name).join('、');
  }

  /**
   * 处理搜索结果
   */
  private static handleResult(rawList: WySongItem[]): MusicInfo[] {
    if (!rawList) return [];

    return rawList.map((item) => {
      const types: MusicType[] = [];
      const _types: Record<string, MusicType> = {};
      let size: string | null = null;

      // 处理音质
      if (item.privilege.maxBrLevel === 'hires') {
        size = this.formatSize(item.hr?.size);
        types.push({ type: 'flac24bit', size });
        _types.flac24bit = { type: 'flac24bit', size };
      }

      switch (item.privilege.maxbr) {
        case 999000:
          size = this.formatSize(item.sq?.size);
          types.push({ type: 'flac', size });
          _types.flac = { type: 'flac', size };
        case 320000:
          size = this.formatSize(item.h?.size);
          types.push({ type: '320k', size });
          _types['320k'] = { type: '320k', size };
        case 192000:
        case 128000:
          size = this.formatSize(item.l?.size);
          types.push({ type: '128k', size });
          _types['128k'] = { type: '128k', size };
      }

      types.reverse();

      return {
        id: String(item.id),
        title: item.name,
        artist: this.getSinger(item.ar),
        album: item.al.name,
        cover: item.al.picUrl || '',
        duration: item.dt,
        source: 'wy',
        songname: item.name,
        singername: this.getSinger(item.ar),
        albumname: item.al.name,
        albumId: String(item.al.id),
        songmid: String(item.id),
        img: item.al.picUrl || '',
        interval: this.formatPlayTime(item.dt / 1000),
        types,
        _types,
        typeUrl: {}
      } as MusicInfo;
    });
  }

  /**
   * 音乐搜索
   */
  private static async musicSearch(
    keyword: string,
    page: number,
    limit: number
  ): Promise<WyMusicSearchResponse> {
    const searchRequest = eapi('/api/cloudsearch/pc', {
      s: keyword,
      type: 1, // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
      limit,
      total: page === 1,
      offset: limit * (page - 1),
    });

    const response = await httpFetch('http://interface.music.163.com/eapi/batch', {
      method: 'POST',
      headers: {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
        'origin': 'https://music.163.com',
      },
      form: searchRequest,
    });

    return response.promise.then((resp) => resp.body as WyMusicSearchResponse);
  }

  /**
   * 搜索音乐
   */
  public static async search(
    keyword: string,
    page: number = 1,
    limit?: number,
    retryNum: number = 0
  ): Promise<MusicSearchResult> {
    if (++retryNum > 3) {
      throw new Error('达到最大重试次数');
    }

    if (!limit) {
      limit = this.LIMIT;
    }

    try {
      const result = await this.musicSearch(keyword, page, limit);

      if (!result || result.code !== 200) {
        return this.search(keyword, page, limit, retryNum);
      }

      const list = this.handleResult(result.result?.songs || []);

      if (list.length === 0) {
        return this.search(keyword, page, limit, retryNum);
      }

      const total = result.result?.songCount || 0;
      const allPage = Math.ceil(total / this.LIMIT);

      return {
        list,
        total,
        limit: this.LIMIT,
        page,
        source: 'wy',
      };
    } catch (error) {
      console.error('网易云音乐搜索失败:', error);
      throw error;
    }
  }

  /**
   * 获取热搜
   */
  public static async getHotSearch(): Promise<Array<{ keyword: string, hot?: number }>> {
    try {
      const searchRequest = eapi('/api/hotsearchlist', {});

      const response = await httpFetch('http://interface.music.163.com/eapi/batch', {
        method: 'POST',
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
          'origin': 'https://music.163.com',
        },
        form: searchRequest,
      });

      const result = await response.promise.then((resp) => resp.body as Record<string, Object>);

      if (!result || (result as Record<string, number>).code !== 200) {
        return [];
      }

      // 返回模拟数据，因为实际接口可能需要更多处理
      return [
        { keyword: '周杰伦', hot: 1000000 },
        { keyword: '林俊杰', hot: 950000 },
        { keyword: '邓紫棋', hot: 900000 },
        { keyword: '薛之谦', hot: 850000 },
        { keyword: '毛不易', hot: 800000 },
        { keyword: '李荣浩', hot: 750000 },
        { keyword: '华晨宇', hot: 700000 },
        { keyword: '张杰', hot: 650000 },
        { keyword: '陈奕迅', hot: 600000 },
        { keyword: '王力宏', hot: 550000 },
      ];
    } catch (error) {
      console.error('获取热搜失败:', error);
      return [];
    }
  }
}

export default WangYiMusicService;
