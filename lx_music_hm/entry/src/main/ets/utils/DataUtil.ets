/**
 * 数据存储工具类 - 鸿蒙版
 * 移植自 lx-music-mobile/src/utils/data.ts
 */

import { storage } from './StorageUtil';

/**
 * 存储数据前缀常量
 */
export const storageDataPrefix = {
  fontSize: 'lx_fontSize_',
  theme: 'lx_theme_',
  playInfo: 'lx_playInfo_',
  userList: 'lx_userList_',
  viewPrevState: 'lx_viewPrevState_',
  listScrollPosition: 'lx_listScrollPosition_',
  listUpdateInfo: 'lx_listUpdateInfo_',
  ignoreVersion: 'lx_ignoreVersion_',
  ignoreVersionFailTipTime: 'lx_ignoreVersionFailTipTime_',
  searchSetting: 'lx_searchSetting_',
  searchHistoryList: 'lx_searchHistoryList_',
  songListSetting: 'lx_songListSetting_',
  leaderboardSetting: 'lx_leaderboardSetting_',
  listPrevSelectId: 'lx_listPrevSelectId_',
  syncAuthKey: 'lx_syncAuthKey_',
  syncHost: 'lx_syncHost_',
  syncHostHistory: 'lx_syncHostHistory_',
  list: 'lx_list_',
  dislikeList: 'lx_dislikeList_',
  userApi: 'lx_userApi_',
  openStoragePath: 'lx_openStoragePath_',
  selectedManagedFolder: 'lx_selectedManagedFolder_',
  musicUrl: 'lx_musicUrl_',
  lyric: 'lx_lyric_',
  musicOtherSource: 'lx_musicOtherSource_',
};

/**
 * 列表ID常量
 */
export const LIST_IDS = {
  DEFAULT: 'default',
  LOVE: 'love',
  TEMP: 'temp',
};

/**
 * 默认设置
 */
const DEFAULT_SETTING = {
  search: {
    source: 'kw' as string,
    temp_source: 'kw' as string,
    type: 'music' as string,
  },
  songList: {
    source: 'kw' as string,
  },
  leaderboard: {
    source: 'kw' as string,
  },
  viewPrevState: {
    id: 'nav_home' as string,
  },
};

/**
 * 节流函数
 */
function throttle<T extends (...args: any[]) => any>(func: T, delay: number): T {
  let lastCall = 0;
  let timeoutId: number | null = null;
  
  return ((...args: Parameters<T>) => {
    const now = Date.now();
    const remaining = delay - (now - lastCall);
    
    if (remaining <= 0) {
      if (timeoutId) {
        clearTimeout(timeoutId);
        timeoutId = null;
      }
      lastCall = now;
      func(...args);
    } else if (!timeoutId) {
      timeoutId = setTimeout(() => {
        lastCall = Date.now();
        timeoutId = null;
        func(...args);
      }, remaining);
    }
  }) as T;
}

// 内存缓存变量
let listPosition: Record<string, number> = {};
let listPrevSelectId: string = LIST_IDS.DEFAULT;
let listUpdateInfo: Record<string, { updateTime: number; isAutoUpdate: boolean }> = {};
let searchSetting: typeof DEFAULT_SETTING['search'] | null = null;
let songListSetting: typeof DEFAULT_SETTING['songList'] | null = null;
let leaderboardSetting: typeof DEFAULT_SETTING['leaderboard'] | null = null;
let searchHistoryList: string[] | null = null;
let ignoreVersion: string | null = null;
let ignoreVersionFailTipTime: number | null = null;
let openStoragePath: string | null = null;
let selectedManagedFolder: string | null = null;
let syncHostInfo: string | null = null;
let syncHostHistory: string[] | null = null;
let userApis: any[] | null = null;

// 节流保存函数
const saveListPositionThrottle = throttle(async () => {
  await storage.setObject(storageDataPrefix.listScrollPosition, listPosition);
}, 1000);

const saveSearchSettingThrottle = throttle(async () => {
  if (searchSetting) {
    await storage.setObject(storageDataPrefix.searchSetting, searchSetting);
  }
}, 1000);

const saveSearchHistoryThrottle = throttle(async () => {
  if (searchHistoryList) {
    await storage.setObject(storageDataPrefix.searchHistoryList, searchHistoryList);
  }
}, 1000);

