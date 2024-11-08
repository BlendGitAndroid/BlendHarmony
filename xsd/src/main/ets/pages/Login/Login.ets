import { TOKEN_KEY, UserSettingClass } from '@blend/basic'
import { loginAPI } from '../../api'
import { LoginFormModel } from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import { bundleManager } from '@kit.AbilityKit'

let flag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
let bundleInfo = bundleManager.getBundleInfoForSelfSync(flag)
let appId = bundleInfo.signatureInfo.appId;

console.log('appId -----> ', appId)

@Entry
@Component
struct Login {
  @State showLoading: boolean = false
  @State accountForm: LoginFormModel = {
    account: '',
    password: '',
  }

  @Styles
  loginStyle() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  getFormValidate() {
    if (this.accountForm.account && this.accountForm.password) {
      return true
    }
    return false
  }

  async onLogin() {
    //   调用登录的接口
    const token = await loginAPI(this.accountForm)
    AlertDialog.show({ message: token, alignment: DialogAlignment.Center })
    //   保存token到APpStorage中 首选项中各一份
    const userSetting = new UserSettingClass(getContext())
    userSetting.setToken(token)
    AppStorage.setOrCreate(TOKEN_KEY, token)
    //   提示用户
    promptAction.showToast({ message: '登录成功' })
    //   跳转到首页上去
    router.pushUrl({ url: '@bundle:com.blend.harmony/xsd/ets/pages/Index/Index' })
  }

  build() {
    Column() {
      // 顶部标题
      Text("小时达").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("手机号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ placeholder: '请输入账号', text: this.accountForm.account })
        .loginStyle()
        .onChange(value => {
          this.accountForm.account = value
        })

      // 密码框
      TextInput({ placeholder: '请输入密码', text: this.accountForm.password })
        .loginStyle()
        .type(InputType.Password)// 密码框
        .showPasswordIcon(true)// 显示密码按钮
        .onChange((value) => {
          this.accountForm.password = value
        })

      // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.showLoading) {
            LoadingProgress().width(20).height(20).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .backgroundColor(this.getFormValidate() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .enabled(this.getFormValidate())
      .onClick(() => this.onLogin())
    }
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }
}