import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct FunctionCase {
  @State message: string = 'Hello World';

  // 组件内函数,也是使用的是箭头函数
  // call和apply是错误级别不支持，bind是警告，能用也别用！
  clickFn1: () => void = () => {
    promptAction.showToast({
      message: this.message
    })
  }

  // 推荐使用箭头函数的写法：如果不用箭头函数this到底是谁不确定
  clickFn() {
    promptAction.showToast({
      message: this.message
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
            // .onClick(this.clickFn) // 这种写法是不对的,clickFn中的this会指向undefined
            // .onClick(() => {
            //   this.clickFn()
            // })
          .onClick(this.clickFn1)
      }
      .width('100%')
    }
    .height('100%')
  }
}