const saveSongListSettingThrottle = throttle(async () => {
  if (songListSetting) {
    await storage.setObject(storageDataPrefix.songListSetting, songListSetting);
  }
}, 1000);

const saveLeaderboardSettingThrottle = throttle(async () => {
  if (leaderboardSetting) {
    await storage.setObject(storageDataPrefix.leaderboardSetting, leaderboardSetting);
  }
}, 1000);

const saveViewPrevStateThrottle = throttle(async (state: any) => {
  await storage.setObject(storageDataPrefix.viewPrevState, state);
}, 1000);

const saveListPrevSelectIdThrottle = throttle(async () => {
  await storage.set(storageDataPrefix.listPrevSelectId, listPrevSelectId);
}, 200);

const saveListUpdateInfoThrottle = throttle(async () => {
  await storage.setObject(storageDataPrefix.listUpdateInfo, listUpdateInfo);
}, 1000);

/**
 * 获取字体大小
 */
export async function getFontSize(): Promise<number> {
  const size = await storage.get(storageDataPrefix.fontSize) as number;
  return size ?? 1;
}

/**
 * 保存字体大小
 */
export async function saveFontSize(size: number): Promise<void> {
  await storage.set(storageDataPrefix.fontSize, size);
}

/**
 * 获取用户主题
 */
export async function getUserTheme(): Promise<any[]> {
  const themes = await storage.getObject<any[]>(storageDataPrefix.theme);
  return themes ?? [];
}

/**
 * 保存用户主题
 */
export async function saveUserTheme(themes: any[]): Promise<void> {
  await storage.setObject(storageDataPrefix.theme, themes);
}

/**
 * 初始化列表位置
 */
async function initPosition(): Promise<void> {
  if (Object.keys(listPosition).length === 0) {
    const position = await storage.getObject<Record<string, number>>(storageDataPrefix.listScrollPosition);
    listPosition = position ?? {};
  }
}

/**
 * 获取列表滚动位置
 */
export async function getListPosition(id: string): Promise<number> {
  await initPosition();
  return listPosition[id] ?? 0;
}

/**
 * 保存列表滚动位置
 */
export async function saveListPosition(id: string, position?: number): Promise<void> {
  await initPosition();
  listPosition[id] = position ?? 0;
  saveListPositionThrottle();
}

/**
 * 移除列表滚动位置
 */
export async function removeListPosition(id: string): Promise<void> {
  await initPosition();
  delete listPosition[id];
  saveListPositionThrottle();
}

/**
 * 覆盖列表位置
 */
export async function overwriteListPosition(ids: string[]): Promise<void> {
  await initPosition();
  const removedIds = [];
  for (const id of Object.keys(listPosition)) {
    if (ids.includes(id)) continue;
    removedIds.push(id);
  }
  for (const id of removedIds) {
    delete listPosition[id];
  }
  saveListPositionThrottle();
}

/**
 * 获取上次选中的列表ID
 */
export async function getListPrevSelectId(): Promise<string> {
  if (!listPrevSelectId) {
    const id = await storage.get(storageDataPrefix.listPrevSelectId) as string;
    listPrevSelectId = id ?? LIST_IDS.DEFAULT;
  }
  return listPrevSelectId || LIST_IDS.DEFAULT;
}

/**
 * 保存上次选中的列表ID
 */
export function saveListPrevSelectId(id: string): void {
  listPrevSelectId = id;
  saveListPrevSelectIdThrottle();
}

/**
 * 初始化列表更新信息
 */
async function initListUpdateInfo(): Promise<void> {
  if (Object.keys(listUpdateInfo).length === 0) {
    const info = await storage.getObject<Record<string, { updateTime: number; isAutoUpdate: boolean }>>(
      storageDataPrefix.listUpdateInfo
    );
    listUpdateInfo = info ?? {};
  }
}

/**
 * 获取列表更新信息
 */
export async function getListUpdateInfo(): Promise<Record<string, { updateTime: number; isAutoUpdate: boolean }>> {
  await initListUpdateInfo();
  return { ...listUpdateInfo };
}

/**
 * 保存列表更新信息
 */
