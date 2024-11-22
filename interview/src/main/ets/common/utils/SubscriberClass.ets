import { commonEventManager } from '@kit.BasicServicesKit'

// 订阅类
class SubscriberClass {
  // 订阅者
  subscriber?: commonEventManager.CommonEventSubscriber

  // 订阅
  subscribe(event: string, callBack: (value: string) => void) {
    // 1.创建订阅者
    this.subscriber = commonEventManager.createSubscriberSync({ events: [event] })
    commonEventManager.subscribe(this.subscriber, (err, value) => {
      // 订阅后触发的回调
      // value.data 是调用事件传递的参数
      callBack(value.data as string)
    })
  }

  // 发布
  // event是发布的事件名称
  // { data }是发布事件携带的参数
  publish(event: string, data: string = '') {
    commonEventManager.publish(event, { data }, () => {
    })
  }
}

export const subscriberClass = new SubscriberClass()