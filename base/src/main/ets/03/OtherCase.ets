@Entry
@Component
export struct OtherCase {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column({ space: 20 }) {
        Text(this.message)
          .width(200)// .aspectRatio(1)
          .aspectRatio(16 / 9)// 宽高比
          .backgroundColor(Color.Brown)
          .textAlign(TextAlign.Center)
          .fontColor($r("app.color.my_first_color")) // 从资源文件中获取

        // 为开发者提供4种像素单位，框架采用vp为基准数据单位。
        // px：屏幕物理像素单位。

        // vp：virtual pixel，屏幕密度相关像素，根据屏幕像素密度转换为屏幕物理像素，当数值不带单位时,默认单位vp。
        // 在实际宽度为1440物理像素的屏幕上，1vp约等于3px。

        // fp
        // 字体像素，与vp类似适用屏幕密度变化，随系统字体大小设置变化。

        // Ipx(类似于前端的vm)
        // 视窗逻辑像素单位，Ipx单位为实际屏幕宽度与逻辑宽度（通过designWidth配置）的比值，
        // designWidth默认值为720。当designWidth为720时，在实际宽度为1440物理像素的屏幕上，
        // 1lpx为2px大小。
        // 在不同屏幕物理分辨率下，要想实现等比例适配。
        // 设置lpx基准值 - resources/base/profile/main-pages.json
        // 添加window属性，设置desigWidth，不设置也可以使用lpx,默认720


        // 默认不带单位就是VP
        Row() {
          // 1vp 约等于 3px,px适合绝对大小，不论什么屏幕，固定物体的大小
          Text('100px')
        }
        .width(px2vp(100))
        .height('100px')
        .backgroundColor(Color.Red)

        Row() {
          // 1vp 约等于 3px,px适合绝对大小，不论什么屏幕，希望看到的大小是差不多的
          Text('100')
        }
        .width(100)
        .height(100)
        .backgroundColor(Color.Red)

        Row() {
          Text('100vp')
        }
        .width('100vp')
        .height('100vp')
        .backgroundColor(Color.Red)

        // 华为理念：屏幕越大看到的应该越多
        Row() {
          Text('100fp')
            .fontSize('10fp')
        }
        .width('100fp')
        .height('100fp')
        .backgroundColor(Color.Red)

        Row() {
          Text('375lpx')
        }
        .width('375lpx')
        .height('100lpx')
        .backgroundColor(Color.Red)

        // lpx:屏幕越大 我就越大
        Text('72lpx')
          .width('72lpx')
          .height('25lpx')
          .backgroundColor(Color.Brown)
      }
      .width('100%')
    }
    .height('100%')
  }
}
