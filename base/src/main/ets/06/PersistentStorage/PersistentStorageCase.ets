// 需要提前声明
PersistentStorage.persistProp('token', '666666')

// UI层面使用
// 1.作用
// 从磁盘上去读，读不到就给666666,读到了就展示磁盘的PersistentStorage
// 2.作用
// 将AppStorage中的token属性写入到磁盘中！

// UI和业务逻辑不直接访问 `PersistentStorage` 中的属性，所有属性访问都是对 `AppStorage` 的访问，
// `AppStorage` 中的更改会自动同步到 `PersistentStorage`。
// 也就是，我们和之前访问AppStorage是一样的，只不过需要提前使用PersistentStorage来声明
// 注意： 如果用了持久化, 那么AppStorage读取出来的对象实际上是PersistentStorage存储的json字符串
// 如果没用持久化 。那么读取出来的对象就是AppStorage对象
// PersistentStorage的持久化变量最好是小于2kb的数据，不要大量的数据持久化，因为PersistentStorage写入磁盘的操作是同步的，
// 大量的数据本地化读写会同步在UI线程中执行，影响UI渲染性能。如果开发者需要存储大量的数据，建议使用数据库api。

@Entry
@Component
struct PersistentStorageCase {
  @StorageLink('token')
  message: string = 'Hello World';

  aboutToAppear(): void {
    const token = AppStorage.get<string>('token')
    this.message = token!
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('登录')
          .onClick(() => {
            AppStorage.setOrCreate('token', '123456')
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}