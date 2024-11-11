import { HmNavBar, HmCard, HmCardItem, CommonRouterParams } from '@blend/basic'
import dayjs from "dayjs";
import { promptAction, router } from '@kit.ArkUI';
import { DelayParamsTypeModel } from '../../models';
import { delayAPI } from '../../api/task';


@Entry
@Component
struct Delay {
  @State
  oldTime: string = ''
  @State
  delayForm: DelayParamsTypeModel = {
    delayReason: ''
  } as DelayParamsTypeModel
  @State
  maxSizeNumber: number = 50

  aboutToAppear(): void {
    const param = router.getParams() as CommonRouterParams
    if (param.oldTime && param.id) {
      this.oldTime = param.oldTime
      this.delayForm.id = param.id
    }

  }

  async onDelay() {
    await delayAPI(this.delayForm)
    promptAction.showToast({ message: '延迟收货成功' })
    router.back()
  }

  build() {
    Column() {
      HmNavBar({ title: '延迟提货' })
      HmCard() {
        HmCardItem({ leftText: '原定时间', rightText: this.oldTime, showRightIcon: false })
        HmCardItem({
          leftText: '延迟时间',
          rightText: this.delayForm.delayTime,
          onRightClick: () => {
            DatePickerDialog.show({
              useMilitaryTime: true,
              showTime: true,
              onDateAccept: (value) => {
                this.delayForm.delayTime = dayjs(value).format('YYYY-MM-DD HH:mm')
              }
            })
          }
        })
        TextArea({ placeholder: '请输入延迟提货原因', text: this.delayForm.delayReason })
          .backgroundColor($r('app.color.background_page'))
          .margin({ top: 20 })
          .borderRadius(8)
          .height(130)
          .placeholderColor($r('app.color.text_secondary'))
          .fontSize(14)
          .onChange((value) => {
            this.delayForm.delayReason = value
          })
          .maxLength(this.maxSizeNumber)
        Text(`${this.delayForm.delayReason.length}/${this.maxSizeNumber}`)
          .margin({ top: -30 })
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 15 })
          .fontColor($r('app.color.text_secondary'))
        Row() {
          Button("提交")
            .height(50)
            .width(207)
            .backgroundColor($r('app.color.primary'))
            .enabled(!!this.delayForm.delayTime && !!this.delayForm.delayReason)
            .onClick(() => {
              this.onDelay()
            })
        }
        .justifyContent(FlexAlign.Center).padding({
          top: 20,
          bottom: 20
        })

      }
    }

    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}