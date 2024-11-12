// 目标：axios二次封装
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { QuestionItem, User } from '../../model'
import { QuestionType } from '../../views/Home/HomeCategory'
import { buffer } from '@kit.ArkTS'
import { auth } from '.'

// 1.后台给的数据结构定死了
// success boolean 成功标识 可选
// code number code,10000 正常，其他为失败 可选
// message string 消息 可选
// data object 响应结果
interface Res<T> {
  success: boolean
  code: number
  message: string
  data: T
}

// 请求跟地址+超时时长配置
export const baseURL = 'https://api-harmony-teach.itheima.net/'

export const timeout = 10 * 1000

// 应用配置
const instance = axios.create({
  baseURL,
  timeout
})
// 拦截器：
// 请求:携带token参数
// 响应：返回结果的处理
// 请求发送到服务器之前的一次拦截 - 设置请求配置信息
// 收到服务器响应结果响应之前的一次拦截 - 数据的处理，异常处理
// 成功 和 失败 两种状态
// config 请求配置 （请求头，地址，参数等等）


instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 业务：.
  // TODO:携带登录信息..
  const user = auth.getUser()
  if (user.token) {
    //   添加token
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
}, (err: Error) => {
  promptAction.showToast({
    message: '请求参数错误'
  })
  return Promise.reject(err)
})


instance.interceptors.response.use((res: AxiosResponse) => {
  // TODO:数据的加工处理
  // 1.接口调通了
  // 业务成功/业务失败
  // 返回成功结果 - 返回错误结果
  // 2.接口没调通
  // 错误信息

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
      url: '@bundle:com.blend.harmony/interview/ets/pages/LoginPage'
    }, router.RouterMode.Single)
    return
  }
  promptAction.showToast({
    message: '响应错误：' + err.message
  })
  return Promise.reject(err)
})

// ----------------------------------------------------------------------
class Http {
  // ResponseData是调用时候传递的类型，他表示返回值的类型
  request<ResponseData, RequestData = Object>(config: AxiosRequestConfig<RequestData>) {
    // 二次封装的核心思想是传递参数，该修改的地方修改
    // 1.只需要传递响应结果的类型即可
    return instance<null, ResponseData, RequestData>(config)
  }
}

export const http = new Http()

