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
import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { SysAlbumsCounter } from '../../../../../../../feature/browser/src/main/ets/default/view/SideBar';

export default function SideBarTest() {
  describe('SideBarTest', () => {
    let sysAlbumsCounter: SysAlbumsCounter = new SysAlbumsCounter();
    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_hasPhotos_to_1_when_count_is_1', 0, () => {

      sysAlbumsCounter.setHasPhoto(1);
      expect(sysAlbumsCounter.hasPhotos).assertEqual(1);
    });

    it('should_set_hasPhotos_to_0_when_count_is_0', 0, () => {
      sysAlbumsCounter.setHasPhoto(0);
      expect(sysAlbumsCounter.hasPhotos).assertEqual(0);
    });

    it('should_set_hasVideos_to_0_when_count_is_0', 0, () => {
      sysAlbumsCounter.setHasVideos(0);
      expect(sysAlbumsCounter.hasVideos).assertEqual(0);
    });

    it('should_set_hasVideos_to_1_when_count_is_1', 0, () => {
      sysAlbumsCounter.setHasVideos(1);
      expect(sysAlbumsCounter.hasVideos).assertEqual(1);
    });

    it('should_set_hasFavorite_to_0_when_count_is_0', 0, () => {
      sysAlbumsCounter.setHasFavorite(0);
      expect(sysAlbumsCounter.hasFavorite).assertEqual(0);
    });

    it('should_set_hasFavorite_to_1_when_count_is_1', 0, () => {
      sysAlbumsCounter.setHasFavorite(1);
      expect(sysAlbumsCounter.hasFavorite).assertEqual(1);
    });

  });
}