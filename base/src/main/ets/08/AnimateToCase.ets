import { display } from '@kit.ArkUI';

@Entry({ routeName: "AnimateToCase" })
@Component
export struct AnimateToCase {
  // animateTo函数，对闭包前界面和闭包中的状态变量引起的界面之间的差异做动画。支持多次调用，支持嵌套。
  // 解释： 不论是组件的显示隐藏还是属性的变化，使用animateTo都可以实现动画

  @State
  message: string = 'Hello World';

  @State
  textSize: number = 50

  @State
  textColor: string = '#000'

  @State
  textOpacity: number = 1

  @State
  positionX: number = 0

  @State
  positionY: number = 0

  displayWidth: number = 0;

  displayHeight: number = 0;

  aboutToAppear(): void {
    let deviceDisplay: display.Display = display.getDefaultDisplaySync();
    this.displayWidth = px2vp(deviceDisplay.width)
    this.displayHeight = px2vp(deviceDisplay.height)
    console.log(this.displayWidth + " AnimateToCase-- " + this.displayHeight)
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(this.textSize)// 对大小
        .fontWeight(FontWeight.Bold)
        .fontColor(this.textColor)// 对颜色
        .opacity(this.textOpacity)// 对透明度
        .position({
          // 对位置
          x: this.positionX,
          y: this.positionY,
        })

      Button('隐藏')
        .onClick(() => {
          animateTo({
            // 动画参数的配置
            duration: 2000
          }, () => {
            // 动画的结果
            this.message = 'World Hello'
            this.textSize = 16
            this.textColor = '#ff00f0'
            this.textOpacity = 0
            this.positionX = this.displayWidth
            this.positionY = this.displayHeight
          })
        })


      Button('显示')
        .onClick(() => {
          animateTo({
            // 动画参数的配置
            duration: 5000
          }, () => {
            // 动画的结果
            this.message = 'Hello World'
            this.textSize = 50
            this.textColor = '#000'
            this.textOpacity = 1
            this.positionX = 0
            this.positionY = 0
          })
        })
    }
    .width('100%')
    .height('100%')
  }
}
