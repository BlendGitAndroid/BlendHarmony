import { ScrollItem } from './ScrollCase';

@Entry
@Component
export struct ScrollCase2 {
  // 设置滚动控制器
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Row() {
        Button("滚到头")
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Top)
          })
      }.height(60)
      .width("100%")
      .backgroundColor(Color.Grey)
      .justifyContent(FlexAlign.Center)

      // 1. 如果里面没有外面大,则不会出现滚动
      // 2. Scroll里面只能有一个容器
      Scroll(this.scroller) { // 添加控制器
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
          ScrollItem()
          ScrollItem()
          ScrollItem()
        }
      }
      .layoutWeight(1)
      // .scrollable(ScrollDirection.Horizontal) // 设置滚动方向

      Row() {
        Button("滚到尾")
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Bottom)
          })
      }.height(60)
      .width("100%")
      .backgroundColor(Color.Orange)
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width("100%")
  }
}
