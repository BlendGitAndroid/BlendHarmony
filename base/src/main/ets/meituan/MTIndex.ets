import { getData } from './api';
import { MTBottom } from './components/MTBottom';
import { MTCart } from './components/MTCart';
import { MTMain } from './components/MTMain';
import { MTTop } from './components/MTTop';
import { Category } from './models';

@Entry({ routeName: 'MTIndex' })
@Component
export struct MTIndex {
  @State
  list: Category[] = []

  @Provide
  showCart: boolean = false;

  async aboutToAppear(): Promise<void> {
    this.list = await getData()
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 顶部
        MTTop()
        // 主界面
        MTMain({
          list: this.list
        }).layoutWeight(1)
      }
      .width('100%')
      .height('100%')

      // 显示购物车
      if (this.showCart) {
        MTCart()
      }

      // 浮动在底部的
      MTBottom()

    }
    .width('100%')
    .height('100%')
  }
}
