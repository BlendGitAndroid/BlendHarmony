import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct StateCase {
  // State修饰的类型：Object、class、string、number、boolean、enum类型，以及这些类型的数组
  // 类型必须被指定
  // 不支持any，不支持简单类型和复杂类型的联合类型，不允许使用undefined和null

  // @state可以在数据发生变化的时候通知引用的地方来进行页面的更新
  // 如果不用State修饰,那么TextInput就不会自动更新
  @State
  name: string = '';
  @State
  password: string = ''

  getEnable(): boolean {
    return !!this.name && !!this.password
  }

  build() {
    Row() {
      Column({ space: 20 }) {

        TextInput({ placeholder: '请输入用户名', text: this.name })
          .width('80%')
          .onChange((value: string) => {
            this.name = value;
          })

        TextInput({ placeholder: '请输入密码', text: this.password })
          .width('80%')
          .type(InputType.Password)// 设置输入框类型
          .onChange((value: string) => {
            this.password = value;
          })

        Button("登录")
          .width('80%')
          .onClick(() => {
            if (this.name === 'blend' && this.password === '123456') {
              promptAction.showToast({
                message: '登录成功'
              })
            } else {
              promptAction.showToast({
                message: '密码错误'
              })
            }
          }).enabled(this.getEnable())

        Button("一键写入帐号和密码")
          .width('80%')
          .onClick(() => {
            this.name = 'blend'
            this.password = '123456'
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
