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
import { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';

export default function ThumbnailTest() {
  describe('ThumbnailTest', () => {

    //测试constructor: when width valid
    it('constructorTest_when_width_valid', 0, () => {
      let width = 1;
      let thumbnail: Thumbnail = new Thumbnail(undefined, undefined, width, undefined);
      expect(thumbnail.width).assertEqual(width);
    });

    //测试constructor: when height valid
    it('constructorTest_when_height_valid', 0, () => {
      let height = 1;
      let thumbnail: Thumbnail = new Thumbnail(undefined, undefined, undefined, height);
      expect(thumbnail.height).assertEqual(height);
    });

    //测试release
    it('releaseTest', 0, () => {
      let thumbnail: Thumbnail = new Thumbnail();
      thumbnail.release();
      expect(thumbnail.pixelMap).assertUndefined();
    });

    //测试equals
    it('should_return_true_when_all_properties_are_equal', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('url', undefined, 100, 100);
      let thumbnail2: Thumbnail = new Thumbnail('url', undefined, 100, 100);
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertTrue();
    });

    it('should_return_false_when_url_is_not_equal', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('url1', undefined, 100, 100);
      let thumbnail2: Thumbnail = new Thumbnail('url2', undefined, 100, 100);
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertFalse();
    });

    it('should_return_false_when_width_is_not_equal', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('url', undefined, 100, 100);
      let thumbnail2: Thumbnail = new Thumbnail('url', undefined, 200, 100);
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertFalse();
    });

    it('should_return_false_when_height_is_not_equal', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('url', undefined, 100, 100);
      let thumbnail2: Thumbnail = new Thumbnail('url', undefined, 100, 200);
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertFalse();
    });

    it('should_return_false_when_other_is_undefined', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('url', undefined, 100, 100);
      let thumbnail2: Thumbnail | undefined = undefined;
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertFalse();
    });

    it('should_return_true_when_all_properties_are_undefined', 0, () => {
      let thumbnail1: Thumbnail = new Thumbnail('', undefined, 0, 0);
      let thumbnail2: Thumbnail = new Thumbnail('', undefined, 0, 0);
      const result = thumbnail1.equals(thumbnail2);
      expect(result).assertTrue();
    });

  });
}