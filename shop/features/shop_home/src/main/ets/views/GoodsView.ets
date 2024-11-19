import {
  auth,
  authCart,
  BusinessVariable,
  GlobalVariable,
  HDMGuess,
  HDMLoadingDialog,
  HDMNavBar,
  HDMSku,
  HDMSkuType,
  PAGE_PATH
} from '@shop/basic'
import { Goods } from '../viewmodel'
import { promptAction, window } from '@kit.ArkUI'
import { GoodsComment, GoodsDetail, GoodsInfo } from '../components'
import { getDetailAPI } from '../api'


@Builder
function GoodsViewBuilder() {
  GoodsView()
}

@Component
export struct GoodsView {
  @StorageProp
  (GlobalVariable.SAFE_AREA_BOTTOM)
  safeBottom: number = 0
  @StorageProp(BusinessVariable.CART_COUNT)
  cartCount: number = 0
  @StorageProp
  (GlobalVariable.SAFE_AREA_TOP)
  safeTop: number = 0
  @State goods: Goods = {} as Goods
  @State activeIndex: number = 0
  @State showSheet: boolean = false
  @State count: number = 1
  @State loading: boolean = false
  @State
  sku: HDMSkuType = {} as HDMSkuType
  scroller = new Scroller()
  loadingTitle: string = "加载中..."
  @Consume
  stackPath: NavPathStack
  loadingDialog: CustomDialogController = new CustomDialogController({
    builder: HDMLoadingDialog({
      title: this.loadingTitle
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })
  tabs: string[] = ['商品', '评价', '详情', '推荐']

  setStatusBar() {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#000000' })
      })
  }

  aboutToAppear() {
    // 接收并解析数据
    this.setStatusBar()
    this.getDetailData() // 获取详情数据
  }

  // 生命周期- 父组件 aboutToAppear(同步已经完成/异步) => 父组件的build => 子组件的aboutToAppear（已经有了之前同步设置的数据了-第一次渲染） => 子组件的build =>
  // 同步代码和异步代码 先把异步代码挂起来-先把所有同步的代码执行完毕- 再去执行异步

  // 获取详情
  async getDetailData() {
    this.loadingDialog.open() // 创建
    const params = this.stackPath.getParamByName(PAGE_PATH.GOODS_PAGE) as Goods[]
    if (params && params.length) {
      this.goods = params[params.length - 1] // 接收上一次的数据
    }
    this.goods = await getDetailAPI(this.goods.id)
    // 通过接口获取真正的详情数据
    this.loadingDialog.close() // 销毁
  }

