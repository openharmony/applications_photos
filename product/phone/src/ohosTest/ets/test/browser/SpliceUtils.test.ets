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
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { SpliceUtils } from '../../../../main/ets/MovingPhotoExtension/SpliceUtils';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

export default function SpliceUtilsTest() {
  describe('SpliceUtilsTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('isAllMovingPhoto', 0, () => {
      isAllMovingPhoto();
    });
  })
}

function isAllMovingPhoto() {
  let item: MediaItem = new MediaItem();
  let mocker: MockKit = new MockKit();
  let mockFuncGetIsMovingPhoto: Function = mocker.mockFunc(item, item.getIsMovingPhoto);
  let mockFuncGetPosition: Function = mocker.mockFunc(item, item.getPosition);
  when(mockFuncGetIsMovingPhoto)().afterReturn(false);
  when(mockFuncGetPosition)().afterReturn(photoAccessHelper.PositionType.CLOUD);
  expect(SpliceUtils.isAllMovingPhoto(item)).assertEqual(false);

  when(mockFuncGetIsMovingPhoto)().afterReturn(true);
  when(mockFuncGetPosition)().afterReturn(photoAccessHelper.PositionType.LOCAL);
  expect(SpliceUtils.isAllMovingPhoto(item)).assertEqual(true);

  mocker.ignoreMock(item, item.getIsMovingPhoto);
  mocker.ignoreMock(item, item.getPosition);
}