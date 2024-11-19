export interface HDMGoodsItem {
  id: string
  name: string
  desc: string
  price: string
  picture: ResourceStr
  orderNum: number
}

export interface CategoryItem {
  children?: CategoryItemChild[]
  goods?: HDMGoodsItem[]
  id: string
  name: string
  picture: ResourceStr
}

export interface CategoryItemChild {
  id: string
  name: string
  picture: ResourceStr
}

export interface GoodsItems {
  counts: number;
  items: HDMGoodsItem[];
  page: number;
  pages: number;
  pageSize: number;
}

// 当前系统用户的类型
export interface HDMUser {
  token: string
  nickname: string
  avatar: string
  account: string
}

// 购物车
export interface CartGoods {
  count: number;
  id: string;
  name: string;
  picture: string;
  price: number;
  selected: boolean;
  skuId: string;
  stock: number;
  attrsText: string;
}

@Observed
// 监听了class中的set(设置值)/get(取值)方法
export class CartGoodsModel implements CartGoods {
  count: number = 0
  id: string = ''
  name: string = ''
  picture: string = ''
  price: number = 0
  selected: boolean = false
  skuId: string = ''
  stock: number = 0
  attrsText: string = ''

  constructor(model: CartGoods) {
    this.count = model.count
    this.id = model.id
    this.name = model.name
    this.picture = model.picture
    this.price = model.price
    this.selected = model.selected
    this.skuId = model.skuId
    this.stock = model.stock
    this.attrsText = model.attrsText
  }
}

// 加入购物车的类型参数

export interface AddCartParams {
  skuId: string
  count: number
}

// 购物车数量的类型

export interface CartCount {
  count: number
}

// 修改购物车数量的类型

export interface UpdateCartParams {
  selected: boolean
  count: number
}

export interface DeleteCartParams {
  ids: string[]
}


// 地址
export interface AddressItem {
  address: string
  contact: string
  fullLocation: string
  id: string
  isDefault: 0 | 1
  receiver: string
  provinceCode: number
  cityCode: number
  countyCode: number
}

// 订单
export interface OrderGoodsItem {
  attrsText: string;
  count: number;
  id: string;
  name: string;
  payPrice: string;
  picture: string;
  price: string;
  skuId: string;
  totalPayPrice: string;
  totalPrice: string;
}

// 摘要
export interface Summary {
  discountPrice: number;
  goodsCount: number;
  postFee: number;
  totalPayPrice: number;
  totalPrice: number;
}

// 结算信息
export interface PreOrder {
  goods: OrderGoodsItem[]
  userAddresses: AddressItem[]
  summary: Summary
}

// 创建订单商品信息
export interface CreateOrderParamsGoods {
  skuId: string
  count: number
}

// 生成订单参数
export interface CreateOrderParams {
  deliveryTimeType: number
  payType: number
  buyerMessage: string
  payChannel: number
  goods: CreateOrderParamsGoods[]
  addressId: string
}

// 创建订单结果
export interface CreateOrderResult {
  id: string
}

// 订单
export interface OrderItem {
  countdown: number;
  createTime: string;
  id: string;
  orderState: 1 | 2 | 3 | 4 | 5 | 6;
  payChannel: number;
  payLatestTime: string;
  payMoney: number;
  payType: number;
  postFee: number;
  skus: OrderSku[];
  totalMoney: number;
  totalNum: number;
}

// 订单 sku
export interface OrderSku {
  attrsText: string;
  curPrice: number;
  id: string;
  image: string;
  name: string;
  properties: Property[];
  quantity: number;
  realPay: number;
  spuId: string;
}

// 属性
export interface Property {
  propertyMainName: string;
  propertyValueName: string;
}

export interface  PayResultParams {
  payResult: boolean
  orderId:  string
}