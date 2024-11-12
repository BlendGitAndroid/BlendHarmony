import { HmSearchBox, HmCalendar, HmClockIn } from '../common/components'
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
    // 拓展：
    // 一多:一次开发，多端部署
    // 界面（界面级一多）
    // 能力（功能级一多）耳机  手机
    // if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
    //   //   唤起扫码界面
    //   const res = await scanBarcode.startScanForResult(getContext())
    //   // promptAction.showToast({
    //   //   message: JSON.stringify(res)
    //   // })
    //   const item = await http.request<QuestionDetail>({
    //     url: 'hm/question/' + res.originalValue
    //   })
    //   if (!item) {
    //     return promptAction.showToast({
    //       message: '请你扫我分享的码~'
    //     })
    //   }
    //   router.pushUrl({
    //     url: 'pages/QuestionPage',
    //     params: {
    //       item,
    //       list: [item]
    //     }
    //   })
    // }else{
    //     promptAction.showToast({
    //       message: '当前设备不支持扫码'
    //     })
    // }
    // 工程（工程级一多）
    // 1.唤起扫码界面
    try {
      //     正常唤起扫码
      //   唤起扫码界面
      const res = await scanBarcode.startScanForResult(getContext())
      // promptAction.showToast({
      //   message: JSON.stringify(res)
      // })
      const item = await http.request<QuestionDetail>({
        url: 'hm/question/' + res.originalValue
      })
      if (!item) {
        return promptAction.showToast({
          message: '请你扫我分享的码~'
        })
      }
      router.pushUrl({
        url: '@bundle:com.blend.harmony/interview/ets/pages/QuestionPage',
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
    //   2.根据结果(id)，跳转的题目页面
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
            // 登录后才能执行
            // if(this.user.token){
            //
            // }else{
            //   router.pushurl(xxx)
            // }
            // 先检测有没有权限
            // 有，执行
            // 没有，去登录 - 登录完重新点
            auth.checkAuth(() => {
              this.scanCode()
            })
          })
        //   搜索框-封装组件
        HmSearchBox({
          layoutValue: 1,
          placeHolderText: '搜索关键字',

        })
        //   打卡
        HmClockIn({
          clockCount: this.user.clockinNumbers
        })
          .onClick(()=>{
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
        //   抽离组件
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