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

import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import type { SmartPickerManager } from './SmartPickerManager';

import type SmartPickerRecommendInfo from './SmartPickerRecommendInfo';

export default class SmartPickerRecommendInfoCallback implements AsyncCallback<SmartPickerRecommendInfo[]> {
  private manager: SmartPickerManager;

  constructor(manager: SmartPickerManager) {
    this.manager = manager;
  }

  callback(assets: SmartPickerRecommendInfo[]): void {
    if (this.manager) {
      this.manager.notifyTabInfoFinished(assets);
    }
  }
}
