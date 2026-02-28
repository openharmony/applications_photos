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

import lazy {
  ActionBarColorMode,
  ActionBarSelectionMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'SelectionTitle';

/**
 * 选择模式下标题信息，内容将随被选择图片数量而改变
 */
@Component
export struct SelectionTitle {
  @Link actionBarProp: ActionBarProp;
  @Consume('selectedCount') count: number;
  @LocalStorageLink('isSelectionTitle') isSelectionTitle: boolean = true;
  @LocalStorageLink('isActionBarColorNormal') private isActionBarColorNormal: boolean = true;
  @Prop immersiveController: ImmersiveController;
  @Prop isEllipsis: boolean = true;
  @Link private titleWidth: number;
  private selectTitleTopPadding: number = 5;

  build() {
    Row() {
      Text(!this.actionBarProp.getIsNeedTitle() ? '' : (this.actionBarProp.getSelectionMode() ===
      ActionBarSelectionMode.MULTI ?
        (this.count <= 0 ? ActionBarProp.MULTI_UNSELECT_TITLE :
          (this.actionBarProp.getMaxSelectCount() > 0 ?
          ActionBarProp.getCountDetailExternalSelectedTitle(this.count,
            this.actionBarProp.getMaxSelectCount()) :
          ActionBarProp.getCountDetailSelectedTitle(this.count))) :
      ActionBarProp.SINGLE_UNSELECT_TITLE))
        .draggable(false)
        .fontSize(DeviceInfo.isTv() ? 40 : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
        .maxFontScale(1.0)
        .minFontScale(1.0)
        .minFontSize(DeviceInfo.isPc() ? undefined : $r('sys.float.Caption_M'))
        .maxFontSize(DeviceInfo.isTv() ? undefined : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .fontWeight(DeviceInfo.isTv() ? FontWeight.Medium : AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT)
        .fontColor(this.getSelectionTitleColor())
        .maxLines(DeviceInfo.isPc() ? 1 : 2)
        .textOverflow({ overflow: this.isEllipsis ? TextOverflow.Ellipsis : TextOverflow.None })
        .key('SelectionTitleText')
        .textShadow({
          radius: this.immersiveController && this.immersiveController.enable ?
          this.immersiveController.textFontShadowRadius : 0,
          color: this.immersiveController && this.immersiveController.enable ?
          this.immersiveController.textFontShadowColor : $r('app.color.transparent')
        })
        .height(DeviceInfo.isTv() ? $r('app.float.tv_sidebar_text_height') : undefined)
        .fontFamily(DeviceInfo.isTv() ? 'HarmonyHeiTi' : undefined)
        .margin({ top: DeviceInfo.isTv() ? this.selectTitleTopPadding : undefined })
    }
    .key('SelectionTitle')
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
      if (newValue?.width) {
        this.titleWidth = Number(newValue?.width);
        Log.info(TAG, `onSizeChange, titleWidth: ${this.titleWidth}`);
      }
    })
    .alignItems(VerticalAlign.Center)
    .visibility(this.isSelectionTitle ? Visibility.Visible : Visibility.Hidden)
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, count: ${this.count}, ${this.actionBarProp.getIsNeedTitle()}`);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'selectionTitle aboutToAppear start..')
  }

  private getSelectionTitleColor(): ResourceColor {
    /* instrument ignore next */
    if (DeviceInfo.isTv() || DeviceInfo.isPc()) {
      return this.isActionBarColorNormal ? $r('sys.color.font_primary') :
      $r('sys.color.ohos_id_color_text_primary_dark');
    }
    return this.immersiveController && this.immersiveController.enable ?
    this.immersiveController.textFontColor : this.actionBarProp.getColorMode() ===
      ActionBarColorMode.TRANSPARENT ? ActionBarProp.TRANSPARENT_TEXT_COLOR :
      ActionBarProp.NORMAL_TEXT_COLOR;
  }
}