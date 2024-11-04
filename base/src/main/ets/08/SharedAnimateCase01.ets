import { router } from '@kit.ArkUI';
import './SharedAnimateCase02'

@Entry
@Component
struct SharedAnimateCase01 {

  // 共享元素转场
  // 页面间元素共享转场动画实现：sharedTransition('共享标识')
  // 同一共享标识的组件在页面间切换时会形成动画

  @State message: string = 'SharedAnimateCase01';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Image($r('app.media.b'))
          .width(200)
          .sharedTransition('imageShared')

        Button('跳转02')
          .onClick(()=>{
            router.pushNamedRoute({
              name:'SharedAnimateCase02'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}