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

import lazy { AccessibilityUtil } from '../../utils/AccessibilityUtil';
import lazy { Log } from '../../utils/Log';

/* instrument ignore file */
const TAG: string = 'BlurImageComponent';

@Component
export struct BlurImageComponent {
  @Prop private topMargin: Length = 0;
  @Prop private bottomMargin: Length = 0;
  @Prop private textMessage: Resource = $r('app.string.Private_protection_view_photos');
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @Prop private accessibilityBackElementId: string = '';
  @Prop private needAccessibility: boolean = true;
  @Prop private message: string = '';

  build() {
    Stack({ alignContent: Alignment.Center }) {

      Column() {
        SymbolGlyph($r('sys.symbol.security_shield'))
          .fontSize($r('app.float.actionButton_default'))
          .draggable(false)
          .fontColor([$r('sys.color.icon_tertiary')])

        Text($r('app.string.Private_protection_in_progress'))
          .margin({ top: $r('app.float.private_shield_tip_margin') })
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.icon_secondary'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')

        Button({ type: ButtonType.Normal, stateEffect: true, buttonStyle: ButtonStyleMode.NORMAL }) {
          Text(this.textMessage)
            .fontColor($r('sys.color.font_emphasize'))
            .fontSize($r('sys.float.Body_L'))
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .constraintSize({ minHeight: $r('app.float.details_dialog_button_height') })
            .margin({
              left: $r('app.float.dialog_double_buttons_margin'),
              right: $r('app.float.dialog_double_buttons_margin'),
            })
        }
        .borderRadius($r('sys.float.corner_radius_level10'))
        .backgroundColor($r('app.color.transparent'))
        .onClick((): void => {
        })
        .focusable(true)
        .defaultFocus(true)
        .id('PrivateInProgressButton')
        .key('PrivateInProgressButton')
        .accessibilityText(this.textMessage)
        .accessibilityLevel('yes')
      }
      .onAppear(() => {
        Log.info(TAG, `BlurImageComponent onAppear message: ${this.message}`);
        if (this.isOpenTouchGuide && this.needAccessibility) {
          Log.info(TAG, 'BlurImageComponent sendFocusAccessibilityEvent PrivateInProgressButton');
          AccessibilityUtil.sendFocusAccessibilityEvent('PrivateInProgressButton');
        }
      })
      .onDisAppear(() => {
        Log.info(TAG, `BlurImageComponent onDisAppear message: ${this.message}`);
        if (this.isOpenTouchGuide && this.needAccessibility) {
          Log.info(TAG, `BlurImageComponent sendFocusAccessibilityEvent: ${this.accessibilityBackElementId}`);
          AccessibilityUtil.sendFocusAccessibilityEvent(this.accessibilityBackElementId);
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: this.topMargin, bottom: this.bottomMargin })

  }
}