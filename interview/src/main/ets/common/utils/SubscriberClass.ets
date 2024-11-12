// 最佳实践：不要多导出一次
import { commonEventManager } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'
import { logger } from './Logger'

// export import 点对点

class SubscriberClass {
  // 订阅者
  subscriber?: commonEventManager.CommonEventSubscriber

  //   订阅
  subscribe(event: string, callBack: (value: string) => void) {
    // 讲义写法
    // commonEventManager.createSubscriber({
    //   events: [event]
    // }, (err, value) => {
    //   if(err){
    //     logger.error('订阅失败')
    //   }
    //   //   订阅触发后的回调
    //   // value就是订阅者
    //   this.subscriber = value
    // })
    //   1.创建订阅者
    this.subscriber = commonEventManager.createSubscriberSync({ events: [event] })
    commonEventManager.subscribe(this.subscriber, (err, value) => {
      //   订阅后触发的回调
      // value.data 是调用事件传递的参数
      callBack(value.data as string)
    })
  }

  //   发布
  publish(event: string, data: string = '') {
    // event是发布的事件名称
    // { data }是发布事件携带的参数
    // () => {}
    commonEventManager.publish(event, { data }, () => {})
  }
}

export const subscriberClass = new SubscriberClass()