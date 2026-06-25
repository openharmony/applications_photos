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
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'RecoverController';

export class RecoverController {
  public static setRecoverFirstGridIndex(first: number | undefined): void {
    LocalStorage.getShared()?.setOrCreate<number>(Constants.KEY_OF_RECOVER_FIRST_GRID_INDEX, first);
  }

  public static setRecoverGridRowCount(gridRowCount: number | undefined): void {
    LocalStorage.getShared()?.setOrCreate<number>(Constants.KEY_OF_RECOVER_GRID_ROW_COUNT, gridRowCount);
  }

  public static setRecoverLastGridIndex(last: number | undefined): void {
    LocalStorage.getShared()?.setOrCreate<number>(Constants.KEY_OF_RECOVER_LAST_GRID_INDEX, last);
  }

  public static setRecoverAlbumUri(albumUri: string | undefined): void {
    LocalStorage.getShared()?.setOrCreate<string>(Constants.KEY_OF_RECOVER_ALBUM_URI, albumUri);
  }

  public static setSelectedRecommendType(index: number | undefined): void {
    LocalStorage.getShared()?.setOrCreate<number>(Constants.KEY_OF_RECOVER_SELECTED_RECOMMEND_TYPE, index);
  }

  public static setIsRecoverInAlbumPage(status: boolean | undefined): void {
    LocalStorage.getShared()?.setOrCreate<boolean>(Constants.IS_RECOVER_IN_ALBUM_PAGE, status);
  }

  public static getRecoverFirstGridIndex(): number | undefined {
    return LocalStorage.getShared()?.get<number>(Constants.KEY_OF_RECOVER_FIRST_GRID_INDEX);
  }

  public static getRecoverGridRowCount(): number | undefined {
    return LocalStorage.getShared()?.get<number>(Constants.KEY_OF_RECOVER_GRID_ROW_COUNT);
  }

  public static getRecoverLastGridIndex(): number | undefined {
    return LocalStorage.getShared()?.get<number>(Constants.KEY_OF_RECOVER_LAST_GRID_INDEX);
  }

  public static getRecoverAlbumUri(): string | undefined {
    return LocalStorage.getShared()?.get<string>(Constants.KEY_OF_RECOVER_ALBUM_URI);
  }

  public static getSelectedRecommendType(): number | undefined {
    return LocalStorage.getShared()?.get<number>(Constants.KEY_OF_RECOVER_SELECTED_RECOMMEND_TYPE);
  }

  public static getIsRecoverInAlbumPage(): boolean | undefined {
    return LocalStorage.getShared()?.get<boolean>(Constants.IS_RECOVER_IN_ALBUM_PAGE);
  }

  public static getIsInAllPhotosSheet(albumUri: string | undefined): boolean {
    Log.info(TAG, `[getIsInAllPhotosSheet], albumUri is ${albumUri}`);
    return albumUri === Constants.PICKER_ALL_PHOTOS_SHEET;
  }
}