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

import { describe, it, expect } from '@ohos/hypium';
import { TrashAlbumAccurateUpdater } from '@ohos/common/src/main/ets/default/model/TrashAlbumAccurateUpdater';
import { MediaObserverNfyInfo, MediaObserverNfyType } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';

export default function TrashAlbumAccurateUpdaterTest() {
  describe('TrashAlbumAccurateUpdaterTest', () => {

    it('should_check_notify_when_MediaObserverNfyType_is_PHOTO_ADD', 0, () => {
      let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
      nfyInfo.type = MediaObserverNfyType.PHOTO_ADD;
      let trashAlbumAccurateUpdater: TrashAlbumAccurateUpdater = new TrashAlbumAccurateUpdater(undefined)
      let res = trashAlbumAccurateUpdater.checkNotify(nfyInfo);
      expect(res).assertFalse();
    });

  });
}