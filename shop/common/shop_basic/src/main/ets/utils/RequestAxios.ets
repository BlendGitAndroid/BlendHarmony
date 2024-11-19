import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { GlobalVariable } from '../constants'
import { promptAction } from '@kit.ArkUI'
import { auth } from '.'

// 创建一个axios的实例
const instance = axios.create({
  baseURL: GlobalVariable.BASE_URL,
  timeout: 10000
})
// 请求拦截器 可以无数个 会按照注册顺序 挨个执行
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 1. todo 待注入token
  const user = auth.getUserInfo()
  if (user && user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
}) // 1

// axios的响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // 判断后台返回的接口是否真的成功
  // 这里有点反人类 any不能as, any类型可以.xxx.xxx
  if (response.data.code === GlobalVariable.SUCCESS_CODE) {
    // 真的成功了
    return response.data.result // 这里不确定类型
  }
  promptAction.showToast({ message: response.data.msg }) // 提示错误消息
  return Promise.reject(new Error(response.data.msg))
}, (error: AxiosError) => {
  const res = error.response?.data as object
  if (res) {
    promptAction.showToast({ message: res["msg"] })
  }
  return Promise.reject(error)
})

// axios返回的是Promise对象- 三种状态 pending(等待) fullfilled(成功) rejected(失败)

// 再造一个类 四个方法  get/post/delete/put
export class RequestAxios {
  // 查询方法
  // get和post区别- get的参数只能拼接到url地址上- 又叫做查询参数 query参数 url地址参数 地址栏参数 get参数
  static get<T>(url: string, params?: object): Promise<T> {
    return instance.get<null, T>(url, { params })
  }

  // 新增方法
  static post<T>(url: string, data?: object): Promise<T> {
    return instance.post<null, T>(url, data)
  }

  // 修改方法
  static put<T>(url: string, data?: object): Promise<T> {
    return instance.put<null, T>(url, data)
  }

  // 删除方法
  static delete<T>(url: string, data?: object): Promise<T> {
    return instance.delete<null, T>(url, { data })
  }
}
