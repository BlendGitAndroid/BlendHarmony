import { FoodItem } from '../models';
import { CartStore } from '../utils/CartStore';

@Component
export struct MTAddCart {
  food: FoodItem = new FoodItem()

  // 从本地数据获取
  @StorageLink('cart_list')
  cartList: FoodItem[] = []

  getCount() {
    // 当本地数据发生变化的时候,cartList随时就会改变
    const index = this.cartList.findIndex((listItem: FoodItem) => listItem.id === this.food.id)
    return this.cartList[index]?.selectCount || 0
  }

  build() {
    Row({ space: 8 }) {
      Row({ space: 8 }) {
        // 减号
        Row() {
          Image($r('app.media.ic_screenshot_line'))
            .width(10)
            .aspectRatio(1)
        }
        .width(16)
        .aspectRatio(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r("app.color.white"))
        .borderRadius(4)
        .border({ width: 0.5, color: $r("app.color.main_color") })
        .visibility(this.getCount() > 0 ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          CartStore.addCart(this.food, false)
        })
      }

      // 数量
      Text(this.getCount().toString())
        .fontSize(14)

      // 加号
      Row() {
        Image($r('app.media.ic_public_add_filled'))
          .width(10)
          .aspectRatio(1)
      }
      .width(16)
      .aspectRatio(1)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r("app.color.main_color"))
      .borderRadius(4)
      .visibility(this.getCount() < this.food.count ? Visibility.Visible : Visibility.Hidden)
      .onClick(() => {
        CartStore.addCart(this.food)
      })
    }
  }
}
