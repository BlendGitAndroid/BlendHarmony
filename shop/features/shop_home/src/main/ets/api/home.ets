import { RequestAxios, CategoryItem, HDMGoodsItem } from '@shop/basic'
import { Banner, Goods, HotResult, SearchResult } from '../viewmodel'

// 封装六个接口


export const getBannerAPI = () => {
  return RequestAxios.get<Banner[]>("/home/banner")
}

export const getCategoryAPI = () => {
  return RequestAxios.get<CategoryItem[]>("/home/category/head")
}

// 获取特惠推荐
export const getHotResultAPI = () => {
  return RequestAxios.get<HotResult>("/hot/preference")
}

// 爆款推荐
export const getInVogueAPI = () => {
  return RequestAxios.get<HotResult>("/hot/inVogue")
}

// 一站买全
export const getOneStopAPI = () => {
  return RequestAxios.get<HotResult>("/hot/oneStop")
}

// 获取新鲜好物
export const getHomeNewAPI = () => {
  return RequestAxios.get<HDMGoodsItem[]>("/home/new")
}

// 获取推荐列表
export const getRecommendAPI = (params: object) => {
  return RequestAxios.get<HDMGoodsItem[]>("/home/recommend", params)
}

// 搜索商品
export const searchGoodsAPI = (data: object) => {
  return RequestAxios.post<SearchResult>("/search/all", data)
}

// 获取商品详情
export const getDetailAPI = (id: string) => {
  return RequestAxios.get<Goods>(`/goods?id=${id}`)
  // /list  { id: 1, name: '张三' } => /list?id=1&name=张三
}
