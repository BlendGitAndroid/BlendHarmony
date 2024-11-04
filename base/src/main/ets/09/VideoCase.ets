@Entry({ routeName: "VideoCase" })
@Component
export struct VideoCase {
  @State
  speed: number = 1

  @State
  isMuted: boolean = false

  @State
  time: number = 0

  @State
  duration: number = 0

  @State
  isFullScreen: boolean = false

  // 控制器
  controller: VideoController = new VideoController()

  build() {
    Row() {
      Tabs() {
        TabContent() {

          Column() {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Video({
                src: 'https://video19.ifeng.com/video09/2024/05/23/p7199260608686989961-0-122707.mp4',
                previewUri: $r('app.media.b'), // 视频封面
                currentProgressRate: this.speed, // 视频速度
                controller: this.controller
              })
                .height(500)
                .objectFit(ImageFit.Contain)// 设置视频展示比例，最长的边展示满，但是会出现黑边
                .controls(this.isFullScreen)// 不展示控制条
                .autoPlay(false)//视频是否自动播放
                .loop(true)//视频是否循环播放
                .muted(this.isMuted)//视频是否静音
                .onPrepared((duration) => {
                  this.duration = duration.duration
                })
                .onUpdate((time) => {
                  this.time = time.time
                })
                .onFullscreenChange((screen) => {
                  this.isFullScreen = screen.fullscreen
                })

              Button('全屏')
                .onClick(() => {
                  this.controller.requestFullscreen(true)
                  this.isFullScreen = true
                })
            }

            Row() {
              Text('播放速度：')
              // 滑动
              Slider({
                value: $$this.speed,
                min: 0.75,
                max: 2,
                step: 0.25,
                style: SliderStyle.InSet
              })
                .layoutWeight(1)
            }

            Row({ space: 20 }) {
              Button('播放')
                .onClick(() => {
                  this.controller.start()
                })
              Button('暂停')
                .onClick(() => {
                  this.controller.pause()
                })
              Button('停止')
                .onClick(() => {
                  this.controller.stop()
                })
              Button('静音')
                .onClick(() => {
                  this.isMuted = !this.isMuted
                })
            }
          }
          .width('100%')
          .height('100%')
        }.tabBar("在线视频")

        TabContent() {
          Video({
            src: $rawfile('1.mp4')
          })
        }.tabBar("本地视频")
      }
    }
    .width('100%')
    .height('100%')
  }
}
