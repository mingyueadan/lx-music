/**
 * 歌词工具类 - 鸿蒙版
 * 移植自 lx-music-mobile/src/utils/lrcTools.ts
 */

import util from '@ohos.util';

/**
 * 时间字段正则表达式
 */
const timeFieldExp = /^(?:\[[\d:.]+\])+/g;
const timeExp = /\d{1,3}(:\d{1,3}){0,2}(?:\.\d{1,3})/g;

/**
 * 歌词信息接口
 */
export interface LyricInfo {
  lyric: string;
  tlyric?: string;  // 翻译歌词
  rlyric?: string;  // 罗马音歌词
  lxlyric?: string; // 自定义歌词
}

/**
 * 格式化时间标签
 * @param label 时间标签字符串
 * @returns 格式化后的时间标签
 */
function formatTimeLabel(label: string): string {
  const t_rxp_1 = /^0+(\d+)/;
  const t_rxp_2 = /:0+(\d+)/g;
  const t_rxp_3 = /\.0+(\d+)/;
  
  return label
    .replace(t_rxp_1, '$1')
    .replace(t_rxp_2, ':$1')
    .replace(t_rxp_3, '.$1');
}

/**
 * 过滤扩展歌词标签
 * @param lrcTimeLabels 原歌词时间标签集合
 * @param extendedLyric 扩展歌词
 * @returns 过滤后的歌词
 */
function filterExtendedLyricLabel(lrcTimeLabels: Set<string>, extendedLyric: string): string {
  const extendedLines = extendedLyric.split(/\r\n|\n|\r/);
  const lines: string[] = [];
  
  for (let i = 0; i < extendedLines.length; i++) {
    let line = extendedLines[i].trim();
    let result = timeFieldExp.exec(line);
    if (!result) continue;

    const timeField = result[0];
    const text = line.replace(timeFieldExp, '').trim();
    if (!text) continue;
    
    let times = timeField.match(timeExp);
    if (times == null) continue;

    const newTimes = times.filter(time => {
      const timeStr = formatTimeLabel(time);
      return lrcTimeLabels.has(timeStr);
    });
    
    if (newTimes.length !== times.length) {
      if (!newTimes.length) continue;
      line = `[${newTimes.join('][')}]${text}`;
    }
    lines.push(line);
  }

  return lines.join('\n');
}

/**
 * 解析歌词时间标签
 * @param lrc 歌词字符串
 * @returns 时间标签集合
 */
function parseLrcTimeLabel(lrc: string): Set<string> {
  const lines = lrc.split(/\r\n|\n|\r/);
  const linesSet = new Set<string>();
  const length = lines.length;
  
  for (let i = 0; i < length; i++) {
    const line = lines[i].trim();
    let result = timeFieldExp.exec(line);
    if (result) {
      const timeField = result[0];
      const text = line.replace(timeFieldExp, '').trim();
      if (text) {
        const times = timeField.match(timeExp);
        if (times == null) continue;
        for (let time of times) {
          linesSet.add(formatTimeLabel(time));
        }
      }
    }
  }

  return linesSet;
}

/**
 * 构建自定义歌词
 * @param lrcData 歌词数据
 * @returns 自定义歌词字符串
 */
function buildAwlyric(lrcData: LyricInfo): string {
  let lrc: string[] = [];
  
  if (lrcData.lyric) {
    const buffer = new util.StringBuffer(lrcData.lyric.trim());
    const base64 = buffer.toString('base64');
    lrc.push(`lrc:${base64}`);
  }
  if (lrcData.tlyric) {
    const buffer = new util.StringBuffer(lrcData.tlyric.trim());
    const base64 = buffer.toString('base64');
    lrc.push(`tlrc:${base64}`);
  }
  if (lrcData.rlyric) {
    const buffer = new util.StringBuffer(lrcData.rlyric.trim());
    const base64 = buffer.toString('base64');
    lrc.push(`rlrc:${base64}`);
  }
  if (lrcData.lxlyric) {
    const buffer = new util.StringBuffer(lrcData.lxlyric.trim());
    const base64 = buffer.toString('base64');
    lrc.push(`awlrc:${base64}`);
  }
  
  return lrc.length ? `[awlrc:${lrc.join(',')}]` : '';
}

/**
 * 构建歌词
 * @param lrcData 歌词数据
 * @param downloadAwlrc 是否下载自定义歌词
 * @param downloadTlrc 是否下载翻译歌词
 * @param downloadRlrc 是否下载罗马音歌词
 * @returns 构建后的歌词
 */
export function buildLyrics(
  lrcData: LyricInfo,
  downloadAwlrc: boolean,
  downloadTlrc: boolean,
  downloadRlrc: boolean
): string {
  // 如果没有扩展歌词，直接返回原歌词
  if (!lrcData.tlyric && !lrcData.rlyric && !lrcData.lxlyric) {
    return lrcData.lyric;
  }

  const lrcTimeLabels = parseLrcTimeLabel(lrcData.lyric);
  let lrc = lrcData.lyric;

  // 添加翻译歌词
  if (downloadTlrc && lrcData.tlyric) {
    lrc = lrc.trim() + `\n\n${filterExtendedLyricLabel(lrcTimeLabels, lrcData.tlyric)}\n`;
  }

  // 添加罗马音歌词
  if (downloadRlrc && lrcData.rlyric) {
    lrc = lrc.trim() + `\n\n${filterExtendedLyricLabel(lrcTimeLabels, lrcData.rlyric)}\n`;
  }

  // 添加自定义歌词
  if (downloadAwlrc) {
    const awlrc = buildAwlyric(lrcData);
    if (awlrc) {
      lrc = lrc.trim() + `\n\n${awlrc}\n`;
    }
  }

  return lrc;
}

