import { HmCalendar, HmCalendarSelectedDay } from '@ohmos/calendar'
import { HmNavBar } from '../common/components'
import { http } from '../common/utils'
import { ClockInfo, ClockInfoParams } from '../model'

interface DayBuilderParams {
  day: number
  text: string
}

@Entry
@Component
struct ClockInPage {
  @Builder
  dayBuilder(params: DayBuilderParams) {
    Column() {
      Row() {
        Text(params.day.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text('天')
          .fontSize(10)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ bottom: 8, left: 10 })
      }
      .alignItems(VerticalAlign.Bottom)

      Text(params.text)
        .fontSize(10)
        .fontColor($r('app.color.common_gray_01'))
    }.margin({ right: 36 })
  }

  // 签到信息
  @State
  clockInfo: ClockInfo = {
    clockinNumbers: 0,
    totalClockinNumber: 0,
    clockins: [],
    flag: false
  }
  // 签到的时间
  @State
  selectedDays: HmCalendarSelectedDay[] = []

  aboutToAppear(): void {
    this.getClockInfo({
      year: (new Date().getFullYear()).toString(),
      month: (new Date().getMonth() + 1).toString()
    })
  }

  async getClockInfo(params: ClockInfoParams) {
    const res = await http.request<ClockInfo>({
      url: 'hm/clockinInfo',
      params
    })
    this.clockInfo = res
    this.selectedDays = res.clockins.map((item) => {
      return { date: item.createdAt } as HmCalendarSelectedDay
    })
  }

  build() {
    Column({ space: 16 }) {
      HmNavBar({ title: '每日打卡', showRightIcon: false })
      Row() {
        this.dayBuilder({ day: this.clockInfo.totalClockinNumber, text: '累计打卡' })
        this.dayBuilder({ day: this.clockInfo.clockinNumbers, text: '连续打卡' })
      }
      .padding({
        top: 10,
        bottom: 25,
        left: 16,
        right: 16
      })
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Row() {
        HmCalendar({
          selectedDays: this.selectedDays,
          onChangeMonth:(month)=>{
            const arr = month.split('-')
            this.getClockInfo({
              year:arr[0],
              month:arr[1]
            })
          }
        })
          .borderRadius(8)
          .border({ width: 0.5, color: '#ededed' })
          .shadow({ color: '#ededed', radius: 16 })
          .backgroundColor($r('app.color.white'))
      }
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.clocked_bg'))
    .backgroundImageSize({ width: '100%' })
  }
}