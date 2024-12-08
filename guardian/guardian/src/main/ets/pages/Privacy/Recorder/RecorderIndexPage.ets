import { ValuesBucket } from '@kit.ArkData'
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'
import { EmptyTipsComp } from '../../../common/components'
import { CustomInputDialog } from '../../../common/dialog'
import { audioCapturerManager } from '../../../manager'
import { fileIo } from '@kit.CoreFileKit'
import { privacyRecorderDB, PrivacyRecorderDBInfo } from '../../../database'

// 用于把毫秒格式化成 mm:ss 的相对时间插件
dayjs.extend(duration)

@Entry
@Component
struct RecorderIndexPage {
  @State list: PrivacyRecorderDBInfo[] = []
  @State tempInputText: string = ''
  @State onConfirmEnable: boolean = true
  @State activeItem: PrivacyRecorderDBInfo | null = null
  // 是否正在录音
  @State isRecording: boolean = false
  @State isPlaying: boolean = false
  // 录音采集时的计时秒数
  @State recordingTime: number = 0
  @State playingTime: number = 0
  // 自定义弹窗层
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomInputDialog({
      title: '重命名音频',
      message: '支持下划线、数宇、英文字母与中文',
      inputText: this.tempInputText,
      onConfirm: async () => {
        // TODO：重命名录音
      },
    }),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Center,
  })
  private playingTimerId: number = -1
  private recordingTimerId: number = -1

  aboutToAppear() {
    audioCapturerManager.requestPermissions()
    // 创建新的目录(文件夹)，用于存放隐私录音
    this.initDir()
    // 页面加载时获取录音列表
    this.getList()
  }

  // 获取录音列表
  async getList() {
    this.list = await privacyRecorderDB.query()
  }

  // 创建新的目录(文件夹)，用于存放隐私录音
  initDir() {
    // 拼接路径
    const context = getContext()
    const dirPath = context.filesDir + '/' + 'privacy_recorder'
    // fileIo.accessSync()     检测文件或目录是否已存在
    if (fileIo.accessSync(dirPath) === false) {
      // fileIo.mkdirSync()    创建目录(文件夹)
      fileIo.mkdirSync(dirPath)
    }
  }

  // 开始录音
  startRecorder() {
    // 开始计时效果
    this.startCounter()
    // 显示正在录音结构
    this.isRecording = true
    // 准备文件路径
    const context = getContext()
    // 把隐私录音写入到指定目录(文件夹)中
    const filePath = context.filesDir + '/' + 'privacy_recorder' + '/' + Date.now() + '.wav'
    // 开启声音采集，写入到指定的文件路径中
    audioCapturerManager.startRecorder(filePath)
  }

  // 停止录音
  async stopRecorder() {
    // 停止计时效果
    this.stopCounter()
    // 隐藏正在录音结构
    this.isRecording = false
    // 停止声音采集
    const audioInfo = await audioCapturerManager.stopRecorder()
    // 把采集的录音信息写入到数据库中
    await privacyRecorderDB.insert({
      id: null, // 新增时自动生成
      filePath: audioInfo.filePath, // 录音文件路径
      title: dayjs(audioInfo.date_added)
        .format('录音 YYYY-MM-DD HH:mm:ss'), // 录音标题
      date_added: audioInfo.date_added, // 录音创建时间
      duration: audioInfo.duration // 录音持续时长
    })
    // 新增成功后，也要获取列表，注意 await 等待 insert 新增成功后，再查询列表
    this.getList()
  }

  // 开启计时效果
  startCounter() {
    // 初始化秒数
    this.recordingTime = 0
    // 清除以前的定时器，确保只启用一个
    clearInterval(this.recordingTimerId)
    // 开启定时器
    this.recordingTimerId = setInterval(() => {
      // 秒数累加
      this.recordingTime++
    }, 1000)
  }

  // 结束计时效果
  stopCounter() {
    clearInterval(this.recordingTimerId)
  }

  // 播放音频
  playAudio(item: PrivacyRecorderDBInfo) {
    // 保存 activeItem，用于视图更新
    this.activeItem = item
    // 更新播放状态，判断是否正在播放中
    if (this.isPlaying === false) {
      // 更新播放状态
      this.isPlaying = true
      // 开始渲染录音
      audioCapturerManager.startRenderer(item.filePath)
      // 开始播放进度条
      this.startPlayingCount(item.duration)
    } else {
      // 更新播放状态
      this.isPlaying = false
      // 停止渲染录音
      audioCapturerManager.stopRenderer()
      // 停止播放进度条
      this.stopPlayingCount()
    }
  }

  // 播放时间计时开始
  startPlayingCount(duration: number) {
    this.isPlaying = true
    // 定义变量来保存当前的时间
    this.playingTime = 0
    // 定义更新间隔，单位为毫秒
    const interval = 200;
    clearInterval(this.playingTimerId)
    this.playingTimerId = setInterval(() => {
      // 获取当前时间
      this.playingTime += interval
      if (this.playingTime > duration) {
        this.stopPlayingCount()
      }
    }, interval)
  }

  // 播放时间计时停止
  stopPlayingCount() {
    // 更新播放状态
    this.isPlaying = false
    // 停止计时器
    clearInterval(this.playingTimerId)
  }

  @Builder
  NavigationMenus() {
    Row() {
      Text('编辑')
        .fontSize(16)
        .fontColor($r('app.color.font'))
        .onClick(() => {

        })
    }
    .height('100%')
    .padding({ right: 25 })
  }

  @Builder
  ListItemSwipeActionEnd() {
    Row() {
      Button("重命名")
        .type(ButtonType.Normal)
        .height('100%')
        .aspectRatio(1)
        .backgroundColor('#CECFCF')
        .onClick(() => {
          // TODO：录音重命名
        })
      Button("删除")
        .type(ButtonType.Normal)
        .height('100%')
        .aspectRatio(1)
        .backgroundColor('#FF5E5D')
        .onClick(() => {
          // TODO：删除录音
        })
    }
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          if (this.list.length) {
            List() {
              ListItemGroup() {
                ForEach(this.list, (item: PrivacyRecorderDBInfo) => {
                  ListItem() {
                    Row({ space: 20 }) {
                      Column({ space: 10 }) {
                        Text(item.title)
                          .fontSize(16)
                          .fontColor($r('app.color.font2'))
                        // 录音进度条
                        if (this.activeItem?.id === item.id && this.isPlaying) {
                          Row({ space: 5 }) {
                            Text(dayjs(this.playingTime)
                              .format('mm:ss'))
                              .fontSize(12)
                              .fontColor($r('app.color.font_sub'))
                            Progress({
                              value: this.playingTime, // 播放时间(单位:毫秒)
                              total: item.duration, // 总持续时间(单位:毫秒)
                            })
                          }
                          .padding({ right: 20 })
                        } else {
                          Text(dayjs(item.date_added)
                            .format('YYYY年MM月DD日 HH:mm:ss'))
                            .fontSize(12)
                            .fontColor($r('app.color.font_sub'))
                        }
                      }
                      .alignItems(HorizontalAlign.Start)
                      .layoutWeight(1)

                      Column() {
                        Image(
                          this.activeItem?.id === item.id && this.isPlaying ?
                          $r('sys.media.ohos_ic_public_pause') :
                          $r("app.media.ic_public_play")
                        )
                          .width(22)
                          .aspectRatio(1)
                          .fillColor('#A6B6C4')
                        Text(dayjs.duration(item.duration)
                          .format('mm:ss'))
                          .fontSize(12)
                          .fontColor('#A6B6C4')
                          .lineHeight(25)
                      }
                      .justifyContent(FlexAlign.Center)
                      .height('100%')
                      .onClick(() => {
                        // TODO：播放音频
                        this.playAudio(item)
                      })
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                    .padding({ left: 15, right: 15 })
                  }
                  .height(72)
                  .transition({ type: TransitionType.Delete, opacity: 0 })
                  .swipeAction({
                    end: {
                      builder: this.ListItemSwipeActionEnd(),
                      onStateChange: (state) => {
                        if (state === SwipeActionState.EXPANDED) {
                          // 保存当前滑动的数据
                          this.activeItem = item
                        }
                      }
                    },
                    edgeEffect: SwipeEdgeEffect.None,
                  })
                })
              }
              .padding({ bottom: 126 })
              .divider({
                strokeWidth: 1,
                color: $r('app.color.border'),
                startMargin: 15,
                endMargin: 15
              })
            }
            // 每行之间的分界线
            .width('100%')
            .height('100%')
          } else {
            EmptyTipsComp({ title: '您还没有任何隐私录音\n点击下面的按钮开始创建' })
          }
        }
        .height('100%')

        // 录音按钮
        Column() {
          Image($r('app.media.ic_circle_recorder'))
            .width(56)
            .aspectRatio(1)
            .onClick(() => {
              // TODO：开始录音
              this.startRecorder()
            })
        }
        .width('100%')
        .height(126)
        .justifyContent(FlexAlign.Center)
        .padding({ left: 15, right: 15 })

        // 停止录音
        Column({ space: 15 }) {
          Row({ space: 12 }) {
            Row() {
              ForEach(Array.from({ length: 12 }), () => {
                Column()
                  .width(5)
                  .height(16)
                  .backgroundColor('#80ffffff')
                  .borderRadius(5 / 2)
              })
            }
            .width(110)
            .justifyContent(FlexAlign.SpaceBetween)

            // 图标
            Image($r('app.media.ic_recorder_fill'))
              .height('100%')

            Row() {
              ForEach(Array.from({ length: 12 }), () => {
                Column()
                  .width(5)
                  .height(16)
                  .backgroundColor('#80ffffff')
                  .borderRadius(5 / 2)
              })
            }
            .width(110)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .height(58)
          .margin({ top: 40 })

          Text(
            dayjs(this.recordingTime * 1000)
              .format(this.recordingTime > 1000 * 60 * 60 ? 'HH:mm:ss' : 'mm:ss')
          )
            .fontSize(18)
            .lineHeight(25)
            .fontWeight(700)
            .fontColor($r('app.color.white'))

          Row() {
            Button('停止录音')
              .type(ButtonType.Normal)
              .width('100%')
              .backgroundColor($r('app.color.brand'))
              .border({ width: 1, color: $r('app.color.white') })
              .borderRadius(10)
              .onClick(() => {
                // TODO：停止录音
                this.stopRecorder()
              })
          }
          .padding({ left: 15, right: 15 })
        }
        .width('101%')
        .height(222)
        .backgroundImage($r("app.media.RecorderAddPage_bg_bottom"))
        .backgroundImageSize(ImageSize.Cover)
        .visibility(this.isRecording ? Visibility.Visible : Visibility.None)
      }
      .height('100%')
    }
    .title('录音')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .menus(this.NavigationMenus)
    .linearGradient({
      angle: 180,
      colors: this.isRecording ? [[$r('app.color.white'), 0.95], [$r('app.color.brand'), 0.95]] :
        [[$r('app.color.white'), 0], [$r('app.color.white'), 1]]
    })
  }
}