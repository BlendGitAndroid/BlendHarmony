import {
  BreakPointEnum,
  BreakPointType,
  BusinessVariable,
  CategoryItem,
  GlobalVariable,
  HDMGoodsItem,
  HDMLoading,
  HDMLoadingText,
  HDMProgressLoading,
  ListDataSource,
  PAGE_PATH,
  HDMGoods,
  downLoadManager,
  pushCardManager
} from '@shop/basic'
import {
  getBannerAPI,
  getCategoryAPI,
  getHomeNewAPI,
  getHotResultAPI,
  getInVogueAPI,
  getOneStopAPI,
  getRecommendAPI
} from '../api'
import { HDMDiscountGoods } from '../components'
import { Banner, Params, DiscountType, RecommendParams } from '../viewmodel'
import { promptAction } from '@kit.ArkUI'
import { emitter } from '@kit.BasicServicesKit'


@Component
export struct HomeView {
  // 断点
  @StorageProp(GlobalVariable.BREAK_POINT_KEY)
  breakPoint: string = ""
  // 高度
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  // 轮播图
  @State banners: Banner[] = []
  // 分类
  @State categories: CategoryItem[] = []
  // 特惠推荐
  @State saleGoods: HDMGoodsItem[] = []
  // 爆款推荐
  @State hotGoods: HDMGoodsItem[] = []
  // 一站买全
  @State oneGoods: HDMGoodsItem[] = []
  // 新鲜好物
  @State newGoods: HDMGoodsItem[] = []
  // 推荐商品
  // @State recommendGoods: HDMGoodsItem[] = []
  recommendDataSource: ListDataSource<HDMGoodsItem> = new ListDataSource<HDMGoodsItem>()
  @State
  searchOpacity: number = 0 // 悬浮搜索框的透明度
  @State
  yOffset: number = 0 // 总偏移量
  @State
  loading: boolean = false // 是否正在加载
  @State
  isReachLoad: boolean = false // 是否正在滚动底部加载
  @State
  isFinished: boolean = false // 是否还有下一页
  @State
  isRefreshing: boolean = false // 是否正在刷新
  page: number = 1 // 分页的页码
  scroller: Scroller = new Scroller()
  @Consume
  stackPath: NavPathStack

  aboutToAppear() {
    // 获取首页数据
    this.getHomeData()
    this.registerEvent()
  }

  registerEvent() {
    emitter.on(BusinessVariable.UPDATE_HOME_DATA, () => {
      this.getHomeData()
    })
  }

  // 获取首页数据
  async getHomeData(again?: boolean) {
    // this.banners = await getBannerAPI()
    // this.categories = await getCategoryAPI()
    // this.saleGoods = (await getHotResultAPI()).subTypes[0].goodsItems.items
    // this.hotGoods = (await getInVogueAPI()).subTypes[0].goodsItems.items
    // this.oneGoods = (await getOneStopAPI()).subTypes[0].goodsItems.items
    // this.newGoods = await getHomeNewAPI()
    // Promise.all 所有的全部执行成功才执行
    // Promise.allSettled- 所有的都走完-不论成功或者失败
    if (!again) {
      this.loading = true
    }
    const result =
      await Promise.allSettled([getBannerAPI(), getCategoryAPI(), getHotResultAPI(), getInVogueAPI(), getOneStopAPI(),
        getHomeNewAPI()])
    if (result[0].status === "fulfilled") {
      this.banners = result[0].value
    }
    if (result[1].status === "fulfilled") {
      this.categories = result[1].value
      // 写入到全局状态
      AppStorage.setOrCreate(BusinessVariable.CATEGORY_DATA, this.categories)
    }
    if (result[2].status === "fulfilled") {
      this.saleGoods = result[2].value?.subTypes?.[0]?.goodsItems?.items || []
      //this.saleGoods = result[2].value
      // 拿到特惠推荐的数据
      // [{ picture: 'xxx' }, { picture: 'xxx' }] => [xxx,xxx,xxx]
      this.pushImageToCard(this.saleGoods) // 单独拎出逻辑 不用强硬阻塞首页的加载
    }
    if (result[3].status === "fulfilled") {
      this.hotGoods = result[3].value?.subTypes?.[0]?.goodsItems?.items || []
    }
    if (result[4].status === "fulfilled") {
      this.oneGoods = result[4].value?.subTypes?.[0]?.goodsItems?.items || []
    }
    if (result[5].status === "fulfilled") {
      this.newGoods = result[5].value
    }
    this.loading = false
  }

  async pushImageToCard(list: HDMGoodsItem[]) {
    const fileList = await downLoadManager.downLoadImages(list.map(item => item.picture as string)) // 字符串数组
    // 往卡片推送
    pushCardManager.pushImageToCard(fileList)
  }

