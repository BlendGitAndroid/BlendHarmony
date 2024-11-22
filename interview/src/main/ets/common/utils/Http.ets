import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { User } from '../../model'
import { auth } from '.'

// 请求跟地址+超时时长配置
export const baseURL = 'https://api-harmony-teach.itheima.net/'

export const timeout = 10 * 1000

// 应用配置
const instance = axios.create({
  baseURL,
  timeout
})

// 请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const user = auth.getUser()
  if (user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
}, (err: Error) => {
  promptAction.showToast({
    message: '请求参数错误'
  })
  return Promise.reject(err)
})

// 返回拦截器
instance.interceptors.response.use((res: AxiosResponse) => {
  // 返回成功结果
  if (res.data.code === 10000) {
    return res.data.data
  }
  return Promise.reject(new Error(JSON.stringify(res.data)))
}, (err: AxiosError) => {
  // 401登录失效
  if (err.response?.status === 401) {
    // 提示：登录失效
    promptAction.showToast({
      message: '登录失效,请重新登录'
    })
    // 1.重新登录 - 删除无效的token
    auth.setUser({} as User)
    // 2.无感刷新 - refreshToken获取新的token写入，重发请求err.config
    // 跳转登录页面(历史记录只有一个登录页面)
    router.pushUrl({
      url: '@bundle:com.blend.harmony1/interview/ets/pages/LoginPage'
    }, router.RouterMode.Single)
    return
  }
  promptAction.showToast({
    message: '响应错误：' + err.message
  })
  return Promise.reject(err)
})

class Http {
  // ResponseData是调用时候传递的类型，他表示返回值的类型
  request<ResponseData, RequestData = Object>(config: AxiosRequestConfig<RequestData>) {
    // 二次封装的核心思想是传递参数，只需要传递响应结果的类型即可
    return instance<null, ResponseData, RequestData>(config)
  }
}

export const http = new Http()

