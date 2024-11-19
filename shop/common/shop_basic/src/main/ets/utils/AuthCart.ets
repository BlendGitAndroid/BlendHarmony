import { BusinessVariable } from "../constants"
import { addCartAPI, getCartCountAPI } from "../api"
import { AddCartParams } from "../viewmodels"
import { auth, storeManager } from "."
import { formBindingData, formProvider } from "@kit.FormKit"

export class AuthCart {
  // 添加购物车
  async addCart(data: AddCartParams) {
    await addCartAPI(data)
    // 更新购物车数量
    this.updateCartCount() // 更新购物车数量
  }

  // 更新购物车 emitter/eventHub 通知购物车来更新列表
  async updateCartCount() {
    if (auth.getUserInfo()?.token) {
      try {
        const result = await getCartCountAPI()
        AppStorage.setOrCreate<number>(BusinessVariable.CART_COUNT, result.count)

        // 更新卡片上的数量
        this.updateCardData(result.count)

        // 触发更新
        getContext().eventHub.emit(BusinessVariable.UPDATE_CART_LIST) // 触发更新列表事件

      } catch (error) {
        // 购物车获取不到 出异常 那就退0
        AppStorage.setOrCreate<number>(BusinessVariable.CART_COUNT, 0)
      }
    } else {
      AppStorage.setOrCreate<number>(BusinessVariable.CART_COUNT, 0)
    }

  }

  // 更新卡片数据
  updateCardData(count: number) {
    // 要拿到所有的formId
    const formIdList = storeManager.getFormId()
    let param: Record<string, number> = {
      'count': count
    }
    let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    formIdList.forEach(formId => {
      formProvider.updateForm(formId, obj)
    })
  }
}

export const authCart = new AuthCart()