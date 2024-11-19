import { BreakPointType, GlobalVariable, HDMGoodsItem, ListDataSource, PAGE_PATH, HDMGoods } from '@shop/basic'
import { searchGoodsAPI } from '../api'
import { SearchParams, SearchRouterParam, SortCompAttr, SortField, SortMethod } from '../viewmodel'
import { SearchSortItem } from './SearchSortItem'


@Component
export struct SearchResultView {
  @Consume
  stackPath: NavPathStack
  // 顶部安全区域
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  safeTop: number = 0
  @StorageProp(GlobalVariable.BREAK_POINT_KEY)
  breakPoint: string = ""
  // mock 数据
  @State data: HDMGoodsItem[] = []
  lazyDataSource: ListDataSource<HDMGoodsItem> = new ListDataSource<HDMGoodsItem>()
  loading: boolean = false // 是否正在加载
  isFinished: boolean = false // 是否已经完成了所有的加载
  // 查询参数
  @State
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()

  aboutToAppear(): void {
    const params = this.stackPath.getParamByName(PAGE_PATH.SEARCH_RESULT_PAGE) as SearchRouterParam[]
    this.params.keyword = params[params.length - 1].keyword
    this.queryGoodsData()
  }

  async queryGoodsData() {
    const result = await searchGoodsAPI(this.params)
    // this.data = result.pageData.items
    this.lazyDataSource.addArr(result.pageData.items)
    this.params.page++
    if (result.pageData.pages < this.params.page) {
      this.isFinished = true
    }


    // 9 -> 10
  }

  // 重新查询逻辑
  refreshQuery() {
    this.params.page = 1 // 再次搜索回到第一页
    this.isFinished = false // 是否加载完成回到最开始状态
    this.loading = false // 一切回到初始状态
    this.lazyDataSource.loadData([]) // 回到空数据 再去添加的
    this.queryGoodsData()
  }

  build() {
    NavDestination() {
      Column() {
        // 搜索区域
        Row() {
          Image($r('[shop_basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('[shop_basic].color.white'))
            .margin(13)
            .onClick(() => {
              this.stackPath.pop()
            })
          Search({ placeholder: '商品关键字...', value: this.params.keyword })
            .searchIcon({ src: $r('[shop_basic].media.ic_public_search'), color: $r('[shop_basic].color.gray') })
            .placeholderColor($r('[shop_basic].color.gray'))
            .placeholderFont({ size: 14 })
            .backgroundColor($r('[shop_basic].color.white'))
            .textFont({ size: 14 })
            .layoutWeight(1)
            .padding(0)
            .margin(0)
            .height(36)
            .caretStyle({ color: $r('[shop_basic].color.red') })
            .onSubmit((value) => {
              this.params.keyword = value
              this.refreshQuery()
            })
        }
        .padding({ top: this.safeTop, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[$r('[shop_basic].color.linear_begin'), 0], [$r('[shop_basic].color.linear_end'), 1]]
        })

        // list
        Row() {
          ForEach(this.sortList, (item: SortCompAttr) => {
            // 筛选组件
            SearchSortItem({
              label: item.label, // 当前自己的显示名称
              field: item.field, // 当前自己的字段
              sortField: this.params.sortField, // 搜索以谁为准
              sortMethod: this.params.sortMethod,
              onSortChange: (field: SortField, method: SortMethod) => {
                this.params.sortField = field
                this.params.sortMethod = method
                // 必须要重查
                this.refreshQuery()
              }
            })
          })
          Text('筛选')
            .fontSize(14)
            .fontColor($r('[shop_basic].color.gray'))
        }
        .padding({ left: 16, right: 16 })
        .height(50)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .border({ width: { bottom: 0.5 }, color: $r('[shop_basic].color.border') })

        WaterFlow({ scroller: this.scroller }) {
          LazyForEach(this.lazyDataSource, (item: HDMGoodsItem) => {
            FlowItem() {
              HDMGoods({ goods: item, smallImage: true })
            }
          })
        }
        .columnsTemplate(
          new BreakPointType({
            sm: '1fr 1fr',
            md: '1fr 1fr 1fr',
            lg: '1fr 1fr 1fr 1fr'
          })
            .getValue(this.breakPoint)

        )
        .columnsGap(0.5)
        .rowsGap(0.5)
        .layoutWeight(1)
        .onReachEnd(async () => {
          if (!this.loading && !this.isFinished) {
            this.loading = true
            await this.queryGoodsData()
            this.loading = false
          }
        })
      }
    }
    .hideTitleBar(true)
  }
}

@Builder
export function SearchResultViewBuilder() {
  SearchResultView()
}