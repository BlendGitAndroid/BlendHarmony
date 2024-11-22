import { window } from '@kit.ArkUI'
import { logger } from './Logger'

// 状态栏管理
class StatusBar {
  // 深色 - 文字颜色
  setDarkBar() {
    this.setBar({
      statusBarContentColor:'#000000'
    })
  }

  // 浅色 - 文字颜色
  setLightBar() {
    this.setBar({
      statusBarContentColor:'#ffffff'
    })
  }

  // 自定义颜色(颜色配置)
  async setBar(systemBar: window.SystemBarProperties) {
    try {
      const context = AppStorage.get<Context>('context')
      if (context) {
        const win = await window.getLastWindow(context)
        //核心：设置状态栏的方法
        win.setWindowSystemBarProperties(systemBar)
      }
    } catch (err) {
      logger.error('SetBar Error:', JSON.stringify(err))
    }
  }
}

export const statusBar = new StatusBar()






