import { VoiceState } from '../../models/voice'
import { emitter } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

@Component
struct VoiceInput {
  @Consume
  voiceState: VoiceState
  @Consume
  v2tResult: string

  @Builder
  getVoiceContent() {
    if (this.voiceState === VoiceState.Cancel) {
      Row() {

      }
      .height(80)
      .width(100)
      .borderRadius(20)
      .backgroundColor($r('app.color.danger'))
      .margin({
        left: 30
      })
    } else if (this.voiceState === VoiceState.Recording) {
      Row({ space: 2 }) {
        //   语音波峰
        ForEach(this.list, (item: number) => {
          Row() {

          }.height(item)
          .width(2)
          .borderRadius(1)
          .backgroundColor($r('app.color.animate_voice_color'))
        })
      }
      .height(80)
      .width(180)
      .borderRadius(20)
      .backgroundColor($r('app.color.chat_primary'))
      .justifyContent(FlexAlign.Center)
    } else if (this.voiceState === VoiceState.Transfer) {
      Row() {
        Text(this.v2tResult)
          .fontSize(20)
          .fontColor($r('app.color.text_primary'))
      }
      .height(120)
      .width(280)
      .borderRadius(20)
      .backgroundColor($r('app.color.chat_primary'))
      .alignItems(VerticalAlign.Top)
    }
  }

  // 1.收集数据
  // 转化
  calcAudioHeight(bufferData: ArrayBuffer) {
    console.log('wechat', JSON.stringify(bufferData))
    try {
      const newBuffer = new Int16Array(bufferData)
      const sampleSize = Math.floor((newBuffer.length / 20))
      const arr: number[] = []
      for (let i = 0; i < newBuffer.length; i += sampleSize) {
        //  循环每一块振幅的每一个振幅
        let sum = 0
        for (let j = i; j < i + sampleSize; j++) {
          sum += Math.abs(newBuffer[j])
        }
        // sum是所有振幅单元的和 -》 转换成可视化的数据
        //   0.6
        //   sum是每个振幅的振值总和
        //   sampleSize 是每一个振幅的数量
        // -32768 ~ +32768 =  65536 = 16*16  * 16*16
        const h = 120 * sum / sampleSize / 32767
        arr.push(h < 10 ? 10 : h)
      }
      // this.list
      this.list = arr
    } catch (e) {
      promptAction.showToast({
        message: '计算异常'
      })
    }
  }

  // 2.展示的数据
  @State
  list: number[] = []

  aboutToAppear(): void {
    emitter.on('calcVoice', (data) => {
      this.calcAudioHeight(data.data!.buffer as ArrayBuffer)
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        this.getVoiceContent()
      }.height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(this.voiceState === VoiceState.Cancel ? HorizontalAlign.Start : HorizontalAlign.Center)

      Column() {

        // 显示关闭和文本
        Row() {
          Row() {
            Image($r("app.media.ic_public_cancel"))
              .width(30)
              .height(30)
              .fillColor(this.voiceState === VoiceState.Cancel ? $r('app.color.text_primary') :
              $r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.voiceState === VoiceState.Cancel ? $r('app.color.bottom_color') :
          $r("app.color.voice_round_color"))
          .rotate({
            angle: -10
          })
          .scale({
            x: this.voiceState === VoiceState.Cancel ? 1.2 : 1,
            y: this.voiceState === VoiceState.Cancel ? 1.2 : 1
          })

          Row() {
            Text("文")
              .fontSize(24)
              .textAlign(TextAlign.Center)
              .fontColor(this.voiceState === VoiceState.Transfer ? $r('app.color.text_primary') :
              $r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.voiceState === VoiceState.Transfer ? $r('app.color.bottom_color') :
          $r("app.color.voice_round_color"))
          .rotate({
            angle: 10
          })
          .scale({
            x: this.voiceState === VoiceState.Transfer ? 1.2 : 1,
            y: this.voiceState === VoiceState.Transfer ? 1.2 : 1
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 40,
          right: 40
        })
        .margin({
          bottom: 30
        })

        Stack() {
          Image($r("app.media.ic_public_output"))
            .width('100%')
            .height(120)
            .fillColor(this.voiceState === VoiceState.Recording ? $r('app.color.bottom_color') :
            $r("app.color.voice_round_color"))
            .scale({
              x: this.voiceState === VoiceState.Recording ? 1.2 : 1
            })
          Image($r("app.media.ic_public_recorder"))
            .width(30)
            .height(30)
            .fillColor(this.voiceState === VoiceState.Recording ? $r('app.color.bottom_voice_color') :
            $r("app.color.bottom_color"))
        }
        .width('100%')
      }
    }
    .height('100%')
    .backgroundColor($r("app.color.voice_back_color"))

  }
}

export default VoiceInput