@Preview
@Component
export struct HDMProgressLoading {
  @State
  value: number = 30
  timer: number = -1
  // 传入宽度
  loadingWidth: number = 80
  // 正着加 反着减
  isRight: boolean = true // 是否正向
  @State
  pAngle: number = 0
  loadingColor: ResourceColor = $r("app.color.red")

  aboutToAppear(): void {
    this.beginCount()
  }

  beginCount() {
    this.timer = setInterval(() => {
      // 如果加到了90 且当前正在正向的情况下
      if (this.value === 90 && this.isRight) {
        this.isRight = false // 要反转
      }
      if (this.value === 30 && !this.isRight) {
        // 反向减的情况 到了最小值 反转
        this.isRight = true
      }
      // 正向++ 反向--
      if (this.isRight) {
        this.value++
      } else {
        this.value--
      }

    }, 100)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Progress({
      value: this.value,
      type: ProgressType.ScaleRing,
      total: 100
    })
      .color(this.loadingColor)
      .style({
        strokeWidth: 4
      })
      .width(this.loadingWidth)
      .aspectRatio(1)
      .rotate({
        angle: this.pAngle
      })
      .onAppear(() => {
        animateTo({ duration: 1500, iterations: -1 }, () => {
          this.pAngle = 360
        })
      })


  }
}