// 使用axios上传 直接调用方法即可 不需要使用upload
import { FormData } from '@ohos/axios'

import { request } from '../utils/Request'

// 上传接口
export function uploadApi(data: FormData): Promise<string> {
  return request<string, FormData>({
    url: '/common/upload',
    method: 'post',
    headers: {
      "Content-Type": "multipart/form-data"
    },
    data,
    context: getContext() // 上下文
  })
}