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
export struct ActionButton {
  src: Resource = $r('app.media.alt_placeholder');
  text: Resource | null = null;
  textSize: number | Resource = $r('app.float.buttonActionTextSize_default');
  isActive: boolean = false;
  actionID: number = Constants.NEGATIVE_1;
  sizeDefault: number | Resource = $r('app.float.ic_size_default');
  heightOfActionButton: number | Resource = $r('app.float.actionButton_default');
  widthOfActionButton: number | Resource = $r('app.float.actionButton_default');
  isCropStyleButton: boolean = false;
  @Consume broadCast: BroadCast;
  componentKey: string = '';

  aboutToAppear() {
    if (this.text == undefined) {
      this.heightOfActionButton = $r('app.float.buttonWithoutText');
      this.widthOfActionButton = $r('app.float.buttonWithoutText');
    }
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      if (this.text != undefined) {
        // 图标+文字的ActionButton
        Image(this.src)
          .width(this.sizeDefault)
          .height(this.sizeDefault)
          .fillColor(this.isActive ? $r('app.color.photo_edit_active_color') : $r('app.color.default_white_color'))
        Row() {
          Text(this.text)
            .fontSize(this.textSize)
            .fontColor(this.isActive
              ? $r('app.color.photo_edit_active_color') : $r('app.color.default_white_color'))
        }
        .margin({
          top: $r('app.float.actionBar_margin'),
          left: $r('app.float.actionBar_margin'),
          right: $r('app.float.actionBar_margin')
        })
      } else {
        Image(this.src)
          .width(this.sizeDefault)
          .height(this.sizeDefault)
          .objectFit(ImageFit.Contain)
          .fillColor(this.isActive ? $r('app.color.photo_edit_active_color') : $r('app.color.default_white_color'))

      }
    }
    .height(this.text != undefined ? this.heightOfActionButton : this.sizeDefault)
    .width(this.text != undefined ? this.widthOfActionButton : this.sizeDefault)
    .key('ActionButton' + this.componentKey)
    .onClick(() => {
      this.broadCast.emit(Constants.UPDATE_MENU, [this.actionID]);
    })
  }
}