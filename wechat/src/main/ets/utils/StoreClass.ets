import { preferences } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { MessageInfoModel } from '../models/message'
import { DefaultUserList } from '../models/user'
import { emitter } from '@kit.BasicServicesKit'

// 存储类
export class StoreClass {
  static context: Context

  static wechat_store: string = 'WECHAT_STORE'

  // 执行一次以后不管了
  static init(context: Context) {
    StoreClass.context = context
  }

  // 1.获取某人的聊天仓库
  static getUserStore(userId: string) {
    // 仓库的获取
    // getContext是UI界面获取的
    // this.context是在Ability中获取
    return preferences.getPreferencesSync(StoreClass.context || getContext(), {
      name: `${StoreClass.wechat_store}_${userId}`  //eg:WECHAT_STORE_01
    })
  }

  // 2.添加某个人一条聊天记录
  static async addChatMessage(userId: string, message: MessageInfoModel) {
    // 1.仓库是什么,每一个人都有一个单独仓库
    const store = StoreClass.getUserStore(userId)
    // 2.新增一条消息(string)，key是message.id
    store.putSync(message.id, JSON.stringify(message))
    // 注意点：此时还没有完全写入磁盘
    await store.flush()
    // 发一个通知：当前聊天记录更新了
    // emitter.emit(事件id, 参数?可选)
    emitter.emit('addMessage') // 通过emitter触发更新
  }

  // 3.获取某个人的聊天记录(一进入聊天的时候会获取)
  static getChatMessage(userId: string) {
    const store = StoreClass.getUserStore(userId)
    // 获取仓库里面所有的记录
    const chatObj = store.getAllSync() as object
    if (chatObj) {
      // list是对象形式，聊天记录时间排序方式
      const list = Object.values(chatObj)// 将数组对象转换为字符串数组
        .map((item: string) => { // 利用map将字符串转换为Message对象
          return JSON.parse(item) as MessageInfoModel
        }).sort((a, b) => { // 然后按照发送时间从小到大排序
          return a.sendTime - b.sendTime
        })
      // a和b是每一条消息，通过消息的发送时间比对重新排序
      return list
    }
    // 如果没有和这个人的聊天纪录返回和查询到的结果一样的数据结构
    return []
  }

  // 4.删除某个人的一条聊天记录
  static async removeChatMessage(userId: string, messageId: string) {
    const store = StoreClass.getUserStore(userId)
    // 根据Message.id删除这条记录
    store.deleteSync(messageId)
    // 注意点：此时还没有完全写入磁盘
    await store.flush()
    emitter.emit('addMessage')
  }

  // 5.删除某个人的所有聊天记录
  static removeChatAllMessage(userId: string) {
    preferences.deletePreferences(StoreClass.context, {
      name: `${StoreClass.wechat_store}_${userId}`
    })
    emitter.emit('addMessage')
  }

  // 6.获取所有人的最后一条聊天记录
  static getAllChatLastMessage() {
    const list: MessageInfoModel[] = []
    // 所有人的聊天记录 -> 所有的仓库
    // DefaultUserList -> 所有联系人
    DefaultUserList.forEach(user => {
      //   通过这个人去拿store
      const chatList = StoreClass.getChatMessage(user.user_id)
      //   能拿到,拿聊天记录
      if (chatList.length) {
        list.push(chatList[chatList.length-1])
      }
    })
    // list目前是根据用户列表顺序查出来的，应该按聊天时间排序
    // newList就是排序完的
    const newList = list.sort((a, b) => {
      // 聊天列表，最新的在上面
      // 聊天记录，最新的在下面
      return b.sendTime - a.sendTime
    })
    return newList
  }
}

//总结：
// 1.拿所有<string>  getAllSync
// 2.删除store  preference.remove
// 3.创建|读取store preference.getPreferencesSync()
// 4.删除<string> store.deleteSync(key)