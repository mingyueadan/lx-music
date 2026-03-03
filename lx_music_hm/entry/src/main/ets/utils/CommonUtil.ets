/**
 * 通用工具类
 * 提供常用的工具函数，包括字符串处理、数组操作、格式转换等
 */

import promptAction from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import { window } from '@kit.ArkUI';

/**
 * 平台检测
 */
export const isHarmonyOS = true;

/**
 * 获取设备语言
 */
export const getDeviceLanguage = (): string => {
  // HarmonyOS 中获取系统语言
  // 暂时返回默认值
  return 'zh-CN';
}

/**
 * 检查应用是否处于活动状态
 */
export const isActive = (): boolean => {
  // HarmonyOS 中检查应用状态
  return true;
};

/**
 * 临时文件路径
 */
export const TEMP_FILE_PATH = `${globalThis.filesDir}/tempFile`;

/**
 * 显示 Toast 提示
 * @param message 消息内容
 * @param duration 显示时长
 * @param position 显示位置
 */
export const toast = (message: string, duration: 'long' | 'short' = 'short', position: 'top' | 'center' | 'bottom' = 'bottom'): void => {
  // 使用 HarmonyOS 的 promptAction 显示 Toast
  // 注意：HarmonyOS 的 promptAction 功能有限，可能需要自定义实现
  console.log(`[${position}] ${message}`);
  // 实际项目中可以使用 customDialog 或自定义组件
};

/**
 * 打开 URL
 * @param url 要打开的 URL
 */
export const openUrl = async (url: string): Promise<void> => => {
  // HarmonyOS 中使用 @ohos.app.ability.common.UIAbilityContext 打开 URL
  // 暂时使用 console.log 占位
  console.log(`Open URL: ${url}`);
  // 实际实现需要使用 abilityContext.startAbility
};

/**
 * 检查 API 是否支持
 * @param source 音源
 */
export const assertApiSupport = (source: string): boolean => {
  // 检查音源是否支持
  // 暂时返回 true
  return source === 'local' || true;
};

/**
 * 退出应用
 */
export const exitApp = (): void => {
  // HarmonyOS 中使用 abilityContext.terminateSelf 退出应用
  console.log('Exit app');
  // 实际实现需要使用 abilityContext.terminateSelf()
};

/**
 * 保存文件（JSON 格式，gzip 压缩）
 * @param path 文件路径
 * @param data 要保存的数据
 */
export const handleSaveFile = async (path: string, data: any): Promise<void> => => {
  // HarmonyOS 中使用 @ohos.file.fs 保存文件
  // 暂时使用 console.log 占位
  console.log(`Save file to: ${path}`);
  // 实际实现需要使用 fs.writeFile 和 gzip 压缩
};

/**
 * 读取文件（支持 gzip 解压）
 * @param path 文件路径
 * @returns 解析后的数据
 */
export const handleReadFile = async <T = unknown>(path: string): Promise<T> => {
  // HarmonyOS 中使用 @ohos.file.fs 读取文件
  // 暂时使用 console.log 占位
  console.log(`Read file from: ${path}`);
  // 实际实现需要使用 fs.readFile 和 gzip 解压
  return {} as T;
};

/**
 * 确认对话框
 * @param options 对话框选项
 * @returns 用户是否确认
 */
export const confirmDialog = async (options: {
  title?: string;
  message?: string;
  cancelButtonText?: string;
  confirmButtonText?: string;
  bgClose?: boolean;
}): Promise<boolean> => {
  // HarmonyOS 中使用 promptAction.showDialog 显示确认对话框
  // 暂时返回 true
  console.log(`Confirm dialog: ${options.title}`);
  return Promise.resolve(true);
};

/**
 * 提示对话框
 * @param options 对话框选项
 */
export const tipDialog = async (options: {
  title?: string;
  message?: string;
  btnText?: string;
  bgClose?: boolean;
}): Promise<void> => {
  // HarmonyOS 中使用 promptAction.showDialog 显示提示对话框
  console.log(`Tip dialog: ${options.title}`);
  return Promise.resolve();
};

/**
 * 复制文本到剪贴板
 * @param str 要复制的文本
 */
export const clipboardWriteText = (str: string): void => {
  // HarmonyOS 中使用 @ohos.pasteboard 系统剪贴板
  // 暂时使用 console.log 占位
  console.log(`Copy to clipboard: ${str}`);
  // 实际实现需要使用 pasteBoardSystemData.putStringData
};

