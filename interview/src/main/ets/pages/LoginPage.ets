import { HmNavBar } from '../common/components/HmNavBar'
import { promptAction, router } from '@kit.ArkUI'
import { auth, http, tracking, UserStoreKey } from '../common/utils'
import { LoginParam, User } from '../model'

@Entry
@Component
struct LoginPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  mobile: string = 'hmheima'
  @State
  code: string = 'Hmheima%123'
  @State
  isAgree: boolean = false
  @State
  loading: boolean = false

  async login() {
    if (this.loading) {
      return
    }
    if (!this.mobile) {
      return promptAction.showToast({
        message: '请输入用户名'
      })

    }
    if (!this.code) {
      return promptAction.showToast({
        message: '请输入密码'
      })
    }
    if (!this.isAgree) {
      return promptAction.showToast({
        message: '请阅读并勾选用户协议'
      })
    }
    this.loading = true
    const user = await http.request<User, LoginParam>({
      url: 'hm/login',
      method: 'post',
      data: {
        username: this.mobile,
        password: this.code
      }
    })
    this.loading = false
    // 权限 = 用户信息 = 1.声明 2.设置 3.获取
    // 用户信息user - AppStorage+persistentStorage
    // AppStorage.setOrCreate('user', user)
    auth.setUser(user)
    tracking.report(true)
    // 登录完成：
    // 发送 - 线程内 - eventHub
    // 上下文.eventHub
    getContext().eventHub.emit(UserStoreKey)
    // 发送 - 线程间 - emitter
    // ability之间属于线程通信
    // emitter.emit('13166669999')
    // 进程 - 卡片和应用通信数据进程 - 黑马云音乐- rcp
    // formUpdate() 通知卡片
    // action 通知应用
    // 总结：
    // 组件 - 组件
    // 页面间
    // ability之间
    // 线程内
    // 线程间
    // 进程间
    // 获取参数
    const params = router.getParams() as Record<string, string>
    if (params) {
      router.replaceUrl({
        url: "@bundle:com.blend.harmony/interview/ets/" + params.return_url,
        params
      })
    } else {
      router.back()
    }
  }

  build() {
    Column() {
      HmNavBar({ showRightIcon: false })
      Column() {
        Image($r('app.media.icon'))
          .width(120)
          .aspectRatio(1)
        Text('面试通')
          .fontSize(28)
          .margin({ bottom: 15 })
        Text('搞定企业面试真题，就用面试通')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .padding(16)

      Column({ space: 15 }) {
        TextInput({ placeholder: '请输入用户名', text: $$this.mobile })
          .customStyle()
        TextInput({ placeholder: '请输入密码', text: $$this.code })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .customStyle()
        Row() {
          Checkbox()
            .shape(CheckBoxShape.ROUNDED_SQUARE)
            .selectedColor('#fa711d')
            .size({ width: 14, height: 14 })
            .select(this.isAgree)
            .onChange((val) => {
              this.isAgree = val
            })
          Text('已阅读并同意')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('用户协议')
            .fontSize(14)
            .padding({ right: 4 })
            .onClick(() => {
              router.pushUrl({
                url: '@bundle:com.blend.harmony/interview/ets/pages/WebPage',
                params: {
                  title: '用户协议',
                  src: 'http://110.41.143.89/user'
                }
              })
            })
          Text('和')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('隐私政策')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: '@bundle:com.blend.harmony/interview/ets/pages/WebPage',
                params: {
                  title: '隐私政策',
                  src: 'http://110.41.143.89/privacy'
                }
              })
            })
        }
        .width('100%')

        Button({ type: ButtonType.Normal }) {
          Row() {
            if (this.loading) {
              LoadingProgress()
                .color($r('app.color.white'))
                .width(24)
                .height(24)
                .margin({ right: 10 })
            }
            Text('立即登录')
              .fontColor($r('app.color.white'))
          }
        }
        .width('100%')
        .backgroundColor('none')
        .borderRadius(4)
        .height(44)
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [['#fc9c1c', 0], ['#fa711d', 1]]
        })
        .stateEffect(false)
        .onClick(() => {
          // TODO
          this.login()
        })
      }
      .padding({
        left: 36,
        right: 36,
        top: 30,
        bottom: 16
      })

      Column({ space: 6 }) {
        Text('其他登录方式')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .width('100%')
      .height('100%')
    }
  }
}

@Extend(TextInput)
function customStyle() {
  .placeholderColor('#C3C3C5')
  .caretColor('#fa711d')
  .height(44)
  .borderRadius(0)
  .backgroundColor($r('app.color.white'))
  .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })
}

