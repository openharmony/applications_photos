/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import SmartPickerRecommendInfo from './SmartPickerRecommendInfo';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import { SmartPickerDataInterface } from '../interface/SmartPickerDataInterface';
import SmartPickerConstants from './SmartPickerConstants';
import { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import { SmartPickerDataFactory } from '../interface/SmartPickerDataFactory';
import { MediaItem } from '@ohos/common';
import { QueryParam } from '@ohos/common/src/main/ets/default/model/browser/BrowserDataImpl';
import { RecommendationOptions } from './SmartPickerManager';

const TAG: string = 'SmartPickerDataAdapter';

export default class SmartPickerDataAdapter {
  private photosDataInterface: SmartPickerDataInterface = undefined;
  private uriDataImplMap: Map<string, SmartPickerDataInterface> = new Map();

  constructor() {
  }

  static getInstance(): SmartPickerDataAdapter {
    if (AppStorage.get(SmartPickerConstants.SMART_PICKER_DATA_ADAPTER) == null) {
      AppStorage.setOrCreate(SmartPickerConstants.SMART_PICKER_DATA_ADAPTER, new SmartPickerDataAdapter());
    }
    let manager: SmartPickerDataAdapter = AppStorage.get(SmartPickerConstants.SMART_PICKER_DATA_ADAPTER);
    return manager;
  }

  getTabInfoList(callback: AsyncCallback<SmartPickerRecommendInfo[]>, recommendationOptions: RecommendationOptions, param?: string) {
    try {
      let recommendationType = recommendationOptions.recommendationType;
      if (recommendationType >= SmartPickerConstants.QR_OR_BAR_CODE && recommendationType <= SmartPickerConstants.PROFILE_PICTURE) {
        this.photosDataInterface = SmartPickerDataFactory.getFeature(SmartPickerDataFactory.TYPE_LABEL, this);
        Log.debug(TAG, 'getTabInfoList this.photosDataInterface:' + this.photosDataInterface);
        this.photosDataInterface.getTabInfoList(recommendationOptions).then(async (tabInfoList: Array<SmartPickerRecommendInfo>) => {
          if (tabInfoList !== undefined && tabInfoList.length > 0) {
            Log.debug(TAG, 'getTabInfoList tabInfoList length:' + tabInfoList.length);
            this.setUriDataImplMap(tabInfoList, this.photosDataInterface);
            callback.callback(tabInfoList);
          } else {
            Log.error(TAG, 'getTabInfoList tabInfoList is undefined');
          }
        })
      }
    } catch (err) {
      Log.error(TAG, 'getTabInfoList err:' + err);
    }
  }

  private setUriDataImplMap(tabInfoList: Array<SmartPickerRecommendInfo>, dataImpl: SmartPickerDataInterface): void {
    if (tabInfoList === undefined || tabInfoList === null || tabInfoList.length <= 0) {
      Log.error(TAG, 'getTabInsetUriDataImplMap param invalid');
      return;
    }
    tabInfoList.forEach((tabInfo: SmartPickerRecommendInfo) => {
      if (!StringUtil.isEmpty(tabInfo.getAlbumUri())) {
        this.uriDataImplMap.set(tabInfo.getAlbumUri(), dataImpl);
      } else {
      }
    })
  }

  getData(callback: AsyncCallback<MediaItem[]>, param: QueryParam) {
    try {
      let albumUri = param?.albumUri;
      if (StringUtil.isEmpty(albumUri)) {
        callback.callback([]);
        return;
      }
      let smartPickerDataInterface = this.uriDataImplMap.get(albumUri);
      if (smartPickerDataInterface !== undefined && smartPickerDataInterface !== null) {
        this.uriDataImplMap.get(albumUri).getData(callback, param);
      } else {
        callback.callback([]);
        return;
      }
    } catch (err) {
      Log.error(TAG, 'getData err:' + err);
    }
  }

  async getDataCount(albumUri: string, filterMediaType?: string): Promise<number> {
    let count = 0;
    if (!StringUtil.isEmpty(albumUri) && this.uriDataImplMap.get(albumUri) !== undefined) {
      return this.uriDataImplMap.get(albumUri).getDataCount(albumUri, filterMediaType);
    } else {
      return new Promise((resolve): void => {
        resolve(count);
      })
    }
  }
}


