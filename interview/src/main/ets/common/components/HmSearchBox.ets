import { router } from '@kit.ArkUI'

@Component
export struct HmSearchBox {
  @Prop
  placeHolderColor: ResourceColor = '#ff8d8d89'
  @Prop
  placeHolderText: string = '搜索题目'
  @Prop
  layoutValue: number = 0
  @Prop
  searchWidth: number = 100
  @Prop
  searchHeight: number = 32
  @Prop
  searchBgColor: ResourceColor = '#e8e7ed'

  // 需求：既可以指定大小，又可以自适应
  // 1.传递宽高，就用宽高，默认不会自适应
  // 2.不传递宽高，就用自适应，会覆盖宽高
  build() {
    Row({ space: 4 }) {
      Image($r('app.media.ic_common_search'))
        .width(14)
        .aspectRatio(1)
        .fillColor(this.placeHolderColor)
      Text(this.placeHolderText)
        .fontSize(14)
        .fontColor(this.placeHolderColor)
    }
    .width(this.searchWidth)
    .height(this.searchHeight)
    .layoutWeight(this.layoutValue)
    .justifyContent(FlexAlign.Center)
    .borderRadius(this.searchHeight / 2)
    .backgroundColor(this.searchBgColor)
    .onClick(()=>{
      router.pushUrl({
        url:'@bundle:com.blend.harmony/interview/ets/pages/SearchPage'
      })
    })
  }
}