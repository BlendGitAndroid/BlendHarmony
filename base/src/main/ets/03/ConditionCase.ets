import { promptAction } from '@kit.ArkUI'

@Entry
@Component
export struct ConditionCase {
  @State
  isShow: boolean = false
  @State
  selectValue: string = SelectIndexType['NoVip']
  @State
  selectValueIndex: SelectIndexType = SelectIndexType.NoVip

  build() {
    Row() {
      Column({ space: 20 }) {
        Toggle({
          type: ToggleType.Switch,
          isOn: $$this.isShow
        })

        if (this.isShow) {
          Image($r('app.media.b'))
            .width(100)
        } else {
          Image($r('app.media.a'))
            .width(100)
        }

        // Hidden虽然不展示，但是会占位置（不影响其他元素）
        Image($r('app.media.ic_public_cart'))
          .width(100)
          .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)

        // None不展示，也不会占位置
        Image($r('app.media.ic_public_cart'))
          .width(100)
          .visibility(this.isShow ? Visibility.Visible : Visibility.None)


        Column({space: 16}) {

          Row() {
            Text('开通会员: ')
            Select([{ value: SelectIndexType['NoVip'] },
              { value: SelectIndexType['VIP'] },
              { value: SelectIndexType['SVIP'] }])
              .layoutWeight(1)
              .value($$this.selectValue)
              .selected($$this.selectValueIndex)
              .onSelect((index: number, value: string) => {
                promptAction.showToast({
                  message: this.selectValue + " " + SelectIndexType.VIP
                })
              })
          }.width('60%')

          Row({ space: 16 }) {
            Image($r('app.media.a'))
              .width(60)
              .borderRadius(30)

            Text('Blend')
            if (this.selectValue === SelectIndexType.NoVip) {
              Text(SelectIndexType['NoVip'])
                .backgroundColor('#ccc')
                .MyTextExtend()
            } else if (this.selectValue === SelectIndexType.VIP) {
              // 开通VIP
              Text(SelectIndexType['VIP'])
                .backgroundColor('#ffddd515')
                .MyTextExtend()
            } else {
              // 开通SVIP
              Text(SelectIndexType['SVIP'])
                .backgroundColor('#ffbc1d1d')
                .MyTextExtend()
            }
          }.width('60%')

        }.width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}

enum SelectIndexType {
  NoVip = "未开通",
  VIP = "VIP",
  SVIP = "SVIP"
}

@Extend(Text)
function MyTextExtend() {
  .padding(
    {
      top: 4,
      bottom: 4,
      left: 12,
      right: 12
    }
  )
  .fontColor(Color.White)
  .borderRadius(16)
}
