import { ProductNameList } from '../constants'

// 根据英文获取中文的方法

export function getDeviceMap(name: string) {
  return ProductNameList.find(item => item.en === name) // 返回的是个对象
}