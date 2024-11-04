// 1.消息类型
import { UserInfo } from './user'
import { util } from '@kit.ArkTS'

export enum MessageTypeEnum {
    TEXT,//文本
    IMAGE,//图片
    AUDIO,//语音
    VIDEO,//视频
    LOCATION,//定位
    LINK//连接
}
//2.消息的数据结构
export interface MessageInfo {
   id:string
   sendUser:UserInfo
   connectUser:UserInfo//用的时候再去理解
   messageContent:string//消息文本：[视频] [图片] [链接]
   messageType:MessageTypeEnum
   sendTime:number
   sourceFilePath:string //音频，视频，图片等有附属文件的消息路径
   sourceDuration:number //语音消息的时长

}
export class MessageInfoModel implements MessageInfo {
  id: string = ''
  sendUser: UserInfo = {} as UserInfo
  connectUser: UserInfo = {} as UserInfo
  messageContent: string = ''
  sendTime:number = 0
  messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  sourceFilePath: string = ''
  sourceDuration: number = 0

  constructor(model: MessageInfo) {
    // id生成
    this.id = model.id || util.generateRandomUUID()
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    // 发送时间
    this.sendTime = model.sendTime || Date.now()
    // 默认文本消息
    this.messageType = model.messageType || MessageTypeEnum.TEXT
    this.sourceFilePath = model.sourceFilePath
    this.sourceDuration = model.sourceDuration
  }
}
