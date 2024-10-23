@Entry
@Component
export struct ComponentsBase {
  @State message: string = 'Hello World';

  // 百分比说明： 鸿蒙的里面的百分比指的是相对当前父容器，并不是当前的手机屏幕
  // 在写宽度高度时，直接写数字默认单位为vp虚拟像素，屏幕会进行适配
  build() {
    // 默认从上到下,水平居中,超出没有滚动条
    Column() {
      Column() {
        Text("1")
        Text("1")
        Text("1")
        Text("1")
        Text("1")
        Text("1")
      }.width('100%') // 百分比要用引号
      .height(200)

      // 布局 Row 水平排列 垂直剧中,内容超出时没有滚动条
      Row() {
        Text("2")
        Text("2")
        Text("2")
        Text("2")
        Text("2")
        Text("2")
      }
      .width('100%')
      .height(200)
      .backgroundColor(Color.Brown)

      // 实现水平和竖直方向居中
      Row() {
        Row({ space: 10 }) {
          Column() {

          }
          .width(80)
          .height(200)
          .backgroundColor('blue')

          Row() {

          }
          .width(80)
          .height(200)
          .backgroundColor('#ff4400')

          Column() {

          }
          .width(80)
          .height(200)
          .backgroundColor('rgb(123,123,223)')
        }
      }.layoutWeight(1)
      .width('100%')
      .backgroundColor(Color.Green)
      .justifyContent(FlexAlign.Center) // 主轴方向居中

    }.width('100%')
    .height('100%')

  }
}
