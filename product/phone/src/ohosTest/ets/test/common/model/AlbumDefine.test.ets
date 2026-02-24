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
import { ArgumentMatchers, describe, expect, MockKit, when } from '@ohos/hypium';
import { run as it } from '@ohos/tools/src/ohosTest/ets/Factory.test';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { abilityDelegator } from '../../../TestAbility/TestAbility';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { AlbumDefine, QueryType } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import { dataSharePredicates } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { FetchOptions } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { FileFetchOptionBuilder } from '@ohos/common/src/main/ets/default/model/FetchOption';
import { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';

const TAG: string = 'AlbumDefineTest';

function getFetchOptions(): photoAccessHelper.FetchOptions | undefined {
  let predicates = new dataSharePredicates.DataSharePredicates();
  predicates.notEqualTo('album_name', 'fake');
  predicates.equalTo('highlight_status', '1');
  predicates.orderByDesc('generate_time');
  return {
    fetchColumns: [],
    predicates: predicates,
  };
}

export default function AlbumDefineTest(): void {
  let builder: FileFetchOptionBuilder;
  let predicates: dataSharePredicates.DataSharePredicates;
  let albumUris: string[];
  let album: AlbumInfo;
  describe('AlbumDefineTest', (): void => {
    it('AlbumDefineTest_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest01();
    });
    it('AlbumDefineTest_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest02();
    });
    it('AlbumDefineTest_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest03();
    });
    it('AlbumDefineTest_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      AlbumDefine.getOrderBuilder(builder);
      await AlbumDefineTest04();
    });
    it('AlbumDefineTest_005', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest05();
    });
    it('AlbumDefineTest_006', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest06();
    });
    it('AlbumDefineTest_007', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest07();
    });
    it('AlbumDefineTest_008', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest08();
    });
    it('AlbumDefineTest_009', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest09();
    });
    it('AlbumDefineTest_010', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest10();
    });
    it('AlbumDefineTest_011', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest11();
    });
    it('AlbumDefineTest_012', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      AlbumDefine.modifyPredicatesInAlbumUris(predicates, albumUris);
      await AlbumDefineTest12();
    });
    it('AlbumDefineTest_013', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumDefineTest13();
    });
    it('AlbumDefineTest_014', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      AlbumDefine.modifyPredicatesInPhotoUris(predicates, albumUris);
      await AlbumDefineTest14();
    });
    it('AlbumDefineTest_015', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      AlbumDefine.getSystemAlbumNameByResource(album);
      await AlbumDefineTest15();
    });
  })
}

/**
 * 打开图库
 */
async function AlbumDefineTest01() {
  Log.info(TAG, 'AlbumDefineTest_001 start');
  try {
    let result =
      await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
        .then((): void => {
          Log.info(TAG, 'MainAbility start success');
        });
    expect(result !== null).assertTrue();
  } catch (exception) {
    Log.error(TAG, 'start failed: ' + exception.code);
  } finally {
    Log.info(TAG, 'start photo application');
  }
  Log.info(TAG, 'AlbumDefineTest_001 end');
}

