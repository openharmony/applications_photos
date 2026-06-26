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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Constants } from '../model/common/Constants'
import lazy { TimeController } from './TimeController'
import lazy { WindowUtil } from './WindowUtil';

const TAG: string = 'ImmersiveController';

export enum MViewType {
  YEAR,
  MONTH,
  DAY,
  GROUP_DAY
}

export class ImmersiveController {
  public static readonly FONT_COLOR_LIGHT: string = '#ffffff';
  public static readonly FONT_COLOR_DARK: string = '#000000';
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
  public enable: boolean = true;
  public bgBlur: BlurStyle;
  public bgBlurDisabled: BlurStyle;
  public opacityDisabled: number | Resource;
  public currentMaskingLayerOpacity: number;
  public mainWindow: window.Window = global.mainWindow();
  public columnBgColor: string | Resource = $r('app.color.transparent');
  private isMaskingLayerShow: boolean = false;
  private isFromPortrait: boolean = false;
  private isHorizontal: boolean = false;
  public immersiveThreshold: number = 20;
  public isInImmersive: boolean = false;
  public textShadowRadius: number = 0;
  public textShadowColor: string = '#00000000';
  private static darkModeFontColor: string = ImmersiveController.FONT_COLOR_LIGHT;
  private static lightModeFontColorImmersive: string = '#ffffff';
  private static lightModeFontColorNormal: string = '#000000';
  public static darkModeIconBgColor: string = '#19ffffff';
  private static darkModeIconBgColorDisabled: string = '#0a0a0a';
  private static lightModeIconBgColorImmersive: string = '#19ffffff';
  public static lightModeIconBgColorNormal: string = '#0C000000';
  private static lightModeIconBgColorDisabled: string = '#edeef0';
  private static darkModeIconFillColor: string = '#FFFFFF';
  private static lightModeIconFillColor: string = '#000000';
  private static darkModeIconColorImmersiveDisabled: Resource = $r('sys.color.ohos_id_color_tertiary');
  private static lightModeIconColorImmersiveDisabled: Resource = $r('sys.color.ohos_id_color_text_tertiary_contrary');
  public static textFontShadowRadiusImmersive: number = 20;
  public static textFontShadowColorImmersive: string = '#4d000000';
  private static textFontShadowRadiusNormal: number = 0;
  private static textFontShadowColorNormal: string = '#00000000';
  public static bottomColumnBgColor: string = '#cc808080';
  public static aniTime: number = 150;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public static readonly maskerLayerZIndex: number = 1;
  public static isInImmersive: boolean = false;
  // 横屏tabBar动画参数
  public static endTabBarHeight: number = 0;
  // 横屏segmentButton动画参数
  public endSegmentY: number = 0;
  // 年视图进入沉浸态时屏幕左侧时间胶囊动画延时
  public static YEAR_VIEW_LEFT_CAPSULES_ANIMATION_DELAY: number = 100;
  // 是否处于捏合状态
  public isPinching: boolean = false;
  // 是否在拖动滚动条
  private isScrollerBarTouch: boolean = false;
  // 当前处于的视图类型
  private currentViewType: MViewType = MViewType.DAY;
  private isSideBar: boolean | undefined = false;
  private timeController: TimeController;
  private currentStatusColor: string | undefined = '';

  constructor(colorMode: ConfigurationConstant.ColorMode, isHorizontal: boolean, isFromPortrait: boolean = false,
    immersiveThreshold: number = 20, timeController: TimeController = new TimeController()) {
    this.isRefreshShow = false;
    /* instrument ignore if */
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
    this.currentMaskingLayerOpacity = Constants.TRANSPARENT;
    this.isHorizontal = isHorizontal;
    this.isFromPortrait = isFromPortrait;
    this.immersiveThreshold = immersiveThreshold;
    this.timeController = timeController;
  }

