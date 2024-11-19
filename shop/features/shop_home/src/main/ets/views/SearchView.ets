import { GlobalVariable, PAGE_PATH } from '@shop/basic'
import { SearchRouterParam } from '../viewmodel'
import { HDMAudioSearch } from '../components'

@Preview
@Component
struct SearchView {
  @StorageProp(GlobalVariable.SAFE_AREA_TOP)
  topHeight: number = 0
  @State keyword: string = ''
  @Consume
  stackPath: NavPathStack

  aboutToAppear(): void {

  }

  aboutToDisappear(): void {
    // window.getLastWindow(getContext())
    //   .then((win) => {
    //     win.setWindowSystemBarProperties({ statusBarContentColor: '#000000' })
    //   })
  }

  build() {
    NavDestination() {
      Column() {
        // search
        Row() {
          Image($r('[shop_basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('[shop_basic].color.white'))
            .margin(13)
            .onClick(() => {
              this.stackPath.pop()
            })
          Search({ placeholder: '商品关键字...', value: this.keyword })
            .searchIcon({ src: $r('[shop_basic].media.ic_public_search'), color: $r('[shop_basic].color.gray') })
            .placeholderColor($r('[shop_basic].color.gray'))
            .placeholderFont({ size: 14 })
            .searchButton('搜索', { fontSize: 14, fontColor: $r('[shop_basic].color.red') })
            .backgroundColor($r('[shop_basic].color.white'))
            .textFont({ size: 14 })
            .layoutWeight(1)
            .padding(0)
            .margin(0)
            .height(36)
            .caretStyle({ color: $r('[shop_basic].color.red') })
            .defaultFocus(true)
            .onSubmit((value) => {
              // 可以跳转到搜索结果页 传递关键字
              // let params: SearchRouterParam = {
              //   keyword: value
              // }
              // this.stackPath.pushPathByName(PAGE_PATH.SEARCH_RESULT_PAGE, params)

              this.stackPath.pushPathByName(PAGE_PATH.SEARCH_RESULT_PAGE, {
                keyword: value
              } as SearchRouterParam)
            })


        }
        .padding({ top: this.topHeight, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[$r('[shop_basic].color.linear_begin'), 0], [$r('[shop_basic].color.linear_end'), 1]]
        })

        HDMAudioSearch({
          onComplete: (keyword) => {
            // 直接去搜索就可以了
            this.keyword = keyword
            this.stackPath.pushPathByName(PAGE_PATH.SEARCH_RESULT_PAGE, {
              keyword: keyword
            } as SearchRouterParam)
          }
        })
      }
    }
    .hideTitleBar(true)
  }
}

@Builder
function SearchViewBuilder() {
  SearchView()
}