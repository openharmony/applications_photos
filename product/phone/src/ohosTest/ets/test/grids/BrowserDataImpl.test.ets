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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { BrowserDataImpl } from '@ohos/common/src/main/ets/default/model/browser/BrowserDataImpl';
import type { QueryParam, QueryAlbumParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import type { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { FetchType } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { common } from '@kit.AbilityKit';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import { Size } from '@kit.ArkUI';
import { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';

/**
 * BrowserDataImpl Unittest
 *
 * @since 2025-05-30
 */
export default function BrowserDataImplTest() {
  describe('BrowserDataImplTest', () => {
    it('BrowserDataImplTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest001();
    });

    it('BrowserDataImplTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest002();
    });

    it('BrowserDataImplTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest003();
    });

    it('BrowserDataImplTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest004();
    });

    it('BrowserDataImplTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest005();
    });

    it('BrowserDataImplTest_006', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest006();
    });

    it('BrowserDataImplTest_007', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest007();
    });

    it('BrowserDataImplTest_008', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest008();
    });

    it('BrowserDataImplTest_009', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest009();
    });

    it('BrowserDataImplTest_010', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest010();
    });

    it('BrowserDataImplTest_011', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest011();
    });

    it('BrowserDataImplTest_012', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest012();
    });

    it('BrowserDataImplTest_013', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest013();
    });

    it('BrowserDataImplTest_014', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest014();
    });

    it('BrowserDataImplTest_015', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest015();
    });

    it('BrowserDataImplTest_016', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest016();
    });

    it('BrowserDataImplTest_017', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest017();
    });

    it('BrowserDataImplTest_018', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest018();
    });

    it('BrowserDataImplTest_019', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest019();
    });

    it('BrowserDataImplTest_020', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest020();
    });

    it('BrowserDataImplTest_021', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest021();
    });

    it('BrowserDataImplTest_022', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest022();
    });

    it('BrowserDataImplTest_023', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest023();
    });

    it('BrowserDataImplTest_024', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest024();
    });

    it('BrowserDataImplTest_025', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await BrowserDataImplTest025();
    });
  });
}

class BrowserDataImplClassTest extends BrowserDataImpl {
  public getData(callback?: AsyncCallback<MediaItem[]>, param?: QueryParam | undefined): void { };

  public getDataCount(callback: AsyncCallback, param: QueryParam): void { };

  public async getDataByName(name: string, albumUri: string): Promise<void> { };

  public async getDataByUri(uri: string): Promise<void> { };

  public getDataIndexByUri(callback: AsyncCallback, param: QueryAlbumParam, uri: string): void { };

  public getMediaItemByUri(callback: AsyncCallback, uri: string): void { };

  public onCreate(context: common.Context | undefined): void {
    this.userFileManagerAccess = UserFileManagerAccess.getInstance();
    this.userFileManagerAccess.onCreate(context);
  }

  private userFileManagerAccess: UserFileManagerAccess | undefined = new UserFileManagerAccess();

  constructor() {
    super();
  }
}

/**
 * getFetchOpt
 * 分支 ！query.albumUri && fetchType not in [FetchType.EMPTY, FetchType.DATE_INFO]
 */
async function BrowserDataImplTest001() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.NORMAL,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 ！query.albumUri && fetchType === FetchType.EMPTY
 */
async function BrowserDataImplTest002() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.EMPTY,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 ！query.albumUri && fetchType === FetchType.DATE_INFO
 */
async function BrowserDataImplTest003() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 query.albumUri && !UserFileManagerAccess.isRecycleBin && orderby !== UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()
 * && fetchType === FetchType.DATE_INFO
 * */
async function BrowserDataImplTest004() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 query.albumUri && !UserFileManagerAccess.isRecycleBin && orderby !== UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS.toString()
 * && fetchType === FetchType.EMPTY
 * */
async function BrowserDataImplTest005() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.EMPTY,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 query.albumUri && !UserFileManagerAccess.isRecycleBin && orderby !== UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS
 * && fetchType not in [FetchType.EMPTY, FetchType.DATE_INFO]
 * */
