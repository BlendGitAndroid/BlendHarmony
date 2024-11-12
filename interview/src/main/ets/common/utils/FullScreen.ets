//全屏工具：
import window from '@ohos.window'
import { logger } from './Logger'

// 开启全屏
// 关闭全屏
// 1.准备一个工具类
class FullScreen {
  //   2.实现方法
  async enable() {
    try {
      const context = AppStorage.get<Context>('context')
      if (context) {
        const win = await window.getLastWindow(context)
        await win.setWindowLayoutFullScreen(true)
        // 获取屏幕上下安全区并存储
        const topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        AppStorage.setOrCreate('topHeight', px2vp(topArea.topRect.height))
        const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height))
      }
    } catch (err) {
      logger.error('FullScreen Error:', JSON.stringify(err))
    }
  }
  // 这个方法只是为了实现闭环，不是你需要调用
  async disable() {
    try {
      const context = AppStorage.get<Context>('context')
      if (context) {
        const win = await window.getLastWindow(context)
        await win.setWindowLayoutFullScreen(false)
        AppStorage.setOrCreate('topHeight', 0)
        AppStorage.setOrCreate('bottomHeight', 0)
      }
    } catch (err) {
      logger.error('CloseFullScreen Error:', JSON.stringify(err))
    }
  }
}

//3.new 一下 导出
export const fullScreen = new FullScreen()