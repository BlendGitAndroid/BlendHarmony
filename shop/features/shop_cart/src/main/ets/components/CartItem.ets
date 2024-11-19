import { CartGoodsModel, HDMLoadingDialog } from '@shop/basic'

@Component
export struct CartItem {
  @ObjectLink
  cart: CartGoodsModel
  onChangeSelected: (selected: boolean) => void = () => {

  }
  onChangeCount: (count: number) => void = () => {

  }
  dialog = new CustomDialogController({
    builder: HDMLoadingDialog({ title: '' }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  })

  build() {
    Row({ space: 10 }) {
      Checkbox()
        .selectedColor($r('[shop_basic].color.red'))
        .size({ width: 14, height: 14 })
        .select(this.cart.selected)
        .onClick(() => {
          this.cart.selected = !this.cart.selected
          // 取消勾选或者勾选
          this.onChangeSelected(this.cart.selected)
        })
      Image(this.cart.picture)
        .width(80)
        .height(80)
        .syncLoad(true) // 解决图片闪烁
      Column({ space: 8 }) {
        Text(this.cart.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(14)
          .fontColor($r('[shop_basic].color.black'))
          .width('100%')
        Row() {
          Text(this.cart.attrsText)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(12)
            .fontColor($r('[shop_basic].color.text'))
            .layoutWeight(1)
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .fillColor($r('[shop_basic].color.gray'))
            .width(16)
            .height(16)
        }
        .padding({ left: 6, right: 4 })
        .width(100)
        .height(24)
        .backgroundColor($r('[shop_basic].color.under'))
        .borderRadius(2)

        Row() {
          Text(`¥${this.cart.price}`)
            .fontSize(14)
            .fontWeight(500)
          Counter() {
            Text(this.cart.count.toString())
          }
          .enableDec(this.cart.count > 1)
          .onInc(async () => {

            // await this.onChangeCount(this.cart.count) // 子传父 服务器先更新
            // this.cart.count++ // 再更新客户端
            this.cart.count++
            this.onChangeCount(this.cart.count)
          })
          .onDec(() => {
            this.cart.count--
            this.onChangeCount(this.cart.count) // 子传父
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(100)
    .padding(10)
    .border({ width: { bottom: 0.5 }, color: '#e4e4e4' })
    .backgroundColor($r('[shop_basic].color.white'))
  }
}