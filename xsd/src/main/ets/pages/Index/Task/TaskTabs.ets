import { TabClass } from '@blend/basic'
import TaskList from './TaskList'
import { TaskListParamsModel, TaskTypeEnum } from '../../../models'

@Component
export struct TaskTabs {
  tabList: TabClass[] = [
    { name: 'waiting', title: '待提货' },
    { name: 'line', title: '在途' },
    { name: 'finish', title: '已完成' }
  ]
  @State
  currentIndex: number = 0
  // 通过TabsController来控制滑动的index
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
        .lineCap(LineCapStyle.Round)// 设置分割线的端点样式, 在线条两端延伸半个圆，直径等于线宽
        .width(this.currentIndex === index ? 23 : 0)// 通过控制宽度来实现显示不显示
        .animation({
          duration: 300
        })
    }
    .onClick(() => {
      this.controller.changeIndex(index) // 通过点击改变Tabs的index
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 内部的Tabs,绑定index和controller
      Tabs({ index: $$this.currentIndex, controller: this.controller }) {
        ForEach(this.tabList, (item: TabClass) => {
          TabContent() {
            if (item.name === 'waiting') { // 待提货
              TaskList() // 默认待提货
            } else if (item.name === 'line') { // 在途
              TaskList({ queryParams: { page: 1, pageSize: 10, status: TaskTypeEnum.Line } as TaskListParamsModel })
            } else { // 已完成
              TaskList({ queryParams: { page: 1, pageSize: 10, status: TaskTypeEnum.Finish } as TaskListParamsModel })
            }
          }
          .tabBar(item.title)
        })
      }

      // Row 占满一行, 高度跟Tabs的标题栏高度一致
      // 使用下面的Row覆盖Tabs默认的标题
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