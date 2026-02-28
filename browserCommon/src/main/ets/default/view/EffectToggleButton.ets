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

import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import { ConfigurationConstant } from '@kit.AbilityKit';
import i18n from '@ohos.i18n';
import { EffectPhotoContext, ShotForMoreContext } from '../utils/EffectPhotoContext';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { uiEffect } from '@kit.ArkGraphics2D';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

/* instrument ignore file */

const TAG: string = 'EffectToggleButton';

const ICON_REPLACEMENT_ARRAY = [
  Action.CLOSE_VIRTUAL_APERTURE.actionID,
  Action.CLOSE_FLASH_CAPTURE.actionID,
  Action.CLOSE_EFFECT.actionID,
  Action.DYNAMIC_PANNING.actionID
]

const DARK_BUTTON_MAP: Map<number, Resource> = new Map([
  [Action.DYNAMIC_PANNING.actionID, $r('app.media.dynamic_panning_dark')],
  [Action.CLOSE_FLASH_CAPTURE.actionID, $r('app.media.close_flash_capture_dark')],
  [Action.CLOSE_VIRTUAL_APERTURE.actionID, $r('app.media.close_virtual_aperture_dark')],
]);

/**
 * 一拍多得特效切换视图
 */
@Component
export struct EffectToggleButton {
  @Prop menu: Action;
  @Prop enabledButton: boolean;
  @Prop isLoading: boolean;
  @Prop isCloud: boolean;
  @ObjectLink effectToggleButtonList: Action[];
  @ObjectLink checkList: Action[];
  onMenuClicked: Function = (): void => {};
  private symbolCheckMark: SymbolGlyphModifier = new SymbolGlyphModifier($r('sys.symbol.checkmark')).fontSize('24vp');
  @StorageProp('currentColorMode') private themeColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @State opacityValue: number = 0;
  @State textWidth: string = '0.1';
  @Prop isMovingPhoto: boolean;
  @State symbolPaddingLeft: number = 8;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  aboutToAppear(): void {
    Log.info(TAG, `checkList ${this.checkList.length}, info ${JSON.stringify(this.checkList)}`);
  }

  aboutToDisappear(): void {

  }

  build() {
    this.ApertureCapture();
  }

  private getIconMargin(): Margin {
    // 正常排列
    if (!i18n.isRTL(i18n.System.getSystemLanguage())) {
      return {
        left: 8,
        right: this.textWidth !== '0.1' ? 4 : 0
      }
    } else {
      // 镜像语言模式
      return {
        left: this.textWidth !== '0.1' ? 4 : 0,
        right: 8
      }
    }
  }

  private doButtonExpand() {
    animateTo({
      duration: 300,
      delay: 0,
      curve: Curve.Friction,
      onFinish: () => {}
    }, () => {
      this.textWidth = 'auto';
    })

    animateTo({
      duration: 150,
      delay: 150,
      curve: Curve.Sharp,
      onFinish: () => {}
    }, () => {
      this.opacityValue = 1;
    })
  }

  private doButtonShrink() {
    animateTo({
      duration: 50,
      delay: 0,
      curve: Curve.Sharp,
      onFinish: () => {
        animateTo({
          duration: 250,
          delay: 0,
          curve: Curve.Friction,
        }, () => {
          this.symbolPaddingLeft = 8;
          this.textWidth = '0.1';
        })
      }
    }, () => {
      this.opacityValue = 0;
      this.symbolPaddingLeft = 0;
    })
  }

