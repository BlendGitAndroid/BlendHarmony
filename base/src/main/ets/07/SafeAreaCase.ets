import { window } from '@kit.ArkUI';

@Entry({ routeName: "SafeAreaCase" })
@Component
export struct SafeAreaCase {
  @State message: string = 'Hello World';

  @State
  topSafeHeight: number = 0

  @State
  bottomSafeHeight: number = 0

  aboutToAppear(): void {
    window.getLastWindow(getContext()).then((win) => {
      // 沉浸式: 指定页面开启或关闭
      win.setWindowLayoutFullScreen(true)
      //   获取上方安全区高度
      this.topSafeHeight = px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
      //   获取下方安全区高度
      this.bottomSafeHeight =
        px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)

      AlertDialog.show({
        message: `
              上方安全区高度:${this.topSafeHeight}
              下方安全区高度:${this.bottomSafeHeight}
            `
      })
    })
  }

  build() {
    Column() {
      Image($r('app.media.a'))
        .width(200)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.a'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundBlurStyle(BlurStyle.BACKGROUND_ULTRA_THICK) // 高斯模糊
    .padding({
      top: this.topSafeHeight,
      bottom: this.bottomSafeHeight
    })
    .backgroundColor(Color.Pink)

  }
}
