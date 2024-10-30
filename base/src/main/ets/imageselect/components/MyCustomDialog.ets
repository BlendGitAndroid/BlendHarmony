// 声明一个弹框,是一个弹框
@CustomDialog
export struct MyCustomDialog {
  @Prop
  selectedList: ResourceStr[]

  @State
  activeIndex: number = 0

  // 必须得有一个弹层控制器
  controller: CustomDialogController

  build() {
    Column() {
      // 滑块视图容器，提供子组件滑动轮播显示的能力
      Swiper() {
        ForEach(this.selectedList, (item: ResourceStr) => {
          Image(item)
            .width('100%')
        })
      }
      .index($$this.activeIndex)  // 设置当前在容器中显示的子组件的索引值

      Text(`${this.activeIndex + 1}/${this.selectedList.length}`)
        .fontColor('#fff')
        .margin(5)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#d2010203')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 使用弹层控制器关闭
      this.controller.close()
    })
  }
}