/**
 * 检查通知权限
 */
export const checkNotificationPermission = async (): Promise<void> => {
  // HarmonyOS 中使用 @ohos.notifications.requestPermission 检查权限
  // 暂时占位
  console.log('Check notification permission');
};

/**
 * 检查是否忽略电池优化
 */
export const checkIgnoringBatteryOptimization = async (): Promise<void> => {
  // HarmonyOS 中检查电池优化设置
  // 暂时占位
  console.log('Check ignoring battery optimization');
};

/**
 * 重置通知权限检查
 */
export const resetNotificationPermissionCheck = async (): Promise<void> => {
  console.log('Reset notification permission check');
};

/**
 * 重置电池优化检查
 */
export const resetIgnoringBatteryOptimizationCheck = async (): Promise<void> => {
  console.log('Reset ignoring battery optimization check');
};

/**
 * 分享音乐信息
 * @param shareType 分享类型
 * @param downloadFileName 下载文件名格式
 * @param musicInfo 音乐信息
 */
export const shareMusic = (
  shareType: string,
  downloadFileName: string,
  musicInfo: any
): void => {
  const name = musicInfo.name;
  const singer = musicInfo.singer;
  const musicTitle = downloadFileName
    .replace('歌名', name)
    .replace('歌手', singer);

  if (shareType === 'system') {
    // HarmonyOS 中使用 abilityContext.startAbility 分享
    console.log(`Share music: ${musicTitle}`);
  } else if (shareType === 'clipboard') {
    clipboardWriteText(musicTitle);
    toast('已复制');
  }
};

/**
 * 监听尺寸变化
 * @param handler 尺寸变化回调
 */
export const onDimensionChange = (
  handler: (info: { window: { width: number; height: number }, screen: { width: number; height: number } }) => void
): void => {
  // HarmonyOS 中使用 window.on('resize', handler) 监听尺寸变化
  // 暂时占位
  console.log('Register dimension change listener');
};

/**
 * 获取外观模式
 */
export const getAppearance = (): 'light' | 'dark' => {
  // HarmonyOS 中使用 @ohos.app.ability.ConfigurationConstant 获取主题
  // 暂时返回 light
  return 'light';
};

/**
 * 监听外观变化
 * @param callback 外观变化回调
 */
export const onAppearanceChange = (
  callback: (colorScheme: 'light' | 'dark') => void
): void => {
  // HarmonyOS 中监听主题变化
  // 暂时占位
  console.log('Register appearance change listener');
};

/**
 * 是否支持自动主题
 */
let isSupportedAutoTheme: boolean | null = null;

export const getIsSupportedAutoTheme = (): boolean => {
  if (isSupportedAutoTheme === null) {
    // HarmonyOS NEXT 默认支持自动主题
    isSupportedAutoTheme = true;
  }
  return isSupportedAutoTheme;
};

/**
 * 显示导入失败的提示
 * @param type 导入类型
 */
export const showImportTip = (type: string): void => {
  let message: string;
  switch (type) {
    case 'defaultList':
    case 'playList':
    case 'playList_v2':
      message = '导入播放列表失败，请确保文件格式正确';
      break;
    case 'setting':
    case 'setting_v2':
      message = '导入设置失败，请确保文件格式正确';
      break;
    case 'allData':
    case 'allData_v2':
      message = '导入全部数据失败，请确保文件格式正确';
      break;
    case 'playListPart':
    case 'playListPart_v2':
      message = '导入部分播放列表失败，请确保文件格式正确';
      break;
    default:
      message = '导入失败，未知格式';
      break;
  }

  tipDialog({
    title: '导入失败',
    message,
    btnText: '确定',
  });
};

/**
 * 生成节流函数（使用 BackgroundTimer）
 * @param fn 回调函数
 * @param delay 延迟时间
 * @returns 节流后的函数
 */
export function throttleBackgroundTimer<Args extends any[]>(
  fn: (...args: Args) => void | Promise<void>,
  delay: number = 100
): (...args: Args) => void {
  let timer: number | null = null;
  let _args: Args;

  return (...args: Args) => {
    _args = args;
    if (timer) return;

    timer = setTimeout(() => {
      timer = null;
      void fn(..._args);
    }, delay);
  };
}

/**
 * 生成防抖函数（使用 BackgroundTimer）
 * @param fn 回调函数
 * @param delay 延迟时间
 * @returns 防抖后的函数
 */
