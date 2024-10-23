import router from '@ohos.router'
import '@ohos/base/src/main/ets/Indexs'  // 接受命名路由

@Entry
@Component
struct Index {
  @State message: string = '排名'

  build() {
    Row() {
      Column() {
        Text("base学习")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            // 条找路由命名
            router.pushNamedRoute({
              name: 'baseIndexPage'
            })
          })

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

        Text("Video组件的使用")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'simpleVideo/pages/SimpleVideoIndex'})
          })

        Text("给应用添加弹窗")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'multipleDialog/pages/HomePage'})
          })

        Text("给应用添加动画")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'animateRefresh/pages/TabIndex'})
          })

        Text("Web组件的使用")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'webComponent/pages/MainPage'})
          })

        Text("使用HTTP访问网络")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'httpRequest/pages/Index'})
          })

        Text("保存应用数据")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'dataPreferences/pages/HomePage'})
          })

        Text("三方库")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'thirdParty/pages/MainPage'})
          })

        Text("给应用添加通知消息")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'notificationDownload/pages/MainPage'})
          })

        Text("后台代理提醒")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(() => {
            router.pushUrl({url: 'reminderClock/pages/MainIndex'})
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}