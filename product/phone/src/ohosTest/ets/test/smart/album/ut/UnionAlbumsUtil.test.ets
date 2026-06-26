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
import { buildUnionAlbumInfo } from '@ohos/common/src/main/ets/default/utils/UnionAlbumsUtil';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';

const TAG = 'UnionAlbumsUtilTest';

/**
 * UnionAlbumsUtil Unittest
 *
 * @since 2024-07-26
 */
export default function UnionAlbumsUtilTest() {
  describe('UnionAlbumsUtilTest', () => {
    it('UnionAlbumsUtilTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await UnionAlbumsUtilTest01();
    });

    it('UnionAlbumsUtilTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await UnionAlbumsUtilTest02();
    });

    it('UnionAlbumsUtilTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await UnionAlbumsUtilTest03();
    });

    it('UnionAlbumsUtilTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await UnionAlbumsUtilTest04();
    });
  })
}

/**
 * buildUnionAlbumInfo
 * 分支 filterMediaType !== AlbumDefine.FILTER_MEDIA_TYPE_IMAGE
 */
async function UnionAlbumsUtilTest01() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let albums: PhotoAlbum[] = [imageAlbum];
  await buildUnionAlbumInfo(albums);
  expect(context !== undefined).assertTrue();
}


async function UnionAlbumsUtilTest02() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let albums: PhotoAlbum[] = [imageAlbum];
  await buildUnionAlbumInfo(albums, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
  expect(context !== undefined).assertTrue();
}


async function UnionAlbumsUtilTest03() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let albums: PhotoAlbum[] = [imageAlbum];
  await buildUnionAlbumInfo(albums, AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
  expect(context !== undefined).assertTrue();
}

async function UnionAlbumsUtilTest04() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (!context) {
    return
  }

  let userFileManagerAccess = new UserFileManagerAccess();
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let albums: PhotoAlbum[] = [imageAlbum];
  await buildUnionAlbumInfo(albums, AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
  expect(context !== undefined).assertTrue();
}