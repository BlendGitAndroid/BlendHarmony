import text from '@ohos.graphics.text'

@CustomDialog
@Component
export struct HmSelectCard {
  controller: CustomDialogController
  title: string = "请选择"
  showClose: boolean = true // 是否显示关闭的小图标
  showButton: boolean = true // 是否显示底部的按钮
  buttonText: string = '确定'
  onConfirm: () => void = () => {
  }
  @BuilderParam
  cardContent: () => void // 外部决定内容显示什么内容

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(16).fontColor($r('app.color.text_primary'))
        if (this.showClose) {
          Image($r("app.media.ic_btn_close")).width(13).height(13)
            .onClick(() => {
              this.controller.close()
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(60)
      .borderRadius({ topLeft: 16, topRight: 16 })

      // 渲染内容
      if (this.cardContent) {
        this.cardContent()
      }

      Row() {
        if (this.showButton) {
          Button(this.buttonText, { type: ButtonType.Capsule })
            .width(200)
            .backgroundColor($r('app.color.primary'))
            .height(45)
            .onClick(() => {
              if (this.onConfirm) {
                this.onConfirm()
              }
            })
        }

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor($r('app.color.white'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 21.36, right: 21.36, bottom: 21.36 })

  }
}