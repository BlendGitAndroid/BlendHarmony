@Entry
@Component
export struct StackCase {
  build() {
    Row() {
      Column() {
        Stack() {

          Text("抖音")
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .fontColor("#ff2d83b3")
            .translate({
              x: -2,
              y: 2
            })
            .zIndex(1)

          Text("抖音")
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .fontColor("#ffe31fa9")
            .translate({
              x: 2,
              y: -2
            })
            .zIndex(2)

          Text("抖音")
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
            .fontColor("#ff030000")
            .translate({
              x: 0,
              y: 0
            })
            .zIndex(3) // 更加有层次感
        }
        .width("100%")
        .height(200)
        .alignContent(Alignment.TopEnd) // 设置子组件的排列方式

      }
      .width("100%")
    }
    .height('100%')
  }
}
