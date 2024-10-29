import { PlayControlComp } from './components/PlayControlComp'
import { PlayNavComp } from './components/PlayNavComp'
import { WechatConsumeComp } from './components/WechatConsumeComp'

@Entry
@Component
export struct WatchCase {
  // Watch
  // 如果开发者需要关注某个状态变量的值是否改变，可以使用 `@Watch` 为状态变量设置回调函数。
  // Watch("回调函数名")中的回调必须在组件中声明，该函数接收一个参数，参数为修改的属性名
  // 注意：Watch修饰符要写在 State Prop Link Provide的修饰符下面，否则会有问题

  @Provide
  isPlay: boolean = false

  @State
  currentIndex: number = 0

  list: TabInterface[] = [
    {
      icon: $r("app.media.ic_public_message"),
      selectIcon: $r('app.media.ic_public_message_filled'),
      name: 'wechat',
      title: '微信',
    },
    {
      icon: $r('app.media.ic_public_contacts_group'),
      selectIcon: $r('app.media.ic_public_contacts_group_filled'),
      name: 'connect',
      title: '联系人',
    },
    {
      icon: $r('app.media.ic_gallery_discover'),
      selectIcon: $r('app.media.ic_gallery_discover_filled'),
      name: 'discover',
      title: '发现',
    },
    {
      icon: $r('app.media.ic_public_contacts'),
      selectIcon: $r('app.media.ic_public_contacts_filled'),
      name: 'my',
      title: '我的',
    }
  ]

  @Builder
  tabBarItem(item: TabInterface) {
    Column({ space: 6 }) {
      Image(item.name === this.list[this.currentIndex].name ? item.selectIcon : item.icon)
        .width(20)
      Text(item.title)
        .fontSize(12)
        .fontColor(item.name === this.list[this.currentIndex].name ? '#1caa20' : '#000')
    }
  }

  build() {
    Row() {
      // 设置Stack靠底部对齐
      Stack({ alignContent: Alignment.Bottom }) {
        // Tab标签
        Tabs({ index: $$this.currentIndex }) {
          ForEach(this.list, (item: TabInterface) => {
            TabContent() {
              if (item.name === 'wechat') {
                WechatConsumeComp()
              } else if (item.name === 'connect') {
                WechatConsumeComp()
              }
            }.tabBar(this.tabBarItem(item))
          })
        }.barPosition(BarPosition.End) // 在父布局的底部

        PlayNavComp()
          .translate({
            y: -60
          })
      }.width('100%')
    }
    .height('100%')
  }
}

interface TabInterface {
  name: string

  icon: ResourceStr

  selectIcon: ResourceStr

  title: string
}
