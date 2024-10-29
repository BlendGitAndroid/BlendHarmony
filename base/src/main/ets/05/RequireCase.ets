@Entry
@Component
export struct RequireCase {
  // Require修饰符只能作用在两个修饰符前面,Prop和BuilderParam

  @State message: string = 'Hello World';

  @Builder
  parentContent() {
    Text('builderParam')
  }

  build() {
    Row() {
      Column() {
        RequireChild({
          message: this.message
        }) {
          this.parentContent()
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Builder
function MyContentFunction(): void {
}

@Component
struct RequireChild {
  // 1.Prop
  @Require
  @Prop
  message: string

  // 2.BuilderParam
  @Require
  @BuilderParam
  defaultContent: () => void = MyContentFunction

  build() {
    Column() {
      Text(this.message)
      this.defaultContent()
    }
  }
}