async function BrowserDataImplTest006() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.NORMAL,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'start',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 query.albumUri && !UserFileManagerAccess.isRecycleBin && fetchType not in [FetchType.EMPTY, FetchType.DATE_INFO]
 * && orderby === UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS
 * */
async function BrowserDataImplTest007() {
  let browserDataImplClassTest = new BrowserDataImplClassTest()
  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.NORMAL,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'date_taken_ms',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getFetchOpt
 * 分支 query.albumUri && && fetchType not in [FetchType.EMPTY, FetchType.DATE_INFO]
 */
async function BrowserDataImplTest008() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();

  let mocker: MockKit = new MockKit();
  let isRecycleBin: Function = mocker.mockFunc(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
  when(isRecycleBin)(ArgumentMatchers.any).afterReturn(true);

  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.NORMAL,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'date_taken_ms',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
  mocker.ignoreMock(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
}

/**
 * getFetchOpt
 * 分支 query.albumUri && && fetchType === FetchType.EMPTY
 */
async function BrowserDataImplTest009() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();

  let mocker: MockKit = new MockKit();
  let isRecycleBin: Function = mocker.mockFunc(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
  when(isRecycleBin)(ArgumentMatchers.any).afterReturn(true);

  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.EMPTY,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'date_taken_ms',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
  mocker.ignoreMock(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
}

/**
 * getFetchOpt
 * 分支 query.albumUri && && fetchType === FetchType.DATE_INFO
 */
async function BrowserDataImplTest010() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();

  let mocker: MockKit = new MockKit();
  let isRecycleBin: Function = mocker.mockFunc(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
  when(isRecycleBin)(ArgumentMatchers.any).afterReturn(true);

  let queryParam: QueryParam = {
    start: 1,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 3,
    id: '12121',
    fileIds: [1],
    orderBy: 'date_taken_ms',
    albumUri: 'cc/dd'
  };
  let res = browserDataImplClassTest.getFetchOpt(queryParam);
  expect(!!res).assertTrue();
  mocker.ignoreMock(UserFileManagerAccess, UserFileManagerAccess.isRecycleBin);
}

/**
 * getItems
 * 分支 !query?.albumUri
 */
async function BrowserDataImplTest011() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let queryParam: QueryParam = {
    fetchType: FetchType.NORMAL,
    orderBy: 'date_taken_ms'
  };
  let res = browserDataImplClassTest.getItems(queryParam);
  expect(!!res).assertTrue();
}

/**
 * getItems
 * 分支 query?.albumUri && !album
 */
async function BrowserDataImplTest012() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturnNothing();

  let queryParam: QueryParam = {
    fetchType: FetchType.NORMAL,
    orderBy: 'date_taken_ms',
    albumUri: 'file://media/PhotoAlbum/7'
  };
  let res = browserDataImplClassTest.getItems(queryParam);
  expect(!!res).assertTrue();
  mocker.ignoreMock(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().getAlbumByUri);
}

/**
 * getItems
 * 分支 query?.albumUri && album
 */
async function BrowserDataImplTest013() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let queryParam: QueryParam = {
    fetchType: FetchType.NORMAL,
    orderBy: 'date_taken_ms',
    albumUri: 'file://media/PhotoAlbum/7'
  };

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn(true);

  let res = browserDataImplClassTest.getItems(queryParam);
  expect(!!res).assertTrue();
  mocker.ignoreMock(UserFileManagerAccess.getInstance(), UserFileManagerAccess.getInstance().getAlbumByUri);
}

/**
 * getItemsCount
 * 分支 userId < 0 && !album
 */
async function BrowserDataImplTest014() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let storage = new LocalStorage();

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturnNothing();

  let getCount: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getCount);
  when(getCount)(ArgumentMatchers.any).afterReturn(10);

  let res = await browserDataImplClassTest.getItemsCount('', undefined, false, storage);
  expect(res).assertEqual(undefined);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getCount);
}

/**
 * getItemsCount
 * 分支 userId > 0 && !album
 */
async function BrowserDataImplTest015() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let storage = new LocalStorage();
  let selectParams = new SelectParams();
  selectParams.userId = 1;
  storage.setOrCreate<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY, selectParams);

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturnNothing();

  let getCount: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getCount);
  when(getCount)(ArgumentMatchers.any).afterReturn(10);

  let res = await browserDataImplClassTest.getItemsCount('', undefined, false, storage);
  expect(res).assertEqual(undefined);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getCount);
}

