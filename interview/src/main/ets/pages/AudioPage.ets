import { abilityAccessCtrl } from '@kit.AbilityKit'
import { promptAction, router } from '@kit.ArkUI'
import { AudioView } from '../views/Audio/AudioView'


@Entry
@Component
struct AudioPage {
  aboutToAppear(): void {
    this.checkPermission()
  }

  // 权限检测
  async checkPermission() {
    //  有没有权限
    const manager = abilityAccessCtrl.createAtManager()
    // 第一次像用户申请权限（权限列表配置过）
    const result = await manager.requestPermissionsFromUser(getContext(), [
      "ohos.permission.MICROPHONE"
    ])
    // 所有授权过的权限
    const isPass = result.authResults.every((result) => {
      return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    if (isPass) {

    } else {
      const confirm = await promptAction.showDialog({
        title: '温馨提示',
        message: '未授权使用麦克风将无法使用面试录音功能，是否前往设置？',
        buttons: [
          { text: '离开', color: $r('app.color.common_gray_01') },
          { text: '去授权', color: $r('app.color.black') }
        ]
      })
      if (confirm.index === 1) {
        // 等于在系统设置页设置了
        const finalResult = await manager.requestPermissionOnSetting(getContext(), [
          "ohos.permission.MICROPHONE"
        ])
        const finalPass = finalResult.every((result) => {
          return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
        })
        if (finalPass) {
          setTimeout(() => {
            promptAction.showToast({
              message: '授权成功'
            })
          }, 10)
        } else {
          // 第二次拒绝
          router.back()
        }
      } else {
        // 不给授权就返回上个页面
        router.back()
      }
    }
  }

  build() {
    Column({ space: 12 }) {
      AudioView()
    }
    .height('100%')
    .width('100%')
  }
}