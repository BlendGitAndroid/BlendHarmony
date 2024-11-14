import wifiManager from '@ohos.wifiManager'

class WfManager {
  // 检查wifi到底开没开  没开的话进行提示
  checkWifi() {
    return wifiManager.isWifiActive() // 检查wifi的开关
  }
}

export const wfManager = new WfManager()