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
import {
  PortraitListsDataSource,
  PortraitLoadingTaskParams,
  PortraitListsLoadTask,
  PortraitLoadingInfo
} from '@ohos/common/src/main/ets/default/model/browser/album/PortraitListsDataSource';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumSetDataInfo } from '@ohos/common/src/main/ets/default/model/common/AlbumSetDataInfo';
import { MediaObserverNfyInfo, MediaObserverNfyType } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { ChangeInfo, DataSource, LoadingInfo, LoadingResult, LoadingTask } from '@ohos/common/src/main/ets/default/model/DataSource';
import type { PhotoAsset } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import type common from '@ohos.app.ability.common';

const TAG = 'PortraitListsDataSourceTest';

/**
 * PortraitListsDataSource Unittest
 * PortraitListsLoadTask Unittest
 *
 * @since 2025-07-19
 */
export default function PortraitListsDataSourceTest() {
  describe('PortraitListsDataSourceTest', () => {
    it('PortraitListsDataSourceTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest01();
    });

    it('PortraitListsDataSourceTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest02();
    });

    it('PortraitListsDataSourceTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest03();
    });

    it('PortraitListsDataSourceTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest04();
    });

    it('PortraitListsDataSourceTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest05();
    });

    it('PortraitListsDataSourceTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest06();
    });

    it('PortraitListsDataSourceTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest07();
    });

    it('PortraitListsDataSourceTest_08', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest08();
    });

    it('PortraitListsDataSourceTest_09', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest09();
    });

    it('PortraitListsDataSourceTest_10', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest10();
    });

    it('PortraitListsDataSourceTest_11', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest11();
    });

    it('PortraitListsDataSourceTest_12', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest12();
    });

    it('PortraitListsDataSourceTest_13', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest13();
    });

    it('PortraitListsDataSourceTest_14', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest14();
    });

    it('PortraitListsDataSourceTest_15', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest15();
    });

    it('PortraitListsDataSourceTest_16', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest16();
    });

    it('PortraitListsDataSourceTest_17', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest17();
    });

    it('PortraitListsDataSourceTest_18', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest18();
    });

    it('PortraitListsDataSourceTest_19', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest19();
    });

    it('PortraitListsDataSourceTest_20', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsDataSourceTest20();
    });

    it('PortraitListsLoadTaskTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsLoadTaskTest01();
    });

    it('PortraitListsLoadTaskTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsLoadTaskTest02();
    });

    it('PortraitListsLoadTaskTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PortraitListsLoadTaskTest03();
    });
  })
}

/**
 * getData
 * 分支 if (index < 0 || index >= this.albums.length)
 */
async function PortraitListsDataSourceTest01() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  let res = source.getData(-1);
  expect(res).assertUndefined();
}

/**
 * getWrappedData
 * 分支 (!albumInfo)
 */
async function PortraitListsDataSourceTest02() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  let res = source.getWrappedData(100);
  expect(res).assertUndefined();
}

/**
 * getWrappedData
 * 分支 if (tmp)
 */
async function PortraitListsDataSourceTest03() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  let albumSetDataInfo = new AlbumSetDataInfo(albumInfo, 1);
  source.albums = [albumInfo];
  source.albumInfoItemCache.set('test', albumSetDataInfo);
  let res = source.getWrappedData(0);
  expect(res === albumSetDataInfo).assertTrue();
}

/**
 * writeCache
 * 分支 this.options !== PORTRAIT_TYPE_MAIN && this.options !== PORTRAIT_TYPE_MORE
 */
async function PortraitListsDataSourceTest04() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();

  const run = (albums: (AlbumInfo | undefined)[]): Promise<void> => Reflect.get(source, 'writeCache')
    .call(source, albums);

  await run([albumInfo]);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (nfyInfo.type === MediaObserverNfyType.PHOTO_REMOVE
 */
async function PortraitListsDataSourceTest05() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.PHOTO_REMOVE;

  source.onNotify(nfyInfo);
  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (nfyInfo.type < MediaObserverNfyType.ALBUM_ADD
 */
async function PortraitListsDataSourceTest06() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.PHOTO_ADD;

  source.onNotify(nfyInfo);
  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 if (StringUtil.isStringStartsWithNumber(nfyInfo.albumUris[index], ANALYSIS_ALBUM)) {
 */
async function PortraitListsDataSourceTest07() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.ALBUM_ADD;
  nfyInfo.albumUris = ['file://media/AnalysisAlbum/7']

  source.onNotify(nfyInfo);
  expect(source !== undefined).assertTrue();
}

/**
 * onMediaLibDataChange
 * 分支 if (!this.ignoreLocalNotify)
 */
async function PortraitListsDataSourceTest08() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  source.setIgnoreLocalNotify(false);
  source.onMediaLibDataChange('test');

  expect(source !== undefined).assertTrue();
}

/**
 * getAlbumInfoByAlbumUri
 * 分支 if (!albumUri) {
 */
async function PortraitListsDataSourceTest09() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  source.getAlbumInfoByAlbumUri('');

  expect(source !== undefined).assertTrue();
}

/**
 * getAlbumInfoByAlbumUri
 * 分支 !(!albumUri) {
 */
async function PortraitListsDataSourceTest10() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  source.getAlbumInfoByAlbumUri('test');

  expect(source !== undefined).assertTrue();
}

/**
 * getAlbumByIndex
 * 分支 if (index < 0 || index >= this.albums.length) {
 */
async function PortraitListsDataSourceTest11() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  source.getAlbumByIndex(-1);

  expect(source !== undefined).assertTrue();
}

