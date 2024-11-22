@CustomDialog
@Component
export struct HDMPreviewImage {
  controller: CustomDialogController
  // 多张图片
  urls: string[] = []
  activeIndex: number = 0

  build() {
    Swiper() {
      ForEach(this.urls, (item: string, index: number) => {
        HDMImageScale({
          url: item, onClose: () => {
            this.controller.close()
          }
        })
      })
    }
    .loop(false)
    .index($$this.activeIndex)
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.black"))
    .indicator(false)
  }
}

// 自定义组件 实现放大缩小的效果
@Component
struct HDMImageScale {
  url: string = ""
  onClose: () => void = () => {
  }
  @State
  scaleValue: number = 1
  @State positionX: number = 0
  @State positionY: number = 0
  @State offsetX: number = 0
  @State offsetY: number = 0

  build() {
    Column() {
      Image(this.url)
        .scale({
          x: this.scaleValue,
          y: this.scaleValue
        })
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .width("100%")
        .aspectRatio(1.4)
        .onClick(() => {
          if (this.scaleValue === 1) {
            this.onClose()
          } else {
            animateTo({ duration: 300 }, () => {
              this.scaleValue = 1
            })
          }

        })
        .gesture(
          GestureGroup(GestureMode.Parallel,
            // 捏合手势
            PinchGesture()
              .onActionUpdate((event) => {
                if (event.scale >= 1) {
                  this.scaleValue = event.scale
                }
              }),
            // 拖动手势
            PanGesture()// 更新 多频次执行
              .onActionUpdate(event => {
                if (this.scaleValue > 1) {
                  this.offsetX = this.positionX + event.offsetX
                  this.offsetY = this.positionY + event.offsetY
                }
              })// 执行最后一次
              .onActionEnd((event: GestureEvent) => {
                this.positionX = this.offsetX
                this.positionY = this.offsetY
                console.info('Pan end')
              })

          )

        )
    }
    .justifyContent(FlexAlign.Center)
    .height("100%")

  }
}