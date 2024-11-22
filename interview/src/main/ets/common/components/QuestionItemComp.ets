import { HmTag } from '.'
import { QuestionItem } from '../../model'

@Preview
@Component
export struct QuestionItemComp {
  @Require
  @Prop
  item: QuestionItem = {} as QuestionItem

  build() {
    Column({ space: 10 }) {
      Row() {
        HmTag({ difficulty: this.item.difficulty })
        Text(this.item.stem)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(14)
      }

      RowSplit() {
        Text('点赞 ' + this.item.likeCount)
          .grayText(true)
        Text('浏览 ' + this.item.views)
          .grayText()
        if (this.item.readFlag === 1) {
          Text('已看过')
            .grayText()
        }
      }
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(80)
    .padding({
      left: 16,
      right: 16
    })
  }
}

@Extend(Text)
function grayText(isStart: boolean = false) {
  .fontSize(12)
  .fontColor($r('app.color.common_gray_01'))
  .padding({ left: isStart ? 0 : 12, right: 12 })
}