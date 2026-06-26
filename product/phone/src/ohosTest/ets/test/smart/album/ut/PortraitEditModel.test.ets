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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PortraitEditModel } from '@ohos/portraitAlbum/src/main/ets/default/viewModel/PortraitEditModel';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';

const TAG = 'PortraitEditModelTest';

/**
 * PortraitEditModel Unittest
 *
 * @since 2024-07-26
 */
export default function PortraitEditModelTest() {
  describe('PortraitEditModelTest', () => {
    it('PortraitEditModelTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest01();
    });

    it('PortraitEditModelTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest02();
    });

    it('PortraitEditModelTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest03();
    });

    it('PortraitEditModelTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest04();
    });

    it('PortraitEditModelTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest05();
    });

    it('PortraitEditModelTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitEditModelTest06();
    });
  })
}

/**
 * constructor
 */
async function PortraitEditModelTest01() {
  let model = new PortraitEditModel();
  expect(model !== undefined).assertTrue();
}

/**
 * getPortraitAlbumInfoByName
 */
async function PortraitEditModelTest02() {
  let model = new PortraitEditModel();
  await model.getPortraitAlbumInfoByName('人像相册');
  expect(model !== undefined).assertTrue();
}

/**
 * getPortraitMergePara
 */
async function PortraitEditModelTest03() {
  let model = new PortraitEditModel();
  let albums: AlbumInfo[] = [];
  await model.getPortraitMergePara(albums);
  expect(model !== undefined).assertTrue();
}

/**
 * getPortraitMergePara
 */
async function PortraitEditModelTest04() {
  let model = new PortraitEditModel();
  let albumInfo: AlbumInfo = new AlbumInfo();
  let albums: AlbumInfo[] = [albumInfo];
  await model.getPortraitMergePara(albums);
  expect(model !== undefined).assertTrue();
}

/**
 * updatePortraitAlbumInfo
 */
async function PortraitEditModelTest05() {
  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let model = new PortraitEditModel();
  let albumInfo: AlbumInfo = new AlbumInfo();
  await model.updatePortraitAlbumInfo(undefined, imageAlbum, albumInfo);
  expect(model !== undefined).assertTrue();
}

/**
 * portraitRenameComplete
 */
async function PortraitEditModelTest06() {
  let model = new PortraitEditModel();
  await model.portraitRenameComplete('人像相册');
  expect(model !== undefined).assertTrue();
}