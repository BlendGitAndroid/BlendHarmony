import { FoodItem } from '../models'

PersistentStorage.persistProp('cart_list', [])

export class CartStore {
  // 添加购物车
  static addCart(food: FoodItem, flag: boolean = true) {
    // 1. 获取本地村粗的list
    const list = AppStorage.get<FoodItem[]>('cart_list') || []
    // 2. 查找index,如果没有找到,则是-1
    const index = list.findIndex((item: FoodItem) => item.id === food.id)
    // 如果是增加
    if (flag) {
      // 如果没有找到,说明是首次添加
      if (index < 0) {
        const newFood: FoodItem = new FoodItem()
        newFood.name = food.name
        newFood.count = food.count
        newFood.selectCount = 1
        newFood.price = food.price
        newFood.picture = food.picture
        newFood.id = food.id
        list.unshift(newFood)
      } else {
        // 如果找到了
        list[index].selectCount!++
        // 强制叫第一层变化下,在鸿蒙中,即使是存储,也是第一层改变才更新UI
        list.splice(index, 1, list[index])
      }
    } else {
      console.log(`CartStore 111`)
      // 如果是删除
      list[index].selectCount!--
      if (list[index].selectCount! == 0) {
        list.splice(index, 1) // 删除掉这个index,从index位置开始,删除1个
      } else {
        list.splice(index, 1, list[index]) // 删除掉这个index,从index位置开始,删除1个,并添加上list[index]
      }
    }
    // 更新存储
    AppStorage.setOrCreate('cart_list', list);
  }

  static clearCart() {
    AppStorage.setOrCreate('cart_list', [])
  }
}