@Preview
@Component
export struct HDMNavBar {
  @Prop
  title: string = ""
  // 左图标
  @Prop
  leftIcon: ResourceStr = $r("app.media.ic_public_left")
  // 右图标
  @Prop
  rightIcon: ResourceStr = $r("app.media.ic_public_more")
  @Prop
  showLeftIcon: boolean = true
  @Prop
  showRightIcon: boolean = false
  color: ResourceColor = $r("app.color.black") // 字体颜色
  bg: ResourceColor = $r("app.color.white")
  // 左侧触发
  onLeftClick: () => void = () => {
  }
  // 点击右侧
  onRightClick: () => void = () => {
  }

  @Builder
  defaultBuilder() {
  }

  // 点击右侧
  @BuilderParam
  // 把@Builder当成参数传递过来，直接调用这个函数, 传入的UI就会放入到调用的位置
  customTitle: () => void = this.defaultBuilder // 坑点- 编辑器可以不给初始值 预览的时候会因为没有给初始值而无法预览

  build() {
    RelativeContainer() {
      if (this.showLeftIcon) {
        Image(this.leftIcon)
          .width(24)
          .aspectRatio(1)
          .fillColor(this.color)
          .alignRules({
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            },
          })
          .onClick(() => {
            this.onLeftClick()
          })
          .zIndex(2)
      }
      // 有标题时才渲染
      if (this.title) {
        Text(this.title)
          .fontColor(this.color)
          .alignRules({
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            },
            middle: {
              anchor: '__container__',
              align: HorizontalAlign.Center
            }
          })
      }
      // 如果传入了builderParam 调用一下
      if (this.customTitle) {
        Row() {
          this.customTitle()
        }
        .alignRules({
          center: {
            anchor: '__container__',
            align: VerticalAlign.Center
          },
          middle: {
            anchor: '__container__',
            align: HorizontalAlign.Center
          }
        })

      }

      if (this.showRightIcon) {
        Image(this.rightIcon)
          .width(24)
          .aspectRatio(1)
          .fillColor(this.color)
          .alignRules({
            right: {
              anchor: '__container__',
              align: HorizontalAlign.End
            },
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            },
          })
          .onClick(() => {
            this.onRightClick()
          })
      }

    }
    .padding({
      left: 10,
      right: 10
    })
    .height(50)
    .width("100%")
    .backgroundColor(this.bg)
  }
}