// API11的写法，将所有的工具函数包装到新的kit中了
import { preferences } from '@kit.ArkData'

// 以前的写法
// import preferences from '@ohos.data.preferences'

export class PreferencesUtil {
  // 默认仓库的名字
  static defaultStore: string = 'DEFAULT_STORE'

  static firstStore: string = 'FIRST_STORE'

  // 仓库中的字段
  static tokenKey: string = 'TOKEN_KEY'

  //  每个字段需要准备2个方法
  //  设置字段的内容
  static setToken(context: Context, token: string, storeName: string = PreferencesUtil.defaultStore) {
    //   1.得到仓库
    const store = preferences.getPreferencesSync(context, { name: storeName })
    //   2.给仓库中写入内容
    store.putSync(PreferencesUtil.tokenKey, token)
    //   3.写入磁盘
    store.flush()
  }

  //  读取字段的内容
  static getToken(context: Context, storeName: string = PreferencesUtil.defaultStore) {
    //     1.取到仓库
    const store = preferences.getPreferencesSync(context, { name: storeName })
    //   2.从仓库中取值
    return store.getSync(PreferencesUtil.tokenKey, '')
  }

  //   删除token
  static removeToken(context: Context, storeName: string = PreferencesUtil.defaultStore) {
    const store = preferences.getPreferencesSync(context, { name: storeName })
    store.deleteSync(PreferencesUtil.tokenKey)
    store.flush()
  }
}
