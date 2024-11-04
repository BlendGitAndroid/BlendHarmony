import { DefaultUserList, UserInfo } from '../models/user'
import { router } from '@kit.ArkUI'

// 组件和页面的区别
@Component
struct Connect {
  @State
  @Watch('filterName')
  searchText: string = ''

  // 筛选
  filterName(){
    this.filterList = DefaultUserList.filter(user=>user.username.includes(this.searchText))
  }

  @State
  filterList:UserInfo[] = []

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
      }.width('100%')
      .padding({
        left: 10,
        right: 10,
        top: 10
      })
      // 验证搜索效果：
      // TextInput({text:'老'})
      //   .width('100%')

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
              width: {
                bottom: 1
              },
              color: '#f5f7f8'
            })
          }
          .onClick(()=>{
            router.pushUrl({
              url:'@bundle:com.blend.harmony/wechat/ets/pages/ChatDetail/ChatDetail',
              params:user
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