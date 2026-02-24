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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { getDelayConst, GridLink } from '@ohos/common/src/main/ets/default/model/browser/photo/const/GridLinkDelay';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

export default function GridLinkDelayTest() {
  describe('GridLinkDelayTest', () => {

    //测试getDelayConst: key = GridLink.IN_PHOTO_GRID
    it('getDelayConst_when_number_is_GridLink.IN_PHOTO_GRID', 0, () => {
      let number = GridLink.IN_PHOTO_GRID;
      const res = getDelayConst(number);
      expect(res).assertEqual(100);
    });

    //测试getDelayConst: key = GridLink.OUT_SIDEBAR
    it('getDelayConst_when_number_is_GridLink.OUT_SIDEBAR', 0, () => {
      let number = GridLink.OUT_SIDEBAR;
      const res = getDelayConst(number);
      expect(res).assertEqual(0);
    });

    //测试getDelayConst: key = GridLink.ALBUM_ACTIONBAR
    it('getDelayConst_when_number_is_GridLink.ALBUM_ACTIONBAR', 0, () => {
      let number = GridLink.ALBUM_ACTIONBAR;
      const res = getDelayConst(number);
      expect(res).assertEqual(100);
    });

    //测试getDelayConst: key = GridLink.OUT_SIDEBAR_BOUNDARY_LINE
    it('getDelayConst_when_number_is_GridLink.OUT_SIDEBAR_BOUNDARY_LINE', 0, () => {
      let number = GridLink.OUT_SIDEBAR_BOUNDARY_LINE;
      const res = getDelayConst(number);
      expect(res).assertEqual(250);
    });

    //测试getDelayConst: key = GridLink.OUT_ALBUM_ACTIONBAR
    it('getDelayConst_when_number_is_GridLink.OUT_ALBUM_ACTIONBAR', 0, () => {
      let number = GridLink.OUT_ALBUM_ACTIONBAR;
      const res = getDelayConst(number);
      expect(res).assertEqual(50);
    });

    //测试getDelayConst: key = GridLink.PHOTO_GRID_ACTIONBAR and isPc = true
    it('getDelayConst_when_number_is_GridLink.PHOTO_GRID_ACTIONBAR', 0, () => {
      let mocker = new MockKit();
      const mockFuc: Function = mocker.mockFunc(DeviceInfo, DeviceInfo.isPc);
      when(mockFuc)(ArgumentMatchers.anyString).afterReturn(true);
      let number = GridLink.PHOTO_GRID_ACTIONBAR;
      const res = getDelayConst(number);
      expect(res).assertEqual(100);
      mocker.ignoreMock(DeviceInfo, DeviceInfo.isPc);
    });

  });
}