import { logger } from '../utils/Logger'

@Component
export struct HmCalendar {
  // 枚举，数组
  monthArr: string[] = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
  // month 0~11 匹配数组的索引，几月
  @State
  month: number = 0
  // date 1~31 几号
  @State
  date: number = 1
  // 当前月多少天
  @State
  day: number = 30
  // 1号前面空几天？
  @State
  offsetDay: number = 0

  aboutToAppear(): void {
    //   获取当前的月，日
    const dateObj = new Date()
    this.month = dateObj.getMonth()
    this.date = dateObj.getDate()

    // 下个月的时间戳 - 当前时间戳
    // 时间戳差 / （24*60*60*1000） = 多少天
    // dateObj.getMonth()  0~11   new Date()需要传1~12
    const nextTemp =
      new Date(dateObj.getFullYear() + '-' + (this.month + 2) + '-' + this.date).getTime()
    const currentTemp =
      new Date(dateObj.getFullYear() + '-' + (this.month + 1) + '-' + this.date).getTime()
    this.day = Math.floor((nextTemp - currentTemp) / (1000 * 60 * 60 * 24))
    this.offsetDay = new Date(dateObj.getFullYear() + '-' + (this.month + 1)).getDay()

  }

  build() {
    Row() {
      Row() {
        // 文字日历
        Column({ space: 6 }) {
          Text(this.monthArr[this.month])
            .fontColor('#ffc83f39')
          Text(this.date.toString().padStart(2, '0'))
            .fontSize(32)
        }
        .padding(12)
        .backgroundColor($r('app.color.white'))
        .borderRadius(12)
        .shadow({
          radius: 4,
          color: '#ff87838c'
        })
        .position({
          x: 16,
          y: -16
        })

        //   每日推荐文字
        Column({ space: 6 }) {
          Text('每日一题')
            .fontSize(12)
          Text('ArkTS 有哪些装饰器？')
            .fontWeight(FontWeight.Bold)
            .fontSize(14)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 100
        })

        // 日历图表
        Column() {
          GridRow({ columns: 7, gutter: 6 }) {
            // 空白 1-6->0-5  0天->6
            ForEach(Array(this.offsetDay === 0 ? 6 : this.offsetDay - 1).fill(() => 1), () => {
              GridCol()
            })
            // 真正的日期
            ForEach(Array(this.day).fill(() => 1), (item: number, index: number) => {
              GridCol() {
                Row()
                  .width(6)
                  .aspectRatio(1)
                  .borderRadius(3)
                  .backgroundColor(this.date === (index + 1) ? '#ff00ff0f' : '#ccc')
              }
            })
          }
        }
        .width(120)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .padding({
          right: 16
        })
      }
      .width('100%')
      .height(80)
      .borderRadius(6)
      .backgroundColor('#edecf2')
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16
    })
  }
}