/**
 * 解析歌词行
 * @param line 歌词行
 * @returns 解析结果 { time: 时间(毫秒), text: 文本 }
 */
export function parseLyricLine(line: string): { time: number; text: string } | null {
  const result = timeFieldExp.exec(line);
  if (!result) return null;

  const timeField = result[0];
  const text = line.replace(timeFieldExp, '').trim();
  
  const times = timeField.match(timeExp);
  if (!times || times.length === 0) return null;

  // 解析时间（格式：[mm:ss.xxx]）
  const timeStr = times[0];
  const parts = timeStr.split(':');
  let time = 0;
  
  if (parts.length >= 2) {
    time += parseInt(parts[0]) * 60 * 1000; // 分钟
    time += parseFloat(parts[1]) * 1000; // 秒
  }
  
  return { time, text };
}

/**
 * 解析完整歌词
 * @param lrc 歌词字符串
 * @returns 解析后的歌词行数组
 */
export function parseLyric(lrc: string): Array<{ time: number; text: string }> {
  const lines = lrc.split(/\r\n|\n|\r/);
  const result: Array<{ time: number; text: string }> = [];
  
  for (const line of lines) {
    const parsed = parseLyricLine(line);
    if (parsed) {
      result.push(parsed);
    }
  }
  
  // 按时间排序
  result.sort((a, b) => a.time - b.time);
  
  return result;
}

/**
 * 获取当前时间对应的歌词行
 * @param parsedLyric 解析后的歌词
 * @param currentTime 当前时间（毫秒）
 * @returns 歌词行索引
 */
export function getCurrentLyricLine(
  parsedLyric: Array<{ time: number; text: string }>,
  currentTime: number
): number {
  for (let i = 0; i < parsedLyric.length; i++) {
    if (parsedLyric[i].time > currentTime) {
      return i > 0 ? i - 1 : 0;
    }
  }
  return parsedLyric.length - 1;
}

/**
 * 自定义歌词解析
 * @param awlrc 自定义歌词字符串
 * @returns 解析后的歌词数据
 */
export function parseAwLyric(awlrc: string): LyricInfo {
  const result: LyricInfo = {
    lyric: '',
    tlyric: '',
    rlyric: '',
    lxlyric: '',
  };

  // 匹配 [awlrc:...] 格式
  const awlrcMatch = awlrc.match(/\[awlrc:(.+)\]/);
  if (!awlrcMatch) return result;

  const content = awlrcMatch[1];
  const parts = content.split(',');

  for (const part of parts) {
    if (part.startsWith('lrc:')) {
      const base64 = part.substring(4);
      try {
        const buffer = util.Base64Helper.decodeStringSync(base64);
        result.lyric = buffer;
      } catch (e) {
        console.error('Failed to parse lrc:', e);
      }
    } else if (part.startsWith('tlrc:')) {
      const base64 = part.substring(5);
      try {
        const buffer = util.Base64Helper.decodeStringSync(base64);
        result.tlyric = buffer;
      } catch (e) {
        console.error('Failed to parse tlrc:', e);
      }
    } else if (part.startsWith('rlrc:')) {
      const base64 = part.substring(5);
      try {
        const buffer = util.Base64Helper.decodeStringSync(base64);
        result.rlyric = buffer;
      } catch (e) {
        console.error('Failed to parse rlrc:', e);
      }
    } else if (part.startsWith('awlrc:')) {
      const base64 = part.substring(6);
      try {
        const buffer = util.Base64Helper.decodeStringSync(base64);
        result.lxlyric = buffer;
      } catch (e) {
        console.error('Failed to parse awlrc:', e);
      }
    }
  }

  return result;
}

/**
 * 移除歌词中的空行
 * @param lrc 歌词字符串
 * @returns 处理后的歌词
 */
export function removeEmptyLines(lrc: string): string {
  const lines = lrc.split(/\r\n|\n|\r/);
  const result: string[] = [];
  
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('[')) {
      result.push(line);
    }
  }
  
  return result.join('\n');
}

/**
 * 格式化时间显示
 * @param milliseconds 毫秒数
 * @returns 格式化后的时间字符串 (mm:ss)
 */
export function formatTime(milliseconds: number): string {
  const minutes = Math.floor(milliseconds / 60000);
  const seconds = Math.floor((milliseconds % 60000) / 1000);
  
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

/**
 * 格式化时间显示（带毫秒）
 * @param milliseconds 毫秒数
 * @returns 格式化后的时间字符串 (mm:ss.xxx)
 */
export function formatTimeWithMs(milliseconds: number): string {
  const minutes = Math.floor(milliseconds / 60000);
  const seconds = Math.floor((milliseconds % 60000) / 1000);
  const ms = milliseconds % 1000;
  
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${ms.toString().padStart(3, '0')}`;
}

/**
 * 将时间字符串转换为毫秒
 * @param timeStr 时间字符串 (mm:ss 或 mm:ss.xxx)
 * @returns 毫秒数
 */
export function parseTimeToMs(timeStr: string): number {
  const parts = timeStr.split(':');
  let ms = 0;
  
  if (parts.length >= 2) {
    ms += parseInt(parts[0]) * 60 * 1000; // 分钟
    const secParts = parts[1].split('.');
    ms += parseFloat(secParts[0]) * 1000; // 秒
    if (secParts.length > 1) {
      ms += parseInt(secParts[1].padEnd(3, '0')); // 毫秒
    }
  }
  
  return ms;
}
