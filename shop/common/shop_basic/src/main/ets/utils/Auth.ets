import { GlobalVariable } from "../constants"
import { HDMUser } from "../viewmodels"

export class Auth {
  private key: string = GlobalVariable.USER_INFO_KEY

  // 设置用户信息
  setUserInfo(user: HDMUser) {
    AppStorage.setOrCreate<HDMUser>(this.key, user) // 往内存写入
  }

  // 获取用户信息
  // arkUI组件中可以用@StorageProp
  // arkTS中无法使用修饰符
  getUserInfo() {
    return AppStorage.get<HDMUser>(this.key)
  }
}

export const auth = new Auth()