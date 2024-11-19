import { GoodsItems, HDMGoodsItem } from '@shop/basic';

export interface Banner {
  id: string;
  imgUrl: string;
  type: string;
}


export interface Params {
  title: string,
  subTitle: string,
  bg: ResourceStr,
  list: HDMGoodsItem[]
}

export enum DiscountType {
  COMMAND,
  DISCOUNT,
  NEW
}

// 特惠推荐的接口
export interface HotResult {
  id: string;
  subTypes: SubType[];
  title: string;
}

export interface SubType {
  goodsItems: GoodsItems;
  id: string;
  title: string;
}


// 推荐列表的请求的参数的类型
export interface RecommendParams {
  limit: number
}