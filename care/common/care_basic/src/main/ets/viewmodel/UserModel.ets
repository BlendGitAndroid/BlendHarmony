export interface LoginParams {
  /** 华为应用id */
  clientId: null | string;

  /** 华为应用秘钥 */
  clientSecret: null | string;

  /** 华为账号授权码 */
  code: string;

}

export interface UserData {
  /** 头像 */
  avatar: null | string;

  /** 用户id */
  id: string;

  /** 用户昵称 */
  nickName: string;

  /** 用户账号，即邮箱 */
  username: string;

}

// i2c
export class LoginParamsModel implements LoginParams {
  clientId: null | string = null
  clientSecret: null | string = null
  code: string = ''

  constructor(model: LoginParams) {
    this.clientId = model.clientId
    this.clientSecret = model.clientSecret
    this.code = model.code
  }
}
export class UserDataModel implements UserData {
  avatar: null | string = null
  id: string = ''
  nickName: string = ''
  username: string = ''

  constructor(model: UserData) {
    this.avatar = model.avatar
    this.id = model.id
    this.nickName = model.nickName
    this.username = model.username
  }
}
