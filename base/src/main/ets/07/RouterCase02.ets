import { promptAction, router } from '@kit.ArkUI';

class OrderId {
  id: number = 0
}

@Entry({ routeName: "RouterCase02" })
@Component
struct RouterCase02 {
  @State message: string = 'RouterCase02';

  aboutToAppear(): void {
    // if(router.getParams()){
    //   promptAction.showToast({
    //     message: `
    //     当前栈数量：${router.getLength()}
    //     当前页面参数：${JSON.stringify(router.getParams())}
    //     当前订单号：${(router.getParams() as OrderId).id}
    //     当前页面状态：${JSON.stringify(router.getState())}
    //   `
    //   })
    // }
    promptAction.showToast({
      message: `
        当前栈数量：${router.getLength()}
        当前页面参数：${JSON.stringify(router.getParams())}
        当前页面状态：${JSON.stringify(router.getState())}
      `
    })
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('PushUrl跳转01')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/11/RouterCase01'
            })
          })

        Button('返回栈记录的上一个页面')
          .onClick(() => {
            router.back()
          })

        Button('不记录栈跳转-replaceUrl')
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/11/RouterCase01'
            })
          })

        Button('携带参数跳转')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/11/RouterCase01',
              params: {
                id: 654321
              }
            })
          })

        Button('单例模式跳转')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/11/RouterCase01'
            }, router.RouterMode.Single)
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}