  /* instrument ignore next */
  public setParamForPortrait(isFromPortrait: boolean, colorMode: ConfigurationConstant.ColorMode): void {
    // 人像相册初始状态处于沉浸式
    if (isFromPortrait) {
      this.enterImmersive(colorMode, 0, Number.MAX_SAFE_INTEGER, false);
    }
    this.isFromPortrait = isFromPortrait;
  }

  /**
   * 更新标题栏颜色
   *
   * @param currentMode 当前显示模式
   * @param currentStatusColor 当前颜色
   */
  /* instrument ignore next */
  public onColorModeChange(currentMode: ConfigurationConstant.ColorMode, currentStatusColor?: string): void {
    this.currentStatusColor = currentStatusColor;
    Log.info(TAG, `onColorModeChange currentMaskingLayerOpacity:${this.currentMaskingLayerOpacity},isFromPortrait${this.isFromPortrait}, currentcolorMode${currentMode}`);
    if (this.isFromPortrait) {
      this.setImmersiveModeParam(currentMode, true);
      this.setImmersiveStatusColor(currentMode, true);
      return;
    }
    if (this.currentMaskingLayerOpacity === Constants.TRANSPARENT) {
      this.setNormalStatusColor(currentMode);
      this.setNormalModeParam(currentMode);
      Log.info(TAG, 'currentMaskingLayerOpacity is TRANSPARENT');
      return;
    }
    this.setImmersiveStatusColor(currentMode, true);
    this.setImmersiveModeParam(currentMode, true);
  }

  /* instrument ignore next */
  private setImmersiveModeParam(currentMode: ConfigurationConstant.ColorMode,
    onColorModeChange: boolean = false): void {
    this.currentMaskingLayerOpacity = Constants.OPAQUE;
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

  /* instrument ignore next */
  private setNormalModeParam(currentMode: ConfigurationConstant.ColorMode): void {
    this.currentMaskingLayerOpacity = Constants.TRANSPARENT;
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.textFontColor = ImmersiveController.darkModeFontColor;
      this.iconBgColor = ImmersiveController.darkModeIconBgColor;
      this.iconBgColorDisabled = ImmersiveController.darkModeIconBgColorDisabled;
      this.iconFillColor = ImmersiveController.darkModeIconFillColor;
      this.iconFillColorDisabled = ImmersiveController.darkModeIconFillColor;
    } else {
      this.iconBgColor = ImmersiveController.lightModeIconBgColorNormal;
      this.iconBgColorDisabled = ImmersiveController.lightModeIconBgColorDisabled;
      this.textFontColor = ImmersiveController.lightModeFontColorNormal;
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

  private setImmersiveStatusColor(currentMode: ConfigurationConstant.ColorMode, isSideBar?: boolean,
    isShowPhotoBrowser?: boolean): void {
    /* instrument ignore if */
    if (this.currentStatusColor && this.currentStatusColor !== '') {
      WindowUtil.updateWindowSystemBarProperties(this.currentStatusColor);
      Log.info(TAG, `setImmersiveStatusColor:${currentMode}, currentStatusColor:${this.currentStatusColor}`);
      // 标题栏颜色更新完成后重置变量，防止缓存值影响其他非照片页场景
      this.currentStatusColor = '';
      return;
    }
    Log.info(TAG, `setImmersiveStatusColor:${currentMode} ${isSideBar} ${isShowPhotoBrowser}`);
    /* instrument ignore if */
    if (DeviceInfo.isPc()) {
      if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        WindowUtil.updateWindowSystemBarProperties(ImmersiveController.darkModeFontColor);
        Log.info(TAG, 'set darkMode color');
      } else {
        WindowUtil.updateWindowSystemBarProperties(ImmersiveController.lightModeFontColorNormal);
        Log.info(TAG, 'set lightMode color');
      }
    } else {
      /* instrument ignore if */
      if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        WindowUtil.updateWindowSystemBarProperties(ImmersiveController.darkModeFontColor);
      } else {
        WindowUtil.updateWindowSystemBarProperties(isSideBar || isShowPhotoBrowser ?
        ImmersiveController.lightModeFontColorNormal : ImmersiveController.lightModeFontColorImmersive);
      }
    }
  }

