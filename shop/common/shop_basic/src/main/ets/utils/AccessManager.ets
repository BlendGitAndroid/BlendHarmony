import { abilityAccessCtrl, bundleManager, Permissions } from "@kit.AbilityKit";

export class AccessManager {
  // 检查是否有权限
  async checkPermission(permissions: Permissions[], callback: () => void) {
    // 检查当前有没有这个permissions的权限
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const manager = abilityAccessCtrl.createAtManager()
    let isHave = permissions.every(item => {
      let status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId, item)
      return status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    if (isHave) {
      // 此时拥有
      callback() // 对方可以正常进行逻辑的处理了
    } else {
      // 第一次弹窗
      const result = await manager.requestPermissionsFromUser(getContext(), permissions)
      let againHave = result.authResults.every(status => {
        return status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      })

      if (againHave) {
        callback() // 对方可以正常进行逻辑的处理了
      } else {
        manager.requestPermissionOnSetting(getContext(), permissions)
      }
    }


  }
}


//  华为 只弹出一次
//


export const accessManager = new AccessManager()