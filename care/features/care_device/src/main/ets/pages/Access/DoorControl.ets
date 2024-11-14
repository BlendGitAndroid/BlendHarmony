import { ResManager, RouterConfig } from '@care/basic/Index'
import router from '@ohos.router'
import { getDeviceStatus } from '../../api'
import { DeviceStatusData, DeviceStatusDataModel } from '../../viewmodel'
import { EcLoading } from '@itheima/wing-care'
import { blueManager } from '../../utils'
import { promptAction } from '@kit.ArkUI'

class ControlItem {
  name: string = ''
  url: string = ''
}

@Entry
@Component
struct DoorControl {
  // CustomDialog
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({
      tip: "蓝牙连接中..."
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @StorageProp('topHeight')
  topHeight: number = 0
  // 控制列表
  list: ControlItem[] = [
    { name: '蓝牙开门', url: RouterConfig.DEVICE_DOOR_BLUE_OPEN_URL },
    { name: '远程开门', url: RouterConfig.DEVICE_DOOR_REMOTE_OPEN_URL },
    { name: '临时密码', url: RouterConfig.DEVICE_DOOR_PASSWORD_URL },
    { name: '开门记录', url: RouterConfig.DEVICE_DOOR_OPEN_RECORD_URL },
  ]
  @State
  deviceStatus: DeviceStatusDataModel = new DeviceStatusDataModel({} as DeviceStatusData)

  aboutToAppear(): void {
    this.getDeviceStatus()
    this.connect()
  }

  isLinking: boolean = false // 是否正在连接

  // 连接蓝牙
  async connect() {
    // 开启蓝牙的连接
    // 进度条
    this.loading.open() // 打开进度条
    const isOpen = await blueManager.checkBlue() // 检查蓝牙是否开启

    if (isOpen) {
      // 这个回调会频繁的执行
      blueManager.scanDevice((list) => {
        if (!this.isLinking) {
          // 只要找到了我需要的 就不进行下个逻辑
          const filter = list.filter(item => item.deviceName.startsWith("JL-ITHEIMA"))
          if (filter.length) {
            // 专注的连接这一个
            this.isLinking = true
            blueManager.connectBlue(filter[0].deviceId, () => {
              // 连接成功会告诉我
              this.loading.close() // 关闭进度条
            })
          }

        }

      })
    } else {
      promptAction.showToast({ message: '请先打开蓝牙' })
      this.loading.close() // 打开进度条
    }
  }

  onBackPress(): boolean | void {
    blueManager.destroy()
  }

  async getDeviceStatus() {
    const params = router.getParams() as object
    if (params && params["iotId"]) {
      this.deviceStatus = await getDeviceStatus(params["iotId"])
    }
  }

  @Builder
  cellItem(title: string, url: string = '') {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row() {
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => router.pushUrl({ url }))
  }

  build() {
    Navigation() {
      //  1. 设备信息
      Column({ space: 8 }) {
        Text(this.deviceStatus.name)
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .margin({ top: 20 })
        Text(this.deviceStatus.status === "ONLINE" ? "在线" : "离线")
          .fontColor('#fff')
          .fontSize(ResManager.EC_SMALL_FS)
          .padding({
            left: 14,
            right: 14,
            top: 2.5,
            bottom: 2.5
          })
          .backgroundColor('#0398FF')
          .borderRadius(10)
        Image($r("app.media.pic_shebei_mj"))
          .width(120)
          .aspectRatio(1)
      }
      .width('100%')
      .height('30%')

      // 2. 设备控制：快捷导航
      Column() {
        List() {
          ForEach(this.list, (item: ControlItem) => {
            ListItem() {
              this.cellItem(item.name, item.url)
            }
          })
        }
        .width('100%')
        .height('auto')
        .padding({ left: 14, right: 18, })
        .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
      }
      .margin({ top: 20, left: ResManager.EC_CONTENT_SPACE, right: ResManager.EC_CONTENT_SPACE })
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)
    }
    .title('门禁管理')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
    .backgroundImage($r("app.media.pic_mjgl_bj"))
    .backgroundImageSize({ width: '100%', height: '36.2%' })

  }
}