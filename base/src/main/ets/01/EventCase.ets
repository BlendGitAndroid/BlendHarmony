import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct EventCase {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column({ space: 20 }) {
        // 1.改变事件onChange->内容发生变化时的事件
        // 2.箭头函数()=>{}
        TextInput()
        TextInput({ placeholder: '请输入用户名' })
          .backgroundColor(Color.Pink)
          .onChange(() => { // 推荐写法：
            // 当事件触发的时候，这里面的事就会执行
            // 3.轻提示
            promptAction.showToast({
              message: '输入框字符更改！！！'
            })
          })//  进阶版写法：
            // .onChange(() => {
            //   this.login()
            // })
            // 4.提交事件
          .onSubmit(() => {
            // 5.弹层提示
            promptAction.showDialog({
              message: '提交'
            })
          })// 8.聚焦视角
          .onFocus(() => {
            promptAction.showToast({
              message: '获取焦点！！！'
            })
          })// 9.失去焦点
          .onBlur(() => {
            promptAction.showToast({
              message: '失去焦点！！！'
            })
          })
        Row() {
          Button('登录')
            .layoutWeight(1)// 6.点击事件
            .onClick(() => {
              //  7.弹层提示
              AlertDialog.show({
                message: 'Button登录！！！'
              })
            })
        }
      }
      .padding(24)
      .width('100%')
    }
    .height('100%')
  }
}
