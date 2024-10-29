interface OrderRecord {
  orderName: string
  orderAmount: number
  orderDate: Date
}

@Entry
@Component
export struct ForEachCase {
  // ForEach(
  // // 数据源
  // arr: Array,
  // // 组件生成函数
  // itemGenerator: (item: 单项, index?: number) => void,
  // // 键值生成函数
  // keyGenerator?: (item: 单项, index?: number): string => string
  // )


  // 面试会问的知识：
  // ForEach(要循环的数据(是一个数组) ，(item:类型 （ 数组的每一项）)=>{
  //     重复生成的结构体
  // },生成唯一标识的函数(字符串类型：索引+结构体的字符串格式JSON.stringify(item))，
  // 宁可不写也不要乱写)
  // ForEach的第三个属性是一个回调，它是生成唯一key的， 不传的话会帮助我们生成独一无二的key
  // index_ + JSON.stringify(item)
  //
  // 鸿蒙更新的原理：循环的比较-比较你的key存在不，0_"zhangsan" 如果存在相同的key，则不更新
  // 只改动了某一条数据，可能所有列表都会更新
  // ForEach的第三个参数 宁可不给 也不要瞎给


  orderList: OrderRecord[] = [
    {
      orderName: '给老婆买口红',
      orderAmount: 399,
      orderDate: new Date('2024/5/11')
    },
    {
      orderName: '给老婆买花',
      orderAmount: 99,
      orderDate: new Date('2024/5/11')
    },
    {
      orderName: '给自己买手机',
      orderAmount: 9999,
      orderDate: new Date('2024/5/11')
    }
  ]

  build() {
    Column() {

      Row() {
        Text("支付记录")
      }.width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Center)
      .border({
        width: {
          bottom: 1
        },
        color: Color.Gray
      })

      Column() {
        ForEach(this.orderList, (item: OrderRecord, index: number) => {
          Column({ space: 16 }) {
            Text(item.orderName)
              .fontWeight(FontWeight.Bold)

            Row() {
              Text('￥' + item.orderAmount.toFixed(2))
                .fontColor(Color.Red)
              Text(item.orderDate.toLocaleDateString())
            }.width('100%')
            .justifyContent(FlexAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)

          }.width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        })
      }.width('100%')
      .layoutWeight(1)

    }
    .width('100%')
  }
}
