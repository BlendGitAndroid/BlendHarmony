import { PreferencesUtil } from './PreferencesUtil';
import { router } from '@kit.ArkUI';
import '@ohos/base/src/main/ets/06/PreferencesStorage/PreferenceCase'; // 接受命名路由
import './PreferencesResult';

@Entry({ routeName: 'PreferenceCase' })
@Component
export struct PreferenceCase {
  @State
  message: string = '暂未登录！';

  aboutToAppear(): void {
    this.message = PreferencesUtil.getToken(getContext()) + ""
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('登录')
          .onClick(() => {
            PreferencesUtil.setToken(getContext(), '123456')
            AlertDialog.show({
              message: '登录成功！'
            })
            router.pushNamedRoute({
              name: 'PreferencesResult'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}