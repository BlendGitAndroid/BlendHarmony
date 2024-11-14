// 使用axios上传 直接调用方法即可
import { FormData } from '@ohos/axios'

import { request } from '../utils/Request'

// 上传接口,其方法内部调用了request.uploadFile
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