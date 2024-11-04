import VoiceInput from './VoiceInput'
import { display, promptAction } from '@kit.ArkUI'
import { VoiceState } from '../../models/voice'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'
import { AudioCapturer } from '../../utils/AudioCapturer'
import { FileOperate } from '../../utils/FileOperate'
import { currentUser, UserInfo } from '../../models/user'
import { PopupItem } from '../../models/popup'
import { fileIo, picker } from '@kit.CoreFileKit'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { camera, cameraPicker } from '@kit.CameraKit'
import Location from './Location'
import { VoiceToText } from '../../utils/VoiceToText'

@Preview
@Component
struct BottomInput {
  @State
  showVoice: boolean = false
  @State
  bottomList: PopupItem[] = [
    {
      icon: $r('app.media.ic_public_photo'),
      title: '照片',
      itemClick: () => {
        //     发送相片方法
        this.sendPhotos()
      }
    },
    {
      icon: $r('app.media.ic_public_carema'),
      title: '拍摄',
      itemClick: () => {
        //     唤起相机方法
        this.openCamera()
      }
    }, {
    icon: $r('app.media.ic_statusbar_gps'),
    title: '位置',
    itemClick: () => {
      //   打开地图
      this.showMap = true
    }

  }, {
    icon: $r('app.media.ic_public_voice'),
    title: '语音输入',

  }, {
    icon: $r("app.media.ic_public_collect"),
    title: '收藏',

  }, {
    icon: $r("app.media.ic_public_contacts_filled"),
    title: '个人名片',

  }, {
    icon: $r("app.media.ic_public_folder_filled"),
    title: '文件',

  }, {
    icon: $r("app.media.ic_public_music_filled"),
    title: '音乐',
  }
  ]
  @State
  showBottomCard: boolean = false // 显示底部
  // 接收父组件传递的发消息的方法
  sendTextMsg: (message: string) => void = () => {
  }
  // 发送语音消息
  sendAudioMsg: (filePath: string, duration: number) => void = () => {
  }
  // 发送图片消息
  sendImageMsg: (imgList: MessageInfoModel[]) => void = () => {
  }
  @State
  content: string = ''
  @State
  showVoiceCom: boolean = false
  talker: UserInfo = {} as UserInfo
  @Provide
  v2tResult: string = ''

  @Builder
  getVoiceComp() {
    //   坑点：builder里面不允许直接放置自定义组件
    Column() {
      VoiceInput()
    }
  }

