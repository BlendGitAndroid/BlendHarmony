import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct StyleCase {
  // 注意： Styles和Extend均只支持在当前文件下的全局或者组件内部定义，如果你想要在其他文件导出一个公共样式，导出公共使用，
  // ArtTS是不支持的，这种方式还是需要考虑组件复用。
  // 在开发过程中会出现大量代码在进行重复样式设置，`@Styles` 可以帮我们进行样式复用

  // 组件内生命@Styles,只能在当前组件用
  // 1.不能导入导出
  // 2.不能传参
  // 3.只能用通用属性和事件
  // 4.支持 全局定义和 组件内定义，同时存在组件内覆盖全局生效
  @Styles
  MyStyleFunction() {
    .width('80%')
    .backgroundColor('#FF00FF0F')
    .onClick(() => {
      promptAction.showToast({
        message: '微信支付成功'
      })
    })
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Button('微信支付')
          .MyStyleFunction()

        Button('微信支付')
          .MyStyleFunction()

        Button('支付宝支付')
          .MyButtonStyle()

        Button('支付宝支付')
          .MyButtonStyle()
      }
      .width('100%')
    }
    .height('100%')
  }
}


// 全局Styles扩展符只能和使用它的组件位于同一个文件，不允许导入导出，导入导出也使用不了
@Styles
function MyButtonStyle() {
  .width('80%')
  .backgroundColor('#ff0a6adb')
  .onClick(() => {
    promptAction.showToast({
      message: '支付宝支付成功'
    })
  })
}
