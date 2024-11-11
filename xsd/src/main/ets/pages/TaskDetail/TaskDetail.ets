import {
  CommonRouterParams,
  HmNavBar,
  HmSkeleton,
  HmToggleCard,
  HmUpload,
  ImageListModel,
  UploadFile
} from '@blend/basic'
import { componentSnapshot, promptAction, router } from '@kit.ArkUI'
import { deliverAPI, getTaskDetailAPI, pickUpAPI } from '../../api/task'
import { ExceptionListModel, TaskDetailInfoModel } from '../../models/task_detail'
import { HmLoading } from '@blend/basic/src/main/ets/components/HmLoading'
import { TaskTypeEnum } from '../../models'
import common from '@ohos.app.ability.common'
import call from '@ohos.telephony.call'
import { worker } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'


// 全局的Extend 拓展 文字的颜色
@Extend(Text)
function baseTextIconStyle() {
  .fontSize(12)
  .fontColor($r('app.color.white'))
  .backgroundColor($r('app.color.text_primary'))
  .width(22)
  .height(22)
  .borderRadius(11)
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function baseTextStyle() {
  .margin({
    left: 11.5
  })
  .fontColor($r('app.color.text_secondary'))
  .fontSize(14)
  .lineHeight(20)
}

class BaseBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
  iconClick?: () => void = () => {
  }
}


@Entry
@Component
struct TaskDetail {
  @State
  taskDetailData: TaskDetailInfoModel = {} as TaskDetailInfoModel
  @State
  snapImag: image.PixelMap | null = null
  // 是否要打开一个半模态框,用于截图
  @State
  snapShow: boolean = false

  async aboutToAppear() {
    await this.getTaskDetail()
  }

  async onPageShow() {
    const params = router.getParams() as CommonRouterParams
    if (params.addExcept) {
      await this.getTaskDetail()
    }
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

  @Builder
  getSnapContent() {
    Column() {
      Image(this.snapImag)
        .width("100%")
        .height("100%")
        .objectFit(ImageFit.Auto)
        .borderRadius(6)
    }
    .padding("10%")
    .width("100%")
    .height("100%")
    .backgroundColor("rgba(0,0,0,0.2)")
    .onClick(() => {
      this.snapShow = false
    })
  }

  // 定义一个Builder样式
  @Builder
  getBaseContentItem(item: BaseBuilderClass) {
    Row() {
      Text(item.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Row() {
        Text(item.value)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon)
            .width(24)
            .height(24)
            .onClick(() => {
              item.iconClick && item.iconClick()
            })
        }
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .margin({
      top: 14
    })
  }

  beginNav() {
    const context = getContext() as common.UIAbilityContext

    context.startAbility({
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'], // 拉起窗口进入到鸿蒙手机的自带浏览器app
      uri: encodeURI('https://gaode.com/search?query=' + this.taskDetailData.endAddress) // 告诉浏览器要访问的地址
    }) // 拉起一个新的窗口
  }

  // 获取基础信息
  @Builder
  getBaseInfo() {
    Row() {
      Column() {
        Row() {
          Text("起")
            .baseTextIconStyle()
          Text(this.taskDetailData.startAddress)
            .baseTextStyle()
        }.margin({
          top: 21
        })

        Row() {
          Text("止")
            .baseTextIconStyle()
            .backgroundColor($r('app.color.primary'))
          Text(this.taskDetailData.endAddress)
            .baseTextStyle()
        }.margin({
          top: 14.5
        })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        right: 20
      })

      if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Column() {
          Image($r("app.media.ic_navigation"))
            .width(22)
            .height(22)
          Text("开始导航")
            .fontSize(14)
            .margin({ top: 10, bottom: 10 })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({
          top: 20
        })
        .onClick(() => {
          this.beginNav()
        })
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center).width('100%')

    Divider()
      .vertical(false)
      .height(2)
      .color($r('app.color.background_divider'))
      .margin({
        left: 8, right: 8, top: 21
      })

    this.getBaseContentItem({
      title: '任务编号',
      value: this.taskDetailData.transportTaskId
    })
    this.getBaseContentItem({
      title: '联系人',
      value: this.taskDetailData.startHandoverName
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: this.taskDetailData.startHandoverPhone,
      icon: $r('app.media.ic_phone'),
      iconClick: () => {
        call.makeCall(this.taskDetailData.startHandoverPhone)
      }

    })
    this.getBaseContentItem({
      title: '提货时间',
      value: this.taskDetailData.planDepartureTime
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: this.taskDetailData.planArrivalTime
    })

  }

  @Builder
  getDriverInfo() {
    this.getBaseContentItem({
      title: '车牌号',
      value: this.taskDetailData.licensePlate
    })

    this.getBaseContentItem({
      title: '司机姓名',
      value: this.taskDetailData.driverName
    })
  }

  // 运输路线
  @Builder
  getTransLineContent() {
    Row() {
      Column() {
        Text(this.taskDetailData.startProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.startCity)
          .fontSize(14)
          .lineHeight(22)
      }.width(50)

      Image($r("app.media.ic_right_arrow"))
        .width(36)
        .height(16)

      Column() {
        Text(this.taskDetailData.endProvince)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .lineHeight(22)
          .fontWeight(600)
        Text(this.taskDetailData.endCity)
          .fontSize(14)
          .lineHeight(22)
      }.width(50)
    }.justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({
      left: 60,
      right: 60
    })
  }

  // 提货时上传组件
  @Builder
  getPickUpInfo() {
    HmUpload({
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting,
      title: '请拍照上传回单凭证',
      imageList: this.taskDetailData.cargoPickUpPictureList || [],
      onImageListChange: (imageList) => {
        this.taskDetailData.cargoPickUpPictureList = imageList
      }
    })

    HmUpload({
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting,
      title: '请拍照上传货物照片凭证',
      imageList: this.taskDetailData.cargoPictureList || [],
      onImageListChange: (imageList) => {
        this.taskDetailData.cargoPictureList = imageList
      }
    })
  }

  scroller = new Scroller()
  loading = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true
  })

