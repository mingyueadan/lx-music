import http from '@ohos.net.http'

/**
 * 网络服务
 * 统一管理网络请求
 */
export class NetworkService {
  private static instance: NetworkService
  private defaultTimeout: number = 15000

  private constructor() {
  }

  static getInstance(): NetworkService {
    if (!NetworkService.instance) {
      NetworkService.instance = new NetworkService()
    }
    return NetworkService.instance
  }

  /**
   * GET请求
   * @param url 请求地址
   * @param params 请求参数
   * @param headers 请求头
   */
  async get(url: string, params?: Object, headers?: Object): Promise<HttpResponse> {
    return this.request(url, 'GET', params, headers)
  }

  /**
   * POST请求
   * @param url 请求地址
   * @param data 请求数据
   * @param headers 请求头
   */
  async post(url: string, data?: Object, headers?: Object): Promise<HttpResponse> {
    return this.request(url, 'POST', data, headers)
  }

  /**
   * PUT请求
   * @param url 请求地址
   * @param data 请求数据
   * @param headers 请求头
   */
  async put(url: string, data?: Object, headers?: Object): Promise<HttpResponse> {
    return this.request(url, 'PUT', data, headers)
  }

  /**
   * DELETE请求
   * @param url 请求地址
   * @param params 请求参数
   * @param headers 请求头
   */
  async delete(url: string, params?: Object, headers?: Object): Promise<HttpResponse> {
    return this.request(url, 'DELETE', params, headers)
  }

  /**
   * 统一请求方法
   * @param url 请求地址
   * @param method 请求方法
   * @param data 请求数据
   * @param headers 请求头
   */
  private async request(url: string, method: string, data?: Object, headers?: Object): Promise<HttpResponse> {
    try {
      console.log(`[NetworkService] ${method} 请求: ${url}`)

      // 创建HTTP请求
      const httpRequest = http.createHttp()

      // 设置请求头
      const requestHeaders = {
        'Content-Type': 'application/json',
        ...headers
      }

      // 构建请求选项
      const requestOption: http.HttpRequestOptions = {
        method: http.RequestMethod[method as keyof typeof http.RequestMethod] || http.RequestMethod.GET,
        header: requestHeaders,
        connectTimeout: this.defaultTimeout,
        readTimeout: this.defaultTimeout,
        extraData: data
      }

      // 发送请求
      const response = await httpRequest.request(url, requestOption)

      // 解析响应
      const result: HttpResponse = {
        statusCode: response.responseCode,
        data: response.result as Object,
        headers: response.header
      }

      console.log(`[NetworkService] ${method} 响应: ${result.statusCode}`)

      // 关闭请求
      httpRequest.destroy()

      return result
    } catch (error) {
      console.error('[NetworkService] 请求失败:', error)
      throw error
    }
  }

  /**
   * 设置超时时间
   * @param timeout 超时时间(毫秒)
   */
  setTimeout(timeout: number): void {
    this.defaultTimeout = timeout
  }
}

/**
 * HTTP响应接口
 */
export interface HttpResponse {
  statusCode: number // 状态码
  data: Object // 响应数据
  headers: Object // 响应头
}
