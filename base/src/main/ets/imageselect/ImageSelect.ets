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

  // 在Builder里面套一个组件
  // 不用全局的Builder,因为需要传值
  @Builder
  imageListBuilder() {
    // 大坑：builder里面不能直接放自定义组件，需要一层系统组件包裹
    Row() {
      ImageListComp({
        selectedList: this.selectedList,
        showDialog: this.showDialog,
        maxNum: 5
      })
    }
  }

  // 2.注册弹层,new一个控制器
  myCustomDialog: CustomDialogController = new CustomDialogController({
    // 引入自定义的Dialog
    builder: MyCustomDialog({
      selectedList: this.selectedList
    }),
    customStyle: true // 使用自定义弹层
  })

  build() {
    Grid() {
      ForEach(this.selectedList, (item: ResourceStr) => {
        GridItem() {
          Image(item)
            .width('100%')
            .aspectRatio(1)
        }.onClick(() => {
          // 3. 打开弹层展示,图片预览
          this.myCustomDialog.open()
        })
      })

      // 加号按钮
      GridItem() {
        ImageSelectBuilder()
      }
      .onClick(() => {
        this.showDialog = true
      })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    // 全屏模态转场
    // .bindContentCover($$this.showDialog, this.imageListBuilder())
    // 半模态转场,也就是半屏的模态框
    .bindSheet($$this.showDialog, this.imageListBuilder(), {
      showClose: false, // 是否展示关闭按钮
      height: '80%'
    })
  }
}

// bindSheet，半模态转场
// 需要传入三个参数:
// 第一个，是否显示模态框
// 第二个，模态框自定义构建函数
// 第三个(非必传)，模态框的配置项
