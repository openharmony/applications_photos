/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { BroadCast, Constants } from '@ohos/common';

@Component
export struct CropResetButton {
  @Consume broadCast: BroadCast;
  @Consume isCropReset: boolean;
  @State buttonStatus: String = Constants.BUTTON_STATUS_NORMAL;
  @State isPcStyle: boolean = true;
  @Consume('verticalScreen') isVerticalScreen: boolean;

  // 编辑重置按钮按照小按钮的参数设置
  build() {
    if (this.isPcStyle) {
      Stack() {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          Text($r('app.string.cropModeReset_text'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontColor('#5291FF')
            .textAlign(TextAlign.Center)
            .padding({
              left: $r('app.float.menu_padding_horizontal'),
              right: $r('app.float.menu_padding_horizontal')
            })
        }
        .height($r('app.float.small_button_height'))
        .borderRadius($r('app.float.small_button_radius'))
        .onClick(() => {
          this.broadCast.emit(Constants.CROP_RESET_CLICKED, []);
        })
        .backgroundColor('#1affffff')
        .opacity(this.isCropReset ? 1 : Constants.BUTTON_INVALID_OPACITY)
      }.borderRadius($r('app.float.small_button_radius'))
      .height($r('app.float.small_button_height'))
    } else {
      Column() {
        Text($r('app.string.cropModeReset_text'))
          .key('PhotoEditCropReset')
          .fontSize(this.isVerticalScreen ? Constants.VERTICAL_RESET_BUTTON_TEXT_SIZE :
          Constants.HORIZONTAL_RESET_BUTTON_TEXT_SIZE)
          .fontColor('#5291FF')
          .textAlign(TextAlign.Center)
          .visibility(this.isCropReset ? Visibility.Visible : Visibility.Hidden)
      }
      .onClick(() => {
        this.broadCast.emit(Constants.CROP_RESET_CLICKED, []);
      })
      .width(this.isVerticalScreen ? Constants.PERCENT_100 : Constants.HORIZONTAL_RESET_BUTTON_WIDTH)
      .height(this.isVerticalScreen ? Constants.VERTICAL_RESET_BUTTON_HEIGHT : Constants.HORIZONTAL_RESET_BUTTON_HEIGHT)
    }
  }
}