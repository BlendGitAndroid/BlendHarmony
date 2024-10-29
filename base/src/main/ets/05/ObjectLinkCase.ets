@Entry
@Component
export struct ObjectLinkCase {
  // @Observed与ObjectLink, 从名字上看,都是与Link相似
  // 1. ObjectLink只能修饰被Observed修饰的class类型.
  // 2. Observed修饰的class的数据如果是复杂数据类型，需要
  // 采用赋值的方式才可以具备响应式特性-因为它只能监听到第一层.
  // 3. ObjectLink修饰符不能用在Entry修饰的组件中
  // 4. ObjectLink修饰的属性只能改属性里面的值,不能改这个属性的地址

  // ObjectLink出现的根本原因就是鸿蒙的响应式数据只能更新到第一层,第二层等层之后的数据更新了UI并不会更新
  // 因此需要ObjectLink来更新第二层等层之后的数据更改的UI展示
  // 但是第一层的UI还是没有更新的,原因还是第二层的数据更改不会影响第一层UI的刷新,如这里的Text文本的展示

  @State
  goodsList: GoodsTypeModel[] = [
    new GoodsTypeModel({
      name: '瓜子',
      price: 3,
      count: 0
    }),
    new GoodsTypeModel({
      name: '花生',
      price: 3,
      count: 0
    }),
    new GoodsTypeModel({
      name: '矿泉水',
      price: 3,
      count: 0
    })
  ]

  build() {
    Column() {
      Text(JSON.stringify(this.goodsList))

      ForEach(this.goodsList, (item: GoodsTypeModel, index: number) => {
        // 2.传递给子组件一个对象(必须是@Observed修饰过的类new出来的一个对象)
        GoodItemLink({
          goodItem: item
        })
      })
    }
  }
}

@Component
struct GoodItemLink {
  // 这里能用State接收父组件的数据,是因为直接获取了父组件的引用,如果下面的引用被修改了,那么父子组件之间就失去关联了
  // 如 goodItem = [] 被重新赋值给了另外一个引用,当父组件修改的时候,子组件是不会变化的
  // 因为才会有了@Prop修饰符,让父子始终保持联动
  // 所以State和Prop的很像,都能驱动UI更新和响应式数据,只不过Prop能始终保持父子联动
  // @State
  // goodItem: GoodsTypeModel[] = []

  // 3.用ObjectLink修饰子组件的属性,不给初始值
  @ObjectLink
  goodItem: GoodsTypeModel

  build() {
    Row({ space: 20 }) {

      Text(this.goodItem.name)

      Text('￥' + this.goodItem.price)

      Image($r('sys.media.ohos_ic_public_remove_filled'))
        .width(20)
        .aspectRatio(1)
        .onClick(() => {
          this.goodItem.count--
        })

      Text(this.goodItem.count.toString())

      Image($r('sys.media.ohos_ic_public_add_norm_filled'))
        .width(20)
        .aspectRatio(1)
        .onClick(() => {
          this.goodItem.count++
          this.goodItem
        })
    }
    .width('100%')
    .padding(20)
  }
}

interface GoodsType {
  name: string

  price: number

  count: number
}

// 1.使用observed修饰一个类,观察这个类
@Observed
class GoodsTypeModel implements GoodsType {
  name: string = ''

  price: number = 0

  count: number = 0

  constructor(model: GoodsType) {
    this.name = model.name
    this.price = model.price
    this.count = model.count
  }
}
