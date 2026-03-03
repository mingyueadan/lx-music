/**
 * 网易云音乐歌单服务
 * 移植自 lx-music-mobile/src/utils/musicSdk/wy/songList.js
 */

import http from '@ohos.net.http';
import { httpFetch } from '../../../utils/HttpUtil';
import { linuxapi, LinuxapiResult, eapi, EapiResult } from './WangYiCrypto';
import { MusicInfo, SongListInfo } from '../../../types/Music';

/**
 * 歌曲 URL 参数接口
 */
interface SongUrlParams {
  ids: string;
  br: number;
  level: string;
  encodeType: string;
}

/**
 * Linux API 请求参数接口
 */
interface LinuxApiRequestParams {
  method: http.RequestMethod;
  url: string;
  params: {
    id: string;
    n: number;
    s: number;
  };
}

/**
 * EAPI 搜索参数接口
 */
interface EapiSearchParams {
  s: string;
  type: number;
  limit: number;
  total: boolean;
  offset: number;
}

/**
 * 歌单详情响应接口
 */
interface WySongListDetailResponse {
  code: number;
  playlist?: {
    id: number;
    name: string;
    coverImgUrl: string;
    description: string;
    creator: {
      nickname: string;
    };
    playCount: number;
    trackIds: Array<{ id: number }>;
    tracks?: WyTrackItem[];
  };
  privileges?: WyPrivilegeItem[];
}

/**
 * 歌曲项接口
 */
interface WyTrackItem {
  id: number;
  name: string;
  ar: Array<{ name: string }>;
  al: {
    id: number;
    name: string;
    picUrl?: string;
  };
  dt: number;
  hr?: { size?: number };
  h?: { size?: number };
  l?: { size?: number };
  pc?: {
    ar?: string;
    sn?: string;
    alb?: string;
  };
}

/**
 * 权限项接口
 */
interface WyPrivilegeItem {
  id: number;
  maxBrLevel?: string;
  maxbr?: number;
}

/**
 * 歌单详情结果接口
 */
interface SongListDetailResult {
  list: MusicInfo[];
  info: SongListInfo;
  total: number;
  source: string;
}

/**
 * 音质类型接口
 */
interface QualityType {
  type: string;
  size: string | null;
}

/**
 * 音乐类型接口
 */
interface MusicTypesInterface {
  flac24bit?: QualityType;
  flac?: QualityType;
  '320k'?: QualityType;
  '128k'?: QualityType;
}

/**
 * 搜索歌单返回接口
 */
interface SearchSongListResult {
  list: SongListInfo[];
  total: number;
  source: string;
}

/**
 * 网易云音乐歌单服务类
 */
export class WangYiSongListService {
  private static readonly LIMIT_SONG = 100000;
  private static readonly SUCCESS_CODE = 200;

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
   * 格式化播放次数
   */
  private static formatPlayCount(count: number): string {
    if (count >= 100000000) {
      return `${(count / 100000000).toFixed(1)}亿`;
    } else if (count >= 10000) {
      return `${(count / 10000).toFixed(1)}万`;
    }
    return String(count);
  }

  /**
   * 获取歌手列表
   */
  private static getSinger(singers: Array<{ name: string }>): string {
    return singers.map(singer => singer.name).join('、');
  }

