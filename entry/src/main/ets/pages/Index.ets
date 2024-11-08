import router from '@ohos.router';
import '@ohos/base/src/main/ets/Indexs'; // 接受命名路由

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column({ space: 20 }) {

        Text("官方代码")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Official' }, router.RouterMode.Single) // 单实例模式
          })

        Text("base学习")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 条找路由命名
            router.pushNamedRoute({
              name: 'baseIndexPage'
            })
          })

        Text("wechat")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 条找路由命名
            router.pushUrl({
              // '@bundle:包名（bundleName）/模块名（moduleName）/路径/页面所在的文件名(不加.ets后缀)'
              // 需要在Deploy Multi Hap下进行配置
              url: '@bundle:com.blend.harmony/wechat/ets/pages/Index'
            })
          })

        Text("快递")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 条找路由命名
            router.pushUrl({
              // '@bundle:包名（bundleName）/模块名（moduleName）/路径/页面所在的文件名(不加.ets后缀)'
              // 需要在Deploy Multi Hap下进行配置
              url: '@bundle:com.blend.harmony/xsd/ets/pages/Login/Login'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}