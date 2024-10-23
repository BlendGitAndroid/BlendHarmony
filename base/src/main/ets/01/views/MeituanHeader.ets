@Preview
@Component
export default  struct MeituanHeader {
  @State message: string = 'Hello World';

  build() {
    Row(){
      Text('头部')
        .width('100%')
        .fontColor(Color.Black)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#ff4400')

  }
}
