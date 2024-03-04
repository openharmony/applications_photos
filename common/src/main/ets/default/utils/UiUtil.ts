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

import { MathUtil } from './MathUtil';
import { Constants } from '../model/common/Constants';
import { Log } from './Log';
import { ScreenManager } from '../model/common/ScreenManager';
import prompt from '@system.prompt';
import type window from '@ohos.window';
import type { Action } from '../view/browserOperation/Action';
import { AlbumInfo } from '../model/browser/album/AlbumInfo';
import common from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';
import { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import { MediaItem } from '../model/browser/photo/MediaItem';

const TAG: string = 'common_UiUtil';

type Window = window.Window;

export class UiUtil {

  /**
   * Status bar height
   */
  static readonly STATUS_BAR_HEIGHT = 45;

  /**
   * Navigation bar height
   */
  static readonly NAVI_BAR_HEIGHT = 45;

  /**
   * Hexadecimal Radix
   */
  static readonly HEX_BASE = 16;

  /**
   * Maximum order of color
   */
  static readonly MAX_COLOR_ORDER = 255;
  public static readonly TOAST_DURATION = 3000;
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
   * Set status bar color
   *
   * @param statusBarColor statusBarColor
   */
  static setStatusBarColor(topWindow: Window): void {
    topWindow.setSystemBarProperties({ navigationBarColor: '#FFF1F3F5', navigationBarContentColor: '#FF000000' },
      () => {
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
  static getHexOpacityColor(paramColor: string, paramOpacity: number): string {
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
    if (opacityStr.length == 1) {
      opacityStr = `0${opacityStr}`;
    }
    if (opacityStr.length == 0) {
      opacityStr = '00';
    }
    return `#${opacityStr + color}`;
  }

  /**
   * Get the content of the resource reference
   *
   * @param resource resource reference
   * @returns resource Corresponding content string
   */
  static async getResourceString(resource: Resource): Promise<string> {
    try {
      Log.info(TAG, `getResourceString: ${JSON.stringify(resource)}`);
      if (AppStorage.get('photosAbilityContext') === null || AppStorage.get('photosAbilityContext') === 'undefined') {
        Log.error(TAG, 'getResourceString error: context is null');
        return null;
      }
      let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
      let mgr: string = await context.resourceManager.getString(resource.id);
      if (mgr) {
        return mgr;
      } else {
        Log.error(TAG, `getResourceManager instance is none`);
        return null;
      }
    } catch (error) {
      Log.error(TAG, `getResourceString error: ${error}`);
      return null;
    }
  }

  private static getResourceManager(src: string = 'photosAbilityContext'): resourceManager.ResourceManager | undefined {
    const resourceManager: resourceManager.ResourceManager | undefined =
      AppStorage.get<common.UIAbilityContext>(src)?.resourceManager;
    if (resourceManager === undefined) {
      Log.error(TAG, JSON.stringify({ context: AppStorage.get<common.UIAbilityContext>(src), resourceManager }));
    }
    return resourceManager;
  }

  static async getResourceNumber(resource: Resource): Promise<number> {
    try {
      Log.info(TAG, `getResourceNumber: ${JSON.stringify(resource)}`);
      if (AppStorage.get('photosAbilityContext') === null || AppStorage.get('photosAbilityContext') === 'undefined') {
        Log.error(TAG, 'getResourceNumber error: context is null');
        return null;
      }
      let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
      let mgr: number = context.resourceManager.getNumber(resource.id);
      if (mgr) {
        return mgr;
      } else {
        Log.error(TAG, `getResourceNumber instance is none`);
        return null;
      }
    } catch (error) {
      Log.error(TAG, `getResourceNumber error: ${error}`);
      return null;
    }
  }

  /**
   * 用于检查该文件是否可以编辑，用于控制编辑菜单是否灰化
   *
   * @param mediaItem 被检测的媒体
   *
   * @returns true 可以编辑，false 不可以编辑
   */
  static isEditedEnable(mediaItem: MediaItem): boolean {
    if (mediaItem.mediaType !== UserFileManagerAccess.MEDIA_TYPE_IMAGE && mediaItem.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      Log.warn(TAG, 'the mediaType is invalid, the type is ' + mediaItem.mediaType);
      return false;
    }
    if (mediaItem.size === undefined || mediaItem.size === 0) {
      Log.warn(TAG, 'the size is invalid, the size is ' + mediaItem.size);
      return false;
    }
    if (mediaItem.width === undefined || mediaItem.width === 0) {
      Log.warn(TAG, 'the width is invalid, the width is ' + mediaItem.width);
      return false;
    }
    if (mediaItem.height === undefined || mediaItem.height === 0) {
      Log.warn(TAG, 'the height is invalid, the height is ' + mediaItem.height);
      return false;
    }
    if (mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO && (mediaItem.duration === undefined || mediaItem.duration === 0)) {
      Log.warn(TAG, 'the duration is invalid, the duration is ' + mediaItem.duration);
      return false;
    }
    return true;
  }

  /**
   * Get the content of the resource reference
   *
   * @param resource resource reference
   * @returns resource Corresponding content number
   */
  static getResourceNumberSync(resource: Resource): number {
    Log.info(TAG, `getResourceNumber: ${JSON.stringify(resource)}`);
    return this.getResourceManager()?.getNumber(resource.id) ?? Number.NaN;
  }

  /**
   * Get the content of the resource reference
   *
   * @param resource resource reference
   * @returns resource Corresponding content Color
   */
  static getResourceColorSync(resource: Resource): number {
    try {
      Log.info(TAG, `getResourceString: ${JSON.stringify(resource)}`);
      if (globalThis.photosAbilityContext == null || globalThis.photosAbilityContext === 'undefined') {
        Log.error(TAG, 'getResourceString error: context is null');
        return null;
      }
      let mgr = globalThis.photosAbilityContext.resourceManager.getColorSync(resource.id);
      if (mgr) {
        return mgr;
      } else {
        Log.error(TAG, `getResourceManager instance is none`);
        return null;
      }
    } catch (error) {
      Log.error(TAG, `getResourceString error: ${error}`);
      return null;
    }
  }

  static async showToast(resource: Resource): Promise<void> {
    let message = await UiUtil.getResourceString(resource);
    Log.debug(TAG, `showToast: ${message}`);
    prompt.showToast({
      message: message,
      duration: UiUtil.TOAST_DURATION,
      bottom: '64vp'
    });
  }

  /**
   * Get the content of the resource reference
   *
   * @param resource resource reference
   * @returns resource Corresponding content string
   */
  static getResourceStringSync(resource: Resource): string {
    Log.info(TAG, `getResourceString: ${JSON.stringify(resource)}`);
    if (resource.moduleName === 'browserlibrary') {
      return this.getResourceManager('photoLibraryContext')?.getStringSync(resource.id) ?? '';
    }
    return this.getResourceManager()?.getStringSync(resource.id) ?? '';
  }

  /**
   * 获取相册封面宫格布局列的个数
   *
   * @param isSidebar 是否包含侧边栏
   */
  static getAlbumGridCount(isSidebar: boolean): number {
    Log.info(TAG, `get screen width is : ${ScreenManager.getInstance().getWinWidth()}`);
    let sideBarWidth = isSidebar ? Constants.TAB_BAR_WIDTH : 0;
    let contentWidth = ScreenManager.getInstance().getWinWidth() - sideBarWidth;
    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    let gridColumnsCount = Math.max(Constants.DEFAULT_ALBUM_GRID_COLUMN_MIN_COUNT,
      Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * Constants.NUMBER_2 + Constants.ALBUM_SET_GUTTER) /
        (maxCardWidth + Constants.ALBUM_SET_GUTTER)));
    Log.info(TAG, `[getAlbumGridCount] contentWidth: ${contentWidth}, gridColumnsCount: ${gridColumnsCount}`);
    return gridColumnsCount;
  }

  static resetGeometryTransitionParams(): void {
    AppStorage.setOrCreate<number>('geometryScale', 1);
    AppStorage.setOrCreate<number>('geometryOffsetX', 0);
    AppStorage.setOrCreate<number>('geometryOffsetY', 0);
    AppStorage.setOrCreate<number>('geometryOpacity', 1);
  }

  static updateGeometryTapInfo(geometryTapIndex: number, geometryTransitionString: string): void {
    AppStorage.setOrCreate<number>('placeholderIndex', geometryTapIndex);
    AppStorage.setOrCreate<string>('geometryTransitionBrowserId',
      geometryTransitionString);
    Log.debug(TAG, 'this.geometryTransitionId = ' + geometryTransitionString +
      ', placeholderIndex = ' + geometryTapIndex);
  }

  static getRouterParams(params: Object): Object {
    let fakeRouterParam: Object = AppStorage.Get('fakeRouterParam');
    AppStorage.delete('fakeRouterParam');
    if (fakeRouterParam) {
      Log.debug(TAG, 'fakeRouterParam = ' + JSON.stringify(fakeRouterParam));
    }
    if (params) {
      Log.debug(TAG, 'params = ' + JSON.stringify(params));
    }
    return params ? params : fakeRouterParam;
  }

  static isActionArrayEqual(firstList: Array<Action>, secondList: Array<Action>): boolean {
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

  static getDisplayNameResourceByAlbumInfo(albumInfo: AlbumInfo): Resource {
    let res: Resource = null;
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
    } else {
      return res;
    }
  }
}