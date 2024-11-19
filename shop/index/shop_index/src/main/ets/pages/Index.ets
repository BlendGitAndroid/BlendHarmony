import {
  auth,
  authCart,
  BreakPointType,
  BusinessVariable,
  GlobalVariable,
  PAGE_PATH,
  screenManager,
  screenManagerByMedia,
  storeManager,
  TabItem
} from '@shop/basic'
import { CartView } from '@shop/cart'
import { CategoryView } from '@shop/category'
import { HomeView } from '@shop/home'
import { MineView } from '@shop/mine'
import { emitter } from '@kit.BasicServicesKit'

// 编写即调用
storeManager.ctx = getContext() // 赋值上下文
auth.setUserInfo(storeManager.getUserInfo())

@Entry
@Component
struct Index {
  @StorageProp(GlobalVariable.BREAK_POINT_KEY)
  breakPoint: string = ""
  @StorageProp(GlobalVariable.SAFE_AREA_BOTTOM)
  bottomHeight: number = 0
  @StorageProp(BusinessVariable.CART_COUNT)
  cartCount: number = 0
  @State
  activeIndex: number = 0
  list: TabItem[] = [
    { text: '首页', normal: $r('app.media.ic_public_home_normal'), active: $r('app.media.ic_public_home_active') },
    { text: '分类', normal: $r('app.media.ic_public_pro_normal'), active: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', normal: $r('app.media.ic_public_cart_normal'), active: $r('app.media.ic_public_cart_active') },
    { text: '我的', normal: $r('app.media.ic_public_my_normal'), active: $r('app.media.ic_public_my_active') },
  ]
  @Provide
  stackPath: NavPathStack = new NavPathStack()

  @Builder
  getTabItemBuilder(item: TabItem, index: number) {
    Column() {
      if (index === 2) {
        // 加入购物车徽标
        Badge({
          count: this.cartCount,
          style: {}
        }) {
          Column({ space: 4 }) {
            Image(this.activeIndex === index ? item.active : item.normal)
              .width(24)
              .aspectRatio(1)
            Text(item.text)// 跨 HSP 访问资源，需要在 oh-package.json5中导入
              .fontColor($r('[shop_basic].color.black'))
              .fontSize(12)
          }
        }
      } else {
        Image(this.activeIndex === index ? item.active : item.normal)
          .width(24)
          .aspectRatio(1)
        Text(item.text)// 跨 HSP 访问资源，需要在 oh-package.json5中导入
          .fontColor($r('[shop_basic].color.black'))
          .fontSize(12)
      }

    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }

  aboutToAppear(): void {
    // 全屏
    screenManager.full(getContext())
    screenManagerByMedia.registerListenerScreen()
    // Logger.info("正常打印")
    // Logger.error("错误啦")
    // Logger.warn("警告啦")
    this.registerListener()
    this.initCartCount()
  }

  aboutToDisappear(): void {
    // 退出全屏
    screenManager.exitFull(getContext())
    screenManagerByMedia.unregisterListenerScreen()
  }

  // 注册监听
  registerListener() {
    // emitter.on(GlobalVariable.SWITCH_TAB, (event) => {
    //   if (event.data) {
    //     let index = event.data["index"] as number
    //     this.activeIndex = index
    //   }
    // })
    getContext().eventHub.on(GlobalVariable.SWITCH_TAB, (index: number) => {
      this.activeIndex = index
    })
    emitter.on(BusinessVariable.TO_SEARCH, () => {
      this.stackPath.pushPath({
        name: PAGE_PATH.SEARCH_PAGE
      })
    })
  }

  // 购物车数量初始化
  initCartCount() {
    authCart.updateCartCount()
  }

  build() {
    Navigation(this.stackPath) {
      Tabs({
        barPosition: new BreakPointType({
          xs: BarPosition.End,
          sm: BarPosition.End,
          md: BarPosition.End,
          lg: BarPosition.Start
        }).getValue(this.breakPoint), index: $$this.activeIndex
      }) {
        ForEach(this.list, (item: TabItem, index: number) => {
          TabContent() {
            if (index === 0) {
              HomeView()
            } else if (index === 1) {
              CategoryView()
            } else if (index === 2) {
              CartView()
            } else {
              MineView()
            }

          }
          .tabBar(this.getTabItemBuilder(item, index))
        })
      }
      .barHeight(
        new BreakPointType({
          xs: 50,
          sm: 50,
          md: 50,
          lg: 220
        }).getValue(this.breakPoint)
      )
      .vertical(new BreakPointType({
        xs: false,
        sm: false,
        md: false,
        lg: true
      }).getValue(this.breakPoint)
      )
      .scrollable(false)
      .padding({
        bottom: this.bottomHeight
      })
      .animationDuration(
        new BreakPointType({
          xs: 100,
          sm: 100,
          md: 100,
          lg: 0
        }).getValue(this.breakPoint)
      )
    }
    .mode(NavigationMode.Stack) // 不使用它原生的分屏模式
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true) //  不显示标题
  }
}