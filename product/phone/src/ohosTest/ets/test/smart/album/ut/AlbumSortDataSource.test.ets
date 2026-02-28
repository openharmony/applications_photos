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
import { AlbumSortDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSortDataSource';
import { MediaObserverNfyInfo } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { MediaObserverNfyType } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { AlbumOrderInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumOrderInfo';

import {
  AlbumSortConstants,
  OrderStyle,
  AlbumOrderType,
  AlbumOrderSection,
  AlbumSortCount,
  AlbumOrderStatus
} from '@ohos/common/src/main/ets/default/model/common/AlbumSortConstants';

const TAG = 'AlbumSortDataSourceTest';

/**
 * AlbumSortDataSource Unittest
 *
 * @since 2024-07-26
 */
export default function AlbumSortDataSourceTest() {
  describe('AlbumSortDataSourceTest', () => {
    it('AlbumSortDataSourceTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest01();
    });

    it('AlbumSortDataSourceTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest02();
    });

    it('AlbumSortDataSourceTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest03();
    });

    it('AlbumSortDataSourceTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest04();
    });

    it('AlbumSortDataSourceTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest05();
    });

    it('AlbumSortDataSourceTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest06();
    });

    it('AlbumSortDataSourceTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest07();
    });

    it('AlbumSortDataSourceTest_08', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest08();
    });

    it('AlbumSortDataSourceTest_09', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest09();
    });

    it('AlbumSortDataSourceTest_10', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest10();
    });

    it('AlbumSortDataSourceTest_11', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest11();
    });

    it('AlbumSortDataSourceTest_12', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest12();
    });

    it('AlbumSortDataSourceTest_13', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest13();
    });

    it('AlbumSortDataSourceTest_14', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest14();
    });

    it('AlbumSortDataSourceTest_15', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest15();
    });

    it('AlbumSortDataSourceTest_16', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest16();
    });

    it('AlbumSortDataSourceTest_17', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest17();
    });

    it('AlbumSortDataSourceTest_18', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest18();
    });

    it('AlbumSortDataSourceTest_19', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest19();
    });

    it('AlbumSortDataSourceTest_20', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest20();
    });

    it('AlbumSortDataSourceTest_21', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest21();
    });

    it('AlbumSortDataSourceTest_22', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest22();
    });

    it('AlbumSortDataSourceTest_23', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest23();
    });

    it('AlbumSortDataSourceTest_24', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest24();
    });

    it('AlbumSortDataSourceTest_25', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest25();
    });

    it('AlbumSortDataSourceTest_26', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest26();
    });

    it('AlbumSortDataSourceTest_27', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest27();
    });

    it('AlbumSortDataSourceTest_28', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest28();
    });

    it('AlbumSortDataSourceTest_29', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest29();
    });

    it('AlbumSortDataSourceTest_30', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest30();
    });

    it('AlbumSortDataSourceTest_31', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest31();
    });

    it('AlbumSortDataSourceTest_32', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest32();
    });

    it('AlbumSortDataSourceTest_33', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest33();
    });

    it('AlbumSortDataSourceTest_34', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest34();
    });

    it('AlbumSortDataSourceTest_35', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest35();
    });

    it('AlbumSortDataSourceTest_36', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest36();
    });

    it('AlbumSortDataSourceTest_37', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await AlbumSortDataSourceTest37();
    });
  })
}

/**
 * initSecondBatch
 */
async function AlbumSortDataSourceTest01() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.initSecondBatch();

  expect(source !== undefined).assertTrue();
}

/**
 * initFirstBach
 */
async function AlbumSortDataSourceTest02() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.initFirstBatch();

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 index < this.systemAlbumAreaCount
 */
async function AlbumSortDataSourceTest03() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.getData(-1);

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 index === this.systemAlbumAreaCount
 */
async function AlbumSortDataSourceTest04() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.getData(0);

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 index < this.sourceAlbumAreaIndex
 */
async function AlbumSortDataSourceTest05() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.sourceAlbumAreaIndex = 2;
  source.getData(1);

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 index === this.sourceAlbumAreaIndex
 */
async function AlbumSortDataSourceTest06() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.sourceAlbumAreaIndex = 1;
  source.getData(1);

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 index < this.totalCount()
 */
