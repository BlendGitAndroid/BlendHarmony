@Entry
@Component
export struct AreaChangeCase {
  build() {

    Column() {
      Column() {

        Stack() {
          Image("https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png")
            .width(180)
            .onAreaChange((oldValue: Area, newValue: Area) => {
              AlertDialog.show({
                // 获取组件的大小
                message: `${newValue.width} + " " + ${newValue.height}`
              })
            })


          Text("鸿蒙版")
            .fontSize(16)
            .fontColor(Color.Gray)
            .translate({
              y: -5,
              x: 60
            })
        }

        Row() {
          TextInput({ placeholder: "请输入" })
            .layoutWeight(1)
            .borderRadius({
              topLeft: 4,
              bottomLeft: 4
            })
            .margin({
              left: 16
            })
            .backgroundColor(Color.Pink)
          Button("百度一下")
            .type(ButtonType.Normal)
            .borderRadius({
              topRight: 4,
              bottomRight: 4
            })
            .margin({
              right: 16
            })
        }.width("100%")
        .margin({
          top: 16
        })
      }
      .width("100%")
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .backgroundColor("#f5f5f5")

  }
}

