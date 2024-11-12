@Component
export struct HmCalendar {
  // 当前月份天数
  @State
  dayNum: number = 31
  // 1号前面空几天
  @State
  freeDay: number = 0
  // 当前是几号
  @State
  currentDate: number = 0
  // 当前是几月
  @State
  currentMonth: number = 0
  // 当前是哪一年
  @State
  currentYear: number = 0
  @State
  circleRadius: number = 6
  @State
  circleBackgroundColor: ResourceColor = '#ccc'
  @State
  circleActiveColor: ResourceColor = '#ff00ff0f'
  @State
  gutter: number = 10
  // 展示图形还是数字
  @State
  showType: 'number' | 'shape' = 'shape'
  @State
  showOperate: boolean = true
  @State
  showWeek: boolean = true
  weekDays: string[] = ['一', '二', '三', '四', '五', '六', '日']

  // 思考题1：
  // 圆点 | 方块儿 | 三角形 ...
  // 思考题2：
  // 日历的国际化：支持中英文切换
  // 思考题3：
  // 选中高亮:选中>当前>默认
  // 总结：
  // 组件封装 -
  // 可复用性:实现功能基础上，灵活复用
  // 可拓展性:后续在基础上可以继续增加功能

  aboutToAppear(): void {
    //   当前月份的天数？
    const year = new Date().getFullYear()
    this.currentYear = year
    const month = new Date().getMonth()
    this.currentMonth = month
    this.calcDate(year, month)
  }

  // 计算日期
  calcDate(year: number, month: number) {
    this.dayNum = new Date(year, month + 1, 0).getDate()
    // 当前几号 （减1是为了和索引匹配）
    this.currentDate = new Date().getDate() - 1
    //   这个月1号是周几？
    // 0空6 5空4 4空3 3空2
    const day = new Date(year, month, 1).getDay()
    this.freeDay = day === 0 ? 6 : day - 1
  }

  build() {
    Column() {
      // 日历操作
      if(this.showOperate){
        Row() {
          Image($r('sys.media.ohos_ic_public_play_last'))
            .width(24)
            .aspectRatio(1)
            .fillColor(this.circleBackgroundColor)
            .onClick(() => {
              this.currentMonth--
              if (this.currentMonth < 0) {
                this.currentMonth = 11
                this.currentYear--
              }
              this.calcDate(this.currentYear, this.currentMonth)
            })
          Text((this.currentYear) + '年' + (this.currentMonth + 1) + '月')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor(this.circleBackgroundColor)
          Image($r('sys.media.ohos_ic_public_play_next'))
            .width(24)
            .aspectRatio(1)
            .fillColor(this.circleBackgroundColor)
            .onClick(() => {
              this.currentMonth++
              if (this.currentMonth > 11) {
                this.currentMonth = 0
                this.currentYear++
              }
              this.calcDate(this.currentYear, this.currentMonth)
            })
        }
        .width('100%')
        .padding(16)
      }

      // .justifyContent(FlexAlign.SpaceBetween)

      // 日历展示：
      GridRow({ columns: 7, gutter: this.gutter }) {
        // 展示星期数
        if (this.showWeek) {
          ForEach(Array(7).fill(() => 1), (item: number, index) => {
            GridCol() {
              Text(this.weekDays[index])
                .fontColor(this.circleBackgroundColor)
            }
          })
        }

        ForEach(Array(this.freeDay).fill(() => 1), () => {
          GridCol() {
            Row()
              .width(this.circleRadius)
              .aspectRatio(1)
              .borderRadius(this.circleRadius / 2)
          }
        })
        //日历天数
        ForEach(Array(this.dayNum).fill(() => 1), (item: number, index) => {
          GridCol() {
            if (this.showType === 'number') {
              Text((index + 1).toString().padStart(2, '0'))
                .fontSize(14)
                .fontColor(new Date().getFullYear() === this.currentYear &&
                  new Date().getMonth() === this.currentMonth && index === this.currentDate ? this.circleActiveColor :
                this.circleBackgroundColor)
            } else {
              // shape
              Row()
                .width(this.circleRadius)
                .aspectRatio(1)
                .borderRadius(this.circleRadius / 2)
                .backgroundColor(index === this.currentDate ? this.circleActiveColor : this.circleBackgroundColor)
            }

          }
        })
      }
    }
  }
}