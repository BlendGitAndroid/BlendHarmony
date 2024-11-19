import { audio } from "@kit.AudioKit"
import { Logger } from "./Logger"

export class AudioCapturerManager {
  // 实例对象
  capturer: audio.AudioCapturer | null = null // 录音对象
  async createCapturer() {
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率 // 语音转化只能转化16000的采样率
      channels: audio.AudioChannel.CHANNEL_1, // 通道
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
    };

    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0
    };

    let audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    };
    this.capturer = await audio.createAudioCapturer(audioCapturerOptions)
  }

  // 开始录音的方法
  async start(callback: (bf: ArrayBuffer) => void) {
    if (!this.capturer) {
      await this.createCapturer() // 创建录音对象 保证先有录音对象才可以录音
    }
    // 先监听 再开始录音把
    this.capturer?.on("readData", (bf) => {
      // bf 一段段的语音转化二进制对象的具体参数
      // Logger.info(bf.byteLength.toString())
      callback(bf)
    })
    this.capturer?.start() // 开启录音

  }

  // 停止录音的方法
  async stop() {
    if (this.capturer) {
      await this.capturer.stop() // 停止录音
      await this.capturer.release() // 释放资源
      this.capturer = null // 释放内存对象 垃圾回收 gc
      // 正常的局部变量
    }

  }
}

export const audioCapturerManager = new AudioCapturerManager()
