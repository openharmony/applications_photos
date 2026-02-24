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

import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';

/* instrument ignore next */
@Component
export struct FastPlayLabel {
  // 记录当前系统深浅色模式
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  @Prop isHorizontal: boolean = false;
  @Prop isPullingUp: boolean = false;
  // actionbar的顶部padding值，在平板状态下不为0
  private actionBarTopPadding: number = 0;

  /* instrument ignore next */
  private initActionBArTopPadding(): void {
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      this.actionBarTopPadding = PhotoConfig.isLibrary() ?
      px2vp(Constants.LIBRARY_ACTION_BAR_PADDING_TOP_PX_TABLET) :
      Constants.MAP_ALBUM_TITLE_PADDING_TABLET
    } else {
      this.actionBarTopPadding = 0;
    }
  }

  /* instrument ignore next */
  aboutToAppear(): void {
    this.initActionBArTopPadding();
  }

  /* instrument ignore next */
  build() {
    Stack() {
      Row({ space: Constants.COLUMN_ITEM_SPACING_SMALL }) {
        SymbolGlyph($r('sys.symbol.fast_forward'))
          .fontSize(Constants.FAST_FORWARD_ICON_SIZE)
          .fontColor([Color.White])
          .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
        Text('2.0X')
          .fontColor(Color.White)
          .fontSize(Constants.FAST_PLAY_LABEL_TEXT_FONT_SIZE)
          .fontWeight(FontWeight.Regular)
      }
      .padding({
        top: Constants.COLUMN_ITEM_PADDING_Y_SMALL,
        bottom: Constants.COLUMN_ITEM_PADDING_Y_SMALL,
        left: Constants.COLUMN_PADDING_LEFT,
        right: Constants.COLUMN_PADDING_RIGHT,
      })
      .alignItems(VerticalAlign.Center)
      .borderRadius(Constants.PERCENT_50)
      .justifyContent(FlexAlign.Center)
      .backgroundBlurStyle(BlurStyle.COMPONENT_THIN, {
        colorMode: ThemeColorMode.DARK,
        adaptiveColor: AdaptiveColor.DEFAULT,
        scale: Constants.FAST_PLAY_LABEL_BACKGROUND_BLUR_SCALE,
      })
      .backgroundColor(Constants.FAST_PLAY_LABEL_BACKGROUND_COLOR);
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .alignContent(Alignment.Top)
    .offset({
      y: this.actionBarTopPadding +
        ((!this.isHorizontal && !DeviceInfo.isVerdeFoldable()) || DeviceInfo.isFoldable() ?
        Constants.FAST_PLAY_LABEL_POSITION_Y_VERTICAL : Constants.FAST_PLAY_LABEL_POSITION_Y_HORIZONTAL)
    })
    .markAnchor({
      x: this.isPullingUp && DeviceInfo.isTablet() && !this.isHorizontal ? Constants.PERCENT_NEGATIVE_25 : 0,
      y: this.isPullingUp && !DeviceInfo.isFoldable() && !DeviceInfo.isTablet() &&
        !this.isHorizontal ? Constants.PERCENT_NEGATIVE_25 : 0
    })
  }
}

