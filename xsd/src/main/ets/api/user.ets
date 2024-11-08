import { Request } from '@blend/basic'
import { LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParamsModel } from '../models'

/** 登录接口 */
export function loginAPI(data: LoginFormModel) {
  return Request.post<string>('/driver/login/account', data)
}

/** 查询用户信息 */
export function getUserInfoAPI() {
  return Request.get<UserInfoModel>('/driver/users')
}


/** 查询用户的运输任务接口 */
export function getUserTaskInfoAPI(data: UserTaskInfoParamsModel) {
  return Request.get<UserTaskInfoModel>('/driver/users/taskReport', data)
}