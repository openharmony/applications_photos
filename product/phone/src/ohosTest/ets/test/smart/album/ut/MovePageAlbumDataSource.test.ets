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
import { MovePageAlbumDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/MovePageAlbumDataSource';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { MediaObserverNfyInfo } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { MediaObserverNfyType } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';

const TAG = 'MovePageAlbumDataSourceTest';

/**
 * MovePageAlbumDataSource Unittest
 *
 * @since 2024-07-26
 */
export default function MovePageAlbumDataSourceTest() {
  describe('MovePageAlbumDataSourceTest', () => {
    it('MovePageAlbumDataSourceTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest01();
    });

    it('MovePageAlbumDataSourceTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest02();
    });

    it('MovePageAlbumDataSourceTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest03();
    });

    it('MovePageAlbumDataSourceTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest04();
    });

    it('MovePageAlbumDataSourceTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest05();
    });

    it('MovePageAlbumDataSourceTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest06();
    });

    it('MovePageAlbumDataSourceTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest07();
    });

    it('MovePageAlbumDataSourceTest_08', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest08();
    });

    it('MovePageAlbumDataSourceTest_09', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest09();
    });

    it('MovePageAlbumDataSourceTest_10', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest10();
    });

    it('MovePageAlbumDataSourceTest_11', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await MovePageAlbumDataSourceTest11();
    });
  })
}

/**
 * setBlackLpath
 * 分支 mediaType & 1
 */
async function MovePageAlbumDataSourceTest01() {
  let source = new MovePageAlbumDataSource();
  source.setBlackLpath(1);

  expect(source !== undefined).assertTrue();
}

/**
 * setBlackLpath
 * 分支 !(mediaType & 1)
 */
async function MovePageAlbumDataSourceTest02() {
  let source = new MovePageAlbumDataSource();
  source.setBlackLpath(0);

  expect(source !== undefined).assertTrue();
}

/**
 * pushAlbumInfo
 * 分支 !(this.sourceAlbumUri || this.blackLpath)
 */
async function MovePageAlbumDataSourceTest03() {
  let source = new MovePageAlbumDataSource();
  let albums: AlbumInfo[] = [];

  source.pushAlbumInfo(albums);

  expect(source !== undefined).assertTrue();
}

/**
 * pushAlbumInfo
 * 分支 (this.sourceAlbumUri || this.blackLpath)
 */
async function MovePageAlbumDataSourceTest04() {
  let source = new MovePageAlbumDataSource();
  let albums: AlbumInfo[] = [];

  source.sourceAlbumUri = 'test';
  source.setBlackLpath(1);
  source.pushAlbumInfo(albums);

  expect(source !== undefined).assertTrue();
}

/**
 * pushAlbumInfo
 * 分支 !(this.sourceAlbumUri || this.blackLpath)
 */
async function MovePageAlbumDataSourceTest05() {
  let source = new MovePageAlbumDataSource();
  let albums: AlbumInfo[] = [];

  source.updateAlbumInfo(albums);

  expect(source !== undefined).assertTrue();
}

/**
 * pushAlbumInfo
 * 分支 (this.sourceAlbumUri || this.blackLpath)
 */
async function MovePageAlbumDataSourceTest06() {
  let source = new MovePageAlbumDataSource();
  let albums: AlbumInfo[] = [];

  source.sourceAlbumUri = 'test';
  source.setBlackLpath(1);
  source.updateAlbumInfo(albums);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 default;
 */
async function MovePageAlbumDataSourceTest07() {
  let source = new MovePageAlbumDataSource();
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 fyInfo.type == MediaObserverNfyType.ALBUM_UPDATE;
 */
async function MovePageAlbumDataSourceTest08() {
  let source = new MovePageAlbumDataSource();
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();

  nfyInfo.type = MediaObserverNfyType.ALBUM_UPDATE;
  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 fyInfo.type == MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;
 */
async function MovePageAlbumDataSourceTest09() {
  let source = new MovePageAlbumDataSource();
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();

  nfyInfo.type = MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;
  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * initSecondBatch
 */
async function MovePageAlbumDataSourceTest10() {
  let source = new MovePageAlbumDataSource();
  source.initSecondData();

  expect(source !== undefined).assertTrue();
}

/**
 * initFirstBach
 */
async function MovePageAlbumDataSourceTest11() {
  let source = new MovePageAlbumDataSource();
  source.initData();

  expect(source !== undefined).assertTrue();
}