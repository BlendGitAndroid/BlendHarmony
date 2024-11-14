import { EcDialogTips, EcLoading } from '@itheima/wing-care'
import router from '@ohos.router'
import { ResManager, RouterConfig } from '@care/basic/Index'
import { blueManager } from '../../utils'
import { ble } from '@kit.ConnectivityKit'
import { bindDeviceApi } from '../../api'
import { currentLot } from '../../viewmodel'

@Entry
@Component
struct NearDevice {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 1. 搜索动画
  // 旋转角度
  @State angle: number = 0
  step: number = 5
  timer: number = -1

  // 动画运行
  run() {
    // 开启定时器 每桢开始旋转固定的角度
    // 1秒60桢 需要每桢都有动画
    this.timer = setInterval(() => {
      this.angle += this.step
    }, 1000 / 60)
  }

  // 2. 搜索状态：true 搜索中 | false 结束搜索
  @State
  isSearch: boolean = true
  // true 发现设备 ｜false没有发现设备
  @State
  hasDevice: boolean = false
  @State
  list: ble.ScanResult[] = []
  @State
  isConnect: boolean = false // 是否连接上蓝牙

  // 3. 搜索方法
  search() {
    this.run() // 开始动画
    blueManager.scanDevice((list) => {
      this.list = list.filter(item => item.deviceName !== "") // 使用filter进行过滤
    })
    setTimeout(() => {
      if (this.list.length) {
        this.hasDevice = true
      }
      this.isSearch = false
      clearInterval(this.timer) // 停止动画
    }, 8000)
  }

  aboutToAppear(): void {
    this.reset()
  }

  // 重新搜索
  reset() {
    this.isSearch = true
    this.hasDevice = false
    this.search()
  }

  // 4. 未找到说明
  @Builder
  tipsContent() {
    Column() {
      Image($r("app.media.pic_shebei_mj"))
        .width(120)
        .aspectRatio(1)
      Column({ space: 5 }) {
        Text('未查找到设备怎么办？')
          .margin({ bottom: 10 })
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_MODULE_TITLE_FS)
          .fontWeight(500)
        Text('1、请检查智能门禁电源是否正常')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('2、请检查手机蓝牙是否已开启')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
        Text('3、其他问题请联系客服 000-000-00000')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .width('100%')
      .padding({ left: 14, bottom: 12, right: 14 })
      .alignItems(HorizontalAlign.Start)
    }
  }

  notFoundDialog: CustomDialogController = new CustomDialogController({
    builder: EcDialogTips({
      title: '未查找到设备',
      titleAlign: 'center',
      // 解决 this 指向问题
      tipsContent: () => {
        this.tipsContent()
      },
      cancelButton: {
        text: '我知道了',
        color: ResManager.EC_MAIN_COLOR,
        cb: () => {
          this.notFoundDialog.close()
        }
      }
    }),
    alignment: DialogAlignment.Bottom
  })
  // 自定义Dialog
  loading: CustomDialogController = new CustomDialogController({
    builder: EcLoading({
      tip: "绑定设备中..."
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  build() {
    Navigation() {
      if (!this.hasDevice) {
        Stack({ alignContent: Alignment.Bottom }) {
          // 搜索中：无设备
          Column() {
            Image(ResManager.IC_FJSB_SS)
              .width(180)
              .aspectRatio(1)
              .rotate({
                angle: this.angle
              })
              .animation({
                // 设置动画
                duration: 100
              })

            if (this.isSearch) {
              Text('正在查找附近可连接设备')
                .margin({ top: 36 })
                .fontSize(18)
                .fontColor(ResManager.EC_MID_19)
                .fontWeight(600)
            } else {
              Text('暂未发现设备')
                .margin({ top: 36 })
                .fontSize(18)
                .fontColor(ResManager.EC_MID_19)
                .fontWeight(600)
              Text('建议您拔掉设备电源，重新连接电源后再重新扫描')
                .fontSize(ResManager.EC_NORMAL_FS)
                .fontColor(ResManager.EC_MID_99)
                .margin({ top: 20 })
                .padding({ left: 60, right: 60 })

              Button('重新查找')
                .margin({ top: 50 })
                .width(230)
                .onClick(() => this.reset())
            }
          }
          .padding({ top: 80 })
          .width('100%')
          .height('100%')

          Text('未找到设备')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .margin({ bottom: 72 })
            .onClick(() => this.notFoundDialog.open())
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#fff')
      } else {
        Column() {
          // 标题
          if (!this.isConnect) {
            Row() {
              Text('未连接设备')
                .fontColor(ResManager.EC_MID_19)
                .fontSize(ResManager.EC_MODULE_TITLE_FS)
                .fontWeight(500)
              LoadingProgress()
                .margin({ left: 10 })
                .width(20)
                .height(20)
                .color(ResManager.EC_MID_99)
            }
            .width('100%')
            .margin({ top: 18, bottom: 18 })
          }
          // 设备列表
          List({ space: 10 }) {
            ForEach(
              this.list,
              (item: ble.ScanResult, i: number) => {
                ListItem() {
                  Row() {
                    Column({ space: 5 }) {
                      Text(item.deviceName)
                        .fontColor(ResManager.EC_MID_19)
                        .fontSize(ResManager.EC_NORMAL_FS)
                      Text(item.deviceId)
                        .fontColor(ResManager.EC_MID_99)
                        .fontSize(ResManager.EC_SMALL_FS)
                    }
                    .alignItems(HorizontalAlign.Start)

                    Image($r('app.media.ic_sbbd_ly'))
                      .width(24)
                      .aspectRatio(1)
                      .onClick(() => {
                        try {
                          this.loading.open()
                          // 连接蓝牙
                          blueManager.connectBlue(item.deviceId, async () => {
                            this.isConnect = true // 连接成功
                            // 因为蓝牙连接成功了 所以可以绑定了
                            await bindDeviceApi(currentLot.iotId!) // 物联网的id
                            // 进入下一步
                            router.pushUrl({
                              url: RouterConfig.DEVICE_BIND_TIP_URL, // 进行配置网络页面
                              params: {
                                tips: 1 // 成功的提示
                              }
                            })
                          })
                        } catch (error) {
                          router.pushUrl({
                            url: RouterConfig.DEVICE_BIND_TIP_URL, // 进行配置网络页面
                            params: {
                              tips: 2 // 失败的提示
                            }
                          })
                        } finally {
                          this.loading.close()
                        }
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .padding({
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8
                  })
                  .borderRadius(ResManager.EC_NORMAL_RD)
                  .backgroundColor('#fff')
                }
              })
          }
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
        .width('100%')
        .padding({ left: 15, right: 15 })
        .height('100%')
        .backgroundColor(this.hasDevice ? ResManager.EC_MID_BG : '#fff')
      }

    }
    .title('附近设备')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}