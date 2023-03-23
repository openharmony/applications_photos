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
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { ActionButton } from './ActionButton';
import { ActionButtonInfo, ID } from './MainMenuInfo';
import { RefreshActionMenu, ActionChangedEvent } from './RefreshMenu';
import { Constants } from '../../../common/model/common/Constants';
import { CropRatioType } from '../crop/CropType';
import { PhotoEditMode } from '../base/PhotoEditType';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';

@Component
export struct CropStyleBar {
    @Consume broadCast: Broadcast;
    @Consume('verticalScreen') isVerticalScreen: boolean;
    @Consume('selected') selectedMode: number;
    @Consume isCropReset: boolean;
    @Consume cropEdit: PhotoEditCrop;
    private menuClick: any = undefined;
    private resetClick: any = undefined;
    mainMenuList: Array<ActionButtonInfo> = [
        new ActionButtonInfo({
            src: $r('app.media.ic_edit_photo_crop_freedom'),
            actionID: CropRatioType.RATIO_TYPE_FREE,
            isActive: true
        }),
        new ActionButtonInfo({
            src: $r("app.media.ic_edit_photo_crop_land_full"),
            actionID: CropRatioType.RATIO_TYPE_HORIZONTAL
        }),
        new ActionButtonInfo({
            src: $r("app.media.ic_edit_photo_crop_port_full"),
            actionID: CropRatioType.RATIO_TYPE_VERTICAL
        }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_1_1'), actionID: CropRatioType.RATIO_TYPE_1_1 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_16_9'), actionID: CropRatioType.RATIO_TYPE_16_9 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_9_16'), actionID: CropRatioType.RATIO_TYPE_9_16 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_4_3'), actionID: CropRatioType.RATIO_TYPE_4_3 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_3_4'), actionID: CropRatioType.RATIO_TYPE_3_4 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_3_2'), actionID: CropRatioType.RATIO_TYPE_3_2 }),
        new ActionButtonInfo({ src: $r('app.media.ic_edit_photo_crop_2_3'), actionID: CropRatioType.RATIO_TYPE_2_3 }),
    ];
    @State @Watch('clickEvent') menuChanged: RefreshActionMenu = new RefreshActionMenu(-1, this.mainMenuList);

    clickEvent() {
        ActionChangedEvent.isActiveNotChanged(this.menuChanged);
    }

    onMenuClicked(actionID: number | CropRatioType) {
        if (this.selectedMode != PhotoEditMode.EDIT_MODE_CROP) {
            return;
        }
        if (actionID == ID.CROP_ROTATE) {
            this.onRotateClicked();
        }

        if (actionID == ID.CROP_MIRROR) {
            this.onMirrorClicked();
        }

        for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
            if (actionID === this.menuChanged.menuArray[i].actionID) {
                this.menuChanged.isChanged = i;
                this.cropEdit.onFixedRatioChange(actionID);
                this.isCropReset = this.cropEdit.couldReset();
            }
        }
    }

    onRotateClicked() {
        let id = -1;
        for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
            if (this.menuChanged.menuArray[i].isActive) {
                id = this.menuChanged.menuArray[i].actionID;
            }
        }

        if (id === CropRatioType.RATIO_TYPE_4_3) {
            id = CropRatioType.RATIO_TYPE_3_4;
        } else if (id === CropRatioType.RATIO_TYPE_3_4) {
            id = CropRatioType.RATIO_TYPE_4_3;
        } else if (id === CropRatioType.RATIO_TYPE_16_9) {
            id = CropRatioType.RATIO_TYPE_9_16;
        } else if (id === CropRatioType.RATIO_TYPE_9_16) {
            id = CropRatioType.RATIO_TYPE_16_9;
        } else if (id === CropRatioType.RATIO_TYPE_2_3) {
            id = CropRatioType.RATIO_TYPE_3_2;
        } else if (id === CropRatioType.RATIO_TYPE_3_2) {
            id = CropRatioType.RATIO_TYPE_2_3;
        } else if (id === CropRatioType.RATIO_TYPE_VERTICAL) {
            id = CropRatioType.RATIO_TYPE_HORIZONTAL;
        } else if (id === CropRatioType.RATIO_TYPE_HORIZONTAL) {
            id = CropRatioType.RATIO_TYPE_VERTICAL;
        }

        for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
            if (id === this.menuChanged.menuArray[i].actionID) {
                this.menuChanged.isChanged = i;
            }
        }

        this.cropEdit.onRotationAngleChange();
        this.isCropReset = this.cropEdit.couldReset();
    }

    onMirrorClicked() {
        this.cropEdit.onMirrorChange();
        this.isCropReset = this.cropEdit.couldReset();
    }

    onResetClicked() {
        this.menuChanged.isChanged = 0;
        this.isCropReset = this.cropEdit.couldReset();
    }

    aboutToAppear() {
        this.menuClick = this.onMenuClicked.bind(this);
        this.resetClick = this.onResetClicked.bind(this);
        this.broadCast.on(Constants.UPDATE_MENU, this.menuClick);
        this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClick);
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.UPDATE_MENU, this.menuClick);
        this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClick);
    }

    build() {
        List() {
            ForEach(this.menuChanged.menuArray, (item: ActionButtonInfo) => {
                ListItem() {
                    ActionButton({
                        src: item.src,
                        isActive: item.isActive,
                        actionID: item.actionID,
                        heightOfActionButton: $r('app.float.actionbar_height')
                    })
                }
                .width(this.isVerticalScreen ? $r('app.float.crop_listItem_horizontal') : '100%')
                .height(this.isVerticalScreen ? '100%' : $r('app.float.crop_listItem_vertical'))
            })
        }
        .padding(this.isVerticalScreen ? {
                                             top: $r('app.float.padding_crop_style'),
                                             bottom: $r('app.float.padding_crop_style')
                                         } : {
                                                 left: $r('app.float.padding_crop_style'),
                                                 right: $r('app.float.padding_crop_style')
                                             })
        .listDirection(this.isVerticalScreen ? Axis.Horizontal : Axis.Vertical)
    }
}