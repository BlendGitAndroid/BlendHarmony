@Component
export struct ImageListComp {
  @State
  imageList: ResourceStr[] = [
    '/assets/1.webp',
    '/assets/2.webp',
    '/assets/3.webp',
    '/assets/4.webp',
    '/assets/5.webp',
    '/assets/6.webp',
    '/assets/7.webp',
    '/assets/8.webp',
    '/assets/9.webp',
    '/assets/10.webp'
  ]

  // 选择的列表
  @State
  selectList: ResourceStr[] = []

  @Prop
  maxNum: number = 9

  @Link
  selectedList: ResourceStr[]

  @Link
  showDialog: boolean

  build() {
    Column() {
      Row() {
        Text('取消')
          .onClick(() => {
            this.showDialog = false
          })

        Text(`已选中${this.selectList.length}/${this.maxNum}张`)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('确定')
          .onClick(() => {
            this.selectedList.push(...this.selectList)
            this.showDialog = false
          })
      }
      .width('100%')
      .padding(20)

      Grid() {
        ForEach(this.imageList, (item: ResourceStr) => {
          GridItem() {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Image(item)
                .width('100%')
                .aspectRatio(1)

              // 选中的图才展示图标
              if (this.selectList.includes(item)) {
                Image($r('sys.media.ohos_ic_public_select_all'))
                  .width(30)
                  .aspectRatio(1)
                  .fillColor('#ff355107')
                  .margin(5)
              }
            }
          }.onClick(() => {
            if (this.selectList.includes(item)) {
              // 取消选中
              this.selectList = this.selectList.filter(url => url !== item)
            } else {
              if (this.selectList.length >= this.maxNum) {
                return
              } else {
                this.selectList.push(item)
              }
            }
          })
        })
      }
      .width('100%')
      .padding(20)
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .layoutWeight(1)
    }
    .backgroundColor(Color.White)
  }
}
