@Preview
@Component
export struct MeituanFooter {
  @State message: string = 'Hello World';

  build() {
    Row(){
      Text('底部')
        .width('100%')
        .fontColor(Color.Black)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#d2cf0b')

  }
}