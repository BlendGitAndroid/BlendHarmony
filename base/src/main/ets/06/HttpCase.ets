import { http } from '@kit.NetworkKit'
import axios, {
  AxiosResponse,
} from '@ohos/axios'

@Entry
@Component
struct HttpCase {
  async sendHttp() {
    const req = http.createHttp()
    // 耗时的任务可能没执行完就执行下一行代码了，如果需要等待+await,但是await不能单独使用，需要在当前所在函数前面加async
    const res = await req.request('https://zhousg.atomgit.net/harmonyos-next/takeaway.json')
    AlertDialog.show({
      message: res.result as string
    })
  }

  async sendAxios() {
    const res =
      await axios.get<object, AxiosResponse<object, null>, null>('https://zhousg.atomgit.net/harmonyos-next/takeaway.json')
    return res
  }

  build() {
    Row() {
      Column() {
        Button('HTTP测试')
          .onClick(() => {
            this.sendHttp()
          })
        Button('AXIOS测试')
          .onClick(async () => {
            const res = await this.sendAxios()
            AlertDialog.show({
              message: JSON.stringify(res.data)
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}