  private setNormalStatusColor(currentMode: ConfigurationConstant.ColorMode): void {
    Log.info(TAG, `setNormalStatusColor:${this.currentViewType} ${currentMode} ${this.isInImmersive}`);
    let currentStatusColor: string = ImmersiveController.darkModeFontColor;
    // 深色模式时标题栏始终是白色，浅色模式时需要区分是否处于沉浸态和是否处于分组视图，浅色模式的非沉浸态时和浅色模式的分组视图时都是黑色
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT && (!this.isInImmersive ||
      this.currentViewType === MViewType.GROUP_DAY)) {
      currentStatusColor = ImmersiveController.lightModeFontColorNormal;
    }
    WindowUtil.updateWindowSystemBarProperties(currentStatusColor);
  }

  public setStatusColor(nextScrollYOffset: number, currentMode: ConfigurationConstant.ColorMode,
    isSideBar?: boolean, isisAlwaysImmersive?: boolean): void {
    /* instrument ignore if */
    if (this.isFromPortrait) {
      return;
    }
    Log.info(TAG, `setStatusColor:${this.isInImmersive} ${nextScrollYOffset} ${this.immersiveThreshold}`);
    /* instrument ignore if */
    if (isisAlwaysImmersive || nextScrollYOffset > this.immersiveThreshold) {
      this.setImmersiveStatusColor(currentMode, isSideBar);
    } else {
      this.setNormalStatusColor(currentMode);
    }
  }

  public setCurrentViewType(view: MViewType): void {
    this.currentViewType = view;
  }

  //进入沉浸态
  /* instrument ignore next */
  private enterImmersive(currentMode: ConfigurationConstant.ColorMode, duration: number, nextScrollYOffset: number,
    isHorizontal: boolean, isShowPhotoBrowser?: boolean): void {
    if (this.currentMaskingLayerOpacity === Constants.OPAQUE && this.isHorizontal === isHorizontal &&
      !this.isFromPortrait) {
      if (!this.isScrollerBarTouch && !this.isInImmersive) {
        Log.info(TAG, `enterImmersive currentViewType: ${this.currentViewType}, ${this.currentMaskingLayerOpacity}`);
      }
      this.isInImmersive = true;
      return;
    }
    this.isInImmersive = true;
    if (this.currentViewType === MViewType.YEAR) {
      // 进入沉浸态时如果年视图胶囊消失的动效已经启动，则强制停止未结束的动效
      if (this.timeController?.isStartYearOpacity && !this.timeController?.isShowYearCapsules) {
        this.timeController?.pauseOpacityAnimator();
        this.timeController.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
        this.timeController.singleTitleOpacity = Constants.TRANSPARENT;
      }
    }
    Log.info(TAG, `enterImmersive nextScrollYOffset: ${nextScrollYOffset}, currentViewType:${this.currentViewType}` +
      `,isStartYearOpacity:${this.timeController?.isStartYearOpacity},currentMode:${currentMode},duration:${duration}` +
      `, isShowYearCapsules:${this.timeController?.isShowYearCapsules}, currentStatusColor:${this.currentStatusColor}`);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    let isStartOpacity: boolean = !this.isScrollerBarTouch && this.currentViewType === MViewType.YEAR &&
      !DeviceInfo.isTablet();
    // 沉浸态时深色模式和浅色模式时都是白色标题栏
    this.currentStatusColor = Constants.RULER_FILL_STYLE_100;
    this.setImmersiveStatusColor(currentMode, this.isSideBar, isShowPhotoBrowser);
    if (duration > 0) {
      this.execAnimateImmediately(duration, currentMode, isHorizontal, this.currentViewType, isStartOpacity);
      // 捏合进沉浸态时不启动年时间胶囊，因为此时在视图切换的时候已经启动了年的时间胶囊
      if (!this.isPinching && isStartOpacity) {
        this.timeController.updateOpacityBySharp(duration, Constants.OPAQUE, () => {
          this.timeController.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
        });
      } else {
        /* instrument ignore if */
        if (this.currentViewType === MViewType.YEAR && !this.isScrollerBarTouch) {
          this.timeController.yearViewLeftCapsulesOpacity = Constants.OPAQUE;
        } else {
          this.timeController.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
        }
      }
      return;
    }
    /* instrument ignore next */
    this.isHorizontal = isHorizontal;
    this.isInImmersive = true;
    this.isRefreshShow = false;
    ImmersiveController.isInImmersive = true;
    this.timeController.singleTitleOpacity = isStartOpacity ? Constants.TRANSPARENT : Constants.OPAQUE;
    this.setImmersiveModeParam(currentMode);
    this.timeController.yearViewLeftCapsulesOpacity = isStartOpacity ? Constants.OPAQUE : Constants.TRANSPARENT;
  }

  /* instrument ignore next */
  private execAnimateImmediately(duration: number, currentMode: ConfigurationConstant.ColorMode, isHorizontal: boolean,
    currentViewType: MViewType, isStartOpacity: boolean): void {
    animateToImmediately({
      curve: Curve.Sharp,
      duration: duration,
      onFinish: () => {
        // 年视图进入沉浸态时在标题栏完全隐藏后再将文字设置成对应颜色, 反复进退沉浸态场景只有最终停在沉浸态时才需要更新文字颜色
        if (this.currentViewType === MViewType.YEAR && this.isInImmersive && !this.isPinching) {
          this.textFontColor = currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
          ImmersiveController.darkModeFontColor : ImmersiveController.lightModeFontColorImmersive;
        }
      }
    }, () => {
      if (this.currentViewType === MViewType.GROUP_DAY) {
        Log.info(TAG, 'enter immersive in group, reject');
        return;
      }
      this.isHorizontal = isHorizontal;
      this.isInImmersive = true;
      this.isRefreshShow = false;
      ImmersiveController.isInImmersive = true;
      // 只有日、月视图需要显示地址信息, 年视图不显示地址信息
      if (currentViewType !== MViewType.YEAR) {
        this.timeController.subLocalityAddressOpacity = Constants.OPAQUE;
      }
      this.setImmersiveModeParam(currentMode);
      this.timeController.singleTitleOpacity = isStartOpacity ? Constants.TRANSPARENT : Constants.OPAQUE;
    })
  }

  /* instrument ignore next */
  private quiteImmersive(currentMode: ConfigurationConstant.ColorMode, duration: number, nextScrollYOffset: number,
    isHorizontal: boolean, isScrollerBarTouch: boolean): void {
    if (this.currentMaskingLayerOpacity === Constants.TRANSPARENT && this.isHorizontal === isHorizontal) {
      if (!isScrollerBarTouch) {
        Log.debug(TAG, `quiteImmersive currentViewType:${this.currentViewType}`);
      }
      this.isInImmersive = false;
      return;
    }
    this.isInImmersive = false;
    if (this.currentViewType === MViewType.YEAR || this.currentViewType === MViewType.GROUP_DAY) {
      // 退出沉浸态时如果年视图胶囊显示的动效已经启动，则强制停止未结束的动效
      /* instrument ignore if */
      if (this.timeController?.isStartYearOpacity && this.timeController?.isShowYearCapsules) {
        this.timeController?.pauseOpacityAnimator();
      }
      this.timeController.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      this.timeController.singleTitleOpacity = Constants.OPAQUE;
    }
    Log.info(TAG, `quiteImmersive nextScrollYOffset:${nextScrollYOffset}, currentViewType:${this.currentViewType}` +
      `, isStartYearOpacity:${this.timeController?.isStartYearOpacity}, duration:${duration}, ${this.isPinching}` +
      `, isShowYearCapsules:${this.timeController?.isShowYearCapsules}`);
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR, []);
    this.setNormalStatusColor(currentMode);
    // 延迟5ms执行退出沉浸态动效, 防止年视图退出沉浸态时标题闪白
    this.execOpacityAnimateByDelay(duration, currentMode, isHorizontal, this.currentViewType);
  }

  /* instrument ignore next */
  private execOpacityAnimateByDelay(duration: number, currentMode: ConfigurationConstant.ColorMode,
    isHorizontal: boolean, currentViewType: MViewType): void {
    if (duration > 0) {
      this.execOpacityAnimate(duration, currentMode, isHorizontal, currentViewType);
      this.execSignalTitleOpacity(duration, currentViewType);
      return;
    }
    this.isHorizontal = isHorizontal;
    this.isInImmersive = false;
    this.isRefreshShow = true;
    ImmersiveController.isInImmersive = false;
    this.timeController.singleTitleOpacity = Constants.OPAQUE;
    this.setNormalModeParam(currentMode);
    /* instrument ignore if */
    if (!this.isPinching) {
      this.timeController.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
    }
  }

  /* instrument ignore next */
  private execSignalTitleOpacity(duration: number, currentViewType: MViewType): void {
    if (currentViewType === MViewType.YEAR) {
      animateToImmediately({
        curve: Curve.Sharp,
        duration: duration,
        delay: ImmersiveController.YEAR_VIEW_LEFT_CAPSULES_ANIMATION_DELAY,
      }, () => {
        this.timeController.singleTitleOpacity = Constants.OPAQUE;
      })
    }
  }

  /* instrument ignore next */
  private execOpacityAnimate(duration: number, currentMode: ConfigurationConstant.ColorMode, isHorizontal: boolean,
    currentViewType: MViewType): void {
    animateToImmediately({
      curve: Curve.Sharp,
      duration: duration,
      onFinish: () => {
        // 年视图退出沉浸态时需要将地址透明度置成0, 防止非沉浸态年视图切换到月、日视图时地址依然显示的问题
        if (this.currentViewType === MViewType.YEAR) {
          this.timeController.subLocalityAddressOpacity = Constants.TRANSPARENT;
        }
        Log.info(TAG, `execOpacityAnimate onFinish:${currentViewType}`);
      }
    }, () => {
      this.isHorizontal = isHorizontal;
      this.isInImmersive = false;
      this.isRefreshShow = true;
      ImmersiveController.isInImmersive = false;
      this.setNormalModeParam(currentMode);
      if (!this.isPinching) {
        this.timeController.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      }
      if (currentViewType !== MViewType.YEAR) {
        this.timeController.singleTitleOpacity = Constants.OPAQUE;
        this.timeController.subLocalityAddressOpacity = Constants.TRANSPARENT;
      }
      Log.info(TAG, `execOpacityAnimate currentViewType:${currentViewType}`);
    })
  }

  // 视图切换时若上一视图处于沉浸态并且下一个视图不能进入沉浸态, 则退出沉浸态
  /* instrument ignore next */
  public quiteImmersiveOnAppear(currentMode: ConfigurationConstant.ColorMode, duration: number): void {
    Log.info(TAG, `quiteImmersiveOnAppear currentViewType:${this.currentViewType},isInImmersive:${this.isInImmersive}` +
      `, isStartYearOpacity:${this.timeController?.isStartYearOpacity}` +
      `, isShowYearCapsules:${this.timeController?.isShowYearCapsules}`);
    if (this.currentViewType === MViewType.YEAR) {
      // 退出沉浸态时如果年视图胶囊显示的动效已经启动，则强制停止未结束的动效
      /* instrument ignore if */
      if (this.timeController?.isStartYearOpacity && this.timeController?.isShowYearCapsules) {
        this.timeController?.pauseOpacityAnimator();
      }
      this.timeController.yearViewLeftCapsulesOpacity = Constants.TRANSPARENT;
      this.timeController.singleTitleOpacity = Constants.OPAQUE;
    }
    // 非沉浸态时所有视图都不显示地址
    this.timeController.subLocalityAddressOpacity = Constants.TRANSPARENT;
    // 深色模式下状态栏、symbol图标颜色变化不需要动画
    this.setNormalStatusColor(currentMode);
    if (!this.isInImmersive) {
      return;
    }
    /* instrument ignore next */
    animateToImmediately({
      curve: Curve.Sharp,
      duration: duration,
    }, () => {
      this.isInImmersive = false;
      this.isRefreshShow = true;
      ImmersiveController.isInImmersive = false;
      this.setNormalModeParam(currentMode);
      if (this.currentViewType === MViewType.YEAR) {
        this.timeController.singleTitleOpacity = Constants.OPAQUE;
      }
    });
  }

  /**
   * 进入或退出沉浸式状态
   *
   * @param nextScrollYOffset Y轴偏移量
   * @param currentMode 当前模式
   * @param isHorizontal 是否竖屏
   * @param isScrollerBarTouch 是否拖动滚动条
   * @param currentViewType 当前视图类型
   * @param duration 持续时间
   * @param isSideBar PAD侧边栏是否展开
   * @param isShowPhotoBrowser 是否大图
   */
  /* instrument ignore next */
  public enterOrQuiteImmersive(nextScrollYOffset: number, currentMode: ConfigurationConstant.ColorMode,
    isHorizontal: boolean, isScrollerBarTouch: boolean = false,
    currentViewType: MViewType = MViewType.DAY,
    duration: number = ImmersiveController.aniTime, isSideBar?: boolean,
    isShowPhotoBrowser?: boolean): void {
    // 人像模式始终处于沉浸式
    /* instrument ignore if */
    if (this.isFromPortrait) {
      Log.debug(TAG, 'enterOrQuiteImmersive isFromPortrait');
      return;
    }
    /* instrument ignore if */
    if (currentViewType === MViewType.GROUP_DAY) {
      return;
    }
    this.isScrollerBarTouch = isScrollerBarTouch;
    this.currentViewType = currentViewType;
    this.isSideBar = isSideBar;
    if (this.isInImmersive !== nextScrollYOffset > this.immersiveThreshold) {
      Log.info(TAG, `enterOrQuiteImmersive currentViewType:${this.currentViewType},YOffset:${nextScrollYOffset}` +
        `, immersiveThreshold:${this.immersiveThreshold}, isScrollerBarTouch:${isScrollerBarTouch}`);
    }
    if (nextScrollYOffset > this.immersiveThreshold) {
      this.enterImmersive(currentMode, duration, nextScrollYOffset, isHorizontal, isShowPhotoBrowser);
      this.isInImmersive = true;
      ImmersiveController.isInImmersive = true;
    } else {
      this.quiteImmersive(currentMode, duration, nextScrollYOffset, isHorizontal, isScrollerBarTouch);
      this.isInImmersive = false;
      ImmersiveController.isInImmersive = false;
      this.appBroadCast.emit(BroadCastConstants.ON_CANCEL_MULTISELECT, [true]);
    }
    this.appBroadCast.emit(BroadCastConstants.UPDATE_ACTION_BAR_COLOR);
  }

  /**
   * 设置沉浸式阈值
   *
   * @param threshold 沉浸式阈值
   */
  public setThreshold(threshold: number): void {
    this.immersiveThreshold = threshold;
  }

  /**
   * 是否显示组件
   */
  public isMaskingLayerShown(): boolean {
    return this.isMaskingLayerShow;
  }
}