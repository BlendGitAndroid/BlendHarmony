import { CareBuilder, DeviceBuilder, ResManager, RouterConfig } from '@care/basic/Index'
import router from '@ohos.router'


@Component
export struct Home {
  // 消息
  @Builder
  msgItem(title: string, icon: Resource | string, count: number, i: number) {
    Column() {
      // 脚标组件, 可以附加在单个组件上用于信息标记的容器组件
      Badge({
        count,
        position: BadgePosition.RightTop,
        style: {
          badgeColor: '#FF6363',
          borderColor: '#fff',
          borderWidth: 2,
          badgeSize: 20
        }
      }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
          .margin({ bottom: 10 })
      }

      Text(title)
        .fontSize(ResManager.EC_SMALL_FS)
        .fontColor(ResManager.EC_MID_19)
    }
    .layoutWeight(1)
    .borderRadius(8)
    .padding({ top: 20, bottom: 23 })
    .backgroundColor(ResManager.EC_MID_WHITE)
    .onClick(() => {
      router.pushUrl({
        url: RouterConfig.USER_MSG_URL,
        params: {
          type: i
        }
      })
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column({ space: 25 }) {
        Column() {
          // 1.1 广告图
          Image($r('app.media.img_banner'))
            .width('100%')
            .aspectRatio(1.32)

          //  1.2 消息提醒
          Column() {
            Row({ space: 10 }) {
              this.msgItem('老人报警消息', $r("app.media.ic_home_jkbj"), 6, 0)
              this.msgItem('任务提醒消息', $r("app.media.ic_home_rwtx"), 2, 1)
            }
          }
          .margin({
            top: -50,
            left: ResManager.EC_CONTENT_SPACE,
            right: ResManager.EC_CONTENT_SPACE,
          })
        }
        .width('100%')

        Column({ space: 25 }) {
          //  1.3 护理工作台
          Column() {
            // 标题
            Text('护理工作台')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            CareBuilder() // 在basic的提取的Builder
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          //  1.4 设备管理
          Column() {
            // 标题
            Text('设备管理')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })
            // 内容
            DeviceBuilder() // 在basic的提取的Builder
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding({ left: 15, right: 15 })
      }
      .width('100%')
      .height('100%')

      // 2. 服务口号
      Row() {
        Image($r('app.media.img_home_kouhao'))
          .width(211)
          .height(15)
      }
      .margin({ bottom: 28 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}
