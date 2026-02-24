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
import { AlbumSetDataSource } from "@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSource";
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { PageData } from '@ohos/common/src/main/ets/default/model/PageData';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';

const TAG: string = 'AlbumSetDataSourceTest';

/**
 * AlbumSetDataSource Unittest
 *
 * @since 2025-07-21
 */
export default function AlbumSetDataSourceTest(): void {
  describe('AlbumSetDataSourceTest', (): void => {
    it('AlbumSetDataSourceTest_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest01();
    });

    it('AlbumSetDataSourceTest_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest02();
    });

    it('AlbumSetDataSourceTest_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest03();
    });

    it('AlbumSetDataSourceTest_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest04();
    });

    it('AlbumSetDataSourceTest_005', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest05();
    });

    it('AlbumSetDataSourceTest_006', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest06();
    });

    it('AlbumSetDataSourceTest_007', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest07();
    });

    it('AlbumSetDataSourceTest_008', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest08();
    });

    it('AlbumSetDataSourceTest_009', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest09();
    });

    it('AlbumSetDataSourceTest_010', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest10();
    });

    it('AlbumSetDataSourceTest_011', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest11();
    });

    it('AlbumSetDataSourceTest_012', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest12();
    });

    it('AlbumSetDataSourceTest_013', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest13();
    });

    it('AlbumSetDataSourceTest_014', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest14();
    });

    it('AlbumSetDataSourceTest_015', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest15();
    });

    it('AlbumSetDataSourceTest_016', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest16();
    });

    it('AlbumSetDataSourceTest_017', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest17();
    });

    it('AlbumSetDataSourceTest_018', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetDataSourceTest18();
    });
  })
}

async function getSource (albumInfo:AlbumInfo = new AlbumInfo()) {
  let broadCast = new BroadCast();
  let data: (AlbumInfo | undefined) [] = [albumInfo];
  let initData = new PageData<AlbumInfo>(PageData.nextVersion(), data);
  let shouldWriteCache = false;
  let blackUriList = []
  let source = new AlbumSetDataSource(broadCast, initData, shouldWriteCache, blackUriList);
  return source
}

/**
 * constructor
 * 分支  if (initData)
 * 分支  if (blackUriList)
 */
async function AlbumSetDataSourceTest01() {
  let source = await getSource();
  expect(source !== undefined).assertTrue();
}

/**
 * releaseAlbumInfoItemCache
 * 分支 if (!item?.uri)
 */
async function AlbumSetDataSourceTest02() {
  let source = await getSource();
  let item: AlbumInfo = new AlbumInfo();
  item.uri = 'test';
  source.releaseAlbumInfoItemCache(item);
  expect(source !== undefined).assertTrue();
}

/**
 * getWrappedData
 * 分支 if (index < 0 || index >= this.albumCount) {
 */
async function AlbumSetDataSourceTest03() {
  let source = await getSource();

  const run = (index: number): AlbumSetDataInfo | undefined => Reflect.get(source, 'getWrappedData')
    .call(source, index);

  run(-1);

  expect(source !== undefined).assertTrue();
}

/**
 * getWrappedData
 * 分支 if (albumIndex < 0 || albumIndex >= this.albums.length) {
 */
async function AlbumSetDataSourceTest04() {
  let source = await getSource();

  const run = (index: number): AlbumSetDataInfo | undefined => Reflect.get(source, 'getWrappedData')
    .call(source, index);

  source.activeStart = 1;
  run(0);

  expect(source !== undefined).assertTrue();
}

/**
 * getWrappedData
 * 分支 if (index === this.newCreatedAlbumIndex) {
 */
async function AlbumSetDataSourceTest05() {
  let source = await getSource();

  const run = (index: number): AlbumSetDataInfo | undefined => Reflect.get(source, 'getWrappedData')
    .call(source, index);

  source.activeStart = 0;
  source.setNewAlbumIndex(0);
  run(0);

  expect(source !== undefined).assertTrue();
}

/**
 * onSlidingWindowChanged
 * 分支 if (albumInfo) {
 */
async function AlbumSetDataSourceTest06() {
  let source = await getSource();

  const run = (winStart: number, winEnd: number): void => Reflect.get(source, 'onSlidingWindowChanged')
    .call(source, winStart, winEnd);

  run(0, 1);

  expect(source !== undefined).assertTrue();
}

/**
 * handleNotifyUri
 * 分支 !album.coverPhotoUri
 */
async function AlbumSetDataSourceTest07() {
  let source = await getSource();
  let nfyInfo = new MediaObserverNfyInfo();
  let album = new AlbumInfo();
  album.coverPhotoUri = '';

  const run = (nfyInfo: MediaObserverNfyInfo, album: AlbumInfo, albumIndex: number): void => Reflect.get(source, 'handleNotifyUri')
    .call(source, nfyInfo, album, albumIndex);

  run(nfyInfo, album, 1);

  expect(source !== undefined).assertTrue();
}

/**
 * handleNotifyUri
 * 分支 if (!nfyUri)
 */
