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

import { CropModeBar } from './CropModeBar'
import { PhotoEditMode } from '../base/PhotoEditType'
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast'

@Component
export struct MainMenuBar {
    src: string = '';
    @Consume('selected') selectedMode: number;
    @Consume('scale') imageScale: number;
    @Consume('barSize') barScale: Resource;
    @Consume broadCast: Broadcast;
    @Consume('verticalScreen') isVerticalScreen: boolean;

    build() {
        Flex({
            direction: this.isVerticalScreen ? FlexDirection.ColumnReverse : FlexDirection.RowReverse,
            alignItems: ItemAlign.Center,
        }) {
            Flex({
                direction: this.isVerticalScreen ? FlexDirection.ColumnReverse : FlexDirection.RowReverse,
                alignItems: ItemAlign.Center,
            }) {
                if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
                    CropModeBar()
                }
            }
            .height(this.isVerticalScreen ? this.barScale : '100%')
            .width(this.isVerticalScreen ? '100%' : this.barScale)
        }
    }
}