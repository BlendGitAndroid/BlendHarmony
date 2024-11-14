import preferences from '@ohos.data.preferences'

class UserAuthStore {
  KEY = 'user-store'
  context?: Context

  // 定义方法
  // 获取仓库
  getStore() {
    return preferences.getPreferences(this.context || getContext(), { name: 'UserStore' })
  }

  async setUser(data: User) {
    const store = await this.getStore()
    await store.put(this.KEY, JSON.stringify(data))
    await store.flush()
  }

  async getUser() {
    const store = await this.getStore()
    const data = await store.get(this.KEY, '{}') as string
    return JSON.parse(data) as User
  }

  async delUser() {
    const store = await this.getStore()
    await store.delete(this.KEY)
    await store.flush()
  }
}

export class User {
  token: string = '' // 用来存储token
}

export const TokenManager = new UserAuthStore() // 全局只new一次 效果和static一样 但是在class中可以用this 不用static