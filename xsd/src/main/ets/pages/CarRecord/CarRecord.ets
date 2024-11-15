import { CommonRouterParams, HmCard, HmCardItem, HmCheckBox, HmLoading, HmNavBar } from '@blend/basic'
import { carRecordAPI, getTaskDetailAPI } from '../../api/task'
import { CarRecordTypeModel, TaskDetailInfoModel } from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import dayjs from 'dayjs'

// 实现交车功能
// 1. 调用接口
@Entry
@Component
struct CarRecord {
  loading = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true
  })
  @State taskDetailData: TaskDetailInfoModel = {} as TaskDetailInfoModel
  /** 定义变量, 准备收集用户选中的数据 */
  @State carRecord: CarRecordTypeModel = {} as CarRecordTypeModel

  async aboutToAppear() {
    await this.getTaskDetail()
  }

  private async getTaskDetail() {
    const params = router.getParams() as CommonRouterParams
    if (params.id) {
      this.loading.open()
      const result = await getTaskDetailAPI(params.id)
      this.taskDetailData = result
      this.loading.close()
    }
  }

  // 交车点击事件执行的逻辑
  async onCarRecord() {
    this.carRecord.id = this.taskDetailData.transportTaskId // id用的不是taskDetailData.id 而是transportTaskId
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime
    await carRecordAPI(this.carRecord)
    promptAction.showToast({ message: '交车成功' })
    router.replaceUrl({ url: '@bundle:com.blend.harmony1/xsd/ets/pages/Index/Index' })
  }

  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({
              leftText: '出车时间',
              rightText: this.taskDetailData.actualDepartureTime
            })
            HmCardItem({
              leftText: '回车时间',
              rightText: this.carRecord.endTime || '请选择',
              showBottomBorder: false,
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true, // 24小时制
                  onDateAccept: (value: Date) => {
                    this.carRecord.endTime = dayjs(value).format('YYYY-MM-DD HH:mm')
                  }
                })
              }
            })
          }

          HmCheckBox({
            title: '车辆违章',
            value: !!this.carRecord.isBreakRules,
            checkChange: (value) => {
              this.carRecord.isBreakRules = value
            }
          })
          HmCheckBox({
            title: '车辆故障',
            value: !!this.carRecord.isFault,
            checkChange: (value) => {
              this.carRecord.isFault = value
            }
          })
          HmCheckBox({
            title: '车辆事故',
            value: !!this.carRecord.isAccident,
            checkChange: (value) => {
              this.carRecord.isAccident = value
            }
          })
        }
        .height('100%')
      }
      .layoutWeight(1)

      // 底部内容
      Row() {
        Button("交车", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .width(207)
          .height(50)
          .enabled(!!this.carRecord.endTime)
          .onClick(() => {
            this.onCarRecord()
          })
      }
      .backgroundColor($r('app.color.white'))
      .height(70)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
}