  async onPickUp() {
    try {
      this.loading.open()
      /** 上传后的图片地址数组 */
      const cargoPickUpPictureList = await UploadFile(this.taskDetailData.cargoPickUpPictureList)
      const cargoPictureList = await UploadFile(this.taskDetailData.cargoPictureList)
      // 调用提货的接口
      await pickUpAPI({
        id: this.taskDetailData.id,
        cargoPickUpPictureList: cargoPickUpPictureList,
        cargoPictureList: cargoPictureList
      })

      this.loading.close()

      // 刷新界面
      this.getTaskDetail()
      this.scroller.scrollEdge(Edge.Top) // 控制滚动条到顶部
      promptAction.showToast({
        message: '提货成功'
      })
    } catch (e) {
      console.log(JSON.stringify(e));
      this.loading.close()
    }

  }

  getPickUpEnable() {
    const cargoPickUpPictureList = this.taskDetailData.cargoPickUpPictureList || []
    const cargoPictureList = this.taskDetailData.cargoPictureList || []
    if (cargoPickUpPictureList.length > 0 && cargoPictureList.length > 0) {
      return true
    } else {
      return false
    }
  }

  // 底部按钮结构
  @Builder
  getBottomBtn() {
    Row() {
      if (this.taskDetailData.status === TaskTypeEnum.Waiting) {
        Button("延迟提货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony/xsd/ets/pages/Delay/Delay',
              params: {
                id: this.taskDetailData.id,
                oldTime: this.taskDetailData.planDepartureTime
              }
            })
          })

