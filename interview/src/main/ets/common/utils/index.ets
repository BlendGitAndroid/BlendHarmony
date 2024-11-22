// 三层架构的习惯 - 所有的文件夹下的内容都在index导出
// 聚合导出
import { promptAction, router } from '@kit.ArkUI'
import { auth } from './Auth'
import { http } from './Http'
import { util } from '@kit.ArkTS'

export * from './Logger'

export * from './FullScreen'

export * from './StatusBar'

export * from './Http'

export * from './Auth'

export * from './Tracking'

const min = 60
const hour = 60 * 60
const day = 60 * 60 * 24

export function formatTime(second: number = 0) {
  if (second > day) {
    return (second / day).toFixed(1) + '天'
  } else if (second > hour) {
    return (second / hour).toFixed(1) + '小时'
  } else if (second > min) {
    return (second / min).toFixed(1) + '分'
  } else {
    return '暂无数据'
  }

}

interface ClockRes {
  clockinNumbers: number
}

//打开方法
export const requestClockIn = async () => {
  const user = auth.getUser()
  // 如果登录了
  if (user.token) {
    // 今天没打卡就是0,进行自动打卡
    if (user.clockinNumbers === 0) {
      // 打卡,res是打完卡的天数，记得更新
      const res = await http.request<ClockRes>({
        url: 'hm/clockin',
        method: 'post'
      })
      // 把打卡后的天数更新一下
      user.clockinNumbers = res.clockinNumbers
      promptAction.showToast({
        message: '打卡成功'
      })
      auth.setUser(user)
    }
    // 跳转到打卡界面
    router.pushUrl({
      url: '@bundle:com.blend.harmony1/interview/ets/pages/ClockInPage'
    })
  } else {
    // 登录界面
    router.pushUrl({
      url: '@bundle:com.blend.harmony1/interview/ets/pages/LoginPage'
    })
  }
}

export const calcPercent = (done: number, total: number) => {
  return Math.round((done / total * 100)) + '%'
}

// 从rawFile目录的json文件中读取字符串内容
export const getStrFromJson = (context: Context, path: string) => {
  // 跨HSP包访问resource资源，需要指定HSP module，可以通过resourceManager进行访问操作
  return new util.TextDecoder().decodeToString(context.createModuleContext('interview')
    .resourceManager.getRawFileContentSync(path))
}