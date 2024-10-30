import { PreferencesUtil } from './PreferencesUtil';
import { router } from '@kit.ArkUI';

@Entry({ routeName: 'referenceCase' })
@Component
export struct PreferenceCase {
  @State message: string = '暂未登录！';

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
            router.pushUrl({
              url: '/06/PreferencesStorage/PreferencesResult'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}