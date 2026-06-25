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
/* instrument ignore file*/
import lazy { UserConstraintUtil } from './UserConstraintUtil';
import lazy { StringUtil } from './StringUtil';
import lazy systemParameter from '@ohos.systemparameter';
import lazy { Log } from './Log';
import lazy { SelectManager } from '../model/browser/SelectManager';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { Action } from '../view/browserOperation/Action';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { SystemPropertiesManager } from './SystemPropertiesManager';

const TAG: string = 'PhotoPropertiesUtil';

const SWITCH_STATE_ON: string = 'on';
const IMAGE_FORMATS = ['.png', '.jpg', '.jpeg', '.webp', '.bmp', '.raw'];

const PHOTO_PROPERTIES_PORTRAIT_ENABLE: string = 'persist.photos.properties.portrait.enable';
const CAN_SET_WALL_PAPER_COUNT = 1;

export class PhotoPropertiesUtil {
  private isSwitchOpen: boolean = false;
  private static instance: PhotoPropertiesUtil = new PhotoPropertiesUtil();

  private constructor() {
    this.initFeatureSupported();
  }

  /**
   * 是否开启大图详情页上划显示人像卡片
   * true:开启  false:关闭
   */
  private initFeatureSupported(): void {
    try {
      let param: string = systemParameter.getSync(PHOTO_PROPERTIES_PORTRAIT_ENABLE, 'on'); // 获取配置项 默认为on
      Log.info(TAG, `photoProperties showPortrait param: ${param}`);
      this.isSwitchOpen = StringUtil.size(param) !== 0 && param === SWITCH_STATE_ON;
      Log.info(TAG, `photoProperties showPortrait switch: ${this.isSwitchOpen}`);
    } catch (e) {
      Log.info(TAG, `getSync unexpected error: ${this.isSwitchOpen}`);
    }
  }

  public static getInstance(): PhotoPropertiesUtil {
    return PhotoPropertiesUtil.instance;
  }

  public isPortraitEnable(): boolean {
    return this.isSwitchOpen;
  }

  /**
   * 是否支持设置壁纸
   *
   * @param uri 图片uri
   * @returns boolean
   * isConstraintUserModifyWallpaper 企业定制是否约束用户设置壁纸
   */
  public static isValidFormatToSetWallPaper(uri: string | undefined): boolean {
    if (!uri || UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      Log.info(TAG, `Input uri is not support`);
      return false;
    }
    return IMAGE_FORMATS.some(format => uri.toLowerCase().endsWith(format));
  }

  /**
   * 添加设置壁纸菜单
   *
   * @param menuList 菜单列表
   * @param selectManager 选中项
   * @param selectedCount 选中条目
   */
  public static addSetWallPaperInList(menuList: Action[], selectManager: SelectManager, selectedCount: number): void {
    if (selectedCount > 1) {
      return;
    }
    selectManager.getSelectedItems(async (selectedItems: MediaItem[]) => {
      if (selectedItems[0].mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE &&
      PhotoPropertiesUtil.isValidFormatToSetWallPaper(selectedItems[0].uri) &&
        !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
        menuList.push(Action.SET_WALLPAPER);
      }
    });
  }

  /**
   * 判断是否可以设置为壁纸
   *
   * @param selectManager 选中项
   * @param selectedCount 选中条目
   * return boolean 是否可以设置为壁纸
   */
  public static canSetWallPaperInList(selectManager: SelectManager, selectedCount: number): boolean {
    if (selectedCount !== CAN_SET_WALL_PAPER_COUNT) {
      return false;
    }
    return PhotoPropertiesUtil.isValidFormatToSetWallPaper(selectManager.clickedSet.values().next().value);
  }
}