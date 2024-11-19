import { RequestAxios } from '../utils'
import { GoodsItems } from '../viewmodels'


// 获取猜你喜欢的数据
export const getGuessData = (params: object) => {
  return RequestAxios.get<GoodsItems>("/home/goods/guessLike", params)
}