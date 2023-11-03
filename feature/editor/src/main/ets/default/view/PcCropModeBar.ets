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
import { PcCropStyleBar } from './PcCropStyleBar';
import { PcCropRulerBar } from './PcCropRulerBar';
import { CropResetButton } from './CropResetButton';

const TAG: string = 'editor_PcCropModeBar';

/**
 * 天枢PC图片编辑使用的裁剪模式工具栏
 */
@Component
export struct PcCropModeBar {
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
  private rulerComponentSize: number = 0;
  private rulerChanged: Function = (): void => {};
  private resetClicked: Function = (): void => {};

  aboutToAppear() {
    this.rulerChanged = (number: number): void => this.onRulerChanged(number);
    this.broadCast.on(Constants.RULER_CHANGED, this.rulerChanged);
    this.resetClicked = (): void => this.onResetClicked();
    this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClicked);
    this.rulerComponentSize = this.screenWidth;
    Log.debug(TAG, `this.rulerComponentSize = ${this.rulerComponentSize}`);
  }

  aboutToDisappear() {
    this.broadCast.off(Constants.RULER_CHANGED, this.rulerChanged);
    this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClicked);
    this.isCropReset = false;
  }

  onRulerChanged(number: number) {
    this.rotateAngle = number;
    this.cropEdit.onSliderAngleChange(this.rotateAngle);
    this.isCropReset = this.cropEdit.couldReset();
  }

  switchRuler() {
    this.rulerSwitchOn = !this.rulerSwitchOn
  }

  switchFrameStyle() {
    this.frameStyleSwitchOn = !this.frameStyleSwitchOn
  }

  onResetClicked() {
    this.rotateAngle = 0;
  }

  build() {
    Column() {
      // 菜单栏顶部的按钮条
      Row() {
        CropResetButton()
        Blank().flexGrow(1)
        ActionButton({
          src: $r('app.media.ic_edit_photo_crop_rotate'),
          actionID: ID.CROP_ROTATE,
          widthOfActionButton: $r('app.float.secondary_menu_height_default'),
          heightOfActionButton: $r('app.float.crop_action_size')
        })
        Column().width($r('app.float.menu_margin_right'))
        ActionButton({
          src: $r('app.media.ic_edit_photo_crop_mirror'),
          actionID: ID.CROP_MIRROR,
          widthOfActionButton: $r('app.float.secondary_menu_height_default'),
          heightOfActionButton: $r('app.float.crop_action_size')
        })
      }.width('100%')
      .height('60vp')

      // 分割线
      Divider().margin({ bottom: $r('app.float.margin_crop_rotate') }).color('#1affffff')

      // 旋转刻度尺
      Row() {
        Image($r('app.media.ic_public_spinner_open'))
          .width($r('app.float.edit_open_status_icon_length'))
          .height($r('app.float.edit_open_status_icon_length'))
          .objectFit(ImageFit.Contain)
          .fillColor('#FFFFFF')
          .rotate(this.rulerSwitchOn ? { x: 0, y: 0, z: 1, angle: 0 } : {
                                                                          x: 0,
                                                                          y: 0,
                                                                          z: 1,
                                                                          angle: Constants.ANGLE_270
                                                                        })
          .margin({ right: $r('app.float.id_icon_margin_horizontal') })
        Image($r('app.media.ic_public_rotate'))
          .width($r('app.float.edit_menu_icon_length'))
          .height($r('app.float.edit_menu_icon_length'))
          .margin({ left: $r('app.float.id_icon_margin_horizontal'), right: $r('app.float.id_icon_margin_horizontal') })
        Text($r('app.string.rotate_text'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        Blank().flexGrow(1)
        Text('' + this.rotateAngle)
          .fontColor($r('sys.color.ohos_fa_text_secondary_dark'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Regular)
      }
      .width('100%')
      .margin({
        bottom: this.rulerSwitchOn ? $r('app.float.crop_vertical_padding_right') : $r('sys.float.ohos_id_elements_margin_vertical_l')
      })
      .onClick(() => {
        this.switchRuler()
      })

      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        PcCropRulerBar();
      }
      .width('100%')
      .margin({ bottom: this.rulerSwitchOn ? $r('app.float.edit_menu_item_gap') : 0 })
      .visibility(this.rulerSwitchOn ? Visibility.Visible : Visibility.None)

      Row() {
        Image($r('app.media.ic_public_spinner_open'))
          .width($r('app.float.edit_open_status_icon_length'))
          .height($r('app.float.edit_open_status_icon_length'))
          .objectFit(ImageFit.Contain)
          .fillColor('#FFFFFF')
          .rotate(this.frameStyleSwitchOn ? { x: 0, y: 0, z: 1, angle: 0 } : {
                                                                               x: 0,
                                                                               y: 0,
                                                                               z: 1,
                                                                               angle: Constants.ANGLE_270
                                                                             })
          .margin({ right: $r('app.float.id_icon_margin_horizontal') })
        Image($r('app.media.ic_public_picture_frame'))
          .width($r('app.float.edit_menu_icon_length'))
          .height($r('app.float.edit_menu_icon_length'))
          .margin({ left: $r('app.float.id_icon_margin_horizontal'), right: $r('app.float.id_icon_margin_horizontal') })
        Text($r('app.string.edit_frame_style'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
      }
      .width('100%')
      .margin({ bottom: $r('app.float.crop_vertical_padding_right') })
      .onClick((): void => {
        this.switchFrameStyle();
      })

      // 剪切风格bar
      Flex({
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        PcCropStyleBar()
      }
      .width('100%')
      .height($r('app.float.edit_menu_crop_style_bar_height'))
      .visibility(this.frameStyleSwitchOn ? Visibility.Visible : Visibility.Hidden)
    }.padding({ left: $r('app.float.edit_toolBar_padding'), right: $r('app.float.edit_toolBar_padding') })
  }
}