/**
 * getItemsCount
 * 分支 userId > 0 && album && !filterMediaType
 */
async function BrowserDataImplTest016() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let storage = new LocalStorage();
  let selectParams = new SelectParams();
  selectParams.userId = 1;
  storage.setOrCreate<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY, selectParams);

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn({ count: 1 });

  let res = await browserDataImplClassTest.getItemsCount('', undefined, true, storage);
  expect(res).assertEqual(1);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
}

/**
 * getItemsCount
 * 分支 userId > 0 && album && filterMediaType
 */
async function BrowserDataImplTest017() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let storage = new LocalStorage();
  let selectParams = new SelectParams();
  selectParams.userId = 1;
  storage.setOrCreate<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY, selectParams);

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn({ count: 1 });

  const filterMediaType = 'FILTER_MEDIA_TYPE_IMAGE';
  const albumUri = 'file://media/PhotoAlbum/7';
  let res = await browserDataImplClassTest.getItemsCount(albumUri, filterMediaType, true, storage);
  expect(res).assertEqual(0);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
}

/**
 * getItemsCount
 * 分支 userId < 0 && album && filterMediaType
 */
async function BrowserDataImplTest018() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  let storage = new LocalStorage();

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn({ count: 1 });

  const filterMediaType = 'FILTER_MEDIA_TYPE_IMAGE';
  const albumUri = 'file://media/PhotoAlbum/7';
  let res = await browserDataImplClassTest.getItemsCount(albumUri, filterMediaType, true, storage);
  expect(res).assertEqual(0);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(storage),
    UserFileManagerAccess.getInstance(storage).getAlbumByUri);
}

/**
 * getThumbnailSafe
 * 分支 size && (size.width === 0 || size.height === 0) && size.width !== BrowserDataImpl.THUMBNAIL_WIDTH
 * && ImageUtil.isExitTransparentChannelImg === false
 */
async function BrowserDataImplTest019() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7';
  const path = '';
  const modifiedDate = new Date().getTime();
  const size: Size = { width: 0, height: 0 };

  let mocker: MockKit = new MockKit();
  let isExitTransparentChannelImg: Function = mocker.mockFunc(ImageUtil, ImageUtil.isExitTransparentChannelImg);
  when(isExitTransparentChannelImg)(ArgumentMatchers.any).afterReturn(false);

  let res = await browserDataImplClassTest.getThumbnailSafe(sourceUri, path, modifiedDate, size);
  let str = `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=${size.width}&height=${size.height}&path=${path}`;
  expect(res).assertEqual(str);

  mocker.ignoreMock(ImageUtil, ImageUtil.isExitTransparentChannelImg);
}

/**
 * getThumbnailSafe
 * 分支 size && !(size.width === 0 || size.height === 0) && ImageUtil.isExitTransparentChannelImg === true
 */
async function BrowserDataImplTest020() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7';
  const path = '';
  const modifiedDate = new Date().getTime();
  const size: Size = { width: BrowserDataImpl.THUMBNAIL_WIDTH, height: BrowserDataImpl.THUMBNAIL_WIDTH };

  let mocker: MockKit = new MockKit();
  let isExitTransparentChannelImg: Function = mocker.mockFunc(ImageUtil, ImageUtil.isExitTransparentChannelImg);
  when(isExitTransparentChannelImg)(ArgumentMatchers.any).afterReturn(true);

  let res = await browserDataImplClassTest.getThumbnailSafe(sourceUri, path, modifiedDate, size);
  let str = `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=${size.width}&height=${size.height}&path=${path}`;
  expect(res).assertEqual(str);

  mocker.ignoreMock(ImageUtil, ImageUtil.isExitTransparentChannelImg);
}

/**
 * getThumbnailSafe
 * 分支 !size && ImageUtil.isExitTransparentChannelImg === true
 */
