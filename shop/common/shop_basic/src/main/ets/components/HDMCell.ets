@Component
export struct HDMCell {
  @Prop
  title: string = ""
  @Prop
  value: string = ""
  showRightIcon: boolean = true // 是否显示右侧图标
  onRightClick: () => void = () => {
  }
  @BuilderParam
  customIcon: () => void
  @BuilderParam
  customLabel: () => void

  build() {
    Row() {
      if (this.customLabel) {
        this.customLabel()
      } else {
        Text(this.title)
          .fontColor($r("app.color.black"))
          .fontSize(14)
      }
      Row({ space: 6 }) {
        if (this.customIcon) {
          this.customIcon()
        } else {
          Text(this.value)
            .fontColor($r("app.color.gray"))
            .fontSize(14)
          if (this.showRightIcon) {
            Image($r("app.media.ic_public_right"))
              .fillColor($r("app.color.gray"))
              .width(24)
              .aspectRatio(1)
              .onClick(() => {
                this.onRightClick()
              })
          }
        }

      }

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .constraintSize({
      minHeight: 50,
    })

    // .height(50)
  }
}