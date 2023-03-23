/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast'
import { Constants } from '../../../common/model/common/Constants'

@Component
export struct CropResetBar {
    @Consume broadCast: Broadcast;
    @Consume isCropReset: boolean;
    @Consume('verticalScreen') isVerticalScreen: boolean;

    build() {
        Flex({
            direction: FlexDirection.Column,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            Text($r('app.string.cropModeReset_text'))
                .fontSize($r('app.float.same_name_date_size'))
                .fontColor($r('app.color.id_color_isActive'))
                .textAlign(TextAlign.Center)
                .visibility(this.isCropReset ? Visibility.Visible : Visibility.Hidden)
        }
        .width(this.isVerticalScreen
            ? $r('app.float.edit_horizontal_toolBar_size') : $r('app.float.default_button_size'))
        .height(this.isVerticalScreen ? $r('app.float.offSet_size_1') : $r('app.float.default_button_size'))
        .onClick(() => {
            this.broadCast.emit(Constants.CROP_RESET_CLICKED, []);
        })
    }
}