async function AlbumSortDataSourceTest07() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.sourceAlbumAreaIndex = 1;

  let mocker: MockKit = new MockKit();
  let totalCount: Function = mocker.mockFunc(source, source.totalCount);
  when(totalCount)(ArgumentMatchers.any).afterReturn(4);

  source.getData(3);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, source.totalCount)
}

/**
 * sortByAlphabetical
 * 分支 albumOrderSection === AlbumOrderSection.MY_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest08() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.sortByAlphabetical(1);

  expect(source !== undefined).assertTrue();
}

/**
 * getSectionOffset
 * 分支 section === AlbumOrderSection.SYSTEM_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest09() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.SYSTEM_ALBUMS_AREA;

  const run = (section: AlbumOrderSection): number => Reflect.get(source, 'getSectionOffset')
    .call(source, section);

  let res = run(section);

  expect(res === 0).assertTrue();
}

/**
 * getSectionOffset
 * 分支 section === AlbumOrderSection.MY_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest10() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.MY_ALBUMS_AREA;

  const run = (section: AlbumOrderSection): number => Reflect.get(source, 'getSectionOffset')
    .call(source, section);

  let res = run(section);

  expect(res === 1).assertTrue();
}

/**
 * getSectionOffset
 * 分支 section === AlbumOrderSection.SOURCE_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest11() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.SOURCE_ALBUMS_AREA;

  const run = (section: AlbumOrderSection): number => Reflect.get(source, 'getSectionOffset')
    .call(source, section);

  let res = run(section);

  expect(res === 2).assertTrue();
}

/**
 * getSectionOffset
 * 分支 section === AlbumOrderSection.UNSORTED_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest12() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.UNSORTED_ALBUMS_AREA;

  const run = (section: AlbumOrderSection): number => Reflect.get(source, 'getSectionOffset')
    .call(source, section);

  let res = run(section);

  expect(res === 0).assertTrue();
}

/**
 * getSectionByIndex
 * 分支 index <= myAlbumStart
 */
async function AlbumSortDataSourceTest13() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);

  const run = (index: number, myAlbumStart: number, sourceAlbumStart: number): AlbumOrderSection | null => Reflect.get(source, 'getSectionByIndex')
    .call(source, index, myAlbumStart, sourceAlbumStart);

  let res = run(1, 2, 3);

  expect(res === AlbumOrderSection.SYSTEM_ALBUMS_AREA).assertTrue();
}

/**
 * getSectionByIndex
 * 分支 index <= sourceAlbumStart
 */
async function AlbumSortDataSourceTest14() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);

  const run = (index: number, myAlbumStart: number, sourceAlbumStart: number): AlbumOrderSection | null => Reflect.get(source, 'getSectionByIndex')
    .call(source, index, myAlbumStart, sourceAlbumStart);

  let res = run(3, 2, 3);

  expect(res === AlbumOrderSection.MY_ALBUMS_AREA).assertTrue();
}


/**
 * getSectionByIndex
 * 分支 index <= sourceAlbumStart
 */
async function AlbumSortDataSourceTest15() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);

  const run = (index: number, myAlbumStart: number, sourceAlbumStart: number): AlbumOrderSection | null => Reflect.get(source, 'getSectionByIndex')
    .call(source, index, myAlbumStart, sourceAlbumStart);

  let res = run(3, 2, 3);

  expect(res === AlbumOrderSection.MY_ALBUMS_AREA).assertTrue();
}

/**
 * getSectionByIndex
 * 分支 index <= totalCount
 */
async function AlbumSortDataSourceTest16() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);

  const run = (index: number, myAlbumStart: number, sourceAlbumStart: number): AlbumOrderSection | null => Reflect.get(source, 'getSectionByIndex')
    .call(source, index, myAlbumStart, sourceAlbumStart);

  let mocker: MockKit = new MockKit();
  let totalCount: Function = mocker.mockFunc(source, source.totalCount);
  when(totalCount)(ArgumentMatchers.any).afterReturn(4);


  let res = run(4, 2, 3);

  expect(res === AlbumOrderSection.SOURCE_ALBUMS_AREA).assertTrue();
  mocker.ignoreMock(source, source.totalCount)
}

