//1.new LocalStorage(数据)
const localUserInfo = LocalStorage.getShared()

// 2.传递给页面
@Entry(localUserInfo)
@Component
struct LocalStorageCase01 {

  // LocalStorage是页面级的UI状态存储,存储在内存中，通过 `@Entry` 装饰器接收的参数可以在页面内共享同一
  // 个 LocalStorage实例。 `LocalStorage` 也可以在 `UIAbility` 内，页面间共享状态。
  // - 创建 `LocalStorage` 实例：`const storage = new LocalStorage({ key: value })`
  // - 单向 `@LocalStorageProp('user')` 组件内可变
  // - 双向 `@LocalStorageLink('user')` 全局均可变

  // 3.使用localUserInfo
  @LocalStorageLink('avtar')
  avtar: ResourceStr = ''

  @LocalStorageLink('nickName')
  nickName: ResourceStr = ''

  @LocalStorageLink('gender')
  gender: ResourceStr = ''

  @LocalStorageLink('age')
  age: ResourceStr = ''

  build() {
    Column() {
      Row() {
        Image($r('sys.media.ohos_ic_back'))
          .width(20)
          .aspectRatio(1)

        Text('个人信息')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('确定')
      }.width('100%')
      .padding(20)
      .alignItems(VerticalAlign.Center)

      Row() {
        Text('头像：')
        Image(this.avtar)
          .width(40)
      }.width('100%')
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('昵称：')
        TextInput({ text: $$this.nickName })
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .backgroundColor('#fff')
          .padding({
            right: 0
          })
      }.width('100%')
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('性别：')
        TextInput({ text: $$this.gender })
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .backgroundColor('#fff')
          .padding({
            right: 0
          })
      }.width('100%')
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text('年龄：')
        TextInput({ text: $$this.age })
          .textAlign(TextAlign.End)
          .layoutWeight(1)
          .backgroundColor('#fff')
          .padding({
            right: 0
          })
      }.width('100%')
      .padding(20)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
  }
}
