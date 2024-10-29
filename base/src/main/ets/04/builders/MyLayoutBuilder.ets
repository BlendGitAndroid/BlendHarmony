// 全局的自定义Builder函数可以被引用，也就是你的一些公共的builder函数可以抽提出来，
// 像使用函数那样来复用一些样式

@Builder
export function MyLayoutBuilder(leftText: string, rightText: string) {

  Row() {
    Text(leftText)
      .fontColor(Color.White)
    Text(rightText)
      .fontColor(Color.White)
  }
  .width("100%")
  .padding(20)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.Blue)
  .borderRadius(8)

}

@Builder
export function MyLayoutBuilderObject(leftAndRight: LeftAndRight) {

  Row() {
    Text(leftAndRight.leftText)
      .fontColor(Color.White)
    Text(leftAndRight.rightText)
      .fontColor(Color.White)
  }
  .width("100%")
  .padding(20)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.Blue)
  .borderRadius(8)

}

@Builder
export function MyLayoutBuilderObjectChange($$: LeftAndRight) {

  Row() {
    Text($$.leftText)
      .fontColor(Color.White)
    Text($$.rightText)
      .fontColor(Color.White)
  }
  .width("100%")
  .padding(20)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.Blue)
  .borderRadius(8)

}

// ArkUI提供$$作为按引用传递参数的范式。
// 需要在builder中传入一个对象， 该对象使用$$(可使用其他字符)的符号来修饰，此时数据具备响应式了
@Builder
export function MyLayoutBuilderObjectWrapper($$: LeftAndRightWrapper) {

  Row() {
    Text($$.leftAndRight.leftText)
      .fontColor(Color.White)
    Text($$.leftAndRight.rightText)
      .fontColor(Color.White)
  }
  .width("100%")
  .padding(20)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.Blue)
  .borderRadius(8)

}

export interface LeftAndRight {
  leftText: string,
  rightText: string
}

export interface LeftAndRightWrapper {
  leftAndRight: LeftAndRight,
}

