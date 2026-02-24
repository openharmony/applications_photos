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

import lazy { Action, ActionID } from '../browserOperation/Action';
import lazy { ActionBarColorMode } from '../browserOperation/ActionBarMode';
import lazy { ColumnSize, getScreen, isOrientationHorizontal } from '../../model/common/ScreenManager';
import lazy { Constants } from '../../model/common/Constants';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';

const PICKER_CLOSE_ACTION: Action = Action.PICKER_CLOSE;

@Component
export struct ThirdSelectActionBarButton {
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @State res: Resource | undefined = undefined;
  public action: Action = Action.NONE;
  onMenuClicked: Function = (): void => {
  };
  public isAutoTint = true;
  public colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @State showPopup: boolean = false;
  private isFromPickerView: boolean = false;
  @Prop private moreMenuList: Action[] = [];
  @Consume @Watch('isNeedHidePopup') hidePopup: boolean;

  /* instrument ignore file */
  aboutToAppear(): void {
  }

  isNeedHidePopup(): void {
    if (this.hidePopup) {
      this.showPopup = false;
    }
  }

  @Builder
  PopupBuilder() {
    Column() {
      ForEach(this.moreMenuList, (menu: Action, index?: number) => {
        Text(menu.textRes)
          .width('100%')
          .height($r('app.float.menu_height'))
          .fontColor(menu.fillColor)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .onClick((): void => {
            this.onMenuClicked?.(menu);
          })
          .key(`ActionBarButton_Text_${menu.componentKey}`)
        if (this.moreMenuList.indexOf(menu) != this.moreMenuList.length - 1) {
          Divider()
            .width('100%')
            .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
            .color($r('sys.color.comp_divider'))
            .key(`ActionBarButton_Divider_${menu.componentKey}`)
        }
      }, (menu: Action) => menu.actionID.toString())
    }
    .width(getScreen().getColumnsWidth(ColumnSize.COLUMN_TWO))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .padding({
      top: $r('app.float.menu_padding_vertical'),
      bottom: $r('app.float.menu_padding_vertical'),
      left: $r('app.float.menu_padding_horizontal'),
      right: $r('app.float.menu_padding_horizontal'),
    })
    .backgroundColor(Color.White)
    .margin({
      right: this.isHorizontal ? $r('sys.float.ohos_id_max_padding_end') : $r('app.float.menu_margin_right'),
      bottom: this.isHorizontal ? 0 : $r('app.float.menu_margin_bottom'),
    })
  }

  @Builder
  ActionBarButtonBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      if (this.isAutoTint) {
        SymbolGlyph(this.res)
          .id(`Third_Select_${this.action.componentKey}`)
          .draggable(false)
          .fontSize($r('app.float.icon_size'))
          .fontColor([this.colorMode === ActionBarColorMode.TRANSPARENT ?
          Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor])
      } else {
        SymbolGlyph(this.res)
          .id(`Third_Select_${this.action.componentKey}`)
          .draggable(false)
          .fontSize($r('app.float.icon_size'))
      }
    }
    .key(`ActionBarButton${this.action.componentKey}`)
    .height($r('app.float.icon_video_size'))
  }

  private getButtonText(): string {
    if (this.action.actionID === ActionID.NEW) {
      return this.rsc.toString($r('app.string.album_new_album'));
    }
    if (this.action.actionID === ActionID.SEARCH) {
      return this.rsc.toString($r('app.string.search'));
    }
    return this.rsc.toString(this.action?.textRes);
  }

  build() {
    Button({
      type: DeviceInfo.isPc() ? ButtonType.Normal : ButtonType.Circle,
      stateEffect: true,
    }) {
      Row() {
        this.ActionBarButtonBuilder();
      }
      .height(this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0)
      .width(this.action.componentKey !== undefined ? $r('app.float.action_bar_button_height') : 0)
      .justifyContent(FlexAlign.Center)
    }
    .margin({
      left: this.action.componentKey === undefined ? 0 :
        this.action === PICKER_CLOSE_ACTION ? $r('sys.float.padding_level4') : $r('app.float.menu_padding_horizontal'),
      right: this.action.componentKey === undefined ? 0 :
        this.action === PICKER_CLOSE_ACTION ? $r('app.float.menu_padding_horizontal') : $r('sys.float.padding_level4'),
    })
    .enabled(!this.action?.isInvalid)
    .backgroundColor(DeviceInfo.isPc() ? Color.Transparent :
    $r('sys.color.comp_background_tertiary'))
    .backgroundBlurStyle(this.isFromPickerView ? BlurStyle.BACKGROUND_THIN : BlurStyle.NONE)
    .borderRadius(DeviceInfo.isPc() ? $r('sys.float.corner_radius_level4') : $r('sys.float.corner_radius_level10'))
    .onClick((): void => {
      this.onMenuClicked?.(this.action);
    })
    .id(this.action?.componentKey)
    .accessibilityText(this.getButtonText())
    .accessibilityLevel(this.action === PICKER_CLOSE_ACTION ? 'no' : 'yes')
    .visibility(this.action === PICKER_CLOSE_ACTION ? Visibility.Hidden : Visibility.Visible)
    .flexShrink(0)
  }
}