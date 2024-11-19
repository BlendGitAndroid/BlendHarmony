import { GlobalVariable, HDMGuess, HDMNavBar, PAGE_PATH, PayResultParams } from '@shop/basic'

@Builder
function PayResultViewBuilder() {
  PayResultView()
}


@Component
export struct PayResultView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  payResult: boolean = false
  orderId: string = ''
  @Consume
  stackPath: NavPathStack

  aboutToAppear(): void {
    const params = this.stackPath.getParamByName(PAGE_PATH.PAY_RESULT_PAGE) as PayResultParams[]
    if (params && params.length && params[params.length - 1]) {
      this.payResult = params[params.length - 1].payResult
      this.orderId = params[params.length - 1].orderId
    }
  }

  build() {
    NavDestination() {
      Column() {
        HDMNavBar({ title: this.payResult ? '付款成功' : '付款失败' })
        List() {
          ListItem() {
            Column({ space: 20 }) {
              Image(this.payResult ? $r('[shop_basic].media.ic_public_check_filled') :
              $r('[shop_basic].media.ic_public_close_filled'))
                .width(60)
                .height(60)
                .fillColor(this.payResult ? '#00C1BF' : '#B0171F')
              Text(this.payResult ? '付款成功' : '付款失败')
              Row({ space: 20 }) {
                Button('返回首页')
                  .backgroundColor($r('[shop_basic].color.black'))
                  .fontSize(14)
                  .height(36)
                  .onClick(() => {
                    this.stackPath.popToIndex(-1) // 回到最起始页面
                    // 清除路由栈
                    this.stackPath.clear() // 清空路由栈
                  })
                Button('查看订单')
                  .fontSize(14)
                  .height(36)
                  .backgroundColor($r('[shop_basic].color.white'))
                  .fontColor($r('[shop_basic].color.black'))
                  .border({ width: 0.5, color: $r('[shop_basic].color.border') })
                  .onClick(() => {

                  })

              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }
            .padding(40)
            .backgroundColor($r('[shop_basic].color.under'))
          }

          ListItem() {
            HDMGuess()
              .height("100%")
          }
        }
        .layoutWeight(1)
        .height('100%')
        .width('100%')
        .scrollBar(BarState.Off)
      }
    }
    .hideTitleBar(true)
    .padding({
      top: this.topHeight
    })

  }
}