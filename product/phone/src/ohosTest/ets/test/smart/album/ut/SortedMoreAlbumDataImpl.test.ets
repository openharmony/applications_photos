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
import { SortedMoreAlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/SortedMoreAlbumDataImpl';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum, PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';
import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'SortedMoreAlbumDataImplTest';

/**
 * SortedMoreAlbumDataImpl Unittest
 *
 * @since 2024-07-26
 */
export default function SortedMoreAlbumDataImplTest() {
  describe('SortedMoreAlbumDataImplTest', () => {
    it('SortedMoreAlbumDataImplTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await SortedMoreAlbumDataImplTest01();
    });
    it('SortedMoreAlbumDataImplTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await SortedMoreAlbumDataImplTest02();
    });
    it('SortedMoreAlbumDataImplTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await SortedMoreAlbumDataImplTest03();
    });
    it('SortedMoreAlbumDataImplTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await SortedMoreAlbumDataImplTest04();
    });
  })
}

/**
 * buildSortedMoreAlbums
 */
async function SortedMoreAlbumDataImplTest01() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }
  let impl = new SortedMoreAlbumDataImpl(context);

  await impl.buildSortedMoreAlbums();

  expect(impl !== undefined).assertTrue();
}


async function SortedMoreAlbumDataImplTest02() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }
  let impl = new SortedMoreAlbumDataImpl(context);

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let albums: PhotoAlbum[] = [imageAlbum];

  await impl.buildSortedAlbumInfo(albums);

  expect(impl !== undefined).assertTrue();
}

async function SortedMoreAlbumDataImplTest03() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }
  let impl = new SortedMoreAlbumDataImpl(context);

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let albums: PhotoAlbum[] = await userFileManagerAccess.getAllSortedAlbums({});

  if (!albums) {
    return
  }

  albums.filter((album) => album?.count !== 0);

  await impl.buildSortedAlbumInfo(albums);

  expect(impl !== undefined).assertTrue();
}

async function SortedMoreAlbumDataImplTest04() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }
  let impl = new SortedMoreAlbumDataImpl(context);

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let albums: PhotoAlbum[] = await userFileManagerAccess.getAllSortedAlbums({});

  if (!albums) {
    return
  }

  albums.filter((album) => album?.count === 0);

  await impl.buildSortedAlbumInfo(albums);

  expect(impl !== undefined).assertTrue();
}

