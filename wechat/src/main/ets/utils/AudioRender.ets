import { audio } from '@kit.AudioKit'
import { fileIo } from '@kit.CoreFileKit'

export class AudioRender {
  // (配置)
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW

  }
  static audioRenderInfo: audio.AudioRendererInfo = {
    rendererFlags: 0,
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION
  }
  // 播放器
  static audioRender: audio.AudioRenderer
  // 播放的文件
  static renderFile: fileIo.File
  // 已读取(播放)的文件大小
  static renderSize: number = 0
  // 文件(待播放)的大小
  static maxSize: number = 0
  // 记录播放完成后的方法
  static callback: () => void

  // 创建播放器(配置)
  static async init() {
    // 1.创建播放器
    AudioRender.audioRender = await audio.createAudioRenderer({
      streamInfo: AudioRender.audioStreamInfo,
      rendererInfo: AudioRender.audioRenderInfo
    })
    // 2.注册播放的事件监听
    AudioRender.audioRender.on('writeData', (buffer: ArrayBuffer) => {
      if (AudioRender.renderFile) {
        //     存在要播放的文件
        fileIo.readSync(AudioRender.renderFile.fd, buffer, {
          offset: AudioRender.renderSize,
          length: buffer.byteLength
        })
        AudioRender.renderSize += buffer.byteLength
      }
      //   播放完了没？
      if (AudioRender.renderSize >= AudioRender.maxSize) {
        //   播放完了
        fileIo.closeSync(AudioRender.renderFile)
        //   停止播放器
        AudioRender.stop()
        //   停止动画(调用回调函数)
        // if(AudioRender.callback)AudioRender.callback()
        AudioRender.callback && AudioRender.callback()
      }
    })
  }

  //播放
  static async start(filePath: string, callBack: () => void) {
    //   为了代码的健壮性
    if (AudioRender.audioRender && filePath) {
      // 停止之前还没播放完成
      AudioRender.audioRender.stop()
      // 设置要播放的文件
      AudioRender.renderFile = await fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
      AudioRender.maxSize = fileIo.statSync(AudioRender.renderFile.fd).size
      // 开启播放 -> 触发writeData
      AudioRender.audioRender.start()
      // 设置callback
      AudioRender.callback = callBack
    }
  }

  //   停止播放
  static stop() {
    AudioRender.audioRender.stop()
    AudioRender.renderSize = 0
    AudioRender.maxSize = 0
  }

  // 释放播放器
  static async release() {
    if (AudioRender.audioRender) {
      // 自己写会碰见很多场景的bug
      // 1.播放到一半退出页面
      // 2.应用后台小化
      AudioRender.stop()
      await AudioRender.audioRender.release()
    }
  }
}