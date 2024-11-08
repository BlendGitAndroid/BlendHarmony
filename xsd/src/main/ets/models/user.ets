export interface LoginFormModel {
  /**
   * 登录账号
   */
  account: string;

  /** 密码 */
  password: string;


}


/**
 * 响应数据
 */
export interface UserInfoModel {
  /**
   * 头像
   */
  avatar: string;

  /**
   * 姓名
   */
  name: string;

  /**
   * 司机编号
   */
  number: string;

  /**
   * 手机号
   */
  phone: string;

}