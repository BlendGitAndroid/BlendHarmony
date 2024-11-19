import { HDMProgressLoading } from "."

@CustomDialog
@Component
export struct HDMLoadingDialog {
  controller: CustomDialogController
  title: string = "加载中..."

  build() {
    Column({ space: 10 }) {
      // LoadingProgress()
      //   .width(30)
      //   .aspectRatio(1)
      //   .color($r("app.color.white"))
      HDMProgressLoading({
        loadingColor: $r("app.color.white")
      })
        .width(30)
      // Image($r("app.media.loading"))
      //   .width(30)
      //   .aspectRatio(1)
      Text(this.title)
        .fontColor($r("app.color.white"))
    }
    .width(100)
    .aspectRatio(1)
    .borderRadius(10)
    .backgroundColor("rgba(0,0,0, 0.5)")
    .justifyContent(FlexAlign.Center)
  }
}