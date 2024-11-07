// 必有有自定义@CustomDialog, 表示这不是一个普通的组件
@CustomDialog
@Component
export struct HmConfirm {
  controller: CustomDialogController
  message: string = '确认退出登录吗?'
  buttonList: HmConfirmButton[] = []

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.message)
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .height(88)
        .justifyContent(FlexAlign.Center)
        .border({
          color: $r('app.color.background_divider'),
          width: {
            bottom: 0.5
          }
        })

        Row() {
          ForEach(this.buttonList, (item: HmConfirmButton, index: number) => {
            Text(item.text)
              .fontSize(item.fontSize || 16)
              .textAlign(TextAlign.Center)
              .fontColor(item.fontColor || $r('app.color.text_secondary'))
              .layoutWeight(1)
              .border({
                color: $r('app.color.background_divider'),
                width: {
                  right: this.buttonList.length > 1 && index !== this.buttonList.length - 1
                    ? 0.5 : 0
                }
              })
              .height('100%')
              .onClick(async () => {
                if (item.action) {
                  await item.action()
                }
                this.controller.close()
              })
          })
        }
        .height(49)
        .width('100%')
      }
    }
    .width(278)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}

class HmConfirmButton {
  fontColor?: ResourceStr = ''
  fontSize?: number = 16
  text: string = ""
  action?: () => void = () => {
  }
}

