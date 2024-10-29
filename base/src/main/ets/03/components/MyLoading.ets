@Preview
@Component
export default struct MyLoading {
  @State
  value: number = 0;
  // 定时器的引用
  timer: number = -1

  // 1.进入aboutToAppear/离开aboutToDisappear页面的周期
  // 2.定时任务(间隔一段时间执行一次)setInterval  clearInterval(id)
  // 3.延时任务(隔一段时间只执行依次)setTimeout  clearTimeout(id)

  // 进入界面
  aboutToAppear(): void {
    this.timer = setInterval(() => {
      this.value++;
      if (this.value == 100) {
        this.value = 0;
      }
    }, 10)
  }

  // 离开界面
  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Progress({
      type: ProgressType.Ring,
      total: 100,
      value: this.value
    })
  }
}
