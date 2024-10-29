@Entry
@Component
export struct BuildParamCase {
  // 类似于VUE的插槽
  // 1.把UI结构体的函数(Builder修饰的函数)当成参数传入到组件中，让组件放入固定的位置去渲染
  // 2.子组件接收传入的函数的修饰符/装饰器叫做BuilderParam
  // 3.Builder可以实现轻量级的UI复用

  // 使用BuilderParam的步骤
  // - 前提：需要出现父子组件的关系
  // - 前提：BuilderParam应出现在子组件中
  // - 1. 子组件声明  @BuilderParam  getContent: () => void
  // - 2. BuilderParam的参数可以不给初始值，如果给了初始值， 就是没有内容的默认内容
  // - 3. 父组件传入的时候，它需要用builder修饰的函数又或者是 一个箭头函数中包裹着
  // - 4. 调用builder函数的逻辑

  // 尾随闭包,Column () {  } 中大括号就是尾随闭包的写法.当我们
  // 的组件只有一个BuilderParam的时候，此时可以使用尾随闭包的语法 也就是像我们原来使用Column
  // 或者Row组件时一样，直接在大括号中传入

  @Builder
  leftBuilder() {
    Image($r('sys.media.ohos_ic_compnent_titlebar_back'))
      .width(20)
  }

  @Builder
  centerBuilder() {
    Row() {
      Text('最新推荐')

      Text('🔥')
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  rightBuilder() {
    Image($r('sys.media.ohos_ic_public_scan'))
      .width(20)
  }

  @State
  isOn: boolean = false

  @Builder
  secondRightContent() {
    Toggle({
      type: ToggleType.Switch,
      isOn: $$this.isOn
    })
  }

  build() {
    Row() {
      Column() {

        MyBuilderParamChild({
          leftContent: this.leftBuilder,
          centerContent: this.centerBuilder,
          rightContent: this.rightBuilder
        })

        Text('' + this.isOn)
        MySecondBuilderParamChild({
          leftText: '我是左边',
          bgc: '#ff4400',
          // rightContent: () => {
          //   this.secondRightContent() // 只有这样写,才能获取到this的值,箭头语法
          // }
        }) {
          this.secondRightContent() // 尾随闭包
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}


@Component
struct MyBuilderParamChild {
  @BuilderParam
  leftContent: () => void = this.defaultLeftParam
  @BuilderParam
  centerContent: () => void = this.defaultCenterParam
  @BuilderParam
  rightContent: () => void = this.defaultRightParam

  @Builder
  defaultLeftParam() {
    Text('返回')
  }

  @Builder
  defaultCenterParam() {
    Text('首页')
      .layoutWeight(1)
      .textAlign(TextAlign.Center)
  }

  @Builder
  defaultRightParam() {
    Text('确定')
  }

  build() {
    Row() {
      // 左边
      this.leftContent()

      // 中间
      this.centerContent()

      // 右边
      this.rightContent()
    }
    .width('100%')
    .backgroundColor(Color.Pink)
    .padding(20)
  }
}

@Builder
function MyBuilderFunction() {
}

@Component
struct MySecondBuilderParamChild {
  @Prop
  leftText: string = '默认内容'
  @Prop
  bgc: string = '#ccc'
  // 如果子组件有且只有一个builderParam，就可以用尾随闭包
  @BuilderParam
  rightContent: () => void = MyBuilderFunction // 必须定义一个值

  build() {
    Row() {
      Text(this.leftText)

      if (this.rightContent) {
        this.rightContent()
      }

    }
    .width('100%')
    .padding(20)
    .backgroundColor(this.bgc)
    .borderRadius(6)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}