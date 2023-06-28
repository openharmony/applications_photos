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

import type { AsyncCallback } from '../../common/AsyncCallback';
import type { MediaDataSource } from './MediaDataSource';
import { Log } from '../../../utils/Log';
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils';

const TAG: string = 'common_GetItemIndexCallback';

export class GetItemIndexCallback implements AsyncCallback<number> {
  source: MediaDataSource;
  requestTime: number;
  indexNotifyCallback: Function;

  constructor(source: MediaDataSource, indexNotifyCallback: Function) {
    this.source = source;
    this.requestTime = Date.now();
    this.indexNotifyCallback = indexNotifyCallback;
    TraceControllerUtils.startTraceWithTaskId('getMediaItemIndex', this.requestTime);
  }

  callback(index: number): void {
    TraceControllerUtils.finishTraceWithTaskId('getMediaItemIndex', this.requestTime);
    Log.info(TAG, `GetItemIndex finish: index=${index}`);
    this.indexNotifyCallback(index);
  }
}