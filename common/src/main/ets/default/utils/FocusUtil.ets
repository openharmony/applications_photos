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
import lazy { Log } from './Log';
import lazy { FocusController } from '@ohos.arkui.UIContext';
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { FocusCtrlManager } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { ShortCut } from '../model/ShortCut';
import lazy { MediaDataSource } from '../model/browser/photo/MediaDataSource';
import lazy { Constants } from '../model/common/Constants';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { ImageUtil } from './ImageUtil';

const TAG: string = 'common_FocusUtil';

export namespace FocusUtil {
  export function requestFocus(focusController: FocusController, key: string): void {
    try {
      focusController?.requestFocus(key);
      focusController?.activate(true, true);
    } catch (err) {
      Log.error(TAG, 'request focus error');
    }
  }

  export function clearFocus(focusController: FocusController): void {
    try {
      focusController?.clearFocus();
    } catch (err) {
      Log.error(TAG, 'clear focus error');
    }
  }

  export function setFocusState(focusController: FocusController, startIndex: number, lastIndex: number): void {
    try {
      if (!DeviceInfo.isPc()) {
        return;
      }
      let focusItemIndex = FocusCtrlManager.getInstance().getFocusItemIndex();
      if (focusItemIndex &&
        (focusItemIndex - 1 < startIndex || focusItemIndex - 1 > lastIndex)) {
        focusController?.clearFocus();
        FocusCtrlManager.getInstance().setFocusItemIndex(undefined);
      }
    } catch (err) {
      Log.error(TAG, 'set focus state error');
    }
  }

  export function activateFocus(focusController: FocusController): void {
    try {
      if (!DeviceInfo.isPc()) {
        return;
      }
      focusController?.activate(true, true);
    } catch (err) {
      Log.error(TAG, 'activate focus error');
    }
  }

  function calDeleteCountBeforeFocus(indexs: number[], focusItemIndex: number): void {
    let focusManager = FocusCtrlManager.getInstance();
    for (let i of indexs) {
      focusManager.setDeleteCountBeforeFocus(focusManager.getDeleteCountBeforeFocus() + 1);
      if (i === focusItemIndex - 1) {
        return;
      }
    }
  }

  export function setFocusOfDelete(dataSource: MediaDataSource, indexs: number[], uris: string[],
    firstIndex: number, lastIndex: number): void {
    let totalCount: number = dataSource?.totalCount() ?? 0;
    let focusManager = FocusCtrlManager.getInstance();
    if (totalCount - indexs.length <= 0) {
      focusManager.setFocusItemIndex(undefined);
      return;
    }
    indexs.sort((a, b) => {
      return a - b
    });
    let startIndex: number = indexs[0];
    let endIndex: number = indexs[indexs.length - 1];
    Log.info(TAG, `get focus info,totalCount: ${totalCount}, startIndex: ${startIndex}，endIndex: ${endIndex}`);
    Log.info(TAG, `get focus info,firstIndex: ${firstIndex}, lastIndex: ${lastIndex}`);
    // 判断删除的照片是否在视图内（删除图片全部在视图前面或者删除图片全部在视图后面）
    if (firstIndex > endIndex || lastIndex < startIndex) {
      Log.info(TAG, `not get focus item`);
      focusManager.setFocusItemIndex(undefined);
      return;
    }
    // 当滑动导致部分选中的图片看不见时视图内的第一个图片位置会大于选择的第一个图片位置
    if (firstIndex > startIndex) {
      let i: number = firstIndex;
      // 获取视图内选择的第一个图片位置
      for (; i <= endIndex && i <= lastIndex; i++) {
        let item: MediaItem | undefined = dataSource?.getMediaItemSafely(i);
        if (uris.indexOf(item?.uri ?? '') !== -1) {
          startIndex = i;
          break;
        }
      }
      // 判断删除的照片是否在视图内（删除图片一部分在视图前面，另一部分在视图后面）
      if (i === lastIndex + 1) {
        Log.info(TAG, `not get focus item`);
        focusManager.setFocusItemIndex(undefined);
        return;
      }
    }
    // 寻找视图内选择的第一个图片位置后面第一个未选中的图片位置
    for (let i: number = startIndex + 1; i < totalCount && i <= endIndex + 1; i++) {
      let item: MediaItem | undefined = dataSource?.getMediaItemSafely(i);
      if (uris.indexOf(item?.uri ?? '') === -1) {
        focusManager.setFocusItemIndex(i);
        calDeleteCountBeforeFocus(indexs, focusManager.getFocusItemIndex() ?? i);
        return;
      }
    }
    // 不满足上面条件说明连续选中后面1个或者多个图片
    focusManager.setFocusItemIndex(startIndex - 1);
  }

  export function requestGridFocus(focusController: FocusController, dataSource: MediaDataSource, pageName: string,
    isFromPortraitCoverSet: boolean): boolean {
    if (ShortCut.deleteDialogOpenFlag || !DeviceInfo.isPc()) {
      return false;
    }
    let focusManager = FocusCtrlManager.getInstance();
    Log.info(TAG, `grid focusItemIndex: ${focusManager.getFocusItemIndex()}`);
    if (focusManager.getFocusItemIndex() === undefined) {
      focusController?.clearFocus();
      focusManager.setFocusItemUri('');
      return true;
    }
    let targetItem: MediaItem = dataSource?.getMediaItemSafely(focusManager.getFocusItemIndex() ?? 0);
    let imageThumbnail: string = '';
    if (pageName === Constants.PHOTO_ARTGRIDPAGE) {
      imageThumbnail = ImageUtil.getLCDUri(targetItem?.uri, targetItem?.path, targetItem?.getDateModified());
    } else {
      imageThumbnail = targetItem?.thumbnail ?? '';
    }
    if (isFromPortraitCoverSet) {
      focusManager.setFocusItemKey(pageName + 'Cover' + '_GridItem' + imageThumbnail);
    } else {
      focusManager.setFocusItemKey(pageName + '_GridItem' + imageThumbnail);
    }
    Log.info(TAG, `get focusItemKey: ${focusManager.getFocusItemKey()}`);
    focusController?.requestFocus(focusManager.getFocusItemKey());
    focusController?.activate(true, true);
    focusManager.setFocusItemUri(targetItem?.uri);
    return true;
  }
}