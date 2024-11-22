import { subscriberClass } from '../common/utils/SubscriberClass'

@Entry
@Component
struct CommonEventCase {
  @State
  cardPost: string = ''

  aboutToAppear(): void {
    subscriberClass.subscribe('appUpdate', (value) => {
      this.cardPost = value
    })
  }

  @StorageProp('appUpdate')
  appUpdate: string = ''

  build() {
    Column() {
      Button('通知卡片')
        .onClick(() => {
          //CES
          subscriberClass.publish('cardUpdate', Math.random().toFixed(2))
        })
      Text('卡片通知的内容:' + this.cardPost)
      Text('卡片rpc通知的内容:' + this.appUpdate)
    }
    .height('100%')
    .width('100%')
    .padding(40)
  }
}