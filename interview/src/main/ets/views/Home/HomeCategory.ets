import { HmSkeleton, HmTag, QuestionItemComp, QuestionListComp } from '../../common/components'
import axios, { AxiosResponse } from '@ohos/axios'
import { http, UserStoreKey } from '../../common/utils'
import { promptAction } from '@kit.ArkUI'
import { QuestionItem, SortType } from '../../model'
import { HmSkeletonItem } from '../../common/components/HmSkeletonItem'
import { emitter } from '@kit.BasicServicesKit'

export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}

const mockData: QuestionType[] = [
  { id: 1, name: 'ArkTS', displayNewestFlag: 0 },
  { id: 2, name: 'ArkUI', displayNewestFlag: 1 },
  { id: 3, name: 'Hap', displayNewestFlag: 1 },
  { id: 4, name: 'Hsp', displayNewestFlag: 0 },
  { id: 5, name: 'Har', displayNewestFlag: 0 },
  { id: 6, name: 'Ability', displayNewestFlag: 0 },
  { id: 7, name: 'Stage', displayNewestFlag: 0 },
  { id: 8, name: 'Kit', displayNewestFlag: 0 }
]


@Component
export struct HomeCategory {
  @StorageProp('isDark')
  isDark: boolean = false
  // 当前的分类
  @State
  activeIndex: number = 0
  // 当前的排序
  @State
  sort: SortType = SortType.Default
  // 排序的索引
  @State
  filterIndex: number = 0
  @State
  filterSort: SortType = SortType.Default
  @State
  questionTypeList: QuestionType[] = mockData
  @State
  isShow: boolean = false
  @State
  loading: boolean = false

