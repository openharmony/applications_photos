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
import { Constants } from '../util/Const';

const TAG = 'FontAlignTools';

@Extend(Button)
function buttonBg() {
  .stateStyles({
    normal: {
      .backgroundColor($r('sys.color.comp_background_tertiary'))
    }
  })
}

@Component
export struct FontStyleTitleAndClose {
  public closeFontStyleCallback?: () => void;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text($r('app.string.text_style_imageEdit'))
        .fontFamily(Constants.DEFAULT_TEXTAREA_FONT_FAMILY)
        .fontWeight(FontWeight.Bold)
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Button() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize('20vp')
          .fontColor([$r('sys.color.icon_primary')])
          .opacity($r('sys.float.ohos_id_alpha_content_primary'))
          .width(18)
          .height(18)
      }
      .id('FontStyleCloseButton')
      .height(40)
      .width(40)
      .borderRadius(45)
      .buttonBg()
      .accessibilityText($r('app.string.petalClip_stylus_shut_down'))
      .onClick((): void => {
        if (this.closeFontStyleCallback) {
          this.closeFontStyleCallback();
        }
      })
    }
    .margin({ top: 8, left: 16, right: 16 })
    .height(56)
  }
}




