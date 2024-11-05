// 使用自定义Dialog
@CustomDialog
struct PreviewImage {
  // Dialog控制器
  controller: CustomDialogController

  url: string = ''

  type: 'img' | 'video' = 'img'

  build() {
    Column() {
      if (this.type === 'img') {
        // 图片
        Image('file://' + this.url)
          .width('100%')
      } else if (this.type === 'video') {
        //   视频
        Video({
          src: 'file://' + this.url
        })
          .loop(true)
          .autoPlay(true)
          .controls(false)
          .width('100%')
          .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.controller.close()
    })
  }
}

export default PreviewImage