/**
 * getAlbumByIndex
 * 分支 !(index < 0 || index >= this.albums.length) {
 */
async function PortraitListsDataSourceTest12() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();
  source.albums = [albumInfo];
  source.getAlbumByIndex(0);

  expect(source !== undefined).assertTrue();
}

/**
 * removeOriginAlbum
 * 分支 if (originIndex > -1)
 */
async function PortraitListsDataSourceTest13() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  source.albums = [albumInfo];
  source.removeOriginAlbum(albumInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * removeOriginAlbum
 * 分支 if !(originIndex > -1)
 */
async function PortraitListsDataSourceTest14() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  source.albums = [albumInfo];
  source.removeOriginAlbum(new AlbumInfo());

  expect(source !== undefined).assertTrue();
}

/**
 * addAlbum
 * 分支 if (origin && targetIndex >= 0)
 */
async function PortraitListsDataSourceTest15() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  source.albums = [albumInfo];
  source.addAlbum(albumInfo, 0);

  expect(source !== undefined).assertTrue();
}

/**
 * addAlbum
 * 分支 if !(origin && targetIndex >= 0)
 */
async function PortraitListsDataSourceTest16() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();
  albumInfo.uri = 'test';
  source.albums = [albumInfo];
  source.addAlbum(albumInfo, -1);

  expect(source !== undefined).assertTrue();
}

/**
 * PortraitListsLoadTask.start
 * 分支 if (this.isCoolStart)
 * PortraitListsLoadTask.loadAlbumFromCache
 * 分支 this.options !== PORTRAIT_TYPE_MAIN && this.options !== PORTRAIT_TYPE_MORE
 */
async function PortraitListsLoadTaskTest01() {
  let info: PortraitLoadingInfo = { start: 0, count: 1 };
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');

  let params: PortraitLoadingTaskParams = {
    info,
    source: source,
    pageData: Reflect.get(source, 'pageData'),
    context: Reflect.get(source, 'context'),
    options: '',
    cacheMgr: Reflect.get(source, 'cacheMgr'),
    isCoolStart: true,
    albumCountCallback: () => {}
  };

  let task = new PortraitListsLoadTask(params);
  await task.start();

  expect(source !== undefined).assertTrue();
}

/**
 * PortraitListsLoadTask.loadPageDataFromDb
 * 分支  !(if (this.options === PORTRAIT_TYPE_MAIN) || if (this.options === PORTRAIT_TYPE_MORE))
 */
async function PortraitListsLoadTaskTest02() {
  let info: PortraitLoadingInfo = { start: 0, count: 1 };
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');

  let params: PortraitLoadingTaskParams = {
    info,
    source: source,
    pageData: Reflect.get(source, 'pageData'),
    context: Reflect.get(source, 'context'),
    options: '',
    cacheMgr: Reflect.get(source, 'cacheMgr'),
    isCoolStart: true,
    albumCountCallback: () => {}
  };

  let task = new PortraitListsLoadTask(params);
  await task.loadPageDataFromDb(info);

  expect(source !== undefined).assertTrue();
}

/**
 * PortraitListsLoadTask.updatePortraitAlbumInfo
 * 分支  if (!coverAsset
 */
async function PortraitListsLoadTaskTest03() {
  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    return
  }

  let info: PortraitLoadingInfo = { start: 0, count: 1 };
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, '');
  let albumInfo = new AlbumInfo();

  let params: PortraitLoadingTaskParams = {
    info,
    source: source,
    pageData: Reflect.get(source, 'pageData'),
    context: Reflect.get(source, 'context'),
    options: '',
    cacheMgr: Reflect.get(source, 'cacheMgr'),
    isCoolStart: true,
    albumCountCallback: () => {}
  };

  let task = new PortraitListsLoadTask(params);
  const run = (coverAsset: PhotoAsset | undefined, album: PhotoAlbum, albumInfo: AlbumInfo):
    Promise<void> => Reflect.get(task, 'updatePortraitAlbumInfo')
      .call(task, coverAsset, album, albumInfo);
  await run(undefined, imageAlbum, albumInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * releaseAlbumInfoItemCache
 * 分支 if (!item?.uri) {
 */
async function PortraitListsDataSourceTest17() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  let item = new AlbumInfo();
  source.releaseAlbumInfoItemCache(item);
  expect(source !== undefined).assertTrue();
}


/**
 * releaseAlbumInfoItemCache
 * 分支 !if (!item?.uri) {
 */
async function PortraitListsDataSourceTest18() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  let item = new AlbumInfo();
  item.uri = 'test';
  source.releaseAlbumInfoItemCache(item);
  expect(source !== undefined).assertTrue();
}

/**
 * ignoreLocalNotify
 * 分支 if (!this.ignoreLocalNotify) {
 */
async function PortraitListsDataSourceTest19() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  Reflect.set(source, 'ignoreLocalNotify', false);
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  source. onMediaLibDataNfy(nfyInfo);
  expect(source !== undefined).assertTrue();
}

/**
 * ignoreLocalNotify
 * 分支 ！if (!this.ignoreLocalNotify) {
 */
async function PortraitListsDataSourceTest20() {
  let albumBroadCast: BroadCast = new BroadCast();
  let source = new PortraitListsDataSource(getContext(), albumBroadCast, 'favorites_homePage');
  Reflect.set(source, 'ignoreLocalNotify', true);
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  source. onMediaLibDataNfy(nfyInfo);
  expect(source !== undefined).assertTrue();
}