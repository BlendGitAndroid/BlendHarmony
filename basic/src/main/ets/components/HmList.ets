@Preview
@Component
struct HmList {
  // 表示是否正在请求下一页数据
  @State
  loading: boolean = false
  // 是否正在刷新
  @State
  refreshing: boolean = false
  // 服务器上没有更多数据了
  @Prop
  finished: boolean = false
  // 原始数据
  @Prop
  dataSource: object[] = []
  @Prop
  finishedText: string = '没有更多数据了'
  @Prop
  loadingText: string = '拼命加载中'
  // 刷新的状态
  @State
  status: RefreshStatus = RefreshStatus.Inactive
  // 定义插槽,每一个Item的显示
  @BuilderParam
  renderItem: (item: object) => void
  // 加载更多的回调
  onLoad: () => void = () => {
  }
  // 在刷新的回调
  onRefresh: () => void = () => {
  }

  getRefreshText() {
    switch (this.status) {
      case RefreshStatus.Inactive:
        return ''
      case RefreshStatus.Drag:
        return '继续下拉'
      case RefreshStatus.OverDrag:
        return '松手刷新'
      case RefreshStatus.Refresh:
        return '刷新中'
      default:
        return ''
    }
  }

  // 刷新头
  @Builder
  getRefreshBuilder() {
    Row({ space: 10 }) {
      LoadingProgress()
        .color($r('app.color.primary'))
        .width(40)
        .height(40)
      Text(this.getRefreshText())
        .fontColor($r('app.color.text_secondary'))
        .fontSize(14)
    }
    .justifyContent(FlexAlign.Center)
    .height(50)
    .width('100%')
  }

  @Builder
  getBottom() {
    Row({ space: 10 }) {
      if (this.finished) {
        // 此时应该没有动画的loading
        Text(this.finishedText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
      } else {
        Text(this.loadingText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        LoadingProgress()
          .width(20)
          .aspectRatio(1)
          .color($r("app.color.text_secondary"))
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    // 刷新组件
    Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshBuilder }) {
      List() {
        // 虚拟列表
        ForEach(this.dataSource, (item: object) => {
          ListItem() {
            this.renderItem(item)
          }
        })

        // 最后多增加一个Item,显示more
        ListItem() {
          this.getBottom()
        }

      }
      .onReachEnd(async () => { // 如果List已经滑动到底部
        if (this.loading) { // 如果正在请求下一页数据
          return
        }

        if (this.finished) { // 如果没有数据了
          return
        }

        this.loading = true
        await this.onLoad()
        this.loading = false
      })
    }
    .onStateChange(async (state) => { // 刷新组件的状态更新
      // 更新刷新状态
      this.status = state
      // 每次下拉刷新前, 要把旧的数据重置掉
      await this.onRefresh()
      // 再次请求第一页数据
      this.refreshing = false
    })
  }
}

export default HmList
