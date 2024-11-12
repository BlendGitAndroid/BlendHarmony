import { preferences } from '@kit.ArkData'

class History {
  store: preferences.Preferences | null = null

  getStore() {
    if (!this.store) {
      const ctx = AppStorage.get<Context>('context')
      this.store = preferences.getPreferencesSync(ctx, {
        name: 'history-store'
      })
    }
    return this.store
  }

  //   存一条
  async setItem(value: string) {
    // key不能唯一，因为后面会有多个
    // value当key，如果重复搜索同一个，不会多增加记录
    // key如果固定，会覆盖，只会记录一条，即使用数组，也会出现相同的搜索记录
    // 自动排序的解决方案：
    // key也可以用时间戳，存的时候取出来，进行去重
    // 新的value之前已经有了，就把之前的删了，存新的
    this.getStore().putSync(value, value)
    await this.getStore().flush()
  }

  //   删一条
  async delItem(value: string) {
    this.getStore().delete(value)
    await this.getStore().flush()
  }

  //   删全部
  async clear() {
    this.getStore().clearSync()
    await this.getStore().flush()
  }

  //   拿全部
  getAll() {
    const obj = this.getStore().getAllSync()
    //   obj ->  { key:val,key1:val1,key2:val2 } -> [val,val1,val2]
    return Object.keys(obj)
  }
}

export const history = new History()