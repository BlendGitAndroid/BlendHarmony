import { http } from '@kit.NetworkKit'
import { UserSettingClass } from '.'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { promptAction, router } from '@kit.ArkUI'


// 定义3个参数: url method data参数

/** 每次后端响应的数据的类型 */
export interface ResponseData<T> {
  /** code为200时, 代表业务成功响应 */
  code: number

  msg: string

  data: T
}


// get post put delete
export async function requestHttp<T>(url: string, method: http.RequestMethod = http.RequestMethod.GET, data?: object) {

  //   原生的http怎么写
  const req = http.createHttp()

  let urlStr = BASE_URL + url

  if (method === http.RequestMethod.GET) {
    if (data) {
      // 把参数data对象中所有的属性, 拼接成查询参数  ?xxx=value&yyy=value2
      const paramsStr = Object.keys(data).map(item => {
        return `${item}=${data[item]}`
      }).join('&')

      urlStr += `?${paramsStr}`
    }
  }


  const xxx: http.HttpRequestOptions = {
    method,
    extraData: method !== http.RequestMethod.GET ? data : '',
    expectDataType: http.HttpDataType.OBJECT,

    header: {
      Authorization: AppStorage.get(TOKEN_KEY), // TODO: 登录时要存token到APpStorage中一份
      ContentType: 'application/json'
    },
    readTimeout: 10000, // 如果多少秒没响应就断开
  }

  try {
    const res = await req.request(urlStr, xxx)

    if (res.responseCode === 401) { // 没有访问接口的权限 - token没有传或者是登录的token过期了
      //   删除token
      const userSetting = new UserSettingClass(getContext())
      await userSetting.setToken('')
      AppStorage.set(TOKEN_KEY, '')
      //   提示用户
      promptAction.showToast({ message: '登录超时, 请重新登录' })
      //   跳转到登录页面上去
      router.replaceUrl({ url: 'pages/Login/Login' })
      return Promise.reject(new Error('登录超时, 请重新登录'))

    }

    if (res.responseCode === 404) {
      //   提示开发者, 你传递的url路径不存在
      promptAction.showToast({ message: '你的url路径找不到' })
      return Promise.reject(new Error('你的url路径找不到'))
    }

    //   判断业务状态码

    const result = res.result as ResponseData<T>

    if (result.code === 200) {
      return result.data // 后端给的数据
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