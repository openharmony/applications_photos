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

import lazy { Action, ActionID } from './Action';
import lazy { MenuContext } from './MenuContext';
import lazy { MenuConstants } from '../actionbar/Menu';
import type { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants, Condition } from '../../model/common/BroadCastConstants';
import lazy { Log } from '../../utils/Log';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Constants } from '../../model/common/Constants';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { CommonUtil } from '../../utils/CommonUtil';
import lazy { BigDataConstants } from '../../utils/ReportToBigDataUtil';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { MenuOptionOtherParams } from './interfaces';
import lazy { Region } from '../../model/common/DataTypes';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { PrintUtil } from '../../utils/PrintUtil';

const TAG: string = 'menuOption';

/**
 * @deprecated
 */
export interface MenuOptionOtherParamsDeprecated {
  isFromPortrait?: boolean,
  albumUri?: string,
  uri?: string
  // 待操作文件是否为连拍封面
  isBurstPhotos?: boolean;

  // 待操作的连拍封面对应的一组连拍
  burstPhotos?: MediaItem[];

  // 保存连拍时删除原连拍，不需要删除弹窗
  isSkipDeleteDialog?: boolean;
}

function doOtherParams(selected: SelectManager | MediaItem |
undefined, menuContext: MenuContext, otherParams?: MenuOptionOtherParams): void {
  if (otherParams) {
    menuContext.set(MenuContextConstants.MENU_OPTION_OTHER_PARAMS, otherParams);
    /* instrument ignore if */
    if (otherParams?.isRename && selected instanceof MediaItem) {
      menuContext.withMediaItem(selected);
    }
    /* instrument ignore if */
    if (otherParams?.isFromGalleryCleanup) {
      if (selected instanceof MediaItem) {
        menuContext.withMediaItem(selected);
      } else if (selected instanceof SelectManager) {
        const mediaArray: MediaItem[] = Array.from(selected.selectedMap.values());
        if (mediaArray.length === 1) {
          menuContext.withMediaItem(mediaArray[0]);
        }
      }
      menuContext.withFromPage(Constants.GRID_CLEANUP_PAGE);
    }
  }
  if (otherParams?.isBurstPhotos && otherParams?.burstPhotos) {
    menuContext.withBurstPhotos(otherParams.burstPhotos);
  }
  if (otherParams?.isSkipDeleteDialog) {
    menuContext.setSkipDeleteDialog(otherParams.isSkipDeleteDialog);
  }
  if (otherParams?.sortHelper) {
    menuContext.set(MenuConstants.KEY_SORT_HELPER, otherParams.sortHelper);
  }
  if (otherParams?.isFromHighlight) {
    menuContext.withHighlight(true);
  }
}

export function menuOption(actionID: number, selected: SelectManager | MediaItem |
undefined, broadCast: BroadCast, albumInfo?: AlbumInfo, operationPosition?: number, currentPage?:
  string, otherParams?: MenuOptionOtherParams, pageFrom?: string, isLongPress?: boolean): void {
  if (!selected) {
    Log.error(TAG, 'currentPhoto is undefined.');
    return;
  }
  let menuContext = new MenuContext().withSelectManager(selected).withBroadCast(broadCast).withAlbumInfo(albumInfo);
  Log.info(TAG,
    `menuOption, action: ${ActionID[actionID]}, fromSelectMode: ${menuContext.fromSelectMode}, uri: ${albumInfo?.uri}`);
  if (currentPage) {
    menuContext.withFromPage(currentPage);
  }
  if (pageFrom) {
    menuContext.withPageFrom(pageFrom);
  }
  if (isLongPress) {
    menuContext.withFromLongPress(isLongPress);
  }
  doOtherParams(selected, menuContext, otherParams);
  if (actionID === Action.PRINT.actionID) {
    publicPrint(menuContext, selected, albumInfo);
    return;
  } else if (actionID === Action.REMOVE_FROM_GROUP.actionID) {
    menuContext.withAlbumUri(albumInfo?.uri).operate(actionID)
    if (selected instanceof MediaItem) {
      menuContext.withMediaItem(selected)
    }
    return;
  }
  menuContext.withAlbumInfo(albumInfo).fromSelectMode && menuContext.withOperationEndCallback((): void => {
    broadCast.emit(BroadCastConstants.RIGHT_CLICK, [actionID, Condition.END]);
    if (actionID === Action.NOT_FAVORITE.actionID || actionID === Action.FAVORITE.actionID) {
      !(selected instanceof MediaItem) && selected.resetUnFavorItemCount(actionID === Action.NOT_FAVORITE.actionID);
    }
  }).withOperationStartCallback((): void => {
    broadCast.emit(BroadCastConstants.RIGHT_CLICK, [actionID, Condition.START]);
  });
  handleOtherCase(actionID, menuContext, currentPage);
}

/* instrument ignore next */
export function menuHighlightOption(actionID: number, broadCast: BroadCast, otherParams?: MenuOptionOtherParams): void {
  let menuContext = new MenuContext().withBroadCast(broadCast);
  if (otherParams) {
    menuContext.set(MenuContextConstants.MENU_OPTION_OTHER_PARAMS, otherParams);
  }
  menuContext
    .withBroadCast(broadCast)
    .operate(actionID);
  return;
}

function handleOtherCase(actionID: number, menuContext: MenuContext, currentPage?: string): void {
  switch (actionID) {
    case Action.LONG_PRESS_DELETE.actionID:
    case Action.DELETE.actionID:
    case Action.CLEAR_RECYCLE.actionID:
    case Action.RECOVER.actionID:
      menuContext.withAlbumUri(UserFileManagerAccess.getRecycleBinUri());
      break;
    case Action.REMOVE_FROM.actionID:
    case Action.REMOVE_FROM_LARGE.actionID:
    case Action.RENAME.actionID:
    case Action.NOT_FAVORITE.actionID:
      menuContext.withTargetFavorStatus(true);
      break;
    case Action.FAVORITE.actionID:
      menuContext.withTargetFavorStatus(false);
      break;
    default:
      Log.error(TAG, 'action: ' + ActionID[actionID] + ' not implemented');
      return;
  }
  menuContext.operate(actionID);
}

function publicPrint(menuContext: MenuContext, selected: SelectManager | MediaItem, albumInfo?: AlbumInfo): void {
  if (menuContext.fromSelectMode) {
    menuContext.selectManager?.getSelectedItems((selectedItems: MediaItem[]) => {
      Log.info(TAG, 'multiplePrint start');
      PrintUtil.multiplePrint(selectedItems, {
        printTriggerPlace: BigDataConstants.PHOTO_PRINT_GRID_POSITION,
        printTriggerType: 0,
      })
    });
    return;
  }
  const currentPhoto = selected as MediaItem;
  if (currentPhoto) {
    Log.info(TAG, 'singlePrint start');
    PrintUtil.singlePrint(currentPhoto, {
      printTriggerPlace: BigDataConstants.PHOTO_PRINT_BIG_PICTURE_POSITION,
      printTriggerType: 0,
    })
  }
}