        Button("提货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .enabled(this.getPickUpEnable())
          .onClick(() => {
            this.onPickUp()
          })
        // 交货的逻辑
      } else if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Button("上报异常", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony/xsd/ets/pages/Exception/ExceptionReport',
              params: {
                id: this.taskDetailData.transportTaskId
              }
            })
          })
        Button("交货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .enabled(this.getDeliverEnable())
          .onClick(() => {
            this.onDeliver() // 调用交货接口
          })
      } else if (this.taskDetailData.status === TaskTypeEnum.Delivered) {
        Row() {
          // 已交付显示回车登记
          Button("回车登记", { type: ButtonType.Capsule })
            .backgroundColor($r('app.color.primary'))
            .fontColor($r('app.color.white'))
            .height(50)
            .width('80%')
            .onClick(() => {
              router.pushUrl({
                url: '@bundle:com.blend.harmony/xsd/ets/pages/CarRecord/CarRecord',
                params: {
                  id: this.taskDetailData.id
                }
              })
            })
        }
        .width('100%').justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height(70)
    .padding({
      left: 15,
      right: 15
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.white'))
  }

  // 交货的逻辑
  // 显示交货的上传组件
  @Builder
  getDeliverContent() {
    HmUpload({
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line,
      title: '请拍照上传交货回单凭证',
      imageList: this.taskDetailData.certificatePictureList || [],
      onImageListChange: (imageList) => {
        this.taskDetailData.certificatePictureList = imageList
      }
    })
    HmUpload({
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line,
      title: '请拍照上传交货货品照片',
      imageList: this.taskDetailData.deliverPictureList || [],
      onImageListChange: (imageList) => {
        this.taskDetailData.deliverPictureList = imageList
      }
    })
  }

  // 控制交货按钮是否可以被点击
  getDeliverEnable() {
    if (this.taskDetailData.deliverPictureList?.length > 0
      && this.taskDetailData.certificatePictureList?.length > 0) {
      return true
    } else {
      return false
    }
  }

  // 调用接口, 执行交货
  async onDeliver() {

    this.loading.open()

    // 线程模块
    // 要带上文件的后缀
    const uploadWorker1 = new worker.ThreadWorker("entry/ets/workers/UploadWorker.ets") // 创建一个子线程
    const uploadWorker2 = new worker.ThreadWorker("entry/ets/workers/UploadWorker.ets") // 创建一个子线程

    let certificatePictureList: ImageListModel[] = []
    let deliverPictureList: ImageListModel[] = []

    const checkFile = async () => {
      if (!certificatePictureList.length || !deliverPictureList.length) {
        return
      }

      const res = await Promise.all([UploadFile(certificatePictureList), UploadFile(deliverPictureList)])
      await deliverAPI({
        certificatePictureList: res[0],
        deliverPictureList: res[1],
        id: this.taskDetailData.id
      })
      this.loading.close()
      promptAction.showToast({ message: '交货成功' })
      this.getTaskDetail()
    }

    // 让主线程和子线程发消息
    uploadWorker1.postMessage({
      // 不允许传非可序列化的数据, 带装饰器的数据, 不能传给子线程
      files: [...this.taskDetailData.certificatePictureList],
      filePath: getContext().filesDir
    })

    uploadWorker2.postMessage({
      // 不允许传非可序列化的数据, 带装饰器的数据, 不能传给子线程
      files: [...this.taskDetailData.deliverPictureList],
      filePath: getContext().filesDir
    })

    // 线程1完成的压缩结果,从UploadWorker中获取结果
    uploadWorker1.onmessage = (e) => {
      certificatePictureList = e.data.files
      checkFile()
    }

    // 线程2完成的压缩结果
    uploadWorker2.onmessage = (e) => {
      deliverPictureList = e.data.files
      checkFile()
    }
  }

  // 获取异常信息
  @Builder
  getExceptionContent() {
    ForEach(this.taskDetailData.exceptionList, (item: ExceptionListModel) => {
      Row() {
        Column() {
          Row() {
            Text("上报时间").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionTime).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("异常类型").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionType).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("处理结果").fontSize(14).fontColor($r('app.color.text_primary'))
            Text("继续运输").margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')
        }

        // 跳转到详情
        Image($r("app.media.ic_btn_more")).width(24).height(24)
          .onClick(() => {
            router.pushUrl({
              url: '@bundle:com.blend.harmony/xsd/ets/pages/Exception/ExceptionDetail',
              params: {
                formData: item
              }
            })
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

    })
  }

  build() {
    // 如果taskDetailData还没有数据,则显示骨架屏
    if (this.taskDetailData.id) {
      Column() {
        HmNavBar({ title: '任务详情' })

        Row() {
          // 截图
          Image($r('app.media.ic_phone'))
            .width(24)
            .height(24)
            .fillColor($r("app.color.primary"))
            .onClick(async () => {
              // 给某个组件来截图
              const spanImg = await componentSnapshot.get('detail') // detail是给某个组件分配的id, 支持自定义组件
              this.snapImag = spanImg
              this.snapShow = true
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .padding(10)

        Scroll(this.scroller) {
          Column() {
            // 基本信息
            HmToggleCard({ title: '基本信息' }) {
              this.getBaseInfo()
            }

            HmToggleCard({ title: '车辆司机信息' }) {
              this.getDriverInfo()
            }

            HmToggleCard({ title: '运输路线' }) {
              this.getTransLineContent()
            }

            if (this.taskDetailData.status === TaskTypeEnum.Waiting ||
              this.taskDetailData.status === TaskTypeEnum.Delivered) { // 提货状态显示提货信息
              HmToggleCard({ title: '提货信息' }) {
                this.getPickUpInfo()
              }
            }

            if (this.taskDetailData.status === TaskTypeEnum.Line ||
              this.taskDetailData.status === TaskTypeEnum.Delivered) { // 交货状态显示交货信息
              HmToggleCard({ title: '交货信息' }) {
                this.getDeliverContent()
              }
            }

            // 显示异常信息
            if (this.taskDetailData.status === TaskTypeEnum.Line) {
              HmToggleCard({ title: '异常信息' }) {
                this.getExceptionContent()
              }
            }

          }
        }
        .layoutWeight(1)

        this.getBottomBtn()
      }
      .backgroundColor($r('app.color.background_page'))
      .height('100%')
      .id('detail') // 定义截屏Id
      .bindContentCover($$this.snapShow,
        this.getSnapContent(), {
          modalTransition: ModalTransition.NONE
        })
    } else {
      HmSkeleton({ showAvatar: false, count: 4 })
    }
  }
}