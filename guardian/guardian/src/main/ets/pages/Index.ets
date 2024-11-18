import { LOGIN_INFO, LoginInfoResponse, PRIVACY_SETTINGS, PrivacySettings } from '../common/constants';
import { themeManager } from '../manager';
import { GuardTabsComp } from './Tabs/GuardTabsComp';
import { HomeTabsComp } from './Tabs/HomeTabsComp';
import { MyTabsComp } from './Tabs/MyTabsComp';


// 持久化 PersistentStorage 整个项目一个字段只需初始化一次
PersistentStorage.persistProp('isHidePrivacy', false)
// 隐私空间持久化UI状态
PersistentStorage.persistProp<PrivacySettings>(PRIVACY_SETTINGS, {})
// 登录后的用户信息-登录完成后持久化存储
PersistentStorage.persistProp<LoginInfoResponse>(LOGIN_INFO, {})

@Entry
@Component
struct Index {
  // @Provide 装饰器和 @Consume装饰器：与后代组件双向同步
  @Provide currentIndex: number = 0
  @Provide isPageShow: boolean = false
  @StorageLink('bottomHeight') bottomHeight: number = 0

  onPageShow() {
    themeManager.enableFullScreen()
    // 保存页面显示与隐藏状态
    this.isPageShow = true
  }

  onPageHide() {
    themeManager.disableFullScreen()
    this.isPageShow = false
  }

  @Builder
  TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .width(20)
        .aspectRatio(1)
      Text(title)
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.brand') : $r('app.color.font'))
        .margin({ top: 4 })
    }
    .width('100%')
    .height(56)
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
    })
  }

  build() {
    Tabs({ index: this.currentIndex, barPosition: BarPosition.End }) {
      TabContent() {
        // 首页
        HomeTabsComp()
      }
      .tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_tab_shouye_filled'), $r('app.media.ic_tab_shouye')))

      TabContent() {
        // 守护中心
        GuardTabsComp()
      }
      .tabBar(this.TabBuilder('守护中心', 1, $r('app.media.ic_tab_shzx_filled'), $r('app.media.ic_tab_shzx')))

      TabContent() {
        // 我的
        MyTabsComp()
      }
      .tabBar(this.TabBuilder('我的', 2, $r('app.media.ic_tab_wode_filled'), $r('app.media.ic_tab_wode')))
    }
    .barMode(BarMode.Fixed) // 默认值 Fixed
    .scrollable(false) // 限制滑动
    .padding({ bottom: this.bottomHeight })
  }
}