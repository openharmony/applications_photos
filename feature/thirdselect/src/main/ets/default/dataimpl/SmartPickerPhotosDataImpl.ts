/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import type { SmartPickerDataInterface } from '../interface/SmartPickerDataInterface';
import type common from '@ohos.app.ability.common';
import SmartPickerRecommendInfo from '../common/SmartPickerRecommendInfo';
import SmartPickerConstants from '../common/SmartPickerConstants';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import type { QueryParam } from '@ohos/common/src/main/ets/default/model/browser/BrowserDataImpl';
import { SmartPickerUtils } from '../utils/SmartPickerUtils';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import type SmartPickerDataAdapter from '../common/SmartPickerDataAdapter';
import type { RecommendationOptions } from '../common/SmartPickerManager';
import { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';

const TAG: string = 'SmartPickerPhotosDataImpl';

export class SmartPickerPhotosDataImpl implements SmartPickerDataInterface {
  private uriLabelAlbumMap: Map<string, photoAccessHelper.Album> = new Map<string, photoAccessHelper.Album>();
  private labelIdNameMap: Map<string, string> = new Map<string, string>();
  private context: common.Context;
  private dataAdapter: SmartPickerDataAdapter;

  constructor(context: common.Context, dataAdapter: SmartPickerDataAdapter) {
    this.context = context;
    this.dataAdapter = dataAdapter;
  }

  private resetData(): void {
    this.uriLabelAlbumMap.clear();
    this.labelIdNameMap.clear();
  }

  async getTabInfoList(recommendationOptions: RecommendationOptions, param?: string): Promise<Array<SmartPickerRecommendInfo>> {
    this.resetData();
    let recommendationType = recommendationOptions.recommendationType;
    if (recommendationType >= SmartPickerConstants.QR_OR_BAR_CODE && recommendationType <= SmartPickerConstants.PROFILE_PICTURE) {
      this.addLabelIdNameInfo(recommendationType);
    }
    if (this.labelIdNameMap.size <= 0) {
      Log.error(TAG, 'getTabInfoList labelIdNameMap size is 0');
      return [];
    }
    return this.getLabelAlbumTabInfoList();
  }

  private addLabelIdNameInfo(recommendationType?: number): void {
    try {
      if (recommendationType !== undefined) {
        switch (recommendationType) {
          case SmartPickerConstants.QR_OR_BAR_CODE:
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_QR_CODE, SmartPickerConstants.NAME_QR_CODE);
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_BAR_CODE, SmartPickerConstants.NAME_BAR_CODE);
            break;
          case SmartPickerConstants.QR_CODE:
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_QR_CODE, SmartPickerConstants.NAME_QR_CODE);
            break;
          case SmartPickerConstants.BAR_CODE:
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_BAR_CODE, SmartPickerConstants.NAME_BAR_CODE);
            break;
          case SmartPickerConstants.ID_CARD:
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_ID_CARD, SmartPickerConstants.NAME_ID_CARD);
            break;
          case SmartPickerConstants.PROFILE_PICTURE:
            this.labelIdNameMap.set(SmartPickerConstants.LABEL_AVATAR, SmartPickerConstants.NAME_AVATAR);
            break;
        }
      }
    } catch (err) {
      Log.error(TAG, 'addLabelIdNameInfo err:' + err);
    }
  }

  private buildFetchOptions(): photoAccessHelper.FetchOptions {
    let dataPredicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let labelAlbumFetchOpt: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: dataPredicates
    };
    return labelAlbumFetchOpt;
  }

  async getLabelAlbumTabInfoList(): Promise<Array<SmartPickerRecommendInfo>> {
    try {
      let photoHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      let albumFetOpt = this.buildFetchOptions();
      albumFetOpt.predicates.in(SmartPickerConstants.LABEL_ID_KEY, Array.from(this.labelIdNameMap.keys()));
      albumFetOpt.predicates.orderByAsc(SmartPickerConstants.LABEL_ID_KEY);
      //@ts-ignore
      let albumsFetchResult = await photoHelper.getAlbums(photoAccessHelper.AlbumKeys.SMART,
        //@ts-ignore
        photoAccessHelper.AlbumSubtype.CLASSIFY, albumFetOpt);
      if (albumsFetchResult === undefined || albumsFetchResult === null || albumsFetchResult.getCount() <= 0) {
        this.labelIdNameMap.clear();
        Log.error(TAG, 'albumsFetchResult is invalid');
        return [];
      }
      let albumList = await albumsFetchResult.getAllObjects();
      albumsFetchResult.close();
      let pickerRecommendInfoList: SmartPickerRecommendInfo[] = [];
      for (let i = 0; i < albumList.length; i++) {
        let album: photoAccessHelper.Album = albumList[i];
        if (album.count > 0) {
          let tabInfo = this.buildTabInfoByAlbum(album);
          pickerRecommendInfoList.push(tabInfo);
          this.uriLabelAlbumMap.set(album.albumUri, album);
        } else {
          this.labelIdNameMap.delete(album.albumName);
        }
      }
      return pickerRecommendInfoList;
    } catch (err) {
      Log.error(TAG, 'getLabelAlbumTabInfoList err' + err);
    }
    return [];
  }

  private buildTabInfoByAlbum(album: photoAccessHelper.Album): SmartPickerRecommendInfo {
    let tabInfo = new SmartPickerRecommendInfo();
    tabInfo.setAlbumUri(album.albumUri);
    tabInfo.setRecommendType(SmartPickerConstants.RECOMMEND_TYPE_LABEL);
    tabInfo.setLabelId(album.albumName);
    tabInfo.setTotalCount(album.count);
    return tabInfo;
  }

  getData(callback: AsyncCallback<MediaItem[]>, param: QueryParam): void {
    let albumUri = param.albumUri;
    let start = param.start;
    let count = param.count;
    let filterMediaType = param.filterMediaType;
    this.getLabelPhotoData(callback, albumUri, start, count, filterMediaType);
  }

  private getLabelPhotoData(callback: AsyncCallback<MediaItem[]>, albumUri: string, startIndex?: number, count?: number, filterMediaType?: string): void {
    if (StringUtil.isEmpty(albumUri)) {
      callback.callback([], albumUri);
      return;
    }
    try {
      let labelPhotoFetchOption = this.buildFetchOptions();
      labelPhotoFetchOption.predicates.limit(count, startIndex);
      labelPhotoFetchOption.fetchColumns = Array.prototype.slice.call(SmartPickerConstants.ALL_IMAGE_VIDEO_FETCH_COLUMNS) as string[];
      let album = this.uriLabelAlbumMap.get(albumUri);
      this.getPhotoAssetDataByAlbum(album, labelPhotoFetchOption).then(async (mediaItemList: Array<MediaItem>) => {
        if (mediaItemList) {
          callback.callback(mediaItemList, albumUri);
        } else {
          callback.callback([], albumUri);
        }
      });
    } catch (err) {
      Log.error(TAG, 'getLabelPhotoData err:' + err);
      callback.callback([], albumUri);
    }
  }

  async getPhotoAssetDataByAlbum(album: photoAccessHelper.Album, fileFetchOpt: photoAccessHelper.FetchOptions): Promise<Array<MediaItem>> {
    if (album === null || album === undefined) {
      Log.error(TAG, 'getPhotoAssetDataByAlbum album is invalid');
      return [];
    }
    try {
      let photoFetchResult = await album.getAssets(fileFetchOpt);
      let fileAssetList = await photoFetchResult.getAllObjects();
      photoFetchResult.close();
      let mediaItemList: MediaItem[] = [];
      for (let photoAsset of fileAssetList) {
        let mediaItem: MediaItem = new MediaItem(photoAsset);
        if (this.dataAdapter) {
          mediaItem.setThumbnail(SmartPickerUtils.getThumbnailSafe(photoAsset.uri, String(photoAsset.get(Constants.KEY_FILE_DATA))));
          mediaItemList.push(mediaItem);
        }
      }
      return mediaItemList;
    } catch (err) {
      Log.error(TAG, 'getPhotoAssetDataByAlbum err:' + err);
    }
    return [];
  }

  async getDataCount(albumUri: string, filterMediaType?: string): Promise<number> {
    let count = 0;
    if (!StringUtil.isEmpty(albumUri) && this.uriLabelAlbumMap.get(albumUri) !== undefined) {
      let album = this.uriLabelAlbumMap.get(albumUri);
      if (!filterMediaType) {
        return album.count;
      }
      let fetchOpt = this.buildFetchOptions();
      fetchOpt.fetchColumns = Array.prototype.slice.call(SmartPickerConstants.ALL_IMAGE_VIDEO_FETCH_COLUMNS) as string[];
      let fetResult = await album.getAssets(fetchOpt);
      count = fetResult.getCount();
      fetResult.close();
    }
    return count;
  }
}