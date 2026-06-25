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
import lazy { window } from '@kit.ArkUI';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { Log } from './Log';
import lazy { BroadCast } from './BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { ActionBarColorMode } from '../view/browserOperation/ActionBarMode';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

const TAG: string = 'ImmersiveController';

export enum MViewType {
  YEAR,
  MONTH,
  DAY
}

export class ImmersiveController {
  public isRefreshShow: boolean = false;
  public textFontColor: string;
  public textFontShadowRadius: number = 0;
  public textFontShadowColor: string = '#00000000';
  public currentActionAndRefreshHeight?: number;
  public iconBgColor: string | Resource;
  public iconBgColorDisabled: string | Resource;
  public backBgBlur: number;
  public iconFillColor: string | Resource;
  public iconFillColorDisabled: string | Resource;
  public enable: boolean = false;
  public bgBlur: BlurStyle;
  public bgBlurDisabled: BlurStyle;
  public opacityDisabled: number | Resource;
  public currentMaskingLayerOpacity: number;
  public isShowMultiSelect: boolean = false;
  public isMultiSelectUseAnimation: boolean = false;
  public mainWindow: window.Window;
  public columnBgColor: string | Resource = $r('app.color.transparent');
  private isMaskingLayerShow: boolean = false;
  private isFromPortrait: boolean = false;
  private isHorizontal: boolean = false;
  private immersiveThreshold: number = 20;
  public isInImmersive: boolean = false;
  public textShadowRadius: number = 0;
  public textShadowColor: string = '#00000000';
  private static darkModeFontColor: string = '#ffffff';
  private static lightModeFontColorImmersive: string = '#ffffff';
  private static lightModeFontColorNormal: string = '#000000';
  private static darkModeIconBgColor: string = '#19ffffff';
  private static darkModeIconBgColorDisabled: string = '#0a0a0a';
  private static lightModeIconBgColorImmersive: string = '#19ffffff';
  private static lightModeIconBgColorNormal: string = '#0C000000';
  private static lightModeIconBgColorDisabled: string = '#edeef0';
  private static darkModeIconFillColor: string = '#FFFFFF';
  private static lightModeIconFillColor: string = '#000000';
  private static darkModeIconColorImmersiveDisabled: Resource = $r('sys.color.ohos_id_color_tertiary');
  private static lightModeIconColorImmersiveDisabled: Resource = $r('sys.color.ohos_id_color_text_tertiary_contrary');
  private static textFontShadowRadiusImmersive: number = 20;
  private static textFontShadowColorImmersive: string = '#26000000';
  private static textFontShadowRadiusNormal: number = 0;
  private static textFontShadowColorNormal: string = '#00000000';
  public static bottomColumnBgColor: string = '#cc808080';
  private static aniTime: number = 150;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public static readonly maskerLayerZIndex: number = 1;
  public static isInImmersive: boolean = false;
  public singleTitleOpacity: number = 1;

