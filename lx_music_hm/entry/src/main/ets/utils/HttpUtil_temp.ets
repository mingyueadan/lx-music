/**
 * HTTP请求工具类 - 鸿蒙版
 * 移植自 lx-music-mobile/src/utils/request.js
 */

import http from '@ohos.net.http';
import util from '@ohos.util';

/**
 * 请求消息定义
 */
interface RequestMsg {
  unachievable: string;
  timeout: string;
  notConnectNetwork: string;
}

const requestMsg: RequestMsg = {
  unachievable: '无法访问',
  timeout: '请求超时',
  notConnectNetwork: '网络连接失败'
};

/**
 * 默认请求头
 */
interface DefaultHeaders {
  'User-Agent': string;
}

const defaultHeaders: DefaultHeaders = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36',
};

/**
 * 请求选项接口
 */
export interface RequestOptions {
  method?: http.RequestMethod;
  headers?: Record<string, string>;
  body?: string | Record<string, string>;
  form?: Record<string, string>;
  formData?: Record<string, string>;
  binary?: boolean;
  cache?: string;
  timeout?: number;
}

/**
 * 响应接口
 */
export interface HttpResponse {
  headers: Record<string, string>;
  body: Record<string, string> | string | ArrayBuffer;
  statusCode: number;
  url: string;
  ok: boolean;
}

/**
 * 取消令牌接口
 */
export interface CancelToken {
  cancel: () => void;
}

/**
 * HTTP请求结果
 */
export interface HttpFetchResult {
  promise: Promise<HttpResponse>;
  cancelHttp: () => void;
}

/**
 * 请求对象接口
 */
interface RequestObject {
  request: Promise<HttpResponse>;
  abort: () => void;
}

/**
 * 请求超时自动重试
 * @param url 请求URL
 * @param options 请求选项
 * @returns 请求结果对象
 */
export function httpFetch(url: string, options: RequestOptions = { method: http.RequestMethod.GET }): HttpFetchResult {
  const requestObj = fetchData(url, options);
  return {
    promise: requestObj.request.catch((err: Error) => {
      console.error('HTTP请求出错', err.message);
      switch (err.message) {
        case 'socket hang up':
          return Promise.reject(new Error(requestMsg.unachievable));
        case 'Aborted':
          return Promise.reject(new Error(requestMsg.timeout));
        case 'Network request failed':
          return Promise.reject(new Error(requestMsg.notConnectNetwork));
        default:
          return Promise.reject(err);
      }
    }),
    cancelHttp() {
      requestObj.abort();
    },
  };
}

/**
 * HTTP GET请求
 * @param url 请求URL
 * @param options 请求选项
 * @param callback 回调函数
 * @returns 取消函数
 */
export function httpGet(
  url: string,
  options: RequestOptions | Function,
  callback?: Function
): CancelToken {
  let actualOptions: RequestOptions = {};
  let actualCallback: Function;

  if (typeof options === 'function') {
    actualCallback = options;
    actualOptions = {};
  } else {
    actualOptions = options;
    actualCallback = callback!;
  }

  const mergedOptions: RequestOptions = { method: http.RequestMethod.GET };
  if (actualOptions.method) {
    mergedOptions.method = actualOptions.method;
  }
  if (actualOptions.headers) {
    mergedOptions.headers = actualOptions.headers;
  }
  if (actualOptions.body) {
    mergedOptions.body = actualOptions.body;
  }
  if (actualOptions.form) {
    mergedOptions.form = actualOptions.form;
  }
  if (actualOptions.formData) {
    mergedOptions.formData = actualOptions.formData;
  }
  if (actualOptions.binary) {
    mergedOptions.binary = actualOptions.binary;
  }
  if (actualOptions.cache) {
    mergedOptions.cache = actualOptions.cache;
  }
  if (actualOptions.timeout) {
    mergedOptions.timeout = actualOptions.timeout;
  }

  const requestObj = fetchData(url, mergedOptions);
  requestObj.request.then((resp: HttpResponse) => {
    actualCallback(null, resp, resp.body);
  }).catch((err: Error) => {
    actualCallback(err, null, null);
  });

  return {
    cancel: () => {
      requestObj.abort();
    }
  };
}

/**
 * 处理表单数据
 * @param form 表单对象
 * @returns 表单字符串
 */
