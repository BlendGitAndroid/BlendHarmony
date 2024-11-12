import { HmNavBar } from '../common/components/HmNavBar';
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

interface RouterParam {
  src: string
  title: string
}

@Entry
@Component
struct WebPage {
  @State message: string = 'Hello World';
  controller: WebviewController = new webview.WebviewController()
  @StorageProp('bottomHeight') bottomHeight: number = 0
  @State
  title: string = ''
  @State
  src: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as RouterParam
    this.src = params.src
    this.title = params.title
  }

  build() {
    Column() {
      //  头部 - 返回
      HmNavBar({
        title: this.title,
        showRightIcon: false
      })
      //  网页
      Web({
        src: this.src,
        controller: this.controller
      })
        .margin({
          bottom: 12
        })
    }
    .height('100%')
    .width('100%')
    .padding({
      bottom: this.bottomHeight
    })
  }
}