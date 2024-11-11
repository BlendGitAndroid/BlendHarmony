import { AdvertClass, UserSettingClass } from '@blend/basic'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Start {
  // 需求: 1. 倒计时结束 关闭子窗口
  // 需求: 2. 点击跳过广告按钮, 关闭子窗口

  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass = {
    showAd: false,
    adTime: 0
  }
  timer: number = -1

  closeWin() {
    // 1.1 找到子窗口,然后销毁
    window.findWindow('ad_window').destroyWindow()
  }

  async aboutToAppear() {
    this.adObj = await this.userSetting.getAdvert()
    this.timer = setInterval(() => {
      if (this.adObj.adTime === 0) {
        this.closeWin() //  倒计时结束 关闭子窗口
        clearInterval(this.timer)
        return
      }
      this.adObj.adTime--
    }, 100)
  }

  // 4 当界面销毁时, 销毁定时器
  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) { // 设置右上角
      Image(this.adObj.adImg)
        .objectFit(ImageFit.Cover)
      if (this.adObj.showTime) {
        Text(`${this.adObj.adTime}秒后跳过`)
          .padding({ left: 10, right: 10 })
          .margin({ right: 20, top: 50 })
          .height(30)
          .fontSize(14)
          .borderRadius(15)
          .backgroundColor($r("app.color.background_page"))
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.closeWin()
          })
      }
    }
    .width('100%')
    .height('100%')
  }
}
