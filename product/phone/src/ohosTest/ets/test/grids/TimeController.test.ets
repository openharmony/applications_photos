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
import { describe, it, expect } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { Animator as animator, AnimatorOptions } from '@kit.ArkUI';
import { TimeController, MViewType } from '@ohos/common/src/main/ets/default/utils/TimeController'

/**
 * TimeController Unittest
 *
 * @since 2025-05-29
 */
export default function TimeControllerTest() {
  describe('TimeControllerTest', () => {
    it('TimeControllerTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest001();
    });

    it('TimeControllerTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest002();
    });

    it('TimeControllerTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest003();
    });

    it('TimeControllerTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest004();
    });

    it('TimeControllerTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest005();
    });

    it('TimeControllerTest_006', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest006();
    });

    it('TimeControllerTest_007', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest007();
    });

    it('TimeControllerTest_008', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest008();
    });

    it('TimeControllerTest_009', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest009();
    });

    it('TimeControllerTest_010', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest010();
    });

    it('TimeControllerTest_011', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest011();
    });

    it('TimeControllerTest_012', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest012();
    });

    it('TimeControllerTest_013', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest013();
    });

    it('TimeControllerTest_014', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest014();
    });

    it('TimeControllerTest_015', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest015();
    });

    it('TimeControllerTest_016', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest016();
    });

    it('TimeControllerTest_017', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest017();
    });

    it('TimeControllerTest_018', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest018();
    });

    it('TimeControllerTest_019', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest019();
    });

    it('TimeControllerTest_020', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest020();
    });

    it('TimeControllerTest_021', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest021();
    });

    it('TimeControllerTest_022', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest022();
    });

    it('TimeControllerTest_023', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest023();
    });

    it('TimeControllerTest_024', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest024();
    });

    it('TimeControllerTest_025', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest025();
    });

    it('TimeControllerTest_026', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await TimeControllerTest026();
    });
  })
}

/**
 * updateTimeOpacity
 * 分支 endOpacity === Constants.TRANSPARENT && !((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
 * this.yearViewLeftCapsulesOpacity !== endOpacity)
 */
async function TimeControllerTest001() {
  let timeController = new TimeController();
  timeController.updateTimeOpacity(MViewType.MONTH, MViewType.MONTH, 0, 2, false);
  expect(timeController.isShowYearCapsules).assertEqual(false);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
}

/**
 * updateTimeOpacity
 * 分支 endOpacity !== Constants.TRANSPARENT && !((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
 * this.yearViewLeftCapsulesOpacity !== endOpacity)
 */
async function TimeControllerTest002() {
  let timeController = new TimeController();
  timeController.updateTimeOpacity(MViewType.MONTH, MViewType.MONTH, 1, 2, true);
  expect(timeController.isShowYearCapsules).assertEqual(true);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
}

/**
 * updateTimeOpacity
 * 分支 endOpacity !== Constants.TRANSPARENT && ((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
 * this.yearViewLeftCapsulesOpacity !== endOpacity) && !isStartYearOpacity && endOpacity === Constants.OPAQUE
 */
async function TimeControllerTest003() {
  let timeController = new TimeController();
  timeController.updateTimeOpacity(MViewType.YEAR, MViewType.YEAR, 1, 2, true);
  expect(timeController.isStartYearOpacity ).assertEqual(true);
}

/**
 * updateTimeOpacity
 * 分支 endOpacity !== Constants.TRANSPARENT && ((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
 * this.yearViewLeftCapsulesOpacity !== endOpacity) && !isStartYearOpacity && endOpacity === Constants.OPAQUE
 */
async function TimeControllerTest004() {
  let timeController = new TimeController();
  timeController.updateTimeOpacity(MViewType.YEAR, MViewType.YEAR, 2, 2, true);
  expect(timeController.isStartYearOpacity ).assertEqual(true);
}

/**
 * updateTimeOpacity
 * 分支 endOpacity !== Constants.TRANSPARENT && ((currentType === MViewType.YEAR || targetType === MViewType.YEAR) && isInImmersive &&
 * this.yearViewLeftCapsulesOpacity !== endOpacity) && isStartYearOpacity
 */
async function TimeControllerTest005() {
  let timeController = new TimeController();
  timeController.isStartYearOpacity = true;
  timeController.updateTimeOpacity(MViewType.YEAR, MViewType.YEAR, 1, 2, true);
  expect(timeController.isShowYearCapsules).assertEqual(true);
}

/**
 * handleOtherSceneOpacity
 * 分支  !(currentType === MViewType.MONTH && targetType === MViewType.YEAR) && isInImmersive && targetType == MViewType.YEAR
 */
