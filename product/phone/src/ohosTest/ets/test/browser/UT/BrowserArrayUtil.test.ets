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
import { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import { isSublist } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';

export default function BrowserArrayUtilTest() {
  describe('BrowserArrayUtilTest', () => {
    it('BrowserArrayUtilTest_isFilterListEmpty', 0, () => {
      let arr: FingerInfo[] = new Array(3);
      let finger: FingerInfo = {
        id: 1,
        globalX: 2,
        globalY: 2,
        localX: 3,
        localY: 3,
        displayX: 2,
        displayY: 2,
      };
      arr[1] = finger;
      expect(arr.length).assertEqual(3);
      expect(arr[1].id).assertEqual(1);
      expect(arr[0]).assertUndefined();
      arr = isFilterListEmpty(arr);
      expect(arr.length).assertEqual(1);
      expect(arr[0].id).assertEqual(1);
      expect(arr[0].globalY).assertEqual(2);
    })
    it('BrowserArrayUtilTest_isFilterListEmpty_error', 0, () => {
      let arr: FingerInfo[] = new Array(3);
      expect(arr.length).assertEqual(3);
      arr = isFilterListEmpty(arr);
      expect(arr.length).assertEqual(0);
    })
    it('BrowserArrayUtilTest_isSublist_true', 0, () => {
      let arr1: Action[] = [];
      arr1.push(Action.VIDEO_SCREENSHOT);
      arr1.push(Action.VIDEO_SCREENSHOT_INVALID);
      let arr2: Action[] = [];
      arr2.push(Action.VIDEO_SCREENSHOT);
      let ret = isSublist(arr1, arr2);
      expect(ret).assertEqual(true);
    })
    it('BrowserArrayUtilTest_isSublist_false', 0, () => {
      let arr1: Action[] = [];
      arr1.push(Action.VIDEO_SCREENSHOT);
      arr1.push(Action.VIDEO_SCREENSHOT_INVALID);
      let arr2: Action[] = [];
      arr2.push(Action.PORTRAIT_ALBUM_DISPLAY);
      let ret = isSublist(arr1, arr2);
      expect(ret).assertEqual(false);
    })
  })
}