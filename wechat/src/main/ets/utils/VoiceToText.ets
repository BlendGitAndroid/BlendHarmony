import { speechRecognizer } from '@kit.CoreSpeechKit'
import { util } from '@kit.ArkTS'
import { fileIo } from '@kit.CoreFileKit'

export class VoiceToText {
  //  引擎：语音转文字
  static v2tEngine: speechRecognizer.SpeechRecognitionEngine
  // 引擎创建参数
  static textInitParams: speechRecognizer.CreateEngineParams = {
    // 识别为什么语音
    language: 'zh-CN',
    online: 1,
    extraParams: {
      "locate": "CN",
      "recognizerMode": "short"
    }
  }

  // 开始转化
  static async start(path: string, callback: (result: speechRecognizer.SpeechRecognitionResult) => void) {
    console.log('wechat', 'VoiceToText StartFn')
    // 需不需要创建
    if (!VoiceToText.v2tEngine) {
      console.log('wechat', 'No VoiceToText v2tEngine')
      VoiceToText.v2tEngine = await speechRecognizer.createEngine(VoiceToText.textInitParams)
    }
    // 有没有正在转换：有，肯定不是正在说话
    if (VoiceToText.v2tEngine.isBusy()) {
      console.log('wechat', 'VoiceToText v2tEngine isBusy')
      return
    }
    //  开始转化
    console.log('wechat', 'VoiceToText v2tEngine Start')
    const listener: speechRecognizer.RecognitionListener = {
      onStart() {
      },
      onEvent() {
      },
      // 拿到结果
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        //     输入结果
        callback(result)
        if (result.isLast) {
          console.log('wechat', 'VoiceToText v2tEngine isLast')
          //     关闭
          VoiceToText.v2tEngine.finish(sessionId)
        }

        console.log('wechat', 'VoiceToText v2tEngine result:' + result.result)
      },
      onComplete() {
      },
      onError() {
      }
    }
    // 设置了监听转化
    VoiceToText.v2tEngine.setListener(listener)
    // 启动转化
    const startParams: speechRecognizer.StartParams = {
      sessionId: util.generateRandomUUID(),
      audioInfo: {
        audioType: 'pcm',
        sampleRate: 16000,
        soundChannel: 1,
        sampleBit: 16
      },
      extraParams: {
        "vadBegin": 2000,
        "vadEnd": 3000,
        "maxAudioDuration": 60000
      }
    }
    VoiceToText.v2tEngine.startListening(startParams)
    //  文件写入引擎的缓冲区才能进行转化
    VoiceToText.writeAudio(path, startParams.sessionId)
  }

  // 写入缓冲区
  static async writeAudio(path: string, sessionId: string) {
    const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE)
    //   自定义缓冲区的大小
    const buf: ArrayBuffer = new ArrayBuffer(1280)
    //    已经转化的大小
    let totalSize: number = 0
    //   文件的大小(不对！因为语音输入的时候，文件大小也在发生变化！！！)
    // let maxSize: number = 0
    while (totalSize < fileIo.statSync(file.fd).size) {
      //转化
      fileIo.readSync(file.fd, buf, {
        offset: totalSize,
        length: 1280
      })
      //   真正的可以转化的数据
      let uint8Array: Uint8Array = new Uint8Array(buf)
      //   写入引擎的缓冲区
      VoiceToText.v2tEngine.writeAudio(sessionId, uint8Array)

      // -----必须要等待-----
      await new Promise<boolean>((resolve) => {
        setTimeout(() => {
          return resolve(true)
        }, 30)
      })
      // -----必须要等待-----


      totalSize += 1280
    }
    console.log('wechat', 'VoiceToText finish')
    //   1.文件关闭
    fileIo.closeSync(file)
    //   2.引擎关闭
    VoiceToText.v2tEngine.finish(sessionId)
  }

  // 强制停止转化引擎
}