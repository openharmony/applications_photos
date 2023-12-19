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

import type { MediaItem } from '@ohos/common';
import type { QueryParam } from '@ohos/common/src/main/ets/default/model/browser/BrowserDataImpl';
import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import type { RecommendationOptions } from '../common/SmartPickerManager';
import type SmartPickerRecommendInfo from '../common/SmartPickerRecommendInfo';

export interface SmartPickerDataInterface {
  getTabInfoList(recommendationOptions: RecommendationOptions, param?: string): Promise<Array<SmartPickerRecommendInfo>>;

  getData(callback: AsyncCallback<MediaItem[]>, param: QueryParam): void;

  getDataCount(albumUri: string, filterMediaType?: string): Promise<number>;
}