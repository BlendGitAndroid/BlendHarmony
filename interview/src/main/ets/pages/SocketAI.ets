// 1.导入包
import { http, webSocket } from '@kit.NetworkKit'
import { JSON, util } from '@kit.ArkTS'
import { router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'
import { logger } from '../common/utils/Logger'


@Entry
@Component
struct SocketAI {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State
  contentStr: string = ""
  @State
  messList: MessageItem[] = []
  scroller: Scroller = new Scroller()
  @State
  sendIng: boolean = false
  token: string = ""
  // 2.创建ws对象
  ws: webSocket.WebSocket = webSocket.createWebSocket()

  aboutToAppear() {
    this.getToken()
  }

  // 连接后台的方法
  createConnect() {
    // 1.建立连接：最核心
    //socket地址：'ws://toutiao.itheima.net/socket.io/?EIO=4&transport=websocket&token=' + this.token
    this.ws.connect('ws://toutiao.itheima.net/socket.io/?EIO=4&transport=websocket&token=' + this.token,
      (err: BusinessError, value: boolean) => {
        if (!err) {
          logger.info('socket connect success!')
        } else {
          logger.info('socket connect error!')
        }
      })
    //   2.消息处理
    this.ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      logger.info('socket get message:' + value)
      //   协议1：0开头
      if ((value as string).startsWith('0')) {
        //   回复
        this.ws.send('40')
      } else if ((value as string).startsWith('2')) { //协议2：收到2必须回3
        this.ws.send('3')
      } else if ((value as string).startsWith('42')) { //协议342开头，类型是message就是给我的消息
        //   消息追加到页面
        logger.info(value as string);
        const message = JSON.parse((value as string).replace('42','')) as [string,MessageStruct]
        if(message[0] === 'message'){
          this.messList.push(new MessageItem(message[1].msg,false))
        }
      }
    })
  }

  async getToken() {
    //通过后台服务获取实时通信的token信息
    const instance = http.createHttp()
    const res = await instance.request('https://toutiao.itheima.net/v1_0/authorizations', {
      header: {
        "Content-Type": "application/json",
      },
      method: http.RequestMethod.POST,
      extraData: { mobile: '13912345678', code: '246810' }
    })
    const tokenObj = JSON.parse(res.result as string) as ResponseResult<Token>
    this.token = tokenObj.data.token
    this.createConnect()
  }

  async sendMessage() {
    if (!this.contentStr) {
      return
    }
    this.sendIng = true
    try {
      // 发送给socket
      const data: [string, MessageStruct] = ['message', {
        msg: this.contentStr,
        timestamp: Date.now()
      }]
      this.ws.send('42' + JSON.stringify(data), (err: BusinessError, value: boolean) => {
        if (!err) {
          logger.info('socket send success')
        } else {
          logger.info('socket send error')
        }
      })

      // 发送到页面
      this.messList.push(new MessageItem(this.contentStr))
      this.scroller.scrollEdge(Edge.Bottom)
      this.sendIng = false
      this.contentStr = ""
    } catch (error) {
      AlertDialog.show({ message: JSON.stringify(error) })
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Stack({ alignContent: Alignment.Start }) {
          Text("‍面通AI")
            .width('100%')
            .height(50)
            .textAlign(TextAlign.Center)
          Image($r('sys.media.ohos_ic_compnent_titlebar_back_filled'))
            .width(24)
            .aspectRatio(1)
            .onClick(() => {
              router.back()
            })
        }
        .padding({
          left: 16,
          right: 16
        })

        // 消息列表
        Column() {
          List({ space: 20, scroller: this.scroller }) {
            ForEach(this.messList, (item: MessageItem) => {
              ListItem() {
                // 一左一右
                ChatMessage({
                  item, delMessage: (id: string) => {
                    // 删除消息
                    const index = this.messList.findIndex(item => item.id === id)
                    this.messList.splice(index, 1)
                  }
                })
              }
            })
          }
          .width('100%')
          .height('100%')
        }
        .padding({
          bottom: 80
        })
        .layoutWeight(1)

        Row({ space: 20 }) {
          TextInput({ text: this.contentStr })
            .layoutWeight(1)
            .backgroundColor(Color.White)
            .borderRadius(2)
            .height(40)
            .onChange((value) => {
              this.contentStr = value
            })
            .onSubmit(() => {
              if (this.contentStr) {
                this.sendMessage()
              }
            })
          Button() {
            Row() {
              if (this.sendIng) {
                LoadingProgress()
                  .width(20)
                  .height(20)
                  .color('#fff')
                  .margin({
                    right: 4
                  })
              } else {
                Text("发送")
                  .fontColor("#fff")
              }
            }
          }
          .onClick(async () => {
            if (!this.sendIng) {
              await this.sendMessage()
            }
          })
          .enabled(!!this.contentStr)
          .height(30)
          .width(60)
        }
        .width('100%')
        .backgroundColor('#f6f6f6')
        .height(70)
        .padding({
          left: 10,
          right: 10
        })
      }.height('100%')

    }
    .backgroundColor('#ededed')
    .height('100%')
    .padding({
      top: this.topHeight,
      bottom: this.bottomHeight
    })
  }
}

@Component
struct ChatMessage {
  @Prop
  item: MessageItem = new MessageItem('')
  @State
  showMenu: boolean = false
  delMessage: (id: string) => void = () => {
  }

  @Builder
  getDelContent() {
    Button("删除")
      .backgroundColor(Color.White)
      .fontColor("#0c2803")
      .height(30)
      .onClick(() => {
        this.delMessage(this.item.id!)
      })
  }

  build() {
    Row() {
      Image(this.item.avatar)
        .height(40)
        .width(40)
        .borderRadius(6)
      Row() {
        Text(this.item.content)
          .backgroundColor(this.item.self ? "#8bec73" : Color.White)
          .fontColor("#0c2803")
          .padding(10)
          .lineHeight(24)
          .margin({
            left: 10,
            right: 10
          })
          .borderRadius(5)
          .gesture(
            LongPressGesture()
              .onAction(() => {
                this.showMenu = true
              })
          )
          .bindPopup(this.showMenu, {
            builder: this.getDelContent,
            placement: Placement.Top,
            onStateChange: (event) => {
              this.showMenu = event.isVisible
            }
          })
      }.layoutWeight(5)
      .justifyContent(this.item.self ? FlexAlign.End : FlexAlign.Start)

      Text().layoutWeight(1)
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .alignItems(VerticalAlign.Top)
    .direction(this.item.self ? Direction.Rtl : Direction.Ltr)
  }
}


export class MessageItem {
  content: string = "" // 消息内容
  avatar: ResourceStr = "" // 用户头像
  username: string = "" // 用户名称
  self: boolean = false // 是不是用户自己
  timestamp: number = Date.now() // 消息收到时的时间戳
  id: string = util.generateRandomUUID() // 唯一的id
  constructor(content: string, self: boolean = true) {
    this.content = content
    this.self = self
    this.avatar = self ? 'https://gips3.baidu.com/it/u=1039279337,1441343044&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f1024_1024' :
      'http://gips2.baidu.com/it/u=109337419,2018114866&fm=3042&app=3042&f=JPEG&wm=1,huayi,0,0,13,9&wmo=0,0&w=1024&h=1024'
  }
}

interface ResponseResult<T> {
  data: T
  message: string
}

interface Token {
  token: string
}

interface MessageStruct {
  msg: string
  timestamp: number
}
