import { Category, FoodItem } from '../models'
import { MTFoodItem } from './MTFoodItem'

@Component
export struct MTMain {
  @Prop
  list: Category[] = []

  @State
  activeIndex: number = 0

  build() {
    Row() {
      // 左边目录
      Scroll() {
        Column() {
          ForEach(this.list, (item: Category, index: number) => {
            Text(item.name)
              .height(50)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .backgroundColor(this.activeIndex === index ? $r('app.color.white') : $r('app.color.left_back_color'))
              .onClick(() => {
                this.activeIndex = index
              })

          })
        }
        .height('100%')
        .width(99)
        .backgroundColor($r('app.color.left_back_color'))
      }

      // 右边目录内容
      List() {
        if (this.list.length > 0) {
          ForEach(this.list[this.activeIndex].foods, (item: FoodItem) => {
            ListItem() {
              MTFoodItem({
                food: item
              })
            }
          })
        } else {
          ListItem() {
            Text('暂无商品上架~')
              .width('100%')
              .textAlign(TextAlign.Center)
          }
        }
      }
      .layoutWeight(1)
      .padding({
        bottom: 60
      })
    }
    .alignItems(VerticalAlign.Top)
    .height('100%')
  }
}