  constructor(colorMode: ConfigurationConstant.ColorMode, mainWindow: window.Window, isHorizontal: boolean,
    enable: boolean = true, isFromPortrait: boolean = false, immersiveThreshold: number = 20) {
    this.isRefreshShow = false;
    if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.textFontColor = ImmersiveController.darkModeFontColor;
      this.iconBgColor = ImmersiveController.darkModeIconBgColor;
      this.iconBgColorDisabled = ImmersiveController.darkModeIconBgColorDisabled;
      this.iconFillColor = ImmersiveController.darkModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.darkModeIconFillColor;
    } else {
      this.textFontColor = ImmersiveController.lightModeFontColorNormal;
      this.iconBgColor = ImmersiveController.lightModeIconBgColorNormal;
      this.iconBgColorDisabled = ImmersiveController.lightModeIconBgColorDisabled;
      this.iconFillColor = ImmersiveController.lightModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.lightModeIconFillColor;
    }
    this.bgBlur = BlurStyle.NONE;
    this.bgBlurDisabled = BlurStyle.NONE;
    this.opacityDisabled = 0.4;
    this.textFontShadowRadius = ImmersiveController.textFontShadowRadiusNormal;
    this.textFontShadowColor = ImmersiveController.textFontShadowColorNormal;
    this.backBgBlur = 0;
    this.currentMaskingLayerOpacity = 0;
    this.mainWindow = mainWindow;
    this.enable = enable;
    this.isHorizontal = isHorizontal;
    this.isFromPortrait = isFromPortrait;
    this.immersiveThreshold = immersiveThreshold;
  }

  public setParamForPortrait(isFromPortrait: boolean, colorMode: ConfigurationConstant.ColorMode): void {
    // 人像相册初始状态处于沉浸式
    if (isFromPortrait) {
      this.enterImmersive(colorMode, 0, Number.MAX_SAFE_INTEGER, false);
    }
    this.isFromPortrait = isFromPortrait;
  }

  /* instrument ignore next */
  public onColorModeChange(currentMode: ConfigurationConstant.ColorMode): void {
    if (this.isFromPortrait) {
      this.setImmersiveModeParam(currentMode);
      this.setImmersiveStatusColor(currentMode);
      return;
    }
    if (this.currentMaskingLayerOpacity === 0) {
      this.setNormalStatusColor(currentMode);
      this.setNormalModeParam(currentMode);
      return;
    }
    this.setImmersiveStatusColor(currentMode);
    this.setImmersiveModeParam(currentMode);
  }

  private setImmersiveModeParam(currentMode: ConfigurationConstant.ColorMode): void {
    this.currentMaskingLayerOpacity = 1;
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.textFontColor = ImmersiveController.darkModeFontColor;
      this.iconFillColor = ImmersiveController.darkModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.darkModeIconColorImmersiveDisabled;
    } else {
      this.textFontColor = ImmersiveController.lightModeFontColorImmersive;
      this.iconFillColor = ImmersiveController.darkModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.lightModeIconColorImmersiveDisabled;
    }
    this.isMaskingLayerShow = true;
    this.iconBgColor = ImmersiveController.bottomColumnBgColor;
    this.iconBgColorDisabled = ImmersiveController.bottomColumnBgColor;
    this.opacityDisabled = 1;
    this.bgBlur = BlurStyle.COMPONENT_ULTRA_THIN;
    this.bgBlurDisabled = BlurStyle.COMPONENT_ULTRA_THIN;
    this.textFontShadowRadius = ImmersiveController.textFontShadowRadiusImmersive;
    this.textFontShadowColor = ImmersiveController.textFontShadowColorImmersive;
  }

  private setNormalModeParam(currentMode: ConfigurationConstant.ColorMode): void {
    this.currentMaskingLayerOpacity = 0;
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.textFontColor = ImmersiveController.darkModeFontColor;
      this.iconBgColor = ImmersiveController.darkModeIconBgColor;
      this.iconBgColorDisabled = ImmersiveController.darkModeIconBgColorDisabled;
      this.iconFillColor = ImmersiveController.darkModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.darkModeIconFillColor;
    } else {
      this.textFontColor = ImmersiveController.lightModeFontColorNormal;
      this.iconBgColor = ImmersiveController.lightModeIconBgColorNormal;
      this.iconBgColorDisabled = ImmersiveController.lightModeIconBgColorDisabled;
      this.iconFillColor = ImmersiveController.lightModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.lightModeIconFillColor;
    }
    this.isMaskingLayerShow = false;
    this.opacityDisabled = 0.4;
    this.columnBgColor = $r('app.color.transparent');
    this.bgBlur = BlurStyle.NONE;
    this.bgBlurDisabled = BlurStyle.NONE;
    this.textFontShadowRadius = ImmersiveController.textFontShadowRadiusNormal;
    this.textFontShadowColor = ImmersiveController.textFontShadowColorNormal;
  }

  private setImmersiveStatusColor(currentMode: ConfigurationConstant.ColorMode, isSideBar?: boolean): void {
    Log.info(TAG, `setImmersiveStatusColor: ${currentMode}`);
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.mainWindow.setWindowSystemBarProperties({ statusBarContentColor: ImmersiveController.darkModeFontColor });
    } else {
      this.mainWindow.setWindowSystemBarProperties({
        statusBarContentColor: isSideBar ? ImmersiveController.lightModeFontColorNormal :
        ImmersiveController.lightModeFontColorImmersive
      });
    }
  }

  private setNormalStatusColor(currentMode: ConfigurationConstant.ColorMode): void {
    Log.info(TAG, `setNormalStatusColor: ${currentMode}`);
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.mainWindow.setWindowSystemBarProperties({ statusBarContentColor: ImmersiveController.darkModeFontColor });
    } else {
      this.mainWindow.setWindowSystemBarProperties({
        statusBarContentColor: ImmersiveController.lightModeFontColorNormal,
      });
    }
  }

  public setStatusColor(nextScrollYOffset: number, currentMode: ConfigurationConstant.ColorMode,
    isSideBar?: boolean): void {
    if (this.isFromPortrait) {
      return;
    }
    if (nextScrollYOffset > this.immersiveThreshold) {
      this.setImmersiveStatusColor(currentMode, isSideBar);
    } else {
      this.setNormalStatusColor(currentMode);
    }
  }


  private enterImmersive(currentMode: ConfigurationConstant.ColorMode, duration: number,
    nextScrollYOffset: number, isHorizontal: boolean, isScrollerBarTouch: boolean = false,
    currentViewType: MViewType = MViewType.DAY, isSideBar?: boolean): void {
    if (this.currentMaskingLayerOpacity === 1 && this.isHorizontal === isHorizontal && !this.isFromPortrait) {
      return;
    }

    Log.info(TAG, `enterImmersive nextScrollYOffset: ${nextScrollYOffset}`);
    this.setImmersiveStatusColor(currentMode, isSideBar);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    if (duration > 0) {
      animateToImmediately({
        curve: Curve.Linear,
        duration: duration,
      }, () => {
        this.isHorizontal = isHorizontal;
        this.isInImmersive = true;
        ImmersiveController.isInImmersive = true;
        this.setImmersiveModeParam(currentMode);
        this.singleTitleOpacity = !isScrollerBarTouch && currentViewType === MViewType.YEAR && !DeviceInfo.isTablet() ?
          0 : 1;
      })
      return;
    }
    this.isHorizontal = isHorizontal;
    this.isInImmersive = true;
    ImmersiveController.isInImmersive = true;
    this.singleTitleOpacity = !isScrollerBarTouch && currentViewType === MViewType.YEAR && !DeviceInfo.isTablet() ?
      0 : 1;
    this.setImmersiveModeParam(currentMode);
  }

  private quiteImmersive(currentMode: ConfigurationConstant.ColorMode, duration: number,
    nextScrollYOffset: number, isHorizontal: boolean): void {
    if (this.currentMaskingLayerOpacity === 0 && this.isHorizontal === isHorizontal) {
      return;
    }

    Log.info(TAG, `quiteImmersive nextScrollYOffset: ${nextScrollYOffset}`);
    this.setNormalStatusColor(currentMode);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    if (duration > 0) {
      animateToImmediately({
        curve: Curve.Linear,
        duration: duration,
      }, () => {
        this.isHorizontal = isHorizontal;
        this.isInImmersive = false;
        ImmersiveController.isInImmersive = false;
        this.setNormalModeParam(currentMode);
        this.singleTitleOpacity = 1;
      })
      return;
    }
    this.isHorizontal = isHorizontal;
    this.isInImmersive = false;
    ImmersiveController.isInImmersive = false;
    this.singleTitleOpacity = 1;
    this.setNormalModeParam(currentMode);
  }

  public enterOrQuiteImmersive(nextScrollYOffset: number, currentMode: ConfigurationConstant.ColorMode,
    isHorizontal: boolean, isScrollerBarTouch: boolean = false,
    currentViewType: MViewType = MViewType.DAY,
    duration: number = ImmersiveController.aniTime, isSideBar?: boolean): void {
    // 人像模式始终处于沉浸式
    if (this.isFromPortrait) {
      return;
    }
    if (nextScrollYOffset > this.immersiveThreshold) {
      this.enterImmersive(currentMode, duration, nextScrollYOffset, isHorizontal, isScrollerBarTouch,
        currentViewType, isSideBar);
    } else {
      this.quiteImmersive(currentMode, duration, nextScrollYOffset, isHorizontal);
    }
  }

  public setThreshold(threshold: number): void {
    this.immersiveThreshold = threshold;
  }

  /**
   * 更新是否显示多选按钮状态
   *
   * @param isShowMultiSelect 是否显示多选按钮
   */
  public updateMultiSelectState(isShowMultiSelect: boolean): void {
    this.isShowMultiSelect = isShowMultiSelect;
  }

  /**
   * 更新是否使用动效
   *
   * @param isMultiSelectUseAnimation 是否使用动效
   */
  public updateMultiSelectUseAnimation(isMultiSelectUseAnimation: boolean): void {
    this.isMultiSelectUseAnimation = isMultiSelectUseAnimation;
  }

  public isMaskingLayerShown(): boolean {
    return this.isMaskingLayerShow;
  }
}