function handleFormData(form: Record<string, string>): string {
  const formBody: string[] = [];
  const keys: string[] = Object.keys(form);
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    const value = form[key];
    const encodedKey = encodeURIComponent(key);
    const encodedValue = encodeURIComponent(value);
    formBody.push(`${encodedKey}=${encodedValue}`);
  }
  return formBody.join('&');
}

/**
 * 处理请求数据
 * @param url 请求URL
 * @param options 请求选项
 * @returns 处理后的请求选项
 */
async function handleRequestData(url: string, options: RequestOptions): Promise<http.HttpRequestOptions> {
  const method = options.method || http.RequestMethod.GET;
  const headers = options.headers || {};
  let body = options.body;
  const form = options.form;
  const formData = options.formData;
  const cache = options.cache || 'no-store';

  let actualHeaders: Record<string, string> = headers;

  // 设置默认Accept头
  actualHeaders['Accept'] = 'application/json';
  const keys: string[] = Object.keys(headers);
  for (let i = 0; i < keys.length; i++) {
    actualHeaders[keys[i]] = headers[keys[i]];
  }

  // 处理POST请求的Content-Type和body
  if (method === http.RequestMethod.POST && !actualHeaders['Content-Type']) {
    if (form) {
      actualHeaders['Content-Type'] = 'application/x-www-form-urlencoded';
      body = handleFormData(form);
    } else if (formData) {
      actualHeaders['Content-Type'] = 'multipart/form-data';
      body = formData;
    } else {
      actualHeaders['Content-Type'] = 'application/json';
    }
  }

  // 序列化JSON body
  let extraData: string | undefined = undefined;
  if (actualHeaders['Content-Type'] === 'application/json' && body && typeof body === 'object') {
    extraData = JSON.stringify(body);
  } else if (body) {
    extraData = typeof body === 'string' ? body : String(body);
  }

  // 合并headers
  const mergedHeaders: Record<string, string> = {};
  const defaultKeys: string[] = Object.keys(defaultHeaders);
  for (let i = 0; i < defaultKeys.length; i++) {
      const key = defaultKeys[i];
      if (key === 'User-Agent') {
        mergedHeaders[key] = defaultHeaders['User-Agent'];
      }
  }
  const actualKeys: string[] = Object.keys(actualHeaders);
  for (let i = 0; i < actualKeys.length; i++) {
    mergedHeaders[actualKeys[i]] = actualHeaders[actualKeys[i]];
  }

  return {
    method,
    header: mergedHeaders,
    extraData: extraData,
    readTimeout: options.timeout || 15000,
    connectTimeout: options.timeout || 15000,
  };
}

/**
 * 处理响应数据
 * @param response HTTP响应
 * @param binary 是否为二进制数据
 * @returns 处理后的响应对象
 */
async function handleResponse(response: http.HttpResponse, binary: boolean = false): Promise<HttpResponse> {
  const headers: Record<string, string> = {};
  const headerObj: Record<string, Object> = response.header as Record<string, Object>;
  const keys: string[] = Object.keys(headerObj);
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    const value = headerObj[key];
    headers[key] = value as string;
  }

  const result: HttpResponse = {
    headers,
    body: '',
    statusCode: response.responseCode,
    url: '',
    ok: response.responseCode >= 200 && response.responseCode < 300,
  };

  if (binary) {
    // 处理二进制数据
    const arrayBuffer = response.result as ArrayBuffer;
    result.body = arrayBuffer;
  } else {
    // 处理文本数据
    const text = response.result as string;
    try {
      result.body = JSON.parse(text);
    } catch {
      result.body = text;
    }
  }

  return result;
}

/**
 * 获取数据
 * @param url 请求URL
 * @param options 请求选项
 * @returns 请求对象
 */
function fetchData(url: string, options: RequestOptions): RequestObject {
  console.log('---HTTP请求开始---', url);

  let httpRequest: http.HttpRequest | null = null;
  let isAborted = false;

  const requestPromise = handleRequestData(url, options).then((httpOptions) => {
    httpRequest = http.createHttp();

    return new Promise<HttpResponse>((resolve, reject) => {
      httpRequest!.request(url, httpOptions, (err, data) => {
        if (isAborted) {
          reject(new Error('Aborted'));
          return;
        }

        if (err) {
          reject(err);
          return;
        }

        handleResponse(data, options.binary || false)
          .then(resolve)
          .catch(reject)
          .finally(() => {
            httpRequest!.destroy();
          });
      });
    });
  });

  return {
    request: requestPromise,
    abort() {
      isAborted = true;
      if (httpRequest) {
        httpRequest.destroy();
      }
    },
  };
}

