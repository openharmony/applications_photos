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
import { Rectangle, RectangleAnimated } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/types';

export default function RectangleTest() {
  describe('RectangleTest', () => {
    it('RectangleTest_01', 0, () => {
      let faceRect = new Rectangle(10,20,700,800);
      let testValue = faceRect.width();
      expect(testValue).assertEqual(700 - 10);
    });

    it('RectangleTest_02', 0, () => {
      let faceRect = new Rectangle(10,800,700,20);
      let testValue = faceRect.height();
      expect(testValue).assertEqual(20 - 800);
    });

    it('RectangleTest_03', 0, () => {
      let faceRect = new Rectangle(10,800,700,20);
      let testValue = faceRect.ratio();
      expect(testValue).assertEqual((700 - 10) / (20 - 800));
    });

    it('RectangleTest_04', 0, () => {
      let faceRect = new Rectangle(10,800,700,20);
      let testValue = faceRect.clone();
      expect(testValue).not().assertNull();
    });

    it('RectangleTest_05', 0, () => {
      let faceRect = new Rectangle(10,800,700,20);
      let testValue = faceRect.toString();
      expect(testValue).assertEqual('Rect[10,800,700,20]');
    });

    it('RectangleTest_06', 0, () => {
      let faceRect = new RectangleAnimated(10,800,700,20);
      let testValue = faceRect.plus(faceRect);
      expect(testValue.left).assertEqual(10+10);
      expect(testValue.top).assertEqual(800+800);
      expect(testValue.right).assertEqual(700+700);
      expect(testValue.bottom).assertEqual(20+20);
    });

    it('RectangleTest_07', 0, () => {
      let faceRect = new RectangleAnimated(10,800,700,20);
      let testValue = faceRect.subtract(faceRect);
      expect(testValue.left).assertEqual(10-10);
      expect(testValue.top).assertEqual(800-800);
      expect(testValue.right).assertEqual(700-700);
      expect(testValue.bottom).assertEqual(20-20);
    });

    it('RectangleTest_08', 0, () => {
      let faceRect = new RectangleAnimated(10,800,700,20);
      let testValue = faceRect.multiply(10);
      expect(testValue.left).assertEqual(10*10);
      expect(testValue.top).assertEqual(800*10);
      expect(testValue.right).assertEqual(700*10);
      expect(testValue.bottom).assertEqual(20*10);
    });

    it('RectangleTest_09', 0, () => {
      let faceRect = new RectangleAnimated(10,800,700,20);
      let testValue = faceRect.equals(faceRect);
      expect(testValue).assertTrue();
    });

    it('RectangleTest_10', 0, () => {
      let faceRect1 = new RectangleAnimated(10,800,700,20);
      let faceRect2 = new RectangleAnimated(20,500,600,30);
      let testValue = faceRect1.equals(faceRect2);
      expect(testValue).assertFalse();
    });

    it('RectangleTest_11', 0, () => {
      let faceRect1 = new RectangleAnimated(10,800,700,20);
      let faceRect2 = new RectangleAnimated(20,800,700,20);
      let testValue = faceRect1.equals(faceRect2);
      expect(testValue).assertFalse();
    });

    it('RectangleTest_12', 0, () => {
      let faceRect1 = new RectangleAnimated(10,800,700,20);
      let faceRect2 = new RectangleAnimated(10,600,700,20);
      let testValue = faceRect1.equals(faceRect2);
      expect(testValue).assertFalse();
    });

    it('RectangleTest_13', 0, () => {
      let faceRect1 = new RectangleAnimated(10,800,700,20);
      let faceRect2 = new RectangleAnimated(10,800,500,20);
      let testValue = faceRect1.equals(faceRect2);
      expect(testValue).assertFalse();
    });

    it('RectangleTest_14', 0, () => {
      let faceRect1 = new RectangleAnimated(10,800,700,20);
      let faceRect2 = new RectangleAnimated(10,800,700,30);
      let testValue = faceRect1.equals(faceRect2);
      expect(testValue).assertFalse();
    });
  });
}