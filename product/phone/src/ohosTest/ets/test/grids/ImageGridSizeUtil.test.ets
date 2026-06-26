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
import { describe,  it, MockKit, when, ArgumentMatchers, expect } from '@ohos/hypium';
import { GridSize, ImageGridSizeUtil } from '@ohos/common/src/main/ets/default/utils/ImageGridSizeUtil';
import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

export default function ImageGridSizeUtilTest() {
  describe('ImageGridSizeUtilTest', () => {

    //isResourceBigger and justifyWidth
    it('resizeGridThumbnail_and_isResourceBigger_and_justifyWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceInfo, DeviceInfo.isPc);
      when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(true);
      let thumbnailSize: Size = {
        width : 200,
        height : 200,
      };
      let gridItemWidth = 1;
      let gridSize: GridSize = {
        thumbnailWidth: Constants.PERCENT_100,
        thumbnailHeight: Constants.PERCENT_100,
        ratio: 2,
      };
      ImageGridSizeUtil.resizeGridThumbnail(thumbnailSize, gridItemWidth, gridSize);
      expect(gridSize.thumbnailWidth).assertEqual(Constants.PERCENT_100);
      mocker.ignoreMock(DeviceInfo, DeviceInfo.isPc);
      mocker.clear(DeviceInfo);
    });

  });
}