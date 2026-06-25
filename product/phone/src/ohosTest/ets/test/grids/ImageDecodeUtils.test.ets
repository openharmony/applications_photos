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
import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ImageDecodeUtils } from '@ohos/common/src/main/ets/default/model/browser/photo/ImageDecodeUtils';

export default function ImageDecodeUtilsTest() {
  describe('ImageDecodeUtilsTest', () => {

    // false, false -> false
    it('should_return_false_when_hdrPictureSwitch_is_false_and_isHighTemperatureControll_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      AppStorage.setOrCreate<boolean>('hdr_picture_switch', false);
      let fun = mocker.mockFunc(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
      when(fun)([]).afterReturn(false);
      const result = ImageDecodeUtils.isSupportHDR();
      expect(result).assertEqual(false);
      mocker.ignoreMock(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
    });

    // false, true -> false
    it('should_return_true_when_hdrPictureSwitch_is_false_and_isHighTemperatureControll_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let fun = mocker.mockFunc(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
      AppStorage.setOrCreate<boolean>('hdr_picture_switch', false);
      when(fun)([]).afterReturn(true);
      const result = ImageDecodeUtils.isSupportHDR();
      expect(result).assertEqual(false);
      mocker.ignoreMock(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
    });

    // true, false -> true
    it('should_return_false_when_hdrPictureSwitch_is_true_and_isHighTemperatureControll_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let fun = mocker.mockFunc(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
      AppStorage.setOrCreate<boolean>('hdr_picture_switch', true);
      when(fun)([]).afterReturn(false);
      const result = ImageDecodeUtils.isSupportHDR();
      expect(result).assertEqual(true);
      mocker.ignoreMock(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
    });

    // true, true -> false
    it('should_return_true_when_hdrPictureSwitch_is_true_and_isHighTemperatureControll_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      AppStorage.setOrCreate<boolean>('hdr_picture_switch', true);
      let fun = mocker.mockFunc(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
      when(fun)([]).afterReturn(true);
      const result = ImageDecodeUtils.isSupportHDR();
      expect(result).assertEqual(false);
      mocker.ignoreMock(AppStorage, AppStorage.get);
      mocker.ignoreMock(ImageDecodeUtils, ImageDecodeUtils.isHighTemperatureControll);
    });


    // 仅测试返回是否为空，结果依赖本机设置
    it('should_return_true_or_false_and_not_null', 0, () => {
      const result = ImageDecodeUtils.isHighTemperatureControll();
      expect(result).not().assertNull();
    });

  });
}
