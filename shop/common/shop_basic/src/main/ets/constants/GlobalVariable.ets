export class GlobalVariable {
  static readonly BREAK_POINT_KEY: string = "break_point" // 全局变量的key
  static readonly SAFE_AREA_TOP: string = "safe_area_top" // 顶部安全区的高度的key
  static readonly SAFE_AREA_BOTTOM: string = "safe_area_bottom" // 底部安全区的高度的key
  static readonly BASE_URL: string = "https://meikou-api.itheima.net" // 网络请求基础地址
  // code成功标识
  static readonly SUCCESS_CODE: string = "1" // 成功标识
  // 用户存储用户信息的key
  static readonly USER_INFO_KEY: string = "user_info_key" // 用户信息的key
  static readonly SWITCH_TAB: string = "switch_tab" // 切换tab的key
  static readonly FORM_ID_LIST: string = "form_id_list" // 存储卡片id的列表
  static readonly CARD_IMAGE_DATA: string = "card_image_data" // 图片数据
}

// 存储业务类型的常量
export class BusinessVariable {
  static readonly CATEGORY_DATA: string = "category" // 成功标识
  static readonly CART_COUNT: string = "cart_count" // 购物车数量的key
  static readonly UPDATE_CART_LIST: string = "update_cart_list" // 更新购物车列表
  static readonly UPDATE_HOME_DATA: string = "update_home_data" // 更新首屏数据
  static readonly TO_SEARCH: string = "to_search" // 更新首屏数据
}