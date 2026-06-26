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
import { YearMonthUtil } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthUtil';
import { SendablePhotoAccessHelper } from '@ohos/common/src/main/ets/default/access/SendablePhotoAccessHelper';
export default function YearMonthUtilTest() {

  describe('YearMonthUtilTest', () => {

    //测试generateYearMonthViewKey
    it ('generateYearMonthViewKey', 0, () => {
      let currentView = 'currentView';
      let itemCountPerGroup = 1;
      let itemColumnPerGroup = 1;
      let viewIndex = 1;
      let fillPosition = 1;
      const res = YearMonthUtil.generateYearMonthViewKey(currentView, itemCountPerGroup, itemColumnPerGroup, viewIndex, fillPosition);
      expect(res).assertEqual(`${currentView}_${itemCountPerGroup}_${itemColumnPerGroup}_${viewIndex}_${fillPosition ?? 0}`);
      YearMonthUtil.queryMediaItem(SendablePhotoAccessHelper.getInstance(),1,1,1,true);
    });

    //测试queryMediaItem: return []
    it ('queryMediaItem_when_start_is_smaller_than_zero', 0, () => {
      let start = -1;
      let count = 1;
      let priority = 1;
      let isThumbnailReady = true;
      let instance = SendablePhotoAccessHelper.getInstance();
      const res = YearMonthUtil.queryMediaItem(instance, start, count, priority, isThumbnailReady);
      expect(res.length === 0).assertTrue();
    });

    //测试queryMediaItem: return []
    it ('queryMediaItem_when_assets_null', 0, () => {
      let start = 1;
      let count = 1;
      let priority = 1;
      let isThumbnailReady = true;
      let instance = SendablePhotoAccessHelper.getInstance();
      const res = YearMonthUtil.queryMediaItem(instance, start, count, priority, isThumbnailReady);
      expect(res.length === 0).assertTrue();
    });
  });
}