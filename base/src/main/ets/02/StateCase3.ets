@Entry
@Component
export struct StateCase3 {
  // 双向绑定: 数据和视图双向同步-数据变化-视图更新，视图更新，-数据更新
  // $$语法：内置组件双向同步
  // 当前$$支持基础类型变量，以及@State、@Link和@Prop装饰的变量。
  // 上述组件中有的双向组件是属性，有的双向绑定是参数

  @State
  isChecked: boolean = false
  @State
  myDate: Date = new Date('2024-05-01')
  @State
  myRatio: boolean = false
  @State
  mySearch: string = ''
  @State
  myToggle: boolean = false
  @State
  mySelect: string = '请选择'

  build() {
    Column({ space: 12 }) {
      Column() {
        Text('Checkbox双向绑定')
        Checkbox()
          .select($$this.isChecked)
        Text('' + this.isChecked)
      }

      MyDivider()

      Column() {
        Text('DatePicker双向绑定')
        DatePicker({
          selected: $$this.myDate
        })
        Text('' + this.myDate)
      }

      MyDivider()

      Column() {
        Text('Radio双向绑定')
        Radio({
          value: 'radio',
          group: 'radioSelect'
        })
          .checked($$this.myRatio)
        Text('' + this.myRatio)
      }

      MyDivider()

      Column() {
        Text('Search双向绑定')
        Search({
          value: $$this.mySearch
        })
        Text('' + this.mySearch)
      }

      MyDivider()
      Column() {
        Text('Toggle双向绑定')
        Toggle({
          type: ToggleType.Switch,
          isOn: $$this.myToggle
        })
        Text('' + this.myToggle)
      }

      MyDivider()

      Column() {
        Text('Select双向绑定')
        Select([{ value: 'aaa' },
          { value: 'bbb' },
          { value: 'ccc' },
          { value: 'ddd' }])
          .value($$this.mySelect)
        Text('' + this.mySelect)
      }
    }
    .width("100%")
    .height("100%")
  }
}

@Component
struct MyDivider {
  build() {
    Divider().height(5).backgroundColor(Color.Pink)
  }
}
