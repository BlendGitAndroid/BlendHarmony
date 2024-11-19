@Preview
@CustomDialog
@Component
export struct HDMConfirm {
  controller: CustomDialogController
  message: string = ""
  onConfirm: () => void = () => {
  }
  onCancel: () => void = () => {
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .alignRules({
          middle: {
            anchor: '__container__',
            align: HorizontalAlign.Center
          },
          bottom: {
            anchor: 'cancel',
            align: VerticalAlign.Top
          }
        })
        .margin({
          bottom: 50
        })

      Text("取消")
        .textAlign(TextAlign.Center)
        .height(50)
        .fontColor($r("app.color.gray"))
        .alignRules({
          left: {
            anchor: '__container__',
            align: HorizontalAlign.Start
          },
          right: {
            anchor: '__container__',
            align: HorizontalAlign.Center
          },
          bottom: {
            anchor: '__container__',
            align: VerticalAlign.Bottom
          }
        })
        .id("cancel")
        .border({
          color: $r("app.color.gray"),
          width: {
            right: 0.5,
            top: 0.5
          }
        })
        .onClick(async () => {
          await this.onCancel()
          this.controller.close()
        })
      Text("确定")
        .height(50)
        .textAlign(TextAlign.Center)
        .fontColor($r("app.color.red"))
        .border({
          color: $r("app.color.gray"),
          width: {
            top: 0.5
          }
        })
        .alignRules({
          right: {
            anchor: '__container__',
            align: HorizontalAlign.End
          },
          left: {
            anchor: '__container__',
            align: HorizontalAlign.Center
          },
          bottom: {
            anchor: '__container__',
            align: VerticalAlign.Bottom
          }
        })
        .onClick(async () => {
          await this.onConfirm()
          this.controller.close()
        })
    }
    .height(160)
    .width(280)
    .backgroundColor($r("app.color.white"))
    .borderRadius(10)
  }
}