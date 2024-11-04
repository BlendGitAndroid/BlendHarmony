import { webview } from '@kit.ArkWeb'
import { promptAction } from '@kit.ArkUI'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@Entry({ routeName: "WebControlDemo" })
@Component
struct WebControlDemo {
  //总结：
  //1.应用控制网页 - runJavaScript(方法名(参数))
  //2.网页控制应用 - registerJavaScriptProxy(对象字面量,对象名,[开放的属性名集合]),必须在refresh后才能调用

  @State
  controller: webview.WebviewController = new webview.WebviewController()

  openPhoto(num: number) {
    //打开相册:photo
    new photoAccessHelper.PhotoViewPicker().select({
      maxSelectNumber: num
    })
  }

  build() {
    Row() {
      Column() {
        Button('变！')
          .onClick(() => {
            // 调用网页的方法
            this.controller.runJavaScript('changeText()', (err, result) => {
              if (err) {
                promptAction.showToast({
                  message: '调用失败'
                })
              }
              if (result) {
                promptAction.showToast({
                  message: result
                })
              }
            })
          })

        Button('注入方法')
          .onClick(() => {
            this.controller.registerJavaScriptProxy({
              "objKey": (num: number) => {
                this.openPhoto(num)
              }
            }, 'objName', ['objKey'])
          })

        Button('刷新')
          .onClick(() => {
            this.controller.refresh()
          })

        Web({
          src: $rawfile('index.html'),
          controller: this.controller
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}