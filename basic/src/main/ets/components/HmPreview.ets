@CustomDialog
@Component
export struct HmPreview {
  controller: CustomDialogController
  urls: string[] = []
  selectedIndex: number = 0

  build() {
    Column() {
      Swiper() {
        ForEach(this.urls, (url: string) => {
          Image(url)
            .width('100%')
            .onClick(() => {
              this.controller.close()
            })
        })
      }
      .index(this.selectedIndex) // 默认选中第几个图片
      .indicator(false) // 关闭指示器
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.black'))
    .width('100%')
    .height('100%')
  }
}



