@Entry
@Component
export struct PropCase {

  // 父子单向同步Prop
  // 1. @Prop装饰的变量可以和父组件建立单向的同步关系。@Prop装饰的变量是可变的，
  // 但是变化不会同步回其父组件。
  // 2. Prop 支持类型和State修饰符基本一致，并且Prop可以给初始值，也可以不给.
  // 3. 注意：子组件仍然可以改自己，更新UI，但不会通知父组件(单向)，父组件改变后会覆盖子组件自己的值

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

        PropChild({
          money: this.money
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct PropChild {
  @Prop
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
