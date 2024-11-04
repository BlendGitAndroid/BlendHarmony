@Entry
@Component
struct ImageFrameCase {

  // 通过使用ImageAnimator组件实现逐帧播放图片的能力，可以配置需要播放的图片列表，每张图片可以配置时长
  // 通过state属性可以控制图片的动画的执行方式
  // AnimationStatus.Initial 初始化   -  不播放动画
  // AnimationStatus.Running 播放中   -  播放动画
  // AnimationStatus.Paused 暂停   -  暂停动画至当前帧

  @State
  playState: AnimationStatus = AnimationStatus.Initial

  build() {
    Row() {
      Column({ space: 20 }) {
        // 定义图片帧动画
        ImageAnimator()
          .images([
            { src: '/assets/JDRunMan/app_refresh_people_0.png' },
            { src: '/assets/JDRunMan/app_refresh_people_1.png' },
            { src: '/assets/JDRunMan/app_refresh_people_2.png' },
            { src: '/assets/JDRunMan/app_refresh_people_3.png' }
          ])
          .width(200)
          .height(200)
          .duration(1000)
          .iterations(-1)
          .fillMode(FillMode.None)// 控制图片播放
          .state(this.playState) // 绑定state

        ImageAnimator()// 每一帧图片的数组
          .images(Array.from(Array(37), (item: string, index: number) => {
            return { src: `/assets/JDLoading/loading_${index + 1}.png` } as ImageFrameInfo
          }))
          .width(200)
          .height(200)
          .duration(3000)
          .iterations(-1)
          .fillMode(FillMode.None)// 控制图片播放
          .state(this.playState) // 绑定state

        Button('播放')
          .onClick(() => {
            this.playState = AnimationStatus.Running
          })

        Button('暂停')
          .onClick(() => {
            this.playState = AnimationStatus.Paused
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}