export function debounceBackgroundTimer<Args extends any[]>(
  fn: (...args: Args) => void | Promise<void>,
  delay: number = 100
): (...args: Args) => void {
  let timer: number | null = null;
  let _args: Args;

  return (...args: Args) => {
    _args = args;
    if (timer) clearTimeout(timer);

    timer = setTimeout(() => {
      timer = null;
      void fn(..._args);
    }, delay);
  };
}

/**
 * 样式转换工具（适配屏幕尺寸）
 * @param styles 样式对象
 * @returns 转换后的样式对象
 */
export const transformStyle = <T extends Record<string, any>>(styles: T): T => {
  const newStyle: T = { ...styles };

  for (const [prop, value] of Object.entries(newStyle)) {
    if (typeof value !== 'number') continue;

    switch (prop) {
      case 'height':
      case 'minHeight':
      case 'marginTop':
      case 'marginBottom':
      case 'paddingTop':
      case 'paddingBottom':
      case 'paddingVertical':
        newStyle[prop] = vp2px(value);
        break;
      case 'width':
      case 'minWidth':
      case 'marginLeft':
      case 'marginRight':
      case 'paddingLeft':
      case 'paddingRight':
      case 'paddingHorizontal':
      case 'gap':
        newStyle[prop] = vp2px(value);
        break;
      case 'padding':
        newStyle.paddingRight = newStyle.paddingLeft = vp2px(value);
        newStyle.paddingBottom = newStyle.paddingTop = vp2px(value);
        break;
      case 'margin':
        newStyle.marginRight = newStyle.marginLeft = vp2px(value);
        newStyle.marginBottom = newStyle.marginTop = vp2px(value);
        break;
      case 'fontSize':
        newStyle[prop] = fp2px(value);
        break;
      default:
        // 其他属性不转换
        break;
    }
  }

  return newStyle;
};

/**
 * 创建响应式样式
 * @param styles 样式对象
 * @returns 转换后的样式对象
 */
export const createStyle = <T extends Record<string, any>>(
  styles: T
): T => {
  const newStyle: Record<string, any> = { ...styles };

  for (const [name, style] of Object.entries(newStyle)) {
    newStyle[name] = transformStyle(style);
  }

  return newStyle as T;
};

/**
 * 判断是否为横屏模式
 * @param width 宽度
 * @param height 高度
 * @returns 是否为横屏模式
 */
export const isHorizontalMode = (width: number, height: number): boolean => {
  return width / height > 1.2;
};

/**
 * 行信息接口
 */
export interface RowInfo {
  rowNum: number | undefined;
  rowWidth: `${number}%`;
}

/**
 * 行信息类型
 */
export type RowInfoType = 'full' | 'medium';

/**
 * 获取行信息
 * @param type 行类型
 * @returns 行信息对象
 */
export const getRowInfo = (type: RowInfoType = 'full'): RowInfo => {
  // 获取窗口尺寸
  const width = px2vp(window.innerWidth);
  const height = px2vp(window.innerHeight);

  const isMultiRow = isHorizontalMode(width, height);
  if (type === 'medium' && width / height < 1.8) {
    // 对于 medium 类型，只在更宽时才使用多行
    const isMultiRow = width / height > 2.0;
  }

  return {
    rowNum: isMultiRow ? 2 : undefined,
    rowWidth: isMultiRow ? '50%' : '100%',
  };
};

/**
 * 生成 MD5 哈希
 * @param text 要哈希的文本
 * @returns MD5 哈希值（小写）
 */
export const toMD5 = (text: string): string => {
  // 使用 CryptoUtil 的 md5 方法
  // 这里需要导入 CryptoUtil
  // 暂时返回占位符
  return text;
};

/**
 * 反诈提示对话框
 */
export const cheatTip = async (): Promise<void> => {
  // 暂时占位
  console.log('Cheat tip dialog');
};

/**
 * 远程歌词提示对话框
 */
export const remoteLyricTip = async (): Promise<void> => {
  // 暂时占位
  console.log('Remote lyric tip dialog');
};

/**
 * vp 转 px
 * @param value vp 值
 * @returns px 值
 */
export const vp2px = (value: number): number => {
  return Math.round(value * (window.innerWidth / 100));
};

/**
 * fp 转 px
 * @param value fp 值
 * @returns px 值
 */
export const fp2px = (value: number): number => {
  return Math.round(value * (window.fontScale || 1));
};

