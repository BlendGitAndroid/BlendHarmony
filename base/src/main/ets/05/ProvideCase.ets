@Entry
@Component
export struct ProvideCase {
  // 父子双向
  // 如果组件层级特别多，跨组件传递状态数据来实现双向同步@Provide和 @Consume
  // 1.在不指定Provide名称的情况下，需要使用相同的名字来定义和接收数据
  // 2.Consume不能有默认值
  // 3.如果组件已有该命名变量，可以起别名进行提供/接收

  @Provide
  dataInfo: MoneyInfo = {
    money: 200,
    bank: '中国银行'
  }
  @Provide("nameProvide")
  name: string = "起别名"

  build() {
    Row() {
      Column({ space: 20 }) {
        Text('父组件:' + this.dataInfo.money)
        Text(this.name)
        Button('存100块')
          .onClick(() => {
            this.dataInfo.money += 10
          })

        ProvideChild1()
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ProvideChild1 {
  @Consume
  dataInfo: MoneyInfo
  @Consume
  nameProvide: string

  build() {
    Column() {
      Text('子组件1:' + this.dataInfo.money)
      Text(this.nameProvide)
      Button('花100块')
        .onClick(() => {
          this.dataInfo.money -= 100
        })
      ProvideChild2()
    }
    .padding(20)
    .backgroundColor(Color.Pink)
  }
}

@Component
struct ProvideChild2 {
  @Consume
  dataInfo: MoneyInfo
  @Consume("nameProvide")
  name: string

  build() {
    Column() {
      Text('子组件1的组件:' + this.dataInfo.money)
      Text(this.name)
      Button('花100块')
        .onClick(() => {
          this.dataInfo.money -= 100
        })
    }
    .padding(20)
    .backgroundColor(Color.Red)
  }
}

interface MoneyInfo {

  money: number
  bank: string

}