  @Builder
  ApertureCapture(): void {
    Button({ type: ButtonType.Normal, stateEffect: false }) {
      Column() {
        Row() {
          if (ICON_REPLACEMENT_ARRAY.includes(this.menu.actionID)) {
            Image(this.menu?.iconRes)
              .draggable(false)
              .width(16)
              .height(16)
              .fillColor($r('sys.color.icon_primary'))
              .opacity(this.enabledButton && !this.isLoading ? 1 : 0.4)
              .margin({
                left: this.getIconMargin().left,
                right: this.getIconMargin().right,
              })
          } else {
            SymbolGlyph(this.menu?.iconRes)
              .draggable(false)
              .fontSize(16)
              .fontColor([$r('sys.color.icon_primary')])
              .maxFontScale(1)
              .opacity(this.enabledButton && !this.isLoading ? 1 : 0.4)
              .margin({
                left: this.getIconMargin().left,
                right: this.getIconMargin().right,
              })
          }
          Text(this.menu.textRes)
            .opacity(this.enabledButton && !this.isLoading ? this.opacityValue : 0.4)
            .width(this.textWidth)
            .maxLines(1)
            .fontColor($r('sys.color.icon_primary'))
            .fontSize(14)
            .maxFontScale(2)
            .lineHeight(16)
            .fontWeight(FontWeight.Regular)
          SymbolGlyph($r('sys.symbol.arrowtriangle_down_fill'))
            .draggable(false)
            .fontSize(12)
            .maxFontScale(1)
            .fontColor([$r('sys.color.icon_primary')])
            .opacity(this.enabledButton && !this.isLoading ? 1 : 0.4)
            .margin({
              left: this.symbolPaddingLeft,
              right: 8
            })
        }
        .height(28)
        .borderRadius($r('sys.float.corner_radius_level7'))
        // .visualEffect(uiEffect.createEffect().backgroundColorBlender(hdsEffect.getBrightnessParam({
        //   scenario: hdsEffect.BrightnessScenario.BACKGROUND_BRIGHTNESS,
        //   level: hdsEffect.BrightnessLevel.BRIGHTNESS_LEVEL_3,
        //   fraction: 0,
        // })))
        .backgroundEffect({ radius: 30 })
        .backgroundColor($r('sys.color.comp_background_gray'))
        .borderStyle(BorderStyle.Solid)
        .borderColor(this.isDarkMode() ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.2)')
        .borderWidth(0.5)
        .stateStyles({
          pressed: {
            .backgroundColor($r('sys.color.interactive_hover'))
          },
          focused: {
            .backgroundColor($r('sys.color.interactive_click'))
          },
          selected: {
            .outline({
              width: '2vp',
              color: $r('sys.color.interactive_focus')
            })
          }
        })
      }
      .key(`EffectBarButton${this.menu.componentKey}`)
      .justifyContent(FlexAlign.Center)
      .bindMenu(this.MovingPhotoMoreMenu, {
        placement: Placement.BottomLeft
      })
      .enabled(this.enabledButton && !this.isLoading)
      .onClick(() => {
        if (this.isCloud) {
          UiUtil.showToast($r('app.string.current_picture_not_download_please_download_and_try_again'));
          return;
        }
        // EffectToggleHelper.initEditorSDK();

      })
      .accessibilityLevel('yes')
      .accessibilityText(this.menu?.textRes)
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
    .onAppear(() => {
    })
    .backgroundColor($r('app.color.transparent'))
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  private isDarkMode(): boolean {
    return this.themeColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  }

  // 动图模式切换下拉菜单
  @Builder
  MovingPhotoMoreMenu() {
    Column() {
      Menu() {
        ForEach(this.effectToggleButtonList, (menu: Action, index: number): void => {
          this.MenuItemBuilder(menu, index);
        })
      }
      .onAppear((): void => {
        if (this.isCloud) {
          return;
        }
        this.doButtonExpand();
      })
      .onDisAppear((): void => {
        if (this.isCloud) {
          return;
        }
        this.doButtonShrink();
      })
      .width($r('app.float.more_menu_width'))
      .radius($r('sys.float.corner_radius_level10'))
    }.visibility(this.isCloud ? Visibility.None : Visibility.Visible)
  }

  @Builder
  MenuItemBuilder(menu: Action, index: number) {
    MenuItem(this.getMenuOption(menu))
      .contentFont({ weight: 'medium' })
      .key(`MovingPhotoMenuItem_${index}`)
      .onClick((): void => {
        const id: number[] = this.checkList.map(item => item.actionID);
        if (id.includes(menu.actionID)) {
          return;
        }
        ShotForMoreContext.getInstance().setSwitchClickEffect(menu.componentKey);
        if (this.isMovingPhoto) {
          EffectPhotoContext.getInstance().setEffectClick(menu.actionID);
        }
        this.onMenuClicked?.(menu);
        this.appBroadCast.emit(BroadCastConstants.EFFECT_MODE_SWITCH_CLICKED, [false]);
      })
      .onAppear((): void => {
        Log.debug(TAG, `movingPhotoMenuItemBuilder onappear, menu: ${menu.componentKey}`);
      })
      .onChange((selected: boolean): void => {
        Log.debug(TAG, `menuItem changed: ${menu.componentKey}`);
      })
    if (this.effectToggleButtonList.length > 2 && index === 1){
      Divider()
        .strokeWidth(8)
        .color(this.isDarkMode() ? 'rgba(255,255,255,0.03)' : 'rgba(0,0,0,0.03)')
        .margin({
          left: -4,
          right: -4,
        })
    } else if (index === 0 || index === 2) {
      Divider()
        .strokeWidth('1px')
        .color($r('sys.color.comp_divider'))
        .margin({
          left: 16,
          right: 16,
        })
    }
  }

  private getMenuOption(menu: Action): MenuItemOptions {
    let menuItemOptions: MenuItemOptions = {
      content: menu.textRes,
      symbolStartIcon: new SymbolGlyphModifier(menu.iconRes).fontSize('24vp').enabled(menu?.isInvalid),
    }
    if (ICON_REPLACEMENT_ARRAY.includes(menu.actionID)) {
      menuItemOptions.symbolStartIcon = undefined;
      menuItemOptions.startIcon = !this.isDarkMode() ? menu.iconRes : DARK_BUTTON_MAP.get(menu.actionID);
    }
    const id: number[] = this.checkList.map(item => item.actionID);
    if (id.includes(menu.actionID)) {
      menuItemOptions.symbolEndIcon = this.symbolCheckMark;
    }
    return menuItemOptions;
  }
}