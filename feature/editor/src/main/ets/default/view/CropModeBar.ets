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
import { ID } from './MainMenuInfo';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import { CropStyleBar } from './CropStyleBar';
import { CropRulerBar } from './CropRulerBar';
import { CropResetButton } from './CropResetButton';
import { ToolBar } from './ToolBar';

const TAG: string = 'editor_CropModeBar';

const COMPONENT_KEY_ROTATE: string = 'Rotate';
const COMPONENT_KEY_MIRROR: string = 'Mirror';
interface RulerProperties {
  rulerWidth: number;
  rulerHeight: number;
}

@Component
export struct CropModeBar {
  @Consume('angle') rotateAngle: number;
  @Consume broadCast: BroadCast;
  @Consume('verticalScreen') isVerticalScreen: boolean;
  @Consume('selected') selectedMode: number;
  @Consume cropEdit: PhotoEditCrop;
  @Consume isCropReset: boolean;
  @Consume screenWidth: number;
  @Consume screenHeight: number;
  @State rulerSwitchOn: boolean = true;
  @State frameStyleSwitchOn: boolean = true;
  @StorageLink('rulerProperties') rulerProperties: RulerProperties = { rulerWidth: 0, rulerHeight: 0 };
  private rulerChangedFunc: Function = (number: number): void => this.onRulerChanged(number);
  private resetClickedFunc: Function = (): void => this.onResetClicked();
  private cropRulerBarHeight: number = Constants.VERTICAL_RULER_COMPONENT_HEIGHT;



  aboutToAppear(): void {
    this.broadCast.on(Constants.RULER_CHANGED, this.rulerChangedFunc);
    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClickedFunc);
  }

  aboutToDisappear(): void {
    this.broadCast.off(Constants.RULER_CHANGED, this.rulerChangedFunc);
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClickedFunc);
    this.isCropReset = false;
  }

  onRulerChanged(number: number): void {
    this.rotateAngle = number;
    this.cropEdit.onSliderAngleChange(this.rotateAngle);
    this.isCropReset = this.cropEdit.couldReset();
  }

  switchRuler(): void {
    this.rulerSwitchOn = !this.rulerSwitchOn;
  }

  switchFrameStyle(): void {
    this.frameStyleSwitchOn = !this.frameStyleSwitchOn;
  }

  onResetClicked(): void {
    this.rotateAngle = 0;
  }

  build() {
    Flex({
      direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Start
    }) {
      Column() {
        // 重置按钮
        CropResetButton({
          isPcStyle: false
        })
      }
      .margin(this.isVerticalScreen ? {
                                        top: Constants.VERTICAL_RESET_BUTTON_MARGIN,
                                        bottom: Constants.VERTICAL_RESET_BUTTON_MARGIN
                                      } : { left: Constants.HORIZONTAL_RESET_BUTTON_MARGIN })

      Flex({
        direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        CropStyleBar();
      }
      .height(this.isVerticalScreen ? Constants.VERTICAL_CROP_STYLE_BAR_HEIGHT : Constants.PERCENT_100)
      .width(this.isVerticalScreen ? Constants.PERCENT_100 : Constants.HORIZONTAL_CROP_STYLE_BAR_HEIGHT)

      Flex({
        direction: this.isVerticalScreen ? FlexDirection.Row : FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Flex({
          direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          ActionButton({
            src: $r('app.media.ic_edit_photo_crop_rotate'),
            text: $r('app.string.rotate_text'),
            textSize: this.isVerticalScreen ?
            $r('app.float.buttonActionTextSize_default') : $r('app.float.buttonActionTextSize_horizontal'),
            sizeDefault: this.isVerticalScreen ?
            $r('app.float.ic_size_default') : $r('app.float.ic_size_horizontal'),
            actionID: ID.CROP_ROTATE,
            widthOfActionButton: this.isVerticalScreen ?
            $r('app.float.secondary_menu_height_default') : Constants.HORIZONTAL_ACTION_BUTTON_WIDTH,
            heightOfActionButton: this.isVerticalScreen ?
            $r('app.float.crop_action_size') : Constants.HORIZONTAL_ACTION_BUTTON_HEIGHT,
            componentKey: COMPONENT_KEY_ROTATE
          })
        }
        .padding(this.isVerticalScreen ? {} : { left: Constants.HORIZONTAL_ACTION_BUTTON_LEFT_PADDING })
        .margin(this.isVerticalScreen ? {} : { left: Constants.HORIZONTAL_ACTION_BUTTON_LEFT_MARGIN })
        .width(this.isVerticalScreen ? Constants.VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH :
        Constants.HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH)
        .height(this.isVerticalScreen ? Constants.VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT :
        Constants.HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT)

        if (this.rulerSwitchOn) {
          // 旋转刻度尺
          Flex({
            direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
          }) {
            CropRulerBar()
          }
          .margin(this.isVerticalScreen ? {} : { left: Constants.HORIZONTAL_CROP_RULER_MARGIN })
          .height(this.isVerticalScreen ? this.cropRulerBarHeight : this.rulerProperties.rulerHeight)
          .width(this.rulerProperties.rulerWidth)
        }

        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          ActionButton({
            src: $r('app.media.ic_edit_photo_crop_mirror'),
            text: $r('app.string.mirror_text'),
            textSize: this.isVerticalScreen ?
            $r('app.float.buttonActionTextSize_default') : $r('app.float.buttonActionTextSize_horizontal'),
            sizeDefault: this.isVerticalScreen ?
            $r('app.float.ic_size_default') : $r('app.float.ic_size_horizontal'),
            actionID: ID.CROP_MIRROR,
            widthOfActionButton: this.isVerticalScreen ?
            $r('app.float.secondary_menu_height_default') : Constants.HORIZONTAL_ACTION_BUTTON_WIDTH,
            heightOfActionButton: this.isVerticalScreen ?
            $r('app.float.crop_action_size') : Constants.HORIZONTAL_ACTION_BUTTON_HEIGHT,
            componentKey: COMPONENT_KEY_MIRROR
          })
        }
        .padding(this.isVerticalScreen ? {} : { left: Constants.HORIZONTAL_ACTION_BUTTON_LEFT_PADDING })
        .margin(this.isVerticalScreen ? {} : { left: Constants.HORIZONTAL_ACTION_BUTTON_LEFT_MARGIN })
        .width(this.isVerticalScreen ? Constants.VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH :
        Constants.HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH)
        .height(this.isVerticalScreen ? Constants.VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT :
        Constants.HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT)
      }
      .width(this.isVerticalScreen ? Constants.PERCENT_100 : Constants.HORIZONTAL_RULER_COMPONENT_WIDTH)

      Column() {
        ToolBar({
          textSize: this.isVerticalScreen ?
          $r('app.float.buttonActionTextSize_default') : $r('app.float.buttonActionTextSize_horizontal')
        })
      }
      .alignItems(HorizontalAlign.Center)
      .width(this.isVerticalScreen ? Constants.VERTICAL_TOOL_BAR_WIDTH : Constants.HORIZONTAL_TOOL_BAR_WIDTH)
      .height(this.isVerticalScreen ? Constants.VERTICAL_TOOL_BAR_HEIGHT : Constants.HORIZONTAL_TOOL_BAR_HEIGHT)
    }
  }
}