async function TimeControllerTest006() {
  let timeController = new TimeController();
  const run = (currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void => Reflect.get(timeController, 'handleOtherSceneOpacity')
    .call(timeController, MViewType.YEAR, MViewType.YEAR, true);
  run(MViewType.YEAR, MViewType.YEAR, true);
  expect(timeController.singleTitleOpacity).assertEqual(0);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(1);
}

/**
 * handleOtherSceneOpacity
 * 分支  !(currentType === MViewType.MONTH && targetType === MViewType.YEAR) && isInImmersive && targetType !== MViewType.YEAR
 */
async function TimeControllerTest007() {
  let timeController = new TimeController();
  const run = (currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void => Reflect.get(timeController, 'handleOtherSceneOpacity')
    .call(timeController, MViewType.YEAR, MViewType.MONTH, true);
  run(MViewType.YEAR, MViewType.MONTH, true);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
}

/**
 * handleOtherSceneOpacity
 * 分支  !(currentType === MViewType.MONTH && targetType === MViewType.YEAR) && !isInImmersive
 */
async function TimeControllerTest008() {
  let timeController = new TimeController();
  const run = (currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void => Reflect.get(timeController, 'handleOtherSceneOpacity')
    .call(timeController, MViewType.YEAR, MViewType.MONTH, false);
  run(MViewType.YEAR, MViewType.MONTH, false);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
}

/**
 * handleOtherSceneOpacity
 * 分支  (currentType === MViewType.MONTH && targetType === MViewType.YEAR) && isInImmersive
 */
async function TimeControllerTest009() {
  let timeController = new TimeController();
  const run = (currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void => Reflect.get(timeController, 'handleOtherSceneOpacity')
    .call(timeController, MViewType.MONTH, MViewType.YEAR, true);
  run(MViewType.MONTH, MViewType.YEAR, true);
  expect(timeController.singleTitleOpacity).assertEqual(0);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(1);
}

/**
 * handleOtherSceneOpacity
 * 分支  (currentType === MViewType.MONTH && targetType === MViewType.YEAR) && !isInImmersive
 */
async function TimeControllerTest010() {
  let timeController = new TimeController();
  const run = (currentType: MViewType, targetType: MViewType, isInImmersive: boolean): void => Reflect.get(timeController, 'handleOtherSceneOpacity')
    .call(timeController, MViewType.MONTH, MViewType.YEAR, false);
  run(MViewType.MONTH, MViewType.YEAR, false);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
}

/**
 * updateCapsulesOpacityAnimator
 * 分支 !opacityAnimator
 */
async function TimeControllerTest011() {
  let timeController = new TimeController();
  const updateCapsulesOpacityAnimator = (durationTime: number, startOpacity: number, endOpacity: number): void  => Reflect.get(timeController, 'updateCapsulesOpacityAnimator')
    .call(timeController, 2, 1, 2);
  updateCapsulesOpacityAnimator(2, 1, 2);
  expect(timeController.isStartYearOpacity).assertEqual(false);
}

/**
 * updateCapsulesOpacityAnimator
 * 分支 opacityAnimator
 */
async function TimeControllerTest012() {
  let timeController = new TimeController();
  const createAnimatorOptions = (durationTime: number, delayTime: number, startValue: number,
    endValue: number, easingType: string): AnimatorOptions => Reflect.get(timeController, 'createAnimatorOptions')
    .call(timeController, 2, 0, 1, 2, 'sharp');
  let options: AnimatorOptions = createAnimatorOptions(2, 0, 1, 2, 'sharp');
  let opacityAnimator = animator.create(options);
  Reflect.set(timeController, 'opacityAnimator', opacityAnimator);

  const updateCapsulesOpacityAnimator = (durationTime: number, startOpacity: number, endOpacity: number): void  => Reflect.get(timeController, 'updateCapsulesOpacityAnimator')
    .call(timeController, 2, 1, 2);
  updateCapsulesOpacityAnimator(2, 1, 2);
  expect(timeController.isStartYearOpacity).assertEqual(false);
}

/**
 * pauseOpacityAnimator
 * 分支 opacityAnimator
 */
async function TimeControllerTest013() {
  let timeController = new TimeController();
  const run = (durationTime: number, delayTime: number, startValue: number,
    endValue: number, easingType: string): AnimatorOptions => Reflect.get(timeController, 'createAnimatorOptions')
    .call(timeController, 2, 0, 1, 2, 'sharp');
  let options: AnimatorOptions = run(2, 0, 1, 2, 'sharp');
  let opacityAnimator = animator.create(options);
  Reflect.set(timeController, 'opacityAnimator', opacityAnimator);
  timeController.pauseOpacityAnimator();
  expect(timeController.isStartYearOpacity).assertEqual(false);
}

/**
 * pauseOpacityAnimator
 * 分支 !opacityAnimator
 */
async function TimeControllerTest014() {
  let timeController = new TimeController();
  timeController.pauseOpacityAnimator();
  expect(timeController.isShowYearCapsules).assertEqual(false);
}

/**
 * handleSingleTitleOpacity
 * 分支 endOpacity === Constants.TRANSPARENT && progress > this.timeOpacityStartThreshold
 */
async function TimeControllerTest015() {
  let timeController = new TimeController();
  const run = (endOpacity: number, progress: number): void => Reflect.get(timeController, 'handleSingleTitleOpacity')
    .call(timeController, 0, 100);
  run(0, 100);
  expect(timeController.singleTitleOpacity).assertEqual(1);
}

/**
 * handleSingleTitleOpacity
 * 分支 endOpacity === Constants.TRANSPARENT && progress <= this.timeOpacityStartThreshold
 */
async function TimeControllerTest016() {
  let timeController = new TimeController();
  const run2 = (endOpacity: number, progress: number): void => Reflect.get(timeController, 'handleSingleTitleOpacity')
    .call(timeController, 0, 0);
  run2(0, 0);
  expect(timeController.singleTitleOpacity).assertEqual(1);
}

/**
 * handleSingleTitleOpacity
 * 分支 endOpacity != Constants.TRANSPARENT && progress <= this.timeOpacityStartThreshold
 */
async function TimeControllerTest017() {
  let timeController = new TimeController();
  const run = (endOpacity: number, progress: number): void => Reflect.get(timeController, 'handleSingleTitleOpacity')
    .call(timeController, 1, 0);
  run(1, 0);
  expect(timeController.singleTitleOpacity).assertEqual(1);
}

/**
 * handleSingleTitleOpacity
 * 分支 endOpacity != Constants.TRANSPARENT && progress > this.timeOpacityStartThreshold
 */
async function TimeControllerTest018() {
  let timeController = new TimeController();
  const run2 = (endOpacity: number, progress: number): void => Reflect.get(timeController, 'handleSingleTitleOpacity')
    .call(timeController, 1, 100);
  run2(1, 100);
  expect(timeController.singleTitleOpacity).assertEqual(0);
}

/**
 * startCapsuleAndSingleTitleVisibilityAnimation
 * 分支 isScrollerBarTouch
 */
async function TimeControllerTest019() {
  let timeController = new TimeController();
  timeController.startCapsuleAndSingleTitleVisibilityAnimation(true, true, MViewType.YEAR);
  expect(timeController.singleTitleOpacity).assertEqual(1);
  expect(timeController.yearViewLeftCapsulesOpacity).assertEqual(0);
  expect(timeController.timelineScrollerLeftCapsulesOpacity).assertEqual(1);
  expect(timeController.timelineScrollerOpacity).assertEqual(1);
}

/**
 * startScrollerCapsuleAnimation
 * 分支 isScrollTouch
 */
async function TimeControllerTest020() {
  let timeController = new TimeController();
  timeController.startScrollerCapsuleAnimation(true, true, true, MViewType.YEAR);
  expect(timeController.timelineScrollerOpacity).assertEqual(0);
}

/**
 * startScrollerCapsuleAnimation
 * 分支 isScrollStop
 */
async function TimeControllerTest021() {
  let timeController = new TimeController();
  timeController.startScrollerCapsuleAnimation(true, false, true, MViewType.YEAR);
  expect(timeController.timelineScrollerOpacity).assertEqual(0);
}

/**
 * updateYearViewLeftCapsulesOpacityByDelay
 * 分支 timelineScrollerLeftCapsulesOpacity !== Constants.TRANSPARENT
 */
async function TimeControllerTest022() {
  let timeController = new TimeController();
  timeController.timelineScrollerLeftCapsulesOpacity = 1;
  timeController.startScrollerCapsuleAnimation(true, false, true, MViewType.YEAR);
  expect(timeController.timelineScrollerOpacity).assertEqual(0);
}

/**
 * updateMultiSelectState
 * 设置isShowMultiSelect值
 */
async function TimeControllerTest023() {
  let timeController = new TimeController();
  timeController.updateMultiSelectState(true);
  expect(timeController.isShowMultiSelect).assertTrue();
}

/**
 * updateMultiSelectUseAnimation
 * 设置isMultiSelectUseAnimation值
 */
async function TimeControllerTest024() {
  let timeController = new TimeController();
  timeController.updateMultiSelectUseAnimation(true);
  expect(timeController.isMultiSelectUseAnimation).assertTrue();
}

/**
 * updateScrollerOpacity
 * 设置timelineScrollerOpacity
 */
async function TimeControllerTest025() {
  let timeController = new TimeController();
  timeController.updateScrollerOpacity();
  expect(timeController.timelineScrollerOpacity).assertEqual(0);
  expect(timeController.timelineScrollerLeftCapsulesOpacity).assertEqual(0);
}

/**
 * startCapsuleAndSingleTitleVisibilityAnimation
 * 分支 !isScrollerBarTouch
 */
async function TimeControllerTest026() {
  let timeController = new TimeController();
  timeController.startCapsuleAndSingleTitleVisibilityAnimation(false, true, MViewType.YEAR);
  expect(timeController.timelineScrollerOpacity).assertEqual(0);
}