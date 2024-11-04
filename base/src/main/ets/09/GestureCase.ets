import { display, promptAction } from '@kit.ArkUI'

@Entry
@Component
struct GestureCase {
  // TapGesture: 点击手势,支持单次点击、多次点击识别。
  // LongPressGesture: 长按手势。
  // PanGesture: 平移手势，滑动最小距离为5vp时识别成功。
  // PinchGesture: 捏合手势。
  // RotationGesture: 旋转手势。
  // SwipeGesture: 滑动手势,滑动最小速度为100vp/s时识别成功。
  // GestureGroup: 手势识别组,多种手势组合为复合手势,支持连续识别、并行识

  // GestureMode枚举说明
  // Sequence: 顺序识别,按照手势的注册顺序识别手势,直到所有手势识别成功。若有一个手势识别失败，
  // 后续手势识别均失败。顺序识别手势组仅有最后一个手势可以响应onActionEnd
  // Parallel: 并发识别，注册的手势同时识别,直到所有手势识别结束,手势识别互相不影响。
  // Exclusive: 互斥识别，注册的手势同时识别，若有一个手势识别成功，则结束手势识别。


  @State
  showBind: boolean = false

  @State
  screenWidth: number = 0

  @State
  selectType: SelectType = SelectType.NONE

  aboutToAppear(): void {
    // 获取当前屏幕的宽度
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width)
  }

  @Builder
  bindContent() {
    Column() {
      Row() {
        Text('删')
          .fontColor('#fff')
          .fontSize(24)
          .width(100)
          .aspectRatio(1)
          .backgroundColor(this.selectType === SelectType.DELETE ? Color.Red : '#ff757070')
          .borderRadius(50)
          .rotate({
            angle: -10
          })
          .textAlign(TextAlign.Center)

        Text('文')
          .fontColor('#fff')
          .fontSize(24)
          .width(100)
          .aspectRatio(1)
          .backgroundColor(this.selectType === SelectType.TEXT ? Color.Red : '#ff757070')
          .borderRadius(50)
          .rotate({
            angle: 10
          })
          .textAlign(TextAlign.Center)

      }.width('100%')
      .padding({
        left: 20,
        right: 20
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }.width('100%')
    .height('100%')
    .backgroundColor('#4f000000')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Button('发语音消息')
        .width('100%')
        .type(ButtonType.Normal)
        .backgroundColor('#ff149d21')
        .gesture(
          // 组合手势
          GestureGroup(GestureMode.Parallel,
            // 1.先长摁
            LongPressGesture()
              .onAction(() => {
                //   触发手势时执行的内容
                this.showBind = true
              })
              .onActionEnd(() => {
                // 长按结束时
                this.showBind = false
              }),

            // 2.滑动
            PanGesture()
              .onActionUpdate((event) => {
                // promptAction.showToast({
                //   message:'我开始滑了:'+event.fingerList[0].globalX+'/'+this.screenWidth
                // })
                if (event.fingerList[0].globalX < this.screenWidth / 2) {
                  this.selectType = SelectType.DELETE
                } else {
                  this.selectType = SelectType.TEXT
                }
              })
              .onActionEnd(() => {
                this.selectType = SelectType.NONE
              }),

            //   3.按压
            TapGesture()
              .onAction(() => {
                promptAction.showToast({
                  message: '别按我了！'
                })
              })
          )
        )
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .justifyContent(FlexAlign.End)
    .bindContentCover($$this.showBind, this.bindContent(), {
      modalTransition: ModalTransition.NONE
    })
    .onAreaChange((_, _newValue) => {
      this.screenWidth = _newValue.width as number
    })
  }
}

enum SelectType {
  NONE,
  DELETE,
  TEXT
}