export async function saveListUpdateInfo(info: Record<string, { updateTime: number; isAutoUpdate: boolean }>): Promise<void> {
  await initListUpdateInfo();
  listUpdateInfo = info;
  saveListUpdateInfoThrottle();
}

/**
 * 设置列表自动更新
 */
export async function setListAutoUpdate(id: string, enable: boolean): Promise<void> {
  await initListUpdateInfo();
  const targetInfo = listUpdateInfo[id] ?? { updateTime: 0, isAutoUpdate: false };
  targetInfo.isAutoUpdate = enable;
  listUpdateInfo[id] = targetInfo;
  saveListUpdateInfoThrottle();
}

/**
 * 设置列表更新时间
 */
export async function setListUpdateTime(id: string, time: number): Promise<void> {
  await initListUpdateInfo();
  const targetInfo = listUpdateInfo[id] ?? { updateTime: 0, isAutoUpdate: false };
  targetInfo.updateTime = time;
  listUpdateInfo[id] = targetInfo;
  saveListUpdateInfoThrottle();
}

/**
 * 移除列表更新信息
 */
export async function removeListUpdateInfo(id: string): Promise<void> {
  await initListUpdateInfo();
  delete listUpdateInfo[id];
  saveListUpdateInfoThrottle();
}

/**
 * 覆盖列表更新信息
 */
export async function overwriteListUpdateInfo(ids: string[]): Promise<void> {
  await initListUpdateInfo();
  const removedIds = [];
  for (const id of Object.keys(listUpdateInfo)) {
    if (ids.includes(id)) continue;
    removedIds.push(id);
  }
  for (const id of removedIds) {
    delete listUpdateInfo[id];
  }
  saveListUpdateInfoThrottle();
}

/**
 * 保存忽略的版本
 */
export async function saveIgnoreVersion(version: string | null): Promise<void> {
  ignoreVersion = version;
  if (version == null) {
    await storage.remove(storageDataPrefix.ignoreVersion);
  } else {
    await storage.set(storageDataPrefix.ignoreVersion, version);
  }
}

/**
 * 获取忽略的版本
 */
export async function getIgnoreVersion(): Promise<string | null> {
  if (ignoreVersion === undefined) {
    const version = await storage.get(storageDataPrefix.ignoreVersion) as string | null;
    ignoreVersion = version ?? null;
  }
  return ignoreVersion;
}

/**
 * 保存忽略版本失败提示时间
 */
export async function saveIgnoreVersionFailTipTime(time: number | null): Promise<void> {
  ignoreVersionFailTipTime = time;
  if (time == null) {
    await storage.remove(storageDataPrefix.ignoreVersionFailTipTime);
  } else {
    await storage.set(storageDataPrefix.ignoreVersionFailTipTime, time);
  }
}

/**
 * 获取忽略版本失败提示时间
 */
export async function getIgnoreVersionFailTipTime(): Promise<number> {
  if (ignoreVersionFailTipTime === undefined) {
    const time = await storage.get(storageDataPrefix.ignoreVersionFailTipTime) as number | null;
    ignoreVersionFailTipTime = time ?? 0;
  }
  return ignoreVersionFailTipTime ?? 0;
}

/**
 * 保存打开的存储路径
 */
export async function saveOpenStoragePath(path: string): Promise<void> {
  if (path) {
    openStoragePath = path;
    await storage.set(storageDataPrefix.openStoragePath, path);
  } else {
    if (!openStoragePath) return;
    openStoragePath = null;
    await storage.remove(storageDataPrefix.openStoragePath);
  }
}

/**
 * 获取打开的存储路径
 */
export async function getOpenStoragePath(): Promise<string | null> {
  if (openStoragePath === '') {
    const path = await storage.get(storageDataPrefix.openStoragePath) as string | null;
    openStoragePath = path ?? null;
  }
  return openStoragePath;
}

/**
 * 获取搜索设置
 */
export async function getSearchSetting(): Promise<typeof DEFAULT_SETTING['search']> {
  if (!searchSetting) {
    const setting = await storage.getObject<typeof DEFAULT_SETTING['search']>(storageDataPrefix.searchSetting);
    searchSetting = setting ?? { ...DEFAULT_SETTING.search };
  }
  return { ...searchSetting };
}

/**
 * 保存搜索设置
 */
