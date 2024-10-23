
// HAR不支持在配置文件中声明pages页面，但是可以包含pages页面，
// 并通过命名路由的方式进行跳转。
@Entry({ routeName: 'baseIndexPage' })
@Component
export struct Indexs {
  @State message: string = 'Base Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
