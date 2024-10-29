import { promptAction } from '@kit.ArkUI'

@Entry
@Component
export struct StateStyleCase {
  // stateStyles可以依据组件的内部状态的不同
  // focused：获焦态。
  // normal：正常态。
  // pressed：按压态。
  // disabled：不可用态。
  // selected: 选中态

  // 使用比较多的应该是 `normal` `pressed` 结合下的按压效果

  @State
  canUsed: boolean = true

  build() {
    Row() {
      Column({ space: 20 }) {

        TextInput({ placeholder: '请输入帐号' })
          .width('100%')// .border({
            //   // 这也是正常态
            //   width: 2,
            //   color: '#999999'
            // })
          .onFocus(() => {
            promptAction.showToast({
              message: '聚焦了！'
            })
          })
          .stateStyles({
            // 正常态
            normal: {
              .border({
                width: 2,
                color: '#999999'
              })
            },

            focused: {
              .border({
                width: 2,
                color: Color.Orange
              })
              .width('80%')
            }
          })

        TextInput({ placeholder: '请输入密码' })
          .width('100%')
          .type(InputType.Password)
            // .border({
            //   // 这也是正常态
            //   width: 2,
            //   color: '#999999'
            // })
          .onFocus(() => {
            promptAction.showToast({
              message: '聚焦了！'
            })
          })
          .stateStyles({
            // 正常态
            normal: {
              .border({
                width: 2,
                color: '#999999'
              })
            },

            focused: {
              .border({
                width: 2,
                color: Color.Orange
              })
              .width('80%')
            }
          })

        Button('注册')
          .width('100%')
          .backgroundColor(Color.Blue)
          .enabled(this.canUsed)
          .stateStyles({
            // 禁用
            disabled: {
              .backgroundColor(Color.Gray)
            },
            // 按压
            pressed: {
              .backgroundColor(Color.Green)
            }
          })

        // selected支持的并不多,有点鸡肋
        Toggle({
          type: ToggleType.Switch,
          isOn: $$this.canUsed
        }).selectedColor(Color.Green)


      }
      .padding(20)
      .width('100%')
    }
    .height('100%')
  }
}
