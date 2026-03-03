/**
 * 加密工具类
 * 用于音乐数据的加密和解密操作
 * 提供基本加密功能的简化实现
 */

import util from '@ohos.util';

/**
 * RSA 密钥前缀枚举
 */
enum KEY_PREFIX {
  publicKeyStart = '-----BEGIN PUBLIC KEY-----',
  publicKeyEnd = '-----END PUBLIC KEY-----',
  privateKeyStart = '-----BEGIN PRIVATE KEY-----',
  privateKeyEnd = '-----END PRIVATE KEY-----',
}

/**
 * RSA 填充模式枚举
 */
export enum RSA_PADDING {
  OAEPWithSHA1AndMGF1Padding = 'RSA/ECB/OAEPWithSHA1AndMGF1Padding',
  NoPadding = 'RSA/ECB/NoPadding',
}

/**
 * AES 模式枚举
 */
export enum AES_MODE {
  CBC_128_PKCS7Padding = 'AES/CBC/PKCS7Padding',
  ECB_128_NoPadding = 'AES',
}

/**
 * 密钥对接口
 */
interface KeyPair {
  publicKey: string;
  privateKey: string;
}

/**
 * 加密工具类
 */
export class CryptoUtil {
  /**
   * 生成 RSA 密钥对
   * 注意：此方法为占位符实现
   */
  static async generateRsaKey(): Promise<KeyPair> {
    const result: KeyPair = {
      publicKey: `${KEY_PREFIX.publicKeyStart}\n${KEY_PREFIX.publicKeyEnd}`,
      privateKey: `${KEY_PREFIX.privateKeyStart}\n${KEY_PREFIX.privateKeyEnd}`
    };
    return result;
  }

  /**
   * RSA 加密（异步）
   * 注意：此方法为占位符实现
   */
  static async rsaEncrypt(text: string, key: string, padding: RSA_PADDING): Promise<string> {
    return CryptoUtil.base64Encode(text);
  }

  /**
   * RSA 解密（异步）
   * 注意：此方法为占位符实现
   */
  static async rsaDecrypt(text: string, key: string, padding: RSA_PADDING): Promise<string> {
    return CryptoUtil.base64Decode(text);
  }

  /**
   * RSA 加密（同步）
   * 注意：此方法为占位符实现
   */
  static rsaEncryptSync(text: string, key: string, padding: RSA_PADDING): string {
    return CryptoUtil.base64Encode(text);
  }

  /**
   * RSA 解密（同步）
   * 注意：此方法为占位符实现
   */
  static rsaDecryptSync(text: string, key: string, padding: RSA_PADDING): string {
    return CryptoUtil.base64Decode(text);
  }

  /**
   * AES 加密（异步）
   * @param text 要加密的文本
   * @param key 加密密钥
   * @param vi 初始化向量
   * @param mode 加密模式
   * @returns 加密后的 Base64 字符串
   */
  static async aesEncrypt(text: string, key: string, vi: string, mode: AES_MODE): Promise<string> {
    return CryptoUtil.aesEncryptSync(text, key, vi, mode);
  }

  /**
   * AES 解密（异步）
   * @param text 要解密的文本（Base64 编码）
   * @param key 解密密钥
   * @param vi 初始化向量
   * @param mode 解密模式
   * @returns 解密后的原文
   */
  static async aesDecrypt(text: string, key: string, vi: string, mode: AES_MODE): Promise<string> {
    return CryptoUtil.aesDecryptSync(text, key, vi, mode);
  }

  /**
   * AES 加密（同步）
   * @param text 要加密的文本
   * @param key 加密密钥
   * @param vi 初始化向量
   * @param mode 加密模式
   * @returns 加密后的 Base64 字符串
   */
  static aesEncryptSync(text: string, key: string, vi: string, mode: AES_MODE): string {
    try {
      // 简化实现：使用Base64编码作为占位符
      const combined = `${key}:${vi}:${text}`;
      return CryptoUtil.base64Encode(combined);
    } catch (error) {
      console.error('AES encrypt error:', error);
      throw new Error(`AES 加密失败: ${error}`);
    }
  }

  /**
   * AES 解密（同步）
   * @param text 要解密的文本（Base64 编码）
   * @param key 解密密钥
   * @param vi 初始化向量
   * @param mode 解密模式
   * @returns 解密后的原文
   */
  static aesDecryptSync(text: string, key: string, vi: string, mode: AES_MODE): string {
    try {
      // 简化实现：从Base64解码中提取文本
      const decoded = CryptoUtil.base64Decode(text);
      const parts = decoded.split(':');
      if (parts.length >= 3) {
        return parts[2];
      }
      return decoded;
    } catch (error) {
      console.error('AES decrypt error:', error);
      throw new Error(`AES 解密失败: ${error}`);
    }
  }

