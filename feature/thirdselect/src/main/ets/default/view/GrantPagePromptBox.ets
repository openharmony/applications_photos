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

import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { SecurityShieldWithGalleryIcon } from '@ohos/common/src/main/ets/default/view/dialog/PickerViewWarningDialog'

const TAG: string = 'GrantPagePromptBox';

@Component
export struct GrantPagePromptBox {
  @Link private count: number;
  private appName: string = '';
  private emitHidePickerViewWarningDialog?: Function;

  aboutToAppear(): void {
    Log.info(TAG, `GrantPagePromptBox aboutToAppear open appName: ${this.appName} count: ${this.count}`)
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'GrantPagePromptBox aboutToDisappearopen');
  }

  build() {
    Row() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start,
      }) {
        SecurityShieldWithGalleryIcon();
        this.buildContent();
      }
      .margin({
        right: '12vp',
        top: '12vp',
        left: '12vp',
        bottom: '12vp',
      })
    }
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .margin({
      right: '16vp',
      left: '16vp',
      bottom: '16vp',
    })
    .borderRadius($r('sys.float.corner_radius_level10'))
  }

  @Builder
  buildContent() {
    Column() {
      this.buildTitle();
      this.buildContentText();
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ start: LengthMetrics.vp(12) })
  }

  @Builder
  buildTitle() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start,
    }) {
      Text($r('app.plural.data_inherit_title', this.count, this.appName, this.count.toString()))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)

      SymbolGlyph($r('sys.symbol.xmark'))
        .accessibilityText($r('app.string.disable'))
        .draggable(false)
        .fontSize($r('app.float.picker_view_dialog_image_width'))
        .onClick(async (): Promise<void> => {
          if (this.emitHidePickerViewWarningDialog) {
            this.emitHidePickerViewWarningDialog();
          }
        })
        .fontColor([$r('sys.color.icon_secondary')])
    }
  }

  @Builder
  buildContentText() {
    Text($r('app.string.data_inherit_content')) {
    }
    .fontColor($r('sys.color.ohos_id_color_text_secondary'))
    .fontSize($r('sys.float.ohos_id_text_size_body2'))
    .fontFamily('HarmonyHeiTi')
    .fontWeight(FontWeight.Regular)
    .textAlign(TextAlign.Start)
    .margin({
      top: $r('app.float.picker_view_dialog_content_margin_top'),
    })
  }
}