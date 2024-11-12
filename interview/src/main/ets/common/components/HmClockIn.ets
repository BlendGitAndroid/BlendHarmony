@Component
export struct HmClockIn {
  @Prop
  clockCount: number = 0

  build() {
    Row() {
      if (this.clockCount === 0) {
        Text('打卡')
          .fontSize(18)
          .fontColor($r('app.color.black'))
          .fontWeight(FontWeight.Bold)
          .margin({
            left: 30,
            bottom: 4
          })
      } else {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
            .fontColor($r('app.color.black'))
          Text() {
            Span(this.clockCount>999?'999':this.clockCount?.toString()||'0')
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
            Span('天')
              .fontSize(10)
          }
        }
        .margin({
          left:30
        })
      }
    }
    .width(74)
    .height(28)
    .backgroundImage(this.clockCount===0?$r('app.media.ic_common_unclock'):$r('app.media.ic_common_clocked'))
    .backgroundImageSize(ImageSize.Contain)
  }
}