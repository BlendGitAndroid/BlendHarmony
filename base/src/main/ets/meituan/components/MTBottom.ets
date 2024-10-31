import { FoodItem } from '../models'

@Component
export struct MTBottom {
  // 从index获取,是否展示购物车
  @Consume('showCart')
  showCart: boolean

  // 从本地存储获取
  @StorageLink('cart_list')
  cartList: FoodItem[] = []

  getTotalCount() {
    // reduce((上一次计算的累加值，当前数组的每一项)=>{},初始值)
    const result = this.cartList.reduce((total, item) => {
      return total + (item.selectCount || 0)
    }, 0)
    return result.toString()
  }

  getTotalPrice() {
    const result = this.cartList.reduce((total, item) => {
      return total + ((item.selectCount || 0)) * item.price
    }, 0)
    return result.toFixed(2) // 固定小数点两位
  }

  build() {
    Row() {
      Row() {
        // 脚标组件, 可以附加在单个组件上用于信息标记的容器组件
        Badge({
          value: this.getTotalCount(), // 脚标提示内容
          position: BadgePosition.Right, // 设置位置
          style: {
            badgeSize: 18 // 大小
          }
        }) {
          Image($r('app.media.ic_public_cart'))// 脚标的大图标
            .width(48)
            .height(60)
            .position({
              y: -10
            })
        }.margin({
          left: 20,
          right: 20
        }).onClick(() => {
          this.showCart = !this.showCart
        })

        // 价格
        Column() {
          // span  imageSpan
          Text() {
            Span('￥')
              .fontSize(12)
            Span(this.getTotalPrice())
              .fontSize(24)
          }
          .fontColor($r('app.color.white'))

          Text('预计配送费 ￥5')
            .fontColor($r('app.color.search_font_color'))
            .fontSize(14)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        // 去结算
        Text('去结算')
          .height(50)
          .width(100)
          .backgroundColor($r('app.color.main_color'))
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .borderRadius({
            topRight: 25,
            bottomRight: 25
          })
      }
      .width('100%')
      .backgroundColor($r('app.color.bottom_back'))
      .height(50)
      .borderRadius(25)
    }
    .width('100%')
    .padding(20)
  }
}
