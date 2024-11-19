import { audio } from '@kit.AudioKit';
import { speechRecognizer } from '@kit.CoreSpeechKit';
import { KeyboardAvoidMode, promptAction } from '@kit.ArkUI'
import { accessManager, audioCapturerManager, speechToTextMananger } from '@shop/basic';
import { vibrator } from '@kit.SensorServiceKit';

export enum VoiceState {
  DEFAULT,
  VOICING,
  VOICEOVER
}

@Preview
@Component
export struct HDMAudioSearch {
  @State voiceState: VoiceState = VoiceState.DEFAULT
  @State
  scaleValue: number = 1
  @State
  keyword: string = ''
  audioCapturer: audio.AudioCapturer | null = null
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null
  onChange: (keyword: string) => void = () => {
  }
  onComplete: (keyword: string) => void = () => {
  }

  async startRecord() {
    accessManager.checkPermission(["ohos.permission.MICROPHONE"], () => {
      // 按住语音的时候 加一个马达震动
      vibrator.startVibration({
        type: 'time',
        duration: 200,
      }, {
        id: 0,
        usage: 'media'
      })
      animateTo({ duration: 500 }, () => {
        this.scaleValue = 1.5
      })
      this.voiceState = VoiceState.VOICING
      // 开始录音
      speechToTextMananger.init((text) => {
        this.keyword = text // 拿到识别文本 显示到页面上
      }) // 先初始化
      audioCapturerManager.start((bf) => {

        // 拿到语音转化 => 语音识别
        speechToTextMananger.start(bf) // 传入音频buffer得到转化文字
      })
    })
  }

  async closeRecord() {
    vibrator.stopVibration(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME)
    animateTo({ duration: 500 }, () => {
      this.scaleValue = 1
    })
    audioCapturerManager.stop()
    speechToTextMananger.stop()
    this.voiceState = VoiceState.DEFAULT
  }

  aboutToAppear(): void {
    this.getUIContext()
      .setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }

  build() {
    Column() {
      if (this.voiceState !== VoiceState.DEFAULT) {
        Column({ space: 16 }) {
          if (this.voiceState === VoiceState.VOICING) {
            Text('请说，我在聆听...')
              .fontSize(14)
          } else if (this.voiceState === VoiceState.VOICEOVER && this.keyword === '') {
            Text('未检测到语音，请长按按钮重试')
              .fontSize(14)
          }
          Text() {
            Span('你可以这样说：')
            Span('太阳眼镜/冬款连衣裙')
              .fontColor($r('[shop_basic].color.gray'))
          }
          .fontSize(12)
        }
        .justifyContent(FlexAlign.Center)
        .height(150)

        // 显示文本内容
        Row() {
          Text(this.keyword)
            .fontSize(14)
        }
        .padding(20)
        .width("100%")
        .justifyContent(FlexAlign.Center)
      }

      Blank()
      Button() {
        Row({ space: 4 }) {
          Image($r('sys.media.ohos_ic_public_voice'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('[shop_basic].color.white'))
          if (this.voiceState === VoiceState.VOICING) {
            Text('松开立即搜索')
              .fontSize(14)
              .fontColor($r('[shop_basic].color.white'))
          } else {
            Text('长按语音搜索')
              .fontSize(14)
              .fontColor($r('[shop_basic].color.white'))
          }
        }
      }
      .padding({ left: 12, right: 12 })
      .height(36)
      .scale({
        x: this.scaleValue,
        y: this.scaleValue
      })
      .linearGradient({
        angle: 135,
        colors: [[$r('[shop_basic].color.linear_begin'), 0], [$r('[shop_basic].color.linear_end'), 1]]
      })
      .margin({ bottom: 16 })
      .gesture(
        LongPressGesture()
          .onAction(() => {
            this.startRecord()
          })
          .onActionEnd(async () => {
            await this.closeRecord()
            // 松开手 得到的文本传出去进行查询
            // 正则替换
            this.onComplete(this.keyword.replace(/[?!,。]/g, ""))
          })
          .onActionCancel(() => {
            this.closeRecord()
          }))

    }
    .layoutWeight(1)
    .width('100%')
    .backgroundImage($r('app.media.search_bg'))
    .backgroundImageSize(ImageSize.Contain)
    .backgroundImagePosition(Alignment.Bottom)
    .onVisibleAreaChange([0, 1], () => {
      this.keyword = ''
      this.voiceState = VoiceState.DEFAULT
    })
  }
}