import { http } from '.'
import { TimeItem } from '../../model'
import { logger } from './Logger'
import { preferences } from '@kit.ArkData'
import { JSON } from '@kit.ArkTS'

class Tracking {
  // 缓存列表：缓存记录的点
  // list: TimeItem[] = []

  // 首选项：仓库 ->  key  ->  通过key val存储
  store: preferences.Preferences | null = null
  // 用于仓库读写的key
  trackKey: string = 'track-list'

  // 仓库的创建
  getStore() {
    if (!this.store) {
      //   创建仓库
      const ctx = AppStorage.get<Context>('context')
      this.store = preferences.getPreferencesSync(ctx, {
        name: 'tracking-store'
      })
    }
    return this.store
  }

  //记录
  async record(questionId: string, startTime: number, endTime: number) {
    // 原来  的数组
    const json = this.getStore().getSync(this.trackKey, '[]')
    const list = JSON.parse(json as string) as TimeItem[]
    // +
    // 新增  的数组
    list.push({
      questionId,
      startTime,
      endTime
    })
    // =
    // 完整  的数组  list
    this.getStore().putSync(this.trackKey, JSON.stringify(list))
    // 持久化一定记得写入磁盘
    await this.getStore().flush()

    // this.list.push({
    //   questionId,
    //   startTime,
    //   endTime
    // })
    // logger.info(JSON.stringify(this.list))
  }

  //上送：不是每个点都发送，恰当的时机上送，减少服务器压力
  async report(force: boolean = false) {
    const json = this.getStore().getSync(this.trackKey, '[]')
    const list = JSON.parse(json as string) as TimeItem[]
    // 判断是否需要上传(被动：判断条数)
    if (list.length >= 5 || (force && list.length)) {
      // 上送逻辑
      await http.request<null>({
        url: 'hm/time/tracking',
        method: 'post',
        // data 是body参数   params是url参数
        data: {
          timeList: list
        }
      })
      // 把数据变成空(推荐)
      // this.getStore().putSync(this.trackKey,'[]')
      // 删除
      this.getStore().deleteSync(this.trackKey)
      await this.getStore().flush()
    }

  }
}

export const tracking = new Tracking()