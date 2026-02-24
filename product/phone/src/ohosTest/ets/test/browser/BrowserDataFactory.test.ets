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
import { BrowserDataFactory } from '@ohos/common/src/main/ets/default/interface/BrowserDataFactory';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';

export default function BrowserDataFactoryTest() {
  describe('BrowserDataFactoryTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('getFeature', 0, () => {
      getFeature();
    });
  })
}

function getFeature() {
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_GROUP);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_THIRD_SELECT_ALBUM);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM_ASYNC);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO_ASYNC);
  BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_HIDDEN_PHOTO);
  expect(() => BrowserDataFactory.getFeature('invalid_type')).assertThrowError('invalid_type is an invalid type.');
}