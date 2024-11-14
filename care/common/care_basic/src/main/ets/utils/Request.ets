// 导出封装的axios的实例
import { Log } from '@abner/log'
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { TokenManager } from '.'
import { router } from '@kit.ArkUI'
import { RouterConfig } from '../constants'

// 创建一个axios的实例
const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net', // 基础地址
  timeout: 20000 // 网络请求超时时间
})

// 理解为什么 error: AxiosError 可以写在 use 方法中，关键在于理解 TypeScript 的类型系统和 Axios 的运行时行为。
// 在 TypeScript 中，any 类型表示任意类型。onRejected 的参数类型定义为 any，这意味着你可以传递任何类型的参数，包括 AxiosError。
// 在运行时，Axios 会根据请求或响应的具体情况传递相应的错误对象。对于请求拦截器和响应拦截器，错误对象通常是 AxiosError 类型。
// 两个拦截器,请求拦截器
instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  // config就是请求的参数 地址 以及一些头信息
  Log.info("1.请求参数：" + JSON.stringify(config))
  const user = await TokenManager.getUser()
  if (user.token) {
    config.headers.Authorization = user.token // 统一注入token
  }
  return config // 返回的这个参数是必须的 axios就是用我们返回的这个config发送请求
}, (error: AxiosError) => {
  Log.error("3.异常信息：" + JSON.stringify(error))
  return Promise.reject(error)
})

// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // response是服务器返回的结果
  // axios的默认返回选项是 包了一层data的数据
  Log.info("2.响应结果：" + JSON.stringify(response.data))
  // 判断是否执行成功
  if (response.data && response.data.code !== 200) {
    // 说明执行出现问题 要提示错误 返回promise的异常
    AlertDialog.show({ message: response.data.msg }) // 提示错误
    return Promise.reject(new Error(response.data.msg))
  }
  return response.data.data // 直接返回我们需要的数据

}, (error: AxiosError) => {
  // 4xx 5xx会走到axios的响应拦截器的错误回调函数中
  Log.error("3.异常信息：" + JSON.stringify(error))
  if (error.response?.status === 401) { // token失效
    TokenManager.delUser() // 删除原有token
    router.replaceUrl({
      url: RouterConfig.LOGIN_URL
    })
  } else {
    // 除401之外的错误可以弹出显示
    AlertDialog.show({ message: error.message }) // 弹出错误信息
  }
  return Promise.reject(error)
})

// R是返回的类型 D是请求类型
// 之所以把R写在前面,是因为请求参数有时候不用写
export function request<Response = null, DataParams = null>(config: AxiosRequestConfig<DataParams>) {
  return instance<null, Response, DataParams>(config)
}