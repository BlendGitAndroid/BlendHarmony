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
            router.pushUrl({url: 'rank/pages/RankPage'}, router.RouterMode.Single)  // 单实例模式
          })

        Text("代办列表")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'toDoList/pages/ToDoListPage'})
          })

        Text("路由")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'router/pages/IndexPage'})
          })

        Text("简单的页面")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'simpleComponents/pages/LoginPage'})
          })

        Text("管理组件状态")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'targetManager/pages/MainPage'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}