  @Builder
  CustomTitleBuilder() {
    Row() {
      Row({ space: 6 }) {
        ForEach(this.tabs, (item: string, index: number) => {
          Text(item)
            .fontColor(this.activeIndex === index ? $r("[shop_basic].color.black") : $r("[shop_basic].color.gray"))
            .onClick(() => {
              this.activeIndex = index
              this.scroller.scrollToIndex(index)
            })
        })
      }

      // 楼层切换
      Image($r('[shop_basic].media.ic_public_shared'))
        .iconButton()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .padding({
      left: 40,
      right: 40
    })
  }

  // 加入购物车
  async addToCart() {
    const user = auth.getUserInfo()
    if (!user || !user.token) {
      promptAction.showToast({ message: '您还未登录' })
      this.showSheet = false // 关闭半模态弹窗
      // 到底跳转不跳转登录 取决于产品的运营逻辑
      this.stackPath.pushPath({ name: PAGE_PATH.LOGIN_PAGE })
      return Promise.reject(new Error("您还未登录"))
    }
    // 此时说明用户是有的
    if (!this.sku.id) {
      promptAction.showToast({ message: '请选择对应的产品规格' })
      return Promise.reject(new Error("请选择对应的产品规格"))
    }
    this.loadingTitle = "加入中..."
    this.loadingDialog.open()
    // 加入购物车的接口
    // await addCartAPI({ skuId: this.sku.id, count: this.count })
    await authCart.addCart({ skuId: this.sku.id, count: this.count })
    promptAction.showToast({ message: '加入购物车成功' })
    this.loadingDialog.close()
    return Promise.resolve()
  }

  // 快速购买
  async buyQuickly() {
    await this.addToCart() // 加入购物车成功
    this.showSheet = false // 关闭半模态
    this.stackPath.pushPath({
      name: PAGE_PATH.CHECK_ORDER_PAGE
    }) // 跳转到核对订单页面
  }

  @Builder
  AddCartBuilder() {
    Column() {
      Text(this.sku.id ? `已选:${this.sku.specsText} ` : "")
        .fontWeight(300)
        .width('100%')
        .fontColor($r('[shop_basic].color.black'))
        .fontSize(14)
        .padding({ bottom: 10, right: 50 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 10 }) {
        Image(this.sku.picture || this.goods.mainPictures?.[0])
          .alt($r('app.media.ic_sku_img'))
          .width(80)
          .height(80)
          .backgroundColor($r('[shop_basic].color.under'))
          .borderRadius(4)
        Column() {
          Row() {
            Text('现价¥')
              .fontSize(14)
              .fontColor($r('[shop_basic].color.black'))
              .offset({ y: -4 })
            Text(this.sku.price || this.goods.price)
              .fontSize(24)
              .fontColor($r('[shop_basic].color.black'))
              .fontWeight(500)
            Text('原价¥' + (this.sku.oldPrice || this.goods.price))
              .fontSize(12)
              .fontColor($r('[shop_basic].color.gray'))
              .margin({ left: 10 })
              .offset({ y: -4 })
              .decoration({
                type: TextDecorationType.LineThrough,
                color: $r('[shop_basic].color.gray')
              })
          }
          .alignItems(VerticalAlign.Bottom)

          Row({ space: 10 }) {
            // 计数器
            Counter() {
              Text(this.count.toString())
            }
            .enableDec(this.count > 1) // 小于1不能减
            .enableInc(this.count < this.goods.inventory) // 小于库存数量
            .onInc(() => {
              this.count++
            })
            .onDec(() => {
              this.count--
            })

            Text(this.goods.inventory <= 10000 ? '库存充足' : '库存紧张')
              .fontSize(12)
              .fontColor(this.goods.inventory <= 10000 ? $r('[shop_basic].color.gray') : $r('[shop_basic].color.red'))
          }
        }
        .height(80)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Divider()
        .strokeWidth(4)
        .color($r('[shop_basic].color.under'))
        .margin({ left: -8, right: -8, top: 13 })

      List() {
        ListItem() {
          // Sku 组件
          HDMSku({
            skus: this.goods.skus,
            specs: this.goods.specs,
            onSkuChange: (sku) => {
              this.sku = sku
            }
          })
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      Row() {
        Button(this.loading ? '加入中...' : '加入购物袋')
          .buyButton($r('[shop_basic].color.black'), true)
          .onClick(() => {
            // 实现加入购物车逻辑
            this.addToCart()
          })
        Button('立即购买')
          .buyButton($r('[shop_basic].color.red'), false)
          .onClick(() => {
            this.buyQuickly() // 立刻购买
          })
      }
      .width('100%')
    }
    .height(600)
    .padding({
      left: 16,
      right: 16,
      top: 16,
      bottom: this.safeBottom || 16
    })
    .zIndex(2)
  }

  build() {
    NavDestination() {
      Column() {
        HDMNavBar({
          showRightIcon: true,
          // customTitle: () => {
          //   this.CustomTitleBuilder()
          // },
          onLeftClick: () => {
            this.stackPath.pop()
          }
        }) {
          this.CustomTitleBuilder()
        }

        Column() {
          List({ scroller: this.scroller }) {
            ListItem() {
              // 商品信息
              GoodsInfo({ goods: this.goods, showSheet: this.showSheet })
            }

            ListItem() {
              // 评论 目前无评论数据
              GoodsComment({ goods: this.goods })
            }

            ListItem() {
              // 商品详情
              GoodsDetail({ goods: this.goods })
            }

            ListItem() {
              // 猜你喜欢
              HDMGuess()
            }
          }
          .onScrollIndex((index) => {
            this.activeIndex = index
          })
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
        }
        .layoutWeight(1)
        .backgroundColor($r('[shop_basic].color.under'))

        Row() {
          Image($r('[shop_basic].media.ic_public_like'))
            .iconButton()
          Image($r('[shop_basic].media.ic_public_comment'))
            .iconButton()
          Badge({
            count: this.cartCount,
            style: {},
            position: { x: 30, y: 4 }
          }) {
            Image($r('[shop_basic].media.ic_public_cart'))
              .iconButton()
              .onClick(() => {
                this.stackPath.pushPath({
                  name: PAGE_PATH.CART_PAGE,
                  param: true // 显示返回图标
                })
              })
          }

          Row() {
            Button('加入购物袋')
              .buyButton($r('[shop_basic].color.black'), true)
              .onClick(() => this.showSheet = true)
            Button('立即购买')
              .buyButton($r('[shop_basic].color.red'), false)
              .onClick(async () => {
                if (this.sku.id) {
                  await this.addToCart() // 加入到购物车
                  this.stackPath.pushPath({
                    name: PAGE_PATH.CHECK_ORDER_PAGE
                  })
                } else {
                  this.showSheet = true
                }
              })
          }
          .layoutWeight(1)
          .padding({ right: 16, left: 6 })
        }
        .height(54)
        .width('100%')
        .margin({ bottom: this.safeBottom })
      }
      .height('100%')
      .bindSheet($$this.showSheet, this.AddCartBuilder(),
        {
          height: SheetSize.FIT_CONTENT,
          backgroundColor: $r('[shop_basic].color.white'),
          preferType: SheetType.CENTER
        })
    }
    .hideTitleBar(true)
    .padding({
      top: this.safeTop,
    })
  }
}

@Extend(Image)
function iconButton() {
  .width(24)
  .aspectRatio(1)
  .margin(13)
  .fillColor($r('[shop_basic].color.black'))
}

@Extend(Button)
function buyButton(color: ResourceStr, isLeft: boolean) {
  .fontSize(14)
  .height(36)
  .type(ButtonType.Normal)
  .layoutWeight(1)
  .backgroundColor(color)
  .borderRadius({
    topLeft: isLeft ? 18 : 0,
    bottomLeft: isLeft ? 18 : 0,
    topRight: isLeft ? 0 : 18,
    bottomRight: isLeft ? 0 : 18
  })
  .pixelRound({
    end: PixelRoundCalcPolicy.FORCE_CEIL,
    start: PixelRoundCalcPolicy.FORCE_FLOOR
  })
}

