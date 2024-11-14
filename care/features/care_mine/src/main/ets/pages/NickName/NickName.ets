import { ResManager, updateUserNickName } from '@care/basic/Index';
import { promptAction, router } from '@kit.ArkUI';


@Entry
@Component
struct NickName {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  nickName: string = ""

  aboutToAppear(): void {
    const params = router.getParams() as object
    if (params && params["name"]) {
      this.nickName = params["name"]
    }
  }

  // 提交
  async save() {
    await updateUserNickName(this.nickName)
    getContext().eventHub.emit("updateUser") // 更新
    promptAction.showToast({ message: '修改昵称成功' })
    router.back()
  }

  build() {
    Navigation() {
      Column() {
        // Text(this.nickname)
        TextInput({ text: $$this.nickName, placeholder: '请输入2-5个字符的昵称' })
          .height(50)
          .borderRadius(ResManager.EC_NORMAL_RD)
          .backgroundColor('#fff')
          .placeholderColor(ResManager.EC_MID_99)
        //   提交
        Button('保存', { type: ButtonType.Capsule })
          .margin({ top: 50 })
          .width(230)
          .enabled(this.nickName.length >= 2 && this.nickName.length <= 5)
          .onClick(() => {
            this.save()
          })
      }
      .margin({ left: 15, right: 15 })

    }
    .title('昵称')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor(ResManager.EC_MID_BG)
  }
}