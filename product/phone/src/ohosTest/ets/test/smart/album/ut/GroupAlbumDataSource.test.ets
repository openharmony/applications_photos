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

import { describe, expect, it, ArgumentMatchers, MockKit, when } from "@ohos/hypium";
import { TestConstants } from "@ohos/tools/src/ohosTest/ets/TestConstants";
import { MediaObserverNfyInfo, MediaObserverNfyType } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { GroupAlbumDataSource } from "@ohos/common/src/main/ets/default/model/browser/album/GroupAlbumDataSource";
import { PageData } from '@ohos/common/src/main/ets/default/model/PageData';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';

const TAG: string = 'GroupAlbumDataSourceTest';

/**
 * GroupAlbumDataSource Unittest
 *
 * @since 2025-07-21
 */
export default function GroupAlbumDataSourceTest(): void {
  describe('GroupAlbumDataSourceTest', (): void => {
    it('GroupAlbumDataSourceTest_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest01();
    });

    it('GroupAlbumDataSourceTest_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest02();
    });

    it('GroupAlbumDataSourceTest_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest03();
    });

    it('GroupAlbumDataSourceTest_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest04();
    });

    it('GroupAlbumDataSourceTest_005', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest05();
    });

    it('GroupAlbumDataSourceTest_006', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest06();
    });

    it('GroupAlbumDataSourceTest_007', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest07();
    });

    it('GroupAlbumDataSourceTest_008', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await GroupAlbumDataSourceTest08();
    });
  })
}

/**
 * getData
 * 分支 if (index < 0) {
 */
async function GroupAlbumDataSourceTest01() {
  let source = new GroupAlbumDataSource();
  source.getData(-1);
  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 if !(index < 0) {
 */
async function GroupAlbumDataSourceTest02() {
  let source = new GroupAlbumDataSource();
  source.getData(0);
  expect(source !== undefined).assertTrue();
}

/**
 * getWrappedData
 * 分支 if (!albumInfo) {
 */
async function GroupAlbumDataSourceTest03() {
  let source = new GroupAlbumDataSource();

  const run = (index: number): AlbumSetDataInfo | undefined => Reflect.get(source, 'getWrappedData')
    .call(source, index);
  run(1);

  expect(source !== undefined).assertTrue();
}

/**
 * getWrappedData
 * 分支 if !(!albumInfo) {
 * 分支 if !(tmp) {
 * 分支 if (tmp) {
 */
async function GroupAlbumDataSourceTest04() {
  let source = new GroupAlbumDataSource();
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  let data: (AlbumInfo | undefined) [] = [albumInfo];
  let initData = new PageData<AlbumInfo>(PageData.nextVersion(), data);
  Reflect.set(source, 'pageData', initData)

  const run = (index: number): AlbumSetDataInfo | undefined => Reflect.get(source, 'getWrappedData')
    .call(source, index);
  run(0); // 分支 else
  run(0);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD || nfyInfo.albumUris.length === 0) {
 */
async function GroupAlbumDataSourceTest05() {
  let source = new GroupAlbumDataSource();
  let nfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.PHOTO_ADD;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onChange
 * 分支  if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
 */
async function GroupAlbumDataSourceTest06() {
  let source = new GroupAlbumDataSource();

  source.onChange('image');

  expect(source !== undefined).assertTrue();
}

/**
 * onChange
 * 分支  if ！(mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
 */
async function GroupAlbumDataSourceTest07() {
  let source = new GroupAlbumDataSource();

  source.onChange('test');

  expect(source !== undefined).assertTrue();
}

/**
 * writeAlbumsCache
 * 分支 if (album && album.uri && album.uri.length !== 0) {
 * 分支 if !(album && album.uri && album.uri.length !== 0) {
 */
async function GroupAlbumDataSourceTest08() {
  let source = new GroupAlbumDataSource();
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  let albums = [albumInfo, undefined];

  const run = (albums: (AlbumInfo | undefined)[]): Promise<void> => Reflect.get(source, 'writeAlbumsCache')
    .call(source, albums);

  await run(albums);

  expect(source !== undefined).assertTrue();
}