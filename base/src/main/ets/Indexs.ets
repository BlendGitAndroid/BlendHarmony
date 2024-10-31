import { router } from '@kit.ArkUI';
import './06/PreferencesStorage/PreferenceCase';
import './06/HttpCase';
import "./meituan/MTIndex";

// HAR不支持在配置文件中声明pages页面，但是可以包含pages页面，
// 并通过命名路由的方式进行跳转。
@Entry({ routeName: 'baseIndexPage' })
@Component
export struct Indexs {
  @State message: string = 'Base Hello World';

  build() {
    Row() {
      Column({ space: 20 }) {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Button('PreferenceCase')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'PreferenceCase'
            })
          })

        Button('HttpCase')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'HttpCase'
            })
          })

        Button('美团')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'MTIndex'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
