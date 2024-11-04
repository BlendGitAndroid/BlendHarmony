@Entry
@Component
struct CanvasCase {
  // 1. 放置Canvas组件-给宽和高
  // 2. 初始化画笔对象 CanvasRenderingContext2D，将画笔对象作为构造参数传递给Canvas组件
  // 3. 可以在Canvas的onReady事件中进行动态绘制

  // 2.准备画笔
  myPen: CanvasRenderingContext2D = new CanvasRenderingContext2D()

  @State
  canvasWidth: number = 0

  @State
  canvasHeight: number = 0

  // 画线
  drawLine() {
    this.myPen.beginPath()
    //   moveTo  手拿着笔移动到画布的某个坐标(离开画布)
    this.myPen.moveTo(0, 0)
    //    line   手拿着笔移动到画布的某个坐标(在画布上移动)
    this.myPen.lineTo(100, 100)
    //   store   绘制一下在画布上移动的轨迹
    this.myPen.lineWidth = 5
    this.myPen.strokeStyle = 'red'
    this.myPen.stroke()
    this.myPen.closePath()
  }

  drawRect() {
    this.myPen.beginPath()
    this.myPen.moveTo(200, 200)
    this.myPen.lineWidth = 3
    this.myPen.strokeStyle = '#FFF045'
    this.myPen.strokeRect(200, 200, 100, 100)
    this.myPen.closePath()
  }

  drawCircle() {
    this.myPen.beginPath()
    // this.myPen.moveTo(50,50)
    this.myPen.lineWidth = 10
    this.myPen.strokeStyle = '#FFF045'
    this.myPen.arcTo(75, 85, 30, 0, 200)
    this.myPen.stroke()
    this.myPen.closePath()
  }

  drawBezierCurve() {
    this.myPen.beginPath()
    this.myPen.lineWidth = 4
    this.myPen.strokeStyle = 'red'
    this.myPen.moveTo(50, 50)
    this.myPen.bezierCurveTo(100, 100, 200, 200, 200, 10)
    this.myPen.stroke()
    this.myPen.closePath()
  }

  drawText() {
    this.myPen.beginPath()
    this.myPen.font = '100px san-serif'
    this.myPen.fillText('精忠报国!', this.canvasWidth / 2, this.canvasHeight / 2)
    this.myPen.closePath()
  }

  drawImage() {
    this.myPen.beginPath()
    this.myPen.drawImage(new ImageBitmap('/assets/1.webp'), 0, 0)
    this.myPen.closePath()
  }

  clearCanvas() {
    this.myPen.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        // 1.准备画布
        Canvas(this.myPen)
          .width('100%')
          .height(300)
          .backgroundColor(Color.Pink)
          .onReady(() => {
            // this.drawLine()
          })
          .onAreaChange((_, _new) => {
            this.canvasWidth = _new.width as number
            this.canvasHeight = _new.height as number
          })
        Flex({ wrap: FlexWrap.Wrap }) {
          Button('清空画布')
            .onClick(() => {
              this.clearCanvas()
            })
          Button('画线')
            .onClick(() => {
              this.drawLine()
            })
          Button('画矩形')
            .onClick(() => {
              this.drawRect()
            })
          Button('画圆')
            .onClick(() => {
              this.drawCircle()
            })
          Button('画3次贝塞尔曲线')
            .onClick(() => {
              this.drawBezierCurve()
            })
          Button('画文字')
            .onClick(() => {
              this.drawText()
            })
          Button('画图')
            .onClick(() => {
              this.drawImage()
            })
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}