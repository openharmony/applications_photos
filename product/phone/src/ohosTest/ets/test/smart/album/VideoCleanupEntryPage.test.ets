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
import { describe, expect, it } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { VideoCleanupEntryPage } from '../../../../../main/ets/galleryCleanupAbility/view/VideoCleanupEntryPage';

/**
 * Description.
 *
 * @since 2024-07-26
 */
export default function VideoCleanupEntryPageTest() {
  describe('VideoCleanupEntryPageTest', () => {
    let videoCleanupEntryPage: VideoCleanupEntryPage;
    it('VideoCleanupEntryPageTest_01', TestConstants.TEST_LEVEL_ONE, () => {
      if (videoCleanupEntryPage) {
        let ret: boolean = videoCleanupEntryPage?.build() !== null;
        expect(ret).assertTrue();
      }
    });
  })
}