/**
 * 检查URL是否可访问
 * @param url 请求URL
 * @param options 请求选项
 * @returns Promise<void>
 */
export async function checkUrl(url: string, options: RequestOptions = {}): Promise<void> {
  const mergedOptions: RequestOptions = { method: http.RequestMethod.HEAD };
  if (options.method) {
    mergedOptions.method = options.method;
  }
  if (options.headers) {
    mergedOptions.headers = options.headers;
  }
  if (options.body) {
    mergedOptions.body = options.body;
  }
  if (options.form) {
    mergedOptions.form = options.form;
  }
  if (options.formData) {
    mergedOptions.formData = options.formData;
  }
  if (options.binary) {
    mergedOptions.binary = options.binary;
  }
  if (options.cache) {
    mergedOptions.cache = options.cache;
  }
  if (options.timeout) {
    mergedOptions.timeout = options.timeout;
  }
  mergedOptions.method = http.RequestMethod.HEAD;
  return fetchData(url, mergedOptions).request.then((resp: HttpResponse) => {
    if (resp.statusCode === 200) {
      return Promise.resolve();
    } else {
      throw new Error(resp.statusCode.toString());
    }
  });
}

/**
 * POST请求
 * @param url 请求URL
 * @param body 请求体
 * @param options 请求选项
 * @returns 请求结果对象
 */
export function httpPost(url: string, body: Object | string, options: RequestOptions = {}): HttpFetchResult {
  const mergedOptions: RequestOptions = { method: http.RequestMethod.POST, body: body as string | Record<string, string> };
  if (options.method) {
    mergedOptions.method = options.method;
  }
  if (options.headers) {
    mergedOptions.headers = options.headers;
  }
  if (options.form) {
    mergedOptions.form = options.form;
  }
  if (options.formData) {
    mergedOptions.formData = options.formData;
  }
  if (options.binary) {
    mergedOptions.binary = options.binary;
  }
  if (options.cache) {
    mergedOptions.cache = options.cache;
  }
  if (options.timeout) {
    mergedOptions.timeout = options.timeout;
  }
  mergedOptions.method = http.RequestMethod.POST;
  mergedOptions.body = body as string | Record<string, string>;
  return httpFetch(url, mergedOptions);
}

/**
 * PUT请求
 * @param url 请求URL
 * @param body 请求体
 * @param options 请求选项
 * @returns 请求结果对象
 */
export function httpPut(url: string, body: Object | string, options: RequestOptions = {}): HttpFetchResult {
  const mergedOptions: RequestOptions = { method: http.RequestMethod.PUT, body: body as string | Record<string, string> };
  if (options.method) {
    mergedOptions.method = options.method;
  }
  if (options.headers) {
    mergedOptions.headers = options.headers;
  }
  if (options.form) {
    mergedOptions.form = options.form;
  }
  if (options.formData) {
    mergedOptions.formData = options.formData;
  }
  if (options.binary) {
    mergedOptions.binary = options.binary;
  }
  if (options.cache) {
    mergedOptions.cache = options.cache;
  }
  if (options.timeout) {
    mergedOptions.timeout = options.timeout;
  }
  mergedOptions.method = http.RequestMethod.PUT;
  mergedOptions.body = body as string | Record<string, string>;
  return httpFetch(url, mergedOptions);
}

/**
 * DELETE请求
 * @param url 请求URL
 * @param options 请求选项
 * @returns 请求结果对象
 */
export function httpDelete(url: string, options: RequestOptions = {}): HttpFetchResult {
  const mergedOptions: RequestOptions = { method: http.RequestMethod.DELETE };
  if (options.method) {
    mergedOptions.method = options.method;
  }
  if (options.headers) {
    mergedOptions.headers = options.headers;
  }
  if (options.form) {
    mergedOptions.form = options.form;
  }
  if (options.formData) {
    mergedOptions.formData = options.formData;
  }
  if (options.binary) {
    mergedOptions.binary = options.binary;
  }
  if (options.cache) {
    mergedOptions.cache = options.cache;
  }
  if (options.timeout) {
    mergedOptions.timeout = options.timeout;
  }
  mergedOptions.method = http.RequestMethod.DELETE;
  return httpFetch(url, mergedOptions);
}
