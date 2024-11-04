import hilog from '@ohos.hilog';

const TAG = '[GetKeyBoardCase]';
const number = 0xFF00;

@Entry({ routeName: "GetKeyBoardCase" })
@Component
export struct GetKeyBoardCase {
  // 页面初始化
  aboutToAppear(): void {
    // 如果没有销毁只会执行一次
    hilog.info(number, TAG, 'onCreate')
  }

  // 页面销毁
  aboutToDisappear(): void {
    hilog.info(number, TAG, 'aboutToDisappear')
  }

  // @Entry修饰的页面多了3个周期
  // 组件不包含下面3个周期
  // 页面展示的事后进行触发
  // eg:路由跳转返回、应用后台前台切换
  onPageShow(): void {
    hilog.info(number, TAG, 'onPageShow')
  }

  onPageHide(): void {
    hilog.info(number, TAG, 'onPageHide')
  }

  onBackPress(): boolean | void {
    hilog.info(number, TAG, 'onBackPress')
  }

  build() {
    Column() {
      Text('顶部区域')
        .width('100%')
        .height(50)
        .textAlign(TextAlign.Center)

      Text('中部区域')
        .width('100%')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Orange)

      Row() {
        TextInput({ placeholder: "请留下评论" })
      }
      .width('100%')
      .height(50)
    }
    .width('100%')
    .height('100%')
  }
}
