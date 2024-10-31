import { http } from '@kit.NetworkKit'
import { Category } from '../models'

export const getData = async () => {
  const req = http.createHttp()
  const res = await req.request('https://zhousg.atomgit.net/harmonyos-next/takeaway.json')
  if (typeof res.result === 'string') { // 类型检查和类型守卫
    return JSON.parse(res.result) as Category[]
  } else {
    return []
  }
}