/**
 * 事件发射器基类
 * 提供事件的订阅、取消订阅、触发功能
 */
export class EventEmitter {
  private listeners: Map<string, Array<(...args: any[]) => void>> = new Map()

  /**
   * 订阅事件
   * @param eventName 事件名称
   * @param listener 事件监听器
   */
  on(eventName: string, listener: (...args: any[]) => void): void {
    if (!this.listeners.has(eventName)) {
      this.listeners.set(eventName, [])
    }
    this.listeners.get(eventName)?.push(listener)
  }

  /**
   * 取消订阅
   * @param eventName 事件名称
   * @param listener 事件监听器
   */
  off(eventName: string, listener?: (...args: any[]) => void): void {
    const targetListeners = this.listeners.get(eventName)
    if (!targetListeners) return

    if (listener) {
      const index = targetListeners.indexOf(listener)
      if (index >= 0) {
        targetListeners.splice(index, 1)
      }
    } else {
      this.listeners.delete(eventName)
    }
  }

  /**
   * 触发事件
   * @param eventName 事件名称
   * @param args 事件参数
   */
  emit(eventName: string, ...args: any[]): void {
    const targetListeners = this.listeners.get(eventName)
    if (!targetListeners) return

    targetListeners.forEach(listener => {
      try {
        listener(...args)
      } catch (error) {
        console.error(`[EventEmitter] 事件监听器错误 [${eventName}]:`, error)
      }
    })
  }

  /**
   * 只订阅一次
   * @param eventName 事件名称
   * @param listener 事件监听器
   */
  once(eventName: string, listener: (...args: any[]) => void): void {
    const onceListener = (...args: any[]) => {
      listener(...args)
      this.off(eventName, onceListener)
    }
    this.on(eventName, onceListener)
  }

  /**
   * 清除所有监听器
   */
  clear(): void {
    this.listeners.clear()
  }
}
