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
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { Heic2JPGManagerAccess } from '@ohos/common/src/main/ets/default/access/Heic2JPGManagerAccess';

export default function Heic2JPGManagerAccessTest() {
  describe('Heic2JPGManagerAccessTest', () => {

    it ('verifyJumpSuccess_when_equal', 0, async () => {
      let instance = Heic2JPGManagerAccess.getInstance();
      instance.verifyJumpSuccess(Heic2JPGManagerAccess.targetIndex);
      expect(Heic2JPGManagerAccess.isJumpSuccess).assertEqual(true);
      // 验证完重置为false
      Heic2JPGManagerAccess.isJumpSuccess = false;
    });

    it ('verifyJumpSuccess_when_not_equal', 0, async () => {
      let instance = Heic2JPGManagerAccess.getInstance();
      instance.verifyJumpSuccess(0);
      expect(Heic2JPGManagerAccess.isJumpSuccess).assertEqual(false);
    });

    it('setJumpPlan', 0, async () => {
      let instance = Heic2JPGManagerAccess.getInstance();
      let targetIndex = 0;
      instance.setJumpPlan(targetIndex, false);
      expect(Heic2JPGManagerAccess.targetIndex).assertEqual(targetIndex);
    });
  });
}

