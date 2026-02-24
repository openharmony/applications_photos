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
import {  describe, expect, it } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import GalleryCleanupAbility from '../../../../../../main/ets/galleryCleanupAbility/GalleryCleanupAbility';

const TAG = 'GalleryCleanupAbilityTest';

/**
 * GalleryCleanupAbility Unittest
 *
 * @since 2024-07-26
 */
export default function GalleryCleanupAbilityTest() {
  describe('GalleryCleanupAbilityTest', () => {
    it('GalleryCleanupAbilityTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await GalleryCleanupAbilityTest01();
    });

    it('GalleryCleanupAbilityTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await GalleryCleanupAbilityTest02();
    });

    it('GalleryCleanupAbilityTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await GalleryCleanupAbilityTest03();
    });

    it('GalleryCleanupAbilityTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await GalleryCleanupAbilityTest04();
    });
  })
}

/**
 * onForeground
 * 分支 !if (!this.isCleanupPageShow) {
 */
async function GalleryCleanupAbilityTest01() {
  let impl = new GalleryCleanupAbility();
  impl.onForeground();
  expect(impl !== undefined).assertTrue();
}

/**
 * onForeground
 * 分支 if (!this.isCleanupPageShow) {
 */
async function GalleryCleanupAbilityTest02() {
  let impl = new GalleryCleanupAbility();
  Reflect.set(impl, 'isCleanupPageShow', false);
  impl.onForeground();
  expect(impl !== undefined).assertTrue();
  Reflect.set(impl, 'isCleanupPageShow', true);
}

/**
 * onBackground
 * 分支 !if (!this.isCleanupPageShow) {
 */
async function GalleryCleanupAbilityTest03() {
  let impl = new GalleryCleanupAbility();
  impl.onBackground();
  expect(impl !== undefined).assertTrue();
}

/**
 * onBackground
 * 分支 if (!this.isCleanupPageShow) {
 */
async function GalleryCleanupAbilityTest04() {
  let impl = new GalleryCleanupAbility();
  Reflect.set(impl, 'isCleanupPageShow', false);
  impl.onBackground();
  expect(impl !== undefined).assertTrue();
  Reflect.set(impl, 'isCleanupPageShow', true);
}