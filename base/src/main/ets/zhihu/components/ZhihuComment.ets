import { ReplyItemModel } from '../models'

@Component
export struct ZhihuComment {
  @ObjectLink
  childItem: ReplyItemModel

  renderLog(index: number) {
    // 第一个是标识，不要放打印的内容
    console.log('renderLog', index)
    return Color.Transparent
  }

  build() {
    Row({ space: 16 }) {
      //   2.1图
      Image(this.childItem.avatar)
        .width(60)
        .borderRadius(60)
        .backgroundColor(this.renderLog(1))

      //   2.2右侧容器
      Column({ space: 16 }) {
        // 2.2.1人名
        Text(this.childItem.author)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(this.renderLog(2))

        // 2.2.2评论内容
        Text(this.childItem.content)
          .backgroundColor(this.renderLog(3))

        // 2.2.3下侧容器
        Row() {
          Text(`${this.childItem.time}·IP:${this.childItem.area}`)
            .fontSize(12)
            .fontColor('#ccc')
          Row() {
            Image($r('app.media.ic_like'))
              .width(16)
              .fillColor(this.childItem.likeFlag ? Color.Red : '#ccc')
              .backgroundColor(this.renderLog(4))

            Text(this.childItem.likeNum + '')
              .fontSize(12)
              .fontColor(this.childItem.likeFlag ? Color.Red : '#ccc')
              .backgroundColor(this.renderLog(5))

          }.onClick(() => {
            // 改变childItem的数据
            if (this.childItem.likeFlag) {
              this.childItem.likeNum--
            } else {
              this.childItem.likeNum++
            }
            this.childItem.likeFlag = !this.childItem.likeFlag
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(20)
    .alignItems(VerticalAlign.Top)
  }
}
