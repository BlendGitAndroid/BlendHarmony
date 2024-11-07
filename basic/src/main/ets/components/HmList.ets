@Preview
@Component
struct HmList {
  @State loading: boolean = false // 表示是否正在请求下一页数据
  @State refreshing: boolean = false
  // 💥不能写死, 外部传
  @Prop finished: boolean = false // 服务器上没有更多数据了
  // 💥taskList不能写死, 外部传
  @Prop dataSource: object[] = []
  // 💥💥onLoad 不能写死, 父组件传具体发请求的含糊
  onLoad: () => void = () => {
  }
  onRefresh: () => void = () => {
  }
  @Prop finishedText: string = '没有更多数据了'
  @Prop loadingText: string = '拼命加载中'
  @BuilderParam
  renderItem: (item: object) => void

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

  @Builder
  getRefreshBuilder() {
    // 控制 显示不同的文字, 自定义文字提示的
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

  @State status: RefreshStatus = RefreshStatus.Inactive

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
    Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshBuilder }) {
      List() {
        // 虚拟列表
        ForEach(this.dataSource, (item: object) => {
          ListItem() {
            // TaskItemCard({ taskItem: item }) // 插槽 BuilderParams
            this.renderItem(item)
          }
        })

        ListItem() {
          this.getBottom()
        }

      }
      .onReachEnd(async () => {
        if (this.loading) {
          return
        }

        if (this.finished) {
          return
        }

        this.loading = true
        await this.onLoad()
        this.loading = false
      })
    }
    .onStateChange(async (state) => {
      this.status = state
      //  每次下拉刷新前, 要把旧的数据重置掉
      await this.onRefresh() // 再次请求第一页数据
      this.refreshing = false
    })
  }
}

export default HmList