  @Builder
  TabBarBuilder(item: QuestionType, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(44)
          .fontSize(14)
        Row()
          .height(2)
          .width(this.activeIndex === index ? 20 : 0)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex === index ? 300 : 0 })
      }

      if (item.displayNewestFlag === 1) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({
            left: 4
          })
      }
    }
    .height('100%')
    .margin({
      left: 16,
      right: 16
    })
  }

  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            this.sort = SortType.Default
            this.filterIndex = 0
          })
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
          .onClick(() => {
            this.isShow = false
            this.activeIndex = this.filterIndex
            this.controller.changeIndex(this.activeIndex)
            // 问题：里面公用一个sort
            this.sort = this.filterSort
          })
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      // TODO 筛选按钮
      Flex() {
        FilterButton({
          text: '默认',
          isSelected: this.filterSort === SortType.Default,
          sort: this.filterSort
        })
          .onClick(() => {
            this.filterSort = SortType.Default
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          sort: this.filterSort,
          isSelected: this.filterSort === SortType.ViewLow || this.filterSort === SortType.ViewHigh
        })
          .onClick(() => {
            if (this.filterSort === SortType.ViewLow) {
              this.filterSort = SortType.ViewHigh
            } else {
              this.filterSort = SortType.ViewLow
            }
          })
        FilterButton({
          text: '难度',
          isSort: true,
          sort: this.filterSort,
          isSelected: this.filterSort === SortType.DifficultyLow || this.filterSort === SortType.DifficultyHigh
        })
          .onClick(() => {
            if (this.filterSort === SortType.DifficultyLow) {
              this.filterSort = SortType.DifficultyHigh
            } else {
              this.filterSort = SortType.DifficultyLow
            }
          })
        FilterButton({
          text: '推荐',
          sort: this.filterSort,
          isSelected: this.filterSort === SortType.Commend
        })
          .onClick(() => {
            this.filterSort = SortType.Commend
          })
      }

      Text('选择分类')
        .textTitle()
      // TODO 筛选按钮
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionType, i) => {
          Column() {
            FilterButton({
              text: item.name,
              isNew: item.displayNewestFlag === 1,
              isSelected: this.filterIndex === i
            })
              .onClick(() => {
                this.filterIndex = i
              })
          }
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }

  @Builder
  SkeletonBuilder() {
    HmSkeleton() {
      Column() {
        Row({ space: 16 }) {
          HmSkeletonItem({ widthValue: 60 })
          HmSkeletonItem({ widthValue: 100 })
          HmSkeletonItem({ widthValue: 80 })
          HmSkeletonItem({ widthValue: 40 })
        }
        .height(44)
        .width('100%')

        ForEach([1, 2, 3, 4, 5, 6], () => {
          Column({ space: 10 }) {
            HmSkeletonItem({ widthValue: '90%' })
            HmSkeletonItem({ widthValue: '45%' })
          }
          .height(80)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        })
      }
      .padding({ left: 16, right: 16 })
    }
  }

  controller: TabsController = new TabsController()

  async getQuestionTypeList() {
    this.loading = true
    const res = await http.request<QuestionType[], string>({
      url: 'hm/question/type'
    })
    // data是post请求时候携带的参数（不出现在url）
    // params是请求地址参数，出现在url上的
    this.questionTypeList = res
    setTimeout(() => {
      this.loading = false
    }, 1500)
  }

  async aboutToAppear() {
    // 首次进入跳转指定tab
    // setTimeout(() => {
    //   // this.activeIndex = this.questionTypeList.length-1
    //   //只跳转不更新数据
    //   this.controller.changeIndex(this.questionTypeList.length - 1)
    //   // 只更新数据不跳转
    //   this.activeIndex = this.questionTypeList.length - 1
    // }, 1)
    // http是自己的工具
    // request是自己封装的方法
    // <QuestionType[]>是响应结果的类型
    // string请求参数的类型
    // method是请求类型，不写默认是get请求
    this.getQuestionTypeList()
    //   订阅 - 保证自己能更新
    //   接收 - 线程内 -eventHub
    getContext().eventHub.on(UserStoreKey, () => {
      //   监听到了，然后要干嘛
      this.getQuestionTypeList()
    })
    //   接收 - 线程间 -emitter
    // emitter.on('13166669999',()=>{
    //   //   监听到了，然后要干嘛
    //   this.getQuestionTypeList()
    // })

  }

  build() {
    if (this.loading) {
      this.SkeletonBuilder()
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ controller: this.controller }) {
          ForEach(this.questionTypeList, (item: QuestionType, index: number) => {
            TabContent() {
              //   TODO:列表代码
              // 测试QuestionItemComp代码
              // Column({ space: 6 }) {
              //   // 测试Tag代码
              //   // HmTag({difficulty:1})
              //   // HmTag({difficulty:2})
              //   // HmTag({difficulty:3})
              //   // HmTag({difficulty:4})
              //   // HmTag({difficulty:5})
              //   // HmTag({text:'Harmony OS NEXT',color:'#ff00ff0f'})
              //   ForEach(new Array(10).fill(1), () => {
              //     QuestionItemComp({
              //       item:{
              //         id: '100',
              //         stem: '请说下ArkUI的容器组件有哪些？',
              //         difficulty: 3,
              //         likeCount: 23,
              //         views: 423,
              //         readFlag: 1
              //       }
              //     })
              //   })
              // }
              QuestionListComp({
                typeId: item.id,
                sort: this.sort,
                activeIndex: this.activeIndex,
                index
              })
                .layoutWeight(1)
            }.tabBar(this.TabBarBuilder(item, index))
          })
        }
        .barMode(BarMode.Scrollable)
        .barHeight(44)
        .scrollable(false)
        .onTabBarClick((index) => {
          this.activeIndex = index
        })
        .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })

        Row() {
          Image($r('app.media.ic_home_filter'))
            .width(24)
            .aspectRatio(1)
        }
        .width(56)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 90,
          colors: [[this.isDark ? '#00131313' : '#00FFFFFF', 0], [this.isDark ? '#131313' : '#FFFFFF', 0.285]]
        })
        .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
          showClose: false,
          height: 400
        })
        .onClick(() => {
          this.isShow = true
        })
      }
    }
  }
}

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}

@Component
struct FilterButton {
  text: string = '默认'
  isSort: boolean = false
  isNew: boolean = false
  @Prop
  isSelected: boolean = false
  // 排序模式
  @Prop
  sort: SortType = SortType.Default

  build() {
    Row() {
      Text(this.text)
        .fontSize(12)
        .fontColor(this.isSelected ? $r('app.color.common_main_color') : $r('app.color.black'))
      if (this.isNew) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .position({ right: -26, top: -7 })
      }
      if (this.isSort) {
        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .size({ width: 12, height: 6 })
            .fillColor(this.isSelected && this.sort % 2 === 0 ? $r('app.color.common_main_color') :
            $r('app.color.black'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .size({ width: 12, height: 6 })
            .fillColor(this.isSelected && this.sort % 2 === 1 ? $r('app.color.common_main_color') :
            $r('app.color.black'))
        }
        .margin({ top: -0.5, left: 2 })
      }
    }
    .height(30)
    .padding({ left: 10, right: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
    .borderRadius(4)
    .margin({ top: 12, right: this.isNew ? 26 : 10 })
  }
}

