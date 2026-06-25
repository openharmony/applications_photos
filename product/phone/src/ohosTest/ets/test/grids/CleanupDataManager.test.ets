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
import { describe, expect, it, MockKit, ArgumentMatchers, when  } from '@ohos/hypium';
import { CleanupDataManager } from '@ohos/common/src/main/ets/default/model/browser/photo/CleanupDataManager';
import { FetchType, QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import { collections } from '@kit.ArkTS'
import lazy { SendableMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SendableMediaItem';

export default function CleanupDataManagerTest() {

  describe('CleanupDataManagerTest', () => {
    // 测试getItems
    // 分支 !if (queryParam.albumUri) {
    it ('getItems', 0, async() => {
      let queryParam: QueryParam = {
        start: 0,
        count: 2,
        fetchType: FetchType.DATE_INFO,
        startTime: 1024,
        id: 'id',
        fileIds: [1, 2],
        orderBy: "orderBy"
      } as QueryParam
      let context = getContext();
      let cleanupDataManager = new CleanupDataManager(context, queryParam, 'fromPage', 'imageOrderByName');
      const res = await cleanupDataManager.getItems(queryParam);
      expect(res !== undefined).assertTrue();
    });

    //测试getFetchOpt
    it ('getFetchOpt', 0, () => {
      let queryParam: QueryParam = {
        start: 0,
        count: 2,
        fetchType: FetchType.DATE_INFO,
        startTime: 1024,
        id: 'id',
        fileIds: [1, 2],
        orderBy: "orderBy"
      } as QueryParam
      let context = getContext();
      let cleanupDataManager = new CleanupDataManager(context, queryParam, 'fromPage', 'imageOrderByName');
      const res = cleanupDataManager.getFetchOpt(queryParam);
      expect(res !== undefined).assertTrue();
    });

    //测试onDestroy
    it ('onDestroy', 0, () => {
      let mocker = new MockKit();
      let queryParam: QueryParam = {
        start: 0,
        count: 2,
        fetchType: FetchType.DATE_INFO,
        startTime: 1024,
        id: 'id',
        fileIds: [1, 2],
        orderBy: "orderBy"
      } as QueryParam
      let context = getContext();
      let cleanupDataManager = new CleanupDataManager(context, queryParam, 'fromPage', 'imageOrderByName');
      mocker.mockFunc(Reflect.get(cleanupDataManager, 'userFileManager'), Reflect.get(cleanupDataManager, 'userFileManager').onDestroy);
      cleanupDataManager.onDestroy();
      mocker.verify('onDestroy', []).atLeast(1);
      mocker.ignoreMock(Reflect.get(cleanupDataManager, 'userFileManager'), Reflect.get(cleanupDataManager, 'userFileManager').onDestroy);
    });

    it ('CleanupDataManagerTest_01', 0, async() => {
      await cleanupDataManagerTest01();
    })

    it ('CleanupDataManagerTest_02', 0, async() => {
      await cleanupDataManagerTest02();
    })

    it ('CleanupDataManagerTest_03', 0, async() => {
      await cleanupDataManagerTest03();
    })

    it ('CleanupDataManagerTest_04', 0, async() => {
      await cleanupDataManagerTest04();
    })

    it ('CleanupDataManagerTest_05', 0, async() => {
      await cleanupDataManagerTest05();
    })

  });
}

/**
 * getItems
 * 分支 if (queryParam.albumUri) {
 * 分支 ! if (album) {
 */
async function cleanupDataManagerTest01() {
  let queryParam: QueryParam = {
    start: 0,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 1024,
    id: 'id',
    fileIds: [1, 2],
    orderBy: "orderBy",
    albumUri: 'test'
  } as QueryParam
  let context = getContext();
  let cleanupDataManager = new CleanupDataManager(context, queryParam, 'fromPage', 'imageOrderByName');
  const res = await cleanupDataManager.getItems(queryParam);
  expect(res !== undefined).assertTrue();
}

/**
 * getItemsTask
 * 分支  if (dataList) {
 */
async function cleanupDataManagerTest02() {
  let queryParam: QueryParam = {
    start: 0,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 1024,
    id: 'id',
    fileIds: [1, 2],
    orderBy: "orderBy",
    albumUri: 'test'
  } as QueryParam
  let context = getContext();
  let cleanupdatamanager: CleanupDataManager = new CleanupDataManager(context, queryParam, "page", "DATE_TAKEN_MS");
  let mocker: MockKit = new MockKit();
  let mockGetItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.getItems);
  let mockAddItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);

  let mockMediaItemList: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
  let mediaItem: SendableMediaItem = new SendableMediaItem();
  mockMediaItemList.push(mediaItem)

  when(mockGetItems)(ArgumentMatchers.any).afterReturn(mockMediaItemList);
  when(mockAddItems)(ArgumentMatchers.any).afterReturn(mockMediaItemList);

  await cleanupdatamanager.getItemsTask(mockMediaItemList);

  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.getItems);
  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);
}