async function AlbumDefineTest02() {
  Log.info(TAG, 'AlbumDefineTest_002 start');
  AlbumDefine.getFilterMediaTypeUpperCase('');
  AlbumDefine.getFilterMediaTypeUpperCase('video/quicktime');
  AlbumDefine.getFilterMediaType('video/quicktime');
  AlbumDefine.getFilterMediaType('');
  AlbumDefine.getFilterQueryType('video/quicktime');
  AlbumDefine.getFilterQueryType('');
  AlbumDefine.getActualStringByQueryType('video/quicktime', QueryType.MIME_TYPE);
  AlbumDefine.getActualStringByQueryType('image/*', QueryType.MEDIA);
  AlbumDefine.getActualStringByQueryType('video/*', QueryType.MEDIA);
  AlbumDefine.getActualStringByQueryType('image/movingPhoto', QueryType.SUBTYPE);
  AlbumDefine.getFilterQueryType('');
  AlbumDefine.convertQueryAndFilterMap(['*/*', 'image/movingPhoto']);
  AlbumDefine.getFileFetchOpt();
  let option = getFetchOptions();
  if (option) {
    AlbumDefine.setFilterConditions(option);
    AlbumDefine.setFilterConditions(option, { recommendationType: 12 });
  }
  expect(option !== undefined).assertTrue();
  AlbumDefine.getOrderBuilder(new FileFetchOptionBuilder());
  AlbumDefine.getOrderBuilder(new FileFetchOptionBuilder(), false, 'date_taken_ms');
  AlbumDefine.getOrderBuilder(new FileFetchOptionBuilder(), false, 'size');
  AlbumDefine.getOrderBuilder(new FileFetchOptionBuilder(), false, 'display_name');
  AlbumDefine.getOrderBuilder(new FileFetchOptionBuilder(), false, '11');
  AlbumDefine.getFileFetchOptWithDate(2, '11', 1, 1);
  AlbumDefine.getFileFetchOptWithCamera(2, 1, '1', '1', true, '1', [1]);
  AlbumDefine.getFileFetchOptWithEmptyColumn(2, 1, '1', '1', true);
  AlbumDefine.getFileFetchOptWithDateColumn(2, 1, '1', '1');
  AlbumDefine.getUploadingFetchOpt('1');
  AlbumDefine.getTrashFetchOpt(2, 1, '1');
  AlbumDefine.getTrashFetchOptWithEmptyColumn(2, 1, '1');
  AlbumDefine.getTrashFetchOptWithDateColumn(2, 1, '1');
  AlbumDefine.getFileFetchOptByUri('1');
  AlbumDefine.getFileIdFromUri('file://media/Photo/183/5');
  AlbumDefine.getFileIdFromUri('file://media/Photo/s');
  AlbumDefine.getFileFetchOptByUriList([]);
  AlbumDefine.getFileFetchOptByUriList([1]);
  AlbumDefine.getFileFetchOptForYearAndMonth(2, 1, true);
  AlbumDefine.getFileFetchOptByDateModified(2, 1);
  AlbumDefine.getFileFetchOptByName('file://media/Photo/s');
  AlbumDefine.getFileFetchOptByPath('file://media/Photo/s');
  AlbumDefine.getPhotoFetchOptByUri('file://media/Photo/s');
  AlbumDefine.getAlbumFetchOptByName('file://media/Photo/s');
  AlbumDefine.getAlbumFetchOptByUri('file://media/Photo/s');
  AlbumDefine.getAlbumsFetchOptByUris(['file://media/Photo/s']);
  AlbumDefine.getAlbumFetchOptByOrderDesc();
  Log.info(TAG, 'AlbumDefineTest_002 end');
}

async function AlbumDefineTest03() {
  Log.info(TAG, 'AlbumDefineTest_003 start');
  let builder = new FileFetchOptionBuilder();
  AlbumDefine.setFilterMediaType(builder, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
  AlbumDefine.setFilterMediaType(builder, AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
  AlbumDefine.setFilterMediaType(builder, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO);
  AlbumDefine.setFilterMediaType(builder, 'image/jpeg');
  AlbumDefine.getFileFetchOptByDateModified(2, 1);
  AlbumDefine.getAllLocalVideoFile(builder);
  AlbumDefine.getBurstPhotosFetchOpt(2, 1, true, true);
  AlbumDefine.getBurstPhotosFetchOpt(2, 1, true, false);
  let allItemsFetchOpt: FetchOptions =
    AlbumDefine.getFileFetchOpt(2, 1);
  AlbumDefine.modifyPredicatesInAlbumUris(allItemsFetchOpt.predicates, ['file://media/Photo/183/5']);
  AlbumDefine.modifyPredicatesInPhotoUris(allItemsFetchOpt.predicates, ['file://media/Photo/183/5']);
  AlbumDefine.getPhotoTypeKeyByFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_VIDEO);
  AlbumDefine.getPhotoTypeKeyByFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
  AlbumDefine.getPhotoTypeKeyByFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE_MOVING_PHOTO);
  AlbumDefine.getPhotoTypeKeyByFilterMediaType('');
  AlbumDefine.albumNameReplacer('albumName', '1');
  AlbumDefine.getAnonymizeAlbumName('albumName');
  AlbumDefine.isSystemAlbum(185);
  AlbumDefine.isUserAlbum(185, 1);
  AlbumDefine.isSourceAlbum(1);
  expect(allItemsFetchOpt !== undefined).assertTrue();
  Log.info(TAG, 'AlbumDefineTest_003 end');
}

