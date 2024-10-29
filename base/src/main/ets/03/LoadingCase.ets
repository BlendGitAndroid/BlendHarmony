import MyLoading from './components/MyLoading';

@Entry
@Component
export struct LoadingCase {
  @State
  isShow: boolean = true

  aboutToAppear(): void {
    setTimeout(() => {
      this.isShow = false;
    }, 3 * 1000)
  }

  build() {
    Row() {
      Column() {
        if (this.isShow) {
          MyLoading()
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}