  @Builder
  getBottomCard(item: PopupItem) {
    Column() {
      Column() {
        Image(item.icon)
          .width(30)
          .height(30)
          .fillColor("#4c4c4c")
      }
      .backgroundColor(Color.White)
      .width(56)
      .aspectRatio(1)
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(item.title)
        .fontSize(12)
        .fontColor($r('app.color.text_second'))
        .margin({
          top: 10
        })
    }.layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      item.itemClick && item.itemClick()
    })
  }

  @Provide
  voiceState: VoiceState = VoiceState.Recording
  @State
  screenWidth: number = 0
  @State
  screenHeight: number = 0
  // 某个人的记录
  audioFilePath: string = ''
  // 语音计时
  @State
  duration: number = 0
  // 定时器标识
  timer: number = -1

  async aboutToAppear() {
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width)
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height)
    // 录音器的创建
    console.log('wechat', 'AudioCapturer audioCapturer initStart')
    await AudioCapturer.init()
    console.log('wechat', 'AudioCapturer audioCapturer initFinish')

  }

  aboutToDisappear(): void {
    //录音器的释放
    AudioCapturer.release()
  }

  // 检测麦克风权限
  checkMicroPhonePermission() {
    const manager = abilityAccessCtrl.createAtManager()
    // 获取当前应用信息
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const status = manager.checkAccessTokenSync(bundleInfo.appInfo.accessTokenId, "ohos.permission.MICROPHONE")
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      //   没有授权
      // 跳转到系统设置，让用户自己打开权限
      (getContext() as common.UIAbilityContext).startAbility({
        bundleName: 'com.huawei.hmos.settings',
        abilityName: 'com.huawei.hmos.settings.MainAbility',
        uri: "application_info_entry",
        parameters: {
          pushParams: bundleInfo.name
        }
      })
    } else {
      //   已经授权
      //   1.展示弹层
      this.showVoiceCom = true
      //   2.开始录音
      this.collectVoice()
    }
  }

  // 收集声音：开始
  collectVoice() {
    // 1.创建音频文件
    this.audioFilePath = FileOperate.createAudioFile(this.talker.user_id)
    // 2.往音频文件写入内容
    AudioCapturer.start(this.audioFilePath)
    // 3.计时
    this.startTime()
  }

  // 开始计时
  startTime() {
    this.timer = setInterval(() => {
      this.duration++
    }, 1000)
  }

  // 结束计时
  endTime() {
    clearInterval(this.timer)
  }

  // 释放手指：结束
  releaseFinger() {
    //   隐藏语音输入弹层
    this.showVoiceCom = false
    // 停止录音
    AudioCapturer.stop()
    // 停止计时
    this.endTime()
    if (this.voiceState === VoiceState.Recording) {
      if (this.duration < 1) {
        return promptAction.showToast({
          message: '内容时间不足一秒！'
        })
      }
      //  正常录音
      this.sendAudioMsg(this.audioFilePath, this.duration)
      this.duration = 0
      this.audioFilePath = ''
    } else if (this.voiceState === VoiceState.Cancel) {
      //  取消语音消息(删除已经录制的语音)
      FileOperate.delFilePath(this.audioFilePath)
      this.audioFilePath = ''
      this.duration = 0
    } else if (this.voiceState === VoiceState.Transfer) {
      //  输入时：语音转文字  输出的是文字
      if (this.v2tResult) {
        this.sendTextMsg(this.v2tResult)
      }
      //  删除录制的语音
      FileOperate.delFilePath(this.audioFilePath)
      this.audioFilePath = ''
      this.duration = 0
      this.v2tResult = ''
    }
  }

  // 发送图片的方法
  async sendPhotos() {
    // 1.选择图片拿到结果
    const photo = new picker.PhotoViewPicker()
    const result = await photo.select({
      maxSelectNumber: 9,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (result.photoUris.length) {
      //   选择了图片！photoUris进行拷贝
      // promptAction.showDialog({
      //   message:JSON.stringify(result.photoUris) //图片的地址
      // })
      //   2.图片的拷贝
      const imgList: MessageInfoModel[] = []
      result.photoUris.forEach((item) => {
        // 通过文件的地址如何拿文件
        const file = fileIo.openSync(item, fileIo.OpenMode.READ_ONLY)
        //   拷贝： 和备份还是有区别
        // 文件的复制 fileIo.copyFileSync(复制哪个文件，赋值到哪里产生新文件)
        const newFile = getContext().filesDir + '/' + Date.now() + '.jpg' // file://filesDir/123214.jpg
        fileIo.copyFileSync(file.fd, newFile)
        //   每张图产生一条消息
        const newMessage = new MessageInfoModel({
          sendUser: currentUser,
          connectUser: this.talker,
          messageContent: '[图片]',
          messageType: MessageTypeEnum.IMAGE,
          sourceFilePath: newFile
        } as MessageInfo)
        imgList.push(newMessage)
        fileIo.closeSync(file.fd)
      })
      //   imgList就是所有的图片消息
      this.sendImageMsg(imgList)
    }
  }

  // 唤起相机
  async openCamera() {
    const profile: cameraPicker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
    }
    const result: cameraPicker.PickerResult = await cameraPicker.pick(getContext(),
      [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
      profile)
    // promptAction.showDialog({
    //   message: JSON.stringify(result)
    // })
    // result.resultUri
    if (result.mediaType === 'photo' && result.resultUri !== '') {
      //   拍照
      const newFile = getContext().filesDir + '/' + Date.now() + '.jpg'
      const file = fileIo.openSync(result.resultUri, fileIo.OpenMode.READ_ONLY)
      fileIo.copyFileSync(file.fd, newFile)
      const newMessage = new MessageInfoModel({
        sendUser: currentUser,
        connectUser: this.talker,
        messageContent: '[图片]',
        messageType: MessageTypeEnum.IMAGE,
        sourceFilePath: newFile
      } as MessageInfo)
      // 借用发图的方法
      this.sendImageMsg([newMessage])
    } else if (result.mediaType === 'video' && result.resultUri !== '') {
      //   拍视频
      const newFile = getContext().filesDir + '/' + Date.now() + '.mp4'
      const file = fileIo.openSync(result.resultUri, fileIo.OpenMode.READ_ONLY)
      fileIo.copyFileSync(file.fd, newFile)
      const newMessage = new MessageInfoModel({
        sendUser: currentUser,
        connectUser: this.talker,
        messageContent: '[视频]',
        messageType: MessageTypeEnum.VIDEO,
        sourceFilePath: newFile,
      } as MessageInfo)
      this.sendImageMsg([newMessage])
    }
  }

  // 地图
  @State
  showMap: boolean = false
  @Provide
  currentMessage: string = ''

  @Builder
  getMapContent() {
    Stack({ alignContent: Alignment.Top }) {
      Location()
      Row() {
        Text('返回')
          .onClick(() => {
            this.showMap = false
          })
        Text('发送')
          .onClick(() => {
            if (this.currentMessage) {
              this.sendTextMsg(this.currentMessage)
            }
            this.currentMessage = ''
            this.showMap = false
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(20)
      .margin({
        top: 40
      })
    }
    .width('100%')
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Image(this.showVoice ? $r('app.media.ic_public_keyboard') : $r('app.media.ic_public_sound'))
          .width(25)
          .height(25)
          .onClick(() => {
            this.showVoice = !this.showVoice
            if (this.showVoice) {
              this.showBottomCard = false
            }
          })

        if (this.showVoice) {
          Button('按住 说话')
            .type(ButtonType.Normal)
            .layoutWeight(1)
            .borderRadius(2)
            .fontColor($r('app.color.text_primary'))
            .backgroundColor(Color.White)
            .gesture(
              GestureGroup(
                GestureMode.Parallel,
                LongPressGesture()
                  .onAction(() => {
                    //   展示语音输入弹层
                    // this.showVoiceCom = true
                    //   检测麦克风权限？展示弹层：权限界面跳转
                    this.checkMicroPhonePermission()
                  })
                  .onActionEnd(() => {
                    this.releaseFinger()
                  }),
                PanGesture()
                  .onActionUpdate((event) => {
                    // 1.event.fingerList[0].globalY <= 语音输入区的高度  ->  recording
                    // 2.event.fingerList[0].globalY > 语音输入区的高度
                    // 2.1 event.fingerList[0].globalX <= 屏幕宽度的一半  ->  cancel
                    // 2.1 event.fingerList[0].globalX > 屏幕宽度的一半  ->  transfer
                    if (event.fingerList[0].globalY >= this.screenHeight - 120) {
                      //   录制状态
                      // promptAction.showToast({
                      //   message: 'recording'
                      // })
                      this.voiceState = VoiceState.Recording
                    } else {
                      if (event.fingerList[0].globalX <= this.screenWidth / 2) {
                        // promptAction.showToast({
                        //   message: 'cancel'
                        // })
                        this.voiceState = VoiceState.Cancel
                      } else {
                        // promptAction.showToast({
                        //   message: 'transfer'
                        // })
                        this.voiceState = VoiceState.Transfer
                        // this.v2tResult = ''
                        //   语音转文字
                        VoiceToText.start(this.audioFilePath, (res) => {
                          this.v2tResult = res.result
                        })
                      }
                    }
                  })
                  .onActionEnd(() => {
                    this.voiceState = VoiceState.Recording
                  })
              )
            )
        } else {
          TextInput({ text: $$this.content })
            .height(35)
            .layoutWeight(1)
            .borderRadius(2)
            .backgroundColor(Color.White)
            .focusable(true)
            .id('input')
            .onSubmit(() => {
              //1.发送消息
              this.sendTextMsg(this.content)
              //2.输入框清空
              this.content = ''
              //3.输入框聚焦
              focusControl.requestFocus('input')
            })
            .onClick(() => {
              this.showBottomCard = false
            })
        }

        Image($r('app.media.ic_public_add_norm'))
          .width(25)
          .height(25)
          .id('add')
          .onClick(() => {
            this.showBottomCard = !this.showBottomCard

            focusControl.requestFocus('add')
          })
      }
      .height(60)
      .width('100%')
      .padding({
        left: 10,
        right: 10
      })
      .bindContentCover($$this.showMap, this.getMapContent, {
        modalTransition: ModalTransition.NONE
      })

      // 底部菜单栏
      if (this.showBottomCard) {
        GridRow({ columns: 4 }) {
          ForEach(this.bottomList, (item: PopupItem) => {
            GridCol() {
              //   自定义的builder
              this.getBottomCard(item)
            }
            .height(100)
          })
        }
        .width('100%')
      }
    }
    .backgroundColor($r('app.color.second_back_color'))
    .bindContentCover($$this.showVoiceCom, this.getVoiceComp, {
      modalTransition: ModalTransition.NONE
    })
  }
}

export default BottomInput