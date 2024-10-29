@Preview
@Component
export struct ZhihuNavBar {
  build() {
    Row() {
      // 1.1箭头
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(20)
          .height(20)
      }
      .width(30)
      .aspectRatio(1)
      .backgroundColor('#f5f5f5')
      .borderRadius(30) // 可以给大不能小！超出半径都一样！
      .justifyContent(FlexAlign.Center)

      // 1.2文字
      Text('评论回复')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .margin({
          right: 30
        })

    }
    .width('100%')
    .padding(20)
    .border({
      width: {
        bottom: 1
      },
      color: '#f5f5f5'
    })
  }
}
