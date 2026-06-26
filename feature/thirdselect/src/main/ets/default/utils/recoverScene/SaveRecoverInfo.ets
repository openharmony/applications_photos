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

import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { PickerMediaDataSource } from '../../common/PickerMediaDataSource';
import { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { RecoverController } from './RecoverController';
import { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

const TAG: string = 'SaveRecoverInfo';

export const THIRD_SELECT_IS_ORIGIN: string = 'third_select_is_origin';

export class SaveRecoverInfo {
  private isRecoverInAlbumPage: boolean = false;
  private lastMediaItem: MediaItem | undefined = undefined;

  public constructor(dataSource: PickerMediaDataSource | undefined, unDataGridCount: number, loadedSize: number,
    chosenItemIndex: number, isSceneBoard: boolean) {
    this.isRecoverInAlbumPage = RecoverController.getIsRecoverInAlbumPage() ?? false;
    this.lastMediaItem =
      this.getAnchorMediaItem(dataSource, unDataGridCount, loadedSize, chosenItemIndex, this.isRecoverInAlbumPage,
        isSceneBoard);
  }

  public getAlbumUri(): string {
    return RecoverController.getRecoverAlbumUri() ?? Constants.PICKER_ALL_PHOTOS_SHEET;
  }

  public async getTime(albumUri: string): Promise<number> {
    let isOrderByDateTaken: boolean = false;
    let orderProp: string = '';
    Log.info(TAG, `start to SaveRecoverInfo getTime`);
    if (this.isRecoverInAlbumPage) {
      let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
      if (!UserFileManagerAccess.IMAGE_OR_VIDEO_ALBUM_SUBTYPE.includes(album?.albumSubtype ?? -1)) {
        isOrderByDateTaken = true;
      }
    }
    Log.info(TAG, `SaveRecoverInfo getTime, orderProp is ${orderProp}, isOrderByDateTaken is ${orderProp ===
      'date_taken_ms'}, albumUri is ${albumUri}`);
    return (isOrderByDateTaken ? this.lastMediaItem?.getDateTaken() : this.lastMediaItem?.getDateAdded()) ?? 0;
  }

  public getDisplayName(): string {
    return this.lastMediaItem?.displayName ?? '';
  }

  public getRecommendationType(param: SelectParams): number {
    return param.recommendationTypeForRecover === 0 ? param.recommendationType : param.recommendationTypeForRecover;
  }

  public getSelectedRecommendationType(): number {
    return RecoverController.getSelectedRecommendType() ?? 0;
  }

  private getAnchorMediaItem(dataSource: PickerMediaDataSource | undefined, unDataGridCount: number, loadedSize: number,
    chosenItemIndex: number, isRecoverInAlbumPage: boolean, isSceneBoard: boolean): MediaItem | undefined {
    let lastGridIndex: number = RecoverController.getRecoverLastGridIndex() ?? 0;
    if (isSceneBoard) {
      lastGridIndex = this.getLastGridIndexOnSceneBoard(lastGridIndex, chosenItemIndex);
    }
    let lastDataIndex: number = this.convertGridIndexToDataIndex(isRecoverInAlbumPage, lastGridIndex, unDataGridCount);
    // 部分应用使用UIExtensionComponent调用picker，拖动到底部后再次上拉留白后，会增加宫格数量，导致超出picker数据集。此处进行兜底处理。
    if (lastDataIndex >= loadedSize) {
      lastDataIndex = loadedSize - 1;
    }
    Log.info(TAG, `prepareContextRecoveryInfo, lastGridIndex is: ${lastGridIndex}, ` +
      `lastDataIndex is: ${lastDataIndex}, unDataGridCount is: ${unDataGridCount}, loadedSize is: ${loadedSize}.`);
    return dataSource?.getData(lastDataIndex)?.mediaItem;
  }

  private getLastGridIndexOnSceneBoard(lastGridIndex: number, chosenItemIndex: number): number {
    let firstGridIndex: number = RecoverController.getRecoverFirstGridIndex() ?? 0;
    let gridRowCount: number = RecoverController.getRecoverGridRowCount() ?? Constants.PICKER_DEFAULT_GRID_ROW_COUNT;
    Log.info(TAG, `getLastGridIndexOnSceneBoard, chosenItemIndex is: ${chosenItemIndex}, ` +
      `firstGridIndex is: ${firstGridIndex}, gridRowCount is: ${gridRowCount}, lastGridIndex is: ${lastGridIndex}`);
    if (chosenItemIndex <= (firstGridIndex + gridRowCount - 1) && lastGridIndex > gridRowCount) {
      lastGridIndex -= gridRowCount;
    }
    return lastGridIndex;
  }

  private convertGridIndexToDataIndex(isRecoverInAlbumPage: boolean, gridIndex: number,
    unDataGridCount: number): number {
    if (!isRecoverInAlbumPage) {
      return gridIndex - unDataGridCount;
    }
    return gridIndex;
  }
}