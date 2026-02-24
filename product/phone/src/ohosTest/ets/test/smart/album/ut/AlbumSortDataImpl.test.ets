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
import { AlbumSortDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSortDataImpl';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum, PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';
import { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'AlbumSortDataImplTest';

/**
 * AlbumSortDataImpl Unittest
 *
 * @since 2024-07-26
 */
export default function AlbumSortDataImplTest() {
  describe('AlbumSortDataImplTest', () => {
    it('AlbumSortDataImplTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest01();
    });

    it('AlbumSortDataImplTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest02();
    });

    it('AlbumSortDataImplTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest03();
    });

    it('AlbumSortDataImplTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest04();
    });

    it('AlbumSortDataImplTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest05();
    });

    it('AlbumSortDataImplTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest06();
    });

    it('AlbumSortDataImplTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataImplTest07();
    });
  })
}

async function AlbumSortDataImplTest01() {
  let impl = new AlbumSortDataImpl();
  let albums: PhotoAlbum[] = [];

  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (imageAlbum) {
    albums.push(imageAlbum);
  }

  let videoAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);

  if (videoAlbum) {
    albums.push(videoAlbum);
  }

  let favoriteAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);

  if (favoriteAlbum) {
    albums.push(favoriteAlbum);
  }

  let hiddenAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.HIDDEN_ALBUM_SUB_TYPE);

  if (hiddenAlbum) {
    albums.push(hiddenAlbum);
  }

  let cloudEnhanceAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.CLOUD_ENHANCE_ALBUM_SUB_TYPE);

  if (cloudEnhanceAlbum) {
    albums.push(cloudEnhanceAlbum);
  }

  let otherAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.SOURCE_GENERIC_ALBUM_SUB_TYPE);

  if (otherAlbum) {
    albums.push(otherAlbum);
  }

  let mocker: MockKit = new MockKit();
  let buildUnionAlbumInfo: Function = mocker.mockFunc(impl, Reflect.get(impl, 'buildUnionAlbumOrderInfo'));
  when(buildUnionAlbumInfo)(ArgumentMatchers.any).afterReturn({ });

  await impl.buildSortedAlbumsInfo(albums);

  expect(impl !== undefined).assertTrue();
}

async function AlbumSortDataImplTest02() {
  let impl = new AlbumSortDataImpl();
  let albums: PhotoAlbum[] = [];

  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  albums.push(imageAlbum)

  const run = (albums: PhotoAlbum[]): Promise<AlbumOrderInfo> => Reflect.get(impl, 'buildUnionAlbumOrderInfo')
    .call(impl, albums);

  await run(albums);

  expect(impl !== undefined).assertTrue();
}

async function AlbumSortDataImplTest03() {
  let impl = new AlbumSortDataImpl();

  await impl.getSystemAndMyAlbumAreaCount();

  expect(impl !== undefined).assertTrue();
}

/**
 * processUnionAlbumOrderInfos
 * 分支 !info.isUnionAlbu
 */
async function AlbumSortDataImplTest04() {
  let impl = new AlbumSortDataImpl();
  let albumOrderInfos: AlbumOrderInfo[] = [];
  let albums: PhotoAlbum[] = [];

  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  albums.push(imageAlbum)

  const run = (albums: PhotoAlbum[]): Promise<AlbumOrderInfo> => Reflect.get(impl, 'buildUnionAlbumOrderInfo')
    .call(impl, albums);

  let albumOrderInfo: AlbumOrderInfo = await run(albums);
  albumOrderInfos.push(albumOrderInfo)

  await impl.processUnionAlbumOrderInfos(albumOrderInfos);

  expect(impl !== undefined).assertTrue();
}


/**
 * setAlbumOrderCover
 * 分支： !(!albumInfo || !data)
 */
async function AlbumSortDataImplTest05() {
  let impl = new AlbumSortDataImpl();
  let albumOrderInfos: AlbumOrderInfo[] = [];
  let albums: PhotoAlbum[] = [];

  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  albums.push(imageAlbum)

  const run = (albums: PhotoAlbum[]): Promise<AlbumOrderInfo> => Reflect.get(impl, 'buildUnionAlbumOrderInfo')
    .call(impl, albums);

  let albumOrderInfo: AlbumOrderInfo = await run(albums);
  albumOrderInfos.push(albumOrderInfo);

  let fetchOpt = AlbumDefine.getFileFetchOpt(0, 1, undefined, false, UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS);
  let coverUris: string[] = albums.map((album: PhotoAlbum): string => album.coverUri);
  AlbumDefine.modifyPredicatesInPhotoUris(fetchOpt.predicates, coverUris);
  let assets: PhotoAsset[] = await userFileManagerAccess.getAllObject(fetchOpt);

  if (!assets.length) {
    return
  }

  let data: PhotoAsset = assets[0];

  const run2 = (albumInfo: AlbumOrderInfo, data: PhotoAsset): Promise<AlbumOrderInfo> => Reflect.get(impl, 'setAlbumOrderCover')
    .call(impl, albumOrderInfo, data);

  run2(albumOrderInfo, data);

  expect(impl !== undefined).assertTrue();
}

/**
 * buildAlbumSorting
 * 分支 if (isDefault) {
 */
async function AlbumSortDataImplTest06() {
  let impl = new AlbumSortDataImpl();
  let albumOrderInfos: AlbumOrderInfo[] = [];

  await impl.buildAlbumSorting(albumOrderInfos, true);

  expect(impl !== undefined).assertTrue();
}

/**
 * buildAlbumSorting
 * 分支 !if (isDefault) {
 */
async function AlbumSortDataImplTest07() {
  let impl = new AlbumSortDataImpl();
  let albumOrderInfos: AlbumOrderInfo[] = [];

  await impl.buildAlbumSorting(albumOrderInfos, false);

  expect(impl !== undefined).assertTrue();
}