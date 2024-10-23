@Entry
@Component
export struct GridCase {
  @State message: string = 'Hello World';

  // 在基本的布局组件 Column/Row/Flex/Stack中不论内容超出与否，皆不会出现滚动条
  // 如果内容超出容器区域，会自动出现滚动条
  build() {
    Column() {
      Grid() {
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
        MyGrid()
      }
      .columnsTemplate("1fr 1fr 1fr 1fr") // 4列
      // .rowsTemplate("1fr 1fr 1fr 1fr") // 4行
      .rowsGap(10)  //  设置行与行的间距
      .columnsGap(1) // 设置列与列的间距。
    }.height("100%")
    .width("100%")
  }
}

@Component
struct MyGrid {
  build() {
    GridItem() {
      Column()
        .width("100%")
        .height(200)
        .backgroundColor(Color.Pink)
    }
  }
}