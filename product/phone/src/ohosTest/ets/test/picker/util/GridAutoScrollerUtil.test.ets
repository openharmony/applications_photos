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
import { beforeEach, describe, expect, it } from "@ohos/hypium";
import { GridAutoScrollerUtil } from "@ohos/common/src/main/ets/default/utils/GridAutoScrollerUtil";

export default function GridAutoScrollerUtilTest() {
  describe('GridAutoScrollerUtil', () => {
    let utils: GridAutoScrollerUtil;

    beforeEach(() => {
      utils = new GridAutoScrollerUtil();
      utils.setExtraAreaWidth();
    })

    it('GridAutoScrollerUtil_autoscrollOrStopInHorizontalDirection_test01', 0, () => {
      const scroller: Scroller = new Scroller();
      Reflect.set(utils, 'isEntryFromHotAndNotScrolled', false);
      const res = utils.autoscrollOrStopInHorizontalDirection(scroller, 0.1);
      expect(res !== null).assertTrue()
    })

    it('GridAutoScrollerUtil_autoscrollOrStopInHorizontalDirection_test02', 0, () => {
      const scroller: Scroller = new Scroller();
      Reflect.set(utils, 'isEntryFromHotAndNotScrolled', true);
      Reflect.set(utils, 'oriGesturePosX', 499);
      utils.setScrollerWidth(500);
      const res = utils.autoscrollOrStopInHorizontalDirection(scroller, 499);
      expect(res !== null).assertTrue()
    })

    it('GridAutoScrollerUtil_autoscrollOrStopInHorizontalDirection_test03', 0, () => {
      const scroller: Scroller = new Scroller();
      utils.setScrollerWidth(50);
      const res = utils.autoscrollOrStopInHorizontalDirection(scroller, -1);
      expect(res !== null).assertTrue()
    })

    it('GridAutoScrollerUtil_autoscrollOrStopInHorizontalDirection_test04', 0, () => {
      const scroller: Scroller = new Scroller();
      utils.setScrollerWidth(500);
      const res = utils.autoscrollOrStopInHorizontalDirection(scroller, 600);
      expect(res !== null).assertTrue()
    })

    it('GridAutoScrollerUtil_isWantToAutoLeft_test01', 0, () => {
      Reflect.set(utils, 'oriGesturePosX', 50);
      const run = (gesturePosX: number): boolean => Reflect.get(utils, 'isWantToAutoLeft')
        .call(utils, gesturePosX);
      const res = run(40);
      expect(res).assertEqual(true);
    })

    it('GridAutoScrollerUtil_isWantToAutoLeft_test02', 0, () => {
      Reflect.set(utils, 'oriGesturePosX', 50);
      const run = (gesturePosX: number): boolean => Reflect.get(utils, 'isWantToAutoLeft')
        .call(utils, gesturePosX);
      const res = run(60);
      expect(res).assertEqual(false);
    })

    it('GridAutoScrollerUtil_isWantToAutoRight_test01', 0, () => {
      Reflect.set(utils, 'oriGesturePosX', 50);
      const run = (gesturePosX: number): boolean => Reflect.get(utils, 'isWantToAutoRight')
        .call(utils, gesturePosX);
      const res = run(40);
      expect(res).assertEqual(false);
    })

    it('GridAutoScrollerUtil_isWantToAutoRight_test02', 0, () => {
      Reflect.set(utils, 'oriGesturePosX', 50);
      const run = (gesturePosX: number): boolean => Reflect.get(utils, 'isWantToAutoRight')
        .call(utils, gesturePosX);
      const res = run(60);
      expect(res).assertEqual(true);
    })

    it('GridAutoScrollerUtil_initIsEntryFromHotAndNotScrolledInHorizontalDirection_test01', 0, () => {
      utils.setScrollerWidth(500);
      utils.initIsEntryFromHotAndNotScrolledInHorizontalDirection(800);
      const res = Reflect.get(utils, 'isEntryFromHotAndNotScrolled');
      expect(res).assertEqual(false);
    })

    it('GridAutoScrollerUtil_initIsEntryFromHotAndNotScrolledInHorizontalDirection_test02', 0, () => {
      utils.setScrollerWidth(500);
      utils.initIsEntryFromHotAndNotScrolledInHorizontalDirection(497);
      const res = Reflect.get(utils, 'isEntryFromHotAndNotScrolled');
      expect(res).assertEqual(true);
    })
  })
}