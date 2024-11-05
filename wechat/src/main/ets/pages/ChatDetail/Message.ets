import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { PopupItem } from '../../models/popup'
import { currentUser } from '../../models/user'
import { StoreClass } from '../../utils/StoreClass'
import { AudioRender } from '../../utils/AudioRender'
import { FileOperate } from '../../utils/FileOperate'
import { VoiceToText } from '../../utils/VoiceToText'
import { TextToVoice } from '../../utils/TextToVoice'
import { promptAction } from '@kit.ArkUI'

@Component
struct Message {
  @State
  v2tInfo: string = ''

  message: MessageInfoModel = new MessageInfoModel({} as MessageInfo)

  // 定义delMessage方法
  delMessage: (messageId: string) => void = () => {
  }

  @State
  showPopup: boolean = false

  @State
  popupList: PopupItem[] = [
    {
      title: '朗读',
      icon: $r("app.media.ic_public_ears"),
      itemClick: () => {
        if (this.message.messageType === MessageTypeEnum.TEXT) {
          TextToVoice.start(this.message.messageContent)
        }
        this.showPopup = false
      }
    },
    {
      title: '收藏',
      icon: $r("app.media.ic_public_cube")
    },
    {
      title: '转文字',
      icon: $r("app.media.ic_public_trans_text"),
      itemClick: () => {
        if (this.message.messageType === MessageTypeEnum.AUDIO) {
          VoiceToText.start(this.message.sourceFilePath, (result) => {
            this.v2tInfo = result.result
          })
        }
        this.showPopup = false
      }
    },
    {
      title: '删除',
      icon: $r("app.media.ic_public_cancel"),
      itemClick: () => {
        promptAction.showDialog({
          title: '警告：',
          message: '确认删除吗？',
          buttons: [
            {
              text: '确定',
              color: '#ff114c14'
            },
            {
              text: '取消',
              color: '#ff1d678d'
            }
          ]
        }).then(data => {
          if (data.index == 0) {
            // 1.删除UI页面
            this.delMessage(this.message.id)
            // 2.首选项的删除
            StoreClass.removeChatMessage(this.message.connectUser.user_id, this.message.id)
            // 3.有没有消息文件
            if (this.message.sourceFilePath) {
              FileOperate.delFilePath(this.message.sourceFilePath)
            }
          }
        }).catch((err: Error) => {
          console.info('showDialog error: ' + err);
        })
      }
    },
    {
      title: '多选',
      icon: $r("app.media.ic_public_multi_select")
    },
    {
      title: '引用',
      icon: $r("app.media.ic_public_link")
    },
    {
      title: '提醒',
      icon: $r("app.media.ic_public_warin")
    }
  ]

  @State
  playState: AnimationStatus = AnimationStatus.Initial

  // popup结构
  @Builder
  getContent() {
    // 行：设置一行几列
    GridRow({ columns: 5 }) {
      // 列：根据一行几个进行排列位置
      ForEach(this.popupList, (item: PopupItem) => {
        GridCol() {
          Column({ space: 6 }) {
            Image(item.icon)
              .fillColor($r('app.color.white'))
              .width(18)
              .aspectRatio(1)
            Text(item.title)
              .fontSize(14)
              .fontColor($r('app.color.white'))
          }
          .height(60)
        }
        .onClick(() => {
          // 短路运算符，放置点击还没有绑定事件的元素
          item.itemClick && item.itemClick()
        })
      })
    }
    .padding({
      top: 15,
      left: 10
    })
  }

  // 文字消息结构
  @Builder
  getTextContent() {
    Text(this.message.messageContent)
      .backgroundColor(currentUser.user_id === this.message.sendUser.user_id ? $r('app.color.primary') :
      $r('app.color.white'))
      .fontColor($r('app.color.text_primary'))
      .padding(10)
      .lineHeight(24)
      .margin({
        left: 10,
        right: 10
      })
      .borderRadius(6)
  }

