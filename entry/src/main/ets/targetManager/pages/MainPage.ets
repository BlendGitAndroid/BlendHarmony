/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import TargetInformation from '../view/TargetInformation';
import AddTargetDialog from '../view/AddTargetDialog';
import TargetList from '../view/TargetList';
import DataModel, { TaskItemBean } from '../viewmodel/DataModel';
import { CommonConstants } from '../common/constant/CommonConstant';
import getCurrentTime from '../common/utils/DateUtil';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct MainPage {

  @State targetData: Array<TaskItemBean> = DataModel.getData();
  @State totalTasksNumber: number = 0;
  @State completedTasksNumber: number = 0;
  @State latestUpdateDate: string = CommonConstants.DEFAULT_PROGRESS_VALUE;

  // @Provide和@Consume，应用于与后代组件的双向数据同步，应用于状态数据在多个层级之间传递的场景。
  // @Watch应用于对状态变量的监听。如果开发者需要关注某个状态变量的值是否改变，可以使用@Watch为状态变量设置回调函数。
  // overAllProgressChanged这个变量更改,就会调用 onProgressChanged 函数
  @Provide @Watch('onProgressChanged') overAllProgressChanged: boolean = false;

  // CustomDialogController来控制自定义弹窗的显示和隐藏
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddTargetDialog({
      onClickOk: (value: string): void => this.saveTask(value)
    }),
    alignment: DialogAlignment.Bottom,
    offset: {
      dx: CommonConstants.DIALOG_OFFSET_X,
      dy: $r('app.float.dialog_offset_y')
    },
    customStyle: true,
    autoCancel: false
  });

  /**
   * Listening targetData.
   */
  onProgressChanged() {
    this.totalTasksNumber = this.targetData.length;
    this.completedTasksNumber = this.targetData.filter((item: TaskItemBean) => {
      return item.progressValue === CommonConstants.SLIDER_MAX_VALUE;
    }).length;
    this.latestUpdateDate = getCurrentTime();
  }

  build() {
    Column() {
      this.titleBar()
      TargetInformation({
        latestUpdateDate: this.latestUpdateDate,
        totalTasksNumber: this.totalTasksNumber,
        completedTasksNumber: this.completedTasksNumber
      })
      TargetList({
        targetData: $targetData,
        onAddClick: (): void => this.dialogController.open()
      })
        .height(CommonConstants.LIST_BOARD_HEIGHT)
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.index_background'))
  }

  @Builder
  titleBar() {
    Text($r('app.string.target_manager_title'))
      .width(CommonConstants.TITLE_WIDTH)
      .height($r('app.float.title_height'))
      .fontSize($r('app.float.title_font'))
      .fontWeight(CommonConstants.FONT_WEIGHT_LARGE)
      .textAlign(TextAlign.Start)
      .margin({
        top: $r('app.float.title_margin'),
        bottom: $r('app.float.title_margin')
      })
  }

  /**
   * Save the progress value and update time after you click OK in the dialog box.
   *
   * @param taskName Latest Progress Value.
   */
  saveTask(taskName: string) {
    if (taskName === '') {
      promptAction.showToast({
        message: $r('app.string.cannot_input_empty'),
        duration: CommonConstants.TOAST_TIME,
        bottom: CommonConstants.TOAST_MARGIN_BOTTOM
      });
      return;
    }
    DataModel.addData(new TaskItemBean(taskName, 0, getCurrentTime()));
    this.targetData = DataModel.getData();
    this.overAllProgressChanged = !this.overAllProgressChanged;
    this.dialogController.close();
  }
}