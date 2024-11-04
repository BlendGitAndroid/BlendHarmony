import { request } from '@kit.BasicServicesKit';

@Entry({ routeName: "DownloadCase" })
@Component
struct DownloadCase {
  // 应用沙箱是一种以安全防护为目的的隔离机制，避免数据受到恶意路径穿越访问。在这种沙箱的保护机制下，
  // 应用可见的目录范围即为“应用沙箱目录”。
  // getContext().cacheDir
  // getContext().fileDir
  // getContext().tempDir

  @State
  downloadUrl: string = 'https://foruda.gitee.com/avatar/1705232317138324256/1759638_itcast_panpu_1705232317.png';

  @State
  filePath: string = ''

  build() {
    Row() {
      Column() {
        Image(this.downloadUrl)
          .width(200)

        Button('下载')
          .onClick(async () => {
            // 起一个名字
            // /data/app/el2/100/base/com.blend.harmony/haps/entry/cache/test.jpg
            let filePath: string = getContext().cacheDir + '/test.jpg'
            //  下载
            const task = await request.downloadFile(getContext(), {
              url: this.downloadUrl,
              filePath: filePath
            })
            task.on('complete', () => {
              this.filePath = filePath
            })
          })

        if (this.filePath !== '') {
          // 沙箱里面的文件，都得是file协议
          Image('file://' + this.filePath)
            .width(200)
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}