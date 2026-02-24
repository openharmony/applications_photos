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
import { AlbumCardComponent } from '@ohos/common/src/main/ets/default/view/AlbumCard';

/**
 * Description.
 *
 * @since 2024-07-26
 */
export default function AlbumCardComponentTest() {
  describe('AlbumCardComponentTest', () => {
    let albumCardComponent: AlbumCardComponent;
    it('AlbumCardComponentTest_01', TestConstants.TEST_LEVEL_ONE, () => {
      if (!albumCardComponent) {
        return;
      }
      let ret: boolean = albumCardComponent?.aboutToAppear() !== null;
      expect(ret).assertTrue();
    });
  })
}
