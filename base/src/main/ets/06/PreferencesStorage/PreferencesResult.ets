import { PreferencesUtil } from './PreferencesUtil';
import { router } from '@kit.ArkUI';

@Entry({ routeName: 'PreferencesResult' })
@Component
struct PreferencesResult {
  @State message: string = '已登录！';

  aboutToAppear(): void {
    AlertDialog.show({
      message: JSON.stringify(PreferencesUtil.getToken(getContext()))
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('退出')
          .onClick(() => {
            // PreferencesClass.removeToken(getContext())
            PreferencesUtil.setToken(getContext(), '')
            router.back()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}