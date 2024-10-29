interface AddressInfo {
  province: string
  city: string
  area: string
}

interface PersonInfo {
  name: string
  age: string
  gender: "男" | "女"
  address: AddressInfo
}

// 所有的鸿蒙的更新机制-关于对象层的， 所有的监听机制都只能监听到Object.keys(对象)中的可见属性，
// 但凡超过一层，是监测不到变化的。

// 发现第一层数据 比如 name/age/sex都是可以双向同步的，但是第二层的数据无法进行响应式更新
// 在鸿蒙开发中，我们应该明确，所有的响应式更新都只能是系统可观测的响应式更新，那什么是可观测的呢？
// 就是只有对象或者数组第一层的数据发生了变化，才可以被观测到，所以基于这种特性:
// 1. 当装饰的数据类型为boolean,string,number类型时,可以观察到数据的变化。
// 2. 当装饰的数据类型为class或者Object时,可以观察到自身的赋值的变化,和其属性赋值的变化,
// 即Object.keys(observedObject)返回的所有属性。
// 3.当装饰的对象是array时,可以观察到数组本身的赋值和添加、删除、更新数组的变化。但是数组项的属性的
// 变化观察不到。

@Entry
@Component
export struct StateCase2 {
  @State
  myInfo: PersonInfo = {
    name: "Blend",
    age: "20",
    gender: "男",
    address: {
      province: '广东',
      city: '广州',
      area: '天河'
    }
  }

  build() {
    Row() {
      Column({ space: 20 }) {

        Text(JSON.stringify(this.myInfo))

        Row() {
          Text("姓名：")
          TextInput({ text: this.myInfo.name })
            .layoutWeight(1)
            .onChange((value: string) => {

            })
        }

        Row() {
          Text('年龄：')
          TextInput({ text: this.myInfo.age })
            .layoutWeight(1)
            .onChange((value) => {
              // 1.数据已经改了！！！
              this.myInfo.age = value
            })
        }

        Row() {
          Text('性别：')
          Select([{ value: '男' }, { value: '女' }])
            .value(this.myInfo.gender)
            .layoutWeight(1)
            .onSelect((index: number, value: string) => {
              this.myInfo.gender = value as "男" | "女"
            })
        }

        Row({ space: 4 }) {
          Text('地址：')
          TextInput({ text: this.myInfo.address.province })
            .layoutWeight(1)
            .onChange((value) => {
              // 即使被@State修饰了，也不能在第二层发生变化的时候产生改变
              this.myInfo.address.province = value
              // 4.1这里的数据变了,但是UI不会发生变化
              // promptAction.showToast({
              //   message:JSON.stringify(this.myInfo)
              // })

              // 1.如果第二层及以后发生变化，也要更新第一层才生效
              // this.myInfo.address = {
              //   province: value,
              //   city: '桂林',
              //   area: '山水甲天下'
              // }

              // 2.我的目的是要一个新对象(改自己也可以生效)
              // this.myInfo = new PersonInfoModel({
              //   name:'小张',
              //   age:'20',
              //   gender:'女',
              //   address:{
              //     province:value,
              //     city:'桂林',
              //     area:'山水甲天下'
              //   }
              // })

              //   3.不new自己，只new第一层
              // this.myInfo.address = new AddressInfoModel({
              //       province:value,
              //       city:'桂林',
              //       area:'山水甲天下'
              // })

              //   4.为什么要new原来的对象
              // 4.2用改了的数据重新new一个对象出来，给回原来的第一层
              this.myInfo.address = new AddressInfoModel(this.myInfo.address)
            })
          TextInput({ text: this.myInfo.address.city }).layoutWeight(1)
            .onChange((value) => {
              this.myInfo.address.city = value
              // 这么写不行，这不是一个新对象
              // this.myInfo.address = this.myInfo.address
              this.myInfo.address = new AddressInfoModel(this.myInfo.address)
            })
          TextInput({ text: this.myInfo.address.area })
            .layoutWeight(1)

        }

      }
      .width('100%')
      .padding(20)
    }
    .height('100%')
  }
}

class AddressInfoModel implements AddressInfo {
  province: string = ''
  city: string = ''
  area: string = ''

  constructor(model: AddressInfo) {
    this.province = model.province
    this.city = model.city
    this.area = model.area
  }
}

class PersonInfoModel implements PersonInfo {
  name: string = ''
  age: string = ''
  gender: '男' | '女' = '男'
  address: AddressInfo = new AddressInfoModel({} as AddressInfo)

  constructor(model: PersonInfo) {
    this.name = model.name
    this.age = model.age
    this.gender = model.gender
    this.address = model.address
  }
}
