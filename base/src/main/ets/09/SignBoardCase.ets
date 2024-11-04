import fileIo from '@ohos.file.fs'
import { buffer } from '@kit.ArkTS'

@Entry
@Component
struct SignBoardCase {
  myPen: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))

  @State
  imgUrl: string = ''

  build() {
    Row() {
      Column({ space: 15 }) {
        Canvas(this.myPen)
          .width('100%')
          .height(300)
          .backgroundColor(Color.Pink)
          .onReady(() => {
            this.myPen.lineWidth = 4
            this.myPen.strokeStyle = 'red'
          })
          .onTouch((event: TouchEvent) => { // 手指滑动事件
            if (event.type === TouchType.Down) {
              this.myPen.beginPath()
              this.myPen.moveTo(event.touches[0].x, event.touches[0].y)
            } else if (event.type === TouchType.Move) {
              this.myPen.lineTo(event.touches[0].x, event.touches[0].y)
              this.myPen.stroke()
            } else if (event.type === TouchType.Up) {
              this.myPen.closePath()
            }
          })
        Button('保存')
          .onClick(() => {
            // this.imgUrl = this.myPen.toDataURL('image/jpg')
            // 下载到沙箱
            let img = this.myPen.toDataURL('image/jpg') // 这是一个文件流
            const filePath = getContext().tempDir + '/' + Date.now() + '.jpg'
            const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
            const base64Image = img.split(';base64,').pop() // 裁掉;base64,前面的
            const imgBuffer = buffer.from(base64Image, 'base64') // base64格式的
            fileIo.writeSync(file.fd, imgBuffer.buffer)
            fileIo.closeSync(file)
            this.imgUrl = 'file://' + filePath
          })
        if (this.imgUrl) {
          Image(this.imgUrl)
            .width('100%')
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}