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
import { AlbumAccurateUpdater } from '@ohos/common/src/main/ets/default/model/AlbumAccurateUpdater';
import { GridViewMode } from '@ohos/common/src/main/ets/default/view/grid/GridView';
import { describe, expect, it } from '@ohos/hypium';
import {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';

export default function AlbumAccurateUpdaterTest() {

  describe('AlbumAccurateUpdaterTest', () => {

    it ('checkNotify', 0, () => {
      let updater  = new AlbumAccurateUpdater(undefined);
      let newMode = GridViewMode.GROUP;
      let nfyInfo = new MediaObserverNfyInfo();
      const res = updater.checkNotify(nfyInfo);
      expect(res).assertTrue();
    })

  })
}
