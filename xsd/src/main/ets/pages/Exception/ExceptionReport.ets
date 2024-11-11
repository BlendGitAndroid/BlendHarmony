import { CommonRouterParams, HmCard, HmCardItem, HmNavBar, HmSelectCard, HmUpload, UploadFile } from '@blend/basic'
import dayjs from 'dayjs'
import { ExceptionParamsTypeModel } from '../../models'
import { promptAction, router } from '@kit.ArkUI'
import { exceptionReportAPI } from '../../api/task'

@Entry
@Component
struct ExceptionReport {
  @State
  exceptionForm: ExceptionParamsTypeModel = {
    exceptionDescribe: ''
  } as ExceptionParamsTypeModel
  @State
  maxSizeNumber: number = 50
  @State
  exceptErrorList: string[] =
    ["发动机启动困难", "不着车、漏油", "照明失灵", "有异常响动", "排烟异常、温度异常", "其他问题"]
  @State
  selectedIndex: number = -1

  onPageShow() {
    const params = router.getParams() as CommonRouterParams
    if (params.id) {
      this.exceptionForm.transportTaskId = params.id
    }

    if (params.location) {
      this.exceptionForm.exceptionPlace = params.location
    }
  }

  @Builder
  getCardContent() {
    ForEach(this.exceptErrorList, (item: string, index,) => {
      this.getSingleItem(item, index, this.exceptErrorList.length - 1 !== index)
    })
  }

  @Builder
  getSingleItem(item: string, index: number, showBorder: boolean) {
    Row() {
      Text(item)
        .fontSize(14)
        .fontWeight(400)
        .fontColor($r('app.color.text_primary'))
      Row() {
        Image($r(this.selectedIndex === index ? "app.media.ic_check_true" : "app.media.ic_check_false"))
          .width(32)
          .height(32)
          .onClick(() => {
            this.selectedIndex = index
          })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .border({
      width: {
        bottom: showBorder ? 1 : 0
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(60)
  }

  // 当表单收集到所有的数据, 返回true
  getBtnEnable() {
    return !!(this.exceptionForm.exceptionDescribe
      && this.exceptionForm.exceptionImagesList?.length
      && this.exceptionForm.exceptionPlace
      && this.exceptionForm.exceptionTime
      && this.exceptionForm.exceptionType
      && this.exceptionForm.transportTaskId)
  }

  async onReport() {
    // 上传后的在线图片地址
    const list = await UploadFile(this.exceptionForm.exceptionImagesList!)
    this.exceptionForm.exceptionImagesList = list
    // 调用上报的接口
    await exceptionReportAPI(this.exceptionForm)
    promptAction.showToast({ message: '上传成功' })
    router.back({
      url: 'pages/TaskDetail/TaskDetail',
      params: {
        addExcept: true
      }
    })
  }

  typeDialog = new CustomDialogController({
    builder: HmSelectCard({
      cardContent: () => {
        this.getCardContent()
      },
      title: '请选择异常类型',
      onConfirm: () => {
        if (this.selectedIndex === -1) {
          promptAction.showToast({ message: '请选择' })
          return
        }

        this.exceptionForm.exceptionType = this.exceptErrorList[this.selectedIndex]
        this.typeDialog.close()
      }
    }),
    customStyle: true
  })

  build() {
    Column() {
      HmNavBar({ title: '上报异常' })
      Scroll() {
        Column() {
          HmCard() {
            HmCardItem({
              leftText: '异常时间', rightText: this.exceptionForm.exceptionTime || '请选择',
              onRightClick: () => {
                DatePickerDialog.show({
                  showTime: true,
                  useMilitaryTime: true,
                  onDateAccept: (value) => {
                    this.exceptionForm.exceptionTime = dayjs(value).format('YYYY-MM-DD HH:mm') // dayjs时间控件
                  }
                })
              }
            })
            HmCardItem({
              leftText: '上报位置',
              rightText: this.exceptionForm.exceptionPlace || '请选择',
              onRightClick: () => {
                promptAction.showToast({
                  message: "位置上报暂未实现"
                })
              }
            })
            HmCardItem({
              leftText: '异常类型', rightText: this.exceptionForm.exceptionType || '请选择', onRightClick: () => {
                this.typeDialog.open()
              }
            })
            HmCardItem({
              leftText: '异常描述',
              rightText: '',
              showRightIcon: false,
              showBottomBorder: false
            })
            TextArea({
              placeholder: '请输入异常描述',
              text: this.exceptionForm.exceptionDescribe
            })
              .height(130)
              .borderRadius(8)
              .placeholderColor($r('app.color.text_secondary'))
              .fontSize(14)
              .onChange((value) => {
                this.exceptionForm.exceptionDescribe = value
              })
              .maxLength(this.maxSizeNumber)

            Text(`${this.exceptionForm.exceptionDescribe?.length}/${this.maxSizeNumber}`)
              .margin({ top: -30 })
              .textAlign(TextAlign.End)
              .width('100%')
              .padding({ right: 15 })
              .fontColor($r('app.color.text_secondary'))
            Row().height(20)

          }

          HmCard() {
            HmUpload({
              title: '上传图片(最多6张)',
              maxSelectNumber: 6,
              imageList: this.exceptionForm.exceptionImagesList || [],
              canUpload: true,
              onImageListChange: (list) => {
                this.exceptionForm.exceptionImagesList = list
              }
            })
            Row()
              .height(20)
          }
        }
      }.padding({
        bottom: 80
      })
      .layoutWeight(1)


      Row() {
        Button("提交")
          .height(50)
          .width(207)
          .backgroundColor($r('app.color.primary'))
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.onReport()
          })
      }
      .position({
        y: '100%'
      })
      .height(70)
      .translate({
        y: -70
      })
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}