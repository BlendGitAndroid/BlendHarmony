import { DefaultUserList, UserInfo } from '../models/user'
import { router } from '@kit.ArkUI'

// 组件和页面的区别,页面有@Entry,但是组件没有
@Component
struct Connect {
  @State
  @Watch('filterName')
  searchText: string = '' // searchText发生变化的时候,执行filterName方法

  // 筛选,监听searchText,发生变化调用filterName方法,直接使用filter方法
  filterName() {
    this.filterList = DefaultUserList.filter(user => user.username.includes(this.searchText))
  }

  @State
  filterList: UserInfo[] = []

  // 初始赋值
  aboutToAppear(): void {
    this.filterList = DefaultUserList
  }

  build() {
    Column() {
      // 搜索
      Row() {
        // 直接使用Search组件
        Search({ placeholder: '搜索', value: $$this.searchText })
          .height(30)
          .backgroundColor($r('app.color.white'))
          .borderRadius(4)
      }
      .width('100%')
      .padding({
        left: 10,
        right: 10,
        top: 10
      })

      //  联系人列表
      List() {
        ForEach(this.filterList, (user: UserInfo) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(user.avatar)
                .width(30)
                .aspectRatio(1)
                .borderRadius(4)
              Text(user.username)
                .layoutWeight(1)
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
            }
            .padding(16)
            .backgroundColor($r('app.color.white'))
            .border({
              // 增加底部横线
              width: {
                bottom: 1
              },
              color: '#f5f7f8'
            })
          }
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony1/wechat/ets/pages/ChatDetail/ChatDetail',
              params: user
            })
          })
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}

export default Connect