@Component
export struct HDMCellGroup {
  @BuilderParam
  default: () => void = this.getDefaultBuilder

  // 当子组件只有一个@BuilderParam的时候才可以用尾随闭包写法
  @Builder
  getDefaultBuilder() {
  }

  build() {
    Column() {
      if (this.default) {
        this.default()
      }
    }
    .alignItems(HorizontalAlign.Start)
    .border({
      width: { top: 0.6, bottom: 0.6 },
      color: $r('app.color.under')
    })
    .padding({ left: 16, right: 16 })
    .backgroundColor($r("app.color.white"))
  }
}

// Column () {  }