@Entry({ routeName: "SafeAreaExpandCase" })
@Component
export struct SafeAreaExpandCase {
  build() {
    Column() {
      Image($r('app.media.a'))
        .width(200)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.a'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundBlurStyle(BlurStyle.BACKGROUND_ULTRA_THICK)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]) // 作用控制组件扩展其安全区域
  }
}
