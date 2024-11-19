import { request } from "@kit.BasicServicesKit"
import { util } from "@kit.ArkTS"

export class DownLoadManager {
  // 下载完成的地址要返回给调用者
  async downLoadImages(list: string[]) {
    // request.downloadFile(getContext())
    const taskList = list.map((url): Promise<string> => this.downloadSingle(url))
    // [Promise1, Promise2, Promise3....]
    return await Promise.all(taskList)
  }

  // 单个下载
  private downloadSingle(url: string) {
    return new Promise<string>(async (resolve, reject) => {
      let savePath = getContext().tempDir + "/" + util.generateRandomUUID() + ".jpg"
      const task = await request.downloadFile(getContext(), {
        url,
        filePath: savePath
      })
      task.on("complete", () => {
        resolve(savePath)
      })
      task.on("fail", () => {
        reject(new Error("上传失败"))
      })
    })

  }
}

export const downLoadManager = new DownLoadManager()