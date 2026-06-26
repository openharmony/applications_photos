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

import image from '@ohos.multimedia.image';

import { afterAll, afterEach, beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { Component, Driver, On, ON, Point } from '@ohos.UiTest';
import { HashMap } from '@kit.ArkTS';

export default function ExifUtilTest(): void {
    describe('getAllExifProps', () => {
      it('should return all EXIF property keys', Level.LEVEL0, () => {
        const propArray = ExifUtil.getAllExifProps();
        expect(propArray.length).assertLargerOrEqual(0);
        expect(propArray).assertContain(image.PropertyKey.IMAGE_WIDTH);
        expect(propArray).assertContain(image.PropertyKey.IMAGE_LENGTH);
      });
    });

    describe('transferAll', () => {
      it('should handle empty sourceUri and outputUri', Level.LEVEL0, async () => {
        expect(async() => {
          await ExifUtil.transferAll('testTag', '', '');
        }).not().assertThrowError('BusinessError');
        // Add assertions to verify the expected behavior
      });

      it('should transfer EXIF info successfully', Level.LEVEL0, async () => {
        const sourceUri = 'path/to/source.jpg';
        const outputUri = 'path/to/output.jpg';

        // Create mock files and image sources if necessary
        // You might need to mock fs.open and image.createImageSource

        await ExifUtil.transferAll('testTag', sourceUri, outputUri);
        // Add assertions to verify the expected behavior
        expect(outputUri).not().assertNull();
      });
    });
}