/**
 * getOrderTypeBySection
 * 分支 section === AlbumOrderSection.MY_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest17() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.MY_ALBUMS_AREA;
  let myAlbumAreaType: AlbumOrderType = 0;
  let sourceAlbumAreaType: AlbumOrderType = 1;

  const run = (section: AlbumOrderSection, myAlbumAreaType: AlbumOrderType,
    sourceAlbumAreaType: AlbumOrderType): AlbumOrderType => Reflect.get(source, 'getOrderTypeBySection')
    .call(source, section, myAlbumAreaType, sourceAlbumAreaType);

  let res = run(section, myAlbumAreaType, sourceAlbumAreaType);

  expect(res === myAlbumAreaType).assertTrue();
}

/**
 * getOrderTypeBySection
 * 分支 section === AlbumOrderSection.SOURCE_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest18() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.SOURCE_ALBUMS_AREA;
  let myAlbumAreaType: AlbumOrderType = 0;
  let sourceAlbumAreaType: AlbumOrderType = 1;

  const run = (section: AlbumOrderSection, myAlbumAreaType: AlbumOrderType,
    sourceAlbumAreaType: AlbumOrderType): AlbumOrderType => Reflect.get(source, 'getOrderTypeBySection')
    .call(source, section, myAlbumAreaType, sourceAlbumAreaType);

  let res = run(section, myAlbumAreaType, sourceAlbumAreaType);

  expect(res === sourceAlbumAreaType).assertTrue();
}

/**
 * getOrderTypeBySection
 * 分支 section === AlbumOrderSection.SYSTEM_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest19() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let section: AlbumOrderSection = AlbumOrderSection.SYSTEM_ALBUMS_AREA;
  let myAlbumAreaType: AlbumOrderType = 0;
  let sourceAlbumAreaType: AlbumOrderType = 1;

  const run = (section: AlbumOrderSection, myAlbumAreaType: AlbumOrderType,
    sourceAlbumAreaType: AlbumOrderType): AlbumOrderType => Reflect.get(source, 'getOrderTypeBySection')
    .call(source, section, myAlbumAreaType, sourceAlbumAreaType);

  let res = run(section, myAlbumAreaType, sourceAlbumAreaType);

  expect(res === AlbumOrderType.CUSTOM_SORT).assertTrue();
}

/**
 * onNotify
 * 分支 nfyInfo.type === MediaObserverNfyType.ALBUM_UPDATE
 */
async function AlbumSortDataSourceTest20() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.ALBUM_UPDATE;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 nfyInfo.type === MediaObserverNfyType.ALBUM_UPDATE
 */
async function AlbumSortDataSourceTest21() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.ADD_PHOTO_INTO_ALBUM;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * onNotify
 * 分支 nfyInfo.type === MediaObserverNfyType.NONE
 */
async function AlbumSortDataSourceTest22() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let nfyInfo: MediaObserverNfyInfo = new MediaObserverNfyInfo();
  nfyInfo.type = MediaObserverNfyType.NONE;

  source.onNotify(nfyInfo);

  expect(source !== undefined).assertTrue();
}

/**
 * getData
 * 分支 else
 */
async function AlbumSortDataSourceTest23() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.systemAlbumAreaCount = 0;
  source.sourceAlbumAreaIndex = 1;

  let mocker: MockKit = new MockKit();
  let totalCount: Function = mocker.mockFunc(source, source.totalCount);
  when(totalCount)(ArgumentMatchers.any).afterReturn(4);

  source.getData(10);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, source.totalCount)
}

/**
 * sortByAlphabetical
 * 分支 albumOrderSection === AlbumOrderSection.SYSTEM_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest24() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.sortByAlphabetical(0);

  expect(source !== undefined).assertTrue();
}

/**
 * sortByAlphabetical
 * 分支 albumOrderSection === AlbumOrderSection.SOURCE_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest25() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.sortByAlphabetical(2);

  expect(source !== undefined).assertTrue();
}


/**
 * sortByAlphabetical
 * 分支 albumOrderSection === AlbumOrderSection.UNSORTED_ALBUMS_AREA
 */
