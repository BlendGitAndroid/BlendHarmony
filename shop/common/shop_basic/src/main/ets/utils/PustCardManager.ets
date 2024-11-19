import { fileIo } from "@kit.CoreFileKit"
import { storeManager } from "."
import { formBindingData, formProvider } from "@kit.FormKit"
import { GlobalVariable } from "../constants"

export class PushCardManager {
  // list来自沙箱的地址列表 => 总体大小不能超过2M
  pushImageToCard(list: string[]) {
    // 控制卡片显示的数量 最好不要超过5张
    const images = list.slice(0, 5) // 要传递的图片
    let imageList: string[] = []
    let formImages: Record<string, number> = {}
    images.forEach(url => {
      // url是一个沙箱地址
      const file = fileIo.openSync(url, fileIo.OpenMode.READ_ONLY)
      imageList.push(url) // 添加到数组中
      formImages[url] = file.fd
      // 卡片上显示图片 图片地址:地址 - 地址: fd
      // file.fd

      // 传一张图片 - a.png- { formImages: { "a.png": 123, "b.png": '456' }, images: ["a.png", "b.png", "c.png"]  }
    })

    // imageList => ["xxx.png", "xxx.png"]
    // formImages => { xxx.png: 1, xxx.png: 2 }

    // 给所有的卡片推送图片数据
    const formIdList = storeManager.getFormId() // 能拿到所有的卡片id
    // 要推送的数据
    let data = formBindingData.createFormBindingData({
      formImages,
      imageList
    })
    AppStorage.setOrCreate(GlobalVariable.CARD_IMAGE_DATA, data) // 写入全局状态
    formIdList.forEach(formId => {
      formProvider.updateForm(formId, data)
    })
  }
}

export const pushCardManager = new PushCardManager()