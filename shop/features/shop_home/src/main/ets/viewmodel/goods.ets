import { HDMGoodsItem, HDMSkuType, HDMSpec } from '@shop/basic';

// 其他略
export interface GoodsProperty {
  name: string;
  value: string;
}

export interface GoodsDetail {
  pictures: string[];
  properties: GoodsProperty[];
}

// 7个属性 extend继承这7个属性 再增加5个属性
export interface Goods extends HDMGoodsItem {
  inventory: number
  mainPictures: string[]
  details: GoodsDetail
  specs: HDMSpec[]
  skus: HDMSkuType[]
}

export interface HmSpecValue {
  name: string
  picture: string | null
  selected: boolean | null
  disabled: boolean | null
}