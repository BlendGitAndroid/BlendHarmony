import router from '@ohos.router'
@Entry
@Component
struct Index {
  @State message: string = '排名'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.pushUrl({url: 'rank/pages/RankPage'})
          })

        Text("代办列表")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'toDoList/pages/ToDoListPage'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}