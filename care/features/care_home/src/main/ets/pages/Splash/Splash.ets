import { ResManager } from '@care/basic/Index'
import { router, window } from '@kit.ArkUI'

@Entry
@Component
struct Splash {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State
  count: number = 3
  timer: number = -1

  countdown() {
    this.timer = setInterval(() => {
      this.count--
      if (this.count === 0) {
        clearInterval(this.timer)
        // 销毁子窗口
        window.findWindow("ad_win").destroyWindow()
      }
    }, 1000)
  }

  aboutToAppear(): void {
    this.countdown()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 闪图
      Image($r('app.media.pic_sp1'))
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      // app 信息
      Column() {
        Text() {
          ImageSpan($r('app.media.startIcon'))
            .width(32)
            .aspectRatio(1)
            .margin({ right: 15 })
          Span('翼康养老')
            .fontColor('#000')
            .fontSize(24)
            .fontWeight(700)
        }
      }
      .width('100%')
      .padding({ top: 30, bottom: this.bottomHeight })
      // 说明：设置expandSafeArea属性进行组件绘制扩展时，组件不能设置固定宽高尺寸（百分比除外）
      // .height(100)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#fff')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)

  }
}