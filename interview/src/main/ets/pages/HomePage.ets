import { HmCalendar, HmClockIn, HmSearchBox } from '../common/components'
import { auth, http, requestClockIn, tracking, UserStoreKey } from '../common/utils'
import { QuestionDetail, User } from '../model'
import { HomeCategory } from '../views/Home/HomeCategory'
import { promptAction, router } from '@kit.ArkUI'
import { scanBarcode } from '@kit.ScanKit'

@Component
export struct HomePage {
  @StorageLink('topHeight') topHeight: number = 0
  @StorageLink(UserStoreKey)
  user: User = {} as User

  @Builder
  swiperItemBuilder(src: ResourceStr) {
    Row() {
      Image(src)
        .width('100%')
        .aspectRatio(2.65)
        .objectFit(ImageFit.Fill)
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16
    })
  }

  // 扫码
  async scanCode() {
    // 1.唤起扫码界面
    try {
      //  唤起扫码界面
      const res = await scanBarcode.startScanForResult(getContext())
      const item = await http.request<QuestionDetail>({
        url: 'hm/question/' + res.originalValue
      })
      if (!item) {
        return promptAction.showToast({
          message: '请你扫我分享的码~'
        })
      }
      router.pushUrl({
        url: '@bundle:com.blend.harmony1/interview/ets/pages/QuestionPage',
        params: {
          item,
          list: [item]
        }
      })
    } catch (e) {
      promptAction.showToast({
        message: '当前设备不支持扫码'
      })
    }
  }

  aboutToAppear(): void {
    tracking.report(true)
  }

  build() {
    Column() {
      //头部
      Row({ space: 16 }) {
        //   扫码
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            // 先检测有没有权限
            auth.checkAuth(() => {
              this.scanCode()
            })
          })
        // 搜索框-封装组件
        HmSearchBox({
          layoutValue: 1,
          placeHolderText: '搜索关键字',
        })
        // 打卡
        HmClockIn({
          clockCount: this.user.clockinNumbers
        }).onClick(() => {
          requestClockIn()
        })
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16
      })

      //轮播图
      Swiper() {
        // 抽离组件
        ForEach([
          $r('app.media.banner_pj'),
          $r('app.media.banner_ai'),
          $r('app.media.banner_qa'),
        ], (src: ResourceStr) => {
          this.swiperItemBuilder(src)
        })
      }
      .margin({
        top: 16,
        bottom: 16
      })
      .indicator(DotIndicator.dot()
        .bottom(4)
        .itemHeight(4)
        .selectedColor($r('app.color.white'))
        .selectedItemHeight(4))

      //日历
      HmCalendar()

      // 试题分类
      Column() {
        HomeCategory()
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%')
    .width('100%')
    .padding({
      top: this.topHeight
    })
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}