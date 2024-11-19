import { HDMGoodsItem, ListDataSource, BreakPointType } from "../viewmodels"
import { HDMGoods } from "./HDMGoods"
import { GlobalVariable } from '../constants'
import { getGuessData } from "../api"

@Component
export struct HDMGuess {
  @StorageProp(GlobalVariable.BREAK_POINT_KEY)
  breakPoint: string = ""
  lazyDataSource: ListDataSource<HDMGoodsItem> = new ListDataSource()
  loading: boolean = false
  @State
  page: number = 1
  @State
  allPage: number = 1

  aboutToAppear(): void {
    this.getGuess()
  }

  async getGuess() {
    const result = await getGuessData({ page: this.page } as PageParams)
    this.lazyDataSource.addArr(result.items) // 追加数据
    this.allPage = result.pages
    this.page++
    // if(this.allPage < this.page) {
    //
    // }
  }

  build() {
    Column() {
      Row() {
        Text("猜你喜欢")
          .fontColor($r("app.color.black"))
      }
      .height(50)
      .width("100%")
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r("app.color.white"))

      // 瀑布流组件
      WaterFlow() {
        LazyForEach(this.lazyDataSource, (item: HDMGoodsItem) => {
          FlowItem() {
            HDMGoods({ goods: item })
          }
        })
      }
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .columnsTemplate(
        new BreakPointType({
          sm: '1fr 1fr',
          md: '1fr 1fr 1fr',
          lg: '1fr 1fr 1fr 1fr'
        }).getValue(this.breakPoint)
      )
      .columnsGap(10)
      .rowsGap(10)
      .onReachEnd(async () => {
        if (!this.loading && this.page <= this.allPage) {
          this.loading = true
          // 获取数据
          await this.getGuess()
          this.loading = false
        }
      })
    }
    .height("100%")
  }
}

interface PageParams {
  page: number
}