async function BrowserDataImplTest021() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7';
  const path = '';
  const modifiedDate = new Date().getTime();
  const size: Size = { width: BrowserDataImpl.THUMBNAIL_WIDTH, height: BrowserDataImpl.THUMBNAIL_WIDTH };

  let mocker: MockKit = new MockKit();
  let isExitTransparentChannelImg: Function = mocker.mockFunc(ImageUtil, ImageUtil.isExitTransparentChannelImg);
  when(isExitTransparentChannelImg)(ArgumentMatchers.any).afterReturn(true);

  let res = browserDataImplClassTest.getThumbnailSafe(sourceUri, path, modifiedDate);
  let str = `${sourceUri}?timestampApp=${modifiedDate}&oper=astc&width=${size.width}&height=${size.height}&path=${path}`;
  expect(res).assertEqual(str);

  mocker.ignoreMock(ImageUtil, ImageUtil.isExitTransparentChannelImg);
}

/**
 * getThumbnailSafe
 * 分支 !size && ImageUtil.isExitTransparentChannelImg === false
 */
async function BrowserDataImplTest022() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7';
  const path = '';
  const modifiedDate = new Date().getTime();
  let mocker: MockKit = new MockKit();
  let isExitTransparentChannelImg: Function = mocker.mockFunc(ImageUtil, ImageUtil.isExitTransparentChannelImg);
  when(isExitTransparentChannelImg)(ArgumentMatchers.any).afterReturn(false);

  // 该分支无法精确断言，根据相册中是否存在透明通道的图片格式而返回不同结果, 仅断言开头是否一致
  let res = browserDataImplClassTest.getThumbnailSafe(sourceUri, path, modifiedDate);
  let str = `${sourceUri}?timestampApp=${modifiedDate}&oper=`;
  expect(res.startsWith(str)).assertTrue();

  mocker.ignoreMock(ImageUtil, ImageUtil.isExitTransparentChannelImg);
}

/**
 * getSinglePhotoAsset
 * 分支 albumUri && !album
 */
async function BrowserDataImplTest023() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7/test';
  const albumUri = 'file://media/PhotoAlbum/7';

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn(false);

  let getPhotoAssetByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getPhotoAssetByUri);
  when(getPhotoAssetByUri)(ArgumentMatchers.any).afterReturnNothing();

  let res = await browserDataImplClassTest.getSinglePhotoAsset(sourceUri, albumUri);
  expect(res).assertEqual(undefined);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getAlbumByUri);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getPhotoAssetByUri);
}

/**
 * getSinglePhotoAsset
 * 分支 albumUri && album
 */
async function BrowserDataImplTest024() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7/test';
  const albumUri = 'file://media/PhotoAlbum/7';

  let mocker: MockKit = new MockKit();
  let getAlbumByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getAlbumByUri);
  when(getAlbumByUri)(ArgumentMatchers.any).afterReturn(true);

  let getObject: Function = mocker.mockFunc(PhotoAccessHelperAccess.getInstance(),
    PhotoAccessHelperAccess.getInstance().getObject);
  when(getObject)(ArgumentMatchers.any).afterReturnNothing();

  let res = await browserDataImplClassTest.getSinglePhotoAsset(sourceUri, albumUri);
  expect(res).assertEqual(undefined);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getAlbumByUri);

  mocker.ignoreMock(PhotoAccessHelperAccess.getInstance(),
    PhotoAccessHelperAccess.getInstance().getObject);
}

/**
 * getSinglePhotoAsset
 * 分支 !albumUri
 */
async function BrowserDataImplTest025() {
  let browserDataImplClassTest = new BrowserDataImplClassTest();
  const sourceUri = 'file://media/PhotoAlbum/7/test';
  const albumUri = '';

  let mocker: MockKit = new MockKit();
  let getPhotoAssetByUri: Function = mocker.mockFunc(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getPhotoAssetByUri);
  when(getPhotoAssetByUri)(ArgumentMatchers.any).afterReturnNothing();

  let res = await browserDataImplClassTest.getSinglePhotoAsset(sourceUri, albumUri);
  expect(res).assertEqual(undefined);

  mocker.ignoreMock(UserFileManagerAccess.getInstance(),
    UserFileManagerAccess.getInstance().getPhotoAssetByUri);
}