  // 语音消息结构
  @Builder
  getAudioContent() {
    Column() {
      Row({ space: 6 }) {
        Text(this.message.sourceDuration + "'")
          .textAlign(TextAlign.Center)
        if (this.playState === AnimationStatus.Running) {
          ImageAnimator()
            .images([
              { src: $r('app.media.ic_public_voice1') },
              { src: $r('app.media.ic_public_voice2') },
              { src: $r('app.media.ic_public_voice3') },
            ])
            .width(20)
            .height(20)
            .fillMode(FillMode.None)
            .duration(300)
            .iterations(-1)
            .state(this.playState)
            .rotate({
              angle: currentUser.user_id === this.message.sendUser.user_id ? 180 : 0
            })
        } else {
          Image($r('app.media.ic_public_recorder'))
            .width(20)
            .height(20)
            .rotate({
              angle: currentUser.user_id === this.message.sendUser.user_id ? 180 : 0
            })
        }

      }
      .width(this.getAudioWidth())
      .height(40)
      .padding({
        left: 10,
        right: 10
      })
      .margin({
        left: 10,
        right: 10
      })
      .backgroundColor(currentUser.user_id === this.message.sendUser.user_id ? $r('app.color.primary') :
      $r('app.color.white'))
      .justifyContent(currentUser.user_id === this.message.sendUser.user_id ? FlexAlign.End : FlexAlign.Start)
      .borderRadius(6)
      .onClick(() => {
        this.playState = AnimationStatus.Running
        AudioRender.start(this.message.sourceFilePath, () => {
          this.playState = AnimationStatus.Stopped
        })
      })

      if (this.v2tInfo) {
        Text(this.v2tInfo)
          .backgroundColor('#ccc')
          .fontColor($r('app.color.text_primary'))
          .padding(12)
          .borderRadius(4)
          .margin({
            left: 10,
            right: 10
          })
      }
    }.alignItems(HorizontalAlign.End)
  }

  // 全屏模态实现思路：接收预览图片的数据
  // @Consume
  // showImageInfo:boolean
  // @Consume
  // previewImageUrl:string
  // 图片消息结构
  @Builder
  getImageContent() {
    Column() {
      // 不允许操控原图
      Image('file://' + this.message.sourceFilePath)
        .width('100%')
        .borderRadius(4)
        .enabled(false)
    }.width('40%')
    .padding({
      left: 10,
      right: 10
    })
    .onClick(() => {
      // 全屏模态实现思路：
      this.previewImage()
    })
  }

  videoController: VideoController = new VideoController()

  @Builder
  getVideoContent() {
    // 视频预览：缩略图
    Stack() {
      Video({
        src: 'file://' + this.message.sourceFilePath,
        controller: this.videoController
      })
        .controls(false)
        .width(90)
        .height(160)
        .borderRadius(4)
        .onPrepared(() => {
          // 改版后无效了
          this.videoController.setCurrentTime(0.1)
        })
      Image($r('app.media.ic_public_play'))
        .width(30)
        .height(30)
        .fillColor($r('app.color.back_color'))
    }
    .margin({
      left: 12,
      right: 12
    })
    .onClick(() => {
      this.previewImage()
    })
  }

  // 预览图片/视频
  previewImage: () => void = () => {
  }

  // 计算语音消息的长短
  getAudioWidth() {
    const min = 20
    const max = 90
    const calcWidth = min + (100 * this.message.sourceDuration / 60)
    return (calcWidth > max ? max : calcWidth) + '%'
  }

  build() {
    Row() {
      Image(this.message.sendUser.avatar)
        .height(40)
        .aspectRatio(1)
        .borderRadius(6)
      Row() {
        if (this.message.messageType === MessageTypeEnum.TEXT) {
          // 文本消息
          this.getTextContent()
        } else if (this.message.messageType === MessageTypeEnum.AUDIO) {
          // 语音消息
          this.getAudioContent()
        } else if (this.message.messageType === MessageTypeEnum.IMAGE) {
          // 图片消息
          this.getImageContent()
        } else if (this.message.messageType === MessageTypeEnum.VIDEO) {
          //   视频消息
          this.getVideoContent()
        }

      }
      .layoutWeight(6)
      .justifyContent(currentUser.user_id === this.message.sendUser.user_id ? FlexAlign.End : FlexAlign.Start)
      .gesture(LongPressGesture()// 手势，长按弹出弹层
        .onAction(() => {
          // 显示Popup弹层
          this.showPopup = true
        }))
      .bindPopup($$this.showPopup, {
        builder: this.getContent, // 是一个Builder
        popupColor: $r('app.color.popup_back'),
        backgroundBlurStyle: BlurStyle.NONE, // 背景模糊方式，为当前组件提供一种在背景和内容之间的模糊能力
        onStateChange: (event) => {
          this.showPopup = event.isVisible
        }
      })


      Text()
        .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .direction(currentUser.user_id === this.message.sendUser.user_id ? Direction.Rtl : Direction.Ltr)
  }
}

export default Message