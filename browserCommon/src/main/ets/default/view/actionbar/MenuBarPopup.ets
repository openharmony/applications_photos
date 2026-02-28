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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

const TAG = 'MenuBarPopup';

export class PopupStyle {
  public action: string = "";
  public photoCount: number = 0;
  public text: Resource | undefined = undefined;
  public isShow: boolean = false;
}

@Component
export struct MenuBarPopup {
  popupStyle: PopupStyle = new PopupStyle();

  constructor(popupStyle: PopupStyle) {
    super();
    this.popupStyle = popupStyle;
  }

  build() {
    Row() {
      Text(this.popupStyle.text)
        .fontSize($r('sys.float.Body_M'))
        .maxFontScale(Constants.FONT_SCALE_STRONG_SIZE)
    }
    .constraintSize({ maxWidth: $r('app.float.grid_more_height') })
    .padding($r('app.float.immersive_compared_tip_padding_top'))
  }
}