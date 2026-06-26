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
import { PrintActionViewModel } from '@ohos/common/src/main/ets/default/view/actionbar/PrintAction';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { PrintUtil } from '@ohos/common/src/main/ets/default/utils/PrintUtil';
const NUMBER_ONE: number = 1;
const TAG: string = 'common_PrintAction';

/**
 * PrintAction Unittest
 *
 * @since 2025-06-05
 */
export default function PrintActionTest() {
  describe('PrintActionTest',  () => {
    it('PrintActionTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest001();
    });

    it('PrintActionTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest002();
    });

    it('PrintActionTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest003();
    });

    it('PrintActionTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest004();
    });

    it('PrintActionTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest005();
    });

    it('PrintActionTest_009', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest009();
    });

    it('PrintActionTest_010', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest010();
    });

    it('PrintActionTest_011', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest011();
    });

    it('PrintActionTest_012', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest012();
    });

    it('PrintActionTest_013', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest013();
    });

    it('PrintActionTest_014', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest014();
    });

    it('PrintActionTest_015', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest015();
    });

    it('PrintActionTest_016', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest016();
    });

    it('PrintActionTest_017', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PrintActionTest017();
    });
  });
}

interface DownloadInfo {
  batchDownloadProcess: Map<string, number>;
  batchDownloadDoneSize: number;
  batchDownloadFileSize: number;
  cloudSize: number;
}

const DOWNLOAD_INFO: string = Reflect.get(PrintActionViewModel, 'DOWNLOAD_INFO');

/**
 * doAction
 * 分支 !menuContext
 */
