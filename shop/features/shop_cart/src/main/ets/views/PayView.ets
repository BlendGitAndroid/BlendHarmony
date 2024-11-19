import { GlobalVariable, PAGE_PATH, PayResultParams } from '@shop/basic'
import { webview } from '@kit.ArkWeb'

@Component
struct PayView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  controller: webview.WebviewController = new webview.WebviewController()
  @State
  orderId: string = ""
  @Consume
  stackPath: NavPathStack

  aboutToAppear(): void {
    const params = this.stackPath.getParamByName(PAGE_PATH.PAY_PAGE) as string[]
    this.orderId = params[params.length - 1]
  }

  build() {
    NavDestination() {
      Web({
        src: GlobalVariable.BASE_URL + `/pay/wap/aliPay?orderId=${this.orderId}`,
        controller: this.controller
      })
        .onPageBegin((event) => {
          if (event.url.includes(`${GlobalVariable.BASE_URL}/pay/redirect`)) {
            // 支付结果
            let arr = event.url.split("?")
            if (arr.length > 1) {
              let params = arr[1].split("&")
              // payResult
              // orderId
              let objArr = params[0].split("=") // [id=1, age=2]
              // let key = objArr[0] // key payResult
              let value = objArr[1] // value true/false
              this.stackPath.replacePath({
                name: PAGE_PATH.PAY_RESULT_PAGE,
                param: {
                  payResult: value === "true",
                  orderId: this.orderId
                } as PayResultParams
              })
            }
          }
        })
        .width("100%")
        .height("100%")
    }
    .hideTitleBar(true)
    .padding({
      top: this.topHeight
    })
  }
}

@Builder
function PayViewBuilder() {
  PayView()
}