import { promptAction, router } from '@kit.ArkUI'
import { CellRowArrowComp, DividerComp } from '../../common/components'
import { LOGIN_INFO, LoginInfoResponse } from '../../common/constants'

@Entry
@Component
struct SettingsIndexPage {
  // 用户信息持久化
  @StorageLink(LOGIN_INFO) loginInfo: LoginInfoResponse = {}
  @State isWifiNotification: boolean = true
  @State userExperienceImprovementPlan: boolean = true

  // 退出登录
  userLogout() {
    // 清空用户信息
    this.loginInfo = {}
    // 轻提示
    promptAction.showToast({ message: '退出成功' })
    // 返回上一页
    router.back()
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          CellRowArrowComp({ title: '个人信息' })
            .onClick(() => {
              router.pushUrl({ url: '@bundle:com.blend.harmony1/guardian/ets/pages/User/UserInfoPage' })
            })
          CellRowArrowComp({ title: '权限管理' })
            .onClick(() => {
              router.pushUrl({ url: '@bundle:com.blend.harmony1/guardian/ets/pages/Settings/SettingsPermissionPage' })
            })
          DividerComp()
        }
        .height('100%')

        Column({ space: 10 }) {
          Button('退出登录')
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.brand'))
            .borderRadius(10)
            .width('100%')
            .onClick(() => {
              // TODO: 退出登录
              this.userLogout()
            })
        }
        .padding({ left: 20, right: 20, bottom: 30 })
      }
    }
    .title('设置')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }
}