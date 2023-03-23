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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { ActionButton } from './ActionButton';
import { ID } from './MainMenuInfo';
import { Constants } from '../../../common/model/common/Constants';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import { CropStyleBar } from './CropStyleBar';
import { CropRulerBar } from './CropRulerBar';

@Component
export struct CropModeBar {
    @Consume('angle') rotateAngle: number;
    @Consume broadCast: Broadcast;
    @Consume('verticalScreen') isVerticalScreen: boolean;
    @Consume('selected') selectedMode: number;
    @Consume cropEdit: PhotoEditCrop;
    @Consume isCropReset: boolean;
    @Consume screenWidth: number;
    @Consume screenHeight: number;
    private TAG: string = 'CropModeBar'
    private rulerComponentSize: number = 0;
    private rulerChanged: any = undefined;

    aboutToAppear() {
        this.rulerChanged = this.onRulerChanged.bind(this);
        this.broadCast.on(Constants.RULER_CHANGED, this.rulerChanged);
        this.rulerComponentSize = this.isVerticalScreen ? this.screenWidth - Constants.PADDING_VERTICAL
                                                        : this.screenWidth - Constants.PADDING_HORIZONTAL;
        Log.debug(this.TAG, `this.rulerComponentSize = ${this.rulerComponentSize}`);
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.RULER_CHANGED, this.rulerChanged);
        this.isCropReset = false;
    }

    onRulerChanged(number: number) {
        this.rotateAngle = number;
        this.cropEdit.onSliderAngleChange(this.rotateAngle);
        this.isCropReset = this.cropEdit.couldReset();
    }

    build() {
        Flex({
            direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Start
        }) {
            Flex({
                direction: FlexDirection.Row,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center
            }) {
                CropStyleBar();
            }
            .height(this.isVerticalScreen ? $r('app.float.actionbar_height') : '100%')
            .width(this.isVerticalScreen ? '100%' : $r('app.float.actionbar_height'))

            Flex({
                direction: this.isVerticalScreen ? FlexDirection.Row : FlexDirection.Column,
                alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center
            }) {
                Row() {
                    ActionButton({
                        src: $r('app.media.ic_edit_photo_crop_rotate'),
                        text: $r('app.string.rotate_text'),
                        actionID: ID.CROP_ROTATE,
                        widthOfActionButton: this.isVerticalScreen
                            ? $r('app.float.crop_action_hot_zone') : $r('app.float.secondary_menu_height_default'),
                        heightOfActionButton: this.isVerticalScreen
                            ? $r('app.float.secondary_menu_height_default') : $r('app.float.crop_action_size')
                    })
                }
                .padding(this.isVerticalScreen
                    ? { bottom: $r('app.float.crop_rotate_vertical_padding') }
                    : { left: $r('app.float.crop_rotate_horizontal_padding') })

                Flex({
                    direction: this.isVerticalScreen ? FlexDirection.Row : FlexDirection.Column,
                    alignItems: ItemAlign.Center,
                    justifyContent: FlexAlign.Center
                }) {
                    CropRulerBar();
                }
                .width(this.isVerticalScreen ? this.rulerComponentSize : $r('app.float.secondary_menu_height_default'))
                .height(this.isVerticalScreen ? $r('app.float.secondary_menu_height_default') : this.rulerComponentSize)
                .padding(this.isVerticalScreen ? {
                                                     left: $r('app.float.margin_crop_rotate'),
                                                     right: $r('app.float.margin_crop_rotate')
                                                 } : {})

                Row() {
                    ActionButton({
                        src: $r('app.media.ic_edit_photo_crop_mirror'),
                        text: $r('app.string.mirror_text'),
                        actionID: ID.CROP_MIRROR,
                        widthOfActionButton: this.isVerticalScreen
                            ? $r('app.float.crop_action_hot_zone') : $r('app.float.secondary_menu_height_default'),
                        heightOfActionButton: this.isVerticalScreen
                            ? $r('app.float.secondary_menu_height_default') : $r('app.float.crop_action_size')
                    })
                }
                .padding(this.isVerticalScreen
                    ? { bottom: $r('app.float.crop_rotate_vertical_padding') }
                    : { left: $r('app.float.crop_rotate_horizontal_padding') })
            }
            .height(this.isVerticalScreen ? $r('app.float.secondary_menu_height_default') : '100%')
            .width(this.isVerticalScreen ? '100%' : $r('app.float.secondary_menu_height_default'))
            .padding(this.isVerticalScreen ? {
                                                 left: $r('app.float.crop_vertical_padding'),
                                                 right: $r('app.float.crop_vertical_padding')
                                             } : {})
        }
    }
}