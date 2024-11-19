import {
    BusinessVariable,
    CategoryItem,
    CategoryItemChild,
    GlobalVariable, HDMNavBar,
    PAGE_PATH
} from '@shop/basic'

@Component
export struct CategoryView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  //  Mock分类数据
  @StorageProp(BusinessVariable.CATEGORY_DATA)
  categories: CategoryItem[] = []
  @State activeIndex: number = 0
  @Consume
  stackPath: NavPathStack

  build() {
    Column() {
      HDMNavBar({
        title: '分类',
        showLeftIcon: false,
        showRightIcon: true,
        rightIcon: $r("[shop_basic].media.ic_public_search"),
        onRightClick: () => {
          this.stackPath.pushPathByName(PAGE_PATH.SEARCH_PAGE, null)
        }
      })
      // MkNavbar({
      // })
      //   .border({ width: { bottom: 0.5 }, color: $r('[shop_basic].color.under') })

      Row() {
        Column() {
          ForEach(this.categories, (item: CategoryItem, i) => {
            Text(item.name)// 文本
              .backgroundColor(this.activeIndex === i ? $r('[shop_basic].color.black') : $r('[shop_basic].color.white'))
              .fontSize(14)
              .fontColor(this.activeIndex === i ? $r('[shop_basic].color.white') : $r('[shop_basic].color.black'))
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(56)
              .onClick(() => {
                this.activeIndex = i
              })

          })
        }
        .width(88)
        .border({ width: { right: 0.5 }, color: $r('[shop_basic].color.under') })

        Scroll() {
          Column() {
            // 顶部图片
            Image(this.categories[this.activeIndex]?.picture || "")
              .width('100%')
              .height(136)
              .objectFit(ImageFit.Contain)
              .backgroundColor('#f6f6f6')
              .borderRadius(8)
              .margin({ bottom: 8 })
            GridRow({
              columns: {
                sm: 2,
                md: 3,
                lg: 4
              }, gutter: 8
            }) {
              // 子分类
              ForEach(this.categories[this.activeIndex].children, (sub: CategoryItemChild) => {
                GridCol() {
                  Column() {
                    // 图片
                    Image(sub.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(sub.name)// 文本
                      .fontSize(14)
                      .fontColor($r('[shop_basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })
            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.topHeight
    })
  }
}