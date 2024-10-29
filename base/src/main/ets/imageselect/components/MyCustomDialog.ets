// 声明一个弹框
@CustomDialog
export struct MyCustomDialog {
  @Prop
  selectedList: ResourceStr[]

  @State
  activeIndex: number = 0

  // 弹层控制器
  controller: CustomDialogController

  build() {
    Column() {
      Swiper() {
        ForEach(this.selectedList, (item: ResourceStr) => {
          Image(item)
            .width('100%')
        })
      }
      .index($$this.activeIndex)

      Text(`${this.activeIndex + 1}/${this.selectedList.length}`)
        .fontColor('#fff')
        .margin(5)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#d2010203')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.controller.close()
    })
  }
}
