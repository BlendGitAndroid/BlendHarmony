import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import { bundleManager, common } from '@kit.AbilityKit'
import { promptAction } from '@kit.ArkUI'
import { access, ble, constant } from '@kit.ConnectivityKit'
import { BusinessError, emitter } from '@kit.BasicServicesKit'
import { Log } from '@abner/log'
import { BlueData } from '../viewmodel'
import { util } from '@kit.ArkTS'

class BlueManager {
  // 在 TypeScript 中，async 函数总是返回一个 Promise。即使你在 async 函数中直接返回一个值，这个值也会被自动包装成一个 Promise。
  // 因此，在你的 checkBlue 函数中，返回 true 实际上是返回一个 Promise，其解析值为 true。
  // 当你在 async 函数中返回一个值时，TypeScript 会自动将这个值包装在一个 Promise 中。例如：
  // async function example(): Promise<boolean> {
  //   return true;
  // }
  // 上面的代码等同于：
  // function example(): Promise<boolean> {
  //   return Promise.resolve(true);
  // }
  // 检查蓝牙权限-应用有没有蓝牙权限
  async checkBlue(): Promise<boolean> {
    try {
      // 权限的检查
      const bundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      let atManager = abilityAccessCtrl.createAtManager()
      const status =
        atManager.checkAccessTokenSync(bundleInfo.appInfo.accessTokenId, "ohos.permission.ACCESS_BLUETOOTH") // 检查是否授权
      if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        // 要去申请蓝牙权限
        const result = await atManager.requestPermissionsFromUser(getContext(), ["ohos.permission.ACCESS_BLUETOOTH"])
        // 检查是否授权,如果已经授权
        if (result.authResults[0] === 0) {
          // 应该打开蓝牙开关 检测开关是关着的
          if (!this.checkBlueOpen()) {
            return Promise.reject(new Error("请首先打开蓝牙开关"))
          }
          // return true // 表示检查权限成功
          return Promise.resolve(true) // 等同于返回true
        } else {
          // 如果不等于0 那就是点击了禁止
          // 拉起应用系统设置页面
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility({
            bundleName: 'com.huawei.hmos.settings',
            abilityName: 'com.huawei.hmos.settings.MainAbility',
            uri: 'application_info_entry',
            parameters: {
              pushParams: 'com.blend.harmony1' // 应用包名
            }
          });
          return false // 表示授权失败 跳到了设置页面
        }
      }
      // 已经有蓝牙权限
      if (!this.checkBlueOpen()) {
        // 检测开关是关着的
        return Promise.reject(new Error("请首先打开蓝牙开关"))
      }
      return true // 表示授权成功
    } catch (error) {
      return false
    }
  }

  // 检查系统的蓝牙是否打开 true/打开 false/关闭
  checkBlueOpen() {
    return access.getState() === access.BluetoothState.STATE_ON
  }

  timer: number = -1 // 记录定时器

  // 扫描蓝牙
  scanDevice(callback: (res: ble.ScanResult[]) => void) {
    try {
      clearTimeout(this.timer) // 清除上一次的 重新开始
      // 当找到蓝牙时会触发
      const resList: ble.ScanResult[] = [] // 汇总所有的发现蓝牙
      ble.on("BLEDeviceFind", (list: ble.ScanResult[]) => {
        Log.info("扫描到的蓝牙列表：" + JSON.stringify(list))
        resList.push(...list.filter(dv =>!resList.some(item => item.deviceId === dv.deviceId)))
        // 告诉页面
        callback(resList) // 回传汇总的数据
      });
      let scanOptions: ble.ScanOptions = {
        interval: 500,
        dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
        matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE
      }
      ble.startBLEScan(null, scanOptions);
      this.timer = setTimeout(() => {
        ble.stopBLEScan() // 停止扫描
        ble.off("BLEDeviceFind") // 停止监听该事件
      }, 8000)
    } catch (err) {
      Log.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  currentClient: ble.GattClientDevice | null = null

  // 连接蓝牙
  connectBlue(deviceId: string, callback: () => void) {
    if (deviceId) {
      // 创建gatt的实例对象
      this.currentClient = ble.createGattClientDevice(deviceId) // 和蓝牙通信的对象的实例
      this.currentClient.on("BLEConnectionStateChange", async (res) => {
        if (res.state === constant.ProfileConnectionState.STATE_CONNECTED) {
          callback() // 连接成功
          promptAction.showToast({ message: '蓝牙连接成功' })
          // 开启蓝牙的数据监听了
          this.currentClient?.on("BLECharacteristicChange", (res) => {
            // res是二进制数据
            const decode = util.TextDecoder.create() // 创建解码对象
            const buffer = new Uint8Array(res.characteristicValue)
            const result = JSON.parse(decode.decodeWithStream(buffer)) as BlueData
            Log.info("监听特征值返回的结果:" + JSON.stringify(result))
            if (result.command === "wifi") {
              emitter.emit("WifiConnect", {
                data: {
                  status: result.status // 状态传递到需要监听的地方
                }
              })
            }
          })
          // 必须使用对应的监听特征值 发起监听
          const list = await this.currentClient?.getServices()
          const doorService = list?.find(item => item.serviceUuid.startsWith("0000AE30")) // 找到门禁服务
          if (doorService) {
            const watchObj =
              doorService.characteristics.find(item => item.characteristicUuid.startsWith("0000AE04")) // 监听特征值
            this.currentClient?.setCharacteristicChangeNotification(watchObj, true) // 设置监听
          }

        }
      })
      this.currentClient.connect() // 连接蓝牙
    }

  }

  // 销毁蓝牙连接
  destroy() {
    if (this.currentClient) {
      this.currentClient.disconnect()
      this.currentClient.close()
      this.currentClient = null
    }

  }

  // 给蓝牙发送数据
  async sendData(data: BlueData) {
    try {
      // 发送数据
      if (this.currentClient) {
        const list = await this.currentClient?.getServices()
        const doorService = list.find(item => item.serviceUuid.startsWith("0000AE30")) // 找到门禁服务
        if (doorService) {
          // 再找门禁服务的读写特征值的对象
          const writeObj =
            doorService.characteristics.find(item => item.characteristicUuid.startsWith("0000AE10")) // 写入特征值
          if (writeObj) {
            const encoder = new util.TextEncoder() // 生成一个编码对象
            const unit8Array = encoder.encodeInto(JSON.stringify(data))
            // 有了写入特征值 就可以通过蓝牙进行通信了
            await this.currentClient.writeCharacteristicValue({
              serviceUuid: writeObj.serviceUuid,
              characteristicUuid: writeObj.characteristicUuid,
              characteristicValue: unit8Array.buffer, // 将数据转化成二进制的arrayBuffer
              descriptors: []// 要写入的数据,
            }, ble.GattWriteType.WRITE)
          }
        }
      }
    } catch (error) {
      promptAction.showToast({ message: '发送数据失败，' + error.message })
    }

  }
}


export const blueManager = new BlueManager()