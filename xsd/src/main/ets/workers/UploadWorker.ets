import { ImageListModel } from '@blend/basic';
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, util, worker } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;


interface WorkerParams {
  files: ImageListModel[]
  filePath: string
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = async (e: MessageEvents) => {
  //   接收主线程传来的消息
  //   console  fs文件模块
  const data = e.data as WorkerParams
  console.log('data -----> ', JSON.stringify(data.files)) // 本地的路径

  //
  const imagePackerApi = image.createImagePacker() // 创建一个图片编码器

  let arr: ImageListModel[] = []

  while (data.files.length) {
    let fileObj = data.files.pop()
    // 根据文件的路径, 打开一个文件
    const sourceFile = fileIo.openSync(fileObj?.url, fileIo.OpenMode.READ_ONLY)

    //   创建一个新文件
    const newFileName = data.filePath + '/' + util.generateRandomUUID() + '.jpg'
    const targetFile = fileIo.openSync(newFileName, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)

    //   编码旧图片到新图片文件中
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: 20 };

    await imagePackerApi.packToFile(image.createImageSource(sourceFile.fd), targetFile.fd,
      packOpts) // 把一个文件 重新编码到另外一个文件中

    arr.push({ url: newFileName })

    fileIo.close(sourceFile.fd)
    fileIo.close(targetFile.fd)

  }

  // 子线程主动告诉主线程消息
  workerPort.postMessage({
    files: arr
  })

  workerPort.close()


}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}