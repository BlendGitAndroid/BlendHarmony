import { request } from "../utils"
import { LoginParams, UserDataModel } from '../viewmodel'

// 登录接口
export function loginApi(data: LoginParams): Promise<string> {
  return request<string, LoginParams>({
    url: '/employee/login',
    method: 'post',
    data
  })
}

// 获取用户接口
export function getUserApi(): Promise<UserDataModel> {
  return request<UserDataModel>({
    url: '/employee/user',
  })
}

// 更新用户头像
export function updateUserAvatar(avatar: string): Promise<null> {
  return request<null>({
    url: '/employee/user/updateAvatar',
    method: "put",
    params: {
      avatar
    }
  })
}

// 更新用户头像
export function updateUserNickName(nickName: string): Promise<null> {
  return request<null>({
    url: '/employee/user/updateNickname',
    method: "put",
    params: {
      nickName
    }
  })
}

