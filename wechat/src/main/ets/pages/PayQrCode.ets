import { router } from '@kit.ArkUI'
import { generateBarcode, scanCore } from '@kit.ScanKit'

@Entry
@Component
struct PayQrCode {
  @State
  payParams: number = Date.now()

  // 条形码思路
  // 图 pixelMap
  // 条形码生成工具绘制
  @State
  barImage: PixelMap | null = null

  async createBarImage() {
    this.barImage = await generateBarcode.createBarcode('{username:"zs"}', {
      width: 800,
      height: 200,
      scanType: scanCore.ScanType.CODE128_CODE
    })
  }

  aboutToAppear(): void {
    setInterval(() => {
      this.payParams = Date.now()
    }, 3000)
    // 创建条形码
    this.createBarImage()
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_public_arrow_left'))
            .width(30)
            .height(30)
            .fillColor($r("app.color.white"))
            .onClick(() => {
              router.back()
            })
            .zIndex(2)

          // 这个占满整个
          Text("收付款")
            .width('100%')
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor($r('app.color.white'))
        }
        .height(50)
      }
      .padding({
        left: 10,
        right: 10
      })

      Row() {
        Column() {
          Row({ space: 10 }) {
            Image($r("app.media.ic_public_scan"))
              .width(20)
              .height(20)
              .fillColor($r("app.color.pay_back"))

            Text("付款码")
              .fontColor($r("app.color.pay_back"))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .height(60)
          .border({
            width: {
              bottom: 0.5
            },
            color: $r("app.color.border_color")
          })

          // 显示码
          Column({ space: 20 }) {
            Text("优先使用xx银行储蓄卡付款")
              .fontColor($r("app.color.text_second"))
              .fontSize(12)

            // 二维码组件QRCode
            QRCode(this.payParams.toString())
              .width(140)
              .aspectRatio(1)

            // 条形码组件
            Image(this.barImage)
              .width(300)
          }
          .margin({
            top: 10,
            bottom: 10
          })
        }
        .padding(10)
        .borderRadius(4)
        .width("100%")
        .backgroundColor($r("app.color.white"))
      }
      .padding({
        left: 10,
        right: 20
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.pay_back"))
  }
}
