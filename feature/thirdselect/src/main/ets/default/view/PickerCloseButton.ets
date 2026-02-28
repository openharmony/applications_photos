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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';

export class FromBaseInfo {
  public isFromBase: boolean;
  public cancelFunc: Function | undefined;

  constructor(isFromBase: boolean, cancelFunc?: Function) {
    this.isFromBase = isFromBase;
    this.cancelFunc = cancelFunc;
  }
}

@Component
export struct PickerCloseButton {
  private pickerController: ThirdSelectGridController = new ThirdSelectGridController();
  private topMargin: Length = 0;
  private componentHeight: Length = 0;
  private fromBaseInfo: FromBaseInfo | undefined = this.getUIContext()
    .getSharedLocalStorage()?.get<FromBaseInfo>('FromBaseInfo');

  build() {
    Row(){
      Button({
        type: ButtonType.Circle,
        stateEffect: true,
      }) {
        SymbolGlyph(Action.PICKER_CLOSE.iconRes)
          .id(`Third_Select_${Action.PICKER_CLOSE.componentKey}`)
          .draggable(false)
          .fontSize($r('app.float.icon_size'))
          .fontColor([Action.PICKER_CLOSE.fillColor])
      }
      .accessibilityText($r('app.string.disable'))
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .backgroundBlurStyle(BlurStyle.NONE)
      .borderRadius($r('sys.float.corner_radius_level10'))
      .onClick(() => {
        if (this.fromBaseInfo && this.fromBaseInfo.isFromBase) {
          this.fromBaseInfo.cancelFunc?.(true);
          return;
        }
        this.pickerController.onCancelled();
      })
    }
    .alignItems(VerticalAlign.Center)
    .height(this.componentHeight)
    .margin({
      top: this.topMargin,
      right: $r('app.float.picker_close_button_padding_right_left'),
      left: $r('app.float.picker_close_button_padding_right_left')
    })
  }
}