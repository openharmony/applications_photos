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

import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import type { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import type { BrowserDataInterface } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { MediaItem } from '@ohos/common';
import SmartPickerConstants from './SmartPickerConstants';

export class PickerMediaDataSource extends MediaDataSource {
  constructor(windowSize: number, photoDataImpl?: PhotoDataImpl) {
    super(windowSize, photoDataImpl);
  }

  changeDataImpl(dataImpl: BrowserDataInterface): void {
    this.photoDataImpl = dataImpl;
  }

  updateMediaData(requestTime: number, start: number, mediaItems: MediaItem[], onInit?: boolean): void {
    super.updateMediaData(requestTime, start, mediaItems);
    if (onInit) {
      this.broadCast?.emit(SmartPickerConstants.PICKER_INIT_DATA_FIRST_QUERY_FINISH, []);
    }
  }
}


