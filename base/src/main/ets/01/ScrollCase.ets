@Entry
@Component
export struct ScrollCase {
  build() {
    Column() {
      Row() {

      }.height(60)
      .width("100%")
      .backgroundColor(Color.Grey)

      // 1. 如果里面没有外面大,则不会出现滚动
      // 2. Scroll里面只能有一个容器
      Scroll() {
        Column({ space: 20 }) {
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
          ScrollItem()
        }
      }.layoutWeight(1)

      Row() {

      }.height(60)
      .width("100%")
      .backgroundColor(Color.Orange)
    }
    .height('100%')
    .width("100%")
  }
}

@Component
export struct ScrollItem {
  build() {
    Row() {
      Text('滚动的每一项')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(100)
    .backgroundColor(Color.Pink)
  }
}
