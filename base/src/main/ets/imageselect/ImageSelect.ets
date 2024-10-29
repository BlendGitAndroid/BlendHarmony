import { ImageSelectBuilder } from './builders/ImageSelectBuilder'
import { ImageListComp } from './components/ImageListComp'
import { MyCustomDialog } from './components/MyCustomDialog'

@Entry
@Component
export struct ImageSelect {
  @State
  selectedList: ResourceStr[] = []

  @State
  showDialog: boolean = false

  @Builder
  imageListBuilder() {
    Row() {
      ImageListComp({
        selectedList: this.selectedList,
        showDialog: this.showDialog,
        maxNum: 5
      })
    }
  }

  // 2.注册弹层
  myCustomDialog: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog({
      selectedList: this.selectedList
    }),
    customStyle: true
  })

  build() {
    Grid() {
      ForEach(this.selectedList, (item: ResourceStr) => {
        GridItem() {
          Image(item)
            .width('100%')
            .aspectRatio(1)
        }.onClick(() => {
          this.myCustomDialog.open()
        })
      })

      // 加号按钮
      GridItem() {
        ImageSelectBuilder()
      }
      .onClick(() => {
        //   弹层展示
        // this.myCustomDialog.open()
        this.showDialog = true
      })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    // .bindContentCover($$this.showDialog, this.imageListBuilder())
    .bindSheet($$this.showDialog, this.imageListBuilder(), {
      showClose: false,
      height: '80%'
    })
  }
}
