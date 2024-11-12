import { QuestionItemComp } from '.'
import { promptAction, router } from '@kit.ArkUI'
import { PageData, QuestionItem, QuestionListParams, QuestionPageParams, SortType } from '../../model'
import { http } from '../utils/Http'
import { auth } from '../utils/Auth'
import { logger } from '../utils/Logger'

@Component
export struct QuestionListComp {
  // 下拉中
  @State
  isRefreshing: boolean = false
  // 加载中
  @State
  isLoading: boolean = false
  // 所有数据加载完成
  @State
  isFinished: boolean = false
  @State
  list: QuestionItem[] = []
  // 获取列表数据的参数
  @Prop typeId: number
  @Prop activeIndex: number
  @Prop index: number
  @Prop @Watch('onChangeSort') sort: SortType = SortType.Default

  onChangeSort() {
    //   是不是我要更新
    if (this.activeIndex === this.index) {
      this.isRefreshing = true
    }
  }

  @Prop
  // @Watch('changeKeyword')
  keyword: string = ''
  // async changeKeyword(){
  //   const res = await this.getQuestionList()
  //   // 不是追加是覆盖
  //   this.list = res.rows
  // }
  @State page: number = 1

  // 下拉刷新加载
  async onRefresh() {
    // //   模拟加载数据
    // setTimeout(() => {
    //   // TODO:加载数据
    //   this.isRefreshing = false
    // }, 1000)
    this.page = 1
    const res = await this.getQuestionList()
    // 不是追加是覆盖
    this.list = res.rows
    this.isRefreshing = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.isFinished = false
      // 让下一页数据加载同步
      this.page++
    }
    promptAction.showToast({
      message: '更新成功~'
    })
  }

  // 上拉滚动加载
  async onLoad() {
    //   模拟数据加载
    // setTimeout(() => {
    //   for (let i = 0; i < 10; i++) {
    //     this.list.push({} as QuestionItem)
    //   }
    //   if (this.list.length > 30) {
    //     this.isFinished = true
    //   }
    //   this.isLoading = false
    // }, 1000)
    const res = await this.getQuestionList()
    this.list.push(...res.rows)
    this.isLoading = false
    // 是否最后一页
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.page++
    }
  }

  // 获取列标数据的方法
  getQuestionList(): Promise<PageData<QuestionItem>> {
    return http.request<PageData<QuestionItem>>({
      // 经验之谈：1.请求的地址，2.请求的类型，3.请求的参数
      url: 'hm/question/list',
      // params - query参数 / data - body参数
      params: {
        type: this.typeId,
        questionBankType: 10,
        sort: this.sort,
        page: this.page,
        pageSize: 10,
        keyword: this.keyword
      } as QuestionListParams
    })

  }

  // loading展示的builder
  @Builder
  LoadMoreBuilder() {
    if (this.isLoading) {
      Row({ space: 4 }) {
        LoadingProgress()
          .width(20)
        Text('正在玩命的加载...')
          .fontColor($r('app.color.common_gray_01'))
      }
      .height(80)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.isFinished) {
      Text('我是有底线的~')
        .height(80)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.common_gray_01'))
    }
  }

  build() {
    //   1.下拉刷新-refresh
    //   2.上拉加载-list的3个周期
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(this.list, (item: QuestionItem) => {
          QuestionItemComp({
            item
          })
            .onClick(() => {
              // 不鉴权直接跳
              // router.pushUrl({
              //   url: 'pages/QuestionPage'
              // })
              // 鉴权 - 跳转页面
              auth.checkAuth({
                url: '@bundle:com.blend.harmony/interview/ets/pages/QuestionPage',
                params: {
                  item,
                  list: this.list
                } as QuestionPageParams
              })
            })
        })
        //   loading条展示
        this.LoadMoreBuilder()
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_border'),
        startMargin: 16,
        endMargin: 16
      })
      // 关闭弹簧模式
      .edgeEffect(EdgeEffect.None)
      .onReachEnd(() => {
        // 如果下拉中，加载完成，正在加载 都不能继续加载数据了！
        if (this.isLoading || this.isFinished || this.isRefreshing) {
          return
        }
        this.isLoading = true
        // 加载数据
        this.onLoad()
      })

      // 之前的：带弹簧模式，会有2次触底
      // .onScrollStart(() => {
      //   //   开始滑动
      // })
      // .onReachEnd(() => {
      //   //   到底部了(2次)
      // })
      // .onScrollStop(() => {
      //   //   停止滑动
      // })
    }
    .onRefreshing(() => {
      this.onRefresh()
    })
  }
}