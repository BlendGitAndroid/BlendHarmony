@Entry
@Component
export struct ImageCase {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        //   1.使用本地图片,assets文件下
        // '/'代表的是ets目录，自动找出下级目录
        Image('/assets/a.png')
          .width(100)
          .height(100)
          .fillColor(Color.Red)

        //   2.使用在线图片
        Image('https://gips3.baidu.com/it/u=1039279337,1441343044&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f1024_1024')
          .width(100)
          .height(100)

        //   3.使用资源图片（无后缀,使用频率最高）,使用Resource下的图片-media
        Image($r('app.media.a'))
          .width(100)
          .height(100)

        //   4.rawfile
        Image($rawfile('a.png'))
          .width(100)
          .height(100)

        //   5.内置资源图片(图标 SVG)
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(100)
          .height(100)
          .fillColor(Color.Red)

        //   6.图标svg
        Image($r('app.media.ic_Wechat'))
          .width(100)
          .height(100)
          .fillColor(Color.Green)
      }
      .width('100%')
    }
    .height('100%')
  }
}
