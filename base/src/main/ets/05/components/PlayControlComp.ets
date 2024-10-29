@Component
export struct PlayControlComp {
  @Consume
  @Watch('update')
  isPlay: boolean

  @State
  shakenX: number = 0

  @State
  shakenY: number = 0

  timer = -1

  update() {
    if (this.isPlay) {
      this.timer = setInterval(() => {
        this.shakenX = 2 - Math.random() * 4
        this.shakenY = 2 - Math.random() * 4
      }, 100)
    } else {
      clearInterval(this.timer)
      this.shakenX = 0
      this.shakenY = 0
    }
  }

  build() {
    Column() {
      // 文字
      Stack() {
        Text('抖音')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ff2d83b3')
          .translate({
            x: this.shakenX,
            y: this.shakenY
          })
          .zIndex(1)
        Text('抖音')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ffe31fa9')
          .translate({
            x: this.shakenY,
            y: this.shakenX
          })
          .zIndex(2)

        Text('抖音')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .fontColor('#ff030000')
          .translate({
            x: 0,
            y: 0
          })
          .zIndex(3)
      }
      .width('100%')


      // 控制模块
      Row({ space: 20 }) {
        Image($r('sys.media.ohos_ic_public_play_last'))
          .width(20)
          .aspectRatio(1)

        Image(this.isPlay ? $r('sys.media.ohos_ic_public_pause') : $r('sys.media.ohos_ic_public_play'))
          .width(20)
          .aspectRatio(1)
          .onClick(() => {
            this.isPlay = !this.isPlay
          })

        Image($r('sys.media.ohos_ic_public_play_next'))
          .width(20)
          .aspectRatio(1)
      }
      .width('100%')
      .padding(20)
      .backgroundColor(Color.Pink)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
  }
}
