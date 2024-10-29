@Component
export struct TrackCase {
  @State
  message: string = 'Hello World';

  // 主要用于性能优化
  // @Track应用于class对象的属性级更新。@Track装饰的属性变化时,只会触发该属性关联的Ul更新。

  // Track的作用只更新对象中的某些字段， Track修饰符用来作用在class中的某些字段，
  // 只有被标记的字段才会更新，并且没有被Track标记的字段则UI不会被渲染
  // 场景：
  // 假如只想根据对象中某个字段来更新对应的视图,就可以使用Track
  // Track指定了哪些属性变化,就会渲染相应的视图,其他的地方不会被渲染

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