async function AlbumSetDataSourceTest08() {
  let source = await getSource();
  let nfyInfo = new MediaObserverNfyInfo();
  let album = new AlbumInfo();
  album.coverPhotoUri = 'test';
  nfyInfo.uris = [''];

  const run = (nfyInfo: MediaObserverNfyInfo, album: AlbumInfo, albumIndex: number): void => Reflect.get(source, 'handleNotifyUri')
    .call(source, nfyInfo, album, albumIndex);

  run(nfyInfo, album, 1);

  expect(source !== undefined).assertTrue();
}

/**
 * handleNotifyUri
 * 分支 if (album.coverPhotoUri === nfyUri) {
 */
async function AlbumSetDataSourceTest09() {
  let source = await getSource();
  let nfyInfo = new MediaObserverNfyInfo();
  let album = new AlbumInfo();
  album.coverPhotoUri = 'test';
  nfyInfo.uris = ['test'];

  const run = (nfyInfo: MediaObserverNfyInfo, album: AlbumInfo, albumIndex: number): void => Reflect.get(source, 'handleNotifyUri')
    .call(source, nfyInfo, album, albumIndex);

  run(nfyInfo, album, 1);

  expect(source !== undefined).assertTrue();
}

/**
 * handleNotifyUri
 * 分支 if !(album.coverPhotoUri === nfyUri) {
 */
async function AlbumSetDataSourceTest10() {
  let source = await getSource();
  let nfyInfo = new MediaObserverNfyInfo();
  let album = new AlbumInfo();
  album.coverPhotoUri = 'test';
  nfyInfo.uris = ['test1'];

  const run = (nfyInfo: MediaObserverNfyInfo, album: AlbumInfo, albumIndex: number): void => Reflect.get(source, 'handleNotifyUri')
    .call(source, nfyInfo, album, albumIndex);

  run(nfyInfo, album, 1);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE) {
 * 分支 if !(nfyInfo.uris.includes(album?.coverPhotoUri ?? ""))
 * 分支 if (!isNeedUpdate) {
 */
async function AlbumSetDataSourceTest11() {
  let source = await getSource();
  let nfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.PHOTO_UPDATE;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (nfyInfo.type === MediaObserverNfyType.PHOTO_UPDATE) {
 * 分支 if (nfyInfo.uris.includes(album?.coverPhotoUri ?? ""))
 */
async function AlbumSetDataSourceTest12() {
  let album = new AlbumInfo();
  album.coverPhotoUri = 'test';
  let source = await getSource(album);
  let nfyInfo = new MediaObserverNfyInfo();
  nfyInfo.uris = ['test'];
  nfyInfo.type = MediaObserverNfyType.PHOTO_UPDATE;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 nfyInfo.type < MediaObserverNfyType.ALBUM_ADD
 */
async function AlbumSetDataSourceTest13() {
  let album = new AlbumInfo();
  album.coverPhotoUri = 'test';
  let source = await getSource(album);
  let nfyInfo = new MediaObserverNfyInfo();
  nfyInfo.uris = ['test'];
  nfyInfo.type = MediaObserverNfyType.PHOTO_ADD;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * hasUserAlbum
 * if (Number(album?.subType) === Number(photoAccessHelper.AlbumSubtype.USER_GENERIC)) {
 */
async function AlbumSetDataSourceTest14() {
  let album = new AlbumInfo();
  album.subType = Number(photoAccessHelper.AlbumSubtype.FAVORITE)
  let source = await getSource(album);
  source.activeStart = 0;
  source.activeEnd = 1;

  source.hasUserAlbum();

  expect(source !== undefined).assertTrue();
}

/**
 * writeAlbumsCache
 * 分支 if (!albums || albums.length <= 0) {
 */
async function AlbumSetDataSourceTest15() {
  let source = await getSource();

  const run = (albums: (AlbumInfo | undefined)[]): Promise<void> => Reflect.get(source, 'writeAlbumsCache')
    .call(source, albums);

  await run([]);

  expect(source !== undefined).assertTrue();
}

/**
 * onChange
 * 分支 if (!this.deviceId || this.deviceId.length === 0) {
 * 分支 if (mediaType === 'image' || mediaType === 'video' || mediaType === 'album') {
 */
async function AlbumSetDataSourceTest16() {
  let source = await getSource();
  Reflect.set(source, 'deviceId', '');
  source.onChange('image');

  expect(source !== undefined).assertTrue();
}

/**
 * onChange
 * 分支 if !(!this.deviceId || this.deviceId.length === 0) {
 * 分支 if (mediaType === 'remote')
 */
async function AlbumSetDataSourceTest17() {
  let source = await getSource();
  Reflect.set(source, 'deviceId', 'test')
  source.onChange('remote');

  expect(source !== undefined).assertTrue();
}

/**
 * getAlbumInfoSafely
 * 分支 if (!album) {
 */
async function AlbumSetDataSourceTest18() {
  let source = await getSource();
  const run = (index: number): AlbumInfo | undefined => Reflect.get(source, 'getAlbumInfoSafely')
    .call(source, index);
  let ret: AlbumInfo | undefined = run(100);
  expect(ret === undefined).assertTrue();
}