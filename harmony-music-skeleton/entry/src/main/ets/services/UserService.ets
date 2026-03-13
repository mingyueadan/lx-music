import { EventEmitter } from '../event/EventEmitter'

/**
 * 用户信息模型
 */
export class UserModel {
  id: string
  name: string
  avatar: string
  email: string

  constructor(data: Partial<UserModel> = {}) {
    this.id = data.id || ''
    this.name = data.name || ''
    this.avatar = data.avatar || ''
    this.email = data.email || ''
  }
}

/**
 * 用户服务
 */
export class UserService extends EventEmitter {
  private static instance: UserService

  private _user: UserModel | null = null
  private _isLoggedIn: boolean = false

  private constructor() {
    super()
  }

  static getInstance(): UserService {
    if (!UserService.instance) {
      UserService.instance = new UserService()
    }
    return UserService.instance
  }

  /**
   * 初始化用户服务
   */
  async init(): Promise<void> {
    console.log('[UserService] 初始化完成')
    // TODO: 加载用户信息
  }

  /**
   * 用户登录
   */
  async login(username: string, password: string): Promise<UserModel> {
    try {
      console.log('[UserService] 用户登录:', username)
      // TODO: 实际登录逻辑

      const user = new UserModel({
        id: '1',
        name: username,
        avatar: '',
        email: ''
      })

      this._user = user
      this._isLoggedIn = true

      this.emit('login', user)
      this.emit('loginStateChanged', true)

      return user
    } catch (error) {
      console.error('[UserService] 登录失败:', error)
      throw error
    }
  }

  /**
   * 用户登出
   */
  async logout(): Promise<void> {
    try {
      console.log('[UserService] 用户登出')
      // TODO: 实际登出逻辑

      this._user = null
      this._isLoggedIn = false

      this.emit('logout')
      this.emit('loginStateChanged', false)
    } catch (error) {
      console.error('[UserService] 登出失败:', error)
      throw error
    }
  }

  /**
   * 更新用户信息
   */
  async updateUser(user: Partial<UserModel>): Promise<UserModel> {
    try {
      console.log('[UserService] 更新用户信息')
      // TODO: 实际更新逻辑

      if (this._user) {
        this._user = { ...this._user, ...user }
        this.emit('userUpdated', this._user)
      }

      return this._user!
    } catch (error) {
      console.error('[UserService] 更新用户信息失败:', error)
      throw error
    }
  }

  // Getters
  get user(): UserModel | null {
    return this._user
  }

  get isLoggedIn(): boolean {
    return this._isLoggedIn
  }
}
