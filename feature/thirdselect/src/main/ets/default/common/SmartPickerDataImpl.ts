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
import { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import type { AsyncCallback, MediaItem } from '@ohos/common';
import { StringUtil } from '@ohos/common';
import type { QueryParam } from '@ohos/common/src/main/ets/default/model/browser/BrowserDataImpl';
import type SmartPickerDataAdapter from './SmartPickerDataAdapter';

const TAG: string = 'SmartPickerDataImpl';

export default class SmartPickerDataImpl extends PhotoDataImpl {
  private dataAdapter: SmartPickerDataAdapter;

  constructor() {
    super();
  }

  setDataAdapter(dataAdapter: SmartPickerDataAdapter): void {
    this.dataAdapter = dataAdapter;
  }

  getData(callback: AsyncCallback<MediaItem[]>, param: QueryParam): void {
    Log.info(TAG, `getData start ${JSON.stringify(param)}`);
    if (callback === null || callback === undefined) {
      Log.error(TAG, 'getData, param or callback is null, return!');
      return;
    }
    if (StringUtil.isEmpty(param?.albumUri)) {
      return;
    }
    this.dataAdapter.getData(callback, param);
  }

  getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    Log.debug(TAG, `getDataCount: ${JSON.stringify(param)}`);
    this.dataAdapter.getDataCount(param.albumUri, param.filterMediaType).then((count): void => {
      callback.callback(count);
    });
  }
}


