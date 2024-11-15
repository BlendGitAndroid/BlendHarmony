// 持久化标识：常量
import { User } from '../../model'
import { router } from '@kit.ArkUI'

export const UserStoreKey = 'UserStoreKey'

class Auth {
  // 声明(只需要执行一次)
  initUser() {
    PersistentStorage.persistProp(UserStoreKey, {} as User)
  }

  // 设置持久化的信息(本质还是写入appStorage，封装一个方法改变这个代码的定义)
  setUser(user: User) {
    AppStorage.setOrCreate<User>(UserStoreKey, user)
  }

  // 访问
  getUser() {
    return AppStorage.get<User>(UserStoreKey) || {} as User
  }

  // 鉴权:1.页面跳转 2.功能操作
  checkAuth(opt: router.RouterOptions | Function) {
    //  判断有无权限
    const user = auth.getUser()
    // 有token就代表有权限
    if (user.token) {
      // opt是方法,直接执行方法
      if (typeof opt === 'function') {
        opt()
      } else {
        // 有token - 跳转页面
        router.pushUrl(opt)
      }
    } else {
      if (typeof opt === 'function') {
        // 没登录 - 执行方法
        router.pushUrl({
          url: '@bundle:com.blend.harmony1/interview/ets/pages/LoginPage'
        })
      } else {
        // 没登录
        // opt才是用户要去的页面，你给他跳了login
        // 跳login是为了鉴权，登录之后应该继续返回opt
        // 1.登录完了要去opt的url
        // 2.还得携带去opt参数
        const params = opt.params as Record<string, string> || {}
        // return_url自定义的
        params.return_url = opt.url
        router.pushUrl({
          url: '@bundle:com.blend.harmony1/interview/ets/pages/LoginPage',
          params
        })
      }
    }
  }
}

// 单例模式
export const auth = new Auth()