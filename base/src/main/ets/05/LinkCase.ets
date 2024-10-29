@Entry
@Component
export struct LinkCase {
  // 父子双向同步Link
  // 1. Link修饰符则是双向的数据传递，只要使用Link修饰了传递过来的数据，这个时候就是双向同步了.
  // 2. 注意: Link修饰符不允许给初始值.
  // 3. 被Link修饰的数据,必须使用State或Prop来修饰

  @State
  money: number = 100

  build() {
    Row() {
      Column({ space: 20 }) {
        Text('父组件:' + this.money)
        Button("存钱")
          .onClick(() => {
            this.money += 1;
          })

        LinkChild({
          money: this.money
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct LinkChild {
  @Link
  money: number

  build() {
    Column({ space: 20 }) {
      Text('从父组件拿来的:' + this.money)
      Button('花100块')
        .onClick(() => {
          this.money -= 10
        })
    }
    .padding(20)
    .backgroundColor(Color.Pink)

  }
}