export async function saveSearchSetting(setting: Partial<typeof DEFAULT_SETTING['search']>): Promise<void> {
  if (!searchSetting) {
    await getSearchSetting();
  }
  let requiredSave = false;
  if (setting.source && searchSetting.source !== setting.source) requiredSave = true;
  if (setting.type && searchSetting.type !== setting.type) requiredSave = true;
  if (setting.temp_source && searchSetting.temp_source !== setting.temp_source) requiredSave = true;

  if (!requiredSave) return;
  searchSetting = Object.assign(searchSetting, setting);
  saveSearchSettingThrottle();
}

/**
 * 获取搜索历史
 */
export async function getSearchHistory(): Promise<string[]> {
  if (!searchHistoryList) {
    const history = await storage.getObject<string[]>(storageDataPrefix.searchHistoryList);
    searchHistoryList = history ?? [];
  }
  return [...searchHistoryList];
}

/**
 * 保存搜索历史
 */
export async function saveSearchHistory(historyList: string[]): Promise<void> {
  searchHistoryList = historyList;
  saveSearchHistoryThrottle();
}

/**
 * 获取歌单设置
 */
export async function getSongListSetting(): Promise<typeof DEFAULT_SETTING['songList']> {
  if (!songListSetting) {
    const setting = await storage.getObject<typeof DEFAULT_SETTING['songList']>(storageDataPrefix.songListSetting);
    songListSetting = setting ?? { ...DEFAULT_SETTING.songList };
  }
  return { ...songListSetting };
}

/**
 * 保存歌单设置
 */
export async function saveSongListSetting(setting: Partial<typeof DEFAULT_SETTING['songList']>): Promise<void> {
  if (!songListSetting) {
    await getSongListSetting();
  }
  songListSetting = Object.assign(songListSetting, setting);
  saveSongListSettingThrottle();
}

/**
 * 获取榜单设置
 */
export async function getLeaderboardSetting(): Promise<typeof DEFAULT_SETTING['leaderboard']> {
  if (!leaderboardSetting) {
    const setting = await storage.getObject<typeof DEFAULT_SETTING['leaderboard']>(storageDataPrefix.leaderboardSetting);
    leaderboardSetting = setting ?? { ...DEFAULT_SETTING.leaderboard };
  }
  return { ...leaderboardSetting };
}

/**
 * 保存榜单设置
 */
export async function saveLeaderboardSetting(setting: Partial<typeof DEFAULT_SETTING['leaderboard']>): Promise<void> {
  if (!leaderboardSetting) {
    await getLeaderboardSetting();
  }
  leaderboardSetting = Object.assign(leaderboardSetting, setting);
  saveLeaderboardSettingThrottle();
}

/**
 * 获取视图上次状态
 */
export async function getViewPrevState(): Promise<{ id: string }> {
  const state = await storage.getObject<{ id: string }>(storageDataPrefix.viewPrevState);
  return state ?? { ...DEFAULT_SETTING.viewPrevState };
}

/**
 * 保存视图上次状态
 */
export function saveViewPrevState(state: { id: string }): void {
  saveViewPrevStateThrottle(state);
}

/**
 * 获取用户列表
 */
export async function getUserLists(): Promise<any[]> {
  const list = await storage.getObject<any[]>(storageDataPrefix.userList);
  const result = list ?? [];
  
  // 兼容v2.3.0之前版本PC端插入数字类型的ID导致其意外在末尾追加 .0 的问题
  const idFixRxp = /\.0$/;
  for (const info of result) {
    if (info.sourceListId?.endsWith?.('.0')) {
      info.sourceListId = info.sourceListId.replace(idFixRxp, '');
    }
  }
  
  return result;
}

/**
 * 保存用户列表
 */
export async function saveUserList(listInfo: any[]): Promise<void> {
  await storage.setObject(storageDataPrefix.userList, listInfo);
}

/**
 * 获取列表内歌曲
 */
export async function getListMusics(listId: string): Promise<any[]> {
  const list = await storage.getObject<any[]>(storageDataPrefix.list + listId);
  return list ?? [];
}

/**
 * 保存列表内歌曲
 */
export async function saveListMusics(listData: Array<{ id: string; musics: any[] }>): Promise<void> {
  if (listData.length > 1) {
    const promises = listData.map(list => 
      storage.setObject(storageDataPrefix.list + list.id, list.musics)
    );
    await Promise.all(promises);
  } else {
    const list = listData[0];
    await storage.setObject(storageDataPrefix.list + list.id, list.musics);
  }
}

