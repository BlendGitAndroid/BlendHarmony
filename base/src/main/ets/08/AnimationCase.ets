@Entry({ routeName: "AnimationCase" })
@Component
struct AnimationCase {
  // animation函数作用于组件,通过改变组件的属性
  // 识别组件的可动画属性变化，自动添加动画。
  // 组件的接口调用是从下往上执行，animation只会作用于在其之上的属性调用。
  // 组件可以根据调用顺序对多个属性设置不同的animation。

  @State
  message: string = 'Hello World';

  @State
  textSize: number = 50

  @State
  bgColor: string = '#ff00f0'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(this.textSize)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.bgColor)
          .animation({
            // 动画执行时间
            duration: 2000,
            // 动画重复的次数
            iterations: -1,
            // 动画运动曲线
            curve: Curve.Linear,
            // 动画延迟执行时间
            delay: 5 * 1000,
            //播放模式
            playMode: PlayMode.Alternate
          })

        Button('变小')
          .onClick(() => {
            this.textSize = 12
            this.bgColor = '#ff00f0f0'
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}