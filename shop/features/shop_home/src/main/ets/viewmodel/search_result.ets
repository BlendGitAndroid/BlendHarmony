import { GoodsItems } from "@shop/basic"

// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
export interface SearchRouterParam {
  keyword: string
}

// { a:1, b: 2, c: 3, d: 4 .... } as { a: number }

export interface SearchResult {
  // 其余属性舍弃
  pageData: GoodsItems
}