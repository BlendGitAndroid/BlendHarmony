import { MessageInfoModel } from '../models/message'
import { StoreClass } from '../utils/StoreClass'
import { emitter } from '@kit.BasicServicesKit'
import { promptAction, router } from '@kit.ArkUI'
import { FileOperate } from '../utils/FileOperate'
import { PopupItem } from '../models/popup'
import { scanBarcode, scanCore } from '@kit.ScanKit'

@Component
struct WeChat {
  @State
  list: MessageInfoModel[] = []

  // 格式化时间 -> 基础版业务
  // 不是今年：2023-11-11
  // 今年：11-11
  // 这个月：12天前
  // 这1周：星期五
  // 当天：20:52
  // 这1小时内：50分钟前
  // 这1分钟内:刚刚
  transTime(time: number) {
    const dateObj = new Date(time)
    const year = dateObj.getFullYear()
    const month = dateObj.getMonth() //0-11
    const date = dateObj.getDate() //日   Day是获取周几的
    const hours = dateObj.getHours()
    const minutes = dateObj.getMinutes()
    // 是不是今年
    if (year === new Date().getFullYear()) {
      // 是不是这个月
      if (month === new Date().getMonth()) {
        // 是不是今天
        if (date === new Date().getDate()) {
          return hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0')
        } else {
          // 是这个月，不是今天
          return `${new Date().getDate() - date}天前`
        }
      } else {
        // 是今年，不是这个月
        return `${month + 1}月${date}日`
      }
    } else {
      // 不是今年
      return `${year}年${month + 1}月${date}日`
    }
  }

  aboutToAppear(): void {
    this.list = StoreClass.getAllChatLastMessage()
    //  订阅一下通知：
    //   立刻更新list
    emitter.on('addMessage', () => {
      this.list = StoreClass.getAllChatLastMessage()
    })
  }

  @Builder
  getListEnd(userId: string) {
    Row() {
      Text('删除')
        .fontColor($r('app.color.white'))
        .width(100)
        .textAlign(TextAlign.Center)
    }
    .height(70)
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor($r('app.color.danger'))
    .onClick(() => {
      // 1.UI列表
      // 通过发布订阅实现更新
      // 2.首选项
      StoreClass.removeChatAllMessage(userId)
      // 3.删除某个人的所有的文件
      FileOperate.delUserPath(userId)
    })
  }

  @State
  popList: PopupItem[] = [
    {
      title: '发起群聊',
      icon: $r('app.media.ic_public_message')
    },
    {
      title: '添加朋友',
      icon: $r('app.media.ic_public_add_friend')
    },
    {
      title: '扫一扫',
      icon: $r('app.media.ic_public_scan'),
      itemClick: () => {
        this.scan()
      }
    },
    {
      title: '收付款',
      icon: $r('app.media.ic_public_receive'),
      itemClick: () => {
        router.pushUrl({
          url: '@bundle:com.blend.harmony1/wechat/ets/pages/PayQrCode'
        })
      }
    }
  ]

  @State
  showPopup: boolean = false

  @Builder
  getDropDown() {
    Column() {
      ForEach(this.popList, (item: PopupItem) => {
        Row({ space: 6 }) {
          Image(item.icon)
            .width(20)
            .aspectRatio(1)
            .fillColor(Color.White)
          Text(item.title)
            .fontColor(Color.White)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .height(48)
        .justifyContent(FlexAlign.Center)
        .padding({
          left: 12,
          right: 12
        })
        .onClick(() => {
          // 点击对象的itemClick方法
          item.itemClick && item.itemClick()
          this.showPopup = false
        })
      })
    }
    .width(120)
  }

  // 扫码的方法
  async scan() {
    // 1.原生的扫码(API)
    // 定义扫码配置，打开扫码
    const option: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    }
    // 拉起扫码界面
    const result = await scanBarcode.startScanForResult(getContext(), option)

    promptAction.showToast({
      message: JSON.stringify(result)
    })
    // 生成对应的条形码|二维码
    // ```
    // 拓展思路：
    // 需求:扫码加好友
    // 1.把用户信息生成二维码
    // 2.唤起扫码界面通过识别条形码或者二维码拿到用户信息
    // 3.创建用户信息,追加到DefaultUserList
    // 以上的都属于单机版操作```
    //  2.自定义扫码：定制相机
  }

  build() {
    Column() {
      Row() {
        Text(`微信(${this.list.length})`)
          .fontColor($r('app.color.text_primary'))

        Image($r('app.media.ic_public_add_norm'))
          .width(20)
          .height(20)
          .fillColor($r('app.color.text_primary'))
          .position({
            // 绝对定位，确定子组件相对父组件的位置。
            x: '100%'
          })
          .translate({
            x: -40, // 向左偏移40
            y: -5 // 向上偏移5
          })
          .bindPopup($$this.showPopup, {
            // Popup弹窗
            builder: this.getDropDown(),
            backgroundBlurStyle: BlurStyle.NONE,
            popupColor: $r('app.color.popup_back'),
            onStateChange: (event) => {
              this.showPopup = event.isVisible
            },
            placement: Placement.Bottom // 设置popup组件相对于目标的显示位置，默认值为Placement.Bottom
          })
          .onClick(() => {
            this.showPopup = true
          })

      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .padding({
        top: 12,
        bottom: 12
      })

      List() {
        ForEach(this.list, (message: MessageInfoModel) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(message.connectUser.avatar)
                .width(50)
                .height(50)
                .borderRadius(4)

              Column({ space: 10 }) {
                Row() {
                  Text(message.connectUser.username)
                    .fontColor($r('app.color.text_primary'))
                    .fontSize(16)
                  Text(this.transTime(message.sendTime))
                    .fontSize(12)
                    .fontColor($r('app.color.text_second'))
                    .margin({
                      top: 10
                    })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')

                Text(message.messageContent)
                  .fontColor($r('app.color.text_second'))
                  .fontSize(14)
                  .maxLines(1)
                  .textOverflow({
                    overflow: TextOverflow.Ellipsis
                  })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(HorizontalAlign.Start)
              .height(50)
              .layoutWeight(1)
              .padding({
                top: 3,
                bottom: 3
              })
            }
            .stateStyles({
              normal: {
                .backgroundColor($r('app.color.white'))
              },
              pressed: {
                .backgroundColor($r('app.color.back_color'))
              }
            })
            // 预留个问题：为什么不在listItem上添加跳转
            // 因为有个删除的Builder
            .onClick(() => {
              router.pushUrl({
                url: '@bundle:com.blend.harmony1/wechat/ets/pages/ChatDetail/ChatDetail',
                params: message.connectUser
              })
            })
          }
          .swipeAction({
            end: () => {
              //   删除的builder
              this.getListEnd(message.connectUser.user_id)
            }
          })
          .padding({
            top: 10,
            bottom: 10
          })
        })
      }
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color')
      })
      .padding({
        left: 10,
        right: 20
      })
    }

    .height('100%')

  }
}

export default WeChat