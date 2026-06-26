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
import { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import { describe, expect, it } from '@ohos/hypium';

export default function UserConstraintUtilTest() {
  describe('UserConstraintUtilTest', () => {
    it('UserConstraintUtilTest_isConstraintUserModifyWallpaper', 0, () => {
      const isConstraintUserModifyWallpaper: boolean = UserConstraintUtil.isConstraintUserModifyWallpaper();
      expect(isConstraintUserModifyWallpaper).assertEqual(false);
    })

    it('UserConstraintUtilTest_initConstraintUserModifyWallPaper', 0, async () => {
      await UserConstraintUtil.initConstraints();
      const isConstraintUserModifyWallpaper: boolean = UserConstraintUtil.isConstraintUserModifyWallpaper();
      expect(isConstraintUserModifyWallpaper).assertEqual(false);
    })

    it('UserConstraintUtilTest_isEnterpriseDevice', 0, async () => {
      const isEnterpriseDevice: boolean = UserConstraintUtil.isEnterpriseDevice();
      expect(isEnterpriseDevice).assertEqual(false);
    })
  })
}