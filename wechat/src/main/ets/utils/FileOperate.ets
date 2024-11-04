// fs和fileIo功能基本一致
import { fileIo } from '@kit.CoreFileKit'

export class FileOperate {
  // 1.创建文件(音频)
  static createAudioFile(userId: string) {
    //并不是把所有人的文件都放到一个目录
    //一个人一个目录->创建文件夹
    const dirPath = getContext().filesDir + '/' + userId
    const flag = fileIo.accessSync(dirPath)
    if (!flag) {
      // 创建文件夹
      fileIo.mkdirSync(dirPath)
    }
    // 此时一定有文件夹,创建文件
    // 1.1准备文件的路径()
    let filePath = dirPath + '/' + Date.now() + '.wav'
    // 1.2打开文件(如果没有这个文件，就会创建,就是file)
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE)
    // 读取的话....文件的操作
    // 1.3关闭文件
    fileIo.closeSync(file)
    // 返回文件的路径
    return filePath
  }

  //  2.删除文件
  static delFilePath(filePath: string) {
    if (filePath) {
      // 删除一个文件
      fileIo.unlinkSync(filePath)
    }
  }

  //  3.删除整个人的聊天文件
  static delUserPath(userId: string) {
    //删除一个目录
    if (userId) {
      //有没有文件目录
      const dirPath = getContext().filesDir + '/' + userId
      const flag = fileIo.accessSync(dirPath)
      if (flag) {
        //   删除文件夹
        fileIo.rmdirSync(dirPath)
      }
    }
  }
}