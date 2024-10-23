import { promptAction } from '@kit.ArkUI'

@Entry
@Component
export struct ClickCase {
  build() {
    Column({ space: 20 }) {
      Column() {
        Text("showToast")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width(200)
      .height(50)
      .backgroundColor(Color.Pink)
      .onClick(() => {
        promptAction.showToast({
          message: "showToast"
        })
      })

      Column() {
        Text("showDialog")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width(200)
      .height(50)
      .backgroundColor(Color.Pink)
      .onClick(() => {
        promptAction.showDialog({
          message: 'showDialog'
        })
      })

      Column() {
        Text("AlertDialog.show")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width(200)
      .height(50)
      .backgroundColor(Color.Pink)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      AlertDialog.show({
        message: 'AlertDialog.show'
      })
    })
  }
}
