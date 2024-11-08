import { TabClass } from '@blend/basic'
import TaskList from './TaskList'
import { TaskListParamsModel, TaskTypeEnum } from '../../../models'

@Component
export struct TaskTabs {
  tabList: TabClass[] = [
    { name: 'waiting', title: '待提货' },
    { name: 'line', title: '在途' },
    { name: 'finish', title: '已完成' }// ctrl + shift + j
  ]
  @State currentIndex: number = 0
  controller = new TabsController()

  @Builder
  getTabBar(item: TabClass, index: number) {
    Column() {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.currentIndex === index ? $r('app.color.text_primary') : $r('app.color.text_secondary'))
        .fontWeight(600)
        .animation({
          duration: 300
        })
        .margin({
          bottom: 10
        })
      Divider()
        .strokeWidth(4)
        .color($r('app.color.primary'))
        .lineCap(LineCapStyle.Round)
        .width(this.currentIndex === index ? 23 : 0)
        .animation({
          duration: 300
        })
    }
    .onClick(() => {
      this.controller.changeIndex(index)
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Tabs({ index: $$this.currentIndex, controller: this.controller }) {
        ForEach(this.tabList, (item: TabClass) => {
          TabContent() {
            if (item.name === 'waiting') {
              TaskList() // 默认待提货
            } else if (item.name === 'line') {
              TaskList({ queryParams: { page: 1, pageSize: 10, status: TaskTypeEnum.Line } as TaskListParamsModel })
            } else {
              TaskList({ queryParams: { page: 1, pageSize: 10, status: TaskTypeEnum.Finish } as TaskListParamsModel })
            }
          }
          .tabBar(item.title)
        })
      }

      //   Row 占满一行, 高度跟Tabs的标题栏高度一致
      Row({ space: 20 }) {
        ForEach(this.tabList, (item: TabClass, index) => {
          this.getTabBar(item, index)
        })
      }
      .padding({
        left: 40,
        right: 40
      })
      .width('100%')
      .height(50)
      .backgroundColor($r("app.color.white"))
    }
  }
}