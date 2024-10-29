import { PlayControlComp } from './PlayControlComp'

@Component
export struct WechatConsumeComp {
  build() {

    Column() {
      PlayControlComp()
    }
    .width('100%')
  }
}
