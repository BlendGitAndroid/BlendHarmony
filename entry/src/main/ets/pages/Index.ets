import { TOKEN_KEY, UserSettingClass } from '@blend/basic';
import router from '@ohos.router';
import '@blend/base/src/main/ets/Indexs'; // 接受命名路由
import { RouterConfig, TokenManager } from '@care/basic';

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
              url: '@bundle:com.blend.harmony1/wechat/ets/pages/Index'
            })
          })

        Text("express")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            const userSetting = new UserSettingClass(getContext())
            const token = userSetting.getToken()
            AppStorage.setOrCreate(TOKEN_KEY, token) // 放在内存中
            if (token) {
              router.pushUrl({
                url: '@bundle:com.blend.harmony1/xsd/ets/pages/Index/Index'
              })
            } else {
              router.pushUrl({
                url: '@bundle:com.blend.harmony1/xsd/ets/pages/Login/Login'
              })
            }
          })

        Text("interview")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony1/interview/ets/pages/IndexPage'
            })
          })

        Text("care")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            if ((await TokenManager.getUser()).token) {
              router.pushUrl({
                url: RouterConfig.INDEX_URL
              })
            } else {
              router.pushUrl({
                url: RouterConfig.LOGIN_URL
              })
            }
          })

        Text("Test")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony1/test/ets/pages/TestIndexPage'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}