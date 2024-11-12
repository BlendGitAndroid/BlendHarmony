import { http } from '@kit.NetworkKit'
import { UserSettingClass } from '.'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { promptAction, router } from '@kit.ArkUI'


// 定义3个参数: url method data参数

/** 每次后端响应的数据的类型,定义泛型 */
export interface ResponseData<T> {
  code: number
  msg: string
  data: T
}

const TAG = "HTTP-REQUEST"

// Http请求
export async function requestHttp<T>(url: string, method: http.RequestMethod = http.RequestMethod.GET, data?: object) {

  const req = http.createHttp()

  let urlStr = BASE_URL + url

  // 如果是GET请求
  if (method === http.RequestMethod.GET) {
    if (data) {
      // 把参数data对象中所有的属性, 拼接成查询参数  ?xxx=value&yyy=value2
      const paramsStr = Object.keys(data).map(item => {
        return `${item}=${data[item]}`
      }).join('&')

      urlStr += `?${paramsStr}`
    }
  }

  // http配置
  const options: http.HttpRequestOptions = {
    method,
    extraData: method !== http.RequestMethod.GET ? data : '', // 如果是GET请求,extraData是空;否则就是这个data对象,用于传递请求体内容
    expectDataType: http.HttpDataType.OBJECT, // 指定返回数据的类型为Object

    header: {
      Authorization: AppStorage.get(TOKEN_KEY), // header增加token
      ContentType: 'application/json' // header增加ContentType
    },
    readTimeout: 5 * 1000, // 超时
  }

  try {
    if (method !== http.RequestMethod.GET) {
      console.log(TAG, urlStr + " --- " + JSON.stringify(data, null, 2))
    } else {
      console.log(TAG, urlStr)
    }
    const res = await req.request(urlStr, options)

    console.log(TAG, JSON.stringify(res, null, 2))

    // 没有访问接口的权限 - token没有传或者是登录的token过期了
    if (res.responseCode === 401) {
      // 删除token
      const userSetting = new UserSettingClass(getContext())
      await userSetting.setToken('')
      AppStorage.set(TOKEN_KEY, '')
      // 提示用户
      promptAction.showToast({ message: '登录超时, 请重新登录' })
      router.clear() // 清空路由,跳转到登陆界面
      // 跳转到登录页面上去
      router.replaceUrl({ url: '@bundle:com.blend.harmony1/xsd/ets/pages/Login/Login' })
      return Promise.reject(new Error('登录超时, 请重新登录'))
    }

    if (res.responseCode === 404) {
      // 提示开发者, 你传递的url路径不存在
      promptAction.showToast({ message: '你的url路径找不到' })
      return Promise.reject(new Error('你的url路径找不到'))
    }

    // 判断业务状态码
    const result = res.result as ResponseData<T>

    // code为200时, 代表业务成功响应
    if (result.code === 200) {
      return result.data // 将结果对象返回去
    } else {
      promptAction.showToast({ message: '接口调用出错' })
      console.log('接口调用出错result -----> ', JSON.stringify(result))
      return Promise.reject(new Error('接口调用出错'))
    }

  } catch (err) {
    console.error('error', JSON.stringify(err))
    return Promise.reject(err)
  }

}


export class Request {
  /** T 代表的接口返回的数据的类型 后端返回的响应体中data的类型 */
  static get<T = null>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T = null>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T = null>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T = null>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}