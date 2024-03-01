/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import prompt from '@ohos.promptAction';
import { RankViewModel } from '../viewmodel/RankViewModel';
import { RankData } from '../viewmodel/RankData';
import { ListHeaderComponent } from '../view/ListHeaderComponent';
import { TitleComponent } from '../view/TitleComponent';
import { ListItemComponent } from '../view/ListItemComponent';
import { APP_EXIT_INTERVAL, Style, TIME, TITLE, WEIGHT } from '../common/constants/Constants';

let rankModel: RankViewModel = new RankViewModel();

// ArkTS通过struct声明组件名，并通过@Component和@Entry装饰器，来构成一个自定义组件。
@Entry  // 一个页面有且仅有一个@Entry入口
@Component
struct RankPage {
  @State dataSource1: RankData[] = [];
  @State dataSource2: RankData[] = [];
  // The State is used to decide whether to switch the data of RankList.
  @State isSwitchDataSource: boolean = true;
  // It will record the time of clicking back button of system navigation.
  private clickBackTimeRecord: number = 0;

  // 创建自定义组件的新实例后，在执行其build()函数之前执行
  aboutToAppear() {
    this.dataSource1 = rankModel.loadRankDataSource1();
    this.dataSource2 = rankModel.loadRankDataSource2();
  }

  // 当用户点击返回按钮时触发，仅@Entry装饰的自定义组件生效
  onBackPress() {
    if (this.isShowToast()) {
      prompt.showToast({
        message: $r('app.string.prompt_text'),
        duration: TIME
      });
      this.clickBackTimeRecord = new Date().getTime();
      return true;
    }
    return false;
  }

  isShowToast(): boolean {
    return new Date().getTime() - this.clickBackTimeRecord > APP_EXIT_INTERVAL;
  }

  build() {
    Column() {
      // Title component in the top.
      TitleComponent({ isRefreshData: $isSwitchDataSource, title: TITLE })
      // The head style of List component.
      // 这里可以不写构造函数，但是可以通过构造函数传参？
      ListHeaderComponent({
        paddingValue: {
          left: Style.RANK_PADDING,
          right: Style.RANK_PADDING
        },
        widthValue: Style.CONTENT_WIDTH
      }).margin({
          top: Style.HEADER_MARGIN_TOP,
          bottom: Style.HEADER_MARGIN_BOTTOM
        })
      // The style of List component.
      this.RankList(Style.CONTENT_WIDTH)  // 使用时只需要使用this关键字访问@Builder装饰的函数名，即可快速创建布局。
    }
    .backgroundColor($r('app.color.background'))
    .height(WEIGHT)
    .width(WEIGHT)
  }

  // @Builder装饰器，来修饰一个函数，快速生成布局内容，从而可以避免重复的UI描述内容
  @Builder RankList(widthValue: Length) {
    Column() {
      List() {
        // 循环渲染
        ForEach(this.isSwitchDataSource ? this.dataSource1 : this.dataSource2,
          (item: RankData, index?: number) => {
            ListItem() {
              ListItemComponent({ index: (Number(index) + 1), name: item.name, vote: item.vote,
                isSwitchDataSource: this.isSwitchDataSource
              })
            }
          }, (item: RankData) => JSON.stringify(item))
      }
      .width(WEIGHT)
      .height(Style.LIST_HEIGHT)
      .divider({ strokeWidth: Style.STROKE_WIDTH })
    }
    .padding({
      left: Style.RANK_PADDING,
      right: Style.RANK_PADDING
    })
    .borderRadius(Style.BORDER_RADIUS)
    .width(widthValue)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
  }
}

