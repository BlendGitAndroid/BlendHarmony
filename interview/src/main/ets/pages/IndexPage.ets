import { auth } from '../common/utils'
import { theme } from '../common/utils/Theme'
// 数据结构定义
import { HomePage } from './HomePage'
import { InterviewPage } from './InterviewPage'
import { MinePage } from './MinePage'
import { ProjectPage } from './ProjectPage'

// 满足persistentStorage的限制条件：UI结构已经有了//
// 加载页面前就会执行的
auth.initUser()
theme.initTheme()
//ArkTs代码可以执行的地方（只是不能写arkUI
// const a:string = '123456'


interface TabItem {
  icon: Resource
  activeIcon: Resource
  name: string
}

@Entry
@Component
struct IndexPage {
  // 放置tabs组件
  @StorageLink('topHeight') topHeight: number = 0
  @StorageLink('bottomHeight') bottomHeight: number = 0
  @State
  tabList: TabItem[] = [
    {
      icon: $r('app.media.tabbar_home'),
      activeIcon: $r('app.media.tabbar_home_fill'),
      name: '首页'
    },
    {
      icon: $r('app.media.tabbar_project'),
      activeIcon: $r('app.media.tabbar_project_fill'),
      name: '项目'
    },
    {
      icon: $r('app.media.tabbar_interview'),
      activeIcon: $r('app.media.tabbar_interview_fill'),
      name: '面经'
    },
    {
      icon: $r('app.media.tabbar_mine'),
      activeIcon: $r('app.media.tabbar_mine_fill'),
      name: '我的'
    }
  ]
  @State
  activeIndex: number = 0

  // tabbarBuilder
  @Builder
  TabBarBuilder(item: TabItem, index: number) {
    // index是自己的索引
    Column({ space: 5 }) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .width(24)
        .aspectRatio(1)
      Text(item.name)
        .fontSize(12)
        .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
    }
  }

  build() {
    Column() {
      Tabs() {
        ForEach(this.tabList, (item: TabItem, index: number) => {
          TabContent() {
            //   每一页的内容
            if (index === 0) {
              HomePage()
            } else if (index === 1) {
              ProjectPage()
            } else if (index === 2) {
              InterviewPage()
            } else if (index === 3) {
              MinePage()
            }
          }.tabBar(this.TabBarBuilder(item, index))
        })
      }
      .barPosition(BarPosition.End)
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })
      .scrollable(false)
      .onTabBarClick((index) => {
        this.activeIndex = index
      })
      .margin({
        bottom: this.bottomHeight
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.white'))
  }
}