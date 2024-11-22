interface HcTagInfo {
  text: string

  color: ResourceColor
}

// 描述tag标签配置信息的对象
const infoMap: Record<number, HcTagInfo> = {
  1: { text: '简单', color: $r('app.color.common_green') },
  2: { text: '简单', color: $r('app.color.common_green') },
  3: { text: '一般', color: $r('app.color.common_blue') },
  4: { text: '一般', color: $r('app.color.common_blue') },
  5: { text: '困难', color: $r('app.color.common_main_color') }
}


@Component
export struct HmTag {
  @Prop
  difficulty: number = 1

  // 自定义文字内容 + 文字颜色
  @Prop
  text: string = ''

  @Prop
  color: ResourceColor = ''

  build() {
    // 这里使用[]来获取值
    Text(this.text || infoMap[this.difficulty].text)
      .fontColor(this.color || infoMap[this.difficulty].color)
      .fontSize(10)
      .padding({
        left: 6,
        right: 6
      })
      .height(18)
      .borderRadius(2)
      .textAlign(TextAlign.Center)// 最小宽度
      .constraintSize({
        minWidth: 34
      })
      .backgroundColor($r('app.color.common_gray_bg'))
  }
}