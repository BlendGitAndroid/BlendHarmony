import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';
import { ResManager } from '../utils/ResManager';
import picker from '@ohos.multimedia.cameraPicker';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  callback: (url: string) => void = () => {
  }

  async takePhoto() {
    try {
      let pickerProfile: picker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: picker.PickerResult = await picker.pick(getContext(),
        [picker.PickerMediaType.PHOTO], pickerProfile);
      if (pickerResult.resultUri) { // 这里是直接一个uri
        this.callback(pickerResult.resultUri)
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  // 选择相册
  async selectPhoto() {
    const photo = new photoAccessHelper.PhotoViewPicker()
    const result = await photo.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: 1
    })
    if (result.photoUris.length) { // 这里是一个数组
      // 找到图片了
      this.callback(result.photoUris[0])
    }
  }

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => {
          this.takePhoto()
        })

        ListItem() {
          Text('从相册选择')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => {
          this.selectPhoto()
        })

        ListItem() {
          Text('取消')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }.onClick(() => {
          this.controller.close()
        })
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: ResManager.EC_MID_LINE }) // 设置List的分割线
      .padding(ResManager.EC_CONTENT_SPACE)
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)
    }
  }
}
