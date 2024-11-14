import { router } from '@kit.ArkUI';
import { ResManager } from '@care/basic/Index';

@Entry
@Component
struct HealthRecord {
  @StorageProp('topHeight')
  topHeight: number = 0

  // 自定义导航栏 title
  @Builder
  CustomTitle() {
    Row() {
      // 左侧
      Row() {
        Image(ResManager.IC_BACK_WHITE)
          .width(19.65)
          .height(18)
          .margin({ left: 26, right: 18 })
          .onClick(() => router.back())
        Text('血糖历史')
          .fontColor('#fff')
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
      }

      // 右侧
      Text('趋势图')
        .fontSize(ResManager.EC_NORMAL_FS)
        .fontColor('#fff')
        .margin({ right: 18 })
        .onClick(() => {
          router.back()
        })
    }
    .width('100%')
    .height(55)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#33D0C2')
  }

  build() {
    Navigation() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
        // 日期
        Row() {
          Button() {
            Row() {
              Text('2024-03')
                .fontSize(13)
                .fontColor(ResManager.EC_MID_19)
              Image(ResManager.IC_DOWN)
                .width(12)
                .height(5)
                .margin({ left: 2 })
            }
          }
          .width(102)
          .height(28)
          .backgroundColor('#F7F6F9')
        }
        .margin(10)

        // 指标说明
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Column() {
            Row() {
              Circle()
                .width(6)
                .height(6)
                .fill("#0398FF")
                .margin({ right: 8, top: 4 })

              Text('血糖达标')
                .fontSize(13)
                .lineHeight(24)
                .fontColor(ResManager.EC_MID_99)
                .margin({ right: 10 })
              Circle()
                .width(6)
                .height(6)
                .fill("#FFAB2D")
                .margin({ right: 8, top: 4 })
              Text('高或低于目标值')
                .fontSize(13)
                .lineHeight(24)
                .fontColor(ResManager.EC_MID_99)
            }
          }

          Column() {
            Text('单位：mmol/L')
              .fontSize(13)
              .lineHeight(30)
              .fontColor("#999999")
          }
        }
        .width('100%')
        .margin({ bottom: 10 })
        .padding({ left: 10, right: 10 })

        // 血糖表格

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff')
    }
    .title(this.CustomTitle())
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .backgroundColor('#33D0C2')
    .padding({ top: this.topHeight })
  }
}