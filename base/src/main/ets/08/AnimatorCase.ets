// 手动引入第一步
import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator'

@Entry({ routeName: "AnimatorCase" })
@Component
struct AnimatorCase {
  // 之前两种方式都使用于单次执行动画，如果有一个动画需要重复执行，并且还需要开关控制，这种复杂的动画，更适合交给animator类来实现

  @State
  rotateAngle: number = 0

  @State
  isPlay: boolean = false

  // 准备的动画参数
  animateOption: AnimatorOptions = {
    delay: 0,
    easing: "linear",
    fill: "backwards",
    direction: "normal",
    // 上面的参数一个不能少
    // 下面的参数是动画的核心
    iterations: -1,
    duration: 10 * 1000,
    // 那么起始角度是0
    begin: 0, // 这个值会被传递到onFrame的回调函数中
    // 那么终止角度是360
    end: 360
  }

  // 得到动画结果(动画遥控器)
  animateResult: AnimatorResult = animator.create(this.animateOption)

  aboutToAppear(): void {
    // 监听动画更新函数
    this.animateResult.onFrame = (val) => {
      this.rotateAngle = val // 监听动画的值，动态改变@State的值引起UI更新从而产生动画
    }
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Image($r('app.media.b'))
          .width(200)
          .borderRadius(100)
          .rotate({
            angle: this.rotateAngle // 控制旋转
          })

        Button('播放/暂停')
          .onClick(() => {
            this.isPlay = !this.isPlay
            this.isPlay ? this.animateResult.play() : this.animateResult.pause() // 通过控制器控制播放和暂停
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}