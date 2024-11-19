import { RequestAxios } from "../utils"
import {
  AddCartParams,
  CartCount,
  CartGoodsModel,
  CreateOrderParams,
  CreateOrderResult,
  DeleteCartParams,
  PreOrder,
  UpdateCartParams
} from "../viewmodels"


export const addCartAPI = (data: AddCartParams) => {
  return RequestAxios.post<null>("/member/cart", data)
}

// 封装获取购物车数量的API
export const getCartCountAPI = () => {
  return RequestAxios.get<CartCount>("/member/cart/count")
}

// 获取购物车列表

export const getCartListAPI = () => {
  return RequestAxios.get<CartGoodsModel[]>("/member/cart")
  // json => JSON.parse() as CartGoodsModel[]
  // new Class的过程实际上由于Observed存在，开启一个监听
}

// 修饰购物车的单项
export const updateCart = (skuId: string, data: UpdateCartParams) => {
  return RequestAxios.put<CartGoodsModel>(`/member/cart/${skuId}`, data)
}

// C（Create- post新增）R（Read -get类型）U（update-put(全量)/patch（增量））D（delete-删除）
// 全量 数据库 => { a: 1, b: 2, c: 3, d: 4, e: 5 } -put => { a: 1, b: 2 } => 数据库 { a: 1, b: 2 }
// 增量 数据库 => { a: 1, b: 2, c: 3, d: 4, e: 5 } -patch => { a: 3, b: 4 } => 数据库 { a: 3, b: 4, c: 3, d: 4, e: 5 }

// 全选或者取消全选
export const selectOrUnSelect = (data: UpdateCartParams) => {
  return RequestAxios.put<null>(`/member/cart/selected`, data)
}

// 删除购物车

export const delCart = (data: DeleteCartParams) => {
  return RequestAxios.delete<null>(`/member/cart`, data)
}

// 获取订单结算信息

export const getPreOrderAPI = () => {
  return RequestAxios.get<PreOrder>("/member/order/pre")
}

// 创建订单拿到订单id
export const createOrderAPI = (data: CreateOrderParams) => {
  return RequestAxios.post<CreateOrderResult>("/member/order", data)
}