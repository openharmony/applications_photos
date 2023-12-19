/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { AlbumDefine, Constants } from '@ohos/common';
import type Want from '@ohos.app.ability.Want';
import type { RecommendationOptions } from '../common/SmartPickerManager';
import { SmartPickerManager } from '../common/SmartPickerManager';
import SmartPickerConstants from '../common/SmartPickerConstants';

import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import type common from '@ohos.app.ability.common';

const TAG: string = 'SmartPickerUtils';

export class SmartPickerUtils {
  static readonly THUMBNAIL_WIDTH = 256;

  static initIfNeeded(context: common.Context, want: Want, storage: LocalStorage): boolean {
    try {
      let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
      let filterMediaType = wantParam?.filterMediaType as string;
      if (filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_IMAGE && filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_ALL) {
        return false;
      }
      Log.debug(TAG, 'initIfNeeded wantParam:' + JSON.stringify(wantParam));
      if (wantParam?.recommendationOptions === null || wantParam?.recommendationOptions === undefined) {
        return false;
      }
      let recommendation: string = JSON.stringify(wantParam?.recommendationOptions);
      let recommendationOptions: RecommendationOptions = JSON.parse(recommendation);

      if (recommendationOptions === undefined || recommendationOptions === null) {
        Log.error(TAG, 'initIfNeeded recommendationOptions is invalid');
        return false;
      }
      let callerBundleName = wantParam[Constants.KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME] as string;
      Log.info(TAG, 'initIfNeeded callerBundleName:' + callerBundleName + ' storage:' + storage);
      if (storage) {
        let smartPickerManager: SmartPickerManager = new SmartPickerManager(context, recommendationOptions, callerBundleName);
        storage.setOrCreate(SmartPickerConstants.SMART_PICKER_MANAGER, smartPickerManager);
      }
      return true;
    } catch (err) {
      Log.error(TAG, 'initIfNeeded err:' + err);
    }
    return false;
  }

  static getThumbnailSafe(sourceUri: string, path: string, size?): string {
    try {
      if (size) {
        if (size.width !== 0 && size.height !== 0) {
          return `${sourceUri}?oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
        } else {
          Log.warn(TAG, 'getThumbnailSafe with width==0 and height==0, so do not use thumbnail' + JSON.stringify(size));
          return `${sourceUri}`;
        }
      } else {
        return `${sourceUri}?oper=thumbnail&width=${SmartPickerUtils.THUMBNAIL_WIDTH}&height=${SmartPickerUtils.THUMBNAIL_WIDTH}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}`);
      return null;
    }
  }
}