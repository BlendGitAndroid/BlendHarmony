@Component
export struct HmSkeleton {
  // builder函数
  @Builder
  defaultBuilder() {

  }
  // 结构 -> 默认值是一个builder函数
  @BuilderParam
  defaultParam: () => void = this.defaultBuilder
  @State
  opacityValue: number = 1

  build() {
    Column({ space: 6 }) {
      //     占位的结构
      this.defaultParam()
    }
    .opacity(this.opacityValue)
    .animation({
      duration:600,
      playMode: PlayMode.Alternate,
      iterations: -1,
      curve: Curve.EaseInOut
    })
    .onAppear(() => {
      this.opacityValue = 0.5
    })
  }
}