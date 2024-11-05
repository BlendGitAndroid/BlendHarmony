import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct AppStorageCase {
  // 只在内存中生效
  // AppStorage是在应用启动的时候会被创建的单例。它的目的是为了提供应用状态数据的中心存储，这些状态数据在应用级别都是可访问的。
  // AppStorage将在应用运行过程保留其属性。属性通过唯一的键字符串值访问。
  // AppStorage可以和UI组件同步，且可以在应用业务逻辑中被访问。
  // AppStorage支持应用的[主线程]内多个UIAbility实例间的状态共享。
  // AppStorage中的属性可以被双向同步，数据可以是存在于本地或远程设备上，并具有不同的功能，比如数据持久化


  @State
  username: string = ""

  @State
  password: string = ""

  @State
  user: Record<string, string> = { 'username': 'zs', 'age': '18' }

  // 获取数据第二种写法
  // 单向改，自己改了自己会变，不会影响全局状态
  // @StorageProp('userInfo')

  // 双向改
  @StorageLink('userInfo')
  userInfo: Record<string, string> = {
    'nickName': 'zs',
    'age': '18'
  }

  aboutToAppear(): void {
    // 获取数据第一种：API的写法
    const user = AppStorage.get<Record<string, string>>('userInfo')
    this.user = user!
  }

  login() {
    // 校验内容
    if (this.username === 'admin' && this.password === '123456') {
      //  向应用状态存贮账号信息
      const userInfo: Record<string, string> = {
        'nickName': 'Blend',
        'age': '99'
      }

      // 如果是第一次(或者不确定的时候)写入必须用setOrCreate
      // <Record<string, string>>代表对写入内容的类型约束
      AppStorage.setOrCreate<Record<string, string>>('userInfo', userInfo)
      // 跳转
      router.pushUrl({
        url: '下一个界面'
      })
    } else {
      promptAction.showToast({
        message: '账号或密码错误'
      })
    }
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Text(JSON.stringify(this.user))

        TextInput({ placeholder: '请输入用户名', text: $$this.username })

        TextInput({ placeholder: '请输入密码', text: $$this.password })
          .type(InputType.Password)

        Button("登录")
          .width('100%')
          .onClick(() => {
            this.login()
          })
      }
      .padding(20)
      .width('100%')
    }
    .height('100%')
  }
}
