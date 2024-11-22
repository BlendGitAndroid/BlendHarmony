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
  // 1号前面空几天
  @State
  offsetDay: number = 0

  aboutToAppear(): void {
    // 获取当前的月，日
    const dateObj = new Date()
    this.month = dateObj.getMonth() // 月
    this.date = dateObj.getDate() // 日

    // 下个月的时间戳
    const nextTemp =
      new Date(dateObj.getFullYear() + '-' + (this.month + 2) + '-' + this.date).getTime()
    // 当前月时间戳
    const currentTemp =
      new Date(dateObj.getFullYear() + '-' + (this.month + 1) + '-' + this.date).getTime()
    // 当前月多少天 = 时间戳差 / （24*60*60*1000）
    this.day = Math.floor((nextTemp - currentTemp) / (1000 * 60 * 60 * 24))
    // new Date(dateObj.getFullYear() + '-' + (this.month + 1)):这个构造函数将字符串转换为 `Date` 对象
    // 需要注意的是，JavaScript 的 `Date` 构造函数需要一个有效的日期格式。上面的表达式只提供了年份和月份，
    // 日期部分默认为 1，结果将是一个表示该月第一天的 `Date` 对象.
    // `getDay()` 方法返回一个表示星期几的数字，范围从 0（星期日）到 6（星期六）。
    // 获取 `dateObj` 所表示的年份和 `this.month` 所表示的月份的第一天是星期几，返回的值是一个介于 0 到 6 之间
    // 的数字，分别代表星期日到星期六。
    this.offsetDay = new Date(dateObj.getFullYear() + '-' + (this.month + 1)).getDay()
  }

  build() {
    Row() {
      Row() {
        // 文字日历
        Column({ space: 6 }) {
          Text(this.monthArr[this.month])
            .fontColor('#ffc83f39')
          // padStart: 在字符串的开头填充指定的字符，直到字符串达到给定的长度
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
          y: -16  // 向上移动16
        })

        // 每日推荐文字
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
            // `fill` 是一个数组方法，用于用指定的值填充数组的所有元素或部分元素,用1填充这个数组
            // 如果offsetDay是0,表示是星期日,那么前面就有6天
            // 否则前面就是offsetDay - 1个
            ForEach(Array(this.offsetDay === 0 ? 6 : this.offsetDay - 1).fill(1), () => {
              GridCol()
            })
            // 真正的日期
            ForEach(Array(this.day).fill(1), (item: number, index: number) => {
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