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

import lazy { Log } from '../../utils/Log';
import lazy { Constants } from './Constants';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy window from '@ohos.window';
import lazy display from '@ohos.display';
import lazy Bundles, { BUNDLE_NAMES } from '@ohos/tools/src/main/utils/Bundle';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import type { BusinessError, Callback } from '@ohos.base';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import type uiExtensionHost from '@ohos.uiExtensionHost';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { MathUtil } from '../../utils/MathUtil';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { screenLock } from '@kit.BasicServicesKit';
import lazy settings from '@ohos.settings';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import type common from '@ohos.app.ability.common';
import lazy { Size } from '@kit.ArkUI';
import lazy { TestKit } from '@ohos/tools/tsIgnore/arkui/TestKit.e';
import lazy { PhotoConfig } from '../../config/PhotoConfig';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { SelectParams } from './SelectParams';
import lazy { FoldUtil } from '../../utils/FoldUtil';
import lazy { PreferencesUtil } from '../../utils/PreferencesUtil';

/* instrument ignore file */
const TAG: string = 'common_ScreenManager';

// Horizontal and vertical screen flag
const SCREEN_ORIENTATION_HORIZONTAL: string = 'isHorizontal';
//immersive bar background color
const IMMERSIVE_BAR_BACKGROUND_COLOR: string = '#000000';
const SPLIT_HEIGHT_MULTIPLE: number = 0.5;
const SPLIT_HEIGHT_CALCULATE_MULTIPLE: number = 0.3;
/* less SPLIT_RATIO show phoneux, or tablet */
const SPLIT_RATIO: number = 0.4;

const RESET_STATUS_BAR_DELAY: number = 500;

type SystemBarKeys = 'status' | 'navigation';

type specificSystemBarKeys = 'status' | 'navigation' | 'navigationIndicator';

/**
 * 平板侧边栏宽度
 */
const sideBarWidth: number = 240;
const sideBarWidthBreakPoint: number = 684;
const COLUMN_MARGIN_TOOLBAR: number = 24;
const COLUMN_GUTTER_TOOLBAR: number = 24;
const ToolBar_MAX_LENGTH: number = 6;
const ToolBar_ICON_SIZE: number = 24;
const TABLE_HOT_ZONE: number = 52;
const NAVIGATION_INDICATOR_HIDDEN_TIME: number = 2000;
const DRAG_TIME: number = 10;


export enum ColumnSize {
  COLUMN_ONE_POINT_FIVE = 1.5,
  COLUMN_TWO = 2,
  COLUMN_THREE = 3,
  COLUMN_FOUR = 4,
  COLUMN_FIVE = 5,
  COLUMN_SIX = 6,
  COLUMN_EIGHT = 8,
  COLUMN_TWELVE = 12,
}

export enum ScreenWidth {
  WIDTH_MEDIUM = 600,
  WIDTH_LARGE = 840,
  WIDTH_XLARGE = 1440,
}

export enum ColumnMargin {
  WEAK_MARGIN = 16,
  MEDIUM_MARGIN = 24,
  STRONG_MARGIN = 32,
}

export enum WindowMode {
  UNDEFINED = 1,
  FULLSCREEN,
  PRIMARY,
  SECONDARY,
  FLOATING
}

/*
 * 底部导航栏类型：0 三键；1 导航条
 * */
export enum NavigationStyle {
  THREE_KEY = '0',
  AI_BAR = '1',
}

export interface DiggingHoleCameraArea {
  top: number,
  right: number,
  bottom: number,
  left: number,
}

interface WindowAvoidAreaType {
  type: window.AvoidAreaType,
  area: window.AvoidArea,
}

export function getScreen(storage: LocalStorage = LocalStorage.getShared()): ScreenManager {
  return ScreenManager.getInstance(storage);
}

export function isOrientationHorizontal(): boolean {
  return (AppStorage.get(SCREEN_ORIENTATION_HORIZONTAL) ?? DeviceInfo.isPc()) || DeviceInfo.isVerdeFoldable();
}

export function setHorizontal(isHorizontal: boolean, storage: LocalStorage = LocalStorage.getShared()): void {
  let startTime: number = Date.now();
  Log.info(TAG, `setHorizontal start ${isOrientationHorizontal()}, param isHorizontal = ${isHorizontal}`);
  AppStorage.setOrCreate<boolean>(SCREEN_ORIENTATION_HORIZONTAL, isHorizontal);
  getScreen(storage).notifyOrientationChanged(isHorizontal);
  Log.info(TAG, `setHorizontal end ${isOrientationHorizontal()}, time cost:${Date.now() - startTime}`);
}

const LOWER_HALF_SCREEN = 999;

export class ScreenManager {
  public static readonly ON_WIN_SIZE_CHANGED: string = 'on_win_size_changed';
  public static readonly ON_SPLIT_MODE_CHANGED: string = 'on_split_mode_changed';
  public static readonly ON_SYSTEM_UI_COLOR: string = 'on_system_ui_color';
  public static readonly ON_LEFT_BLANK_CHANGED: string = 'on_left_blank_changed';
  public static readonly ON_AREA_HEIGHT_CHANGED: string = 'on_area_height_changed';
  public static readonly ON_DISPLAY_WIDTH_CHANGED: string = 'on_display_width_changed';
  public static readonly ON_WIN_MODE_CHANGE: string = 'on_win_mode_change';
  public static readonly ON_WIN_STATUS_MODE_CHANGE: string = 'on_win_status_mode_change';
  public static readonly ON_ORIENTATION_CHANGED: string = 'on_orientation_changed';
  public static readonly ON_STATUS_BAR_HEIGHT_CHANGED: string = 'on_status_bar_height_changed';
  public static readonly ON_DIGGING_HOLE_CHANGED: string = 'on_digging_hole_changed';
  public static readonly SIDEBAR_CHANGE_BREAKPOINT: string = 'sidebar_change_breakpoint';
  public static readonly DEFAULT_WIDTH: number = 1920;
  public static readonly DEFAULT_HEIGHT: number = 1080;
  // LEM外屏展开到windowSize，px2vp接口有问题，特殊判断
  public static readonly INNER_SCREEN_RATIO: number = 3.125;
  // no interface is available to obtain the height of WindowDecor. WindowDecor px Height: 56.
  public static readonly WIN_DECOR_HEIGHT_PX: number = 56;
  public static readonly WIN_BOTTOM_BORDER_HEIGHT_PX: number = 7;
  public static readonly WIN_BOTTOM_BORDER_WIDTH_PX: number = 2;
  private winWidth: number = 0.0;
  private winHeight: number = 0.0;
  private columnMargin: number = 0.0;
  private columnGutter: number = 0.0;
  private statusBarHeight: number = 0;
  private originalWinWidth: number = 0;
  private isInBreakPoint: boolean = false;
  private naviBarHeight: number = 0;
  private leftBlank: [number, number, number, number] = [0, 0, 0, 0];
  private broadcast: BroadCast = new BroadCast();
  private mainWindow: window.Window | undefined = undefined;
  private columns: number = ColumnSize.COLUMN_FOUR;
  private safePadding: [number, number, number, number] = [0, 0, 0, 0];
  private isForceVertical: boolean = false;
  private dragTimer: number | null = null;
  // Default sidebar for Pc
  private hasSidebar: boolean = true;
  private windowMode: WindowMode = WindowMode.UNDEFINED;
  private isFullScreen: boolean = false;
  public windowStatusMode: window.WindowStatusType = 0;
  private diggingHoleCameraArea: DiggingHoleCameraArea = {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  };
  private windowAvoidArea: window.AvoidArea | null = null;
  private windowAvoidAreaCallBackFunc: Callback<WindowAvoidAreaType> = (data: WindowAvoidAreaType):
    void => this.windowAvoidAreaCallBack(data);
  public windowStatusChangeCallBackFunc: Callback<window.WindowStatusType> =
    (data: window.WindowStatusType): void => this.windowStatusChangeCallBack(data);
  private minWinWidth: number = 520;
  private minWinHeight: number = 520;
  private disScreenWidth: number = 0;
  private disScreenHeight: number = 0;
  private isShowStatusBefore: boolean | undefined = undefined;
  private isShowNavigationBefore: boolean | undefined = undefined;
  private isImmersionStyleBefore: boolean | undefined = undefined;
  private isImmersiveEnabled: boolean = false;
  private isScreenHorizontal: boolean = false;
  private previewColumns: number = ColumnSize.COLUMN_FOUR;
  private previewColumnMargin: number = 0.0;
  private previewColumnGutter: number = 0.0;
  private previewWidth: number = 0.0;
  private timer: number | null = null;
  private storage: LocalStorage;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public isAvoidHoleIgnoreInTimeline: boolean = false;
  private isCamera = Bundles.getInfo().name === BUNDLE_NAMES['camera'];
  private hostWindow?: uiExtensionHost.UIExtensionHostWindowProxy | null;
  // 幻灯片浏览、设置壁纸页
  public isInImmersivePage: boolean = false;
  private onWindowSizeChanged: Callback<window.Size> = (data: window.Size) => {
    Log.info(TAG, `windowSizeChange winW=${data.width}, winH=${data.width}`);
    if (!DeviceInfo.isPc() && !this.isUIExtensionEnv()) {
      try {
        let properties: window.WindowProperties = this.getMainWindow()?.getWindowProperties();
        this.isFullScreen = properties.isFullScreen;
      } catch (exception) {
        Log.error(TAG, `Failed to obtain the area. Cause:${JSON.stringify(exception)}`);
      }
    }
    /* instrument ignore next */
    if (DeviceInfo.isPc() || AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
      this.debounce(() => {
        this.onWinSizeChanged(data);
      })
    } else {
      this.onWinSizeChanged(data);
    }
  }

