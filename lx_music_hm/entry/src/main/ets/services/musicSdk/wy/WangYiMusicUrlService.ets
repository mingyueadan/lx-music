/**
 * 网易云音乐 URL 获取服务
 * 用于获取音乐的播放链接
 */

import http from '@ohos.net.http';
import { httpFetch } from '../../../utils/HttpUtil';
import { eapi, EapiResult } from './WangYiCrypto';

/**
 * 音乐 URL 响应接口
 */
interface WyMusicUrlResponse {
  code: number;
  data?: Array<{
    id: number;
    url: string;
    br: number;
    size: number;
    md5: string;
    type?: string;
  }>;
}

/**
 * 音质映射接口
 */
interface QualityMap {
  '128k': number;
  '320k': number;
  'flac': number;
  'flac24bit': number;
}

/**
 * 网易云音乐 URL 获取服务类
 */
export class WangYiMusicUrlService {
  /**
   * 获取音乐播放 URL
   * @param songmid 音乐 ID
   * @param quality 音质 (默认 320k)
   * @returns 播放 URL
   */
  public static async getMusicUrl(songmid: string, quality: string = '320k'): Promise<string> {
    try {
      let br: number = 320000;
      if (quality === '128k') {
        br = 128000;
      } else if (quality === 'flac' || quality === 'flac24bit') {
        br = 999000;
      } else {
        br = 320000;
      }

      const searchParams: Record<string, string | number> = {
        ids: `[${songmid}]`,
        br: br,
        level: 'standard',
        encodeType: 'aac',
      };
      const searchRequest: EapiResult = eapi('/api/song/enhance/player/url/v1', searchParams);

      const formParam: Record<string, string> = {
        params: searchRequest.params
      };

      const response = await httpFetch('http://interface.music.163.com/eapi/batch', {
        method: http.RequestMethod.POST,
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
          'origin': 'https://music.163.com',
        },
        form: formParam,
      });

      const resp = await response.promise;
      const body = resp.body;

      if (typeof body === 'string' || typeof body === 'object') {
        const bodyObj: Record<string, Object> = body as Record<string, Object>;
        const result: WyMusicUrlResponse = bodyObj as unknown as WyMusicUrlResponse;

        if (!result || result.code !== 200 || !result.data || result.data.length === 0) {
          throw new Error('获取音乐 URL 失败');
        }

        const musicData = result.data[0];
        if (!musicData.url) {
          throw new Error('音乐 URL 不可用');
        }

        return musicData.url;
      } else {
        throw new Error('响应数据格式错误');
      }
    } catch (error) {
      console.error('获取音乐 URL 失败:', error);
      throw new Error(`获取音乐 URL 失败: ${error}`);
    }
  }

  /**
   * 批量获取音乐播放 URL
   * @param songmids 音乐 ID 数组
   * @param quality 音质 (默认 320k)
   * @returns 播放 URL 映射
   */
  public static async getMusicUrls(songmids: string[], quality: string = '320k'): Promise<Record<string, string>> {
    try {
      let br: number = 320000;
      if (quality === '128k') {
        br = 128000;
      } else if (quality === 'flac' || quality === 'flac24bit') {
        br = 999000;
      } else {
        br = 320000;
      }

      const ids = songmids.map(id => parseInt(id)).filter(id => !isNaN(id));
      const searchParams: Record<string, string | number> = {
        ids: JSON.stringify(ids),
        br: br,
        level: 'standard',
        encodeType: 'aac',
      };
      const searchRequest: EapiResult = eapi('/api/song/enhance/player/url/v1', searchParams);

      const formParam: Record<string, string> = {
        params: searchRequest.params
      };

      const response = await httpFetch('http://interface.music.163.com/eapi/batch', {
        method: http.RequestMethod.POST,
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36',
          'origin': 'https://music.163.com',
        },
        form: formParam,
      });

      const resp = await response.promise;
      const body = resp.body;

      if (typeof body === 'string' || typeof body === 'object') {
        const bodyObj: Record<string, Object> = body as Record<string, Object>;
        const result: WyMusicUrlResponse = bodyObj as unknown as WyMusicUrlResponse;

        if (!result || result.code !== 200 || !result.data) {
          throw new Error('批量获取音乐 URL 失败');
        }

        const urlMap: Record<string, string> = {};
        result.data.forEach((item) => {
          if (item.url) {
            urlMap[String(item.id)] = item.url;
          }
        });

        return urlMap;
      } else {
        throw new Error('响应数据格式错误');
      }
    } catch (error) {
      console.error('批量获取音乐 URL 失败:', error);
      throw new Error(`批量获取音乐 URL 失败: ${error}`);
    }
  }
}

export default WangYiMusicUrlService;
