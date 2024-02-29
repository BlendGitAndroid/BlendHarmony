import router from '@ohos.router'
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({url: 'rank/pages/RankPage'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}