import { HDMGoodsItem } from '@shop/basic';

@Component
export struct GoodsComment {
  goods: HDMGoodsItem = {} as HDMGoodsItem

  build() {
    Column() {
      Row() {
        Text('商品评价')
          .fontSize(13)
          .fontWeight(700)
          .fontColor($r('[shop_basic].color.black'))
          .margin({ right: 8 })
        Text('(100+)')
          .fontSize(13)
          .fontColor($r('[shop_basic].color.gray'))
        Blank()
        Text('查看全部')
          .fontSize(13)
          .fontColor($r('[shop_basic].color.gray'))
        Image($r('[shop_basic].media.ic_public_right'))
          .width(20)
          .aspectRatio(1)
          .fillColor($r('[shop_basic].color.gray'))
      }
      .width('100%')
      .height(40)

      ForEach(new Array(2).fill(0), () => {
        Column({ space: 8 }) {
          Row() {
            Image($r('app.media.goods_avatar'))
              .width(24)
              .aspectRatio(1)
              .margin({ right: 8 })
            Text('匿名用户1259')
              .fontColor($r('[shop_basic].color.black'))
              .fontSize(14)
          }
          .width('100%')

          Row() {
            Text('黑色·公开版·128G')
              .fontColor($r('[shop_basic].color.gray'))
              .fontSize(12)
            Blank()
            Text('昨天23.45')
              .fontColor($r('[shop_basic].color.gray'))
              .fontSize(12)
          }
          .width('100%')

          Text('HUAWEI Pura 70 Ultra 创新性采用超聚光伸缩主摄，搭载1英寸大底传感器、以及1英寸传感器中最大的F1.6物理光圈，带来业界最大的主摄进光量。')
            .fontColor($r('[shop_basic].color.text'))
            .fontSize(13)

          Row({ space: 8 }) {
            ForEach(new Array(3).fill(0), () => {
              Image(this.goods.picture)
                .width(80)
                .aspectRatio(1)
            })
          }
          .width('100%')
        }
        .margin({ top: 16 })
      })
    }
    .backgroundColor($r('[shop_basic].color.white'))
    .borderRadius(8)
    .margin({ left: 8, right: 8, bottom: 8 })
    .padding(8)
  }
}