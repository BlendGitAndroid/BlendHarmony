// 用户配置: 广告配置 token 用户信息之类的
import { preferences } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { AdvertClass } from '../models'
import { TOKEN_KEY, USER_SETTING, USER_SETTING_AD } from '../constants'

export const defaultAd: AdvertClass = {
  showAd: true,
  showTime: false,
  adTime: 5,
  adImg: $r('app.media.start')
}

// 管理App的一些配置: 广告的配置
export class UserSettingClass {
  // 获取用户的广告持久化配置仓库

  context: Context

  constructor(ctx: Context) {
    this.context = ctx
  }

  getStore() {
    // UIAbilityContext  组件的content  getC
    return preferences.getPreferencesSync(this.context, { name: USER_SETTING })
  }

  setAdvert(ad: AdvertClass) {
    const store = this.getStore()
    store.putSync(USER_SETTING_AD, JSON.stringify(ad)) // 内存中
    store.flush()
  }


  getAdvert(): AdvertClass {
    const store = this.getStore()
    const str = store.getSync(USER_SETTING_AD, JSON.stringify(defaultAd)) as string
    return JSON.parse(str)
  }

  // 获取token
  getToken(): string {
    const store = this.getStore()
    return store.getSync(TOKEN_KEY, '') as string
  }

  // 保存token
  async setToken(token: string) {
    const store = this.getStore()
    store.putSync(TOKEN_KEY, token)
    await store.flush()
  }
}