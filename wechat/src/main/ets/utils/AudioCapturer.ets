import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit'
import { promptAction } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'
import { JSON } from '@kit.ArkTS'

export class AudioCapturer {
  // 录音器
  static audioCapturer: audio.AudioCapturer
  // 是否录制中
  static isRecording: boolean = false
  // 创建的属性1：
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  }
  // 创建的属性2：
  static audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION,
    capturerFlags: 0
  }

  //   创建录音器(配置)
  static async init() {
    // try catch可以保证运行应用时，及时设备不支持，应用不会崩溃！
    console.log('wechat', 'AudioCapturer audioCapturer creatStart')
    try {
      // 每次初始化重新创建
      AudioCapturer.audioCapturer = await audio.createAudioCapturer({
        streamInfo: AudioCapturer.audioStreamInfo,
        capturerInfo: AudioCapturer.audioCapturerInfo
      })
      console.log('wechat', 'AudioCapturer audioCapturer creatFinish')
    } catch (err) {
      console.log("AudioCapturer", JSON.stringify(err))
      promptAction.showToast({
        message: '当前不支持录音功能！'
      })
    }
  }

  //   开启录音
  static async start(filePath: string) {
    if (!AudioCapturer.audioCapturer) {
      console.log('wechat', 'No AudioCapturer audioCapturer')
      return
    }
    console.log('wechat', 'AudioCapturer audioCapturer StartOpen')
    // 准备一个写入的文件
    let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE || fileIo.OpenMode.CREATE)
    let fd = file.fd
    // 文件的大小(这里只读取一次)
    let bufferSize: number = fileIo.statSync(fd).size
    // 开启录音
    AudioCapturer.isRecording = true
    await AudioCapturer.audioCapturer.start()
    // 如果没有等待开启，while没走进去
    // 录着没？
    while (AudioCapturer.isRecording) {
      // 录着呢，把麦克风缓冲区的内容写入文件中
      // 缓冲区读取的大小
      let size = AudioCapturer.audioCapturer.getBufferSizeSync()
      // 读取缓冲的内容
      let buffer = await AudioCapturer.audioCapturer.read(size, true)


      // 1.buffer发送给voiceInput
      // 2.将buffer可视化
      if (buffer) {

        //   写入文件
        fileIo.writeSync(fd, buffer, {
          // 已经写入的内容作为偏移量(不能覆盖写入，接着写)
          offset: bufferSize,
          length: buffer.byteLength
        })
        emitter.emit('calcVoice', {
          data: {
            buffer
          }
        })
        // 写入后文件的大小是会发生变化的！！！
        // 不改偏移量会覆盖
        bufferSize += buffer.byteLength
      }
    }
  }

  //   结束录音
  static stop() {
    if (AudioCapturer.audioCapturer) {
      AudioCapturer.audioCapturer.stop()
      AudioCapturer.isRecording = false
    }
  }

  //   释放录音器
  static release() {
    if (AudioCapturer.audioCapturer) {
      AudioCapturer.audioCapturer.release()
    }
  }
}