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
import Matrix4 from '@ohos.matrix4';
import { describe, expect, it } from '@ohos/hypium';
import { AnalyzerUtil, ComponentSizeInfo, Status } from '@ohos/common/src/main/ets/default/utils/AnalyzerUtils';

export default function BrowserAnalyzerUtilTest() {
  describe('BrowserAnalyzerUtilTest', () => {
    it('BrowserAnalyzerUtilTest_isTextSelectedDrug', 0, () => {
      let status: Status = Status.UNSELECTED_TO_SELECTED;
      let isSelectedTextChange: boolean = true;
      let preGestureType: GestureControl.GestureType = GestureControl.GestureType.PAN_GESTURE;
      let gestureInfo: GestureInfo = {
        type: GestureControl.GestureType.TAP_GESTURE, isSystemGesture: true,
      };
      let mStatus: boolean = AnalyzerUtil.isTextSelectedDrug(status, isSelectedTextChange, preGestureType, gestureInfo);
      expect(mStatus).assertEqual(true);
    })

    it('BrowserAnalyzerUtilTest_isFingerListEmpty', 0, () => {
      let fingerList: FingerInfo[] = [];
      let fingerListStatus: boolean = AnalyzerUtil.isFingerListEmpty(fingerList);
      expect(fingerListStatus).assertEqual(true);
    })

    it ('BrowserAnalyzerUtilTest_isFingerList_not_Empty', 0, () => {
      let finger1: FingerInfo = {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1,
        hand: undefined
      } as FingerInfo;
      let fingerList: FingerInfo[] = [finger1];
      const res: boolean = AnalyzerUtil.isFingerListEmpty(fingerList);
      expect(res).assertFalse();
    });

    it('BrowserAnalyzerUtilTest_getScale', 0, () => {
      let matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
      let scale: number = AnalyzerUtil.getScale(matrix);
      expect(scale).assertEqual(1);
    })

    it('BrowserAnalyzerUtilTest_isFingerInComponent', 0, () => {
      let imageComponentSizeInfo: ComponentSizeInfo = {
        componentWidth: 1000,
        componentHeight: 1000,
        componentPositionX: 500,
        componentPositionY: 500,
      };
      let scale: number = 1;
      let fingerList: FingerInfo[] = [];
      let fingerInfo: FingerInfo = {
        id: 0,
        globalX: 501,
        globalY: 501,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0,
      };
      fingerList.push(fingerInfo);
      let fingerInComponent: boolean = AnalyzerUtil.isFingerInComponent(imageComponentSizeInfo, scale, fingerList);
      expect(fingerInComponent).assertEqual(true);
    })

    it ('BrowserAnalyzerUtilTest_is_not_FingerInComponent', 0, () => {
      let componentSizeInfo: ComponentSizeInfo = {
        componentWidth: 1,
        componentHeight: 1,
        componentPositionX: 100,
        componentPositionY: 1
      }
      let finger1: FingerInfo = {
        id: 1,
        globalX: 1,
        globalY: 1,
        localX: 1,
        localY: 1,
        displayX: 1,
        displayY: 1,
        hand: undefined
      } as FingerInfo;
      let fingerList: FingerInfo[] = [finger1];
      const res: boolean = AnalyzerUtil.isFingerInComponent(componentSizeInfo, 1, fingerList);
      expect(res).assertFalse();
    });
  })
}