  private constructor(storage: LocalStorage) {
    Log.info(TAG, 'constructor');
    this.storage = storage;
    this.hasSidebar = DeviceInfo.isPc();
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      let abilityInfo = global.uiAbilityContext()?.abilityInfo;
      if (abilityInfo) {
        let winSize = abilityInfo.windowSize;
        this.minWinWidth = winSize?.minWindowWidth;
        this.minWinHeight = winSize?.minWindowHeight;
      } else {
        let bundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE +
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
        bundleManager.getBundleInfoForSelf(bundleFlag).then((bundleInfo: bundleManager.BundleInfo) => {
          let winSize = bundleInfo.hapModulesInfo[0]?.abilitiesInfo[0]?.windowSize;
          this.minWinWidth = winSize?.minWindowWidth;
          this.minWinHeight = winSize?.minWindowHeight;
        });
      }
      Log.info(TAG, `getMinWinSize from bundle, minWidth: ${this.minWinWidth} minHeight: ${this.minWinHeight}`);
    }
    this.setSafePadding();
  }

  public static getInstance(storage?: LocalStorage): ScreenManager {
    if (storage === undefined) {
      storage = LocalStorage.getShared();
      Log.info(TAG, `getInstance, storage: ${storage}`);
    }
    let manager: ScreenManager | undefined = storage?.get<ScreenManager>(Constants.APP_KEY_SCREEN_MANAGER);
    if (!manager) {
      Log.info(TAG, `getInstance, storage can not get manager`);
      manager = new ScreenManager(storage);
      storage?.setOrCreate(Constants.APP_KEY_SCREEN_MANAGER, manager);
    }
    return manager ?? new ScreenManager(storage);
  }

  public getLeftBlank(): number[] {
    return [0, this.getStatusBarHeight(), 0, this.getNaviBarHeight()];
  }

  public getDisScreenWidth(): number {
    return this.disScreenWidth;
  }

  public getDisScreenHeight(): number {
    return this.disScreenHeight;
  }

  public initializationSize(): Promise<void> {
    // Area data obtained through the system interface,
    // There is a possibility that the area data is incorrect.
    let size: window.Rect = this.getWinRect();
    Log.info(TAG, `initializationSize: ${JSON.stringify(size)}`);
    return new Promise<void>((resolve, reject) => {
      if (!size) {
        reject();
      }
      Log.info(TAG, `display screen windowRect: ${JSON.stringify(size)}`);
      if (size.width === 0 || size.height === 0) {
        Log.error(TAG, 'screen size exception!');
        resolve();
        return;
      }
      this.winWidth = px2vp(size.width);
      if (this.windowMode === WindowMode.FLOATING) {
        this.winWidth = px2vp(size.width) - 2 * (Constants.CONTAINER_BORDER_WIDTH + Constants.CONTENT_PADDING);
      }
      this.winHeight =
        DeviceInfo.isSmallFoldExpanded() ? size.height / ScreenManager.INNER_SCREEN_RATIO : px2vp(size.height);
      Log.info(TAG, `init winSize: ${size.width}*${size.height} px, ${this.winWidth}*${this.winHeight} vp`);
      if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
        this.columns = ColumnSize.COLUMN_FOUR;
        this.columnMargin = Constants.COLUMN_MARGIN_FOUR;
        this.columnGutter = Constants.COLUMN_GUTTER_FOUR;
      } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
        this.columns = ColumnSize.COLUMN_EIGHT;
        this.columnMargin = Constants.COLUMN_MARGIN_SIX;
        this.columnGutter = Constants.COLUMN_GUTTER_SIX;
      } else if (this.winWidth >= ScreenWidth.WIDTH_LARGE && this.winWidth < ScreenWidth.WIDTH_XLARGE) {
        this.columns = ColumnSize.COLUMN_TWELVE;
        this.columnMargin = Constants.COLUMN_MARGIN_EIGHT;
        this.columnGutter = Constants.COLUMN_GUTTER_EIGHT;
      } else {
        this.columns = ColumnSize.COLUMN_TWELVE;
        this.columnMargin = Constants.COLUMN_MARGIN_TWELVE;
        this.columnGutter = Constants.COLUMN_GUTTER_TWELVE;
      }
      this.updateFoldDisplayMode();
      this.emit(ScreenManager.ON_WIN_SIZE_CHANGED, [size]);
      resolve();
    });
  }

  // 获取屏幕属性
  public initOrientation(): void {
    try {
      let displayClass = this.getDisplayFixedForSmallFold();
      //获取屏幕的方向，0为竖屏，1为横屏，2反向竖屏，3反向横屏
      Log.info(TAG, `display orientation ${displayClass.orientation}`);
      if (displayClass.orientation && !DeviceInfo.isVerdeFoldable()) {
        setHorizontal(true);
      } else {
        setHorizontal(false);
      }
      // 平板分屏或全景多窗，非自由多窗
      if (this.windowStatusMode === window.WindowStatusType.SPLIT_SCREEN ||
        this.windowStatusMode === window.WindowStatusType.FLOATING &&
        DeviceInfo.isTablet() && !AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
        setHorizontal(false);
      }
    } catch (error) {
      Log.error(TAG, `Failed to obtain the default display object. error: ${error}, code: ${error?.code}`);
    }
  }

  /**
   卡片栅格宽度适配
   */
  public updateSize(): void {
    Log.info(TAG, 'updateSize');
    let size: window.Rect = this.getWinRect();
    this.updateWinSizeInner(size);
  }

  /**
   相机进大图宽高适配
   */
  public updateSizeCamera(): void {
    Log.info(TAG, 'updateSizeCamera');
    let size: window.Rect = this.getWinRect();
    let width: number = size.width;
    let height: number = size.height;
    size.width = height;
    size.height = width;
    this.updateWinSizeInner(size);
  }

  /**
   * 打开图形p3广色域开关，当前底座PC能力不足，屏蔽PC，能力准备好后放开
   */
  public openColorSpaceWideGamut(win: window.Window): void {
    win.isWindowSupportWideGamut().then((isSupport: boolean): void => {
      Log.info(TAG, `isWindowSupportWideGamut, isSupport ${isSupport}`);
      if (!isSupport) {
        return;
      }
      win.setWindowColorSpace(window.ColorSpace.WIDE_GAMUT).then((): void => {
        Log.info(TAG, 'setWindowColorSpace WIDE_GAMUT finish');
      })
    })
  }

  /**
   * Add Listeners
   *
   * @param event
   * @param fn
   */
  public on(event: string, fn: Function): void {
    this.broadcast.on(event, fn);
  }

  /**
   * Delete Listeners
   *
   * @param event
   * @param fn
   */
  public off(event: string, fn?: Function): void {
    this.broadcast.off(event, fn);
  }

  /**
   * Release Broadcast
   */
  public release(): void {
    this.appBroadCast?.release();
    this.broadcast?.release();
  }

  // Unit：vp
  public getWinWidth(): number {
    return this.winWidth;
  }

  // Unit：vp
  public setWinWidth(width: number): void {
    this.winWidth = width;
  }

  // Unit：vp
  public getWinHeight(): number {
    return this.winHeight;
  }

  // Unit: px
  public getWindowRectWidth(): number {
    return this.getWinRect()?.width;
  }

  // Unit: px
  public getWindowRectHeight(): number {
    return this.getWinRect()?.height;
  }

  // Returns the width of the layout area (LayoutWidth = WindowWidth).
  public getWinLayoutWidth(): number {
    Log.debug(TAG, `isFull=${this.isFullScreen}, winH=${this.winWidth}`);
    if (!DeviceInfo.isPc()) {
      return this.winWidth;
    }
    let winDecorWidth: number = this.isFullScreen ? 0 : px2vp(ScreenManager.WIN_BOTTOM_BORDER_WIDTH_PX);
    return this.winWidth - winDecorWidth;
  }

  // Returns the width of the screen width
  public getDisplayWidth(): number {
    return display.getDefaultDisplaySync().width;
  }

  // Returns the height of the layout area (LayoutHeight = WindowHeight - WindowDecorHeight).
  public getWinLayoutHeight(isPcCameraPull?: boolean): number {
    isPcCameraPull = isPcCameraPull || this.isCamera;
    Log.debug(TAG, `isPc=${DeviceInfo.isPc()}, isFull=${this.isFullScreen}, winH=${this.winHeight}`);
    if (!DeviceInfo.isPc()) {
      return this.winHeight;
    }
    let heightVp =
      DeviceInfo.isSmallFoldExpanded() ? ScreenManager.WIN_BOTTOM_BORDER_HEIGHT_PX / ScreenManager.INNER_SCREEN_RATIO :
      px2vp(ScreenManager.WIN_BOTTOM_BORDER_HEIGHT_PX);
    let winDecorHeight: number = 0;
    if (isPcCameraPull && !PhotoConfig.isFromMeetime) {
      winDecorHeight = this.getMainWindow()?.getWindowDecorHeight() + heightVp;
    }
    return this.winHeight - winDecorHeight;
  }

  public getStatusBarHeight(isForce?: boolean): number {
    if (isForce) {
      return this.getWinRect()?.top || 0;
    }
    return this.statusBarHeight;
  }

  public getWinDecorHeight(): number {
    let winDecorHeight = 0;
    if (!DeviceInfo.isPc() || this.isFullScreen) {
      return winDecorHeight;
    }
    if (!this.getMainWindow()) {
      Log.warn(TAG, 'The window has not been created or has been destroyed.');
      return winDecorHeight;
    }
    try {
      winDecorHeight = this.getMainWindow()?.getWindowDecorHeight();
    } catch (error) {
      Log.error(TAG, `Failed to getWinDecorHeight. error: ${error}, code: ${error?.code}`);
    }
    return winDecorHeight;
  }

  public getNaviBarHeight(): number {
    return this.naviBarHeight;
  }

  public initWindowMode(): void {
    Log.info(TAG, `start to initialize photos application window mode: ${this.windowMode}`);
    this.windowMode = WindowMode.UNDEFINED;
    this.checkWindowMode();
    this.getHost() && this.setMainWindow();
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Log.info(TAG, 'initWindowMode setSplitScreen Succeeded');
      this.setSplitScreen();
    } else {
      Log.info(TAG, 'initWindowMode setFullScreen Succeeded');
      this.setFullScreen();
    }
  }

  public destroyWindowMode(): void {
    Log.info(TAG, `start to destory photos application window mode: ${this.windowMode}`);
    this.getHost() && this.destroyMainWindow();
  }

  public destroyWindowModePhotoBrowser(): void {
    Log.info(TAG, `start to destory photos application window mode: ${this.windowMode}`);
    this.getHost() && this.destroyWindow();
  }

  public isSplitMode(mode?: WindowMode): boolean {
    mode = mode ?? this.getWinMode();
    return mode === WindowMode.PRIMARY || mode === WindowMode.UNDEFINED;
  }

  public isImmersiveStatus(): boolean {
    Log.info(TAG, `this.isImmersiveEnabled: ${this.isImmersiveEnabled}`);
    return this.isImmersiveEnabled;
  }

  public isFloatMode(): boolean {
    return this.getWinMode() === WindowMode.FLOATING;
  }

  public isFullMode(): boolean {
    return this.getWinMode() === WindowMode.FULLSCREEN;
  }

  public isSplitModeReal(): boolean {
    return false;
    //return this.getMainWindow()?.getWindowStatus() === window.WindowStatusType.SPLIT_SCREEN;
  }

  public isFullModeReal(): boolean {
    // return this.getMainWindow()?.getWindowStatus() === window.WindowStatusType.FULL_SCREEN;
    return false
  }

  // ALT机型的全景模式
  public isFloatingFullMode(): boolean {
    return !DeviceInfo.isPhoneVde() && this.isFloatModeReal() && 
        getScreen().getWindowRectWidth() === getScreen().getDisScreenWidth() && 
        getScreen().getWindowRectHeight() === getScreen().getDisScreenHeight();
  }

  public isFloatModeReal(): boolean {
    // return false;
    return this.getMainWindow()?.getWindowStatus() === window.WindowStatusType.FLOATING;
  }

  public isPrimaryMode(): boolean {
    return this.getWinMode() === WindowMode.PRIMARY;
  }

  public isUndefinedMode(): boolean {
    return this.getWinMode() === WindowMode.UNDEFINED;
  }

  /**
   * 判断屏幕是否处于正常状态（非悬浮，非分屏）
   * 悬浮或分屏时横屏下的屏幕的布局为竖屏布局，布局需要按竖屏逻辑渲染
   *
   * @returns 屏幕是否处于正常状态（非悬浮，非分屏）
   */
  public isNormalMode(): boolean {
    return !this.isSplitMode() && !this.isFloatMode();
  }

  /*
  * 在分屏或悬浮窗模式下，判断大图详情展示模式
  * return: true: 竖屏，false：横屏
   */
  public checkSplitOrFloatMode(): boolean {
    return (this.getWinMode() !== WindowMode.FULLSCREEN && !DeviceInfo.isPcOrTablet()) ||
      (this.getWinMode() === WindowMode.PRIMARY ||
        getScreen().getWinMode() === WindowMode.FLOATING && DeviceInfo.isTablet());
  }

  /**
   * 沉浸式场景，检查沉浸式下是否有dock栏或标题栏
   * 1、宽度不等于屏幕宽度，说明没有全屏或者最大化场景直接返回
   * 2、宽度相等，高度小于屏幕高度说明有dock栏或标题栏
   *
   * @returns boolean
   */
  public isExistDock(): boolean {
    const winWidth: number = this.getWinWidth();
    const winHeight: number = this.getWinHeight();
    try {
      let displayClass: display.Display = display?.getDefaultDisplaySync();
      this.disScreenWidth = displayClass?.width ?? 0;
      this.disScreenHeight = displayClass?.height ?? 0;
    } catch (e) {
      Log.error(TAG, `get displayClass error: code ${e?.code}, msg ${e?.message}`);
      return false;
    }

    const vpWidth: number = this.getCorrectPx2vp(this.disScreenWidth);
    const vpHeight: number = this.getCorrectPx2vp(this.disScreenHeight);
    if (winWidth !== vpWidth) {
      return false;
    }
    return winHeight !== vpHeight && winHeight > vpHeight * SPLIT_RATIO;
  }

  /**
   * 判断是否开启了 ‘窗口最大化或分屏时隐藏快捷栏’ 开关（系统设置 -> 桌面个性化 -> 窗口最大化或分屏时隐藏快捷栏）
   * @returns
   */
  public isDockAutoHideStyleOn(): boolean {
    return settings.getValueSync(global.uiAbilityContext(), 'settings.dock.auto_hide', '0',
      settings.domainName.USER_PROPERTY) === '1';
  }

  /* 获取窗口模式：全屏、悬浮、分屏 */
  public getWinMode(): WindowMode {
    const winWidth = this.getWinWidth();
    const winHeight = this.getWinHeight();
    if (winWidth === 0 && winHeight === 0) {
      return WindowMode.UNDEFINED;
    }
    try {
      let displayClass = this.getDisplayFixedForSmallFold();
      this.disScreenWidth = displayClass?.width ?? 0;
      this.disScreenHeight = displayClass?.height ?? 0;
    } catch (e) {
      Log.error(TAG, `get displayClass error: code ${e?.code}, msg ${e?.message}`);
    }
    const vpWidth = this.getCorrectPx2vp(this.disScreenWidth);
    const vpHeight = this.getCorrectPx2vp(this.disScreenHeight);
    if ((winWidth === vpWidth) && (winHeight === vpHeight) ||
      (winWidth === vpHeight) && (winHeight === vpWidth)) {
      return WindowMode.FULLSCREEN;
    }
    //pad 切换自由多床再取消自由多窗场景
    if (DeviceInfo.isTabletDevice() && (winWidth > vpWidth) && (winHeight > vpHeight)) {
      return WindowMode.FULLSCREEN;
    }
    if (ScreenManager.handleInnerScreenRatio(winWidth, winHeight, this.disScreenWidth, this.disScreenHeight)) {
      return WindowMode.FULLSCREEN;
    }
    if ((winWidth !== vpWidth) && (winHeight !== vpHeight)) {
      return WindowMode.FLOATING;
    }

    /* 1/3 split_screen show phoneux, 1/2 or 2/3 split_screen show tabletux */
    if (winWidth === vpWidth && winHeight !== vpHeight) {
      if (winHeight < vpHeight * SPLIT_RATIO) {
        return WindowMode.FLOATING;
      } else {
        return WindowMode.PRIMARY;
      }
    }

    if (winHeight === vpHeight && winWidth !== vpWidth) {
      if (winWidth < vpWidth * SPLIT_RATIO) {
        return WindowMode.FLOATING;
      } else {
        return WindowMode.PRIMARY;
      }
    }

    return WindowMode.UNDEFINED;
  }

  public getCorrectPx2vp(value: number): number {
    try {
      const disTempValue: number | undefined = global?.UIContext()?.px2vp(value);
      return disTempValue ? disTempValue : px2vp(value);
    } catch (error) {
    }
    return px2vp(value);
  }

  /* 获取只显示大图详情场景 */
  public getDetailShow(): boolean {
    /* phone、pad、xxx悬浮场景下 */
    if (getScreen().getWinMode() === WindowMode.FLOATING && !DeviceInfo.isPc()) {
      return true;
    }
    /* phone、PAD上下分屏场景下 */
    if (getScreen().getWinMode() ===
    WindowMode.PRIMARY && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) {
      return true;
    }
    /* phone左右分屏场景下 */
    if (getScreen().getWinMode() === WindowMode.UNDEFINED && DeviceInfo.isPhoneUx()) {
      return true;
    }
    return false;
  }

  public getWinScale(): number {
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      this.disScreenWidth = displayClass.width;
      if (getScreen().getWinMode() === WindowMode.UNDEFINED && DeviceInfo.isPhoneUx()) {
        return this.getWinWidth() / px2vp(this.disScreenWidth);
      }
    } catch (e) {
      Log.error(TAG, `getWinScale error, code ${e?.code}, stack ${e?.stack}`);
    }
    return Constants.defaultScale;
  }

  public getSplitImageWidth(): number {
    return this.getWinLayoutWidth() - Constants.SPLIT_LIST_CARD_WIDTH - Constants.PHOTO_LIST_CARD_PADDING * 2;
  }

  public async checkWindowMode(): Promise<void> {
    if (this.isFromPickerView()) {
      return;
    }
    let windowMode = this.getWinMode();
    Log.info(TAG, `checkWindowMode done, this.getWinMode(): ${windowMode}`);

    this.emit(ScreenManager.ON_WIN_MODE_CHANGE, [windowMode]);
    AppStorage.setOrCreate<boolean>('isFullMode', windowMode === WindowMode.FULLSCREEN);
    AppStorage.setOrCreate<boolean>('isFloatMode', windowMode === WindowMode.FLOATING);
    AppStorage.setOrCreate<boolean>('isPrimaryMode', windowMode === WindowMode.PRIMARY);
    AppStorage.setOrCreate<boolean>('isUndefinedMode', windowMode === WindowMode.UNDEFINED);
    AppStorage.setOrCreate<number>('winStatusMode', this.windowStatusMode);
    this.emit(ScreenManager.ON_SPLIT_MODE_CHANGED, [this.isSplitMode(windowMode)]);
    this.emit(ScreenManager.ON_WIN_STATUS_MODE_CHANGE, [this.windowStatusMode]);
    this.windowPCmodeSwitchStatus();

    // xxx，从上往下抛滑，抛滑过程触发的进入沉浸式跳过；抛滑结束，触发的收缩dock栏进入沉浸式会进入下方的if判断触发进入沉浸式
    let isPullWinToLowerHalfScreen = AppStorage.get<boolean>('isPullWinToLowerHalfScreen');
    if (DeviceInfo.isPc() && this.isLayoutFullScreen() && this.isDisplayInLowerHalfScreen() &&
      isPullWinToLowerHalfScreen) {
      Log.info(TAG, `Skip repeat ENTER_IMMERSIVE`);
      return;
    }

    if (windowMode === WindowMode.PRIMARY && this.isImmersiveEnabled) {
      Log.info(TAG, 'checkWindowMode ENTER_IMMERSIVE');
      this.getMainWindow().maximize(window.MaximizePresentation.ENTER_IMMERSIVE);
    } else if (windowMode === WindowMode.FULLSCREEN && !this.isImmersiveEnabled) {
      /* instrument ignore next */
      if (DeviceInfo.isPc() && this.isInImmersivePage) {
        Log.info(TAG, 'pc inSlideShowPage checkWindowMode not EXIT_IMMERSIVE');
        return;
      }
      let topWindow: window.Window = this.getMainWindow();
      if (topWindow?.getWindowProperties()?.isLayoutFullScreen) {
        settings.getValue(global.uiAbilityContext(), 'window_pcmode_switch_status', settings.domainName.USER_PROPERTY,)
          .then((value: string) => {
            Log.info(TAG, `checkWindowMode windowPcmodeSwitchStatus: ${value}`);
            let isWindowPcMode = value === 'true';
            if (!isWindowPcMode) {
              this.getMainWindow().maximize(window.MaximizePresentation.EXIT_IMMERSIVE);
              Log.info(TAG, 'checkWindowMode EXIT_IMMERSIVE ');
            }
          });
      }
    } else if (windowMode === WindowMode.FLOATING && this.isImmersiveEnabled && DeviceInfo.isPc()) {
      this.getMainWindow().setWindowTitleButtonVisible(false, false, false);
    }
  }

  /*
 * 判断自由多窗
 * */
  public windowPCmodeSwitchStatus() {
    // 获取是否开启自由多窗 true 开启，false 关闭。
    settings.getValue(global.uiAbilityContext(), 'window_pcmode_switch_status', settings.domainName.USER_PROPERTY,)
      .then((value: string) => {
        Log.info(TAG, `windowPcmodeSwitchStatus: ${value}`);
        AppStorage.setOrCreate<boolean>('windowPcmodeSwitchStatus', value === 'true');
      });
  }

  /**
   * 是否左右布局
   *
   * @returns boolean
   */
  // instrument ignore next
  isLandscapeLayout(): boolean {
    try {
      let winRect: window.Rect | null = this.mainWindow ? this.mainWindow.getWindowProperties()
        .windowRect : this.hostWindow ? this.hostWindow.properties.uiExtensionHostWindowProxyRect : null;
      /* instrument ignore if */
      if (!winRect) {
        Log.info(TAG, 'isLandscapeLayout without window rect');
        return false;
      }
      /* instrument ignore if */
      if (winRect.height === 0) {
        Log.info(TAG, 'the winRect.height value is zero');
        return false;
      }
      if (winRect.width / winRect.height > 0.9) {
        return true;
      }
      return false;
    } catch (err) {
      Log.info(TAG, `check isLandscapeLayout failed! error code : ${err.code}`);
      return false;
    }
  }

  public setMainWindow(): void {
    Log.info(TAG, 'setMainWindow');
    this.getHost()?.on('windowSizeChange', this.onWindowSizeChanged);
    if (!this.isUIExtensionEnv()) {
      this.getMainWindow()?.getProperties().then((prop: window.WindowProperties) => {
        Log.info(TAG, `window prop: ${JSON.stringify(prop)}`);
        this.onWinSizeChanged(prop.windowRect);
      });
    } else {
      this.onWinSizeChanged(this.getWinRect());
    }
  }

  private debounce(func: () => void, delay: number = DRAG_TIME): void {
    if (this.dragTimer !== null) {
      clearTimeout(this.dragTimer);
    }
    this.dragTimer = setTimeout((): void => {
      func();
      this.dragTimer = null;
    }, delay);
  }

  /**
   * 只取消取消进程中所有windowSizeChange
   */
  public destroyMainWindow(): void {
    try {
      this.getHost()?.off('windowSizeChange');
    } catch (error) {
      Log.error(TAG, `destroy window error: ${error}, code: ${error?.code}`);
    }
  }

  /**
   * 只取消该类注册的windowSizeChange
   */
  public destroyWindow(): void {
    try {
      this.getHost()?.off('windowSizeChange', this.onWindowSizeChanged);
    } catch (error) {
      Log.error(TAG, `destroy window error: ${error}, code: ${error?.code}`);
    }
  }

  public calcActualArea(): DiggingHoleCameraArea {
    let rectValue: DiggingHoleCameraArea = {
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
    };
    try {
      if (this.windowAvoidArea === null) {
        return rectValue;
      }
      let topRect: window.Rect = this.windowAvoidArea.topRect;
      let leftRect: window.Rect = this.windowAvoidArea.leftRect;
      let rightRect: window.Rect = this.windowAvoidArea.rightRect;
      let bottomRect: window.Rect = this.windowAvoidArea.bottomRect;
      this.isAvoidHoleIgnoreInTimeline = false;
      if (topRect.left > 0) {
        // 摄像头在上面
        rectValue.top = px2vp(topRect.top) + px2vp(topRect.height);
      } else if (rightRect.left > 0) {
        // 摄像头在右边
        rectValue.right = this.getWinWidth() - px2vp(rightRect.left);
        if (rightRect.top * 2 > this.disScreenHeight || rightRect.height > rightRect.top) {
          this.isAvoidHoleIgnoreInTimeline = true;
        }
      } else if (bottomRect.left > 0) {
        // 摄像头在下面
        rectValue.bottom = this.getWinHeight() - px2vp(bottomRect.top);
      } else if (leftRect.left > 0) {
        // 摄像头在左边
        rectValue.left = px2vp(leftRect.left) + px2vp(leftRect.width);
        if (leftRect.top * 2 > this.disScreenHeight || leftRect.height > leftRect.top) {
          this.isAvoidHoleIgnoreInTimeline = true;
        }
      }
      return rectValue;
    } catch (error) {
      Log.error(TAG, `calcActualArea error: ${error}, code: ${error?.code}`);
      return rectValue;
    }
  }

  public calcDiggingHoleCameraArea(): void {
    if (this.isFromPickerView()) {
      return;
    }
    try {
      if (!this.windowAvoidArea) {
        this.windowAvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
        Log.info(TAG, `get main window initialize windowAvoidArea: ${JSON.stringify(this.windowAvoidArea)}`);
      }
      this.calcHoleCameraAreaCommonLogic();
    } catch (error) {
      Log.error(TAG, `calcDiggingHoleCameraArea error: ${error}, code: ${error?.code}`);
    }
  }

  public calcHoleCameraAreaCommonLogic(): void {
    try {
      // 处理顶部白边问题
      this.setWindowBackgroundColorDefault(true);
      const relativePos = this.calcActualArea();
      // 屏幕旋转会导致宽高发生变化，如果有负数肯定是宽高变化迟缓，需要重新计算
      if (relativePos.left < 0 || relativePos.top < 0 || relativePos.right < 0 || relativePos.bottom < 0) {
        return;
      }
      if (JSON.stringify(this.diggingHoleCameraArea) !== JSON.stringify(relativePos)) {
        this.diggingHoleCameraArea = relativePos;
        // Area data obtained through the system interface,
        // There is a possibility that the area data is incorrect.
        const statusBarHeight: number = this.getWinRect()?.top || 0;
        // Area data obtained through the system interface,
        // There is a possibility that the area data is incorrect.
        let area = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        const naviBarHeight = area?.bottomRect?.height || 0;
        this.setDiggingHoleCameraArea({
          top: this.diggingHoleCameraArea?.top > 0 ? Math.max(px2vp(statusBarHeight),
            this.diggingHoleCameraArea.top) : 0,
          right: this.diggingHoleCameraArea.right,
          bottom: this.diggingHoleCameraArea?.bottom > 0 ? Math.max(px2vp(naviBarHeight),
            this.diggingHoleCameraArea.bottom) : 0,
          left: this.diggingHoleCameraArea.left,
        });
      }
    } catch (error) {
      Log.error(TAG, `calcHoleCameraAreaCommonLogic error: ${error}, code: ${error?.code}`);
    }
  }

  public windowAvoidAreaCallBack(data: WindowAvoidAreaType): void {
    Log.debug(TAG, `windowAvoidAreaCallBack, ${data.type}`);
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      this.disScreenWidth = displayClass.width;
      this.disScreenHeight = displayClass.height;
      // 屏幕宽度发生变更触发通知
      this.emit(ScreenManager.ON_DISPLAY_WIDTH_CHANGED, [displayClass.width]);
      if (this.isUIExtensionEnv()) {
        if (data.type === window.AvoidAreaType.TYPE_CUTOUT) {
          Log.info(TAG, `windowAvoidAreaCallBack: TYPE_CUTOUT${JSON.stringify(data.area)}`);
          this.windowAvoidArea = data.area;
          this.calcDiggingHoleCameraArea();
        } else if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          this.onLeftBlankChanged(data.area, data.type);
          Log.info(TAG, `windowAvoidAreaCallBack: TYPE_SYSTEM${JSON.stringify(data.area)}`);
        }
      } else {
        if (data.type === window.AvoidAreaType.TYPE_CUTOUT) {
          Log.info(TAG, `set windowAvoidArea from avoidAreaChange event: ${JSON.stringify(data.area)}`);
          this.windowAvoidArea = data.area;
          this.calcDiggingHoleCameraArea();
        } else if (data.type === window.AvoidAreaType.TYPE_SYSTEM ||
          data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          this.onLeftBlankChanged(data.area, data.type);
          /* instrument ignore next */
          if (DeviceInfo.isPhoneVde()) {
            this.onStatusHeightChanged(data.area, data.type);
          }

          Log.info(TAG, `windowAvoidAreaCallBack: TYPE_SYSTEM${JSON.stringify(data.area)}`);
        }
      }
    } catch (error) {
      Log.error(TAG, `windowAvoidAreaCallBack error: ${error}, code: ${error?.code}`);
    }
  }

  public registerWindowAvoidArea(): void {
    try {
      this.getHost()?.on('avoidAreaChange', this.windowAvoidAreaCallBackFunc);
    } catch (error) {
      Log.error(TAG, 'registerWindowAvoidArea error: ' + error + `, code: ${error?.code}`);
    }
  }

  public unRegisterWindowAvoidArea(): void {
    try {
      this.getHost()?.off('avoidAreaChange', this.windowAvoidAreaCallBackFunc);
    } catch (error) {
      Log.error(TAG, `destroy window error: ${error}, code: ${error?.code}`);
    }
  }

  public windowStatusChangeCallBack(data: window.WindowStatusType,): void {
    Log.info(TAG, `windowStatusChangeCallBack: WindowStatusType: ${data}`);
    this.windowStatusMode = data;
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Log.info(TAG, 'windowStatusChangeCallBack setSplitScreen Succeeded');
      let isPcShowingEditor = this.storage?.get<boolean>('isPcShowingEditor');
      if (isPcShowingEditor) {
        this.setDecorButtonStyle(true);
      }
      if (data === window.WindowStatusType.FULL_SCREEN) {
        this.appBroadCast.emit(BroadCastConstants.FULL_SCREEN, [false]);
      }
      this.setSplitScreen();
    } else {
      if (data !== window.WindowStatusType.MINIMIZE) {
        Log.info(TAG, 'windowStatusChangeCallBack setFullScreen Succeeded');
        this.setFullScreen();
      }
    }
    try {
      this.windowPCmodeSwitchStatus();
      settings.getValue(global.uiAbilityContext(), 'float_navigation_info', settings.domainName.USER_PROPERTY)
        .then((data: string) => {
        if (data) {
          let navigationInfo = JSON.parse(data) as NavigationButtonInfo;
          AppStorage.setOrCreate<boolean>('floatNavigationButtonOpen', navigationInfo.t10 === 0);
        }
      })
      /* instrument ignore next */
      if (DeviceInfo.isPc() && !this.isUIExtensionEnv()) {
        this.isFullScreen = (data === window.WindowStatusType.FULL_SCREEN);
      }
      AppStorage.setOrCreate('windowStatus', data);
    } catch (error) {
      Log.error(TAG, `windowStatusChangeCallBack error: ${error}, code: ${error?.code}`);
    }
  }

  public getWindowStatus(): void {
    let data: window.WindowStatusType = this.getMainWindow()?.getWindowStatus();
    AppStorage.setOrCreate<number | undefined>('windowStatus', data);
  }

  public isTabletSmallFloating(): boolean {
    return DeviceInfo.isTablet() &&
      AppStorage.get<window.WindowStatusType>('windowStatus') === window.WindowStatusType.FLOATING &&
      !AppStorage.get<boolean>('windowPcmodeSwitchStatus') && this.isFloatingSmallSize();
  }

  public isGRLSplit(): boolean {
    let foldStatus = FoldUtil.getInstance().getCurFoldStatus();
    return FoldUtil.isTriExpand(foldStatus) &&
      AppStorage.get<window.WindowStatusType>('windowStatus') === window.WindowStatusType.SPLIT_SCREEN;
  }

  private isFloatingSmallSize(): boolean {
    return getScreen().getWinWidth() < getScreen().getWinHeight();
  }

  public registerWindowStatusChange(): void {
    try {
      this.getMainWindow().on('windowStatusChange', this.windowStatusChangeCallBackFunc);
    } catch (error) {
      Log.error(TAG, 'registerWindowStatusChange error: ' + error + `, code: ${error?.code}`);
    }
  }

  public unRegisterWindowStatusChange(): void {
    try {
      this.getMainWindow().off('windowStatusChange', this.windowStatusChangeCallBackFunc);
    } catch (error) {
      Log.error(TAG, `destroy window status error: ${error}, code: ${error?.code}`);
    }
  }

  public getAvoidArea(): void {
    let area: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    Log.info(TAG, `getAvoidArea: statusBarArea: ${JSON.stringify(area)}`);
    AppStorage.setOrCreate<number>('statusBarHeight', area?.topRect?.height);
    this.onLeftBlankChanged(area, window.AvoidAreaType.TYPE_SYSTEM);
    let navArea: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    Log.info(TAG, `getAvoidArea: navArea: ${JSON.stringify(navArea)}`);
    AppStorage.setOrCreate<number>('navigationBarHeight', navArea?.bottomRect?.height);
    this.onLeftBlankChanged(navArea, window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    this.windowAvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
    this.calcDiggingHoleCameraArea();
  }

  public setFullScreen(): void {
    Log.info(TAG, 'setFullScreen start');
    if (this.isUIExtensionEnv() || DeviceInfo.isPc()) {
      return;
    }
    let topWindow: window.Window = this.getMainWindow();
    Log.info(TAG, 'getTopWindow start setWindowLayoutFullScreen');
    try {
      let fullScreenLayoutLocal: boolean = true;
      topWindow?.setWindowLayoutFullScreen(fullScreenLayoutLocal, () => {
        Log.info(TAG, `setFullScreen ${fullScreenLayoutLocal} Succeeded`);
        let isLightColorMode: boolean =
          AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
        this.setWindowBackgroundColorDefault(isLightColorMode);
      });
    } catch (err) {
      Log.error(TAG, `setFullScreen err: ${err}, code: ${err?.code}`);
    }
  }

  public getIsFullScreen(): boolean {
    return this.isFullScreen;
  }

  public isSplitOrFloating(): boolean {
    let windowStatus  = AppStorage.get<window.WindowStatusType>('windowStatus');
    return windowStatus === window.WindowStatusType.SPLIT_SCREEN ||
      windowStatus === window.WindowStatusType.FLOATING;
  }

  public isFromPickerInPhotos(): boolean | undefined {
    return this.storage?.get<boolean>(Constants.PHOTO_PICKER_FROM_PHOTOS);
  }

  //状态栏背景色
  public setWindowBackgroundColorDefault(defaultColor: boolean): void {
    if (this.isUIExtensionEnv() || this.isFromPickerInPhotos()) {
      return;
    }
    try {
      let uiContext: common.UIAbilityContext | undefined = undefined;
      if (PhotoConfig.isLibrary()) {
        uiContext = global?.browserUiAbilityContext();
      } else {
        uiContext = global?.uiAbilityContext();
      }
      if (!uiContext || !uiContext.windowStage) {
        Log.error(TAG, `uiContext is error. isLibrary: ${PhotoConfig.isLibrary()}`);
        return;
      }
      if (AppStorage.get<window.WindowStatusType>('windowStatus') !== window.WindowStatusType.FLOATING) {
        this.getMainWindow().setWindowBackgroundColor(defaultColor ? '#F1F3F5' : '#000000');
      }
    } catch (error) {
      Log.error(TAG, 'setWindowBackgroundColorDefault: failed, error info is ' + error + `, code: ${error?.code}`);
    }
  }

  public setSplitScreen(): void {
    try {
      this.statusBarHeight = 0;
      this.notifyStatusBarHeightChanged();
      this.naviBarHeight = 0;
      this.leftBlank = [0, 0, 0, 0];
      this.emit(ScreenManager.ON_LEFT_BLANK_CHANGED, [this.leftBlank]);
    } catch (err) {
      Log.error(TAG, `setSplitScreen err: ${err}, code: ${err?.code}`);
    }
  }

  public async setDefaultStatusBarProperties(isImmersionStyle?: boolean): Promise<void> {
    let isEditorShow = this.storage?.get<boolean>('isEditorShown');
    if (this.isUIExtensionEnv() || isEditorShow) {
      return;
    }
    Log.debug(TAG, `setDefaultStatusBarProperties() setStatusBarColor start, isImmersionStyle: ${isImmersionStyle}`);
    let isDarkColorMode: boolean =
      AppStorage.get('currentColorMode') === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    let topWindow: window.Window = this.getMainWindow();
    let statusBarColor: string;
    let statusBarContentColor: string;
    //固定场景-直板机/F态,横屏为下拉灰色背景,白色文字,其他场景按默认判断
    if (isOrientationHorizontal() && !DeviceInfo.isFoldable() && DeviceInfo.isPhoneUx()) {
      statusBarColor = Constants.IMMERSIVE_BAR_BACKGROUND_COLOR_30;
      statusBarContentColor = Constants.RULER_FILL_STYLE_100;
    } else {
      statusBarColor = isImmersionStyle ? Constants.IMMERSIVE_BAR_BACKGROUND_COLOR_30 :
        Constants.IMMERSIVE_BAR_BACKGROUND_COLOR_TRANSPARENT;
      statusBarContentColor = isImmersionStyle || isDarkColorMode ?
        Constants.IMMERSIVE_BAR_CONTENT_COLOR : Constants.STATUS_BAR_CONTENT_COLOR;
    }
    try {
      topWindow?.setWindowSystemBarProperties(
        {
          statusBarColor: statusBarColor,
          statusBarContentColor: statusBarContentColor,
        }, (): void => {
        Log.info(TAG, `setDefaultStatusBarProperties() setStatusBarColor done, content color is ${statusBarContentColor}`);
      });
    } catch (err) {
      Log.error(TAG, `setDefaultStatusBarProperties() setStatusBarColor err: ${err}, code: ${err?.code}`);
    }
  }

  /**
   * hopper，获取窗口的displayId
   */
  public getScreenDisplayId(): number | undefined {
    try {
      let properties: window.WindowProperties = this.getMainWindow()?.getWindowProperties();
      return properties?.displayId;
    } catch (exception) {
      Log.error(TAG, `Failed to obtain the area. error msg: ${exception?.msg}, code: ${exception?.code}`);
    }
    return -1;
  }

  /**
   * hopper，获取窗口是否在xxx的下半屏，displayId为999表示在下半屏
   */
  public isDisplayInLowerHalfScreen(): boolean {
    return this.getScreenDisplayId() === LOWER_HALF_SCREEN;
  }

  /**
   * pc, 窗口是否为沉浸式且处于全屏模式（不在悬浮窗、分屏等场景下），默认为false。true表示沉浸式且处于全屏模式；false表示非沉浸式或非全屏模式。
   */
  public isLayoutFullScreen(): boolean {
    try {
      let result: boolean = this.getMainWindow()?.getImmersiveModeEnabledState();
      return result;
    } catch (exception) {
      Log.error(TAG,
        `Failed to obtain the getImmersiveModeEnabledState. error msg: ${exception?.msg}, code: ${exception?.code}`);
    }
    return false;
  }

  /**
   * pc, 获取窗口的模式。
   */
  public getWindowStatusType(): WindowStatusType {
    try {
      return this.getMainWindow()?.getWindowStatus();
    } catch (exception) {
      Log.error(TAG, `Failed to obtain the getWindowStatus. error msg: ${exception?.msg}, code: ${exception?.code}`);
    }
    return window.WindowStatusType.UNDEFINED;
  }

  private handleEnterImmersive(topWindow: window.Window, type: window.WindowStatusType): void {
    switch (type) {
      case window.WindowStatusType.FULL_SCREEN:
      case window.WindowStatusType.MAXIMIZE:
        topWindow.maximize(window.MaximizePresentation.ENTER_IMMERSIVE);
        this.isImmersiveEnabled = true;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', true);
        Log.info(TAG, `enter maximize`);
        break;
      case window.WindowStatusType.FLOATING:
        topWindow.setWindowTitleButtonVisible(false, false, false);
        this.isImmersiveEnabled = true;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', true);
        break;
      case window.WindowStatusType.SPLIT_SCREEN:
        topWindow.setWindowTitleButtonVisible(false, false, false);
        this.isImmersiveEnabled = true;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', true);
        break;
    }
  }

  private handleEnterImmersiveFromCamara(topWindow: window.Window, type: window.WindowStatusType): void {
    switch (type) {
      case window.WindowStatusType.MAXIMIZE:
        topWindow.maximize(window.MaximizePresentation.ENTER_IMMERSIVE);
        this.isImmersiveEnabled = true;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', true);
        break;
      case window.WindowStatusType.FLOATING:
        topWindow.setWindowTitleButtonVisible(false, false, false);
        break;
      case window.WindowStatusType.SPLIT_SCREEN:
        topWindow.setWindowTitleButtonVisible(false, false, false);
        break;
    }
  }

  private handleExitImmersive(topWindow: window.Window, type: window.WindowStatusType): void {
    switch (type) {
      case window.WindowStatusType.FULL_SCREEN:
      case window.WindowStatusType.MAXIMIZE:
        /* instrument ignore next */
        if (DeviceInfo.isPcHalfFoldState()) {
          topWindow.setWindowTitleButtonVisible(true, true, true);
          if (this.isImmersiveEnabled) {
            topWindow.maximize(window.MaximizePresentation.EXIT_IMMERSIVE);
            this.isImmersiveEnabled = false;
            LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', false);
          }
        } else {
          topWindow.maximize(window.MaximizePresentation.EXIT_IMMERSIVE);
          this.isImmersiveEnabled = false;
          topWindow.setWindowTitleButtonVisible(true, true, true);
          LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', false);
        }
        break;
      case window.WindowStatusType.FLOATING:
        topWindow.setWindowTitleButtonVisible(true, true, true);
        this.isImmersiveEnabled = false;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', false);
        break;
      case window.WindowStatusType.SPLIT_SCREEN:
        topWindow.setWindowTitleButtonVisible(true, true, true);
        this.isImmersiveEnabled = false;
        LocalStorage.getShared()?.setOrCreate<boolean>('isImmersiveEnabled', false);
        break;
    }
  }

  public setImmersiveModeEnabledStateLocal(isEnable: boolean, isFromCamara?: boolean): void {
    /* instrument ignore next */
    if (DeviceInfo.isPc() && !this.isUIExtensionEnv()) {
      let topWindow: window.Window = this.getMainWindow();
      try {
        let type: window.WindowStatusType = topWindow.getWindowStatus();
        Log.info(TAG,
          `setImmersiveModeEnabledStateLocal, isEnable ${isEnable}, isPcHalfFoldState: ${DeviceInfo.isPcHalfFoldState()}, type: ${type}`);
        if (isEnable) {
          if (isFromCamara) {
            this.handleEnterImmersiveFromCamara(topWindow, type);
          } else {
            this.handleEnterImmersive(topWindow, type);
          }
        } else {
          this.handleExitImmersive(topWindow, type);
        }
      } catch (err) {
        Log.error(TAG, `setImmersiveModeEnabledStateLocal err: ${err}, code: ${err?.code}`);
      }
    }
  }

  public async setImmersiveStatusBarProperties(color: string = IMMERSIVE_BAR_BACKGROUND_COLOR): Promise<void> {
    if (this.isUIExtensionEnv()) {
      return;
    }
    Log.debug(TAG, 'setImmersiveStatusBarProperties() setStatusBarColor start');
    let topWindow: window.Window = this.getMainWindow();
    try {
      topWindow?.setWindowSystemBarProperties(
        {
          statusBarColor: color,
          statusBarContentColor: Constants.IMMERSIVE_BAR_CONTENT_COLOR,
        }, (): void => {
        Log.info(TAG, 'setImmersiveStatusBarProperties() setStatusBarColor done');
      });
    } catch (err) {
      Log.error(TAG, `setImmersiveStatusBarProperties() setStatusBarColor err: ${err}, code: ${err?.code}`);
    }
  }

  public setDecorButtonStyle(isDarkStyle: boolean): void {
    if (this.isUIExtensionEnv()) {
      return;
    }
    let isPcShowingEditor = this.storage?.get<boolean>('isPcShowingEditor');
    let topWindow: window.Window = this.getMainWindow();
    let style: window.DecorButtonStyle;
    if (this.isImmersiveEnabled && isPcShowingEditor && this.isFullScreen) {
      style = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT,
      };
    } else if (isDarkStyle) {
      style = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK,
      };
    } else {
      style = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET,
      };
    }
    if (isPcShowingEditor) {
      topWindow?.setWindowTitleButtonVisible(true, true, true);
    } else if (!this.isFullScreen && this.isImmersiveEnabled) {
      topWindow?.setWindowTitleButtonVisible(false, false, false);
    }
    try {
      topWindow.setDecorButtonStyle(style);
    } catch (err) {
      Log.error(TAG, `setDecorButtonStyle err: ${err}, code: ${err?.code}`);
    }
  }

  // 设置是否在播放幻灯片页面
  public setIsInImmersivePage(isShow: boolean): void {
    this.isInImmersivePage = isShow;
  }

  public setSystemUi(isShowBar: boolean, isShowNavigation: boolean = isShowBar, isImmersionStyle: boolean = false,
    updateStatus: boolean = true, isUpdateProperties: boolean = true): void {
    let isEditorShow = this.storage?.get<boolean>('isEditorShown');
    let isThreeKeyNavigation: boolean = false;
    if (this.isUIExtensionEnv() || !updateStatus) {
      return;
    }
    if (this.isInImmersivePage) {
      // 播放幻灯片页面，横竖屏旋转，不控制状态栏显隐
      Log.warn(TAG, 'InSlideShowPage');
      return;
    }
    if (isEditorShow) {
      // 编辑界面修改状态栏显隐，需要将isShowBar值同步过来，防止编辑返回大图后，状态栏不恢复
      this.isShowStatusBefore = isShowBar;
      return;
    }
    Log.debug(TAG, `setSystemUi start, isShowBar=${isShowBar}, isPc=${DeviceInfo.isPc()}`);
    if (isShowBar === this.isShowStatusBefore && isShowNavigation === this.isShowNavigationBefore &&
      isImmersionStyle === this.isImmersionStyleBefore) {
      return;
    }
    this.isShowStatusBefore = isShowBar;
    this.isShowNavigationBefore = isShowNavigation;
    this.isImmersionStyleBefore = isImmersionStyle;
    let topWindow: window.Window = this.getMainWindow();
    Log.debug(TAG, 'getTopWindow start');
    let names: specificSystemBarKeys[] = [];
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      names.push('status', 'navigationIndicator');
    } else {
      if (isShowBar) {
        names.push('status');
      }
      if (isShowNavigation) {
        names.push('navigationIndicator');
      }
    }
    Log.info(TAG, `getTopWindow names: ${names} end`);
    if (isUpdateProperties && DeviceInfo.isPc()) {
      this.setDefaultStatusBarProperties(!isShowBar);
    }

    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      // 大图隐藏工具栏时同步窗口沉浸式，否则 isLayoutFullScreen/LocalStorage 不更新，PC 动效与顶栏状态异常
      if (!isShowBar && isImmersionStyle) {
        this.setImmersiveModeEnabledStateLocal(true);
      } else if (isShowBar) {
        this.setImmersiveModeEnabledStateLocal(false);
      }
      return;
    }
    this.setSpecificSystemUi('status', names.includes('status'), isUpdateProperties);
    this.setSpecificSystemUi('navigationIndicator', names.includes('navigationIndicator'), isUpdateProperties);
    Log.info(TAG, `screenmanager setsystemui isImmersionStyle: ${isImmersionStyle}, ${names}`);
    if (this.timer && !isImmersionStyle) {
      Log.info(TAG, `clear timer ${this.timer}`);
      clearTimeout(this.timer);
    }
    if (!DeviceInfo.isPc()) {
      let uiContext: common.UIAbilityContext | undefined = undefined;
      if (PhotoConfig.isLibrary()) {
        uiContext = global?.browserUiAbilityContext();
      } else {
        uiContext = global?.uiAbilityContext();
      }
      if (!uiContext || !uiContext.windowStage) {
        Log.error(TAG, 'uiContext is error. isLibrary: ' + PhotoConfig.isLibrary());
      } else {
        const flag: string = settings.getValueSync(
          uiContext, 'floatingNavigation', '1', settings.domainName.USER_PROPERTY
        );
        Log.info(TAG, `floatingNavigation flag: ${flag}`);
        isThreeKeyNavigation = flag === NavigationStyle.THREE_KEY;
      }
    }
    if (isThreeKeyNavigation) {
      this.setSpecificSystemUi('navigation', isShowNavigation, isUpdateProperties);
    }
    if (isImmersionStyle) {
      if (isThreeKeyNavigation) {
        return;
      }
      this.timer = setTimeout((): void => {
        this.setSpecificSystemUi('navigationIndicator', false, isUpdateProperties);
        this.isShowNavigationBefore = false;
        this.timer = null;
      }, NAVIGATION_INDICATOR_HIDDEN_TIME);
      Log.info(TAG, `set timer ${this.timer}`);
    }
  }

  /* instrument ignore next */
  public showNavigationIndicator() {
    if (this.timer) {
      Log.info(TAG, `clear timer ${this.timer}`);
      clearTimeout(this.timer);
    }
    this.setSpecificSystemUi('navigationIndicator', true, true);
  }

  /* instrument ignore next */
  public setHideNavigationIndicatorTimer(isShowBar: boolean = true) {
    if (isShowBar) {
      return;
    }
    this.timer = setTimeout((): void => {
      this.setSpecificSystemUi('navigationIndicator', false, true);
      this.isShowNavigationBefore = false;
      this.timer = null;
    }, NAVIGATION_INDICATOR_HIDDEN_TIME);
    Log.info(TAG, `set timer ${this.timer}`);
  }

  /**
   * 状态栏恢复到直板机横/竖屏
   */
  public recoverHorizontalStatusBar(isHorizontal: boolean) {
    if (this.isInImmersivePage) {
      Log.debug(TAG, `isInImmersivePage:${this.isInImmersivePage}`)
      return;
    }
    this.setSpecificSystemUi('status', !isHorizontal, true);
  }

  /**
   * 状态栏恢复到默认状态
   */
  public recoverDefaultStatusBar() {
    if (this.statusBarHeight === 0 && !this.isHorizontal()) {
      this.setSpecificSystemUi('status', true, true);
    }
    // 跳转到宫格页，存在其它地方把状态栏设置为不显示，需要恢复下
    setTimeout(() => {
      this.setSpecificSystemUi('status', (!this.isHorizontal() || DeviceInfo.isTabletDevice()), true);
    }, RESET_STATUS_BAR_DELAY);

  }

  private setSpecificSystemUi(name: window.SpecificSystemBar, isShow: boolean, isUpdateProperties: boolean): void {
    let topWindow: window.Window = this.getMainWindow();
    try {
      topWindow?.setSpecificSystemBarEnabled(name, isShow).then(() => {
        if (name === 'status' && isUpdateProperties) {
          this.setDefaultStatusBarProperties(!isShow);
        }
        Log.info(TAG, `Succeeded in setting the system bar to be invisible. name:${name}, isShow:${isShow}`);
      }).catch((err: BusinessError) => {
        Log.error(TAG, `Failed to set the system bar to be invisible. Cause code: ${
        err.code}, message: ${err.message}`);
      });
    } catch (exception) {
      Log.error(TAG, `Failed to set the system bar to be invisible. Cause code: ${
      exception.code}, message: ${exception.message}`);
    }
  }

  public isSidebar(): boolean {
    return this.hasSidebar;
  }

  public getDiggingHoleCameraArea(): DiggingHoleCameraArea {
    return this.diggingHoleCameraArea;
  }

  public setDiggingHoleCameraArea(diggingHoleCameraArea: DiggingHoleCameraArea): void {
    this.diggingHoleCameraArea = diggingHoleCameraArea;
    AppStorage.setOrCreate(Constants.CAMERA_RELATIVE_POSITION_CHANGED, this.diggingHoleCameraArea);
    this.broadcast.emit(ScreenManager.ON_DIGGING_HOLE_CHANGED, [this.diggingHoleCameraArea]);
  }

  public getColumnsWidth(count: number): number {
    const columnWidth: number = (this.winWidth - this.columnMargin - this.columnGutter) / this.columns;
    const columnsWidth = Math.round(columnWidth * count - this.columnGutter);
    Log.debug(TAG, `getColumnsWidth${columnsWidth
    } count : ${count}, colunms : ${this.columns}, columnGutter : ${this.columnGutter}`);
    return columnsWidth;
  }

  // 宫格长按预览图计算栅格
  public getPreviewColumnsWidth(count: number): number {
    Log.info(TAG, `getPreviewColumnsWidth count : ${count}, previewColumns : ${this.previewColumns}`);
    let columnWidth: number = (this.previewWidth - this.previewColumnMargin - this.previewColumnGutter) /
    this.previewColumns;
    return columnWidth * count - this.previewColumnGutter;
  }

  // 相册页 按预览图计算栅格
  getAlbumPreviewColumnsWidth(count: number): number {
    let columnMargin: number = 0.0;
    let columnGutter: number = 0.0;
    let columnWidth: number = 0.0;
    // 根据新UX的规格调整 columnMargin columnGutter 适配,分别为 columns 4,8,12
    if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
      columnMargin = Constants.COLUMN_MARGIN_FOUR * 2;
      columnGutter = Constants.COLUMN_GUTTER_FOUR * 2;
    } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
      columnMargin = Constants.COLUMN_MARGIN_SIX * 2;
      columnGutter = Constants.COLUMN_GUTTER_EIGHT;
    } else {
      columnMargin = Constants.COLUMN_MARGIN_EIGHT * 2;
      columnGutter = Constants.COLUMN_GUTTER_EIGHT;
    }
    columnWidth = (this.winWidth - columnMargin + columnGutter) / this.columns;
    Log.info(TAG, `columnWidth:${
    columnWidth}, result:${columnWidth * count + columnGutter} this.columns ${this.columns}`);
    return columnWidth * count + columnGutter;
  }

  // 时刻页 按预览图计算栅格
  getHighlightPreviewColumnsWidth(count: number): number {
    let columnMargin: number = 0.0;
    let columnGutter: number = 0.0;
    let columnWidth: number = 0.0;
    // 根据新UX的规格调整 columnMargin columnGutter 适配,分别为 columns 4,8,12
    if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
      columnMargin = Constants.COLUMN_MARGIN_FOUR * 2;
      columnGutter = Constants.COLUMN_GUTTER_FOUR * 2;
    } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
      columnMargin = Constants.COLUMN_MARGIN_SIX * 2;
      columnGutter = Constants.COLUMN_GUTTER_EIGHT;
    } else {
      columnMargin = Constants.COLUMN_MARGIN_EIGHT * 2;
      columnGutter = Constants.COLUMN_GUTTER_EIGHT;
    }
    columnWidth = (this.winWidth - columnMargin + columnGutter) / this.columns;
    Log.info(TAG, `Highlight preview columnWidth:${
    columnWidth}, result:${columnWidth * count + columnGutter} this.columns ${this.columns}`);
    let result = columnWidth * count + columnGutter;
    let winLayoutHeight = this.getWinLayoutHeight();
    if (result > winLayoutHeight * SPLIT_HEIGHT_MULTIPLE) {
      result = winLayoutHeight * SPLIT_HEIGHT_CALCULATE_MULTIPLE;
    }
    return result;
  }

  getColumnsWidthToolBar(count: number, isSideBar: boolean): number {
    Log.debug(TAG, `getColumnsWidth count : ${count}, colunms : ${this.columns}`);
    let columnWidth: number = 0.0;
    /* instrument ignore next */
    if (DeviceInfo.isTablet() && isSideBar && getScreen().getWinMode() !== WindowMode.FLOATING) {
      columnWidth =
        (this.winWidth - sideBarWidth - COLUMN_MARGIN_TOOLBAR * 2 - COLUMN_GUTTER_TOOLBAR * (this.columns - 1)) /
        this.columns;
    } else {
      columnWidth =
        (this.winWidth - COLUMN_MARGIN_TOOLBAR * 2 - COLUMN_GUTTER_TOOLBAR * (this.columns - 1)) / this.columns;
    }
    return parseInt(((columnWidth + COLUMN_GUTTER_TOOLBAR) * (count - 1) + columnWidth).toString());
  }

  public getMarginToolBar(): number {
    let marginToolBar: number;
    marginToolBar = ((this.winWidth - COLUMN_MARGIN_TOOLBAR * 2) / ToolBar_MAX_LENGTH - COLUMN_GUTTER_TOOLBAR) / 2 +
      COLUMN_GUTTER_TOOLBAR - (TABLE_HOT_ZONE - ToolBar_ICON_SIZE) / 2;
    return marginToolBar;
  }

  getColumnsWidthToolBarByColumns(count: number, columns: number, isSideBar: boolean): number {
    Log.debug(TAG, `getColumnsWidth count : ${count}, colunms : ${columns}`);
    let columnWidth: number = 0.0;
    /* instrument ignore next */
    if (DeviceInfo.isTablet() && isSideBar) {
      columnWidth =
        (this.winWidth - sideBarWidth - COLUMN_MARGIN_TOOLBAR * 2 - COLUMN_GUTTER_TOOLBAR * (columns - 1)) / columns;
    } else {
      columnWidth = (this.winWidth - COLUMN_MARGIN_TOOLBAR * 2 - COLUMN_GUTTER_TOOLBAR * (columns - 1)) / columns;
    }
    return parseInt(((columnWidth + COLUMN_GUTTER_TOOLBAR) * (count - 1) + columnWidth).toString());
  }

  public getScreenColumns(): number {
    return this.columns;
  }

  public getSafePadding(): [number, number, number, number] {
    return this.safePadding;
  }

  public getLeftSafePadding(resource: Resource, isPadding: boolean): number {
    let vpValue: number = px2vp(UiUtil.getResourceNumber(resource));
    Log.info(TAG, `getMaxResourceValue vpValue : ${vpValue}`);
    if (isPadding) {
      return this.safePadding[0] > 0 ? 0 : vpValue;
    } else {
      return this.safePadding[0] > 0 ? Math.max(vpValue, px2vp(this.safePadding[0])) : 0;
    }
  }

  public getRightSafePadding(resource: Resource, isPadding: boolean): number {
    let vpValue: number = px2vp(UiUtil.getResourceNumber(resource));
    Log.debug(TAG, `getMaxResourceValue vpValue : ${vpValue}`);
    if (isPadding) {
      return this.safePadding[2] > 0 ? 0 : vpValue;
    } else {
      return this.safePadding[0] > 0 ? Math.max(vpValue, px2vp(this.safePadding[2])) : 0;
    }
  }

  public setForceVertical(forceVertical: boolean): void {
    Log.info(TAG, `setForceVertical ${forceVertical}`);
    this.isForceVertical = forceVertical;
  }

  public onRotationAngleChanged(isH: boolean): void {
    Log.info(TAG, `onRotationAngleChanged isHorizontal: ${isH}`);
    if (isH === null || isH === undefined || isOrientationHorizontal() === isH || this.isForceVertical) {
      return;
    }
    setHorizontal(isH);
    this.updatePreviewWidth();
  }

  getMainWindow(): window.Window {
    this.mainWindow = this.storage?.get<window.Window>('mainWindow') as window.Window;
    if (this.mainWindow === undefined) {
      Log.warn(TAG, `getMainWindow failed reason: ${this.storage} ${this.mainWindow}`);
    }
    return this.mainWindow;
  }

  private getProxy(): uiExtensionHost.UIExtensionHostWindowProxy {
    return this.storage?.get<uiExtensionHost.UIExtensionHostWindowProxy>(
      Constants.PHOTO_PICKER_EXTENSION_WINDOW) as uiExtensionHost.UIExtensionHostWindowProxy;
  }

  private setSafePadding(): void {
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      displayClass.getCutoutInfo().then((cutoutInfo: display.CutoutInfo) => {
        Log.info(TAG, `Succeeded in getting cutoutInfo. Data: ${JSON.stringify(cutoutInfo)}`);
        let waterfallDisplayAreaRect: display.WaterfallDisplayAreaRects = cutoutInfo.waterfallDisplayAreaRects;
        let left: display.Rect = waterfallDisplayAreaRect.left;
        let top: display.Rect = waterfallDisplayAreaRect.top;
        let right: display.Rect = waterfallDisplayAreaRect.right;
        let bottom: display.Rect = waterfallDisplayAreaRect.bottom;
        this.safePadding = [left.width, top.height, right.width, bottom.height];
        Log.info(TAG, `Succeeded in getting cutoutInfo. Data: ${JSON.stringify(this.safePadding)}`);
      }).catch((err: BusinessError): void => {
        Log.info(TAG, 'Failed to obtain all the display objects. Code: ' + err + `, code: ${err?.code}`);
      });
    } catch (exception) {
      Log.info(TAG, `Failed to obtain the default display object. Code: ${JSON.stringify(exception)}`);
    }
  }

  private emit(event: string, argument: Object[]): void {
    this.broadcast.emit(event, argument);
  }

  private isLeftBlankInitialized(): boolean {
    return this.leftBlank[0] !== 0 || this.leftBlank[1] !== 0 || this.leftBlank[2] !== 0 || this.leftBlank[3] !== 0;
  }

  private onStatusHeightChanged(area: window.AvoidArea, avoidAreaType?: window.AvoidAreaType): void {
    Log.info(TAG, 'onStatusHeightChanged: avoidAreaType: ' + avoidAreaType + ` area${JSON.stringify(area)}`);
    if (area === null || area === undefined || (area.bottomRect.height === 0 && area.topRect.height === 0)) {
      return;
    }
    if (avoidAreaType !== window.AvoidAreaType.TYPE_SYSTEM) {
      return;
    }
    let topHeight: number | undefined = area?.topRect?.height;
    if (!Number.isFinite(topHeight)) {
      return;
    }
    AppStorage.setOrCreate<number>('statusBarHeight', topHeight);
    Log.info(TAG, `statusBarHeight changed: ${topHeight}`);
  }

  private onLeftBlankChanged(area: window.AvoidArea, avoidAreaType?: window.AvoidAreaType): void {
    if (avoidAreaType && avoidAreaType === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate<number>('navigationBarBottomHeight', area?.bottomRect?.height);
    }
    Log.info(TAG, 'onLeftBlankChanged: avoidAreaType: ' + avoidAreaType + ` area${JSON.stringify(area)}`);
    if (area === null || area === undefined ||
      (area.bottomRect.height === 0 && area.topRect.height === 0 && this.naviBarHeight === 0)) {
      return;
    }

    interface LeftBlankBefore {
      status?: number;
      navi?: number;
    }

    let leftBlankBefore: LeftBlankBefore = {
      status: this.statusBarHeight,
      navi: this.naviBarHeight,
    };
    // Area data obtained through the system interface,
    // There is a possibility that the area data is incorrect.
    if (avoidAreaType && avoidAreaType === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      AppStorage.setOrCreate<number>('navigationBarHeight', area?.bottomRect?.height);
      return;
    } else if (Number.isFinite(avoidAreaType) && avoidAreaType === window.AvoidAreaType.TYPE_SYSTEM) {
      AppStorage.setOrCreate<number>('statusBarHeight', area?.topRect?.height);
      Log.info(TAG, `statusBarHeight Value:${area?.topRect?.height}`);
    }
    this.statusBarHeight = DeviceInfo.isSmallFoldExpanded()
      ? area.topRect.height / ScreenManager.INNER_SCREEN_RATIO
      : DeviceInfo.isVerdeFoldable() ? 0 : px2vp(area.topRect.height);
    this.naviBarHeight = DeviceInfo.isSmallFoldExpanded()
      ? area.bottomRect.height / ScreenManager.INNER_SCREEN_RATIO
      : DeviceInfo.isVerdeFoldable() ? 0 : px2vp(area.bottomRect.height);
    this.notifyStatusBarHeightChanged();
    this.emit(ScreenManager.ON_AREA_HEIGHT_CHANGED, [area.topRect.height]);
    this.leftBlank = [this.leftBlank[0], this.leftBlank[1], this.leftBlank[2], this.naviBarHeight];
    if (leftBlankBefore.status !== this.statusBarHeight || leftBlankBefore.navi !== this.naviBarHeight) {
      Log.info(TAG, `leftBlank changed: ${JSON.stringify(leftBlankBefore)}-${JSON.stringify(this.leftBlank)}`);
      this.emit(ScreenManager.ON_LEFT_BLANK_CHANGED, [this.leftBlank]);
      this.calcDiggingHoleCameraArea();
    }
  }

  private onWinSizeChanged(size: window.Size | window.Rect): void {
    let breakPoint: number = Math.ceil(vp2px(sideBarWidthBreakPoint));
    Log.info(TAG, `onWinSizeChanged width:${size.width}, height:${size.height}, windoeMode:${this.windowMode},
      isHorizontal:${isOrientationHorizontal()}, sideBarWidthBreakPoint:${breakPoint}`);
    if (!size) {
      return;
    }
    AppStorage.setOrCreate<boolean>('isWinSizeChanging', true);
    let differWidth: number = size.width - this.originalWinWidth;
    let isEditorShow = this.storage?.get<boolean>('isEditorShown');
    /* instrument ignore next */
    if (DeviceInfo.isPc() && ((differWidth !== 0 && !this.isImmersiveEnabled) || isEditorShow)) {
      this.appBroadCast.emit(BroadCastConstants.SIDEBAR_CHANGE_BREAKPOINT, [size.width > breakPoint]);
      this.isInBreakPoint = size.width > breakPoint;
    }
    this.originalWinWidth = size.width;
    this.updateWinSizeInner(size);
    this.checkWindowMode();
    this.updateFoldDisplayMode();
    // 外屏长宽相等，默认恒为竖屏
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      setHorizontal(false);
    }
    AppStorage.setOrCreate<boolean>('isWinSizeChanging', false);
  }

  public updateFoldDisplayMode(): void {
    try {
      let foldStatus = display.getFoldDisplayMode();
      AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, foldStatus);
      Log.info(TAG, `updateFoldDisplayMode: ${foldStatus}`);
    } catch (e) {
      Log.error(TAG, 'getFoldDisplayMode fail');
    }
  }

  public getAiBarHeight(): number {
    let area: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    return px2vp(area?.bottomRect.height);
  }

  public getIsInBreakPoint(): boolean {
    return this.isInBreakPoint;
  }

  // 获取AIbar宽度
  public getAiBarWidth(): number {
    let area: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    return px2vp(area?.bottomRect.width);
  }

  // 更新宫格长按预览，栅格相关的中间变量
  private updatePreviewWidth(): void {
    // xxxxxx获取xxx宽度
    let data: display.FoldCreaseRegion = display.getCurrentFoldCreaseRegion();
    let rectArea = data?.creaseRects[0] || {
      width: 0,
      left: 0,
      top: 0,
      height: 0,
    };
    let foldWidth = (rectArea.width / 2) - rectArea.height + Constants.FOLD_CREASE_REGION_DIFF_SIZE;
    /* instrument ignore next */
    if (DeviceInfo.isTablet()) {
      this.previewWidth = this.isHorizontal() ? this.winWidth : this.winHeight;
    } else if (DeviceInfo.isFoldable() && !DeviceInfo.isVerdeFoldable()) {
      this.previewWidth = px2vp(foldWidth);
    } else {
      this.previewWidth = this.isHorizontal() ? this.winHeight : this.winWidth;
    }
    if (this.previewWidth < ScreenWidth.WIDTH_MEDIUM) {
      this.previewColumns = ColumnSize.COLUMN_FOUR;
      this.previewColumnMargin = Constants.COLUMN_MARGIN_FOUR;
      this.previewColumnGutter = Constants.COLUMN_GUTTER_FOUR;
    } else if (this.previewWidth >= ScreenWidth.WIDTH_MEDIUM && this.previewWidth < ScreenWidth.WIDTH_LARGE) {
      this.previewColumns = ColumnSize.COLUMN_EIGHT;
      this.previewColumnMargin = Constants.COLUMN_MARGIN_SIX;
      this.previewColumnGutter = Constants.COLUMN_GUTTER_SIX;
    } else if (this.previewWidth >= ScreenWidth.WIDTH_LARGE && this.previewWidth < ScreenWidth.WIDTH_XLARGE) {
      this.previewColumns = ColumnSize.COLUMN_TWELVE;
      this.previewColumnMargin = Constants.COLUMN_MARGIN_EIGHT;
      this.previewColumnGutter = Constants.COLUMN_GUTTER_EIGHT;
    } else {
      this.previewColumns = ColumnSize.COLUMN_TWELVE;
      this.previewColumnMargin = Constants.COLUMN_MARGIN_TWELVE;
      this.previewColumnGutter = Constants.COLUMN_GUTTER_TWELVE;
    }
  }

  /**
   卡片栅格宽度适配规则:

   1.0<=水平vp<600 时:4 Columns  ;栅格,Margin=16,Gutter=8,卡片宽度占4 Columns

   2.600<=水平 vp<840 时:8 Columns 栅格,Margin=24,Gutter=12,卡片宽度占6 Columns

   3.840<=水平 vp<1440:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

   4.1440<=水平vp 时:12Columns 栅格,Margin=32,Gutter=16,卡片宽度占8 Columns

   5.栅格最大使用宽度:最大使用宽度为 2220vp,当窗口不断拉宽大于 2220vp 时,栅格内的内容不再变化,多出的区域留白
   * @param size
   */
  private updateWinSizeInner(size: window.Size): void {
    if (!size) {
      Log.warn(TAG, 'The input parameter size of ScreenManager updateWinSizeInner is null');
      return;
    }
    let sizeBefore: Size = {
      width: this.winWidth,
      height: this.winHeight,
    };
    this.winWidth = this.getCorrectPx2vp(size?.width);
    this.winHeight = this.getCorrectPx2vp(size.height);
    Log.debug(TAG, `updateWinSizeInner winSize: ${size.width}*${
    size.height} px, ${this.winWidth}*${this.winHeight} vp`);
    if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
      this.columns = ColumnSize.COLUMN_FOUR;
      this.columnMargin = Constants.COLUMN_MARGIN_FOUR;
      this.columnGutter = Constants.COLUMN_GUTTER_FOUR;
    } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
      this.columns = ColumnSize.COLUMN_EIGHT;
      this.columnMargin = Constants.COLUMN_MARGIN_SIX;
      this.columnGutter = Constants.COLUMN_GUTTER_SIX;
    } else if (this.winWidth >= ScreenWidth.WIDTH_LARGE && this.winWidth < ScreenWidth.WIDTH_XLARGE) {
      this.columns = ColumnSize.COLUMN_TWELVE;
      this.columnMargin = Constants.COLUMN_MARGIN_EIGHT;
      this.columnGutter = Constants.COLUMN_GUTTER_EIGHT;
    } else {
      this.columns = ColumnSize.COLUMN_TWELVE;
      this.columnMargin = Constants.COLUMN_MARGIN_TWELVE;
      this.columnGutter = Constants.COLUMN_GUTTER_TWELVE;
    }
    this.updatePreviewWidth();
    if (sizeBefore.width !== this.winWidth || sizeBefore.height !== this.winHeight) {
      let newSize: Size = {
        width: this.winWidth,
        height: this.winHeight,
      };
      Log.info(TAG, `updateWinSizeInner winSize changed: ${JSON.stringify(sizeBefore)} -> ${JSON.stringify(newSize)}`);
      this.calcDiggingHoleCameraArea();
      this.emit(ScreenManager.ON_WIN_SIZE_CHANGED, [size]);
    }
  }

  public getColumnMargin(): number {
    return this.columnMargin;
  }

  public isWinWidthGetToMinBound(): boolean {
    if (this.windowMode === WindowMode.FLOATING) {
      return this.winWidth <= this.minWinWidth - 2 * (Constants.CONTAINER_BORDER_WIDTH + Constants.CONTENT_PADDING);
    }
    return this.winWidth <= this.minWinWidth;
  }

  public isUIExtensionEnv(): boolean {
    let uiExtensionStage: uiExtensionHost.UIExtensionHostWindowProxy = this.getProxy();
    return uiExtensionStage ? true : false;
  }

  private getHost(): uiExtensionHost.UIExtensionHostWindowProxy | window.Window {
    if (this.isUIExtensionEnv()) {
      return this.getProxy();
    } else {
      return this.getMainWindow();
    }
  }

  public getWinRect(): window.Rect {
    if (this.isUIExtensionEnv()) {
      return this.getProxy()?.properties?.uiExtensionHostWindowProxyRect;
    }
    return this.getMainWindow()?.getWindowProperties?.()?.windowRect;
  }

  public setWindowDecorVisiblePc(isVisible: boolean): void {
    try {
      this.getMainWindow().setWindowDecorVisible(isVisible);
      this.getMainWindow().setWindowDecorHeight(Constants.WindowDecorHeight);
    } catch (error) {
      Log.error(TAG, `set Window Decor VisiblePc error:${error},code:${error?.code}`)
    }
  }

  /**
   * 通知旋转方向发生变化
   * @param isHorizontal 是否横屏
   */
  public notifyOrientationChanged(isHorizontal: boolean): void {
    this.isScreenHorizontal = isHorizontal;
    this.broadcast.emit(ScreenManager.ON_ORIENTATION_CHANGED, [isHorizontal]);
  }

  public isHorizontal(): boolean {
    return this.isScreenHorizontal;
  }

  /**
   * 通知 状态栏 发生变化
   */
  private notifyStatusBarHeightChanged(): void {
    this.broadcast.emit(ScreenManager.ON_STATUS_BAR_HEIGHT_CHANGED, [this.statusBarHeight]);
  }

  private static handleInnerScreenRatio(winWidth: number, winHeight: number, disScreenWidth: number,
    disScreenHeight: number): boolean {
    if (!DeviceInfo.isSmallFoldExpanded()) {
      return false;
    }
    return (MathUtil.equals(winWidth, disScreenWidth / ScreenManager.INNER_SCREEN_RATIO) &&
    MathUtil.equals(winHeight, disScreenHeight / ScreenManager.INNER_SCREEN_RATIO)) ||
      (MathUtil.equals(winWidth, disScreenHeight / ScreenManager.INNER_SCREEN_RATIO) &&
      MathUtil.equals(winHeight, disScreenWidth / ScreenManager.INNER_SCREEN_RATIO));
  }

  /**
   *  当锁屏相机拉起大图组件，使用解锁功能前需拉起锁屏弹框解锁
   */
  public screenUnlock(callback?: Function): void {
    screenLock.unlock().then((unlockResult: Boolean) => {
      if (callback && unlockResult) {
        callback(unlockResult);
      }
    }).catch((err: BusinessError) => {
    });
  }

  public screenIsLock(): boolean {
    return screenLock.isLocked();
  }

  public isShowSideBarPc(): boolean {
    if (!DeviceInfo.isPc()) {
      return false;
    }
    if (PreferencesUtil.hasSync(Constants.PC_SIDEBAR_STATUS)) {
      let value: boolean = Boolean(PreferencesUtil.getSync(Constants.PC_SIDEBAR_STATUS, ''));
      Log.info(TAG, `PC isShowSideBar status: ${value}`)
      return value;
    }
    if (this.getWindowRectWidth() <= Math.ceil(vp2px(sideBarWidthBreakPoint))) {
      return false;
    }
    return true;
  }

  /**
   *  计算大图状态栏的高度
   */
  public calcBarTopHeight(): number {
    let topHeight: number = 0;
    let tempActionBarHeight: number = Constants.ActionBarHeight + px2vp(this.statusBarHeight);
    let winMode: WindowMode = getScreen()?.getWinMode();
    // 全屏
    if (winMode === WindowMode.FULLSCREEN) {
      if (isOrientationHorizontal()) {
        let foldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
        if ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(foldStatus)) &&
          !DeviceInfo.isFoldable() && !DeviceInfo.isHalfFoldState()) {
          topHeight = Constants.ActionBarHeight;
        } else if (DeviceInfo.isPc()) {
          topHeight = Constants.WindowDecorHeight;
        } else {
          topHeight = tempActionBarHeight;
        }
      } else {
        topHeight = tempActionBarHeight;
      }
    }
    // 悬浮窗
    if (winMode === WindowMode.FLOATING) {
      if (isOrientationHorizontal() && DeviceInfo.isPc()) {
        topHeight = Constants.WindowDecorHeight;
      } else {
        topHeight = tempActionBarHeight;
      }
    }
    // 分屏-上下分屏-左右分屏
    if (winMode === WindowMode.PRIMARY || winMode === WindowMode.UNDEFINED) {
      if (isOrientationHorizontal() && DeviceInfo.isPc()) {
        topHeight = Constants.WindowDecorHeight;
      } else {
        topHeight = tempActionBarHeight;
      }
    }
    return topHeight;
  }

  private isFromPickerView(): boolean {
    let params = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
    return params?.isFromPickerView ?? false;
  }

  public getPhotoitemView(imageComponentWidth?: number, imageComponentHeight?: number): number[] {
    let screenWidth = imageComponentWidth ?? (DeviceInfo.isPc() ?
    vp2px(getScreen().getWinWidth()) : this.disScreenWidth);
    let screenHeight = imageComponentHeight ?? (DeviceInfo.isPc() ?
    vp2px(getScreen().getWinHeight()) : this.disScreenHeight);
    return [screenWidth, screenHeight];
  }

  public getMargin(newVal: Area): number {
    if (newVal.width < ScreenWidth.WIDTH_MEDIUM) {
      return 16;
    } else if (newVal.width < ScreenWidth.WIDTH_LARGE) {
      return 24;
    } else {
      return 32;
    }
  }

  public getDisplayFixedForSmallFold(): display.Display {
    return DeviceInfo.isSmallFoldScreen() ?
      display.getDisplayByIdSync(0) : display.getDefaultDisplaySync();
  }
}

