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

import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { RecoverController } from './RecoverController';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { FileFetchOptionBuilder } from '@ohos/common/src/main/ets/default/model/FetchOption';
import { FilterConditions } from '@ohos/common/src/main/ets/default/model/FilterConditions';
import { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import {
  FetchAssetResult,
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';

const TAG: string = 'InitRecoverInfo';

export class InitRecoverInfo {
  private isRecoverAlbumOrRecommend: boolean = false;
  private isRecoverRecommend: boolean = false;
  private orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS;

  public async getAnchorDataIndexForRecover(params: SelectParams,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    Log.info(TAG, `start to getAnchorDataIndexForRecover.`);
    this.isRecoverAlbumOrRecommend = !RecoverController.getIsInAllPhotosSheet(params.albumUriForRecover);
    let album: PhotoAlbum | undefined = undefined;
    if (this.isRecoverAlbumOrRecommend) {
      album = await userFileManagerAccess.getAlbumByUri(params.albumUriForRecover);
      Log.info(TAG, `getAnchorDataIndexForRecover, album is ${album}`)
      this.isRecoverRecommend = album?.albumSubtype === photoAccessHelper.AlbumSubtype.CLASSIFY;
      params.isRecoverAlbum = !this.isRecoverRecommend && album !== undefined;
    }
    Log.info(TAG, `isRecoverAlbumOrRecommend is: ${this.isRecoverAlbumOrRecommend}, `+
      `isRecoverRecommend is: ${this.isRecoverRecommend}, albumSubtype is: ${album?.albumSubtype}, `+
      `albumUriForRecover is: ${params.albumUriForRecover}`);
    if (this.isRecoverRecommend) {
      let recommendAnchorIndex: number = await this.getAnchorIndexOnRecommend(params, album, userFileManagerAccess);
      return recommendAnchorIndex;
    }
    let normalAnchorIndex: number = await this.getAnchorIndexOnNormal(params, album, userFileManagerAccess);
    return normalAnchorIndex;
  }

  private async getAnchorIndexOnNormal(params: SelectParams, album: PhotoAlbum | undefined,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    Log.info(TAG, `prepare to getAnchorIndexOnNormal.`)
    if (params.isRecoverAlbum) {
      if (!UserFileManagerAccess.IMAGE_OR_VIDEO_ALBUM_SUBTYPE.includes(album?.albumSubtype ?? -1)) {
        this.orderProp = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS;
      }
    }
    let greaterCount: number = await this.getGreaterAssetsCount(params, album, userFileManagerAccess);
    let extraEqualCount: number = await this.getExtraEqualCount(params, album, userFileManagerAccess);
    if (params.isRecoverAlbum && (greaterCount + extraEqualCount === 0)) {
      let albumAssetsCount: number = await this.getAlbumAssetsCount(params, album, userFileManagerAccess);
      params.isRecoverAlbum = albumAssetsCount !== 0;
      Log.info(TAG, `isRecoverAlbum is ${params.isRecoverAlbum}, albumAssetsCount is ${albumAssetsCount}`)
    }
    Log.info(TAG, `orderProp is ${this.orderProp}, AnchorIndexOnNormal is ${greaterCount +
      extraEqualCount - 1}, greaterCount is ${greaterCount}, extraEqualCount is ${extraEqualCount}`)
    return greaterCount + extraEqualCount - 1;
  }

  private async getGreaterAssetsCount(params: SelectParams, album: PhotoAlbum | undefined,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    let fetchOption: photoAccessHelper.FetchOptions = this.getFetchOptionOnNormal(true, false, params);
    let greaterAssetsCount: number = 0;
    let onDataLoadDone: AsyncCallback<FetchAssetResult | undefined> = {
      callback: (assetsFetchResult: FetchAssetResult | undefined): void => {
        Log.info(TAG, 'getGreaterAssetsCount load back');
        if (!assetsFetchResult) {
          Log.error(TAG, `getGreaterAssetsCount undefined`);
        } else {
          greaterAssetsCount = assetsFetchResult.getCount();
          Log.info(TAG, `getGreaterAssetsCount success, assets count is ${greaterAssetsCount}`);
        }
      }
    };
    await userFileManagerAccess.getAssetsFetchResult(onDataLoadDone, fetchOption, album,
      this.isRecoverAlbumOrRecommend);
    return greaterAssetsCount;
  }

  private async getExtraEqualCount(params: SelectParams, album: PhotoAlbum | undefined,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    let fetchOption: photoAccessHelper.FetchOptions = this.getFetchOptionOnNormal(false, true, params);
    let extraEqualCount: number = 0;
    let onDataLoadDone: AsyncCallback<FetchAssetResult | undefined> = {
      callback: async (assetsFetchResult: FetchAssetResult | undefined): Promise<void> => {
        Log.info(TAG, 'getExtraEqualCount load back');
        if (!assetsFetchResult) {
          Log.error(TAG, `getExtraEqualCount undefined`);
        } else {
          extraEqualCount = await this.calcExtraEqualCount(assetsFetchResult, params)
          Log.info(TAG,
            `getExtraEqualCount success, extraEqualCount is: ${extraEqualCount}, total equal count is: ${assetsFetchResult?.getCount()}`);
        }
      }
    };
    await userFileManagerAccess.getAssetsFetchResult(onDataLoadDone, fetchOption, album,
      this.isRecoverAlbumOrRecommend);
    return extraEqualCount;
  }

  private async getAlbumAssetsCount(params: SelectParams, album: PhotoAlbum | undefined,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    let fetchOption: photoAccessHelper.FetchOptions = this.getFetchOptionOnNormal(false, false, params);
    let albumAssetsCount: number = 0;
    let onDataLoadDone: AsyncCallback<FetchAssetResult | undefined> = {
      callback: (assetsFetchResult: FetchAssetResult | undefined): void => {
        Log.info(TAG, 'getAlbumAssetsCount load back');
        if (!assetsFetchResult) {
          Log.error(TAG, `getAlbumAssetsCount undefined`);
        } else {
          albumAssetsCount = assetsFetchResult.getCount();
          Log.info(TAG, `getAlbumAssetsCount success, assets count is ${albumAssetsCount}`);
        }
      }
    };
    await userFileManagerAccess.getAssetsFetchResult(onDataLoadDone, fetchOption, album,
      this.isRecoverAlbumOrRecommend);
    return albumAssetsCount;
  }

  private async calcExtraEqualCount(assetsFetchResult: FetchAssetResult, params: SelectParams): Promise<number> {
    Log.debug(TAG, `strat to calcExtraEqualCount`);
    if (assetsFetchResult.getCount() === 1) {
      return 1;
    }
    let traceId: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('calcExtraEqualCount', traceId);
    let photoAssets: PhotoAsset[] = await assetsFetchResult.getAllObjects();
    let equalDataCount: number = photoAssets.length;
    let extraEqualIndex: number = 0;
    while (extraEqualIndex < equalDataCount) {
      let curDisplayName: photoAccessHelper.MemberType =
        photoAssets[extraEqualIndex].get(UserFileManagerAccess.FILE_KEY_DISPLAY_NAME);
      if (curDisplayName === params.displayNameForRecover) {
        Log.debug(TAG, `as displayName equal, cur displayname in equal assets is: ${curDisplayName}`);
        extraEqualIndex += 1
        break;
      }
      extraEqualIndex += 1;
    }
    TraceControllerUtils.finishTraceWithTaskId('calcExtraEqualCount', traceId);
    return extraEqualIndex;
  }

  private getFetchOptionOnNormal(isGetGreater: boolean, isGetEqual: boolean, params: SelectParams) {
    Log.info(TAG, `start to getFetchOptionOnNormal, isGetGreater is ${isGetGreater}`);
    let filterConditions: FilterConditions = {
      recommendationType: params.recommendationTypeForRecover,
      photoViewMimeTypeFilter: params?.photoViewMimeTypeFilter,
      fileSizeFilter: params?.fileSizeFilter,
      videoDurationFilter: params?.videoDurationFilter,
    };
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    if (isGetGreater) {
      predicates.greaterThan(this.orderProp, params.timeAnchorForRecover);
    } else if (isGetEqual) {
      predicates.equalTo(this.orderProp, params.timeAnchorForRecover);
      predicates.orderByDesc(UserFileManagerAccess.FILE_KEY_DISPLAY_NAME);
    }
    if (!params.isRecoverAlbum) {
      predicates.equalTo(UserFileManagerAccess.FILE_KEY_THUMBNAIL_VISIBLE,
        UserFileManagerAccess.THUMBNAIL_VISIBLE_VALUE);
    }
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: predicates,
      fetchColumns: isGetGreater ? [] : isGetEqual ? [UserFileManagerAccess.FILE_KEY_DISPLAY_NAME] : [],
    };
    AlbumDefine.setFilterConditions(fetchOption, filterConditions);
    let builder = new FileFetchOptionBuilder(fetchOption);
    AlbumDefine.setFilterMediaType(builder, params.filterMediaType);
    fetchOption = builder.build();
    Log.info(TAG, `getFetchOptionOnNormal success`);
    return fetchOption;
  }

  private async getAnchorIndexOnRecommend(params: SelectParams, album: PhotoAlbum | undefined,
    userFileManagerAccess: UserFileManagerAccess): Promise<number> {
    Log.info(TAG, `start to getAnchorIndexOnRecommend`);
    let fetchOption: photoAccessHelper.FetchOptions = {
      predicates: new dataSharePredicates.DataSharePredicates(),
      fetchColumns: [photoAccessHelper.PhotoKeys.DATE_ADDED],
    };
    fetchOption.predicates.orderByDesc(photoAccessHelper.PhotoKeys.DATE_ADDED);
    if (params.recommendationTypeForRecover === photoAccessHelper.RecommendationType.FEATURED_SINGLE_PORTRAIT) {
      fetchOption.predicates.like('FeaturedSinglePortrait', 'true');
    }
    let anchorIndex: number = 0;
    let onDataLoadDone: AsyncCallback<FetchAssetResult | undefined> = {
      callback: async (assetsFetchResult: FetchAssetResult | undefined): Promise<void> => {
        Log.info(TAG, 'getAnchorIndexOnRecommend load back');
        if (!assetsFetchResult) {
          Log.error(TAG, `getAnchorIndexOnRecommend undefined`);
        } else {
          anchorIndex = await this.calcAnchorIndexOnRecommend(assetsFetchResult, params);
          Log.info(TAG, `getAnchorIndexOnRecommend success, anchorIndex is ${anchorIndex}, ` +
            `total Recommend count is ${assetsFetchResult?.getCount()}`);
        }
      }
    };
    await userFileManagerAccess.getAssetsFetchResult(onDataLoadDone, fetchOption, album,
      this.isRecoverAlbumOrRecommend);
    return anchorIndex;
  }

  private async calcAnchorIndexOnRecommend(assetsFetchResult: FetchAssetResult, params: SelectParams): Promise<number> {
    Log.info(TAG, `calcAnchorIndexOnRecommend begin`);
    let traceId: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('calcAnchorIndexOnRecommend', traceId);
    let photoAssets: PhotoAsset[] = await assetsFetchResult.getAllObjects();
    Log.info(TAG, `calcAnchorIndexOnRecommend getAllObjects end`);
    let minEqualIndex: number = this.getMinEqualIndexByBinarySearch(photoAssets, params.timeAnchorForRecover);
    let accurateIndex: number = this.getAccurateIndex(photoAssets, params.displayNameForRecover, minEqualIndex);
    TraceControllerUtils.finishTraceWithTaskId('calcAnchorIndexOnRecommend', traceId);
    Log.info(TAG, `accurateIndex is: ${accurateIndex}, minEqualIndex is: ${minEqualIndex}.`);
    return accurateIndex;
  }

  private getMinEqualIndexByBinarySearch(photoAssets: PhotoAsset[], anchorTime: number): number {
    let minIndex: number = 0;
    let maxIndex: number = photoAssets.length - 1;
    let randomEqualIndex = -1;
    while (minIndex <= maxIndex) {
      const midIndex: number = Math.floor((minIndex + maxIndex) / 2);
      if (photoAssets[midIndex].get(UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS) > anchorTime) {
        minIndex = midIndex + 1;
      } else {
        randomEqualIndex = midIndex;
        maxIndex = midIndex - 1;
      }
    }
    return this.getMinEqualIndex(photoAssets, anchorTime, randomEqualIndex);
  }

  private getMinEqualIndex(photoAssets: PhotoAsset[], anchorTime: number, randomEqualIndex: number): number {
    while (randomEqualIndex > 0 &&
      photoAssets[randomEqualIndex -1].get(UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS) === anchorTime) {
      randomEqualIndex -= 1;
    }
    return randomEqualIndex;
  }

  private getAccurateIndex(photoAssets: PhotoAsset[], anchorName: string, minEqualIndex: number): number {
    if (photoAssets[minEqualIndex].get(UserFileManagerAccess.FILE_KEY_DISPLAY_NAME) === anchorName) {
      return minEqualIndex;
    }
    while (minEqualIndex < photoAssets.length - 1) {
      if (photoAssets[minEqualIndex +1].get(UserFileManagerAccess.FILE_KEY_DISPLAY_NAME) === anchorName) {
        minEqualIndex += 1;
        break;
      }
      minEqualIndex += 1;
    }
    return minEqualIndex;
  }
}