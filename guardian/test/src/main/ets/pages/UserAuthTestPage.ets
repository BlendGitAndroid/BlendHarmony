import { userAuth } from '@kit.UserAuthenticationKit'
import { promptAction } from '@kit.ArkUI'
import { userAuthManager } from '../manager'

@Entry
@Component
struct UserAuthTestPage {
  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Button('查询支持的认证能力')
            .onClick(() => {
              try {
                // 注意：先在模拟器的设置页，添加锁屏密码
                // 查询支持的认证能力
                userAuth.getAvailableStatus(userAuth.UserAuthType.PIN, userAuth.AuthTrustLevel.ATL1)
                promptAction.showToast({ message: '当前设备中支持 userAuth 认证能力' })
              } catch (error) {
                // 不支持通过 catch 捕获错误信息
                AlertDialog.show({ message: JSON.stringify(error, null, 2) })
              }
            })
          Button('发起认证-userAuth')
            .onClick(() => {
              // 申请权限：ohos.permission.ACCESS_BIOMETRIC。
              // 1. 调用 getUserAuthInstance 获取认证对象。
              //     1.1 指定用户认证相关参数AuthParam（包括挑战值、认证类型UserAuthType列表和认证等级AuthTrustLevel）、配置认证控件界面WidgetParam，
              // 2. 调用 UserAuthInstance.on 接口订阅认证结果。
              // 3. 调用 UserAuthInstance.start 接口发起认证
              //      通过IAuthCallback回调返回认证结果UserAuthResult。
              //      当认证成功时返回认证通过类型（UserAuthType）和令牌信息（AuthToken）。

              // 1. 获取认证对象
              const userAuthInstance = userAuth.getUserAuthInstance(
                {
                  challenge: new Uint8Array([1, 1, 2, 3, 4, 5, 51]), // 挑战值
                  authType: [userAuth.UserAuthType.PIN, userAuth.UserAuthType.FINGERPRINT, userAuth.UserAuthType.FACE],
                  authTrustLevel: userAuth.AuthTrustLevel.ATL3
                },
                { title: '请验证用户身份' }
              )
              // 2. 订阅认证结果
              userAuthInstance.on('result', {
                onResult(result) {
                  AlertDialog.show({ message: JSON.stringify(result, null, 2) })
                }
              })
              // 3. 发起认证
              userAuthInstance.start()
            })

          Button('查询支持的认证能力-检测某一项是否支持即可')
            .onClick(() => {
              // 鸿蒙中支持的认证类型
              const userAuthTypeList: userAuth.UserAuthType[] = [
                userAuth.UserAuthType.PIN,
                userAuth.UserAuthType.FINGERPRINT,
                userAuth.UserAuthType.FACE,
              ]
              // map 遍历查询支持的能力，内部返回 true / false
              const res = userAuthTypeList.map((item) => {
                try {
                  userAuth.getAvailableStatus(item, userAuth.AuthTrustLevel.ATL3)
                  return true
                } catch {
                  return false
                }
              })
              // AlertDialog.show({ message: JSON.stringify(res, null, 2) })
              // some 检查是否有一项支持，有一项支持即返回 true
              const isSupport = res.some(v => v === true)
              AlertDialog.show({ message: JSON.stringify(isSupport, null, 2) })
            })

          Button('查询支持的认证能力-检测某一项是否支持即可-封装')
            .onClick(() => {
              const isSupport = userAuthManager.checkUserAuthSupport()
              AlertDialog.show({ message: JSON.stringify(isSupport, null, 2) })
            })

          Button('发起认证-封装')
            .onClick(async () => {
              try {
                await userAuthManager.startUserAuth()
                promptAction.showToast({ message: '认证成功，await 后续代码能运行' })
              } catch (error) {
                AlertDialog.show({ message: JSON.stringify(error, null, 2) })
              }
            })
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('')
    .titleMode(NavigationTitleMode.Mini)
  }
}