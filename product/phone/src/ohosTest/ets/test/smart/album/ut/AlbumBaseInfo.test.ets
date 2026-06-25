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
import { AlbumBaseInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumBaseInfo';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';

const TAG = 'AlbumBaseInfoTest';

/**
 * AlbumBaseInfo Unittest
 *
 * @since 2024-07-26
 */
export default function AlbumBaseInfoTest() {
  describe('AlbumBaseInfoTest', () => {
    it('AlbumBaseInfoTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumBaseInfoTest01();
    });

    it('AlbumBaseInfoTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumBaseInfoTest02();
    });
  })
}

/**
 * constructor
 * 分支 !album
 */
async function AlbumBaseInfoTest01() {
  let impl = new AlbumBaseInfo();
  expect(impl !== undefined).assertTrue();
}

/**
 * constructor
 * 分支 album
 */
async function AlbumBaseInfoTest02() {
  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let impl = new AlbumBaseInfo(imageAlbum);

  expect(impl !== undefined).assertTrue();
}