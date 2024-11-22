@Component
export struct HmSkeletonItem {
  widthValue: Length = '100%'
  text: string = ''
  bgColor:ResourceColor = Color.Gray

  build() {
    // 骨架屏单元
    Text(this.text)
      .width(this.widthValue)
      .height(16)
      .borderRadius(2)
      .backgroundColor(this.bgColor)
  }
}