/**
 * 移除歌曲列表
 */
export async function removeListMusics(ids: string[]): Promise<void> {
  const promises = ids.map(id => storage.remove(storageDataPrefix.list + id));
  await Promise.all(promises);
}

/**
 * 获取音乐URL
 */
export async function getMusicUrl(musicInfo: any, type: string): Promise<string> {
  const url = await storage.get(storageDataPrefix.musicUrl + musicInfo.id + '_' + type) as string;
  return url ?? '';
}

/**
 * 保存音乐URL
 */
export async function saveMusicUrl(musicInfo: any, type: string, url: string): Promise<void> {
  await storage.set(storageDataPrefix.musicUrl + musicInfo.id + '_' + type, url);
}

/**
 * 清除音乐URL
 */
export async function clearMusicUrl(keys?: string[]): Promise<void> {
  if (!keys) {
    keys = [storageDataPrefix.musicUrl]; // 简化实现，实际需要获取所有相关键
  }
  const promises = keys.map(key => storage.remove(key));
  await Promise.all(promises);
}

/**
 * 获取歌词
 */
export async function getLyric(musicInfo: any): Promise<any> {
  const lrcInfo = await storage.getObject<any>(storageDataPrefix.lyric + musicInfo.id);
  return lrcInfo ?? { lyric: '' };
}

/**
 * 保存歌词
 */
export async function saveLyric(musicInfo: any, lyricInfo: any): Promise<void> {
  await storage.setObject(storageDataPrefix.lyric + musicInfo.id, lyricInfo);
}

/**
 * 清除歌词
 */
export async function clearLyric(keys?: string[]): Promise<void> {
  if (!keys) {
    keys = [storageDataPrefix.lyric]; // 简化实现
  }
  const promises = keys.map(key => storage.remove(key));
  await Promise.all(promises);
}

/**
 * 获取不喜欢列表规则
 */
export async function getDislikeListRules(): Promise<string> {
  const rules = await storage.get(storageDataPrefix.dislikeList) as string;
  return rules ?? '';
}

/**
 * 保存不喜欢列表规则
 */
export async function saveDislikeListRules(rules: string): Promise<void> {
  await storage.set(storageDataPrefix.dislikeList, rules);
}

/**
 * 保存播放信息
 */
export async function savePlayInfo(playInfo: any): Promise<void> {
  await storage.setObject(storageDataPrefix.playInfo, playInfo);
}

/**
 * 获取播放信息
 */
export async function getPlayInfo(): Promise<any | null> {
  return await storage.getObject<any>(storageDataPrefix.playInfo);
}

/**
 * 获取同步认证密钥
 */
export async function getSyncAuthKey(serverId: string): Promise<any | null> {
  const keys = await storage.getObject<Record<string, any>>(storageDataPrefix.syncAuthKey);
  if (!keys) return null;
  return keys[serverId] ?? null;
}

/**
 * 设置同步认证密钥
 */
export async function setSyncAuthKey(serverId: string, info: any): Promise<void> {
  let keys = await storage.getObject<Record<string, any>>(storageDataPrefix.syncAuthKey) ?? {};
  keys[serverId] = info;
  await storage.setObject(storageDataPrefix.syncAuthKey, keys);
}

/**
 * 获取同步主机
 */
export async function getSyncHost(): Promise<string> {
  if (syncHostInfo === undefined) {
    const host = await storage.get(storageDataPrefix.syncHost) as string;
    syncHostInfo = host ?? '';
    
    // 清空1.0.0之前版本的同步主机
    if (typeof syncHostInfo === 'object') syncHostInfo = '';
  }
  return syncHostInfo;
}

/**
 * 设置同步主机
 */
export async function setSyncHost(host: string): Promise<void> {
  syncHostInfo = host;
  await storage.set(storageDataPrefix.syncHost, syncHostInfo);
}

/**
 * 获取同步主机历史
 */
export async function getSyncHostHistory(): Promise<string[]> {
  if (syncHostHistory === undefined) {
    const history = await storage.getObject<string[]>(storageDataPrefix.syncHostHistory);
    syncHostHistory = history ?? [];
    
    // 清空1.0.0之前版本的同步历史
    if (syncHostHistory.length && typeof syncHostHistory[0] !== 'string') syncHostHistory = [];
  }
  return syncHostHistory;
}

