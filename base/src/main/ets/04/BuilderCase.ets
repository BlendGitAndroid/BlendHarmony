import {
  LeftAndRight,
  MyLayoutBuilder,
  MyLayoutBuilderObject,
  MyLayoutBuilderObjectChange,
  MyLayoutBuilderObjectWrapper
} from './builders/MyLayoutBuilder'

@Entry
@Component
export struct BuilderCase {
  // 如果你不想在直接抽象组件，ArkUI还提供了一种更轻量的UI元素复用机制 `@Builder`，可以将重复使用的UI元素抽象成一个方法，
  // 在 `build` 方法里调用。称之为自定义构建函数.
  // 只要使用Builder修饰符修饰的内容，都可以做成对应的UI描述
  // 就是无状态组件,其实是一个函数

  // 参数传递规则
  // 自定义构建函数的参数传递有按值传递和按引用传递两种,均需遵守以下规则:
  // 1. 参数的类型必须与参数声明的类型一致,不允许undefined, null和返回undefined,null的表达式。
  // 2. 在@Builder修饰的函数内部，不允许改变参数值。
  // 3. @Builder内UI语法遵循UI语法规则。
  // 4. 只有传入一个参数，且参数需要直接传入对象字面量才会按引用传递该参数，其余传递方式均为按值传递。

  // 自定义构建函数的参数传递有[按值传递]和[按引用传递]两种，均需遵守以下规则：
  // 1. 参数的类型必须与参数声明的类型一致，不允许undefined、null和返回undefined、null的表达式。
  // 2. 在自定义构建函数内部，不允许改变参数值。
  // 3. @Builder内UI语法遵循[UI语法规则]。
  // 我们发现，使用了string这种基础数据类型，即使它属于用State修饰的变量，也不会引起UI的变化
  //
  // 按引用传递参数时，传递的参数可为状态变量，且状态变量的改变会引起@Builder方法内的UI刷新。
  // ArkUI提供**$$**作为按引用传递参数的范式。

  @State
  list: string[] = ['A', 'B', 'C', 'D']
  @State
  canChange: string = "能改变"
  @State
  leftAnd: LeftAndRight = {
    leftText: "左边",
    rightText: "右边"
  }

  @Builder
  MyBuilderOption(item: string) {
    Row() {
      Text(`${item}.选项${item}`)
        .MyTextColor()
    }.MyOptionStyle()
  }

  build() {
    Row() {
      Column({ space: 20 }) {

        ForEach(this.list, (item: string) => {
          this.MyBuilderOption(item)
        })

        MyLayoutBuilder('按值传递', this.canChange) // 按值传递不具备响应式

        MyLayoutBuilderObject({
          // 按照引用传递必须要用对象字面量
          leftText: '对象字面量',
          rightText: this.canChange
        })

        // 对象字面量
        MyLayoutBuilderObjectChange({
          leftText: '对象字面量',
          rightText: this.canChange
        })

        MyLayoutBuilderObjectChange(this.leftAnd)

        MyLayoutBuilderObjectWrapper({ leftAndRight: this.leftAnd })

        Button("修改右边的值")
          .onClick(() => {
            this.canChange = "我改变了"
            this.leftAnd.rightText = "我右边改变了"
          })

      }.width('100%')
      .padding(20)
    }
    .height('100%')
  }
}

// @Styles封装组件的时候拓展通用样式
@Styles
function MyOptionStyle() {
  .width('100%')
  .padding(20)
  .backgroundColor(Color.Pink)
  .borderRadius(6)
}

@Extend(Text)
function MyTextColor() {
  .fontColor('#fff')
}
