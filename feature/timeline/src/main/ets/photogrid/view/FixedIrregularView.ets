/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

/* instrument ignore file */

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { FixedIrregularViewVm } from '../viewmodel/FixedIrregularViewVm';
import lazy { FixedIrregularViewVc } from '../viewcontroller/FixedIrregularViewVc';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { TRASH_MSG_BOTTOM, TRASH_HEIGHT } from '../statemanager/constants/GridDefine';
import lazy { SdCardDataView } from './common/SdCardDataView';
import lazy {
  ScreenManager,
  getScreen,
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

const TAG: string = 'FixedIrregularView';

/**
 * 固定不规则区域视图构建参数
 */
export interface FixedIrregularViewBuildParams {
  /**
   * 实例ID
   */
  persistentId: number;
}

/**
 * 固定不规则区域视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function fixedIrregularViewBuilder($$: FixedIrregularViewBuildParams): void {
  FixedIrregularView({
    persistentId: $$.persistentId,
  })
}

/**
 * 宫格中固定不规则区域视图
 */
@Component
export struct FixedIrregularView {
  // 外部导入属性
  public persistentId: number = 0;
  public viewModel: FixedIrregularViewVm = new FixedIrregularViewVm();
  @State public controller: FixedIrregularViewVc = new FixedIrregularViewVc();

  aboutToAppear(): void {
    LogUtils.info(TAG, 'FixedIrregularView aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    if (DeviceInfo.isPhoneUx() && this.controller.isShowTrashMessage) {
      getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.controller.onWinSizeChanged);
    }
    LogUtils.info(TAG, 'FixedIrregularView aboutToAppear finish');
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'FixedIrregularView aboutToDisappear');
    if (DeviceInfo.isPhoneUx() && this.controller.isShowTrashMessage) {
      getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.controller.onWinSizeChanged);
    }
    this.controller.release();
    this.viewModel.release();
  }

  @Builder
  IsTrashMessageBuilder() {
    Text($r('app.string.delete_prompt_message', Constants.RECYCLE_DAYS_MAX))
      .fontColor($r('sys.color.font_secondary'))
      .fontSize($r('sys.float.Body_M'))
      .fontWeight(FontWeight.Regular)
      .textAlign(DeviceInfo.isPc()?TextAlign.Center:undefined)
      .width(Constants.PERCENT_100)
      .maxFontScale(Constants.FONT_SCALE_LEVEL1_SIZE)
      .margin({
        bottom: DeviceInfo.isPc()?TRASH_MSG_BOTTOM:0,
      })
      .onAreaChange(
        (oldVal: Area, newVal: Area) => {
          if (oldVal.height === newVal.height) {
            return;
          }
          let newHeight: number = newVal.height as number;
          if (DeviceInfo.isPc()) {
            newHeight = newHeight + TRASH_HEIGHT;
          }
          this.viewModel.updateMsgHeight(newHeight);
        }
      )
      .accessibilityText($r('app.string.delete_prompt_message', Constants.RECYCLE_DAYS_MAX))
      .onClick(() => {
        if (DeviceInfo.isPhoneUx()) {
          this.viewModel.onTrashMessageClick();
        }
      })
      .padding(DeviceInfo.isPhoneUx() ?
          this.controller.isHorizontal ?
          {
            left: this.controller.textPaddingLeftAndRight,
            top: $r('app.float.recycle_prompt_message_margin_top'),
            bottom: $r('app.float.recycle_prompt_message_margin_bottom'),
          } :
          {
            left: this.controller.textPaddingLeftAndRight,
            right: this.controller.textPaddingLeftAndRight,
            top: $r('app.float.recycle_prompt_message_margin_top'),
            bottom: $r('app.float.recycle_prompt_message_margin_bottom'),
          } :
        undefined
      )
  }

  @Builder
  SdCardBuilder() {
    SdCardDataView({
      isShowSdCard: this.controller.isShowSdCard,
      cardShowTitle: this.controller.cardShowTitle,
      cardShowSubTitle: this.controller.cardShowSubTitle,
      viewModel: this.viewModel,
    })
  }

  @Builder
  buildMsgScrollerView() {
    Column() {

      if (this.controller.isShowSdCard) {
        this.SdCardBuilder();
      }

      if (this.controller.isShowTrashMessage) {
        this.IsTrashMessageBuilder();
      }
    }
    .attributeModifier(this.controller.attributeUpdater)
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildMsgScrollerView();
    }
  }
}