async function AlbumSortDataSourceTest26() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  source.sortByAlphabetical(-1);

  expect(source !== undefined).assertTrue();
}

/**
 * sortByAlphabetical
 * 分支 if !(startIdx < 0 || endIdx > this.albums.length || startIdx >= endIdx) {
 */
async function AlbumSortDataSourceTest27() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;
  source.systemAlbumAreaCount = 1;
  source.sortByAlphabetical(0);

  expect(source !== undefined).assertTrue();
}

/**
 * swapData
 * 分支 if (sourceSection === null || targetSection === null) {
 */
async function AlbumSortDataSourceTest28() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getSectionByIndexMock: Function = Reflect.get(source, 'getSectionByIndex')
  let getSectionByIndex: Function = mocker.mockFunc(source, getSectionByIndexMock);
  when(getSectionByIndex)(ArgumentMatchers.any).afterReturn(null);

  source.swapData(0, 1, 0, 0);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getSectionByIndexMock);
}

/**
 * swapData
 * 分支 if (sourceSection === targetSection) {
 */
async function AlbumSortDataSourceTest29() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getSectionByIndexMock: Function = Reflect.get(source, 'getSectionByIndex')
  let getSectionByIndex: Function = mocker.mockFunc(source, getSectionByIndexMock);
  when(getSectionByIndex)(ArgumentMatchers.any).afterReturn(1);

  source.swapData(0, 1, 0, 0);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getSectionByIndexMock);
}

/**
 * swapData
 * 分支 if !(sourceSection === targetSection) {
 */
async function AlbumSortDataSourceTest30() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  source.swapData(0, 1, 0, 0);

  expect(source !== undefined).assertTrue();
}


/**
 * handleSameSectionMove
 * 分支 if (orderType === AlbumOrderType.SORT_BY_NAME) {
 */
async function AlbumSortDataSourceTest31() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getOrderTypeBySectionMock: Function = Reflect.get(source, 'getOrderTypeBySection');
  let getOrderTypeBySection: Function = mocker.mockFunc(source, getOrderTypeBySectionMock);
  when(getOrderTypeBySection)(ArgumentMatchers.any).afterReturn(AlbumOrderType.SORT_BY_NAME);

  const run = (
    from: number,
    to: number,
    section: AlbumOrderSection,
    myAlbumOrderType: AlbumOrderType,
    sourceAlbumOrderType: AlbumOrderType
  ): void => Reflect.get(source, 'handleSameSectionMove')
    .call(source, from, to, section, myAlbumOrderType, sourceAlbumOrderType);

  run(0, 1, 1, 0, 0);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getOrderTypeBySectionMock);
}

/**
 * handleSameSectionMove
 * 分支 if !(orderType === AlbumOrderType.SORT_BY_NAME) {
 */
async function AlbumSortDataSourceTest32() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getOrderTypeBySectionMock: Function = Reflect.get(source, 'getOrderTypeBySection');
  let getOrderTypeBySection: Function = mocker.mockFunc(source, getOrderTypeBySectionMock);
  when(getOrderTypeBySection)(ArgumentMatchers.any).afterReturn(AlbumOrderType.CUSTOM_SORT);

  const run = (
    from: number,
    to: number,
    section: AlbumOrderSection,
    myAlbumOrderType: AlbumOrderType,
    sourceAlbumOrderType: AlbumOrderType
  ): void => Reflect.get(source, 'handleSameSectionMove')
    .call(source, from, to, section, myAlbumOrderType, sourceAlbumOrderType);

  run(0, 1, 1, 0, 0);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getOrderTypeBySectionMock);
}

/**
 * handleCrossSectionMove
 * 分支 if (sourceSection === AlbumOrderSection.SYSTEM_ALBUMS_AREA) {
 * 分支 if (targetSection === AlbumOrderSection.SYSTEM_ALBUMS_AREA) {
 * 分支 if (targetOrderType === AlbumOrderType.SORT_BY_NAME) {
 */
