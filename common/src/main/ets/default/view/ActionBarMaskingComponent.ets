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
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';

import lazy { ImmersiveController } from '../utils/ImmersiveController';

/* instrument ignore file */
const TAG: string = 'ActionBarMaskingComponent';

@Component
export struct ActionBarMaskingComponent {
  @Prop private immersiveController: ImmersiveController;
  // 状态栏高度
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') statusBarHeight: number = 0;
  // 照片页右上角按钮的上下padding
  private static MENU_BUTTON_PADDING: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('sys.float.padding_level4')));
  // 照片页右上角按钮内容高度
  private static MENU_BUTTON_CONTENT_HEIGHT: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('app.float.action_bar_button_height')));
  private static MATH_TREBLE: number = 3;
  private static MATH_DOUBLE: number = 2;
  // 照片页右上角按钮高度
  private static MENU_BUTTON_HEIGHT: number = ActionBarMaskingComponent.MATH_DOUBLE *
  ActionBarMaskingComponent.MENU_BUTTON_PADDING + ActionBarMaskingComponent.MENU_BUTTON_CONTENT_HEIGHT;
  // 蒙层高度
  @State maskHeight: number = px2vp(this.statusBarHeight) +
    ActionBarMaskingComponent.MATH_TREBLE * ActionBarMaskingComponent.MENU_BUTTON_HEIGHT;

  private onStatusBarHeightChange(): void {
    this.maskHeight = px2vp(this.statusBarHeight) +
      ActionBarMaskingComponent.MATH_TREBLE * ActionBarMaskingComponent.MENU_BUTTON_HEIGHT;
  }

  build() {
    Column() {
    }
    .alignItems(HorizontalAlign.Start)
    .height(this.maskHeight)
    .width('100%')
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [[$r('app.color.timeline_mask_start_color'), 0.0], [$r('app.color.timeline_mask_end_color'), 1.0]],
    })
    .enabled(false)
    .opacity(this.immersiveController && this.immersiveController.enable ?
    this.immersiveController.currentMaskingLayerOpacity : 0)
    .visibility((this.immersiveController && this.immersiveController.enable &&
    this.immersiveController.isMaskingLayerShown()) ? Visibility.Visible : Visibility.Hidden)
  }
}
