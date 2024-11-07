@Component
struct HmToggleCard {
  /** 左侧标题, 需要父组件传入 */
  title: string = "基本信息"
  // 控制折叠 或这展开的效果
  @State
  toggleCard: boolean = true // 是否展示
  // 尾随闭包
  /** 外部传入的内容 */
  @BuilderParam
  CardContent: () => void

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
        Image(this.toggleCard ? $r("app.media.ic_btn_cut") : $r("app.media.ic_btn_add"))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            animateTo({ duration: 300 }, () => {
              this.toggleCard = !this.toggleCard
            })

          })
      }
      .width("100%")
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)

      // 外部传入的内容
      if (this.toggleCard && this.CardContent) {
        this.CardContent()
      }
    }
    .backgroundColor($r("app.color.white"))
    .borderRadius(10)
    .padding({
      left: 18,
      right: 18,
      bottom: 18
    })
    .margin({ left: 10, right: 10, top: 10 })

  }
}

export { HmToggleCard }