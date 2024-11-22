import { speechRecognizer } from '@kit.CoreSpeechKit'
import { Logger } from './Logger'
import { util } from '@kit.ArkTS'

export class SpeechToTextMananger {
  engine: speechRecognizer.SpeechRecognitionEngine | null = null
  sessionId: string = util.generateRandomUUID()
  textCallBack?: (text: string) => void

  // 创建语音识别引擎
  async createEngine() {
    // 创建引擎，通过callback形式返回
    // 设置创建引擎参数
    let extraParam: Record<string, Object> = { "locate": "CN", "recognizerMode": "short" };
    let initParamsInfo: speechRecognizer.CreateEngineParams = {
      language: 'zh-CN',
      online: 1,
      extraParams: extraParam
    };
    this.engine = await speechRecognizer.createEngine(initParamsInfo)
  }

  // 只初始化一次
  async init(callBack?: (text: string) => void) {
    this.textCallBack = callBack
    if (!this.engine) {
      await this.createEngine() // 创建引擎
    }
    // 此时引擎已经创建了
    // this.engine?.setListener({})
    this.setListener() // 设置监听项

    // 开启监听
    let recognizerParams: speechRecognizer.StartParams = {
      sessionId: this.sessionId,
      audioInfo: {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      } //audioInfo参数配置请参考AudioInfo
    }
    // 调用开始识别方法
    this.engine?.startListening(recognizerParams);

  }

  // 连续不断的输入
  start(bf: ArrayBuffer) {
    this.engine?.writeAudio(this.sessionId, new Uint8Array(bf))
  }

  stop() {
    this.engine?.finish(this.sessionId) // 先结束
    this.engine?.shutdown() // 释放资源
    this.engine = null // 真正的释放资源
  }

  setListener() {
    // let that = this // this给到一个变量
    // 创建回调对象
    let setListener: speechRecognizer.RecognitionListener = {
      // 开始识别成功回调
      onStart(sessionId: string, eventMessage: string) {
        console.info(`onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      // 事件回调
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
        console.info(`onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`);
      },
      // 识别结果回调，包括中间结果和最终结果
      onResult: (sessionId: string, result: speechRecognizer.SpeechRecognitionResult) => {
        Logger.info(result)
        if (this.textCallBack) {
          this.textCallBack(result.result)
        }
        // console.info(`onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`);
      },
      // 识别完成回调
      onComplete(sessionId: string, eventMessage: string) {
        console.info(`onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      // 错误回调，错误码通过本方法返回
      // 如：返回错误码1002200006，识别引擎正忙，引擎正在识别中
      // 更多错误码请参考错误码参考
      onError(sessionId: string, errorCode: number, errorMessage: string) {
        console.error(`onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`);
      }
    }
    // 设置回调
    this.engine?.setListener(setListener);
  }
}

export const speechToTextMananger = new SpeechToTextMananger()