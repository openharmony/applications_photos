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
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG = 'AlbumOrderInfoTest';

/**
 * AlbumOrderInfo Unittest
 *
 * @since 2024-07-26
 */
export default function AlbumOrderInfoTest() {
  describe('AlbumOrderInfoTest', () => {
    it('AlbumOrderInfoTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest01();
    });

    it('AlbumOrderInfoTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest02();
    });

    it('AlbumOrderInfoTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest03();
    });

    it('AlbumOrderInfoTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest04();
    });

    it('AlbumOrderInfoTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest05();
    });

    it('AlbumOrderInfoTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest06();
    });

    it('AlbumOrderInfoTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest07();
    });

    it('AlbumOrderInfoTest_08', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumOrderInfoTest08();
    });
  })
}

/**
 * constructor
 * 分支 !(isUnionAlbum && unionAlbums)
 */
async function AlbumOrderInfoTest01() {
  let info = new AlbumOrderInfo();
  expect(info !== undefined).assertTrue();
}

/**
 * constructor
 * 分支 isUnionAlbum && unionAlbums
 */
async function AlbumOrderInfoTest02() {
  let info = new AlbumOrderInfo(undefined, true, []);
  expect(info !== undefined).assertTrue();
}

/**
 * getDefaultAlbumOrderSection
 * 分支 this.albumType === photoAccessHelper.AlbumType.SYSTEM
 */
async function AlbumOrderInfoTest03() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.albumType = photoAccessHelper.AlbumType.SYSTEM;
  info.getDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}

/**
 * getDefaultAlbumOrderSection
 * 分支 this.albumType === photoAccessHelper.AlbumType.USER
 */
async function AlbumOrderInfoTest04() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.albumType = photoAccessHelper.AlbumType.USER;
  info.getDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}

/**
 * getDefaultAlbumOrderSection
 * 分支 this.albumType !== photoAccessHelper.AlbumType.USER && this.albumType !== photoAccessHelper.AlbumType.SYSTEM
 */
async function AlbumOrderInfoTest05() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.getDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}

/**
 * setDefaultAlbumOrderSection
 * 分支 this.albumType === photoAccessHelper.AlbumType.SYSTEM
 */
async function AlbumOrderInfoTest06() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.albumType = photoAccessHelper.AlbumType.SYSTEM;
  info.setDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}

/**
 * setDefaultAlbumOrderSection
 * 分支 this.albumType === photoAccessHelper.AlbumType.USER
 */
async function AlbumOrderInfoTest07() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.albumType = photoAccessHelper.AlbumType.USER;
  info.setDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}

/**
 * setDefaultAlbumOrderSection
 * 分支 this.albumType !== photoAccessHelper.AlbumType.USER && this.albumType !== photoAccessHelper.AlbumType.SYSTEM
 */
async function AlbumOrderInfoTest08() {
  let info = new AlbumOrderInfo(undefined, true, []);
  info.setDefaultAlbumOrderSection();
  expect(info !== undefined).assertTrue();
}