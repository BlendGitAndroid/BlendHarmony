import {
  authCart,
  BusinessVariable,
  CartGoods,
  CartGoodsModel,
  delCart,
  getCartListAPI,
  GlobalVariable,
  HDMEmpty,
  HDMGuess,
  HDMLoadingDialog,
  HDMNavBar,
  HDMUser,
  PAGE_PATH,
  selectOrUnSelect,
  updateCart,
  UpdateCartParams
} from '@shop/basic'
import { CartItem } from '../components'

@Component
export struct CartView {
  // 用户信息
  @StorageProp(GlobalVariable.USER_INFO_KEY)
  user: HDMUser = {} as HDMUser
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  // 商品信息
  @State
  cartList: CartGoodsModel[] = []
  // 页面栈
  @Consume
  stackPath: NavPathStack
  @State
  showBackIcon: boolean = false
  @State
  isCheckAll: boolean = false
  @State
  allPrice: number = 0

  aboutToAppear(): void {
    const params = this.stackPath.getParamByName(PAGE_PATH.CART_PAGE) as boolean[]
    if (params[params.length - 1]) {
      this.showBackIcon = true
    }
    this.registerEvent()
  }

  // 注册事件
  registerEvent() {
    this.getCartList()
    getContext().eventHub.on(BusinessVariable.UPDATE_CART_LIST, () => {
      this.getCartList() // 更新列表
    })
  }

  calcAllPrice() {
    this.allPrice = this.cartList.filter(item => item.selected)
      .reduce((preValue: number, item: CartGoodsModel) => {
        return preValue + item.price * item.count
      }, 0)
  }

  // 获取购物车列表
  async getCartList() {
    if (this.user.token) {
      const list = await getCartListAPI()
      // 对每个购物车对象进行的new
      // this.cartList = list
      this.cartList = list.map(item => new CartGoodsModel(item))
      this.checkAllIsSelect()
      this.calcAllPrice()
    }
  }

  checkAllIsSelect() {
    this.isCheckAll = this.cartList.every(item => item.selected)
  }

  @Builder
  DeleteBuilder(skuId: string) {
    Text('删除')
      .fontSize(14)
      .width(60)
      .height(100)
      .backgroundColor($r('[shop_basic].color.red'))
      .fontColor($r('[shop_basic].color.white'))
      .textAlign(TextAlign.Center)
      .onClick(async () => {
        await delCart({
          ids: [skuId]
        })
        authCart.updateCartCount()

      })
  }

  dialog = new CustomDialogController({
    builder: HDMLoadingDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center,
    maskColor: '#00000000'
  })

  onCheckOrder() {
    AlertDialog.show({
      message: '去结算'
    })
  }

  build() {
    NavDestination() {
      Column() {
        HDMNavBar({
          title: '购物袋',
          showLeftIcon: this.showBackIcon,
          showRightIcon: true,
          onLeftClick: () => {
            this.stackPath.pop()
          }
        })
          .border({
            width: { bottom: 0.5 },
            color: '#e4e4e4'
          })

        List() {
          if (this.user.token) {


            if (this.cartList.length) {

              ForEach(this.cartList, (cart: CartGoodsModel) => {
                ListItem() {
                  CartItem({
                    cart: cart,
                    onChangeSelected: async selected => {
                      // 更新数据
                      // 更新页面
                      await updateCart(cart.skuId, {
                        selected, //
                        count: cart.count
                      })
                      authCart.updateCartCount()
                    },
                    onChangeCount: async count => {
                      // 更新数据
                      // 更新页面
                      await updateCart(cart.skuId, {
                        selected: cart.selected, //
                        count
                      })
                      // 服务器已经更新成功
                      authCart.updateCartCount()

                    }
                  })
                }
                .backgroundColor($r('[shop_basic].color.under'))
                .padding({ left: 8, right: 8 })
                .transition({ type: TransitionType.Delete, opacity: 0 })
                .swipeAction({
                  end: this.DeleteBuilder(cart.skuId)
                })
              }, (cart: CartGoods) => cart.skuId + "_" + cart.selected)
            } else {
              ListItem() {
                HDMEmpty({
                  buttonText: '去逛逛',
                  tip: '购物车空空哒',
                  onBtnClick: () => {
                    // emitter.emit(GlobalVariable.SWITCH_TAB, {
                    //   data: {
                    //     index: 0
                    //   }
                    // })
                    getContext().eventHub.emit(GlobalVariable.SWITCH_TAB, 0)
                  }
                })
              }
            }
          } else {
            // 未登录
            ListItem() {
              HDMEmpty({
                buttonText: '去登录',
                tip: "您当前未登录",
                onBtnClick: () => {
                  this.stackPath.pushPath({
                    name: PAGE_PATH.LOGIN_PAGE
                  })
                }
              })
            }
          }
          ListItem() {
            HDMGuess()
              .margin({ top: 8, bottom: 8 })
          }

        }
        .contentStartOffset(8)
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        if (this.cartList.length) {
          Row() {
            Checkbox()
              .selectedColor($r('[shop_basic].color.red'))
              .select(this.isCheckAll)
              .onClick(async () => {
                // 点击全选中/全取消
                this.isCheckAll = !this.isCheckAll
                this.cartList.forEach(item => item.selected = this.isCheckAll) // 客户端变化
                // 服务器也变化
                await selectOrUnSelect({ selected: this.isCheckAll } as UpdateCartParams)
                authCart.updateCartCount()
                // if(this.isCheckAll) {
                //   // 所有的都选中
                //   this.cartList.forEach(item => item.selected = true)
                // }else {
                //   // 所有的都取消
                //   this.cartList.forEach(item => item.selected = false)
                //
                // }
              })
            Text('全选')
              .fontSize(14)
              .fontColor($r('[shop_basic].color.black'))
              .margin({ right: 20 })
            Text('合计:')
              .fontSize(14)
              .fontColor($r('[shop_basic].color.black'))
              .margin({ right: 2 })
            Text(this.allPrice.toFixed(2))
              .fontSize(16)
              .fontWeight(500)
              .fontColor($r('[shop_basic].color.red'))
              .layoutWeight(1)
            Button('去结算')
              .fontSize(14)
              .height(36)
              .backgroundColor($r('[shop_basic].color.red'))// .enabled(this.allPrice > 0)
              .enabled(this.cartList.some(item => item.selected))
              .onClick(() => {
                this.stackPath.pushPath({
                  name: PAGE_PATH.CHECK_ORDER_PAGE
                })
              })
          }
          .height(50)
          .width('100%')
          .backgroundColor($r('[shop_basic].color.white'))
          .border({
            width: { top: 0.5, bottom: 0.5 },
            color: '#e4e4e4'
          })
          .padding({ left: 16, right: 16 })
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('[shop_basic].color.under'))
      .padding({
        top: this.topHeight
      })
    }
    .hideTitleBar(true)
  }
}


@Builder
function CartViewBuilder() {
  CartView()
}


