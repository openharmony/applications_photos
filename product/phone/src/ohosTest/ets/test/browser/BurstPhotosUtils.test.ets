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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { BurstPhotosUtils } from '@ohos/browsercommon/src/main/ets/default/utils/BurstPhotosUtils';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

export default function BurstPhotosUtilsTest() {
  describe('BurstPhotosUtilsTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('longPressHandleBurstPhotos', 0, async () => {
      await longPressHandleBurstPhotos();
    });

  })
}

async function longPressHandleBurstPhotos() {
  let burstPhotosUtils: BurstPhotosUtils = new BurstPhotosUtils();
  let currentPhoto: MediaItem = new MediaItem();
  let dataSource: MediaDataSource = new MediaDataSource(1);
  let broadCast: BroadCast = new BroadCast();
  burstPhotosUtils.longPressHandleBurstPhotos(1, currentPhoto, null as ESObject, broadCast);
  burstPhotosUtils.longPressHandleBurstPhotos(1, null as ESObject, dataSource, broadCast);
  currentPhoto.burstKey = 'test';
  burstPhotosUtils.longPressHandleBurstPhotos(1, currentPhoto, dataSource, broadCast);
}


