import window from '@ohos.window'
import { logger } from './Logger'

// 全屏开启和关闭工具类
class FullScreen {
  // 全屏
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

  // 非全城
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

export const fullScreen = new FullScreen()