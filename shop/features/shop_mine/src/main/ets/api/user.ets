import { HDMUser, RequestAxios } from '@shop/basic'
import { LoginParams } from '../viewmodels'


export const loginAPI = (data: LoginParams) => {
  return RequestAxios.post<HDMUser>("/login", data)
}