/**
 * 添加同步主机历史
 */
export async function addSyncHostHistory(host: string): Promise<void> {
  let syncHostHistory = await getSyncHostHistory();
  if (syncHostHistory.some(h => h === host)) return;
  
  syncHostHistory.unshift(host);
  if (syncHostHistory.length > 20) {
    syncHostHistory = syncHostHistory.slice(0, 20);
  }
  
  await storage.setObject(storageDataPrefix.syncHostHistory, syncHostHistory);
}

/**
 * 移除同步主机历史
 */
export async function removeSyncHostHistory(index: number): Promise<void> {
  if (syncHostHistory) {
    syncHostHistory.splice(index, 1);
    await storage.setObject(storageDataPrefix.syncHostHistory, syncHostHistory);
  }
}

/**
 * 获取用户API列表
 */
export async function getUserApiList(): Promise<any[]> {
  if (!userApis) {
    const apis = await storage.getObject<any[]>(storageDataPrefix.userApi);
    userApis = apis ?? [];
    
    // 移除 1.7.1 及之前版本的脚本数据被意外存储到列表中的问题
    let updated = false;
    for (const info of userApis) {
      if ((info as any).script != null) {
        delete (info as any).script;
        updated = true;
      }
    }
    if (updated) {
      await storage.setObject(storageDataPrefix.userApi, userApis);
    }
  }
  
  return [...userApis];
}

/**
 * 获取用户API脚本
 */
export async function getUserApiScript(id: string): Promise<string> {
  const script = await storage.get(storageDataPrefix.userApi + id) as string;
  return script ?? '';
}

/**
 * 添加用户API
 */
export async function addUserApi(script: string): Promise<any> {
  const result = /^\/\*[\S|\s]+?\*\//.exec(script);
  if (!result) {
    throw new Error('用户API添加失败');
  }

  const scriptInfo = matchInfo(result[0]);
  scriptInfo.name ||= `user_api_${new Date().toLocaleString()}`;

  const apiInfo: any = {
    id: `user_api_${Math.random().toString().substring(2, 5)}_${Date.now()}`,
    ...scriptInfo,
    allowShowUpdateAlert: true,
  };

  userApis!.push(apiInfo);
  await Promise.all([
    storage.setObject(storageDataPrefix.userApi, userApis),
    storage.set(storageDataPrefix.userApi + apiInfo.id, script),
  ]);

  return apiInfo;
}

/**
 * 移除用户API
 */
export async function removeUserApi(ids: string[]): Promise<any[]> {
  if (!userApis) return [];
  
  const _ids: string[] = [];
  for (let index = userApis.length - 1; index > -1; index--) {
    if (ids.includes(userApis[index].id)) {
      _ids.push(storageDataPrefix.userApi + userApis[index].id);
      userApis.splice(index, 1);
      ids.splice(index, 1);
    }
  }
  
  await storage.setObject(storageDataPrefix.userApi, userApis);
  if (_ids.length) {
    const promises = _ids.map(id => storage.remove(id));
    await Promise.all(promises);
  }
  
  return [...userApis];
}

/**
 * 匹配API信息
 */
function matchInfo(scriptInfo: string): Record<string, string> {
  const infoArr = scriptInfo.split(/\r?\n/);
  const rxp = /^\s?\*\s?@(\w+)\s(.+)$/;
  const infos: Partial<Record<string, string>> = {};

  const INFO_NAMES = {
    name: 24,
    description: 36,
    author: 56,
    homepage: 1024,
    version: 36,
  };

  for (const info of infoArr) {
    const result = rxp.exec(info);
    if (!result) continue;
    const key = result[1];
    if (INFO_NAMES[key as keyof typeof INFO_NAMES] == null) continue;
    infos[key] = result[2].trim();
  }

  for (const [key, len] of Object.entries(INFO_NAMES)) {
    infos[key] ||= '';
    if (infos[key] == null) {
      infos[key] = '';
    } else if (infos[key].length > len) {
      infos[key] = infos[key].substring(0, len) + '...';
    }
  }

  return infos as Record<string, string>;
}
