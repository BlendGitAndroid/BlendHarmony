import { auth, http, logger, UserStoreKey } from '../common/utils'
import { User } from '../model'
import { HmLoadingDialog, HmNavBar } from '../common/components'
import { promptAction } from '@kit.ArkUI'
import { fileIo, picker } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { FormData } from '@ohos/axios'

@Entry
@Component
struct ProfilePage {
  @StorageProp(UserStoreKey) user: User = {} as User
  dialog: CustomDialogController = new CustomDialogController({
    builder: HmLoadingDialog({ message: '更新中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  // 修改头像和昵称
  async updateNickName() {
    await http.request<null, User>({
      url: 'hm/userInfo/profile',
      method: 'post',
      data: {
        nickName: this.user.username
      } as User
    })
    promptAction.showToast({
      message: '昵称修改成功'
    })
    auth.setUser(this.user)
  }

  async updateAvatar() {
    // 1.唤起相册选择 - 选一张图
    // picker.PhotoViewPicker已经淘汰，认识就行
    const option = new photoAccessHelper.PhotoSelectOptions()
    option.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    option.maxSelectNumber = 1
    const picker = new photoAccessHelper.PhotoViewPicker()
    const result = await picker.select(option)
    // promptAction.showDialog({
    //   message: JSON.stringify(result)
    // })
    const uri = result.photoUris[0]
    this.dialog.open()
    // 2.存放到沙箱 - cache - internal
    const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY)
    fileIo.copyFileSync(file.fd, getContext().cacheDir + '/' + file.name)
    fileIo.closeSync(file.fd)
    // 3.压缩图片(可选)
    // 参考保存二维码
    // 思考：压缩如何限制大小
    // fileIo.statSync(file).size
    // 4.发图给后台 - 更新数据
    const formData = new FormData()
    formData.append('file', 'internal://cache/' + file.name)
    // 1.上传头像到后台
    // 另一种逻辑（上传得到URL，自己再设置一次）
    await http.request<string>({
      url: 'hm/userInfo/avatar',
      method: 'post',
      data: formData,
      context: getContext(this),
      headers: {
        "Content-Type": "multipart/form-data"
      }
    })
    // 2.更新头像
    // 重新获取头像
    const user = await http.request<User, User>({ url: 'hm/userInfo' })
    // 当前展示的更新
    this.user.avatar = user.avatar
    // 本地存储更新
    auth.setUser(this.user)
    promptAction.showToast({
      message: '头像修改成功'
    })
    this.dialog.close()
  }

  build() {
    Column() {
      HmNavBar({ title: '编辑资料', showRightIcon: false })
      List() {
        ListItem() {
          Row() {
            Text('头像')
            Image(this.user.avatar || $r('app.media.ic_mine_avatar'))
              .alt($r('app.media.ic_mine_avatar'))
              .width(40)
              .aspectRatio(1)
              .borderRadius(20)
              .border({ width: 0.5, color: $r('app.color.common_gray_border') })
              .onClick(() => {
                // TODO 更新头像
                this.updateAvatar()
              })
          }
          .width('100%')
          .height(60)
          .justifyContent(FlexAlign.SpaceBetween)
        }

        ListItem() {
          Row() {
            Text('昵称')
            TextInput({ text: this.user.username })
              .fontColor($r('app.color.common_gray_03'))
              .textAlign(TextAlign.End)
              .layoutWeight(1)
              .padding(0)
              .height(60)
              .backgroundColor($r('app.color.white'))
              .borderRadius(0)
              .onChange((value) => this.user.username = value)
              .onSubmit(() => {
                // TODO 更新昵称
                this.updateNickName()
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        left: 35,
        right: 35,
        top: 15,
        bottom: 15
      })
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_bg') })
    }
  }
}