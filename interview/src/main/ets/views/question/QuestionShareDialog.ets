import { UserStoreKey } from '../../common/utils/Auth'
import { QuestionDetail, User } from '../../model'
import { componentSnapshot, promptAction } from '@kit.ArkUI'
import { image } from '@kit.ImageKit'
import { fileIo } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@CustomDialog
export struct QuestionShareDialog {
  @Prop item: QuestionDetail = {} as QuestionDetail

  @StorageProp(UserStoreKey) user: User = {} as User

  controller: CustomDialogController

  // 先截图,再保存
  async saveImage() {
    // 1.截图
    const pixelMap = await componentSnapshot.get('share')
    // 2.图片数据处理
    // 压缩图片
    const packer = image.createImagePacker()
    // 压缩后的数据
    const buffer = await packer.packing(pixelMap, { format: 'image/jpeg', quality: 98 })
    // 音频 / 图片 / 文档 ->创建一个文件，写入内容
    // 沙箱中创建一个文件
    const ctx = getContext()
    // 定义存放文件的路径
    const filePath = ctx.cacheDir + '/' + Date.now() + '.jpeg'
    // 文件创建 -> 打开路径(有，就是打开文件，没有，就是创建文件，再打开)
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    // 给文件写入buffer
    fileIo.writeSync(file.fd, buffer)
    // 关闭文件
    fileIo.closeSync(file)


    // --------------------------------------------
    // 1.创建工具
    let context = getContext(this);
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    // 2.准备图片地址
    // 用保存到沙箱的截图 filePath
    // 3.存储请求发起
    let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
      photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, filePath);
    // 4.开启保存
    await phAccessHelper.applyChanges(assetChangeRequest);
    // --------------------------------------------
    // 图片存储成功
    promptAction.showToast({
      message: '保存成功'
    })
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 20 }) {
        Image($r('app.media.ic_interview_logo'))
          .width(40)
          .height(40)
        Text('面试通，搞定企业面试题')
        Divider()
          .strokeWidth(0.5)
          .color($r('app.color.common_gray_border'))
        Text('大厂面试题：' + this.item.stem)
          .fontSize(12)
          .maxLines(2)
          .fontWeight(600)
          .width('100%')
          .lineHeight(24)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        QRCode(this.item.id)// 生成二维码
          .width(160)
          .height(160)
        Text('扫码查看答案')
          .fontSize(12)
          .alignSelf(ItemAlign.Center)
        Blank()
        Text('分享来自：' + this.user.username || this.user.nickName)
          .fontSize(12)
      }
      .id('share')
      .padding(20)
      .alignItems(HorizontalAlign.Start)
      .width(300)
      .height(500)
      .backgroundColor($r('app.color.white'))


      Row() {
        // 安全保存控件
        SaveButton({
          icon: SaveIconStyle.FULL_FILLED,
          text: SaveDescription.SAVE_IMAGE,
          buttonType: ButtonType.Normal
        })
          .fontColor($r('app.color.white'))
          .fontSize(14)
          .padding(12)
          .backgroundColor($r('app.color.common_main_color'))
          .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              try {
                this.saveImage()
              } catch (error) {
                console.error("error is " + JSON.stringify(error));
              }
            }
          })
      }
      .borderRadius({ topLeft: 8 })
      .clip(true)
    }
    .borderRadius(8)
    .clip(true)
  }
}