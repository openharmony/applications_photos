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
import { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import { RecoverController } from './RecoverController';

const TAG: string = 'ApplyRecoverInfo';

export class ApplyRecoverInfo {
  // 对于所有图片界面，GridIndex除了照片数据，还包含安全横幅和拍照宫格（各占位1）
  public static getUnDataGridCountOnCamera(cameraAble: boolean, unDataGridCount: number): number {
    if (cameraAble) {
      unDataGridCount += 1;
    }
    Log.info(TAG, `getUnDataGridCountOnCamera, unDataGridCount is ${unDataGridCount}, cameraAble is ${cameraAble}`);
    return unDataGridCount;
  }

  public static getUnDataGridCountOnWarnDialog(isShowPickerWarnDialog: Boolean, unDataGridCount: number): number {
    if (isShowPickerWarnDialog) {
      unDataGridCount += 1;
    } else {
      unDataGridCount -= 1
    }
    Log.info(TAG,
      `getUnDataGridCountOnWarnDialog, unDataGridCount is: ${unDataGridCount}, isShowPickerWarnDialog is: ${isShowPickerWarnDialog}`);
    return unDataGridCount;
  }

  // 检查是否在所有图片tab下的非推荐页面
  public static getIsInAll(selectParams: SelectParams): boolean {
    if (selectParams.recoverSceneEnabled) {
      return RecoverController.getIsInAllPhotosSheet(selectParams.albumUriForRecover);
    }
    Log.info(TAG, `selectedRecommend type is ${RecoverController.getSelectedRecommendType()}.`)
    let selectedRecommendType: number | undefined = RecoverController.getSelectedRecommendType();
    return selectedRecommendType === undefined;
  }

  // 检查是否在所有图片tab下的推荐页面
  public static getIsInRecommend(selectParams: SelectParams): boolean {
    if (selectParams.recoverSceneEnabled) {
      return !RecoverController.getIsInAllPhotosSheet(selectParams.albumUriForRecover) && !selectParams.isRecoverAlbum;
    }
    let isInAlbumPage: boolean = RecoverController.getIsRecoverInAlbumPage() ?? false;
    let albumUri: string | undefined = RecoverController.getRecoverAlbumUri();
    let isInPhotos: boolean = RecoverController.getIsInAllPhotosSheet(albumUri);
    return !isInPhotos && !isInAlbumPage;
  }

  public static convertDataIndexToGridIndex(dataIndexForRecover: number, isRecoverAlbum: boolean,
    unDataGridCount: number): number {
    let gridIndex: number = dataIndexForRecover;
    if (!isRecoverAlbum) {
      gridIndex = dataIndexForRecover + unDataGridCount;
    }
    Log.info(TAG, `GridIndex is: ${gridIndex}, DataIndex is: ${dataIndexForRecover}, ` +
      `unDataGridCount is: ${unDataGridCount}`);
    return gridIndex;
  }
}