/**
 * 格式化时间
 * @param milliseconds 毫秒数
 * @returns 格式化后的时间字符串 (mm:ss)
 */
export const formatTime = (milliseconds: number): string => {
  const minutes = Math.floor(milliseconds / 60000);
  const seconds = Math.floor((milliseconds % 60000) / 1000);
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
};

/**
 * 格式化时间（带毫秒）
 * @param milliseconds 毫秒数
 * @returns 格式化后的时间字符串 (mm:ss.xxx)
 */
export const formatTimeWithMs = (milliseconds: number): string => {
  const minutes = Math.floor(milliseconds / 60000);
  const seconds = Math.floor((milliseconds % 60000) / 1000);
  const ms = Math.floor(milliseconds % 1000);
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${ms.toString().padStart(3, '0')}`;
};

/**
 * 深拷贝对象
 * @param obj 要拷贝的对象
 * @returns 拷贝后的对象
 */
export const deepClone = <T>(obj: T): T => {
  return JSON.parse(JSON.stringify(obj)) as T;
};

/**
 * 数组去重
 * @param arr 数组
 * @param keyFn 用于提取唯一标识的函数
 * @returns 去重后的数组
 */
export const uniqueArray = <T>(
  arr: T[],
  keyFn?: (item: T) => any
): T[] => {
  if (!keyFn) {
    return [...new Set(arr)];
  }
  const seen = new Set();
  return arr.filter(item => {
    const key = keyFn(item);
    if (seen.has(key)) {
      return false;
    }
    seen.add(key);
    return true;
  });
};

/**
 * 数组排序
 * @param arr 数组
 * @param compareFn 比较函数
 * @returns 排序后的数组
 */
export const sortArray = <T>(arr: T[], compareFn?: (a: T, b: T) => number): T[] => {
  const result = [...arr];
  result.sort(compareFn);
  return result;
};

/**
 * 数组分组
 * @param arr 数组
 * @param keyFn 用于提取分组键的函数
 * @returns 分组后的对象
 */
export const groupBy = <T, K extends string>(
  arr: T[],
  keyFn: (item: T) => K
): Record<K, T[]> => {
  return arr.reduce((acc, item) => {
    const key = keyFn(item);
    if (!acc[key]) {
      acc[key] = [];
    }
    acc[key].push(item);
    return acc;
  }, {} as Record<K, T[]>);
};

/**
 * 数组分块
 * @param arr 数组
 * @param size 块大小
 * @returns 分块后的二维数组
 */
export const chunk = <T>(arr: T[], size: number): T[][] => {
  const result: T[][] = [];
  for (let i = 0; i < arr.length; i += size) {
    result.push(arr.slice(i, i + size));
  }
  return result;
};

/**
 * 获取数组元素
 * @param arr 数组
 * @param index 索引
 * @param defaultValue 默认值
 * @returns 数组元素或默认值
 */
export const getArrayItem = <T>(arr: T[], index: number, defaultValue?: T): T | undefined => {
  if (index < 0) {
    index += arr.length;
  }
  return arr[index] ?? defaultValue;
};

/**
 * 数组映射
 * @param arr 数组
 * @param mapFn 映射函数
 * @returns 映射后的数组
 */
export const mapArray = <T, R>(arr: T[], mapFn: (item: T, index: number) => R): R[] => {
  return arr.map(mapFn);
};

/**
 * 数组过滤
 * @param arr 数组
 * @param filterFn 过滤函数
 * @returns 过滤后的数组
 */
export const filterArray = <T>(arr: T[], filterFn: (item: T, index: number) => boolean): T[] => {
  return arr.filter(filterFn);
};

/**
 * 数组查找
 * @param arr 数组
 * @param findFn 查找函数
 * @returns 查找到的元素或undefined
 */
export const findArray = <T>(arr: T[], findFn: (item: T, index: number) => boolean): T | undefined => {
  return arr.find(findFn);
};

/**
 * 数组查找索引
 * @param arr 数组
 * @param findFn 查找函数
 * @returns 查找到的索引或-1
 */
export const findArrayIndex = <T>(arr: T[], findFn: (item: T, index: number) => boolean): number => {
  return arr.findIndex(findFn);
};

/**
 * 数组是否包含元素
 * @param arr 数组
 * @param item 要查找的元素
 * @returns 是否包含
 */
export const arrayIncludes = <T>(arr: T[], item: T): boolean => {
  return arr.includes(item);
};

/**
 * 数组是否包含（使用比较函数）
 * @param arr 数组
 * @param item 要查找的元素
 * @param compareFn 比较函数
 * @returns 是否包含
 */
export const arrayIncludesWith = <T>(arr: T[], item: T, compareFn: (a: T, b: T) => boolean): boolean => {
  return arr.some(element => compareFn(element, item));
};

/**
 * 数组连接
 * @param arrays 要连接的数组
 * @returns 连接后的数组
 */
export const arrayConcat = <T>(...arrays: T[][]): T[] => {
  return arrays.flat();
};

/**
 * 对象合并
 * @param target 目标对象
 * @param sources 源对象
 * @returns 合并后的对象
 */
export const objectMerge = <T extends object>(
  target: T,
  ...sources: Partial<T>[]
): T => {
  return Object.assign(target, ...sources);
};

/**
 * 对象键列表
 * @param obj 对象
 * @returns 键列表
 */
export const objectKeys = <T extends object>(obj: T): Array<keyof T> => {
  return Object.keys(obj) as Array< keyof T>;
};

/**
 * 对象值列表
 * @param obj 对象
 * @returns 值列表
 */
export const objectValues = <T extends object>(obj: T): Array<T[keyof T]> => {
  return Object.values(obj) as Array<T[keyof T]>;
};

/**
 * 对象键值对列表
 * @param obj 对象
 * @returns 键值对列表
 */
export const objectEntries = <T extends object>(obj: T): Array<[keyof T, T[keyof T]]> {
  return Object.entries(obj) as Array<[keyof T, T[keyof T]]>;
};

/**
 * 对象是否包含键
 * @param obj 对象
 * @param key 键
 * @returns 是否包含
 */
export const objectHas = <T extends object>(obj: T, key: PropertyKey): boolean => {
  return Object.prototype.hasOwnProperty.call(obj, key);
};

/**
 * 获取嵌套对象属性
 * @param obj 对象
 * @param path 属性路径（点分隔）
 * @returns 属性值
 */
export const getNestedProperty = (obj: any, path: string): any => {
  return path.split('.').reduce((current, prop) => current?.[prop], obj);
};

/**
 * 设置嵌套对象属性
 * @param obj 对象
 * @param path 属性路径（点分隔）
 * @param value 属性值
 */
export const setNestedProperty = (obj: any, path: string, value: any): void => {
  path.split('.').reduce((current, prop, index, arr) => {
    if (index === arr.length - 1) {
      current[prop] = value;
    } else {
      current[prop] = current[prop] ?? {};
    }
    return current[prop];
  }, obj);
};

/**
 * 字符串首字母大写
 * @param str 字符串
 * @returns 首字母大写的字符串
 */
export const capitalize = (str: string): string => {
  return str ? str.charAt(0).toUpperCase() + str.slice(1) : '';
};

/**
 * 字符串首字母小写
 * @param str 字符串
 * @returns 首字母小写的字符串
 */
export const uncapitalize = (str: string): string => {
  return str ? str.charAt(0).toLowerCase() + str.slice(1) : '';
};

/**
 * 字符串驼峰转连字符
 * @param str 驼峰字符串
 * @returns 连字符字符串
 */
export const camelToKebab = (str: string): string => {
  return str.replace(/([A-Z])/g, '-$1').toLowerCase();
};

/**
 * 字符串连字符转驼峰
 * @param str 连字符字符串
 * @returns 驼峰字符串
 */
export const kebabToCamel = (str: string): string => {
  return str.replace(/-([a-z])/g, (_, c) => c.toUpperCase());
};

/**
 * 字符串驼峰转蛇形
 * @param str 驼峰字符串
 * @returns 蛇形字符串
 */
export const camelToSnake = (str: string): string => {
  return str.replace(/([A-Z])/g, '_$1').toLowerCase();
};

/**
 * 字符串蛇形转驼峰
 * @param str 蛇形字符串
 * @returns 驼峰字符串
 */
export const snakeToCamel = (str: string): string => {
  return str.replace(/_([a-z])/g, (_, c) => c.toUpperCase();
};

/**
 * 字符串截断
 * @param str 字符串
 * @param length 最大长度
 * @returns 截断后的字符串（带省略号）
 */
export const truncate = (str: string, length: number): string => {
  if (str.length <= length) return str;
  return str.slice(0, length - 3) + '...';
};

/**
 * 检查是否为空值
 * @param value 要检查的值
 * @returns 是否为空
 */
export const isEmpty = (value: any): boolean => {
  if (value === null || value === undefined) return true;
  if (typeof value === 'string') return value.trim().length === 0;
  if (Array.isArray(value)) return value.length === 0;
  if (typeof value === 'object') return Object.keys(value).length === 0;
  return false;
};

/**
 * 检查是否为非空值
 * @param value 要检查的值
 * @returns 是否为非空
 */
export const isNotEmpty = (value: any): boolean => {
  return !isEmpty(value);
};

/**
 * 延迟执行
 * @param fn 要执行的函数
 * @param delay 延迟时间（毫秒）
 * @returns 超时器 ID
 */
export const delay = (fn: () => void, delay: number = 0): NodeJS.Timeout => {
  return setTimeout(fn, delay);
};

/**
 * 取消延迟
 * @param timerId 延时器 ID
 */
export const cancelDelay = (timerId: NodeJS.Timeout): void => {
  clearTimeout(timerId);
};

/**
 * 轮询等待条件满足
 * @param condition 条件函数
 * @param interval 轮询间隔（毫秒）
 * @param timeout 超时时间（毫秒）
 * @returns 是否成功
 */
export const pollUntil = async (
  condition: () => boolean | Promise<boolean>,
  interval: number = 100,
  timeout: number = 10000
): Promise<boolean> => {
  const startTime = Date.now();
  while (Date.now() - startTime < timeout) {
    if (await condition()) {
      return true;
    }
    await new Promise(resolve => setTimeout(resolve, interval));
  }
  return false;
};

/**
 * 重试执行
 * @param fn 要执行的函数
 * @param retries 重试次数
 * @param delay 重试间隔（毫秒）
 * @returns 执行结果
 */
export const retry = async <T>(
  fn: () => Promise<T>,
  retries: number = 3,
  delay: number = 1000
): Promise<T> => {
  let lastError: unknown;
  for (let i = 0; i <= retries; i++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      if (i < retries) {
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }
  throw lastError as Error;
};

/**
 * 生成随机字符串
 * @param length 字符串长度
 * @returns 随机字符串
 */
export const randomString = (length: number = 8): string => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
};

/**
 * 生成唯一 ID
 * @returns 唯一 ID
 */
export const generateId = (): string => {
  return `${Date.now()}-${randomString(6)}`;
};

/**
 * 获取随机布尔值
 * @returns 随机布尔值
 */
export const randomBoolean = (): boolean => {
  return Math.random() < 0.5;
};

/**
 * 获取随机整数
 * @param min 最小值
 * @param max 最大值
 * @returns 随机整数
 */
export const randomInt = (min: number, max: number): number => {
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

/**
 * 获取随机浮点数
 * @param min 最小值
 * @param max 最大值
 * @returns 随机浮点数
 */
export const randomFloat = (min: number, max: number): number => {
  return Math.random() * (max - min) + min;
};

/**
 * 数组随机打乱
 * @param arr 数组
 * @returns 打乱后的数组
 */
export const shuffle = <T>(arr: T[]): T[] => {
  const result = [...arr];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
};

/**
 * 数组取第一个元素
 * @param arr 数组
 * @returns 第一个元素或undefined
 */
export const first = <T>(arr: T[]): T | undefined => {
  return arr[0];
};

/**
 * 数组取最后一个元素
 * @param arr 数组
 * @returns 最后一个元素或undefined
 */
export const last = <T>(arr: T[]): T | undefined => {
  return arr[arr.length - 1];
};

/**
 * 数组取第 n 个元素
 * @param arr 数组
 * @param n 索引（从0开始）
 * @returns 第 n 个元素或undefined
 */
export const nth = <T>(arr: T[], n: number): T | undefined => {
  return n >= 0 ? arr[n] : arr[arr.length + n];
};

/**
 * 数组取前 n 个元素
 * @param arr 数组
 * @param n 数量
 * @returns 前 n 个元素
 */
export const take = <T>(arr: T[], n: number): T[] => {
  return arr.slice(0, n);
};

/**
 * 数组跳过前 n 个元素
 * @param arr 数组
 * @param n 数量
 * @returns 剩余元素
 */
export const skip = <T>(arr: T[], n: number): T[] => {
  return arr.slice(n);
};

/**
 * 数组取前 n 个并移除它们
 * @param arr 数组
 * @param n 数量
 * @returns 前 n 个元素
 */
export const takeWhile = <T>(arr: T[], predicate: (item: T) => boolean): T[] => {
  const result: T[] = [];
  for (const item of arr) {
    if (!predicate(item)) break;
    result.push(item);
  }
  return result;
};

/**
 * 数组跳过前 n 个元素直到条件满足
 * @param arr 数组
 * @param predicate 条件函数
 * @returns 剩余元素
 */
export const skipWhile = <T>(arr: T[], predicate: (item: T) => boolean): T[] => {
  let found = false;
  return arr.filter(item => {
    if (!found && !predicate(item)) {
      return false;
    }
    found = true;
    return true;
  });
};

/**
 * 数组求和
 * @param arr 数组
 * @param getValue 值提取函数
 * @returns 总和
 */
export const sum = (arr: number[], getValue?: (item: number) => number): number => {
  return arr.reduce((acc, item) => acc + (getValue ? getValue(item) : item), 0);
};

/**
 * 数组求平均值
 * @param arr 数组
 * @returns 平均值
 */
export const average = (arr: number[]): number => {
  return arr.length ? sum(arr) / arr.length : 0;
};

/**
 * 数组求最大值
 * @param arr 数组
 * @returns 最大值
 */
export const max = (arr: number[]): number => {
  return Math.max(...arr);
};

/**
 * 数组求最小值
 * @param arr 数组
 * @returns 最小值
 */
export const min = (arr: number[]): number => {
  return Math.min(...arr);
};

/**
 * 范围随机数
 * @param min 最小值
 * @param max 最大值
 * @returns 范围内的随机整数
 */
export const rangeRandom = (min: number, max: number): number => {
  return Math.floor(Math.random() * (max - min + 1)) + min;
};

/**
 * 限制数值范围
 * @param value 数值
 * @param min 最小值
 * @param max 最大值
 * @returns 限制后的值
 */
export const clamp = (value: number, min: number, max: number): number => {
  return Math.min(Math.max(value, min), max);
};

/**
 * 线性插值
 * @param start 起始值
 * @param end 结束值
 * @param t 插值因子 (0-1)
 * @returns 插值结果
 */
export const lerp = (start: number, end: number, t: number): number => {
  return start + (end - start) * t;
};

/**
 * 线性插值（向量）
 * @param start 起始向量
 * @param end 结束向量
 * @param t 插值因子 (0-1)
 * @returns 插值结果向量
 */
export const lerpVec3 = (start: number[], end: number[], t: number): number[] => {
  return start.map((v, i) => v + (end[i] - v) * t);
};

/**
 * 角度转弧度
 * @param degrees 角度
 * @returns 弧度
 */
export const degToRad = (degrees: number): number => {
  return degrees * (Math.PI / 180);
};

/**
 * 弧度转角度
 * @param radians 弧度
 * @returns 角度
 */
export const radToDeg = (radians: number): number => {
  return radians * (180 / Math.PI);
};

/**
 * 正弦函数
 * @param degrees 角度
 * @returns 正弦值
 */
export const sin = (degrees: number): number => {
  return Math.sin(degToRad(degrees));
};

/**
 * 余弦函数
 * @param degrees 角度
 * @returns 余弦值
 */
export const cos = (degrees: number): number => {
  return Math.cos(degToRad(degrees));
};

/**
 * 正切函数
 * @param degrees 角度
 * @returns 正切值
 */
export const tan = (degrees: number): number => {
  return Math.tan(degToRad(degrees));
};

/**
 * 反正弦函数
 * @param value 正弦值
 * @returns 角度
 */
export const asin = (value: number): number => {
  return radToDeg(Math.asin(value));
};

/**
 * 反余弦函数
 * @param value 余弦值
 * @returns 角度
 */
export const acos = (value: number): number => {
  return radToDeg(Math.acos(value));
};

/**
 * 反正切函数
 * @param value 正切值
 * @returns 角度
 */
export const atan = (value: number): number => {
  return radToDeg(Math.atan(value));
};

/**
 * 反正切函数（坐标）
 * @param y Y 坐标
 * @param x X 坐标
 * @returns 角度
 */
export const atan2 = (y: number, x: number): number => {
  return radToDeg(Math.atan2(y, x));
};

/**
 * 向点取整
 * @param value 数值
 * @returns 向上取整后的整数
 */
export const ceil = (value: number): number => {
  return Math.ceil(value);
};

/**
 * 向下取整
 * @param value 数值
 * @returns 向下取整后的整数
 */
export const floor = (value: number): number => {
  return Math.floor(value);
};

/**
 * 四舍五入
 * @param value 数值
 * @returns 四舍五入后的整数
 */
export const round = (value: number): number => {
  return Math.round(value);
};

/**
 * 向上取整到最近的整数倍数
 * @param value 数值
 * @param base 倍数
 * @returns 取整后的值
 */
export const ceilTo = (value: number, base: number = 1): number => {
  return Math.ceil(value / base) * base;
};

/**
 * 向下取整到最近的整数倍数
 * @param value 数值
 * @param base 倍数
 * @returns 取整后的值
 */
export const floorTo = (value: number, base: number = 1): number => {
  return Math.floor(value / base) * base;
};

/**
 * 四舍五入到最近的整数倍数
 * @param value 数值
 * @param base 倍数
 * @returns 取整后的值
 */
export const roundTo = (value: number, base: number = 1): number => {
  return Math.round(value / base) * base;
};

/**
 * 检查数字是否为有限
 * @param value 数值
 * @returns 是否为有限
 */
export const isFinite = (value: number): boolean => {
  return Number.isFinite(value);
};

/**
 * 检查数字是否为 NaN
 * @param value 数值
 * @returns 是否为 NaN
 */
export const isNaN = (value: number): boolean => {
  return Number.isNaN(value);
};

/**
 * 检查数字是否为整数
 * @param value 数值
 * @returns 是否为整数
 */
export const isInteger = (value: number): boolean => {
  return Number.isInteger(value);
};

/**
 * 检查数字是否为正数
 * @param value 数值
 * @returns 是否为正数
 */
export const isPositive = (value: number): boolean => {
  return value > 0;
};

/**
 * 检查数字是否为负数
 * @param value 数值
 * @returns 是否为负数
 */
export const isNegative = (value: number): boolean => {
  return value < 0;
};

/**
 * 检查数字是否为零
 * @param value 数值
 * @returns 是否为零
 */
export const isZero = (value: number): boolean => {
  return value === 0;
};

/**
 * 检查数字是否为非零
 * @param value 数值
 * @returns 是否为非零
 */
export const isNonZero = (value: number): boolean => {
  return value !== 0;
};

/**
 * 检查数字是否为偶数
 * @param value 数值
 * @returns 是否为偶数
 */
export const isEven = (value: number): boolean => {
  return value % 2 === 0;
};

/**
 * 检查数字是否为奇数
 * @param value 数值
 * @returns 是否为奇数
 */
export const isOdd = (value: number): boolean => {
  return value % 2 !== 0;
};

/**
 * 比较两个值（支持数字和字符串）
 * @param a 第一个值
 * @param b 第二个值
 * @returns 比较结果
 */
export const compare = (a: any, b: any): number => {
  if (typeof a === 'number' && typeof b === 'number') {
    return a - b;
  }
  if (typeof a === 'string' && typeof b === 'string') {
    return a.localeCompare(b);
  }
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
};

/**
 * 比较两个对象
 * @param a 第一个对象
 * @param b 第二个对象
 * @returns 比较结果
 */
export const compareObjects = <T extends object>(a: T, b: T): number => {
  const keysA = Object.keys(a);
  const keysB = Object.keys(b);

  if (keysA.length !== keysB.length) {
    return keysA.length - keysB.length;
  }

  for (const key of keysA) {
    if (!Object.prototype.hasOwnProperty.call(b, key)) {
      return -1;
    }
    const valueA = a[key as keyof T];
    const valueB = b[key as keyof T];
    if (typeof valueA !== typeof valueB) {
      return typeof valueA < typeof valueB ? -1 : 1;
    }
    if (valueA !== valueB) {
      return valueA < valueB ? -1 : 1;
    }
  }

  return 0;
};

/**
 * 检查对象是否相等
 * @param a 第一个对象
 * @param b 第二个对象
 * @returns 是否相等
 */
export const objectsEqual = <T extends object>(a: T, b: T): boolean => {
  return deepClone(a) === deepClone(b);
};

/**
 * 检查数组是否相等
 * @param a 第一个数组
 * @param b 第二个数组
 * @returns 是否相等
 */
export const arraysEqual = <T>(a: T[], b: T[]): boolean => {
  if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++) {
    if (!objectsEqual(a[i], b[i])) return false;
  }
  return true;
};

export default CommonUtil;
