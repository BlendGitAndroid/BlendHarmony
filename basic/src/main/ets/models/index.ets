export * from './advert'

/** 首页Tab类型 */
export interface TabClass {
  title: string
  name: string
  icon?: ResourceStr
}

/** 路由页面跳转传参的id类型 */
export interface CommonRouterParams {
  id?: string
  oldTime?: string
  location?: string
  addExcept?: boolean
  formData?: object
}

// 可以复用的上传图片的数据模型 和 接口返回的图片数据的模型
export interface ImageListModel {
  /** 图片url */
  url: string;
}