import { router } from '@kit.ArkUI';
import './06/PreferencesStorage/PreferenceCase';
import './06/HttpCase';
import "./meituan/MTIndex";
import './07/SafeAreaCase';
import './07/SafeAreaExpandCase';
import './07/GetKeyBoardCase';
import './07/RouterCase01';
import './08/AnimateToCase';
import './09/VideoCase';
import './09/DouYinCase';
import './09/DownloadCase';
import './10/WebviewCase';
import './10/WebControlDemo';

// HAR不支持在配置文件中声明pages页面，但是可以包含pages页面，
// 并通过命名路由的方式进行跳转。
@Entry({ routeName: 'baseIndexPage' })
@Component
export struct Indexs {
  @State message: string = 'Base Hello World';

  build() {
    Row() {
      Column({ space: 10 }) {
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

        Button('沉浸式')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'SafeAreaCase'
            })
          })

        Button('沉浸式expandSafeArea')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'SafeAreaExpandCase'
            })
          })

        Button('键盘避让模式')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'GetKeyBoardCase'
            })
          })

        Button('Router')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'RouterCase01'
            })
          })

        Button('动画')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'AnimateToCase'
            })
          })

        Button('Video')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'VideoCase'
            })
          })

        Button('抖音')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'DouYinCase'
            })
          })

        Button('沙箱模式')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'DownloadCase'
            })
          })

        Button('WebView')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'WebviewCase'
            })
          })

        Button('WebControlDemo')
          .onClick(() => {
            router.pushNamedRoute({
              name: 'WebControlDemo'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
