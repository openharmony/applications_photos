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

import { BroadCast, Constants, Log } from '@ohos/common';
import { ActionButton } from './ActionButton';
import { ActionButtonInfo, ID } from './MainMenuInfo';
import { ActionChangedEvent, RefreshActionMenu } from './RefreshMenu';
import { CropRatioType } from '../crop/CropType';
import { PhotoEditMode } from '../base/PhotoEditType';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';

const TAG: string = 'editor_PcCropStyleBar';

const COMPONENT_KEY_EDIT_CROP_FREEDOM: string = 'EditCropFreedom';
const COMPONENT_KEY_EDIT_CROP_4_3: string = 'EditCrop_4_3';
const COMPONENT_KEY_EDIT_CROP_3_4: string = 'EditCrop_3_4';
const COMPONENT_KEY_EDIT_CROP_1_1: string = 'EditCrop_1_1';
const COMPONENT_KEY_EDIT_CROP_3_2: string = 'EditCrop_3_2';
const COMPONENT_KEY_EDIT_CROP_2_3: string = 'EditCrop_2_3';
const COMPONENT_KEY_EDIT_CROP_9_16: string = 'EditCrop_9_16';
const COMPONENT_KEY_EDIT_CROP_16_9: string = 'EditCrop_16_9';
const COMPONENT_KEY_EDIT_CROP_PORT_FULL: string = 'PortFull';
const COMPONENT_KEY_EDIT_CROP_LAND_FULL: string = 'LandFull';

/**
 * 天枢PC使用的裁剪比例风格工具栏
 */
@Component
export struct PcCropStyleBar {
  @Consume broadCast: BroadCast;
  @Consume('verticalScreen') isVerticalScreen: boolean;
  @Consume('selected') selectedMode: number;
  @Consume isCropReset: boolean;
  @Consume cropEdit: PhotoEditCrop;
  mainMenuList: Array<ActionButtonInfo> = [
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_freedom'),
      actionID: CropRatioType.RATIO_TYPE_FREE,
      isActive: true,
      componentKey: COMPONENT_KEY_EDIT_CROP_FREEDOM
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_4_3'),
      actionID: CropRatioType.RATIO_TYPE_4_3,
      componentKey: COMPONENT_KEY_EDIT_CROP_4_3
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_3_4'),
      actionID: CropRatioType.RATIO_TYPE_3_4,
      componentKey: COMPONENT_KEY_EDIT_CROP_3_4
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_1_1'),
      actionID: CropRatioType.RATIO_TYPE_1_1,
      componentKey: COMPONENT_KEY_EDIT_CROP_1_1
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_3_2'),
      actionID: CropRatioType.RATIO_TYPE_3_2,
      componentKey: COMPONENT_KEY_EDIT_CROP_3_2
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_2_3'),
      actionID: CropRatioType.RATIO_TYPE_2_3,
      componentKey: COMPONENT_KEY_EDIT_CROP_2_3
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_9_16'),
      actionID: CropRatioType.RATIO_TYPE_9_16,
      componentKey: COMPONENT_KEY_EDIT_CROP_9_16
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_16_9'),
      actionID: CropRatioType.RATIO_TYPE_16_9,
      componentKey: COMPONENT_KEY_EDIT_CROP_16_9
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_portfull'),
      actionID: CropRatioType.RATIO_TYPE_VERTICAL,
      componentKey: COMPONENT_KEY_EDIT_CROP_PORT_FULL
    }),
    new ActionButtonInfo({
      src: $r('app.media.ic_edit_photo_crop_landfull'),
      actionID: CropRatioType.RATIO_TYPE_HORIZONTAL,
      componentKey: COMPONENT_KEY_EDIT_CROP_LAND_FULL
    }),
  ];
  @State @Watch('clickEvent') menuChanged: RefreshActionMenu = new RefreshActionMenu(-1, this.mainMenuList);
  private menuClick: Function = (): void => {};
  private resetClick: Function = (): void => {};

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

  onRotateClicked(): void {
    let id = -1;
    for (let i = 0; i < this.menuChanged.menuArray.length; i++) {
      if (this.menuChanged.menuArray[i].isActive) {
        id = this.menuChanged.menuArray[i].actionID as number;
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
    this.menuClick = (actionID: number | CropRatioType): void => this.onMenuClicked(actionID);
    this.resetClick = (): void => this.onResetClicked();
    this.broadCast.on(Constants.UPDATE_MENU, this.menuClick);
    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClick);
  }

  aboutToDisappear() {
    this.broadCast.off(Constants.UPDATE_MENU, this.menuClick);
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClick);
  }

  build() {
    Grid() {
      ForEach(this.menuChanged.menuArray, (item: ActionButtonInfo) => {
        GridItem() {
          ActionButton({
            src: item.src,
            isActive: item.isActive,
            actionID: item.actionID,
            heightOfActionButton: $r('app.float.icon_size'),
            widthOfActionButton: $r('app.float.icon_size'),
            isCropStyleButton: true,
            componentKey: item.componentKey
          })
        }
        .padding({
          top: $r('app.float.crop_vertical_padding_right'),
          bottom: $r('app.float.crop_vertical_padding_right')
        })
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
    .backgroundColor('#33000000')
    .borderRadius($r('app.float.edit_menu_item_radius'))
    .width('100%')
  }
}