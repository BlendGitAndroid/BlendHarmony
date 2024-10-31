@Preview
@Component
export struct MTTop {
  // 第三个是可选参数
  @Builder
  NavItem(active: boolean, title: string, subTitle?: string) {
    Column() {
      Text() {
        // Text文本下面能放置span标签，里面还是横着排布的
        Span(title)
        if (subTitle) {
          Span(` ${subTitle}`)
            .fontSize(10)
            .fontColor(active ? $r("app.color.black") : $r("app.color.un_select_color"))
        }
      }
      .layoutWeight(1)
      .fontColor(active ? $r("app.color.black") : $r("app.color.un_select_color"))
      .fontWeight(active ? FontWeight.Bold : FontWeight.Normal)

      // 下划线
      Divider()
        .height(1)
        .width(20)
        .backgroundColor(active ? $r("app.color.select_border_color") : 'transparent')
    }
    .width(73)
    .padding({
      top: 3
    })
  }

  build() {
    Row() {
      this.NavItem(true, "点菜")
      this.NavItem(false, "评价", "176")
      this.NavItem(false, "商家")

      Row() {
        Image($r('app.media.ic_public_search'))
          .width(14)
          .aspectRatio(1)
          .fillColor($r("app.color.search_font_color"))
        Text('请输入菜品名称')
          .fontSize(12)
          .fontColor($r("app.color.search_back_color"))
      }
      .backgroundColor($r("app.color.search_back_color"))
      .height(25)
      .borderRadius(13)
      .padding({
        left: 5,
        right: 5
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height(40)
    .padding({
      left: 15,
      right: 15
    })
    .border({
      // 设置边框
      width: {
        bottom: 0.5
      },
      color: $r("app.color.top_border_color")
    })
  }
}
