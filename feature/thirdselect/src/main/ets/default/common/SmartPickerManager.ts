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

import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import type SmartPickerRecommendInfo from './SmartPickerRecommendInfo';
import type SmartPickerRecommendInfoListener from './SmartPickerRecommendInfoListener';
import SmartPickerConstants from './SmartPickerConstants';
import SmartPickerRecommendInfoCallback from './SmartPickerRecommendInfoCallback';
import SmartPickerDataAdapter from './SmartPickerDataAdapter';
import type common from '@ohos.app.ability.common';

const TAG: string = 'SmartPickerManager';

export class SmartPickerManager {
  private recommendationType: number | undefined = undefined;
  private tabInfoArray: Array<SmartPickerRecommendInfo> = [];
  private pickerInfoListeners: Array<SmartPickerRecommendInfoListener> = new Array<SmartPickerRecommendInfoListener>();
  private hansNotify: boolean = false;
  private dataAdapter: SmartPickerDataAdapter = undefined;
  private context: common.Context;

  constructor(context: common.Context, recommendationOptions: RecommendationOptions, callBundleName: string) {
    Log.debug(TAG, 'constructor');
    this.context = context;
    this.init(recommendationOptions, callBundleName);
  }

  async init(recommendationOptions: RecommendationOptions, callBundleName: string): Promise<void> {
    if (recommendationOptions === undefined || recommendationOptions === null) {
      Log.error(TAG, 'init recommendationOptions is invalid');
      return;
    }
    this.recommendationType = recommendationOptions?.recommendationType;
    Log.error(TAG, 'init this.recommendationType:' + this.recommendationType);
    if (this.recommendationType === SmartPickerConstants.INVALID_PHOTO_SELECT_TYPE || this.recommendationType === undefined) {
      return;
    }
    try {
      let recommendInfoCallback: SmartPickerRecommendInfoCallback = new SmartPickerRecommendInfoCallback(this);
      this.dataAdapter = new SmartPickerDataAdapter(this.context);
      this.dataAdapter.getTabInfoList(recommendInfoCallback, recommendationOptions);
    } catch (err) {
      Log.error(TAG, 'init err:' + err);
    }
  }

  addPickerRecommendInfoListener(listener: SmartPickerRecommendInfoListener): void {
    Log.info(TAG, 'addPickerRecommendInfoListener listener:' + listener);
    if (listener && this.pickerInfoListeners.indexOf(listener) === SmartPickerConstants.INVALID) {
      this.pickerInfoListeners.push(listener);
      if (!this.hansNotify && this.tabInfoArray !== undefined && this.tabInfoArray.length > 0) {
        this.notifyTabInfoFinished(this.tabInfoArray);
      }
    }
  }

  removePickerRecommendInfoListener(listener: SmartPickerRecommendInfoListener): void {
    if (!listener) {
      return;
    }
    let index = this.pickerInfoListeners.indexOf(listener);
    if (index > SmartPickerConstants.INVALID) {
      this.pickerInfoListeners.splice(index, 1);
    }
  }

  notifyTabInfoFinished(tabInfoList: SmartPickerRecommendInfo[]): void {
    Log.error(TAG, 'notifyTabInfoFinished');
    try {
      if (tabInfoList === null || tabInfoList === undefined || tabInfoList.length <= 0) {
        Log.error(TAG, 'notifyTabInfoFinished tabInfoList is invalid');
        return;
      }
      this.tabInfoArray = tabInfoList;
      if (this.pickerInfoListeners.length === 0) {
        Log.error(TAG, 'notifyTabInfoFinished pickerInfoListeners is 0');
        return;
      }
      if (!this.hansNotify) {
        for (let listener of this.pickerInfoListeners) {
          listener.onPickerRecommendInfoListReady(this.tabInfoArray, this.dataAdapter);
          break;
        }
        this.hansNotify = true;
      }
      Log.debug(TAG, 'notifyTabInfoFinished end');
    } catch (err) {
      Log.error(TAG, 'notifyTabInfoFinished err:' + err);
    }
  }
}

export class RecommendationOptions {
  recommendationType?: RecommendationType;
}

enum RecommendationType {
  QR_OR_BAR_CODE = 1,
  QR_CODE = 2,
  BAR_CODE = 3,
  ID_CARD = 4,
  PROFILE_PICTURE = 5
}

