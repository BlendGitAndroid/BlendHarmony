import { HmCard, HmCardItem, HmConfirm, HmNavBar, TOKEN_KEY, UserSettingClass } from '@blend/basic'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct Setting {
  controller = new CustomDialogController({
    builder: HmConfirm({
      message: '确定退出吗？', buttonList: [
        { text: '取消', fontColor: $r('app.color.text_secondary') },
        {
          text: '确定', fontColor: $r('app.color.text_primary'), action: () => {
          this.logout()
        }
        }
      ]
    },),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async logout() {
    AppStorage.set(TOKEN_KEY, '')
    await new UserSettingClass(getContext()).setToken('')
    router.replaceUrl({ url: '@bundle:com.blend.harmony/xsd/ets/pages/Login/Login'})
    promptAction.showToast({ message: '退出成功' })
  }

  build() {
    Column() {

      HmNavBar({ title: '系统设置' })
        .margin({ bottom: 20 })

      HmCard() {
        HmCardItem({ leftText: '换绑手机', rightText: '' })
        HmCardItem({ leftText: '修改密码', rightText: '' })
        HmCardItem({ leftText: '消息通知设置', rightText: '' })
        HmCardItem({ leftText: '清理缓存', rightText: '', showBottomBorder: false })
      }

      Row() {
        Button("退出", { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .fontColor($r("app.color.text_primary"))
          .width('100%')
          .borderRadius(8)
          .height(60)
          .onClick(() => {
            //   能够打开自定义弹出层
            this.controller.open()
          })
      }
      .width('100%')
      .margin({ top: 20 })
      .padding({ left: 15, right: 15 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}