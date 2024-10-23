@Preview
@Component
struct MeituanMain {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text("主体")
    }
    .width('100%')
    .height('100%')
    .backgroundColor('blue')
  }
}

export {
  MeituanMain
}
