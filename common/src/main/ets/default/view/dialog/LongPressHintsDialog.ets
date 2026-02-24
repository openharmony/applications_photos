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

import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';

const TAG: string = 'common_LongPressHintsDialog';
const MAX_TEXT_HEIGHT: number = 256;

@CustomDialog
export struct LongPressHintsDialog {
  public controller: CustomDialogController;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State textRes: string | Resource = $r('app.string.common_place_holder', '');
  @State iconRes: Resource = $r('app.string.common_place_holder', '');

  build() {
    Column() {
      SymbolGlyph(this.iconRes)
        .fontSize('64vp')
        .fontColor([$r('sys.color.icon_primary')])
        .margin({ top: 48, bottom: 16 })
      Text(this.textRes)
        .fontSize(32)
        .maxFontScale(1.75)
        .fontColor($r('sys.color.font_primary'))
        .margin({ left: 8, right: 8, bottom: 24 })
    }
    .width(256)
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .borderRadius($r('sys.float.corner_radius_level10'))
    .shadow(ShadowStyle.OUTER_DEFAULT_LG)

  }
}