async function PrintActionTest001() {
  let printActionViewModel = new PrintActionViewModel();

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  printActionViewModel.doAction();

  mocker.verify('error', [TAG, 'invalid menuContext']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
  expect(1).assertEqual(1);
}

/**
 * doAction
 * 分支 !selectManager
 */
async function PrintActionTest002() {
  let printActionViewModel = new PrintActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  menuContext.selectManager = undefined;

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  printActionViewModel.doAction(menuContext);

  mocker.verify('error', [TAG, 'invalid selectManager']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
  expect(1).assertEqual(1);
}

/**
 * doAction
 * 分支 count > PrintUtil.PRINT_MAX_NUMBER
 */
async function PrintActionTest003() {
  let printActionViewModel = new PrintActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;

  let mocker: MockKit = new MockKit();
  let mockManager: Function = mocker.mockFunc(selectManager, selectManager.getSelectedCount);
  when(mockManager)(ArgumentMatchers.anyString).afterReturn(PrintUtil.PRINT_MAX_NUMBER + 1);

  let mockWarn: Function = mocker.mockFunc(Log, Log.warn);
  when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();

  printActionViewModel.doAction(menuContext);

  mocker.verify('warn', [TAG, 'exceed max print count']).atLeast(1);
  mocker.ignoreMock(selectManager, selectManager.getSelectedCount);
  mocker.ignoreMock(Log, Log.warn);
  expect(1).assertEqual(1);
}

/**
 * doAction
 * 分支 count <= PrintUtil.PRINT_MAX_NUMBER
 */
async function PrintActionTest004() {
  let printActionViewModel = new PrintActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;

  let mocker: MockKit = new MockKit();
  let mockManager: Function = mocker.mockFunc(selectManager, selectManager.getSelectedCount);
  when(mockManager)(ArgumentMatchers.anyString).afterReturn(PrintUtil.PRINT_MAX_NUMBER - 1);

  let downloadItems: Function = mocker.mockFunc(printActionViewModel, Reflect.get(printActionViewModel, 'downloadItems'));
  when(downloadItems)(ArgumentMatchers.anyString).afterReturnNothing();
  printActionViewModel.doAction(menuContext);

  expect(selectManager.inverseSelection).assertFalse();
  mocker.ignoreMock(selectManager, selectManager.getSelectedCount);
  mocker.ignoreMock(printActionViewModel, Reflect.get(printActionViewModel, 'downloadItems'));
  expect(1).assertEqual(1);
}

/**
 * downloadItems
 * 分支 cloudUris.length === 0
 */
async function PrintActionTest005() {
  let printActionViewModel = new PrintActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  const startTime: number = Date.now();
  let items: MediaItem[] = [];

  let mocker: MockKit = new MockKit();
  let multiplePrint: Function = mocker.mockFunc(PrintUtil, PrintUtil.multiplePrint);
  when(multiplePrint)(ArgumentMatchers.anyString).afterReturn(undefined);

  let mockInfo: Function = mocker.mockFunc(Log, Log.info);
  when(mockInfo)(ArgumentMatchers.anyString).afterReturnNothing();

  const run = (menuContext: MenuContext, items: MediaItem[], startTime: number):  Promise<void> => Reflect.get(printActionViewModel, 'downloadItems')
    .call(printActionViewModel, menuContext, items, startTime);
  await run(menuContext, items, startTime);

  mocker.verify('info', [TAG, 'batchDownload for print, finish']).atLeast(0);
  mocker.ignoreMock(PrintUtil, PrintUtil.multiplePrint);
  mocker.ignoreMock(Log, Log.info);
  expect(1).assertEqual(1);
}

/**
 * updateBatchDownloadProgress
 * 分支 process === -1
 */
async function PrintActionTest009() {
  let printActionViewModel = new PrintActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = '';
  let process = -1;
  let percentage = 0;
  let failCb: Function = () => {
    Log.info(TAG, 'batchDownload for print, cancel');
  };
  let successCb: Function = () => {};

  let mocker: MockKit = new MockKit();
  let mockInfo: Function = mocker.mockFunc(Log, Log.info);
  when(mockInfo)(ArgumentMatchers.anyString).afterReturnNothing();

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(1).assertEqual(1);
  mocker.verify('info', [TAG, 'batchDownload for print, cancel']).atLeast(0);
  mocker.ignoreMock(Log, Log.info);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && !downloadInfo
 */
async function PrintActionTest010() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = '';
  let process = 0;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  let downloadInfo: DownloadInfo | undefined = menuContext.get<DownloadInfo>(DOWNLOAD_INFO);
  expect(!downloadInfo).assertTrue();
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && !downloadInfo.batchDownloadProcess.has(uri)
 */
async function PrintActionTest011() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 0;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: 1,
    cloudSize: 0,
  };
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  let downloadInfo2: DownloadInfo | undefined = menuContext.get<DownloadInfo>(DOWNLOAD_INFO);
  expect(!downloadInfo2?.batchDownloadProcess.has(uri)).assertTrue();
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size === 1
 * && percentage != 100 && isNaN(processValue)
 */
async function PrintActionTest012() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 100;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: NaN,
    cloudSize: 0,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(1).assertEqual(1);
  mocker.verify('error', [TAG, 'calculate processValue err']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size > 1
 * && percentage === 100 && isNaN(processValue)
 */
async function PrintActionTest013() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 100;
  let percentage = 100;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: NaN,
    cloudSize: 0,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  downloadInfo.batchDownloadProcess.set('dd/cc', 0);
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(downloadInfo.batchDownloadDoneSize).assertEqual(1);
  mocker.verify('error', [TAG, 'calculate processValue err']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size > 1
 * && percentage == 100 && downloadInfo.batchDownloadDoneSize !== downloadInfo.cloudSize
 * && processValue >= Constants.DOWNLOAD_FINISH_PERCENTAGE
 */
async function PrintActionTest014() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 100;
  let percentage = 100;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: 1,
    cloudSize: 0,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  downloadInfo.batchDownloadProcess.set('dd/cc', 0);
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  let mocker: MockKit = new MockKit();
  let mockInfo: Function = mocker.mockFunc(Log, Log.info);
  when(mockInfo)(ArgumentMatchers.anyString).afterReturnNothing();

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(downloadInfo.batchDownloadDoneSize).assertEqual(1);
  mocker.verify('info', [TAG, 'process 100, but not complete. waiting...']).atLeast(1);
  mocker.ignoreMock(Log, Log.info);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size > 1
 * && percentage !== 100 && downloadInfo.batchDownloadDoneSize === downloadInfo.cloudSize
 * && processValue > Constants.DOWNLOAD_FINISH_PERCENTAGE
 */
async function PrintActionTest015() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 0;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: 1,
    cloudSize: 0,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  downloadInfo.batchDownloadProcess.set('dd/cc', 0);
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(downloadInfo.batchDownloadFileSize).assertEqual(0);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size > 1
 * && percentage !== 100 && downloadInfo.batchDownloadDoneSize !== downloadInfo.cloudSize
 * && processValue > Constants.DOWNLOAD_FINISH_PERCENTAGE
 */
async function PrintActionTest016() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 0;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 0,
    batchDownloadFileSize: 1,
    cloudSize: 1,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  downloadInfo.batchDownloadProcess.set('dd/cc', 0)
  const DOWNLOAD_INFO: string = Reflect.get(PrintActionViewModel, 'DOWNLOAD_INFO');
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(downloadInfo.batchDownloadFileSize).assertEqual(1);
}

/**
 * updateBatchDownloadProgress
 * 分支 process !== -1 && downloadInfo && downloadInfo.batchDownloadProcess.has(uri) && downloadInfo.batchDownloadProcess.size > 1
 * && percentage !== 100 && downloadInfo.batchDownloadDoneSize === downloadInfo.cloudSize
 * && processValue > Constants.DOWNLOAD_FINISH_PERCENTAGE
 */
async function PrintActionTest017() {
  let printActionViewModel = new PrintActionViewModel();
  // menuContext默认没有set downloadInfo
  let menuContext: MenuContext = new MenuContext();
  let selectManager: SelectManager = new SelectManager();
  menuContext.selectManager = selectManager;
  let uri = 'cc/dd';
  let process = 100;
  let percentage = 0;
  let failCb: Function = () => {};
  let successCb: Function = () => {};

  let downloadInfo: DownloadInfo = {
    batchDownloadProcess: new Map<string, number>(),
    batchDownloadDoneSize: 1,
    batchDownloadFileSize: 1,
    cloudSize: 1,
  };
  downloadInfo.batchDownloadProcess.set(uri, 0);
  downloadInfo.batchDownloadProcess.set('dd/cc', 100);
  const DOWNLOAD_INFO: string = Reflect.get(PrintActionViewModel, 'DOWNLOAD_INFO');
  menuContext.set(DOWNLOAD_INFO, downloadInfo);

  const run = (uri: string, process: number, percentage: number, failCb: Function,
    successCb: Function, menuContext: MenuContext):  Promise<void> => Reflect.get(printActionViewModel, 'updateBatchDownloadProgress')
    .call(printActionViewModel, uri, process, percentage, failCb, successCb, menuContext);
  await run(uri, process, percentage, failCb, successCb, menuContext);

  expect(downloadInfo.batchDownloadFileSize).assertEqual(0);
}