/**
 * getItemsTask
 * 分支 !if (dataList) {
 */
async function cleanupDataManagerTest03() {
  let queryParam: QueryParam = {
    start: 0,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 1024,
    id: 'id',
    fileIds: [1, 2],
    orderBy: "orderBy",
    albumUri: 'test'
  } as QueryParam
  let context = getContext();
  let cleanupdatamanager: CleanupDataManager = new CleanupDataManager(context, queryParam, "page", "DATE_TAKEN_MS");
  let mocker: MockKit = new MockKit();
  let mockGetItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.getItems);
  let mockAddItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);

  let mockMediaItemList: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
  let mediaItem: SendableMediaItem = new SendableMediaItem();
  mockMediaItemList.push(mediaItem)

  when(mockGetItems)(ArgumentMatchers.any).afterReturnNothing();
  when(mockAddItems)(ArgumentMatchers.any).afterReturnNothing();

  await cleanupdatamanager.getItemsTask(mockMediaItemList);

  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.getItems);
  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);
}

/**
 * getItemsTask
 * 分支 if (dataList) {
 * 分支 if (!item?.uri) {
 */
async function cleanupDataManagerTest04() {
  let queryParam: QueryParam = {
    start: 0,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 1024,
    id: 'id',
    fileIds: [1, 2],
    orderBy: "orderBy",
    albumUri: 'test'
  } as QueryParam
  let context = getContext();
  let cleanupdatamanager: CleanupDataManager = new CleanupDataManager(context, queryParam, "page", "DATE_TAKEN_MS");
  let mocker: MockKit = new MockKit();
  let mockGetItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.getItems);
  let mockAddItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);

  let mockMediaItemList: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
  let mediaItem: SendableMediaItem = new SendableMediaItem();
  mockMediaItemList.push(mediaItem)

  when(mockGetItems)(ArgumentMatchers.any).afterReturn(mockMediaItemList);
  when(mockAddItems)(ArgumentMatchers.any).afterReturnNothing();

  await cleanupdatamanager.getItemsTask(mockMediaItemList);

  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.getItems);
  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);
}

/**
 * getItemsTask
 * 分支 if (dataList) {
 * 分支 !if (!item?.uri) {
 */
async function cleanupDataManagerTest05() {
  let queryParam: QueryParam = {
    start: 0,
    count: 2,
    fetchType: FetchType.DATE_INFO,
    startTime: 1024,
    id: 'id',
    fileIds: [1, 2],
    orderBy: "orderBy",
    albumUri: 'test'
  } as QueryParam
  let context = getContext();
  let cleanupdatamanager: CleanupDataManager = new CleanupDataManager(context, queryParam, "page", "DATE_TAKEN_MS");
  let mocker: MockKit = new MockKit();
  let mockGetItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.getItems);
  let mockAddItems: Function = mocker.mockFunc(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);

  let mockMediaItemList: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
  let mediaItem: SendableMediaItem = new SendableMediaItem();
  mediaItem.uri = 'test';
  mockMediaItemList.push(mediaItem)

  when(mockGetItems)(ArgumentMatchers.any).afterReturn(mockMediaItemList);
  when(mockAddItems)(ArgumentMatchers.any).afterReturnNothing();

  await cleanupdatamanager.getItemsTask(mockMediaItemList);

  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.getItems);
  mocker.ignoreMock(cleanupdatamanager, cleanupdatamanager.addItemIntoArray);
}
