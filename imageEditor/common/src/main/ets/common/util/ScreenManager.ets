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
import { Constants } from './Constants';
import { DeviceUtil } from './DeviceUtil';
import { HiLog } from './HiLog';
import window from '@ohos.window';
import display from '@ohos.display';
import settings from '@ohos.settings';
import Bundles, { BUNDLE_NAMES } from '@ohos/tools/src/main/utils/Bundle';
import {
  CANVAS_RECT,
  DEVICE_FOLD_STATUS,
  DOWNLOAD_STATUS,
  EDITOR_STATUS_BAR_HEIGHT_KEY,
  FIRST_FRAME_STATUS,
  FONT_SIZE_SCALE_KEY,
  SCREEN_ORIENTATION_PORTRAIT,
  SCREEN_FOLD_ORIENTATION_PORTRAIT,
  USER_LOGIN_STATUS,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  WINDOW_STATUS_KEY,
  CURRENT_LANGUAGE
} from '../const';
import { App } from '../../service/App';
import { BusinessError, Callback } from '@ohos.base';
import uiExtensionHost from '@ohos.uiExtensionHost';
import { GlobalThisUtil } from './GlobalThisUtil';
import { RectValue, SwitchAnimator } from '../../service/EditorSDK';
import { global } from '@ohos/tools/src/main/global/Contexts';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import { FoldPhoneTypeValue } from '../../service/model/Enum';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { i18n } from '@kit.LocalizationKit';
import { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';

/* instrument ignore file */
const TAG: string = 'ScreenManager';

export enum ColumnSize {
  COLUMN_ONE_POINT_FIVE = 1.5,
  COLUMN_TWO = 2,
  COLUMN_FOUR = 4,
  COLUMN_SIX = 6,
  COLUMN_EIGHT = 8,
  COLUMN_TWELVE = 12,
}

enum ScreenWidth {
  WIDTH_MEDIUM = 520,
  WIDTH_LARGE = 840,
}

export enum WinWidth {
  WIDTH_MEDIUM = 600,
  WIDTH_LARGE = 840,
  WIDTH_XLARGE = 1440,
}

enum WindowMode {
  UNDEFINED = 1,
  FULLSCREEN,
  PRIMARY,
  SECONDARY,
  FLOATING
}


export class ScreenManager {
  private static readonly WIN_BOTTOM_BORDER_HEIGHT_PX: number = 7;
  private static readonly WIN_BOTTOM_BORDER_WIDTH_PX: number = 12;
  private static instance: ScreenManager;
  private columns: number = ColumnSize.COLUMN_FOUR;
  private isPortrait: boolean = true;
  private winWidth: number = 0.0;
  private winHeight: number = 0.0;
  private canRun: boolean = true;
  private isFold: boolean = true;
  private isFirstFrame: boolean = true;
  private isDownLoadFail: boolean = false;
  private canvasRect: RectValue = new RectValue(0, 0, 0, 0);
  private statusBarHeight: number = 29;
  private isWindowPcModeSwitchStatus: boolean = false;
  private layoutSwitching: boolean = false;
  private isQueryUserLogin: boolean = false;
  private isCamera = Bundles.getInfo().name === BUNDLE_NAMES['camera'];

  public setIsQueryUserLogin(logFlag: boolean) {
    HiLog.i(TAG, `setUserLog is ${logFlag}`);
    this.isQueryUserLogin = logFlag;
    AppStorage.setOrCreate<boolean>(USER_LOGIN_STATUS, logFlag);
  }

  public getIsQueryUserLogin(): boolean {
    if (!AppStorage.has(USER_LOGIN_STATUS)) {
      AppStorage.setOrCreate<boolean>(USER_LOGIN_STATUS, this.isQueryUserLogin);
    }
    return AppStorage.get(USER_LOGIN_STATUS) as boolean;
  }

  public setLayoutSwitching(switchFlag: boolean) {
    this.layoutSwitching = switchFlag;
  }

  public getLayoutSwitching(): boolean {
    return this.layoutSwitching;
  }

  public setCanvasRect(value: RectValue) {
    this.canvasRect = value;
    AppStorage.setOrCreate(CANVAS_RECT, this.canvasRect)
  }

  public getCanvasRect(): RectValue {
    if (!AppStorage.has(CANVAS_RECT)) {
      AppStorage.setOrCreate(CANVAS_RECT, this.canvasRect)
    }
    return AppStorage.get(CANVAS_RECT) as RectValue;
  }

  public setDownLoadFail(value: boolean) {
    this.isDownLoadFail = value;
    AppStorage.setOrCreate(DOWNLOAD_STATUS, this.isDownLoadFail)
  }

  public getDownLoadFail(): boolean {
    if (!AppStorage.has(DOWNLOAD_STATUS)) {
      AppStorage.setOrCreate(DOWNLOAD_STATUS, this.isDownLoadFail)
    }
    return AppStorage.get(DOWNLOAD_STATUS) as boolean;
  }

  public setIsFirstFrame(value: boolean) {
    HiLog.i(TAG, `setIsFirstFrame${value}`);
    this.isFirstFrame = value;
    AppStorage.setOrCreate(FIRST_FRAME_STATUS, this.isFirstFrame)
  }

  /**
   * 标记资源当前处于动效中
   */
  // instrument ignore next
  setIsAnimatingTimer(): void {
    let asset = App.getInstance().myEditor().asset;
    HiLog.i(TAG, `setIsAnimatingTimer`);
    asset.isAnimating = true;
    /* instrument ignore if */
    if (asset.animateTimer != -1) {
      clearTimeout(asset.animateTimer);
    }
    asset.animateTimer = setTimeout(() => {
      asset.isAnimating = false;
    }, 300)
  }

  public getIsFirstFrame(): boolean {
    HiLog.i(TAG, `getIsFirstFrame${this.isFirstFrame}`);

    if (!AppStorage.has(FIRST_FRAME_STATUS)) {
      AppStorage.setOrCreate(FIRST_FRAME_STATUS, this.isFirstFrame)
    }
    return AppStorage.get(FIRST_FRAME_STATUS) as boolean;
  }

  private constructor() {
    if (DeviceUtil.isPc()) {
      this.isPortrait = false;
    } else {
      this.isPortrait = true;
    }
  }

  get width(): number {
    return this.getWinRect() ? px2vp(this.getWinRect()?.width) : this.winWidth;
  }

  get height(): number {
    return this.getWinRect() ? px2vp(this.getWinRect()?.height) : this.winHeight;
  }

  // Returns the width of the layout area (LayoutWidth = WindowWidth).
  getWinLayoutWidth(): number {
    return this.width;
  }

  // Returns the height of the layout area (LayoutHeight = WindowHeight - WindowDecorHeight).
  getWinLayoutHeight(): number {
    HiLog.i(TAG, 'windowStatusChange is ' + ScreenManager.getInstance().getWindowStatusChange());
    if (ScreenManager.getInstance().isMultiWindowNotFullScreen()) {
      let heightVp = px2vp(ScreenManager.WIN_BOTTOM_BORDER_HEIGHT_PX);
      let isFullScreen = this.getMainWindow()?.getWindowProperties?.().isFullScreen;
      let decorHeight = this.getMainWindow()?.getWindowDecorHeight();
      let winDecorHeight: number = isFullScreen ? 0 : (decorHeight ? decorHeight : 0 + heightVp);
      return this.height - winDecorHeight;
    }
    if (this.isCamera) {
      let decorHeight = this.getMainWindow()?.getWindowDecorHeight();
      HiLog.i(TAG, 'from camera decorHeight: ' + decorHeight + 'height: ' + this.height);
      // 非自由多窗且高度大于0且xxx
      if (!this.isWindowPcModeSwitchStatus && decorHeight > 0 && DeviceUtil.isTriFoldScreen()) {
        decorHeight = 0;
      }
      return this.height - decorHeight;
    }
    return this.height;

  }

  public static getInstance() {
    if (!ScreenManager.instance) {
      ScreenManager.instance = new ScreenManager();
    }
    return ScreenManager.instance;
  }

  /**
   * 获取设备是否横竖屏状态
   *
   * @returns true：竖屏, false: 横屏
   */
  public isDisplayPortrait(): boolean {
    try {
      let orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
      let isWindowMode = this.isWindowMode();
      let isPortrait: boolean = orientation === display.Orientation.PORTRAIT ||
        orientation === display.Orientation.PORTRAIT_INVERTED;
      if (isWindowMode || (this.isSplitMode() && !this.isFold)) {
        isPortrait = true;
      }
      if (isPortrait && this.isLandscapeLayout()) {
        isPortrait = false;
      } else if (!isPortrait && this.isPortraitLayout()) {
        isPortrait = true;
      }
      return isPortrait;
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isDisplayPortrait error code is ${code}, message is ${message}`);
    }
    return false;
  }

  initWindowSize(defaultIsPortrait?: boolean) {
    let size: window.Rect = this.getWinRect();
    this.winWidth = px2vp(size.width);
    this.winHeight = px2vp(size.height);
    AppStorage.set<number>(WIN_WIDTH_KEY, this.winWidth);
    AppStorage.set<number>(WIN_HEIGHT_KEY, this.winHeight);
    // 传入横竖屏状态参数时，使用传入的横竖屏状态初始化
    let isPortrait: boolean = defaultIsPortrait !== undefined ? defaultIsPortrait : this.isDisplayPortrait();
    HiLog.i(TAG, `initialize isPortrait: ${isPortrait}`);
    this.onRotationChanged(isPortrait);
    if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
      this.columns = ColumnSize.COLUMN_FOUR;
    } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
      this.columns = ColumnSize.COLUMN_EIGHT;
    } else {
      this.columns = ColumnSize.COLUMN_TWELVE;
    }

    try {
      if (DeviceUtil.isFoldable()) {
        let foldStatus: display.FoldStatus = display.getFoldStatus();
        this.onFoldStatusChanged(foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ||
          foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_EXPANDED ||
          foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED_WITH_SECOND_HALF_FOLDED);
      }
    } catch (err) {
      HiLog.e(TAG, 'onFoldStatusChanged display.getFoldStatus error');
    }

    this.setMainWindow();
  }

  public windowSwitchStatus() {
    settings.getValue(global.uiAbilityContext(), 'window_pcmode_switch_status', settings.domainName.USER_PROPERTY)
      .then((value: string) => {
        this.isWindowPcModeSwitchStatus = value === 'true';
      });
  }

  public getWindowStatusChange(): boolean {
    return this.isWindowPcModeSwitchStatus;
  }

  public getTileToolHeight(): number {
    let heightVp = px2vp(ScreenManager.WIN_BOTTOM_BORDER_HEIGHT_PX);
    let winDecorHeight: number =
      (this.getMainWindow()?.getWindowDecorHeight() ? this.getMainWindow()?.getWindowDecorHeight() : 0 + heightVp);
    return winDecorHeight;
  }

  getColumnsWidth(count: number): number {
    HiLog.i(TAG, `getColumnsWidth count is ${count} colunms is ${this.columns}`);
    let columnWidth: number = (this.winWidth - Constants.COLUMN_MARGIN) / this.columns;
    return Number.parseInt((columnWidth * count - Constants.COLUMN_GUTTER) + '');
  }

  private windowSizeChangeCallback: Callback<window.Size> = (win: window.Size) => {
    HiLog.d(TAG, `windowSizeChange ${JSON.stringify(win)}`);
    this.onWinSizeChanged(win);
    this.getStatusBarHeight();
  }
  private windowStatusChangeCallBack: Callback<window.WindowStatusType> = (win: window.WindowStatusType) => {
    HiLog.d(TAG, `windowStatusChange ${JSON.stringify(win)}`);
    this.windowSwitchStatus();
  }

  avoidAreaChange() {
    this.getHost()?.on('avoidAreaChange', (data) => {
      // 节流，避免短时间多次调用
      if (!this.canRun) {
        return;
      }
      this.canRun = false;
      setTimeout((): void => {
        HiLog.i(TAG, `avoidAreaChange:${JSON.stringify(data)}`);
        this.getStatusBarHeight();
        this.canRun = true;
      }, 50);
    });
  }

  setMainWindow(): void {
    try {
      HiLog.i(TAG, 'setMainWindow');
      this.getStatusBarHeight();
      this.getHost()?.on('windowSizeChange', this.windowSizeChangeCallback);
      this.avoidAreaChange();
      this.windowSwitchStatus();
      this.getMainWindow()?.on('windowStatusChange', this.windowStatusChangeCallBack);
    } catch (error) {
      HiLog.e(TAG, `destroy window error: ${error}, code: ${error?.code}`);
    }
  }

  destroyMainWindow(): void {
    try {
      HiLog.i(TAG, 'destroyMainWindow');
      this.getHost()?.off('windowSizeChange', this.windowSizeChangeCallback);
      this.getMainWindow()?.off('windowStatusChange', this.windowStatusChangeCallBack);
    } catch (error) {
      HiLog.e(TAG, `destroy window error: ${error}, code: ${error?.code}`);
    }
  }

  onFoldRotationChanged(isPortrait: boolean): void {
    HiLog.i(TAG, `onFoldRotationChanged portrait: ${isPortrait}`);
    this.isPortrait = isPortrait;
    AppStorage.setOrCreate<boolean>(SCREEN_FOLD_ORIENTATION_PORTRAIT, this.isPortrait);
  }

  isFoldScreenPortrait(): boolean {
    if (!AppStorage.has(SCREEN_FOLD_ORIENTATION_PORTRAIT)) {
      AppStorage.setOrCreate<boolean>(SCREEN_FOLD_ORIENTATION_PORTRAIT, this.isPortraitLayout());
    }
    return AppStorage.get(SCREEN_FOLD_ORIENTATION_PORTRAIT) as boolean;
  }

  /**
   * 设备横竖屏切换
   */
  onDeviceRotationChanger(isPortrait: boolean): void {
    HiLog.i(TAG, `onDeviceRotationChanger portrait: ${isPortrait}`);
    this.setIsAnimatingTimer();
  }

  onRotationChanged(isPortrait: boolean): void {
    HiLog.i(TAG, `onRotationAngleChanged  isFold:${this.isFold}, isSmallWindowMode:${this.getSmallWindowMode()}`);
    if (this.isWindowPcModeSwitchStatus) {
      isPortrait = false;
    }
    if (AppStorage.get<number>('windowStatus') === window.WindowStatusType.FLOATING && !DeviceUtil.isPc() &&
      !this.isShowLayoutSwitching()) {
      isPortrait = true
      HiLog.i(TAG, 'onRotationAngleChanged FLOATING');
    }
    HiLog.i(TAG, `onRotationAngleChanged portrait: ${isPortrait}`);
    this.isPortrait = isPortrait;
    AppStorage.setOrCreate<boolean>(SCREEN_ORIENTATION_PORTRAIT, this.isPortrait);
    BroadCastManager.getInstance().getBroadCast().emit('onIsScreenPortrait');
  }

  isScreenPortrait(): boolean {
    if (!AppStorage.has(SCREEN_ORIENTATION_PORTRAIT)) {
      AppStorage.setOrCreate<boolean>(SCREEN_ORIENTATION_PORTRAIT, this.isPortrait);
    }
    return AppStorage.get(SCREEN_ORIENTATION_PORTRAIT) as boolean;
  }

  getFontSizeScale(): number {
    if (!AppStorage.has(FONT_SIZE_SCALE_KEY)) {
      AppStorage.setOrCreate<number>(FONT_SIZE_SCALE_KEY, 1);
    }
    return AppStorage.get(FONT_SIZE_SCALE_KEY) as number;
  }

  getCurrentLanguage(): string {
    if (!AppStorage.has(CURRENT_LANGUAGE)) {
      return '';
    }
    return AppStorage.get(CURRENT_LANGUAGE) as string;
  }

  onFoldStatusChanged(isFold: boolean): void {
    this.isFold = DeviceUtil.isSmallFoldProduct() || isFold;
    AppStorage.setOrCreate<boolean>(DEVICE_FOLD_STATUS, this.isFold)
    HiLog.i(TAG, `foldStatus has changed, isFold: ${isFold}`)
  }

  isDeviceFold(): boolean {
    if (!AppStorage.has(DEVICE_FOLD_STATUS)) {
      AppStorage.setOrCreate<boolean>(DEVICE_FOLD_STATUS, this.isFold)
    }
    return AppStorage.get(DEVICE_FOLD_STATUS) as boolean;
  }

  // 是否手机橫屏
  isPhoneLR() {
    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    let isFold = ScreenManager.getInstance().isDeviceFold();
    if (!isScreenPortrait && DeviceUtil.isPhone() &&
      (!DeviceUtil.isFoldable() || (DeviceUtil.isFoldable() && (isFold || (!isFold && this.getHeightScale() < 1))))) {
      return true;
    } else {
      return false;
    }
  }

  // 是否 xxx展开||pad 左右布局
  isFoldAndPadLR() {
    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    let isFold = ScreenManager.getInstance().isDeviceFold();
    if (!isScreenPortrait && (DeviceUtil.isPad() || (DeviceUtil.isFoldable() && !isFold)) && !this.isSplitMode()) {
      return true;
    } else {
      return false;
    }
  }

  // 是否 xxx展开||pad
  isFoldAndPad() {
    let isFold = ScreenManager.getInstance().isDeviceFold();
    if ((DeviceUtil.isPad() || (DeviceUtil.isFoldable() && !isFold)) && !this.isSplitMode()) {
      return true;
    }
    return false;
  }

  getAiBarHeight(): number {
    let area: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    return px2vp(area?.bottomRect.height);
  }

  updateAvoid(top: number, right: number, bottom: number, left: number) {
    const screenClass = App.getInstance().screenClass;
    if (screenClass.avoidBottom === bottom && screenClass.avoidLeft === left &&
      screenClass.avoidRight === right && screenClass.avoidTop === top) {
      return;
    }
    App.getInstance().screenClass.setAvoidInfo(left, right, top, bottom);
  }

  calcAvoidTop(top: number) {
    // UIextension场景状态栏需要避让
    if (((DeviceUtil.isFoldable() && !this.isFold) || DeviceUtil.isPad()) && this.isUIExtensionEnv()) {
      top = this.statusBarHeight;
    }

    // pc不涉及兜底任务栏避让
    if (!DeviceUtil.isPc()) {
      // 除了直板机/xxx机xxx下,且编辑布局为横屏布局无需采用兜底方案,其余情况均需兜底任务栏避让
      if (!(((DeviceUtil.isFoldable() && this.isFold) || (DeviceUtil.getFoldProductType() ===
      FoldPhoneTypeValue.STRAIGHT && !DeviceUtil.isPad())) && !this.isScreenPortrait())) {
        if (top === 0) {
          top = this.statusBarHeight;
        }
      }
    }
    return top;
  }

  getStatusBarHeight() {
    try {
      let statusBarHeightCutOut = 0;
      let aiBarHeight =
        App.getInstance()?.screenClass.avoidBottom === 0 || (this.isSplitMode() && this.isDeviceFold()) ?
          this.getAiBarHeight() : App.getInstance().screenClass.avoidBottom;
      HiLog.i(TAG, 'getWindowAvoidArea cutout');
      let cutout: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
      let system: window.AvoidArea = this.getHost()?.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let cutTopHeight = cutout ? cutout.topRect.top + cutout.topRect.height : 0;
      let systemTopHeight = system ? system.topRect.top + system.topRect.height : 0;
      statusBarHeightCutOut =
        (this.isSplitMode() || AppStorage.get<number>('windowStatus') === window.WindowStatusType.FLOATING ||
          (AppStorage.get<number>(WINDOW_STATUS_KEY) && !DeviceUtil.isPc())) ? systemTopHeight : cutTopHeight;
      let displayLeft = 0;
      if (!this.isPortrait) {
        displayLeft += ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
      } else {
        HiLog.i(TAG, `displayLeft avoid get isPortrait`);
      }
      let left = displayLeft;
      HiLog.i(TAG, `displayLeft avoid ${left}`);
      let right = 0;
      const bottom = aiBarHeight;
      if (DeviceUtil.isPhone()) {
        HiLog.i(TAG, `isPhone avoid ${left}`);
        left = px2vp(cutout.leftRect.left + cutout.leftRect.width) + displayLeft;
        right = cutout.rightRect.width ? px2vp(this.getWinRect()?.width - cutout.rightRect.left) : 0;
      }
      const top = this.calcAvoidTop(px2vp(statusBarHeightCutOut));
      HiLog.i(TAG, `avoid ${left} ${right} ${top} ${bottom}`);
      this.updateAvoid(top, right, bottom, left);

      App.getInstance().myEditor().isScreenClassInit = true;
      HiLog.i(TAG, 'getWindowAvoidArea success, statusBarHeight is ' +
        statusBarHeightCutOut + `, avoidTop is ${App.getInstance().screenClass.avoidTop}`);
      AppStorage.setOrCreate<number>(EDITOR_STATUS_BAR_HEIGHT_KEY, statusBarHeightCutOut);
    } catch (error) {
      HiLog.e(TAG, `getStatusBarHeight failed! ${error}`);
      AppStorage.setOrCreate<number>(EDITOR_STATUS_BAR_HEIGHT_KEY, 0);
    }
  }

  public isRTL() {
    const curLanguage = AppStorage.get<string>(CURRENT_LANGUAGE);
    return i18n.isRTL(curLanguage);
  }

  private onWinSizeChanged(size: window.Size | window.Rect): void {
    HiLog.i(TAG, `onWinSizeChanged ${JSON.stringify(size)}`);
    if (size == null || size == undefined) {
      return;
    }
    this.updateWinSizeInner(size);
  }

  private updateWinSizeInner(size: window.Size): void {
    this.setIsAnimatingTimer();
    this.getSmallWindowMode();
    let newWinWidth = px2vp(size.width);
    let newWinHeight = px2vp(size.height);
    if (this.winWidth === newWinWidth && this.winHeight === newWinHeight) {
      return;
    }
    this.winWidth = newWinWidth;
    this.winHeight = newWinHeight;
    AppStorage.set<number>(WIN_WIDTH_KEY, this.winWidth);
    AppStorage.set<number>(WIN_HEIGHT_KEY, this.winHeight);
    HiLog.i(TAG, `updateWinSizeInner winSize: ${size.width}*${size.height} px, ${this.winWidth}*${this.winHeight} vp`);
    if (this.winWidth < ScreenWidth.WIDTH_MEDIUM) {
      this.columns = ColumnSize.COLUMN_FOUR;
    } else if (this.winWidth >= ScreenWidth.WIDTH_MEDIUM && this.winWidth < ScreenWidth.WIDTH_LARGE) {
      this.columns = ColumnSize.COLUMN_EIGHT;
    } else {
      this.columns = ColumnSize.COLUMN_TWELVE;
    }
  }

  getSmallWindowMode(): boolean {
    let winRect: window.Rect | null = this.getWinRect();
    let isSmallWindow: boolean = false;
    if (!winRect) {
      HiLog.e(TAG, 'isSplitMode without window rect');
      AppStorage.setOrCreate<boolean>(WINDOW_STATUS_KEY, isSmallWindow);
      return isSmallWindow;
    }
    try {
      isSmallWindow = display.getDefaultDisplaySync().width != winRect.width || display.getDefaultDisplaySync()
        .height != winRect.height
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `getSmallWindowMode error code is ${code}, message is ${message}`);
    }
    AppStorage.setOrCreate<boolean>(WINDOW_STATUS_KEY, isSmallWindow);
    return isSmallWindow;
  }

  /**
   * 是否为多窗模式
   *
   * @returns boolean
   */
  isWindowMode(): boolean {
    if (!this.getWinRect()) {
      HiLog.e(TAG, 'get winRect failed');
      return false;
    }
    try {
      if (DeviceUtil.isPad() && (display.getDefaultDisplaySync()
        .height != this.getWinRect().height) || ((DeviceUtil.isFoldable() &&
        !ScreenManager.getInstance().isFold) && display.getDefaultDisplaySync().width != this.getWinRect().width)) {
        return true;
      }
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isWindowMode error code is ${code}, message is ${message}`);
    }
    return false;
  }

  /**
   * 是否为分屏模式
   *
   * @returns boolean
   */
  isSplitMode(): boolean {
    try {
      if (!DeviceUtil.isPc() && this.getWinRect()) {
        if ((display.getDefaultDisplaySync().height == this.getWinRect()?.height &&
          display.getDefaultDisplaySync().width != this.getWinRect()?.width) ||
          (display.getDefaultDisplaySync().height != this.getWinRect()?.height &&
            display.getDefaultDisplaySync().width == this.getWinRect()?.width)) {
          return true;
        }
      }
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isSplitMode error code is ${code}, message is ${message}`);
    }
    return false;
  }

  /**
   * 获取分屏/多窗模式比例
   *
   * @returns boolean
   */
  getScale(): number {
    if (this.getWinRect()) {
      try {
        HiLog.i(TAG, 'getScale is:' + (this.isPortrait ? this.getWinRect()?.height / display.getDefaultDisplaySync()
          .height :
          this.getWinRect()?.width / display.getDefaultDisplaySync().width));
        return this.isPortrait ? this.getWinRect()?.height / display.getDefaultDisplaySync().height :
          this.getWinRect()?.width / display.getDefaultDisplaySync().width;
      } catch (error) {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        HiLog.e(TAG, `getScale error code is ${code}, message is ${message}`);
      }
    }
    return 1;
  }

  isUIExtensionEnv(): boolean {
    let uiExtensionStage: uiExtensionHost.UIExtensionHostWindowProxy =
      LocalStorage.getShared()?.get('editor_UiExtensionStage') as uiExtensionHost.UIExtensionHostWindowProxy;
    return uiExtensionStage ? true : false;
  }

  getHost(): uiExtensionHost.UIExtensionHostWindowProxy | window.Window {
    if (this.isUIExtensionEnv()) {
      return this.getUIExtensionProxy();
    } else {
      return this.getMainWindow();
    }
  }

  private getUIExtensionProxy(): uiExtensionHost.UIExtensionHostWindowProxy {
    let uiExtensionStage: uiExtensionHost.UIExtensionHostWindowProxy =
      LocalStorage.getShared()?.get('editor_UiExtensionStage') as uiExtensionHost.UIExtensionHostWindowProxy;
    return uiExtensionStage;
  }

  public getMainWindow(): window.Window {
    return LocalStorage.getShared()?.get('editor_mainWindow') as window.Window;
  }

  public getWinRect(): window.Rect {
    if (this.isUIExtensionEnv()) {
      let storage = LocalStorage.getShared();
      if (storage && storage.get<boolean>('isThirdPickerSubwindow') && storage.has('PcPickerRect')) {
        return storage.get<window.Rect>('PcPickerRect') ??
          this.getUIExtensionProxy()?.properties?.uiExtensionHostWindowProxyRect;
      }
      return this.getUIExtensionProxy()?.properties?.uiExtensionHostWindowProxyRect;
    }
    return this.getMainWindow()?.getWindowProperties?.()?.windowRect;
  }

  getWidthScale(): number {
    try {
      return this.getWinRect()?.width / display.getDefaultDisplaySync().width;
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `getWidthScale error code is ${code}, message is ${message}`);
    }
    return 0;
  }

  getHeightScale(): number {
    try {
      return this.getWinRect()?.height / display.getDefaultDisplaySync().height;
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `getHeightScale error code is ${code}, message is ${message}`);
    }
    return 0;
  }

  /**
   * 是否左右布局
   *
   * @returns boolean
   */
  isLandscapeLayout(): boolean {
    if (!this.getWinRect()) {
      HiLog.e(TAG, 'isLandscapeLayout without window rect');
      return false;
    }
    HiLog.i(TAG, 'isLandscapeLayout, scale is ' + this.getWinRect().width / this.getWinRect().height);
    if (this.getWinRect().width / this.getWinRect().height > 0.95) {
      return true;
    }
    return false;
  }

  /**
   * 是否上下布局
   *
   * @returns boolean
   */
  isPortraitLayout(): boolean {
    if (!this.getWinRect()) {
      HiLog.e(TAG, 'isPortraitLayout without window rect');
      return false;
    }
    HiLog.i(TAG, 'isPortraitLayout, scale is ' + this.getWinRect().width / this.getWinRect().height);
    if (this.getWinRect().width / this.getWinRect().height <= 0.95) {
      return true;
    }
    return false;
  }

  /**
   * 获取编辑页预览区域的rect位置
   *
   * @returns boolean
   */
  getPreviewRect(ratio: number, isRealPortrait?: boolean, stickerName?: string): RectValue {
    return SwitchAnimator.getEditorPreviewRect({
      width: ScreenManager.getInstance().width,
      height: ScreenManager.getInstance().height,
    }, ratio, 'IMAGE', isRealPortrait, stickerName);
  }

  // 编辑页面上下标题栏距离屏幕左右边距
  updateEditorPageGridPaddingLeftAndRight(): number {
    let winWidth: number = ScreenManager.getInstance().width;
    let editorPageGridPaddingLeftAndRight: number = Constants.EDITOR_GRID_SMALL_PADDING_LEFT_AND_RIGHT;
    if (winWidth < WinWidth.WIDTH_MEDIUM) {
      editorPageGridPaddingLeftAndRight = Constants.EDITOR_GRID_SMALL_PADDING_LEFT_AND_RIGHT;
    } else if (winWidth >= WinWidth.WIDTH_MEDIUM && winWidth < WinWidth.WIDTH_LARGE) {
      editorPageGridPaddingLeftAndRight = Constants.EDITOR_GRID_MEDIUM_PADDING_LEFT_AND_RIGHT;
    } else if (winWidth >= WinWidth.WIDTH_LARGE) {
      editorPageGridPaddingLeftAndRight = Constants.EDITOR_GRID_LARGE_PADDING_LEFT_AND_RIGHT;
    }
    HiLog.d(TAG, `EditorPageGridPaddingLeftAndRight: ${editorPageGridPaddingLeftAndRight}`);
    return editorPageGridPaddingLeftAndRight;
  }

  isMultiWindowNotFullScreen(): boolean {
    try {
      return this.isWindowPcModeSwitchStatus && display.getDefaultDisplaySync().height != this.getWinRect()?.height &&
        display.getDefaultDisplaySync().width != this.getWinRect()?.width;
    } catch (error) {
      HiLog.e(TAG, `isMultiWindowNotFullScreen get error: ${error}`)
      return false;
    }
  }

  // 是否显示布局切换按钮
  isShowLayoutSwitching(): boolean {
    const isFold = ScreenManager.getInstance().isDeviceFold();
    const isFloatMode = getScreen().isFloatMode();
    HiLog.i(TAG, 'isShowLayoutSwitching');
    return !isFold && !isFloatMode;
  }
}