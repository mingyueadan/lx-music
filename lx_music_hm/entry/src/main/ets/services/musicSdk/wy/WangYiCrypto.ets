/**
 * 网易云音乐加密工具
 * 移植自 lx-music-mobile/src/utils/musicSdk/wy/utils/crypto.js
 */

import { CryptoUtil, AES_MODE, RSA_PADDING } from '../../../utils/CryptoUtil';

const IV: string = CryptoUtil.base64Encode('0102030405060708');
const PRESET_KEY: string = CryptoUtil.base64Encode('0CoJUm6Qyw8W8jud');
const LINUX_API_KEY: string = CryptoUtil.base64Encode('rFgB&h#%2?^eDg:Q');
const EAPI_KEY: string = CryptoUtil.base64Encode('e82ckenh8dichen8');

const PUBLIC_KEY: string = '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB\n-----END PUBLIC KEY-----';

/**
 * 加密结果接口
 */
export interface WeapiResult {
  params: string;
  encSecKey: string;
}

/**
 * Linux API 加密结果接口
 */
export interface LinuxapiResult {
  eparams: string;
}

/**
 * EAPI 加密结果接口
 */
export interface EapiResult {
  params: string;
}

/**
 * 网易云音乐 weapi 加密
 * @param object 要加密的对象
 * @returns 加密结果 { params, encSecKey }
 */
export function weapi(object: Record<string, string | number | boolean>): WeapiResult {
  const text: string = JSON.stringify(object);
  const secretKey: string = String(Math.random()).substring(2, 18);

  // 第一次 AES 加密
  const firstEncrypt: string = CryptoUtil.aesEncryptSync(
    CryptoUtil.base64Encode(text),
    PRESET_KEY,
    IV,
    AES_MODE.CBC_128_PKCS7Padding
  );

  // 第二次 AES 加密
  const params: string = CryptoUtil.aesEncryptSync(
    firstEncrypt,
    CryptoUtil.base64Encode(secretKey),
    IV,
    AES_MODE.CBC_128_PKCS7Padding
  );

  // RSA 加密密钥 - 使用 util 模块替代 TextEncoder
  const secretKeyBuffer: string = CryptoUtil.base64Encode(secretKey);
  const reversedSecretKey: string = secretKeyBuffer.split('').reverse().join('');
  const encSecKey: string = CryptoUtil.rsaEncryptSync(reversedSecretKey, PUBLIC_KEY, RSA_PADDING.NoPadding);

  const result: WeapiResult = {
    params,
    encSecKey
  };
  return result;
}

/**
 * 网易云音乐 linuxapi 加密
 * @param object 要加密的对象
 * @returns 加密结果 { eparams }
 */
export function linuxapi(object: Record<string, string | number | boolean>): LinuxapiResult {
  const text: string = JSON.stringify(object);
  const encrypted: string = CryptoUtil.aesEncryptSync(
    CryptoUtil.base64Encode(text),
    LINUX_API_KEY,
    '',
    AES_MODE.ECB_128_NoPadding
  );

  // 转换为大写十六进制
  const eparams: string = encrypted.toUpperCase();

  const result: LinuxapiResult = {
    eparams
  };
  return result;
}

/**
 * 网易云音乐 eapi 加密
 * @param url 请求URL
 * @param object 要加密的对象或字符串
 * @returns 加密结果 { params }
 */
export function eapi(url: string, object: Record<string, string | number | boolean> | string): EapiResult {
  const text: string = typeof object === 'object' ? JSON.stringify(object) : object;
  const message: string = `nobody${url}use${text}md5forencrypt`;
  const digest: string = CryptoUtil.md5(message);
  const data: string = `${url}-36cd479b6b5-${text}-36cd479b6b5-${digest}`;

  const encrypted: string = CryptoUtil.aesEncryptSync(
    CryptoUtil.base64Encode(data),
    EAPI_KEY,
    '',
    AES_MODE.ECB_128_NoPadding
  );

  // 转换为大写十六进制
  const params: string = encrypted.toUpperCase();

  const result: EapiResult = {
    params
  };
  return result;
}

/**
 * 网易云音乐 eapi 解密
 * @param cipherText 加密的文本
 * @returns 解密后的文本
 */
export function eapiDecrypt(cipherText: string): string {
  return CryptoUtil.aesDecryptSync(
    cipherText,
    EAPI_KEY,
    '',
    AES_MODE.ECB_128_NoPadding
  );
}