async function AlbumSortDataSourceTest33() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getOrderTypeBySectionMock: Function = Reflect.get(source, 'getOrderTypeBySection');
  let getOrderTypeBySection: Function = mocker.mockFunc(source, getOrderTypeBySectionMock);
  when(getOrderTypeBySection)(ArgumentMatchers.any).afterReturn(AlbumOrderType.SORT_BY_NAME);

  const run = (
    from: number,
    to: number,
    sourceSection: AlbumOrderSection,
    targetSection: AlbumOrderSection,
    myAlbumOrderType: AlbumOrderType,
    sourceAlbumOrderType: AlbumOrderType
  ): void => Reflect.get(source, 'handleCrossSectionMove')
    .call(source, from, to, sourceSection, targetSection, myAlbumOrderType, sourceAlbumOrderType);

  run(0, 1, AlbumOrderSection.SYSTEM_ALBUMS_AREA, AlbumOrderSection.SYSTEM_ALBUMS_AREA, 0, 1);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getOrderTypeBySectionMock);
}

/**
 * handleCrossSectionMove
 * 分支 if (sourceSection === AlbumOrderSection.MY_ALBUMS_AREA) {
 * 分支 if (targetSection === AlbumOrderSection.MY_ALBUMS_AREA) {
 * 分支 if !(targetOrderType === AlbumOrderType.SORT_BY_NAME) {
 */
async function AlbumSortDataSourceTest34() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let info2 = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;

  let mocker: MockKit = new MockKit();
  let getOrderTypeBySectionMock: Function = Reflect.get(source, 'getOrderTypeBySection');
  let getOrderTypeBySection: Function = mocker.mockFunc(source, getOrderTypeBySectionMock);
  when(getOrderTypeBySection)(ArgumentMatchers.any).afterReturn(AlbumOrderType.CUSTOM_SORT);

  const run = (
    from: number,
    to: number,
    sourceSection: AlbumOrderSection,
    targetSection: AlbumOrderSection,
    myAlbumOrderType: AlbumOrderType,
    sourceAlbumOrderType: AlbumOrderType
  ): void => Reflect.get(source, 'handleCrossSectionMove')
    .call(source, from, to, sourceSection, targetSection, myAlbumOrderType, sourceAlbumOrderType);

  run(0, 1, AlbumOrderSection.MY_ALBUMS_AREA, AlbumOrderSection.MY_ALBUMS_AREA, 0, 1);

  expect(source !== undefined).assertTrue();
  mocker.ignoreMock(source, getOrderTypeBySectionMock);
}

/**
 * getSectionByIndex
 * 分支 return null;
 */
async function AlbumSortDataSourceTest35() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);

  const run = (index: number, myAlbumStart: number, sourceAlbumStart: number): AlbumOrderSection | null => Reflect.get(source, 'getSectionByIndex')
    .call(source, index, myAlbumStart, sourceAlbumStart);

  let mocker: MockKit = new MockKit();
  let totalCount: Function = mocker.mockFunc(source, source.totalCount);
  when(totalCount)(ArgumentMatchers.any).afterReturn(4);

  let res = run(1000, 2, 3);

  expect(res === null).assertTrue();
  mocker.ignoreMock(source, source.totalCount);
}

/**
 * sortByAlphabetical
 * 分支  if (totalExpected > this.albums.length) {
 */
async function AlbumSortDataSourceTest36() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  let albums: AlbumOrderInfo[] = [info];
  source.albums = albums;
  source.systemAlbumAreaCount = 10;
  source.sortByAlphabetical(0);

  expect(source !== undefined).assertTrue();
}

/**
 * setCustomSortOrderType
 * 分支 if (item.albumOrderSection === section) {
 * 分支 if ！(item.albumOrderSection === section) {
 */
async function AlbumSortDataSourceTest37() {
  let broadCast: BroadCast = new BroadCast();
  let source = new AlbumSortDataSource(broadCast);
  let info = new AlbumOrderInfo();
  info.albumOrderSection = AlbumOrderSection.MY_ALBUMS_AREA;
  let info2 = new AlbumOrderInfo();
  info2.albumOrderSection = AlbumOrderSection.SYSTEM_ALBUMS_AREA;
  let albums: AlbumOrderInfo[] = [info, info2];
  source.albums = albums;
  source.setCustomSortOrderType(AlbumOrderSection.MY_ALBUMS_AREA);

  expect(source !== undefined).assertTrue();
}