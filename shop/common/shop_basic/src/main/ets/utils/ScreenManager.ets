import { window, KeyboardAvoidMode } from "@kit.ArkUI"
import { GlobalVariable } from "../constants"
import { deviceInfo } from "@kit.BasicServicesKit"

export class ScreenManager {
  // 全屏
  async full(ctx?: Context) {
    // 2in1设备的处理
    // 2in1 全屏不处理 电脑设备不处理
    if (deviceInfo.deviceType !== "2in1") {
      const win = await window.getLastWindow(ctx || getContext())
      win.setWindowLayoutFullScreen(true)
      this.setAreaHeight(ctx) // 只要调用全屏就把安全区的高度存起来
    }
  }

  async setAreaHeight(ctx?: Context) {
    const win = await window.getLastWindow(ctx || getContext())
    // 设置顶部高度
    AppStorage.setOrCreate<number>(GlobalVariable.SAFE_AREA_TOP,
      px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        .topRect.height))
    // 设置底部高度
    AppStorage.setOrCreate<number>(GlobalVariable.SAFE_AREA_BOTTOM,
      px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        .bottomRect.height))
  }

  // 退出全屏
  async exitFull(ctx?: Context) {
    const win = await window.getLastWindow(ctx || getContext())
    win.setWindowLayoutFullScreen(false)
  }

  // 设置键盘压缩
  async setKeyBoardMode(ctx?: Context) {
    const win = await window.getLastWindow(ctx || getContext())
    win.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }
}


export const screenManager = new ScreenManager()