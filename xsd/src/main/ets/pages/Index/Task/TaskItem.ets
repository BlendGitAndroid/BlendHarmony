import { TaskInfoItemModel, TaskTypeEnum } from '../../../models'
import { router } from '@kit.ArkUI'

@Preview
@Component
struct TaskItemCard {
  @Prop taskItem: TaskInfoItemModel

  // 获取按钮可用性
  getBtnEnable() {
    const value = this.taskItem.status
    if (this.taskItem.enablePickUp) {
      return true
    }
    switch (value) {
      case TaskTypeEnum.Line:
      case TaskTypeEnum.Delivered:
        return true
      default:
        return false
    }
  }

  // 获取按钮显示文本
  getBtnText() {
    const value = this.taskItem.status
    switch (value) {
      case TaskTypeEnum.Waiting:
        return "提货"
      case TaskTypeEnum.Line:
        return "交货"
      case TaskTypeEnum.Delivered:
        return "回车登记"
      default:
        return ""
    }
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItem.transportTaskId}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItem.startAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItem.endAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')

      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.taskItem.planDepartureTime)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        if (this.taskItem.status !== TaskTypeEnum.Finish) {
          Button(this.getBtnText(), { type: ButtonType.Capsule })
            .backgroundColor($r('app.color.primary'))
            .fontColor($r("app.color.white"))
            .fontSize(14)
            .height(32)
            .enabled(this.getBtnEnable())// 可提货
            .onClick(() => {
              router.pushUrl({
                url: '@bundle:com.blend.harmony/xsd/ets/pages/TaskDetail/TaskDetail', params: {
                  id: this.taskItem.id
                }
              })
            })
        }

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({
      left: 19.5,
      right: 19.5,
      bottom: 18.5,
      top: 18.5
    })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))
    .onClick(() => {
      router.pushUrl({
        url: '@bundle:com.blend.harmony/xsd/ets/pages/TaskDetail/TaskDetail', params: {
          id: this.taskItem.id
        }
      })
    })

  }
}

export default TaskItemCard