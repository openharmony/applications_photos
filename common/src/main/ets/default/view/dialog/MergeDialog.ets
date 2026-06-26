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

import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants } from '../../model/common/Constants';
import lazy { DialogCallback } from '../../model/common/DialogUtil';
import lazy { isOrientationHorizontal } from '../../model/common/ScreenManager';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../../default/utils/ReportToBigDataUtil';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy image from '@ohos.multimedia.image';
import lazy { Matrix4x4 } from '../../utils/Matrix4x4';
import lazy { ButtonOptions } from '../../utils/ButtonOptionUtil';
import lazy { Log } from '../../utils/Log';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { ImageUtil } from '../../utils/ImageUtil';

/* instrument ignore file */
const ACTION_BAR_OFFSET_HEIGHT: number = 24;
const PORTRAIT_LAST_INDEX: number = 4;

const TAG = 'MergeDialog';

@CustomDialog
export struct MergeDialog {
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State selectIndex: number = 0;
  public controller?: CustomDialogController;
  @Consume dialogCallback?: DialogCallback;
  @Consume dialogBroadCast: BroadCast;
  @Consume dialogMessage: Resource;
  @Consume isRemoveFromPortrait: boolean;
  @Consume isDuplicateNameMerge: boolean;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  dialogMarginBottom = Constants.ToolBarHeight + ACTION_BAR_OFFSET_HEIGHT +
  px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_dialog_margin_bottom')));
  public removeDialogRight: number = px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_end')));
  private calPadding: boolean = false;
  private buttonList: ButtonOptions[] = [{
    defaultFocus: false,
    value: $r('app.string.dialog_cancel'),
    buttonStyle: ButtonStyleMode.TEXTUAL,
    fontColor: $r('sys.color.font_emphasize'),
    action: () => {
    }
  }, {
    defaultFocus: true,
    value: $r('app.string.action_ok'),
    buttonStyle: ButtonStyleMode.TEXTUAL,
    fontColor: $r('sys.color.font_emphasize'),
    action: () => {
    }
  }]

  calcWidth(): number {
    return 102;
  }

  @Builder
  buildMergeDialog() {
    CustomContentDialog({
      primaryTitle: this.isDuplicateNameMerge ? $r('app.string.duplicate_name_merge_portrait_photo_title') :
      $r('app.string.merge_portrait_photo_title'),
      contentBuilder: (): void => {
        this.buildContent();
      },
      buttons: this.buttonList,
    })
  }

  @Builder
  buildContent() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.merge_portrait_photo_content'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('sys.color.font_primary'))
            .textAlign(TextAlign.Center)
            .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .margin({
          bottom: $r('app.float.dialog_window_margin'),
        })

      }
    }
    // 需要支持嵌套滚动
    .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
  }

  build() {
    this.buildMergeDialog();
  }
}