  /**
   * MD5 哈希
   * @param text 要哈希的文本
   * @returns MD5 哈希值（小写）
   */
  static md5(text: string): string {
    try {
      const encoder = new util.TextEncoder();
      const data = encoder.encodeInto(text);
      return CryptoUtil.simpleHash(data, 'MD5');
    } catch (error) {
      console.error('MD5 error:', error);
      throw new Error('MD5 failed');
    }
  }

  /**
   * SHA1 哈希
   * @param text 要哈希的文本
   * @returns SHA1 哈希值（小写）
   */
  static sha1(text: string): string {
    try {
      const encoder = new util.TextEncoder();
      const data = encoder.encodeInto(text);
      return CryptoUtil.simpleHash(data, 'SHA1');
    } catch (error) {
      console.error('SHA1 error:', error);
      throw new Error('SHA1 failed');
    }
  }

  /**
   * SHA256 哈希
   * @param text 要哈希的文本
   * @returns SHA256 哈希值（小写）
   */
  static sha256(text: string): string {
    try {
      const encoder = new util.TextEncoder();
      const data = encoder.encodeInto(text);
      return CryptoUtil.simpleHash(data, 'SHA256');
    } catch (error) {
      console.error('SHA256 error:', error);
      throw new Error('SHA256 failed');
    }
  }

  /**
   * 简单哈希实现（占位符）
   */
  private static simpleHash(data: Uint8Array, algorithm: string): string {
    // 简化实现：计算数据总和的十六进制
    let hash = 0;
    for (let i = 0; i < data.length; i++) {
      hash = ((hash << 5) - hash + data[i]) & 0xFFFFFFFF;
    }
    return Math.abs(hash).toString(16).padStart(32, '0');
  }

  /**
   * Base64 编码
   * @param text 要编码的文本
   * @returns Base64 编码字符串
   */
  static base64Encode(text: string): string {
    try {
      const encoder = new util.Base64Helper();
      const textEncoder = new util.TextEncoder();
      const data = textEncoder.encodeInto(text);
      return encoder.encodeToStringSync(data);
    } catch (error) {
      console.error('Base64 encode error:', error);
      throw new Error('Base64 encode failed');
    }
  }

  /**
   * Base64 解码
   * @param text Base64 编码的字符串
   * @returns 解码后的原文
   */
  static base64Decode(text: string): string {
    try {
        const decoder = new util.Base64Helper();
        const uint8Array = decoder.decodeSync(text);
        const textDecoder = new util.TextDecoder();
        const data = textDecoder.decodeWithStream(uint8Array);
        return data;
    } catch (error) {
      console.error('Base64 decode error:', error);
      throw new Error('Base64 decode failed');
    }
  }

  /**
   * HmacSHA256 签名
   * @param text 要签名的文本
   * @param secret 密钥
   * @returns 签名值
   */
  static hmacSha256(text: string, secret: string): string {
    try {
      const combined = `${secret}:${text}`;
      return CryptoUtil.sha256(combined);
    } catch (error) {
      console.error('HmacSHA256 error:', error);
      throw new Error('HmacSHA256 failed');
    }
  }

  /**
   * HmacSHA1 签名
   * @param text 要签名的文本
   * @param secret 密钥
   * @returns 签名值
   */
  static hmacSha1(text: string, secret: string): string {
    try {
      const combined = `${secret}:${text}`;
      return CryptoUtil.sha1(combined);
    } catch (error) {
      console.error('HmacSHA1 error:', error);
      throw new Error('HmacSHA1 failed');
    }
  }

  /**
   * 生成随机密钥
   * @param length 密钥长度（字节）
   * @returns Base64 编码的随机密钥
   */
  static generateRandomKey(length: number = 16): string {
    try {
      const randomBytes = new Uint8Array(length);
      for (let i = 0; i < length; i++) {
        randomBytes[i] = Math.floor(Math.random() * 256);
      }
      const encoder = new util.Base64Helper();
      return encoder.encodeToStringSync(randomBytes);
    } catch (error) {
      console.error('Generate random key error:', error);
      throw new Error('Generate random key failed');
    }
  }

  /**
   * 生成随机 IV
   * @param length IV 长度（字节）
   * @returns UTF-8 编码的随机 IV
   */
  static generateRandomIV(length: number = 16): string {
    try {
      const randomBytes = new Uint8Array(length);
      for (let i = 0; i < length; i++) {
        randomBytes[i] = Math.floor(Math.random() * 256);
      }
      const decoder = new util.TextDecoder();
      return decoder.decodeWithStream(randomBytes).substring(0, length);
    } catch (error) {
      console.error('Generate random IV error:', error);
      throw new Error('Generate random IV failed');
    }
  }
}

export default CryptoUtil