  /**
   * 过滤列表详情
   */
  private static filterListDetail(data: WySongListDetailResponse): MusicInfo[] {
    const tracks = data.playlist?.tracks || [];
    const privileges = data.privileges || [];
    const list: MusicInfo[] = [];

    for (let index = 0; index < tracks.length; index++) {
      const item = tracks[index];
      const types: QualityType[] = [];
      const _types: MusicTypesInterface = {};
      let size: string | null = null;

      let privilege: WyPrivilegeItem | undefined = privileges[index];
      if (privilege && privilege.id !== item.id) {
        privilege = privileges.find(p => p.id === item.id);
      }

      if (!privilege) continue;

      // 处理音质
      if (privilege.maxBrLevel === 'hires') {
        size = item.hr ? WangYiSongListService.formatSize(item.hr.size) : null;
        const qualityType: QualityType = { type: 'flac24bit', size: null };
        types.push(qualityType);
        _types.flac24bit = qualityType;
      }

      // 根据最大比特率处理音质类型
      switch (privilege.maxbr) {
        case 999000:
          if (!_types.flac24bit) {
            size = null;
            const qualityType1: QualityType = { type: 'flac', size: null };
            types.push(qualityType1);
            _types.flac = qualityType1;
          }
          break;
        case 320000:
          if (!_types.flac && !_types.flac24bit) {
            size = item.h ? WangYiSongListService.formatSize(item.h.size) : null;
            const qualityType2: QualityType = { type: '320k', size: size };
            types.push(qualityType2);
              _types.flac = qualityType2;
          }
          break;
        case 128000:
              _types['128k'] = qualityType3;
            size = item.l ? WangYiSongListService.formatSize(item.l.size) : null;
            const qualityType3: QualityType = { type: '128k', size: size };
            types.push(qualityType3);
              _types['128k'] = qualityType3;
          }
          break;
      }

      // 创建音乐信息对象
      let musicInfo: MusicInfo;

      // 检查是否有pc字段(可能包含版权信息)
      if (item.pc && item.pc.sn) {
        musicInfo = {
          id: String(item.id),
          title: item.pc.sn ?? '',
          artist: item.pc.ar ?? '',
          album: item.pc.alb ?? '',
          albumId: item.al?.id ? String(item.al.id) : '',
          cover: item.al?.picUrl ?? '',
          duration: item.dt,
          source: 'wy',
          songname: item.pc.sn ?? '',
          singername: item.pc.ar ?? '',
          albumname: item.pc.alb ?? '',
          songmid: String(item.id),
          img: item.al?.picUrl ?? '',
          interval: WangYiSongListService.formatPlayTime(item.dt / 1000),
          types,
          _types,
          typeUrl: {},
        } as MusicInfo;
      } else {
        musicInfo = {
          id: String(item.id),
          title: item.name ?? '',
          artist: WangYiSongListService.getSinger(item.ar),
          album: item.al?.name,
          albumId: item.al?.id ? String(item.al.id) : '',
          cover: item.al?.picUrl ?? '',
          duration: item.dt,
          source: 'wy',
          songname: item.name ?? '',
          singername: WangYiSongListService.getSinger(item.ar),
          albumname: item.al?.name,
          songmid: String(item.id),
          img: item.al?.picUrl,
          interval: WangYiSongListService.formatPlayTime(item.dt / 1000),
          types,
          _types,
          typeUrl: {},
        } as MusicInfo;
      }

      list.push(musicInfo);
    }