// 相册宫格距离屏幕左右边距
export function updateAlbumPageGridPaddingLeftAndRight(ignoreSideBar?: boolean): number {
  let sideBarWidth: number = 0;
  if (!ignoreSideBar) {
    sideBarWidth = ActionBarVar.isShowSideBar ? ActionBarVar.sideBarWidth : 0;
  }
  let winWidth: number = getScreen().getWinWidth() - sideBarWidth;
  let albumPageGridPaddingLeftAndRight: number = Constants.ALBUM_GRID_SMALL_PADDING_LEFT_AND_RIGHT;
  /* instrument ignore next */
  if (DeviceInfo.isPc()) {
    Log.info(TAG, `PC-AlbumPageGridPaddingLeftAndRight: ${albumPageGridPaddingLeftAndRight}`);
    return albumPageGridPaddingLeftAndRight;
  }
  if (winWidth < ScreenWidth.WIDTH_MEDIUM) {
    albumPageGridPaddingLeftAndRight = Constants.ALBUM_GRID_SMALL_PADDING_LEFT_AND_RIGHT;
  } else if (winWidth >= ScreenWidth.WIDTH_MEDIUM && winWidth < ScreenWidth.WIDTH_LARGE) {
    albumPageGridPaddingLeftAndRight = Constants.ALBUM_GRID_MEDIUM_PADDING_LEFT_AND_RIGHT;
  } else if (winWidth >= ScreenWidth.WIDTH_LARGE) {
    albumPageGridPaddingLeftAndRight = Constants.ALBUM_GRID_LARGE_PADDING_LEFT_AND_RIGHT;
  }
  Log.info(TAG, `AlbumPageGridPaddingLeftAndRight: ${albumPageGridPaddingLeftAndRight} ${winWidth} ${sideBarWidth}`);
  return albumPageGridPaddingLeftAndRight;
}

export function updateSegmentButtonWidth(): Length {
  const winWidth: number = ScreenManager.getInstance().getWinWidth();
  if (winWidth > Constants.SEGMENT_BUTTON_MAX_WIDTH + Constants.MENU_START_MARGIN * Constants.DOUBLE_NUMBER) {
    return Constants.SEGMENT_BUTTON_MAX_WIDTH;
  } else {
    return '100%';
  }
}

class NavigationButtonInfo {
  // 0: 三键导航， -1：正常导航条模式
  t10: number = -1;
  region: number[] = [0, 0, 0, 0];
}
