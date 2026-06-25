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

import lazy { MathUtil } from './MathUtil';
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from './Log';
import type { DiggingHoleCameraArea } from '../model/common/ScreenManager';
import lazy { getScreen, isOrientationHorizontal, ScreenManager } from '../model/common/ScreenManager';
import type resourceManager from '@ohos.resourceManager';
import type window from '@ohos.window';
import type { Action } from '../view/browserOperation/Action';
import type { BroadCast } from './BroadCast';
import type { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import type { ViewData } from '../model/browser/photo/ViewData';
import type common from '@ohos.app.ability.common';
import type { AlbumInfo } from '../model/browser/album/AlbumInfo';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy vibrator from '@ohos.vibrator';
import type { BusinessError } from '@ohos.base';
import lazy { GridScreenInfo } from './GridScreenInfo';
import lazy { Configuration, FrameNode, promptAction, UIContext } from '@kit.ArkUI';
import lazy prompt from '@system.prompt';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { SelectParams } from '../../../../main/ets/default/model/common/SelectParams';
const TAG: string = 'UiUtil';

type Window = window.Window;

export interface Event {
  componentWidth: number;
  componentHeight: number;
  message: string;
}

export enum VibrateType {
  IMAGE,
  ALBUM
}

export interface CurrentRowOffset {
  row: number
  col: number
}

export class UiUtil {
  /**
   * Status bar height
   */
  public static readonly STATUS_BAR_HEIGHT = 45;
  /**
   * Navigation bar height
   */
  public static readonly NAVI_BAR_HEIGHT = 45;
  /**
   * Hexadecimal Radix
   */
  public static readonly HEX_BASE = 16;
  /**
   * Maximum order of color
   */
  public static readonly MAX_COLOR_ORDER = 255;
  public static readonly TOAST_DURATION = 3500;
  public static readonly TOAST_DURATION_SHORTER = 2000;
  public static readonly TOAST_BOTTOM = 80;
  public static readonly TOAST_SHOW_MODE_TOP_MOST = 1;
  /**
   * 未知宫格数
   */
  public static readonly GRID_NUM_UNKNOWN: number = -1;
  /**
   * 3-bit length hex color
   */
  private static readonly HEX_COLOR_LENGTH_THREE = 3;
  /**
   * 8-bit length hex color
   */
  private static readonly HEX_COLOR_LENGTH_EIGHT = 8;
  /**
   * Opacity length of hex color
   */
  private static readonly HEX_COLOR_OPACITY_LENGTH = 2;
  /**
   * Hexadecimal array
   */
  private static readonly HEX_ARRAY = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
  /**
   * grid calculation constant
   */
  public static readonly minDpNum: number = 360;
  public static readonly minPadDpNum: number = 1550;
  public static readonly MIN_DP_GRID_NUM: number = 2;
  public static readonly DEFAULT_NUM: number = 1;
  public static readonly albumDefaultScale: number = 0;
  public static readonly albumLargeScale: number = 1;
  /**
   * dialog const
   */
  private static readonly aspectRatioFour: number = 9 / 16;
  private static readonly aspectRatioEight: number = 3 / 4;
  private static readonly aspectRatioTwelve: number = 4 / 3;
  private static readonly columTotalFour: number = 4;
  private static readonly columTotalEight: number = 8;
  private static readonly columTotalTwelve: number = 12;
  private static readonly columCountThree: number = 3;
  private static readonly columCountFour: number = 4;
  private static readonly columCountFive: number = 5;
  private static readonly columCountSix: number = 6;
  private static readonly TRANSPARENT_BACKGROUND_COLOR: Resource = $r('app.color.transparent');
  private static readonly DEFAULT_BACKGROUND_COLOR: Resource = $r('sys.color.background_secondary');
  /**
   * 直板机竖屏宫格列数
   */
  private static readonly GRID_COL_NUM_PHONE_VERTICAL: number = 4;
  /**
   * 直板机竖屏宫格行数
   */
  private static readonly GRID_ROW_NUM_PHONE_VERTICAL: number = 10;
  /**
   * 直板机竖屏宫格数
   */
  private static readonly GRID_NUM_PHONE_VERTICAL: number = UiUtil.GRID_COL_NUM_PHONE_VERTICAL *
  UiUtil.GRID_ROW_NUM_PHONE_VERTICAL;
  /**
   * 直板机横屏宫格列数
   */
  private static readonly GRID_COL_NUM_PHONE_HORIZONTAL: number = 7;
  /**
   * 直板机横屏宫格行数
   */
  private static readonly GRID_ROW_NUM_PHONE_HORIZONTAL: number = 5;
  /**
   * 直板机横屏宫格数
   */
  private static readonly GRID_NUM_PHONE_HORIZONTAL: number = UiUtil.GRID_COL_NUM_PHONE_HORIZONTAL *
  UiUtil.GRID_ROW_NUM_PHONE_HORIZONTAL;
  /**
   * xxxxxx竖屏宫格列数
   */
  private static readonly GRID_COL_NUM_FOLD_PHONE_EXPANDED_VERTICAL: number = 6;
  /**
   * xxxxxx竖屏宫格行数
   */
  private static readonly GRID_ROW_NUM_FOLD_PHONE_EXPANDED_VERTICAL: number = 8;
  /**
   * xxxxxx竖屏宫格数
   */
  private static readonly GRID_NUM_FOLD_PHONE_EXPANDED_VERTICAL: number =
    UiUtil.GRID_COL_NUM_FOLD_PHONE_EXPANDED_VERTICAL * UiUtil.GRID_ROW_NUM_FOLD_PHONE_EXPANDED_VERTICAL;
  /**
   * xxxxxx横屏宫格列数
   */
  private static readonly GRID_COL_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL: number = 6;
  /**
   * xxxxxx横屏宫格行数
   */
  private static readonly GRID_ROW_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL: number = 7;
  /**
   * xxxxxx横屏宫格数
   */
  private static readonly GRID_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL: number =
    UiUtil.GRID_COL_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL * UiUtil.GRID_ROW_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL;
  /**
   * xxx竖屏宫格列数
   */
  private static readonly GRID_COL_NUM_FOLD_PHONE_FOLDED_VERTICAL: number = 4;
  /**
   * xxx竖屏宫格行数
   */
  private static readonly GRID_ROW_NUM_FOLD_PHONE_FOLDED_VERTICAL: number = 11;
  /**
   * xxx竖屏宫格数
   */
  private static readonly GRID_NUM_FOLD_PHONE_FOLDED_VERTICAL: number = UiUtil
    .GRID_COL_NUM_FOLD_PHONE_FOLDED_VERTICAL * UiUtil.GRID_ROW_NUM_FOLD_PHONE_FOLDED_VERTICAL;
  /**
   * xxx横屏宫格列数
   */
  private static readonly GRID_COL_NUM_FOLD_PHONE_FOLDED_HORIZONTAL: number = 6;
  /**
   * xxx横屏宫格行数
   */
  private static readonly GRID_ROW_NUM_FOLD_PHONE_FOLDED_HORIZONTAL: number = 4;
  /**
   * xxx横屏宫格数
   */
  private static readonly GRID_NUM_FOLD_PHONE_FOLDED_HORIZONTAL: number = UiUtil
    .GRID_COL_NUM_FOLD_PHONE_FOLDED_HORIZONTAL * UiUtil.GRID_ROW_NUM_FOLD_PHONE_FOLDED_HORIZONTAL;
  /**
   * 平板竖屏宫格列数
   */
  private static readonly GRID_COL_NUM_TABLET_VERTICAL: number = 6;
  /**
   * 平板竖屏宫格行数
   */
  private static readonly GRID_ROW_NUM_TABLET_VERTICAL: number = 11;
  /**
   * 平板竖屏宫格数
   */
  private static readonly GRID_NUM_TABLET_VERTICAL: number = UiUtil.GRID_COL_NUM_TABLET_VERTICAL *
  UiUtil.GRID_ROW_NUM_TABLET_VERTICAL;
  /**
   * 平板横屏宫格列数
   */
  private static readonly GRID_COL_NUM_TABLET_HORIZONTAL: number = 8;
  /**
   * 平板横屏宫格行数
   */
  private static readonly GRID_ROW_NUM_TABLET_HORIZONTAL: number = 6;
  /**
   * 平板横屏宫格数
   */
  private static readonly GRID_NUM_TABLET_HORIZONTAL: number = UiUtil.GRID_COL_NUM_TABLET_HORIZONTAL *
  UiUtil.GRID_ROW_NUM_TABLET_HORIZONTAL;


  /**
   * set picker BundleNameValue
   * @param boolean
   * @returns
   */
  public static setBundleNameValue(isEnterPhoto: boolean, storage: LocalStorage): void {
    let paramName = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    let pickerNameList: Record<string, boolean | undefined> = AppStorage.get('pickerNameList') ?? {};
    if (pickerNameList && paramName?.bundleName !== undefined) {
      pickerNameList[paramName?.bundleName] = isEnterPhoto;
    }
    Log.info(TAG, `setBundleNameValue: ${JSON.stringify(AppStorage.get('pickerNameList'))}`);
  }

  /* instrument ignore next */
  public static getActionBarBackgroundColor(isShow: boolean): Resource {
    let bgColor: Resource = UiUtil.DEFAULT_BACKGROUND_COLOR;
    if (isShow) {
      bgColor = UiUtil.TRANSPARENT_BACKGROUND_COLOR;
    }
    return bgColor;
  }

  /**
   * Set status bar color
   *
   * @param statusBarColor statusBarColor
   */
  public static setStatusBarColor(topWindow: Window): void {
    topWindow.setWindowSystemBarProperties({ navigationBarColor: '#FFF1F3F5', navigationBarContentColor: '#FF000000' },
      (): void => {
        Log.info(TAG, 'setStatusBarColor done');
      });
  }

  /**
   * Gets the hexadecimal color with opacity
   *
   * @param color Original hex color
   * @param opacity Opacity
   * @returns Hex color with opacity
   */
  /* instrument ignore next */
  public static getHexOpacityColor(paramColor: string, paramOpacity: number): string {
    let colorReg = /^\#([0-9a-fA-f]{3}|[0-9a-fA-f]{6}|[0-9a-fA-f]{8})$/;
    // The input must be # the first 3-bit / 6-bit / 8-bit hex color
    if (paramColor.match(colorReg) == null) {
      Log.error(TAG, `getHexOpacityColor failed because of invalid input, color:  ${paramColor}`);
      return paramColor;
    }
    let color = paramColor.replace(/\#/g, '').toUpperCase();
    let opacity = MathUtil.clamp(0, 1, paramOpacity);
    // If it is an abbreviated 3-digit color, complete the 3-digit characters to 6-digit characters
    if (color.length === UiUtil.HEX_COLOR_LENGTH_THREE) {
      let arr = color.split('');
      color = '';
      for (let i = 0; i < arr.length; i++) {
        color += (arr[i] + arr[i]);
      }
    }
    // If it is an 8-bit color, the original opacity will be removed
    if (color.length === UiUtil.HEX_COLOR_LENGTH_EIGHT) {
      color = color.slice(UiUtil.HEX_COLOR_OPACITY_LENGTH, color.length);
    }
    let opacityNum = Math.round(UiUtil.MAX_COLOR_ORDER * opacity); // rounding
    let opacityStr = '';
    while (opacityNum > 0) {
      let mod = opacityNum % UiUtil.HEX_BASE;
      opacityNum = (opacityNum - mod) / UiUtil.HEX_BASE;
      opacityStr = UiUtil.HEX_ARRAY[mod] + opacityStr;
    }
    if (opacityStr.length === 1) {
      opacityStr = `0${opacityStr}`;
    }
    if (opacityStr.length === 0) {
      opacityStr = '00';
    }
    return `#${opacityStr + color}`;
  }

  /**
   * 十进制的数字转成色值，位数不足的前面补0
   * @param decimal 带透明度的数字
   * @returns
   */
  public static decToHexColor(decimal: number): string {
    if (decimal < 0) {
      return '00000000';
    }
    let hexColor: string = decimal.toString(UiUtil.HEX_BASE);
    while (hexColor.length < 8) {
      hexColor = `0${hexColor}`;
    }
    return `#${hexColor}`;
  }

  /**
   * Get the content of the resource reference
   *
   * @deprecated 此函数使用了全局context导致性能下降,
   * 获取$r string请使用
   *  new RscGetter(getContext().resourceManager).getString()
   * @param resource resource reference
   * @returns resource Corresponding content string
   */
  /* instrument ignore next */
  public static async getResourceString(resource: Resource): Promise<string> {
    Log.info(TAG, `getResourceString: ${JSON.stringify(resource)}`);
    if (resource.moduleName === 'browserlibrary') {
      return await UiUtil.getResourceManager('photoLibraryContext')?.getString(resource.id) ?? '';
    }
    return await UiUtil.getResourceManager()?.getStringValue(resource) ?? '';
  }

  /**
   * @deprecated 此函数使用了全局context导致性能下降, 获取$r string请使用
   *  new RscGetter(getContext().resourceManager).getString()
   * @param resource
   * @param number
   * @returns
   */
  /* instrument ignore next */
  public static async getResourceStringParams(resource: Resource, number: number): Promise<string> {
    Log.info(TAG, `getResourceStringParams: ${JSON.stringify(resource)}`);
    return UiUtil.getResourceManager()?.getStringSync(resource.id, number) ?? '';
  }

  /**
   * @deprecated 此函数使用了全局context导致性能下降, 获取$r string请使用
   *  new RscGetter(getContext().resourceManager).getString()
   * @param resource
   * @param string
   * @returns
   */
  /* instrument ignore next */
  public static async getResourceStringMessage(resource: Resource, string: string): Promise<string> {
    Log.info(TAG, `getResourceStringParams: ${JSON.stringify(resource)}`);
    return UiUtil.getResourceManager()?.getStringSync(resource.id, string) ?? '';
  }

  /**
   * Get the content of the resource reference
   * @deprecated 此函数使用了全局context导致性能下降, 获取$r string请使用
   *  new RscGetter(getContext().resourceManager).getString()
   * @param resource resource reference
   * @returns resource Corresponding content string
   */
  /* instrument ignore next */
  public static getResourceStringSync(resource: Resource): string {
    Log.info(TAG, `getResourceStringSync: ${JSON.stringify(resource)}`);
    if (resource.moduleName === 'browserlibrary') {
      return UiUtil.getResourceManager('photoLibraryContext')?.getStringSync(resource.id) ?? '';
    }
    return UiUtil.getResourceManager()?.getStringSync(resource.id) ?? '';
  }

  /**
   * Get the content of the resource reference
   *
   * @deprecated 此函数使用了全局context导致性能下降, 获取$r number请使用
   *  new RscGetter(getContext().resourceManager).getNumber()
   * @param resource resource reference
   * @returns resource Corresponding content number
   */
  public static getResourceNumber(resource: Resource): number {
    Log.info(TAG, `getResourceNumber: ${JSON.stringify(resource)}`);
    return UiUtil.getResourceManager()?.getNumber(resource.id) ?? Number.NaN;
  }

  /**
   * Get the content of the resource reference
   *
   * @deprecated 此函数使用了全局context导致性能下降, 获取$r Color请使用
   *  new RscGetter(getContext().resourceManager).getColor()
   * @param resource resource reference
   * @returns resource Corresponding content Color
   */
  /* instrument ignore next */
  public static getResourceColorSync(resource: Resource): number {
    Log.info(TAG, `getResourceColorSync: ${JSON.stringify(resource)}`);
    return UiUtil.getResourceManager()?.getColorSync(resource.id) ?? Number.NaN;
  }

  public static async showToastWithMessage(message: string): Promise<void> {
    const uiContext: UIContext = LocalStorage.getShared()?.get('uiContext') as UIContext;
    let toast = uiContext?.getPromptAction();
    toast.showToast({
      message: message,
      duration: UiUtil.TOAST_DURATION,
      bottom: UiUtil.TOAST_BOTTOM,
      showMode: UiUtil.TOAST_SHOW_MODE_TOP_MOST,
    });
    return;
  }

  /* instrument ignore next */
  public static async showToast(resource: Resource, count?: number, duration?: number): Promise<void> {
    let message: string;
    if (count) {
      message = await UiUtil.getResourceStringParams(resource, count);
    } else {
      message = await UiUtil.getResourceString(resource);
    }
    let isFromPicker: UIExtensionContentSession | undefined = LocalStorage.getShared()?.
    get(Constants.PHOTO_PICKER_SESSION_KEY);
    Log.info(TAG, `showToast: ${message}` + " isFromPicker " + isFromPicker);
    if (isFromPicker) {
      prompt.showToast({
        message: message,
        duration: duration ?? UiUtil.TOAST_DURATION,
        bottom: UiUtil.TOAST_BOTTOM + getScreen().getAiBarHeight(),
      });
    } else {
      const uiContext: UIContext = LocalStorage.getShared()?.get('uiContext') as UIContext;
      let toast = uiContext?.getPromptAction();
      // TODO  ToastShowMode.TOP_MOST 目前无效不展示
      toast.showToast({
        message: message,
        duration: duration ?? UiUtil.TOAST_DURATION,
        bottom: UiUtil.TOAST_BOTTOM,
        showMode: 0,
      });
    }
  }

  /* instrument ignore next */
  public static async showToastShorter(resource: Resource, count?: number): Promise<void> {
    let message: string;
    if (count) {
      message = await UiUtil.getResourceStringParams(resource, count);
    } else {
      message = await UiUtil.getResourceString(resource);
    }
    Log.debug(TAG, `showToastShorter: ${message}`);
    promptAction.showToast({
      message: message,
      duration: UiUtil.TOAST_DURATION_SHORTER,
      bottom: UiUtil.TOAST_BOTTOM,
    });
  }

  /**
   * 获取相册封面宫格布局列的个数
   *
   * @param isSidebar 是否包含侧边栏
   */
  /* instrument ignore next */
  public static getAlbumGridCount(isSidebar: boolean, useAlbumDefaultScale?: boolean): number {
    Log.info(TAG, `get screen width is : ${getScreen().getWinWidth()}`);
    let diggingHoleCameraArea: DiggingHoleCameraArea | undefined = AppStorage.get('digging_hole_camera_area');
    let diggingAlbumArea = diggingHoleCameraArea?.top || diggingHoleCameraArea?.left ||
      diggingHoleCameraArea?.right || diggingHoleCameraArea?.bottom;
    let sideBarWidth = isSidebar ? Constants.TAB_BAR_WIDTH : 0;
    let winWidth = getScreen().getWinWidth();
    if (winWidth === 0) { // ScreenManager单例对象存放在LocalStorage中，获取到的结果不是永远可信的
      winWidth = getScreen().getMainWindow()?.getWindowProperties()?.windowRect?.width;
      Log.warn(TAG, `winWidth error, new value: ${winWidth}`);
    }
    let contentWidth = winWidth - sideBarWidth - (diggingAlbumArea ?? 0);
    let gridNum = Constants.gridLargeNum;
    let gridColumnsCount = 0;
    const scale: number = useAlbumDefaultScale ? UiUtil.albumDefaultScale :
      AppStorage.get<number>(Constants.albumScreenScale) ?? UiUtil.albumDefaultScale;
    if (scale >= UiUtil.albumLargeScale) {
      gridNum = Constants.gridLargeNum;
    } else {
      gridNum = Constants.gridSmallNum;
    }
    gridColumnsCount =
      Math.round(UiUtil.MIN_DP_GRID_NUM * (contentWidth / UiUtil.minDpNum - UiUtil.DEFAULT_NUM) + gridNum);
    if (gridColumnsCount <= 0) {
      Log.error(TAG, `gridColumnsCount calculate error, ${winWidth}, ${sideBarWidth}, ${diggingAlbumArea ?? 0}`);
      gridColumnsCount = gridNum;
    }
    Log.info(TAG, `gridColumnsCount=${gridColumnsCount}, contentWidth=${contentWidth}, gridNum=${gridNum}`);
    return gridColumnsCount;
  }

  /**
   * 人像宫格显示数量
   * 统一按照公式计算向上取整
   * @param photoGridNum 初始宫格数量
   * @returns
   */
  /* instrument ignore next */
  public static initPortraitGridRowCount(photoGridNum: number): number {
    let gridColumnsCount: number = photoGridNum;
    let winWidth: number = getScreen().getWinWidth();
    let contentWidth: number = winWidth;
    /* instrument ignore next */
    if (DeviceInfo.isPcOrTablet()) {
      let diggingHoleCameraArea: DiggingHoleCameraArea = ScreenManager.getInstance().getDiggingHoleCameraArea();
      let diggingAlbumArea: number = diggingHoleCameraArea.top || diggingHoleCameraArea.left ||
      diggingHoleCameraArea.right || diggingHoleCameraArea.bottom || 0;
      let sideBarWidth: number = ActionBarVar.isShowSideBar ? Constants.TAB_BAR_WIDTH : 0;
      contentWidth = winWidth - sideBarWidth - diggingAlbumArea;
    }
    let griNum: number = Math.ceil(UiUtil.MIN_DP_GRID_NUM *
      (contentWidth / UiUtil.minDpNum - UiUtil.DEFAULT_NUM) + photoGridNum);
    if (griNum > 0) {
      gridColumnsCount = griNum;
    }
    Log.info(TAG, `portraitGridColumnsCount=${gridColumnsCount}, photoGridNum=${photoGridNum}`);
    return gridColumnsCount;
  }

  /**
   * 获取分类拍摄相册主页面宫格布局列的个数
   *
   * @returns 宫格布局列的个数
   */
  public static getSmartAlbumGridCount(): number {
    let diggingHoleCameraArea: DiggingHoleCameraArea | undefined = AppStorage.get('digging_hole_camera_area');
    let diggingAlbumArea = diggingHoleCameraArea?.top || diggingHoleCameraArea?.left ||
      diggingHoleCameraArea?.right || diggingHoleCameraArea?.bottom;
    let winWidth = getScreen().getWinWidth();
    let contentWidth = winWidth - (diggingAlbumArea ?? 0);
    let gridColumnsCount = 0;
    gridColumnsCount =
      Math.round(UiUtil.MIN_DP_GRID_NUM * (contentWidth / UiUtil.minDpNum - UiUtil.DEFAULT_NUM) +
      Constants.gridSmallNum);
    return gridColumnsCount;
  }

  public static resetGeometryTransitionParams(): void {
    LocalStorage.getShared()?.setOrCreate<number>('geometryScale', 1);
    LocalStorage.getShared()?.setOrCreate<number>('geometryOffsetX', 0);
    LocalStorage.getShared()?.setOrCreate<number>('geometryOffsetY', 0);
    LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 1);
  }

  /**
   * 计算宫格公式
   *
   * @param photoGridNum 规格
   */
  public static palaceLatticeFormula(photoGridNum: number): number {
    /* instrument ignore next */
    const contentWidth = getScreen().getWinWidth();
    if (DeviceInfo.isTablet() &&
      (getScreen().isFullModeReal() || AppStorage.get<boolean>('windowPcmodeSwitchStatus'))) {
      //图库应用宽度
      let winRealWidth = vp2px(getScreen().getWinLayoutWidth());
      //屏幕宽度
      let winWidth: number = getScreen().getDisplayWidth();
      if (winRealWidth > winWidth) {
        winRealWidth = winWidth;
      }
      const griPadNum: number = Math.ceil(2 * (winRealWidth / UiUtil.minPadDpNum - 1) + photoGridNum);
      return griPadNum;
    }
    const griNum: number = Math.round(2 * (contentWidth / UiUtil.minDpNum - 1) + photoGridNum);
    Log.info(TAG, `gridNum of column: ${griNum}`);
    return griNum;
  }

  public static updateGeometryTapInfo(geometryTapIndex: number, geometryTransitionString: string): void {
    LocalStorage.getShared()?.setOrCreate<number>('placeholderIndex', geometryTapIndex);
    LocalStorage.getShared()?.setOrCreate<string>('geometryReuseId', `geometryReuseId_${geometryTapIndex}`);
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', geometryTransitionString);
    Log.info(TAG, 'UiUtil.geometryTransitionId = ' + geometryTransitionString +
      ', placeholderIndex = ' + geometryTapIndex);
  }

  public static getGeometryTransitionUri(
    geometryTransitionBrowserId: string, geometryTransitionUri: string, broadCast: BroadCast): string {
    Log.info(TAG, '[GeometryLogger] getGeometryTransitionUri start ' +
      ` , geometryTransitionUri: ${geometryTransitionUri}` +
      ` , geometryTransitionBrowserId: ${geometryTransitionBrowserId}`);
    if (geometryTransitionBrowserId === '') {
      broadCast.emit(geometryTransitionUri + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, ['']);
      return '';
    }
    let uriStartIndex = geometryTransitionBrowserId.indexOf('/');
    let uriEndIndex = geometryTransitionBrowserId.length;
    let uri = geometryTransitionBrowserId.substring(uriStartIndex, uriEndIndex);
    Log.info(TAG, '[GeometryLogger] getGeometryTransitionUri, ' +
      `, geometryTransitionBrowserId: ${geometryTransitionBrowserId}` +
      `, uriStartIndex=${uriStartIndex}, uriEndIndex=${uriEndIndex}, uri=${uri}`);
    if (geometryTransitionUri !== '' && geometryTransitionUri !== uri) {
      broadCast.emit(geometryTransitionUri + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, ['']);
    }
    Log.info(TAG, `[GeometryLogger] getGeometryTransitionUri, trigger onGeometryIdChange of ${uri}`);
    broadCast.emit(uri + Constants.KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT, [geometryTransitionBrowserId]);
    return uri;
  }

  public static emitByPlaceholderIndex(placeholderIndex: number, dataSource: MediaDataSource | undefined,
    broadCast: BroadCast, pageName: string ,browserControllerId?: number): void {
    // instrument ignore else
    if (placeholderIndex >= 0) {
      let viewData: ViewData | undefined = dataSource?.getWrappedData(placeholderIndex);
      if (viewData?.mediaItem) {
        Log.info(TAG, `[GeometryLogger] emitByPlaceholderIndex placeholderIndex=${placeholderIndex}, isTap=true`);
        broadCast.emit(viewData.mediaItem.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + pageName, [true]);
      }

      let leftData: ViewData | undefined = dataSource?.getWrappedData(placeholderIndex - 1);
      if (leftData?.mediaItem) {
        broadCast.emit(leftData.mediaItem.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + pageName, [false]);
      }

      let rightData: ViewData | undefined = dataSource?.getWrappedData(placeholderIndex + 1);
      if (rightData?.mediaItem) {
        broadCast.emit(rightData.mediaItem.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + pageName, [false]);
      }
      // 一键成片场景，连续生成了2张图，规避白图问题
      let rightDataTwo: ViewData | undefined = dataSource?.getWrappedData(placeholderIndex + 2);
      /* instrument ignore if */
      if (rightDataTwo?.mediaItem) {
        broadCast.emit(rightDataTwo.mediaItem.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + pageName, [false]);
      }
    } else {
      let pos = -placeholderIndex - 1;
      let viewData: ViewData | undefined = dataSource?.getWrappedData(pos);
      if (viewData?.mediaItem) {
        broadCast.emit(viewData.mediaItem.uniqueId + Constants.KEY_OF_PLACE_HOLDER_INDEX + pageName, [false]);
      }
    }
  }

  /**
   * 计算目标资源在宫格中的行位并屏蔽重复结果
   * @param placeholderIndex 资源索引
   * @param dataSource 宫格资源集合
   * @param gridRowCount 每行资源数
   * @param lastRow 上一次的行数
   * @param offset 结果偏移
   * @param offset.row 行偏移
   * @param offset.col 列偏移
   * @returns
   */
  public static getCurrentRow(placeholderIndex: number, dataSource: MediaDataSource,
    gridRowCount: number, lastRow: number, offset: CurrentRowOffset = { row: 0, col: 0 }):
  number | undefined {
    // instrument ignore if
    if (placeholderIndex < 0 || gridRowCount < 1) {
      return undefined;
    }
    const viewData = dataSource?.getWrappedData(placeholderIndex);
    const index = dataSource?.getDataIndex(viewData?.mediaItem);
    if (index !== Constants.NOT_FOUND) {
      const curRow = Math.floor(index + offset.col / gridRowCount) + offset.row;
      Log.debug(TAG, 'onPlaceholderChanged curRow is ' + curRow + ` lastRow ${lastRow}`);
      if (curRow !== lastRow) {
        return curRow;
      }
    }
    return undefined;
  }

  public static getCurrentCol(placeholderIndex: number,
    dataSource: MediaDataSource, gridColCount: number, lastCol: number):
  number | undefined {
    /* instrument ignore if */
    if (placeholderIndex < 0) {
      return undefined;
    }
    const viewData = dataSource?.getWrappedData(placeholderIndex);
    const index = dataSource?.getDataIndex(viewData?.mediaItem);
    if (index !== Constants.NOT_FOUND) {
      const curCol = Math.floor(index / gridColCount);
      Log.debug(TAG, `onPlaceholderChanged curCol is ${curCol}, lastCol ${lastCol}`);
      if (curCol !== lastCol) {
        return curCol;
      }
    }
    return undefined;
  }

  public static getRouterParams(params: Object): Object {
    let fakeRouterParam: Object | undefined = AppStorage.get<Object>('fakeRouterParam');
    AppStorage.delete('fakeRouterParam');
    if (fakeRouterParam) {
      Log.debug(TAG, `fakeRouterParam = ${JSON.stringify(fakeRouterParam)}`);
    }
    if (params) {
      Log.debug(TAG, `params = ${JSON.stringify(params)}`);
    }
    return params || fakeRouterParam;
  }

  public static isActionArrayEqual(firstList: Action[], secondList: Action[]): boolean {
    if (firstList === secondList) {
      return true;
    }
    if (firstList.length !== secondList.length) {
      return false;
    }
    for (let index = 0; index < firstList.length; index++) {
      if (!firstList[index].equals(secondList[index])) {
        return false;
      }
    }
    return true;
  }

  /* instrument ignore next */
  public static getDisplayNameResourceByAlbumInfo(albumInfo: AlbumInfo): Resource | undefined {
    if (albumInfo.isPhotoAlbum) {
      return $r('app.string.album_photos');
    } else if (albumInfo.isFavorAlbum) {
      return $r('app.string.album_favor');
    } else if (albumInfo.isVideoAlbum) {
      return $r('app.string.album_video');
    } else if (albumInfo.isTrashAlbum) {
      return $r('app.string.album_recycle');
    } else if (albumInfo.isScreenShotAlbum) {
      return $r('app.string.album_screen_shot');
    }
    Log.debug(TAG, `DisplayNameResourceByAlbumInfo empty:${albumInfo.toString()}`);
    return undefined;
  }

  /**
   * 用于检查该文件是否可以编辑，用于控制编辑菜单是否灰化
   *
   * @param mediaItem 被检测的媒体
   *
   * @returns true 可以编辑，false 不可以编辑
   */
  public static async isEditedEnable(mediaItem?: MediaItem): Promise<boolean> {
    if (mediaItem?.mediaType !== UserFileManagerAccess.MEDIA_TYPE_IMAGE &&
      mediaItem?.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      Log.warn(TAG, `the mediaType is invalid, the type is ${mediaItem?.mediaType}`);
      return false;
    }
    try {
      if (!await mediaItem?.isEditable()) {
        Log.warn(TAG, 'isUnEditable');
        return false;
      }
    } catch (error) {
      Log.error(TAG, `get isEditable failed: ${error}, code: ${error?.code}`);
      return false;
    }

    if (mediaItem.size === undefined || mediaItem.size === 0) {
      Log.warn(TAG, `the size is invalid, the size is ${mediaItem.size}`);
      return false;
    }
    if (!UiUtil.isEditedWidthAndHeight(mediaItem)) {
      return false;
    }
    if (mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO &&
      (mediaItem.duration === undefined || mediaItem.duration === 0)) {
      Log.warn(TAG, `the duration is invalid, the duration is ${mediaItem.duration}`);
      return false;
    }
    return true;
  }

  /* 用于检查该图片是否可以编辑
  * @param mediaItem 被检测的媒体
  * @returns isSupport: true 可以编辑，false 不可以编辑; reason: 原因
  */
  /* instrument ignore next */
  public static isImageEditedEnable(
    mediaItem?: MediaItem, hasWrite: boolean = true): Record<string, string | boolean | undefined> {
    if (!hasWrite) {
      return { 'url': mediaItem?.uri, 'isSupport': false, 'reason': 'PERMISSION' };
    }
    if (mediaItem && !mediaItem.isEditableType?.()) {
      return { 'url': mediaItem.uri, 'isSupport': false, 'reason': 'TYPE' };
    }
    if (mediaItem?.size === undefined || mediaItem?.size === 0) {
      return { 'url': mediaItem?.uri, 'isSupport': false, 'reason': 'SIZE' };
    }
    if (!UiUtil.isEditedWidthAndHeight(mediaItem)) {
      return { 'url': mediaItem.uri, 'isSupport': false, 'reason': 'WIDTH_HEIGHT' };
    }
    if (!mediaItem?.data) {
      return { 'url': mediaItem.uri, 'isSupport': false, 'reason': 'DATA' };
    }
    return { 'url': mediaItem.uri, 'isSupport': true, 'reason': '' };
  }

  public static isEditedWidthAndHeight(mediaItem: MediaItem): boolean {
    if (mediaItem.width === undefined || mediaItem.width === 0) {
      if (mediaItem.width === 0 && mediaItem?.coverWidth !== 0) {
        Log.info(TAG, `the coverWidth is ${mediaItem?.coverWidth}`);
        mediaItem.width = mediaItem?.coverWidth;
      } else {
        Log.warn(TAG, `the width is invalid, the width is ${mediaItem.width}`);
        return false;
      }
    }
    if (mediaItem.height === undefined || mediaItem.height === 0) {
      if (mediaItem.height === 0 && mediaItem?.coverHeight !== 0) {
        Log.info(TAG, `the coverHeight is ${mediaItem?.coverHeight}`);
        mediaItem.height = mediaItem?.coverHeight;
      } else {
        Log.warn(TAG, `the height is invalid, the height is ${mediaItem.height}`);
        return false;
      }
    }
    return true;
  }

  private static supportedSourcesFormats: Array<string> = [];

  public static getSupportedSourcesFormats(): Array<string> {
    return UiUtil.supportedSourcesFormats;
  }

  public static setSupportedSourcesFormats(formats: Array<string>) {
    UiUtil.supportedSourcesFormats = formats;
  }

  private static getResourceManager(src: string =
  'photosAbilityContext'): resourceManager.ResourceManager | undefined {
    const resourceManager: resourceManager.ResourceManager | undefined =
      LocalStorage.getShared()?.get<common.UIAbilityContext>(src)?.resourceManager;
    if (resourceManager === undefined) {
      Log.error(TAG,
        JSON.stringify({ context: LocalStorage.getShared()?.get<common.UIAbilityContext>(src), resourceManager }));
    }
    return resourceManager;
  }

  /**
   * 用于获取弹窗适配宽度
   */
  /* instrument ignore next */
  public static getDialogWidth(): number {
    let windowWidth: number = getScreen().getWinWidth();
    let windowHeight: number = getScreen().getWinHeight();
    let columnTotal: number = getScreen().getScreenColumns();
    let useColum: number = 4;

    if (columnTotal === UiUtil.columTotalFour) {
      if (windowWidth / windowHeight > UiUtil.aspectRatioFour) {
        useColum = UiUtil.columCountThree;
      } else {
        useColum = UiUtil.columCountFour;
      }
    } else if (columnTotal === UiUtil.columTotalEight) {
      if (windowWidth / windowHeight > UiUtil.aspectRatioEight) {
        useColum = UiUtil.columCountFour;
      } else {
        useColum = UiUtil.columCountFive;
      }
    } else if (columnTotal === UiUtil.columTotalTwelve) {
      // instrument ignore next
      if (windowWidth / windowHeight > UiUtil.aspectRatioTwelve) {
        useColum = UiUtil.columCountFive;
      } else {
        useColum = UiUtil.columCountSix;
      }
    }
    Log.info(TAG, `columnTotal: ${columnTotal} useColum:${useColum}} resultWidth:${getScreen()
      .getColumnsWidth(useColum)}`);
    return getScreen().getColumnsWidth(useColum);
  }

  /**
   * 生成复用节点的关键值：将需要复用的节点按照关键值分类，提高复用性能
   *
   * @param pageName 当前页面的标签
   * @param item 懒加载中的节点
   * @param geometryTransitionBrowserId 共享元素关键字
   * @returns 复用关键值。undefined：不复用，走正常节点创建流程；页面标签VideoNode: 视频类节点；页面标签ImageNode：照片类节点
   */
  public static generateReuseId(pageName: string, item: ViewData, geometryTransitionBrowserId: string):
  string | undefined {
    let tempTransitionId: string = LocalStorage.getShared()?.get<string>('geometryTransitionBrowserId') as string;

    // 共享元素节点不参与复用
    // instrument ignore if
    if (geometryTransitionBrowserId && tempTransitionId && geometryTransitionBrowserId === tempTransitionId) {
      return undefined;
    }

    let reuseId: string = '';
    reuseId += pageName;
    if (!(item?.mediaItem?.thumbnail) && !(item?.simpleMediaItem?.getThumbnailUri())) {
      // 无效节点使用EmptyNode 参与节点复用
      return `${reuseId}EmptyNode`;
    }
    let videoMediaType: string =
      item.mediaItem?.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ? 'video' : 'image';
    return `${reuseId}ImageNode:${videoMediaType}`;
  }

  //判断xxx平板
  public static isNeedDialogBottom(isSidebar: boolean, isFoldExpanded: boolean): boolean {
    return isSidebar || DeviceInfo.isTablet() || isFoldExpanded || DeviceInfo.isTv();
  }

  // 单复数字串转string
  public static getPluralStringSync(resource: Resource, value: number): string {
    if (resource.moduleName === 'browserlibrary') {
      return UiUtil.getResourceManager('photoLibraryContext')?.getPluralStringValueSync(resource.id, value) ?? '';
    }
    return UiUtil.getResourceManager()?.getPluralStringValueSync(resource.id, value) ?? '';
  }

  /* instrument ignore next */
  public static stringify(src: Resource | string): string {
    let display: string = '';
    if (typeof src !== 'string') {
      display = UiUtil.getResourceStringSync(src);
    } else {
      display = src;
    }
    return display;
  }

  // 触发震动
  public static touchVibrate(type: VibrateType): void {
    try {
      let vibrateParam: string = '';
      if (type === VibrateType.ALBUM) {
        vibrateParam = 'haptic.long_press_light';
      } else if (type === VibrateType.IMAGE) {
        vibrateParam = 'haptic.long_press_medium';
      } else {
        Log.error(TAG, 'unexpected vibrate type');
      }
      Log.info(TAG, `vibrate effectId param: ${vibrateParam}`);
      vibrator.startVibration({
        type: 'time',
        duration: 100,
      }, {
        id: 0,
        usage: 'touch',
      }, (error: BusinessError) => {
        if (error) {
          /* instrument ignore next */
          Log.error(TAG, `Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        Log.info(TAG, 'Succeed in starting vibration.');
      });
    } catch (error) {
      /* instrument ignore next */
      Log.error(TAG, `touchVibrate error: ${error}`);
    }
  }

  /* instrument ignore next */
  public static getGridScreenInfo(): GridScreenInfo {
    let info: GridScreenInfo = new GridScreenInfo();
    let isHorizontal: boolean = isOrientationHorizontal();
    // instrument ignore else
    /* instrument ignore next */
    if (DeviceInfo.isFoldablePhone()) {
      /* instrument ignore next */
      if (DeviceInfo.isFoldable()) {
        info.screenGridColNum = isHorizontal ?
        UiUtil.GRID_COL_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL : UiUtil.GRID_COL_NUM_FOLD_PHONE_EXPANDED_VERTICAL;
        info.screenGridRowNum = isHorizontal ?
        UiUtil.GRID_ROW_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL : UiUtil.GRID_ROW_NUM_FOLD_PHONE_EXPANDED_VERTICAL;
      } else {
        info.screenGridColNum = isHorizontal ?
        UiUtil.GRID_COL_NUM_FOLD_PHONE_FOLDED_HORIZONTAL : UiUtil.GRID_COL_NUM_FOLD_PHONE_FOLDED_VERTICAL;
        info.screenGridRowNum = isHorizontal ?
        UiUtil.GRID_ROW_NUM_FOLD_PHONE_FOLDED_HORIZONTAL : UiUtil.GRID_ROW_NUM_FOLD_PHONE_FOLDED_VERTICAL;
      }
      info.screenMaxGridNum = Math.max(
        UiUtil.GRID_NUM_FOLD_PHONE_EXPANDED_HORIZONTAL, UiUtil.GRID_NUM_FOLD_PHONE_EXPANDED_VERTICAL,
        UiUtil.GRID_NUM_FOLD_PHONE_FOLDED_HORIZONTAL, UiUtil.GRID_NUM_FOLD_PHONE_FOLDED_VERTICAL);
    } else if (DeviceInfo.isPhoneUx()) {
      info.screenGridColNum = isHorizontal ?
      UiUtil.GRID_COL_NUM_PHONE_HORIZONTAL : UiUtil.GRID_COL_NUM_PHONE_VERTICAL;
      info.screenGridRowNum = isHorizontal ?
      UiUtil.GRID_ROW_NUM_PHONE_HORIZONTAL : UiUtil.GRID_ROW_NUM_PHONE_VERTICAL;
      info.screenMaxGridNum = Math.max(UiUtil.GRID_NUM_PHONE_HORIZONTAL, UiUtil.GRID_NUM_PHONE_VERTICAL);
    } else if (DeviceInfo.isTablet() || DeviceInfo.isTv()) {
      info.screenGridColNum = isHorizontal ?
      UiUtil.GRID_COL_NUM_TABLET_HORIZONTAL : UiUtil.GRID_COL_NUM_TABLET_VERTICAL;
      info.screenGridRowNum = isHorizontal ?
      UiUtil.GRID_ROW_NUM_TABLET_HORIZONTAL : UiUtil.GRID_ROW_NUM_TABLET_VERTICAL;
      info.screenMaxGridNum = Math.max(UiUtil.GRID_NUM_TABLET_HORIZONTAL, UiUtil.GRID_NUM_TABLET_VERTICAL);
    } else {
      info.screenGridColNum = UiUtil.GRID_NUM_UNKNOWN;
      info.screenGridRowNum = UiUtil.GRID_NUM_UNKNOWN;
      info.screenMaxGridNum = UiUtil.GRID_NUM_UNKNOWN;
    }
    return info;
  }

  // 是否为镜像模式
  public static isMirrorMode(): boolean {
    let modeDirection: string = 'rtl';
    return Configuration.getLocale().dir === modeDirection;
  }

  /**
   * 获取ScrollBar可见状态，当前规格是不滚动2s后不可见
   * 注意：当前滚动条隐藏通过透明度变化实现，后续若控件实现方式变更，该方法会失效。
   *
   * @param elementId ScrollBar的控件id
   * @returns true=可见，false=不可见
   */
  /* instrument ignore next */
  public static isScrollBarVisible(elementId: string): boolean {
    try {
      const uiContext: UIContext = LocalStorage.getShared()?.get<UIContext>('uiContext') as UIContext;
      let node: FrameNode | null = uiContext?.getFrameNodeById(elementId);
      if (!node) {
        Log.error(TAG, `scroll bar node not found, elemId=${elementId}`);
        return false;
      }
      const opacity: number = node.getOpacity();
      Log.info(TAG, `get scroll bar visiable status, elemId=${elementId}, opacity=${opacity}`);
      return Boolean(opacity);
    } catch (err) {
      Log.error(TAG, `get scroll bar visiable status failed, elemId=${elementId}, errMsg=${err}`);
      return false;
    }
  }

  /* instrument ignore next */
  public static setDecorButtonColor(currentMode: ConfigurationConstant.ColorMode): void {
    Log.info(TAG, 'setDecorButtonColor start');
    if (!DeviceInfo.isPc()) {
      return;
    }
    /* instrument ignore next */
    let topWindow: window.Window = LocalStorage.getShared()?.get<window.Window>('mainWindow') as window.Window;
    let dectorStyle: window.DecorButtonStyle = {};
    dectorStyle.colorMode = currentMode;
    topWindow?.setDecorButtonStyle(dectorStyle);
  }

  /**
   * lite机型效果适配
   *
   * @returns false=全量效果设备，true=lite设备
   */
  /* instrument ignore next */
  public static isLiteDeviceUI(): boolean {
    // let effectStyle: number | undefined = hdsEffect.getEffectStyle();
    // let isLiteDevice: boolean = effectStyle != 0;
    // Log.info(TAG, `LiteDeviceUI effectStyle = ${effectStyle}`);
    // return isLiteDevice;
    return false
  }
}