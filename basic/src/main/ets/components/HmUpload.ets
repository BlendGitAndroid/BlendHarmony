import { picker } from '@kit.CoreFileKit'
import { HmPreview } from '.'
import { ImageListModel } from '../models'
import fs from '@ohos.file.fs'
import { util } from '@kit.ArkTS'
import { uploadImageAPI } from '../api/upload'
import request from '@ohos.request'


@Component
export struct HmUpload {
  title: string = ""
  maxSelectNumber: number = 3
  @Prop imageList: ImageListModel[] = []
  @Prop canUpload: boolean = false
  onImageListChange: (imageList: ImageListModel[]) => void = () => {
  }

  async onSelect() {

    const photoPicker = new picker.PhotoViewPicker()

    const result = await photoPicker.select({
      maxSelectNumber: this.maxSelectNumber - this.imageList.length,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })


    if (result.photoUris.length > 0) {
      const list = result.photoUris.map(item => {
        return { url: item } as ImageListModel
      })

      this.imageList.push(...list) // 拼接到旧数组中

      this.onImageListChange(this.imageList)
    }


  }

  index: number = 0
  controller = new CustomDialogController({
    builder: HmPreview({
      urls: this.imageList.map(item => item.url), // 箭头函数的方法体只有一行时, 可以省略{} 和 return
      selectedIndex: this.index
    }),
    customStyle: true
  })

  build() {

    Column() {
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      Grid() {

        ForEach(this.imageList, (item: ImageListModel, index) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width(95)
                .height(95)
                .onClick(() => {
                  this.index = index
                  this.controller.open()
                })

              if (this.canUpload) {
                Image($r('app.media.ic_btn_delete'))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this.imageList.splice(index, 1)
                    this.onImageListChange(this.imageList)
                  })
              }

            }

          }
        })

        if (this.imageList.length < this.maxSelectNumber && this.canUpload) {
          GridItem() {
            Row() {
              Image($r("app.media.ic_add_img")).width(30).height(30)
            }
            .width(95)
            .height(95)
            .backgroundColor('#F2F2F2')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.onSelect()
            })
          }
        }


      }

    }
    .alignItems(HorizontalAlign.Start).width('100%')
  }
}


// 封装成一个可以服用的方法, 外部使用上传逻辑时, 直接导入该函数, 即可使用
export function UploadFile(imageList: ImageListModel[]): Promise<ImageListModel[]> {
  //   💥💥 考本文件到缓存目录
  const saveDir = getContext().cacheDir // 缓存目录


  // 调用上传API的参数
  const fileList: request.File[] = []


  // AlertDialog.show({ message: targetPath, alignment: DialogAlignment.Center })
  imageList.forEach(item => {

    const fileName = util.generateRandomUUID()

    const targetPath = saveDir + '/' + fileName + '.jpg'
    const file = fs.openSync(item.url)
    // 2. 拷贝图片到沙箱(临时缓存目录)
    fs.copyFileSync(file.fd, targetPath) //  拷贝文件 : 1.原始文件的地址或者id,  2.拷贝到的地址或id

    fileList.push({
      filename: fileName + '.jpg',
      name: 'file',
      uri: `internal://cache/${fileName}.jpg`,
      type: 'jpg'
    })
  })


  return uploadImageAPI(getContext(), fileList)
}