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

import lazy { RightClickMenuGroup } from './MenuGroup';
import lazy { Log } from '../../utils/Log';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import lazy { SourceTypeAlbumDataSource } from '../../model/browser/album/SourceTypeAlbumDataSource';

/* instrument ignore file */
const TAG: string = 'MenuController';

export enum PopType {
  NORMAL,
  GRID,
  MOVE,
}

export interface MenuPopUpParams {
  onMenuClick: Function;
  type: PopType,
  // 宫格有移动到
  isSelected?: boolean;
  mediaItem?: MediaItem;
  appBroadCast?: BroadCast;
  albumUri?: string;
  albums?: AlbumSetDataSource;
  sourceTypeAlbumsDataSource?: SourceTypeAlbumDataSource;
  moveBroadCastKey?: string,
  // 宫格空白处
  isPasteboardHasData?: boolean,
  canRedo?: boolean,
  canUndo?: boolean,
  selectMediaType?: number,
  /**
   * isUseCustomShortKey,是否使用自定义的shortKey
   */
  isUseCustomShortKey?: boolean;
}

/**
 * 菜单项统一管理工具类
 * 核心逻辑是将原本根据各种条件，分类处理菜单项，改为在整个页面下： 列出所有的菜单项，对每个菜单项根据判断条件做该菜单项的显隐
 * */
@Observed
export class MenuController {
  private static uuid: number = 0;

  /**
   * 唯一id
   */
  public readonly id: number;

  /**
   * 组装后的菜单项Group数组
   */
  public menuGroupList: RightClickMenuGroup[] = [];

  @Track public menuGroupListWithoutEmpty: RightClickMenuGroup[] = [];

  constructor() {
    MenuController.uuid++;
    this.id = MenuController.uuid;
  }

  /**
   * 刷新groupList
   * @param list
   */
  public setMenuGroupList(list: RightClickMenuGroup[]): void {
    Log.info(TAG,
      `componentKeyList: ${list.map(item => item.menuList.map(action => action.componentKey)).join('; ')}`);
    this.menuGroupList = list;
    this.menuGroupListWithoutEmpty = list.filter(item => item.menuList.length > 0);
  }

  /**
   * 获取所有list
   * @returns
   */
  public getMenuGroupList(): RightClickMenuGroup[] {
    Log.info(TAG,
      `getMenuGroupList menuGroupList: ${this.menuGroupList.map(item => item.key).join(',')}`);
    return this.menuGroupList;
  }

  /**
   * 获取group不为空的list
   * @returns
   */
  public getMenuGroupListWithoutEmpty(): RightClickMenuGroup[] {
    return this.menuGroupListWithoutEmpty;
  }

  /**
   * 判断条件变更刷新GroupList
   *
   * @param boolListArray
   */
  public dealMenuGroup(boolListArray: boolean[][]): void {
    const newList: RightClickMenuGroup[] = [];

    for (let index = 0; index < boolListArray.length; index++) {
      const boolList: boolean[] = boolListArray[index];
      const group: RightClickMenuGroup = this.menuGroupList[index];
      if (group) {
        group.changeGroupList(boolList);
        newList.push(group);
        Log.info(TAG,
          `dealMenuGroup groupMenuList: ${group?.menuList.map(item => item.componentKey).join(',')} key: ${group.key}`);
      } else {
        Log.info(TAG, `dealMenuGroup not have group`);
      }
    }
    this.menuGroupList = newList;
    this.menuGroupListWithoutEmpty = newList.filter(item => item.menuList.length > 0);
  }

  /**
   * 刷新group
   *
   * @param boolListArray
   */
  public changeGroup(group: RightClickMenuGroup, index: number): void {
    Log.info(TAG,
      `changeGroup groupMenuList: ${group.menuList.map(item => item.componentKey).join(',')}`);
    this.menuGroupList[index] = group;
  }
}

export {
  RightClickMenuGroup,
}