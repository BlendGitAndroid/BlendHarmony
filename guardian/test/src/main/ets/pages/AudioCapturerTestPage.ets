import { permissionManager } from '../manager/PermissionManager'
import { audio } from '@kit.AudioKit'
import { promptAction } from '@kit.ArkUI'
import { fileIo } from '@kit.CoreFileKit'

/**
 * 如何选择音频录制开发方式
 *   ArkTS/JS API
 *    1. AudioCapturer  PCM格式、适用于更专业、更多样化的媒体录制应用开发(如：音频通话)
 *    2. AVRecorder     生成m4a文件、支持音频编码（m4a、aac、mp3、ogg、wav、flac）
 *
 *   Native API（C/C++ 不考虑）
 */
@Entry
@Component
struct AudioCapturerTestPage {
  @State isGrant: boolean = false
  @State isCreate: boolean = false
  // 音频采集器
  audioCapturer?: audio.AudioCapturer
  // 音频渲染器
  audioRenderer?: audio.AudioRenderer
  // 音频采集器状态
  @State audioState: audio.AudioState = -1
  // 音频文件路径
  @State filePath: string = ''
  // 音频流信息
  audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  // 音频采集器信息
  audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC, // 声音来源
    capturerFlags: 0, // 0 代表普通音频采集器，1 代表低时延音频采集器 (ArkTS接口暂不支持低时延音频采集器)
  };
  // createAudioCapturer 创建音频采集器时的必传参数
  audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: this.audioStreamInfo, // 音频流信息
    capturerInfo: this.audioCapturerInfo, // 音频采集器信息
  };
  // 音频渲染器信息
  audioRendererInfo: audio.AudioRendererInfo = {
    // usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,  // 用听筒播放
    usage: audio.StreamUsage.STREAM_USAGE_MOVIE, // 用外放喇叭播放
    // usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 用外放喇叭播放
    // usage: audio.StreamUsage.STREAM_USAGE_GAME, // 用外放喇叭播放
    rendererFlags: 0
  };
  // 音频渲染器配置
  audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: this.audioStreamInfo, // 音频流信息
    rendererInfo: this.audioRendererInfo  // 音频渲染器信息
  };

  aboutToAppear() {
    this.requestPermissions()
  }

  async requestPermissions() {
    // 音频开发：需要申请麦克风权限
    this.isGrant = await permissionManager.requestPermissions(['ohos.permission.MICROPHONE'])
  }

  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Text('麦克风权限是否开启：' + this.isGrant)
          Text('音频采集器状态：' + this.audioState)
          Text('音频文件路径：' + this.filePath)
          Button('开始录音-创建音频采集器')
            .enabled(!this.isCreate)
            .onClick(async () => {
              try {
                // 1. 创建音频采集器
                const audioCapturer = await audio.createAudioCapturer(this.audioCapturerOptions);
                // 保存起来，方便其他地方使用
                this.audioCapturer = audioCapturer
                this.isCreate = true
                // ------ 文件系统 fileIo ------
                //   1) 创建并打开本地文件
                const context = getContext()
                //   2) 通过应用上下文，获取到应用的 files 路径
                this.filePath = context.filesDir + '/' + Date.now() + '.wav'
                //   3) 创建并打开文件，注意打开模式选择可读可写 READ_WRITE
                const file = fileIo.openSync(this.filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
                // ------ 文件系统 ------
                // 2. 订阅音频数据读入
                audioCapturer.on('readData', (buffer) => {
                  //  4) 把 buffer 写入到打开的文件中(file.fd为打开文件后标识)
                  fileIo.writeSync(file.fd, buffer)
                  console.log('读取采集器的音频流大小(单位B)', buffer.byteLength);
                })
                // // 2.x 订阅采集器状态
                audioCapturer.on('stateChange', (state) => {
                  this.audioState = state
                })
                // 3. 开始录制音频
                await audioCapturer.start()


                // 如果以上步骤出错，就不会运行到这里
                promptAction.showToast({ message: '音频采集器创建成功' })
              } catch (error) {
                promptAction.showToast({ message: 'createAudioCapturer error：' + JSON.stringify(error.message) })
              }
            })

          Button('停止采集')
            .enabled(this.isCreate)
            .onClick(async () => {
              // 采集器处于播放状态，才调用停止采集
              if (this.audioCapturer?.state === audio.AudioState.STATE_RUNNING) {
                // 停止采集
                await this.audioCapturer?.stop()
                promptAction.showToast({ message: '停止成功' })
              }
            })
          Button('继续采集')
            .enabled(this.isCreate)
            .onClick(async () => {
              // 开始(继续)采集
              await this.audioCapturer?.start()
              promptAction.showToast({ message: '继续开始' })
            })

          Button('释放资源')
            .enabled(this.isCreate)
            .onClick(async () => {
              // 释放资源(释放内存和硬件)
              await this.audioCapturer?.release()
              this.isCreate = false
              promptAction.showToast({ message: '释放资源' })
            })

          Divider()
            .strokeWidth(1)

          Button('创建音频渲染器-播放音频')
            .enabled(this.filePath !== '')
            .onClick(async () => {
              try {
                // 1. 创建音频渲染器
                const audioRenderer = await audio.createAudioRenderer(this.audioRendererOptions);
                // 保存起来
                this.audioRenderer = audioRenderer
                // 根据路径打开文件
                const file = fileIo.openSync(this.filePath)
                // 获取文件信息(大小，创建时间等)
                const fileStat = fileIo.statSync(file.fd)
                console.log('音频渲染器 buffer 当前文件大小为(单位B)', fileStat.size)
                // 准备一个累加值，用于自动停止渲染
                let bufferSize = 0
                // 2. 订阅(buffer写入数据到音频渲染器中，就能发出声音)
                audioRenderer.on('writeData', (buffer) => {
                  // 读取打开文件的 buffer，写入到渲染器中，就能发出声音
                  fileIo.readSync(file.fd, buffer)
                  // buffer 大小累加，用于自动停止
                  bufferSize += buffer.byteLength
                  // 累加的结果，是否已超过文件大小
                  if (bufferSize >= fileStat.size) {
                    // 自动停止渲染
                    audioRenderer.stop()
                  }
                  console.log('音频渲染器 buffer 累加结果(单位B)', bufferSize)
                })
                // 3. 开始渲染
                audioRenderer.start()

                promptAction.showToast({ message: '音频渲染器正常' })
              } catch (error) {
                promptAction.showToast({ message: '音频渲染器错误：' + JSON.stringify(error) })
              }
            })

          Button('停止渲染')
            .enabled(this.filePath !== '')
            .onClick(async () => {
              await this.audioRenderer?.stop()
              promptAction.showToast({ message: '停止成功' })
            })
          Button('销毁实例，释放资源')
            .enabled(this.filePath !== '')
            .onClick(async () => {
              await this.audioRenderer?.release()
              promptAction.showToast({ message: '销毁实例，释放资源成功' })
            })
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('音频录制开发')
    .titleMode(NavigationTitleMode.Mini)
  }
}