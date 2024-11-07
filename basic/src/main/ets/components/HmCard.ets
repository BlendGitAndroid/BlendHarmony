@Component
export struct HmCard {
  @BuilderParam
  HmCardFn: () => void

  build() {
    Column() {
      if (this.HmCardFn) {
        this.HmCardFn()
      }
    }
    .padding({ left: 17.5, right: 17.5 })
    .backgroundColor($r('app.color.white'))
    .margin({ left: 14.5, right: 14.5, bottom: 15 })
    .borderRadius(8)
  }
}