    return list;
  }

  /**
   * 获取歌单详情
   */
  public static async getSongListDetail(songListId: string, page: number = 1): Promise<SongListDetailResult> {
    try {
      const requestParamsObj: Record<string, string | number | boolean> = {
        id: songListId,
        n: WangYiSongListService.LIMIT_SONG,
        s: 8,
      };
      const requestParams: LinuxapiResult = linuxapi(requestParamsObj);

      const response = await httpFetch('https://music.163.com/api/linux/forward', {
        method: http.RequestMethod.POST,
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
        },
        form: { eparams: requestParams.eparams },
      });

      const resp = await response.promise;
      const body = resp.body;

      if (typeof body === 'string' || typeof body === 'object') {
          const result = body as unknown as WySongListDetailResponse;

        if (!result || result.code !== WangYiSongListService.SUCCESS_CODE) {
          throw new Error('获取歌单详情失败');
        }

        const playlist = result.playlist;
        if (!playlist) {
          throw new Error('歌单数据为空');
        }

        let list: MusicInfo[];
        // 如果有完整的歌曲数据，直接使用
        if (playlist.trackIds.length === (result.privileges?.length || 0)) {
          list = WangYiSongListService.filterListDetail(result);
        } else {
         
          throw new Error('获取歌单详情失败');
        }

        const info: SongListInfo = {
          id: `wy__${playlist.id}`,
          title: playlist.name,
          cover: playlist.coverImgUrl,
          author: playlist.creator?.nickname || '',
          description: playlist.description,
          songCount: playlist.trackIds.length,
          name: playlist.name,
          img: playlist.coverImgUrl,
          desc: playlist.description,
          play_count: WangYiSongListService.formatPlayCount(playlist.playCount),
        };

        const songListDetailResult: SongListDetailResult = {
          list,
          info,
          total: list.length,
          source: 'wy'
        };
        return songListDetailResult;
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        } else {
          const songListDetailResult2: SongListDetailResult = {
            list: WangYiSongListService.filterListDetail(result),
            info: {
              id: String(result.playlist?.id),
              title: result.playlist?.name || '',
              cover: result.playlist?.coverImgUrl || '',
              author: result.playlist?.creator?.nickname || '',
              description: result.playlist?.description || '',
              songCount: result.playlist?.trackIds.length || 0,
              name: result.playlist?.name || '',
              img: result.playlist?.coverImgUrl || '',
              desc: result.playlist?.description || '',
              play_count: WangYiSongListService.formatPlayCount(result.playlist?.playCount || 0),
            },
            total: WangYiSongListService.filterListDetail(result).length,
            source: 'wy'
          };
          return songListDetailResult2;
        }
        };
        return resultInfo;
      }
    } catch (error) {
      console.error('获取歌单详情失败:', error);
      throw new Error('获取歌单详情失败');
    }
  }

  /**
   * 搜索歌单
   */
  public static async searchSongList(keyword: string, page: number = 1, limit: number = 30): Promise<SearchSongListResult> {
    try {
      const searchParamsObj: Record<string, string | number | boolean> = {
        s: keyword,
        type: 1000,
        limit: limit,
        total: true,
        offset: (page - 1) * limit,
      };
      const searchParams: EapiResult = eapi('/api/cloudsearch/pc', searchParamsObj);

      const response = await httpFetch('https://interface.music.163.com/eapi/cloudsearch/pc', {
        method: http.RequestMethod.POST,
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
        },
        form: { params: searchParams.params },
      });

      const resp = await response.promise;
      const body = resp.body;

      if (typeof body === 'string' || typeof body === 'object') {
        const result = body as unknown as Record<string, Object>;
        const searchResult = result.result as Record<string, Object> | null;

        if (!searchResult) {
          throw new Error('搜索结果为空');
        }

        const playlists = searchResult.playlists as Array<Record<string, Object>> || [];
        const list: SongListInfo[] = [];

        for (let i = 0; i < playlists.length; i++) {
          const item = playlists[i];
          const songListInfo: SongListInfo = {
            id: `wy__${item.id}`,
            title: item.name as string,
            cover: item.coverImgUrl as string,
            author: (item.creator as Record<string, string>)?.nickname || '',
            description: item.description as string,
            songCount: item.trackCount as number,
            name: item.name as string,
            img: item.coverImgUrl as string,
            desc: item.description as string,
            play_count: WangYiSongListService.formatPlayCount(item.playCount as number),
          };
          list.push(songListInfo);
        }

        const searchSongListResult: SearchSongListResult = {
          list,
          total: (result.result as Record<string, Object>).songCount as number || 0,
          source: 'wy'
        };
        return searchSongListResult;
      } else {
        throw new Error('搜索结果格式错误');
      }
    } catch (error) {
      console.error('搜索歌单失败:', error);
      throw new Error('搜索歌单失败');
    }
  }
}

export default WangYiSongListService;
