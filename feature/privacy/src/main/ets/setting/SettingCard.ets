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

import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

/* instrument ignore file */
const TAG: string = 'SettingCard';

const LARGE_SIZE_FONT: number = 1.75;
const STRONG_SIZE_FONT: number = 2;
const HEAVY_SIZE_FONT: number = 3.2;

@Component
export default struct SettingCard {
  private title?: Resource | string;
  // 记录当前系统放大倍率模式
  @StorageProp('currentFontSizeScale') @Watch('currentFontSizeScaleChange') currentFontSizeScale: number = 1;
  @State private listPaddingTopAndBottom: Resource = DeviceInfo.isPc() ?
    $r('sys.float.padding_level5') : $r('sys.float.padding_level6');

  aboutToAppear(): void {
    this.currentFontSizeScaleChange();
  }

  private currentFontSizeScaleChange(): void {
    if (this.currentFontSizeScale === HEAVY_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level12');
    } else if (this.currentFontSizeScale === STRONG_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level10');
    } else if (this.currentFontSizeScale === LARGE_SIZE_FONT) {
      this.listPaddingTopAndBottom = $r('sys.float.padding_level8');
    } else {
      this.listPaddingTopAndBottom = DeviceInfo.isPc() ?
        $r('sys.float.padding_level5') : $r('sys.float.padding_level6');
    }
  }

  @Builder
  buildSymbolIcon() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .draggable(false)
        .fontSize($r('app.float.ic_gallery_form_arrow'))
        .fontColor([$r('sys.color.icon_fourth')])
    }
    .align(Alignment.End)
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start,
    }) {
      Column() {
        Text(this.title)
          .draggable(false)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontFamily('HarmonyHeiTi')
          .width('100%')
          .key('AccountUserName')
          .constraintSize({ minHeight: $r('app.float.account_name_height') })
          .maxFontScale(3.2)
          .padding({
            top: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
            bottom: DeviceInfo.isPc() ? 0 : Constants.SETTING_TEXT_TOP_BOTTOM_PADDING,
          })
      }
      .margin({
        top: this.listPaddingTopAndBottom,
        bottom: this.listPaddingTopAndBottom,
        right: $r('sys.float.ohos_id_text_margin_horizontal'),
      })
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      this.buildSymbolIcon();
    }
    .key('ExpandedServiceCard')
  }
}