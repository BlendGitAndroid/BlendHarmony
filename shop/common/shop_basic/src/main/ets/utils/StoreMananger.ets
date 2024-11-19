// import preferences from "@ohos.data.preferences"
import { preferences } from "@kit.ArkData"
import { GlobalVariable } from "../constants"
import { HDMUser } from "../viewmodels"

export class StoreManager {
  ctx?: Context

  // 仓库对象
  getStore() {
    return preferences.getPreferencesSync(this.ctx || getContext(), {
      name: GlobalVariable.USER_INFO_KEY // 仓库名称 => 沙箱的文件名称
    })
  }

  // 写入磁盘
  async setUserInfo(user: HDMUser) {
    const store = this.getStore()
    store.putSync(GlobalVariable.USER_INFO_KEY, user) // 写入临时缓存区
    await store.flush() // 写入磁盘
  }

  // 读取磁盘
  getUserInfo(): HDMUser {
    const store = this.getStore()
    return store.getSync(GlobalVariable.USER_INFO_KEY, {}) as HDMUser
  }

  // 写入formId 一个一个写
  async setFormId(formId: string) {
    const store = this.getStore()
    // 先获取原来的formId => [1,2,3, 4]
    const formIdList = this.getFormId() // [1，2，3]
    formIdList.push(formId)
    store.putSync(GlobalVariable.FORM_ID_LIST, formIdList)
    await store.flush() // 这里加await的目的是 防止 万一有人需要在setFormId之后 做事情，但是formId又没有更新完毕，会造成效果不对
  }


  // 读取formId 是有多个卡片的
  getFormId(): string[] {
    const store = this.getStore()
    return store.getSync(GlobalVariable.FORM_ID_LIST, []) as string[]
  }
}

export const storeManager = new StoreManager()