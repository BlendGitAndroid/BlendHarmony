@Component
export struct HDMNavCol {
  icon: ResourceStr = ''
  text: string = ''
  color: ResourceColor = $r('app.color.black')

  build() {
    GridCol() {
      Column() {
        Image(this.icon)
          .width(24)
          .aspectRatio(1)
        Text(this.text)
          .fontColor(this.color)
          .fontSize(12)
          .lineHeight(22)
          .margin({ top: 4 })
      }
      .padding({ top: 16, bottom: 10 })
    }
  }
}