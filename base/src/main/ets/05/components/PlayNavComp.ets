@Component
export struct PlayNavComp {
  // 提供数据
  @Consume
  isPlay: boolean

  build() {
    Row({ space: 20 }) {
      Image($r('app.media.b'))
        .width(30)
        .aspectRatio(1)

      Text('耍猴的 - 二手月季')
        .layoutWeight(1)

      Image(this.isPlay ? $r('sys.media.ohos_ic_public_pause') : $r('sys.media.ohos_ic_public_play'))
        .width(20)
        .aspectRatio(1)
        .onClick(() => {
          this.isPlay = !this.isPlay
        })
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 6,
      bottom: 6
    })
    .backgroundColor(Color.Gray)
  }
}
