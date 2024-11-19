import { display, mediaquery, window } from "@kit.ArkUI"
import { GlobalVariable } from "../constants"
import { BreakPointEnum } from "../viewmodels"

export class ScreenManagerByMedia {
  // 监测屏幕的大小变化
  // registerListenerScreen() {
  //   let xsListener = mediaquery.matchMediaSync("(0vp<=width<320vp)")
  //   let smListener = mediaquery.matchMediaSync("(320vp<=width<600vp)")
  //   let mdListener = mediaquery.matchMediaSync("(600vp<=width<840vp)")
  //   let lgListener = mediaquery.matchMediaSync("(840vp<=width)")
  //   xsListener.on("change", (res) => {
  //     if (res.matches) {
  //       this.setBreakPoint(BreakPointEnum.xs)
  //     }
  //   })
  //   smListener.on("change", (res) => {
  //     if (res.matches) {
  //       this.setBreakPoint(BreakPointEnum.sm)
  //     }
  //   })
  //   mdListener.on("change", (res) => {
  //     if (res.matches) {
  //       this.setBreakPoint(BreakPointEnum.md)
  //     }
  //   })
  //   lgListener.on("change", (res) => {
  //     if (res.matches) {
  //       this.setBreakPoint(BreakPointEnum.lg)
  //     }
  //   })
  // }
  //
  // unregisterListenerScreen() {
  //   let xsListener = mediaquery.matchMediaSync("(0vp<=width<320vp)")
  //   let smListener = mediaquery.matchMediaSync("(320vp<=width<600vp)")
  //   let mdListener = mediaquery.matchMediaSync("(600vp<=width<840vp)")
  //   let lgListener = mediaquery.matchMediaSync("(840vp<=width)")
  //   xsListener.off("change")
  //   smListener.off("change")
  //   mdListener.off("change")
  //   lgListener.off("change")
  // }
  //
  //  setBreakPoint(breakPoint: string) {
  //   AppStorage.setOrCreate<string>(GlobalVariable.BREAK_POINT_KEY, breakPoint)
  // }
  // 开启监听屏幕变化
  async registerListenerScreen(ctx?: Context) {
    // 只调用一次
    this.judgeScreen(px2vp(display.getDefaultDisplaySync().width))
    // let windowStage = AppStorage.get<window.WindowStage>("win")
    let mainWindow = await window.getLastWindow(getContext() || ctx)
    // let mainWindow = windowStage?.getMainWindowSync()
    mainWindow?.on("windowSizeChange", (size) => {
      // 会调用多次
      this.judgeScreen(px2vp(size.width))
    })
  }

  // 判断屏幕大小
  judgeScreen(width: number) {
    let breakPoint: string = ""
    if (width < 320) {
      breakPoint = BreakPointEnum.xs
    } else if (width >= 320 && width < 520) {
      breakPoint = BreakPointEnum.sm
    } else if (width >= 520 && width < 840) {
      breakPoint = BreakPointEnum.md
    } else {
      breakPoint = BreakPointEnum.lg
    }
    AppStorage.setOrCreate(GlobalVariable.BREAK_POINT_KEY, breakPoint);

  }

  // 卸载
  async unregisterListenerScreen(ctx?: Context) {
    let mainWindow = await window.getLastWindow(getContext() || ctx)
    mainWindow.off("windowSizeChange")
  }
}

export const screenManagerByMedia = new ScreenManagerByMedia()