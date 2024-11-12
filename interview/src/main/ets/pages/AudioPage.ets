import { abilityAccessCtrl } from '@kit.AbilityKit'
import { promptAction, router } from '@kit.ArkUI'
import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'
import { relationalStore } from '@kit.ArkData'
import { AudioView } from '../views/Audio/AudioView'


@Entry
@Component
struct AudioPage {
  aboutToAppear(): void {
    this.checkPermission()
  }
  // 权限检测
  async checkPermission() {
    //  有没有权限
    const manager = abilityAccessCtrl.createAtManager()
    // 第一次像用户申请权限（权限列表配置过）
    const result = await manager.requestPermissionsFromUser(getContext(), [
      "ohos.permission.MICROPHONE"
    ])
    // 所有授权过的权限
    const isPass = result.authResults.every((result) => {
      return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    if (isPass) {
      // 提示弹层，等权限弹层结束再弹
      // setTimeout(() => {
      //   promptAction.showToast({
      //     message: '第一次就允许了'
      //   })
      // }, 10)
    } else {
      const confirm = await promptAction.showDialog({
        title: '温馨提示',
        message: '未授权使用麦克风将无法使用面试录音功能，是否前往设置？',
        buttons: [
          { text: '离开', color: $r('app.color.common_gray_01') },
          { text: '去授权', color: $r('app.color.black') }
        ]
      })
      if (confirm.index === 1) {
        // 等于在系统设置页设置了
        const finalResult = await manager.requestPermissionOnSetting(getContext(), [
          "ohos.permission.MICROPHONE"
        ])
        const finalPass = finalResult.every((result) => {
          return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
        })
        if (finalPass) {
          setTimeout(() => {
            promptAction.showToast({
              message: '授权成功'
            })
          }, 10)
        } else {
          // setTimeout(() => {
          //   promptAction.showToast({
          //     message: '第二次拒绝了'
          //   })
          // }, 10)
          router.back()
        }
      } else {
        // 不给授权就返回上个页面
        router.back()
      }
    }
    //  有，直接用
    //  没有，二次弹层打开设置
  }

  // // 录音机
  // avRecorder?: media.AVRecorder
  // // 录音文件地址
  // filePath?: string
  // // 文件的唯一标识
  // fd?: number
  // @State
  // maxAmplitude: number = 0
  // timer: number = -1
  //
  // // 录音开启
  // async startRecord() {
  //   //录音文件
  //   const filePath = getContext().cacheDir + '/test.m4a'
  //   this.filePath = filePath
  //   const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
  //   this.fd = file.fd
  //
  //   const avRecorder = await media.createAVRecorder()
  //   // 准备录音配置
  //   await avRecorder.prepare({
  //     audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
  //     url: `fd://${this.fd}`,
  //     profile: {
  //       audioBitrate: 100000, //音频比特率
  //       audioChannels: 1, //音频声道
  //       audioSampleRate: 48000, //音频采样率
  //       audioCodec: media.CodecMimeType.AUDIO_AAC, //录音格式：目前只支持AAC
  //       fileFormat: media.ContainerFormatType.CFT_MPEG_4A//录音文件类型
  //     }
  //   })
  //   // 开启录音
  //   await avRecorder.start()
  //   this.avRecorder = avRecorder
  //   this.timer = setInterval(async () => {
  //     this.maxAmplitude = await avRecorder.getAudioCapturerMaxAmplitude()
  //   }, 100)
  // }
  //
  // // 录音关闭
  // async stopRecord() {
  //   if (this.avRecorder) {
  //     await this.avRecorder.stop()
  //     await this.avRecorder.release()
  //     //文件的写入buffer是录音机实现的
  //     fileIo.close(this.fd)
  //     clearInterval(this.timer)
  //     this.maxAmplitude = 0
  //   }
  // }
  //
  // // 播放器
  // avPlayer?: media.AVPlayer
  //
  // // 播放录音
  // async playRecord() {
  //   const file = fileIo.openSync(this.filePath, fileIo.OpenMode.READ_ONLY)
  //   const avPlayer = await media.createAVPlayer()
  //   avPlayer.url = `fd://${file.fd}`
  //   avPlayer.on('stateChange', (state) => {
  //     if (state === 'initialized') {
  //       avPlayer.prepare()
  //     } else if (state === 'prepared') {
  //       avPlayer.loop = true
  //       avPlayer.play()
  //     }
  //   })
  // }
  //
  // store?: relationalStore.RdbStore
  // tableName: string = 'userInfo'
  // @State
  // list: UserInfoDB[] = []
  //
  // // 数据库的创建
  // async createDB() {
  //   //store的实例
  //   const store = await relationalStore.getRdbStore(getContext(), {
  //     name: 'interview_pass.db',
  //     securityLevel: relationalStore.SecurityLevel.S1
  //   })
  //   //建表
  //   store.executeSql(`
  //     CREATE TABLE IF NOT EXISTS  ${this.tableName}(
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         name TEXT NOT NULL,
  //         age INTEGER NOT NULL
  //     )
  //   `)
  //   //   存储
  //   this.store = store
  // }
  //
  // // 新增
  // insertDB() {
  //   this.store?.insert(this.tableName, {
  //     // 主键可以省略不屑
  //     name: 'BlendAndroid',
  //     age: Math.floor(Math.random()*100)
  //   })
  // }
  //
  // // 删除
  // deleteDB() {
  //   //查询到整个列表
  //   const item = this.list[0]
  //   const predicates = new relationalStore.RdbPredicates(this.tableName)
  //   predicates.equalTo('id',item.id)
  //   this.store?.deleteSync(predicates)
  // }
  //
  // // 修改
  // updateDB() {
  //   //查询到整个列表
  //   const item = this.list[0]
  //   // 改
  //   item.name = '潘神'
  //   const predicates = new relationalStore.RdbPredicates(this.tableName)
  //   predicates.equalTo('id',item.id)
  //   this.store?.updateSync(item,predicates)
  // }
  //
  // // 查询
  // async findDB() {
  //   const predicates = new relationalStore.RdbPredicates(this.tableName)
  //   const result = await this.store?.query(predicates)
  //   const list: UserInfoDB[] = []
  //   // 有下一行就继续
  //   while (result?.goToNextRow()) {
  //     //   成立执行的代码
  //     list.push({
  //       id: result.getLong(result.getColumnIndex('id')),
  //       name: result.getString(result.getColumnIndex('name')),
  //       age: result.getLong(result.getColumnIndex('age'))
  //     })
  //   }
  //   // 关闭
  //   result?.close()
  //   this.list = list
  // }

  build() {
    Column({ space: 12 }) {
      AudioView()
    }
    .height('100%')
    .width('100%')
  }
}



interface UserInfoDB extends relationalStore.ValuesBucket {
  id: number
  name: string
  age: number
}