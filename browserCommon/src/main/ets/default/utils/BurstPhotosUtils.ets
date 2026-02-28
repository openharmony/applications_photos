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
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MenuOptionOtherParams } from '@ohos/common/src/main/ets/default/view/browserOperation/interfaces';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import type { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

const TAG = 'BurstPhotosUtils';

export class BurstPhotosUtils {
  // 长按图片悬浮菜单对连拍照片操作（隐藏，删除，添加到，移出相册）进行特殊处理
  public async longPressHandleBurstPhotos(actionID: number, currentPhoto: MediaItem, dataSource: MediaDataSource,
    broadCast: BroadCast, albumInfo?: AlbumInfo): Promise<void> {
    if (!dataSource) {
      Log.debug(TAG, 'handleBurstPhotos without dataSource');
      return;
    }
    if (!currentPhoto || !currentPhoto?.burstKey) {
      Log.debug(TAG, 'handleBurstPhotos without burstKey');
      return;
    }
    const items: MediaItem[] = await dataSource.getMediaItemsByBurstKey(currentPhoto.burstKey, albumInfo?.isTrashAlbum);
    Log.info(TAG, `longPressHandleBurstPhotos burstkey: ${currentPhoto.burstKey}, items.length: ${items?.length}`)
    let otherParams: MenuOptionOtherParams = {
      uri: currentPhoto?.uri,
      isBurstPhotos: true,
      burstPhotos: items,
      isSkipDeleteDialog: false,
    };
    menuOption(actionID, currentPhoto, broadCast, albumInfo, undefined, undefined, otherParams);
  }
}