  // 封装获取推荐的方法-因为会多次调用
  async getRecommend() {
    const list = await getRecommendAPI({ limit: this.page * 8 } as RecommendParams)
    this.recommendDataSource.loadData(list) // 加载数据
    if (list.length === this.page * 8) {
      this.page++ // 此时说明我要的他都给了 我再试试下一次
    } else {
      this.isFinished = true // 真正的结束了 因为数据不够了
    }
  }

  @Builder
  DiscountBuilder(params: Params) {
    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[shop_basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[shop_basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(params.list, (item: HDMGoodsItem) => {
          ListItem() {
            HDMDiscountGoods({ type: DiscountType.DISCOUNT, goods: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }

  @Builder
  getRefreshBuilder() {
    Row() {
      // HDMProgressLoading({ loadingWidth: 30 })
      HDMLoading()
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
  }

  build() {
    RelativeContainer() {
      if (this.loading) {
        HDMLoadingText({ title: 'Beautify' })
        // HDMLoading()
        // HDMProgressLoading()
      } else {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.getRefreshBuilder() }) {
          Scroll(this.scroller) {
            Column() {
              // 轮播图 + 搜索
              Stack({ alignContent: Alignment.Top }) {
                Swiper() {
                  ForEach(this.banners, (item: Banner) => {
                    Image(item.imgUrl)
                  })
                }
                .displayCount(
                  new BreakPointType({
                    // 1 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 1,
                    md: 2,
                    lg: 3
                  })
                    .getValue(this.breakPoint)
                )
                .itemSpace(
                  new BreakPointType({
                    // 0 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 0,
                    md: 10,
                    lg: 20
                  })
                    .getValue(this.breakPoint)
                )
                .indicator(
                  this.breakPoint === BreakPointEnum.sm ?
                  DotIndicator.dot()
                    .itemWidth(8)
                    .itemHeight(4)
                    .color('#33191919')
                    .selectedItemWidth(24)
                    .selectedItemHeight(4)
                    .selectedColor('#191919') : false
                )

                Row() {
                  Row({ space: 4 }) {
                    Image($r('[shop_basic].media.ic_public_search'))
                      .width(16)
                      .height(16)
                      .fillColor($r('[shop_basic].color.white'))
                    Text('搜索...')
                      .fontSize(14)
                      .fontColor($r('[shop_basic].color.white'))
                  }
                  .backgroundColor('#33191919')
                  .width('100%')
                  .height(40)
                  .borderRadius(20)
                  .padding({ left: 12 })
                }
                .padding({
                  left: 16,
                  right: 16,
                  top: this.topHeight
                })
              }
              .width('100%')


              // 分类
              Column({ space: 10 }) {
                // 分类
                List({
                  space: new BreakPointType({
                    // 0 手机
                    // 2 折叠屏
                    // 3 平板
                    sm: 14,
                    md: 36,
                    lg: 72
                  })
                    .getValue(this.breakPoint)
                }) {
                  ForEach(this.categories, (item: CategoryItem) => {
                    ListItem() {
                      Column() {
                        Image(item.picture)
                          .width(56)
                          .aspectRatio(1)
                        Text(item.name)
                          .fontSize(10)
                          .fontColor('#CC191919')
                      }
                      .width(60)
                      .height(80)
                      .borderRadius(30)

                      .clip(true)
                      .backgroundImage(item.picture)
                      .backgroundImageSize(ImageSize.Contain)
                      .backgroundImagePosition(Alignment.Center)
                      .backgroundBlurStyle(
                        BlurStyle.BACKGROUND_ULTRA_THICK,
                        { scale: 0.25 }
                      )
                    }
                  })
                }
                .width('100%')
                .height(92)
                .scrollBar(BarState.Off)
                .listDirection(Axis.Horizontal)
                .alignListItem(ListItemAlign.Center)

                // 特惠推荐
                Column({ space: 10 }) {
                  Image($r('app.media.home_cmd_title'))
                    .width(150)
                    .height(20)
                  Row() {
                    Image($r('app.media.home_cmd_inner'))
                      .width(86)
                      .height(116)
                    List({
                      space: new BreakPointType({
                        // 0 手机
                        // 2 折叠屏
                        // 3 平板
                        sm: 14,
                        md: 36,
                        lg: 72
                      })
                        .getValue(this.breakPoint)
                    }) {
                      ForEach(this.saleGoods, (item: HDMGoodsItem) => {
                        ListItem() {
                          HDMDiscountGoods({ goods: item })
                        }
                      })
                    }
                    .layoutWeight(1)
                    .width('100%')
                    .height(116)
                    .backgroundColor($r('[shop_basic].color.white'))
                    .borderRadius({
                      topRight: 8,
                      bottomRight: 8
                    })
                    .padding({ right: 10, left: 10 })
                    .scrollBar(BarState.Off)
                    .listDirection(Axis.Horizontal)
                  }
                }
                .width('100%')
                .height(166)
                .backgroundImage($r('app.media.home_cmd_sm'))
                .backgroundImageSize(ImageSize.Cover)
                .borderRadius(8)
                .padding(10)
                .alignItems(HorizontalAlign.Start)

                // 爆款推荐+一站买全
                Row({ space: 10 }) {
                  this.DiscountBuilder({
                    title: '爆款推荐',
                    subTitle: '最受欢迎',
                    bg: '#EDF1FB',
                    list: this.hotGoods
                  })
                  this.DiscountBuilder({
                    title: '一站买全',
                    subTitle: '精心优选',
                    bg: '#FCF6EA',
                    list: this.oneGoods
                  })
                }

                // 新鲜好物
                Column({ space: 10 }) {
                  Image($r('app.media.home_new'))
                    .width(146)
                    .height(19)
                  List({
                    space: new BreakPointType({
                      // 0 手机
                      // 2 折叠屏
                      // 3 平板
                      sm: 14,
                      md: 36,
                      lg: 72
                    })
                      .getValue(this.breakPoint)
                  }) {
                    ForEach(this.newGoods, (item: HDMGoodsItem) => {
                      ListItem() {
                        HDMDiscountGoods({ type: DiscountType.NEW, goods: item })
                      }
                    })
                  }
                  .width('100%')
                  .height(116)
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)
                }
                .width('100%')
                .height(156)
                .padding(10)
                .backgroundColor('#F7EFF5')
                .borderRadius(8)
                .alignItems(HorizontalAlign.Start)

                // 推荐商品
                WaterFlow() {
                  LazyForEach(this.recommendDataSource, (item: HDMGoodsItem) => {
                    FlowItem() {
                      HDMGoods({ goods: item })
                    }
                  })
                }
                .columnsTemplate(new BreakPointType({
                  // 0 手机
                  // 2 折叠屏
                  // 3 平板
                  sm: "1fr 1fr",
                  md: "1fr 1fr 1fr",
                  lg: "1fr 1fr 1fr 1fr"
                })
                  .getValue(this.breakPoint))
                .columnsGap(8)
                .rowsGap(10)

              }
              .padding({
                left: 8,
                right: 8,
                bottom: 10,
                top: 10
              })
            }
          }
          .scrollBar(BarState.Off)
          .onDidScroll((xOffset: number, yOffset: number,) => {
            // 纵向滚动偏移量
            this.yOffset += yOffset // 总偏移量计算
            // 边界值
            if (this.yOffset > this.topHeight && this.yOffset < (this.topHeight + 40)) {
              this.searchOpacity = (this.yOffset - this.topHeight) / 40 // 过度
            } else if (this.yOffset >= (this.topHeight + 40)) {
              this.searchOpacity = 1 // 显示
            } else {
              this.searchOpacity = 0 // 隐藏
            }

          })
          .onReachEnd(async () => {
            // 获取数据
            if (!this.isReachLoad && !this.isFinished) {
              this.isReachLoad = true // 上车把门焊死
              await this.getRecommend()
              this.isReachLoad = false // 把门打开
            }
          })
        }
        .onRefreshing(async () => {
          await this.getHomeData(true) // 6个接口的数据
          this.page = 1 // 推荐数据页码为1
          this.recommendDataSource.loadData([]) // 清空数据
          this.isFinished = false // 没有结束
          this.isReachLoad = false // 重新设置为初始状态
          this.isRefreshing = false
        })

      }


      // 搜索 随着 滚动条的滚动 透明度变化
      Row() {
        Row({ space: 4 }) {
          Image($r('[shop_basic].media.ic_public_search'))
            .width(16)
            .height(16)
            .fillColor($r('[shop_basic].color.white'))
          Text('搜索...')
            .fontSize(14)
            .fontColor($r('[shop_basic].color.white'))
        }
        .backgroundColor('#33191919')
        .width('100%')
        .height(40)
        .borderRadius(20)
        .padding({ left: 12 })
        .onClick(() => {
          this.stackPath.pushPath({
            name: PAGE_PATH.SEARCH_PAGE
          })
        })
      }
      .padding({
        left: 16,
        right: 16,
        top: this.topHeight,
        bottom: this.topHeight
      })
      .opacity(this.searchOpacity)
      .backgroundColor($r("[shop_basic].color.white"))
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [["#ffdebfee", 0], [$r("[shop_basic].color.white"), 1]]
      })

      // 向上的小火箭
      Row() {
        Image($r("app.media.home_top"))
          .width(30)
          .aspectRatio(1)
          .fillColor("#0095d3")
      }
      .visibility(this.yOffset > 100 ? Visibility.Visible : Visibility.None)
      .justifyContent(FlexAlign.Center)
      .width(40)
      .aspectRatio(1)
      .borderRadius(20)
      .backgroundColor("#fff8f9fa")
      .alignRules({
        right: {
          anchor: '__container__',
          align: HorizontalAlign.End
        },
        bottom: {
          anchor: '__container__',
          align: VerticalAlign.Bottom
        }
      })
      .margin({
        right: 20,
        bottom: 80
      })
      .onClick(() => {
        this.scroller.scrollEdge(Edge.Top)
      })
    }
  }
}