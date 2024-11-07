import request from '@ohos.request'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { promptAction } from '@kit.ArkUI'
import { ResponseData } from '../utils/request'
import { ImageListModel } from '../models'

export function uploadImageAPI(context: Context, files: request.File[]) {

  return new Promise<ImageListModel[]>(async (resolve, reject) => {
    const task = await request.uploadFile(context, {
      url: BASE_URL + '/driver/files/imageUpload', // 后端给的接口地址
      header: {
        Authorization: AppStorage.get(TOKEN_KEY),
        ContentType: 'multipart/form-data'
      }, // 请求头
      method: 'post', // 请求的方式
      files: files, // 上传的文件地址, 组成的数组
      data: [] // 附带的额外的数据
    }) // 上传的任务对象

    // 1. 准备一个数据, 每个图片上传成功后, 都把成功后的返回值, 保存到数据中
    let imageList: ImageListModel[] = []

    // 监听上传失败  弹出失败的原因
    task.on('fail', (err) => {
      AlertDialog.show({ message: JSON.stringify(err, null, 2), alignment: DialogAlignment.Center })
      console.log('上传失败了')
      reject(new Error('上传失败'))
    })

    // 每张图片上传成功都会触发headerReceive
    task.on('headerReceive', (obj: object) => {
      const result = JSON.parse(obj['body']) as ResponseData<string>
      if (result.code === 200) {
        // 2. 每次上传成功后, 都保存数据到imageList中
        imageList.push({ url: result.data })
      }
    })

    // 当所有的图片上传成功后会触发
    task.on('complete', () => {
      resolve(imageList)
    })
  })


}