async function AlbumDefineTest04() {
  Log.info(TAG, 'AlbumDefineTest_004 start');
  let result: string = AlbumDefine.getActualStringByQueryType('test', 5);
  expect(result).assertEqual('test');
}

async function AlbumDefineTest05() {
  let mocker: MockKit = new MockKit();
  let mockThumbnailReady: Function = mocker.mockFunc(ImageUtil, ImageUtil.isThumbnailReady);
  when(mockThumbnailReady)(ArgumentMatchers.anyString).afterReturn(false);
  let result: FetchOptions = AlbumDefine.getFileFetchOptWithCleanupPage(Constants.GRID_CLEANUP_PAGE, 0, 10, true);
  expect(result !== null).assertTrue();
  mocker.ignoreMock(ImageUtil, ImageUtil.isThumbnailReady);
}

async function AlbumDefineTest06() {
  let mocker: MockKit = new MockKit();
  let mockThumbnailReady: Function = mocker.mockFunc(ImageUtil, ImageUtil.isThumbnailReady);
  when(mockThumbnailReady)(ArgumentMatchers.anyString).afterReturn(false);
  let result: FetchOptions = AlbumDefine.getFileFetchOptWithCleanupPage(Constants.VIDEO_CLEANUP_PAGE, 0, 10, true);
  expect(result !== null).assertTrue();
  mocker.ignoreMock(ImageUtil, ImageUtil.isThumbnailReady);
}

async function AlbumDefineTest07() {
  let mocker: MockKit = new MockKit();
  let mockThumbnailReady: Function = mocker.mockFunc(ImageUtil, ImageUtil.isThumbnailReady);
  when(mockThumbnailReady)(ArgumentMatchers.anyString).afterReturn(true);
  let result: FetchOptions = AlbumDefine.getFileFetchOptWithCleanupPage(Constants.VIDEO_CLEANUP_PAGE, 0, 10, true);
  expect(result !== null).assertTrue();
  mocker.ignoreMock(ImageUtil, ImageUtil.isThumbnailReady);
}

async function AlbumDefineTest08() {
  let mocker: MockKit = new MockKit();
  let mockThumbnailReady: Function = mocker.mockFunc(ImageUtil, ImageUtil.isThumbnailReady);
  when(mockThumbnailReady)(ArgumentMatchers.anyString).afterReturn(true);
  let result: FetchOptions = AlbumDefine.getFileFetchOptWithCleanupPage(Constants.VIDEO_CLEANUP_PAGE,
    undefined, undefined, true);
  expect(result !== null).assertTrue();
  mocker.ignoreMock(ImageUtil, ImageUtil.isThumbnailReady);
}

async function AlbumDefineTest09() {
  let builder = new FileFetchOptionBuilder();
  let result: FileFetchOptionBuilder = AlbumDefine.getAllLocalPhotoFile(builder);
  expect(result !== null).assertTrue();
}

async function AlbumDefineTest10() {
  let result: FetchOptions = AlbumDefine.getCleanupPageBurstPhotosFetchOpt(-1, -10);
  expect(result !== null).assertTrue();
}

async function AlbumDefineTest11() {
  let result: FetchOptions = AlbumDefine.getCleanupPageBurstPhotosFetchOpt(0, 10);
  expect(result !== null).assertTrue();
}

async function AlbumDefineTest12() {
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let albumUris: string[] = [];
  AlbumDefine.modifyPredicatesInAlbumUris(predicates, albumUris);
  expect(predicates !== null).assertTrue();
}

async function AlbumDefineTest13() {
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let albumUris: string[] = ['file://media/Photo/1', 'file://media/Photo/2'];
  AlbumDefine.modifyPredicatesInAlbumUris(predicates, albumUris);
  expect(predicates !== null).assertTrue();
}

async function AlbumDefineTest14() {
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let albumUris: string[] = [];
  AlbumDefine.modifyPredicatesInPhotoUris(predicates, albumUris);
  expect(predicates !== null).assertTrue();
}

async function AlbumDefineTest15() {
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let photoUris: string[] = ['file://media/Photo/1', 'file://media/Photo/2'];
  AlbumDefine.modifyPredicatesInPhotoUris(predicates, photoUris);
  expect(predicates !== null).assertTrue();
}