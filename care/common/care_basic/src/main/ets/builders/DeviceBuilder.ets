import { ResManager } from '../utils'
import { router } from '@kit.ArkUI'
import { RouterConfig } from '../constants'

class CareBuilderParams {
  title: string = ""
  icon: ResourceStr = ""
  direction: "horizontal" | "vertical" = "horizontal" // 排列方式
  pageUrl: string = "" // 跳转地址
}

// 模块item
@Builder
/**
 *
 * @param title
 * @param icon
 * @param pos
 * @param url
 */
function careItem(item: CareBuilderParams) {
  if (item.direction === "horizontal") {
    // 护理工作台
    Row({ space: 10 }) {
      Image(item.icon)
        .width(48)
        .aspectRatio(1)
      Text(item.title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .padding({
      top: 20,
      bottom: 23,
      left: 13,
      right: 13
    })
    // .borderRadius(8)
    // .layoutWeight(1)
    // .backgroundColor(ResManager.EC_MID_WHITE)
    .modStyle()
    .onClick(() => {
      item.pageUrl && router.pushUrl({
        url: item.pageUrl
      })
    })
  } else {
    // 设备管理
    Column({ space: 10 }) {
      Image(item.icon)
        .width(40)
        .aspectRatio(1)
      Text(item.title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_SMALL_FS)
    }
    .padding({ top: 23, bottom: 23 })
    // .borderRadius(8)
    // .layoutWeight(1)
    // .backgroundColor(ResManager.EC_MID_WHITE)
    .modStyle()
    .onClick(() => {
      item.pageUrl && router.pushUrl({
        url: item.pageUrl
      })
    })
  }
}

// 可复用样式
@Styles
function modStyle() {
  .borderRadius(8)
  .layoutWeight(1)
  .backgroundColor(ResManager.EC_MID_WHITE)
}

@Builder
export function DeviceBuilder() {
  Row({ space: 10 }) {
    careItem({
      title: '设备安装',
      icon: $r('app.media.icon_home_sbaz'),
      direction: 'vertical',
      pageUrl: RouterConfig.DEVICE_SETUP_URL
    })
    careItem({
      title: '设备绑定',
      icon: $r('app.media.icon_home_sbkz'),
      direction: 'vertical',
      pageUrl: RouterConfig.DEVICE_BIND_URL
    })
    careItem({
      title: '我的设备',
      icon: $r('app.media.icon_home_wdsb'),
      direction: 'vertical',
      pageUrl: RouterConfig.DEVICE_MY_URL
    })
    careItem({
      title: '报警设备',
      icon: $r('app.media.icon_home_bjsb'),
      direction: 'vertical',
      pageUrl: RouterConfig.DEVICE_ALARM_URL
    })
  }
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}

@Builder
export function CareBuilder() {
  Row({ space: 10 }) {
    careItem({
      title: '护理任务',
      icon: $r('app.media.icon_home_hlrw'),
      direction: 'horizontal',
      pageUrl: ""
    })
    careItem({
      title: '护理记录',
      icon: $r('app.media.icon_home_hljl'),
      direction: 'horizontal',
      pageUrl: ""
    })
  }
  .width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}