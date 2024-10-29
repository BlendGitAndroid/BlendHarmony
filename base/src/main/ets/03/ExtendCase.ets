import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct ExtendCase {

  // Extend扩展符只能和使用它的组件位于同一个文件，不允许导入导出，导入导出也使用不了
  // 1. 使用Extend来修饰一个全局的方法
  // 2. 函数可以进行传参，如果参数是状态变量，状态更新后会刷新UI
  // 3. 参数可以是一个函数，实现复用事件且可处理不同逻辑

  build() {
    Row() {
      Column({ space: 20 }) {
        Button('微信支付')
          .MyButtonExtend('wechat')

        Button('支付宝支付')
          .MyButtonExtend('alipay')

        Button('银行卡支付')
          .MyButtonExtend('bank')
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Extend(Button)
function MyButtonExtend(type: 'wechat' | 'alipay' | 'bank') {
  .width('80%')
  .backgroundColor(type === 'wechat' ? Color.Green : (type === 'alipay' ? Color.Blue : Color.Pink))
  .type(ButtonType.Normal)
  .onClick(() => {
    promptAction.showToast({
      message: type === 'wechat' ? '微信支付成功' : '支付宝支付成功'
    })
  })
}
