import { request, zlib } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { fileIo } from '@kit.CoreFileKit'

@Entry({ routeName: "WebviewCase" })
@Component
export struct WebviewCase {
  downloadUrl: string = 'https://gitee.com/shuiruohanyu/toutiao_net/raw/master/resources/toutiao.zip'

  @State
  showProgress: boolean = false

  @State
  current: number = 0

  @State
  total: number = 0

  filePath: string = ''

  async downloadZip() {
    this.showProgress = true
    const fileName = 'toutiao.zip'
    let filePath = getContext().filesDir + '/' + fileName
    const task = await request.downloadFile(getContext(), {
      url: this.downloadUrl,
      filePath: filePath
    })

    task.on('progress', (current, total) => {
      this.current = current
      this.total = total
    })
    task.on('complete', () => {
      this.filePath = filePath
      this.decompressFile()
    })
    task.on('fail', () => {
      promptAction.showToast({
        message: '下载失败！'
      })
    })

  }

  // 解压文件
  async decompressFile() {
    try {
      await zlib.decompressFile(this.filePath, getContext().filesDir)
      this.showProgress = false
    } catch (err) {
      //   上面的代码执行失败
    }
  }

  build() {
    Column() {
      Button('热更新')
        .onClick(() => {
          this.downloadZip()
        })

      Button('获取地址')
        .onClick(() => {
          let path = 'file://' + getContext().filesDir + '/toutiao/index.html'
          console.log("WebviewCase: " + path)
          let file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY);
          console.log("WebviewCase: " + file.path)
        })

      if (this.showProgress) {
        Progress({
          value: this.current,
          total: this.total
        })
          .width('100%')
      } else {
        Column() {
          Web({
            src: 'file://' + getContext().filesDir + '/toutiao/index.html',
            controller: new webview.WebviewController()
          }).width('100%')
            .height('100%')
            .domStorageAccess(true)// 开启本地缓存
            .fileAccess(true) // 开启文件读写
        }.width('100%')
        .layoutWeight(1)
        .backgroundColor(Color.Blue)
      }
    }
    .width('100%')
    .height('100%')
  }
}
