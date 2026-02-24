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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { display } from '@kit.ArkUI';

/* instrument ignore file */
const TAG: string = 'PickerSelectTip';

const PICKER_SELECT_TIPS_COL_HEIGHT: number = 28;

@Component
export struct PickerSelectTip {
  private tipsHeight: number = PICKER_SELECT_TIPS_COL_HEIGHT;
  private symbolFontColor: Resource[] =
    [$r('sys.color.font_tertiary')];
  private textFontColor: Resource = $r('sys.color.font_tertiary');
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;

  aboutToAppear(): void {
    Log.info(TAG, `PickerSelectTip is aboutToAppear.`)
  }

  build() {
    Row() {
      // PickerShieldAnimate.animateType暂不支持监听状态变量变化，暂时使用条件分支实现
      // if (this.isVerdeFoldable) {
      //   PickerShieldAnimate({
      //     pickerType: PickerType.GALLERY_PICKER,
      //     animateType: AnimateType.TOAST
      //   })
      //   .hitTestBehavior(HitTestMode.None)
      // } else {
      //   PickerShieldAnimate({
      //     pickerType: PickerType.GALLERY_PICKER,
      //     animateType: AnimateType.TIP
      //   })
      //   .hitTestBehavior(HitTestMode.None)
      // }
    }
    .height(this.tipsHeight)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }
}