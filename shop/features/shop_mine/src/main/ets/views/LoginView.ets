import { GlobalVariable, HDMNavBar, auth, storeManager, authCart } from '@shop/basic'
import { promptAction } from '@kit.ArkUI'
import { loginAPI } from '../api'
import { LoginParams } from '../viewmodels'

@Component
export struct LoginView {
  @State
  loginForm: LoginParams = {
    account: '13200000001',
    password: "123456"
  }
  @State valid: boolean = false
  @State agree: boolean = false
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  @Consume
  stackPath: NavPathStack

  onInput() {
    return this.loginForm.account && this.loginForm.password ? true : false
  }

  async onSubmit() {
    if (!this.agree) {
      return promptAction.showToast({ message: '请先勾选协议' })
    }
    // 调用接口
    const user = await loginAPI(this.loginForm)
    auth.setUserInfo(user) // 写入到全局状态 内存
    storeManager.setUserInfo(user) // 写入磁盘
    authCart.updateCartCount()
    promptAction.showToast({ message: '登录成功' })
    this.stackPath.pop()
  }

  @Styles
  form() {
    .width('100%')
    .height(42)
    .padding({
      left: 16,
      right: 16,
      top: 0,
      bottom: 0
    })
  }

  build() {
    NavDestination() {
      GridRow({
        columns: {
          sm: 4,
          md: 8,
          lg: 12
        }
      }) {
        GridCol({
          span: {
            sm: 4,
            md: 6,
            lg: 8
          },
          offset: {
            sm: 0,
            md: 1,
            lg: 2
          }
        }) {
          Column() {
            HDMNavBar({
              title: '幸福商城登录',
              onLeftClick: () => {
                this.stackPath.pop()
              }
            })
            Column({ space: 16 }) {
              Text('账号密码登录')
                .fontSize(18)
                .fontColor($r('[shop_basic].color.black'))
                .width('100%')
                .fontWeight(500)
                .margin({ bottom: 10 })
              TextInput({ placeholder: '请输入账号/手机号', text: $$this.loginForm.account })
                .placeholderColor($r('[shop_basic].color.gray'))
                .placeholderFont({ size: 14 })
                .form()
              TextInput({ placeholder: '请输入密码', text: $$this.loginForm.password })
                .type(InputType.Password)
                .showPasswordIcon(false)
                .placeholderColor($r('[shop_basic].color.gray'))
                .placeholderFont({ size: 14 })
                .form()

              Row({ space: 4 }) {
                Checkbox()
                  .select($$this.agree)
                  .width(12)
                  .aspectRatio(1)
                  .selectedColor($r('[shop_basic].color.black'))
                  .mark({ size: 10, strokeWidth: 1 })
                Text() {
                  Span('查看并同意')
                  Span('《隐私条款》')
                    .fontColor('#007DFB')
                  Span('和')
                  Span('《用户协议》')
                    .fontColor('#007DFB')
                }
                .width('100%')
                .fontSize(12)
                .fontColor($r('[shop_basic].color.gray'))
              }

              Button('登录')
                .backgroundColor($r('[shop_basic].color.black'))// .enabled(this.valid)
                .enabled(this.onInput())
                .fontColor($r('[shop_basic].color.white'))
                .form()
                .onClick(() => {
                  this.onSubmit()
                })

              Row() {
                Blank()
                Text('忘记密码')
                  .fontColor('#007DFB')
                  .fontSize(12)
              }
              .width('100%')

              Column({ space: 16 }) {
                Stack() {
                  Text()
                    .width(200)
                    .height(1)
                    .backgroundColor($r('[shop_basic].color.under'))
                  Text('其他登录方式')
                    .width(100)
                    .fontSize(12)
                    .backgroundColor($r('[shop_basic].color.white'))
                    .fontColor($r('[shop_basic].color.text'))
                    .textAlign(TextAlign.Center)
                }

                Row() {
                  // 后续放置华为登录
                }
              }
              .margin({ top: 200 })
            }
            .padding(30)
          }
          .width('100%')
          .height('100%')
        }
      }

    }
    .padding({
      top: this.topHeight
    })
    .hideTitleBar(true)
  }
}

@Builder
function LoginViewBuilder() {
  LoginView()
}