@Component
export struct HmCardItem {
  leftText: string = ''
  @Prop rightText: string = ''
  showRightIcon: boolean = true
  showBottomBorder: boolean = true
  onRightClick: () => void = () => {
  }

  build() {
    Row() {
      Text(this.leftText).fontSize(16).fontWeight(400).fontColor($r('app.color.text_primary'))
      Row() {
        if (this.rightText) {
          Text(this.rightText).fontSize(16).fontWeight(400).fontColor($r('app.color.text_secondary'))
        }

        if (this.showRightIcon) {
          Image($r("app.media.ic_btn_more")).width(24).height(24)
        }
      }
      .onClick(() => {
        this.onRightClick()
      })

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({ width: { bottom: this.showBottomBorder ? 1 : 0 }, color: $r('app.color.background_page') })
    .width('100%')
    .height(60)
  }
}

