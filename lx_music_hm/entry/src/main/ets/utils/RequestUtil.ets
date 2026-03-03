/**
 * 网络请求工具类
 * 基于 HarmonyOS 原生HTTP模块实现
 */

/**
 * 请求配置接口
 */
interface RequestConfig {
  url: string;
  method?: string;
  data?: Object;
  headers?: Record<string, string>;
  timeout?: number;
}

/**
 * 响应接口
 */
interface ResponseData {
  data: Object;
  status: number;
  headers?: Record<string, string>;
}

/**
 * 网络请求工具类
 */
export class RequestUtil {
  private static instance: RequestUtil;

  private constructor() {}

  /**
   * 获取单例
   */
  static getInstance(): RequestUtil {
    if (!RequestUtil.instance) {
      RequestUtil.instance = new RequestUtil();
    }
    return RequestUtil.instance;
  }

  /**
   * 发送请求
   */
  private async request(config: RequestConfig): Promise<ResponseData> {
    const method = config.method || 'GET';
    const url = config.url;
    const headers = config.headers || {};

    try {
      // TODO: 使用 HarmonyOS HTTP 模块
      // 暂时返回模拟数据
      return {
        data: {},
        status: 200
      };
    } catch (error) {
      console.error('Request failed:', error);
      throw error;
    }
  }

  /**
   * GET 请求
   */
  async get(url: string, params?: Object, headers?: Record<string, string>): Promise<Object> {
    const config: RequestConfig = {
      url,
      method: 'GET',
      headers
    };

    const response = await this.request(config);
    return response.data;
  }

  /**
   * POST 请求
   */
  async post(url: string, data?: Object, headers?: Record<string, string>): Promise<Object> {
    const config: RequestConfig = {
      url,
      method: 'POST',
      data,
      headers
    };

    const response = await this.request(config);
    return response.data;
  }

  /**
   * PUT 请求
   */
  async put(url: string, data?: Object, headers?: Record<string, string>): Promise<Object> {
    const config: RequestConfig = {
      url,
      method: 'PUT',
      data,
      headers
    };

    const response = await this.request(config);
    return response.data;
  }

  /**
   * DELETE 请求
   */
  async delete(url: string, headers?: Record<string, string>): Promise<Object> {
    const config: RequestConfig = {
      url,
      method: 'DELETE',
      headers
    };

    const response = await this.request(config);
    return response.data;
  }
}
