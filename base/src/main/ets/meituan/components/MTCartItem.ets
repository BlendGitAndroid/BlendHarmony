import { FoodItem } from '../models';
import { MTAddCart } from './MTAddCart';

@Component
export struct MTCartItem {
  food: FoodItem = new FoodItem()

  build() {
    Row() {
      // 左边图片
      Image(this.food.picture)
        .width(60)
        .aspectRatio(1)
        .borderRadius(8)

      // 右边详情
      Column({ space: 5 }) {
        Text(this.food.name)
          .fontSize(14)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .maxLines(2)
        Row() {
          Text() {
            Span('¥ ')
              .fontColor($r("app.color.font_main_color"))
              .fontSize(10)
            Span(this.food.price.toString())
              .fontColor($r("app.color.font_main_color"))
              .fontWeight(FontWeight.Bold)
          }

          MTAddCart({
            food: this.food
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10, right: 10 })
    }
    .alignItems(VerticalAlign.Top)
  }
}
