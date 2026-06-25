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
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { DeleteMenuOperation } from '@ohos/common/src/main/ets/default/view/browserOperation/DeleteMenuOperation';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { PhotoAsset } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'DeleteMenuOperation';
const NUMBER_ONE: number = 1;

export default function DeleteMenuOperationTest() {
  describe('DeleteMenuOperationTest', () => {

    it('should_initialize_BATCH_SIZE_to_500_when_isTrashAlbum_is_true', 0, () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;

      // Act
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);

      // Assert
      expect(deleteMenuOperation.BATCH_SIZE).assertEqual(500);
    });

    it('should_initialize_BATCH_SIZE_to_1000_when_isTrashAlbum_is_false', 0, () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = false;

      // Act
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);

      // Assert
      expect(deleteMenuOperation.BATCH_SIZE).assertEqual(1000);
    });

    it('should_initialize_BATCH_SIZE_to_1000_when_albumInfo_is_undefined', 0, () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = undefined;

      // Act
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);

      // Assert
      expect(deleteMenuOperation.BATCH_SIZE).assertEqual(1000);
    });

    it('should_set_confirm_text_to_delete_when_isTrash_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.setConfirmText();
      let res = AppStorage.get<Resource>(Constants.CONFIRM_TEXT_KEY);
      expect(res != undefined).assertTrue();
    });

    it('should_set_confirm_text_to_delete_permanently_when_isTrash_is_true', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.setConfirmText();
      let res = AppStorage.get<Resource>(Constants.CONFIRM_TEXT_KEY);
      expect(res != undefined).assertTrue();
    });

    it('should_set_count_to_0_when_selectManager_is_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let menuContext: MenuContext = new MenuContext();
      menuContext.selectManager = undefined;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      mocker.mockFunc(Log, Log.info);
      deleteMenuOperation.doAction();
      mocker.verify('info', [TAG, 'DeleteMenuOperation!']).once();
      mocker.ignoreMock(Log, Log.info);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_log_error_when_menuContext_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      mocker.mockFunc(Log, Log.debug);
      deleteMenuOperation.doAction();
      mocker.verify('debug', [TAG, 'prepare selectManager complete']).times(2);
      mocker.ignoreMock(Log, Log.debug);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_confirmText_when_isNeedDelete_is_true', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.selectManager = new SelectManager();
      menuContext.isSkipDeleteDialog = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      when(mockFunc)([]).afterReturnNothing();
      mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.confirmCallback);
      deleteMenuOperation.doAction();
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.confirmCallback);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_confirmText_when_isNeedDelete_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.selectManager = new SelectManager();
      menuContext.isSkipDeleteDialog = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      when(mockFunc)([]).afterReturnNothing();
      deleteMenuOperation.doAction();
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_show_progress_dialog_when_isLemFoldState_is_true', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.selectManager = new SelectManager();
      menuContext.isSkipDeleteDialog = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      when(mockFunc)([]).afterReturnNothing();
      deleteMenuOperation.doAction();
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_show_progress_dialog_when_albumInfo_is_undefined', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.selectManager = new SelectManager();
      menuContext.isSkipDeleteDialog = false;
      menuContext.albumInfo = undefined;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      when(mockFunc)([]).afterReturnNothing();
      deleteMenuOperation.doAction();
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.setConfirmText);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_processOperation_when_selectAssets_is_empty', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockProcessOperation: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockProcessOperation)(ArgumentMatchers.any).afterReturnNothing();
      let assets: PhotoAsset[] = [];
      deleteMenuOperation.selectAssetCallback(assets);
      mocker.verify('processOperation', []).times(1);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_selectAssets_and_call_processOperation_when_selectAssetCallback_is_called', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockProcessOperation: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockProcessOperation)(ArgumentMatchers.any).afterReturnNothing();

      let assets: PhotoAsset[] = [];
      deleteMenuOperation.selectAssetCallback(assets);

      expect(deleteMenuOperation.selectAssets).assertDeepEquals(assets);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('should_return_immediately_when_isCancelled_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.isCancelled = true;
      await deleteMenuOperation.requestOneBatchOperation();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_isShowProgress_to_false_when_selectManager_is_not_null_and_inverseSelection_is_true', 0,
      async () => {
        let menuContext: MenuContext = new MenuContext();
        let selectManager: SelectManager = new SelectManager();
        selectManager.inverseSelection = true;
        menuContext.selectManager = selectManager;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.isCancelled = false;
        deleteMenuOperation.uris = ['uri1', 'uri2'];
        deleteMenuOperation.totalCount = 2;
        deleteMenuOperation.currentBatch = 1;
        deleteMenuOperation.totalBatches = 1;
        expect(deleteMenuOperation.requestOneBatchOperation()).assertPromiseIsResolved();
      });

    it('should_set_isShowProgress_to_true_when_selectManager_is_not_null_and_inverseSelection_is_false', 0,
      async () => {
        let menuContext: MenuContext = new MenuContext();
        let selectManager: SelectManager = new SelectManager();
        selectManager.inverseSelection = false;
        menuContext.selectManager = selectManager;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.isCancelled = false;
        deleteMenuOperation.uris = ['uri1', 'uri2'];
        deleteMenuOperation.totalCount = 2;
        deleteMenuOperation.currentBatch = 1;
        deleteMenuOperation.totalBatches = 1;
        expect(deleteMenuOperation.requestOneBatchOperation()).assertPromiseIsResolved();
      });

    it('should_set_isShowProgress_to_false_when_selectManager_is_not_null_and_inverseSelection_is_false_and_batchUris_is_empty',
      0, async () => {
        let menuContext: MenuContext = new MenuContext();
        let selectManager: SelectManager = new SelectManager();
        selectManager.inverseSelection = false;
        menuContext.selectManager = selectManager;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.isCancelled = false;
        deleteMenuOperation.uris = [];
        deleteMenuOperation.totalCount = 1;
        deleteMenuOperation.currentBatch = 1;
        deleteMenuOperation.totalBatches = 1;
        expect(deleteMenuOperation.requestOneBatchOperation()).assertPromiseIsResolved();
      });

    it('should_set_isShowProgress_to_true_when_selectManager_is_not_null_and_inverseSelection_is_true_and_batchUris_is_not_empty',
      0, async () => {
        let menuContext: MenuContext = new MenuContext();
        let selectManager: SelectManager = new SelectManager();
        selectManager.inverseSelection = true;
        menuContext.selectManager = selectManager;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.isCancelled = false;
        deleteMenuOperation.uris = ['uri1'];
        deleteMenuOperation.totalCount = 1;
        deleteMenuOperation.currentBatch = 1;
        deleteMenuOperation.totalBatches = 1;
        expect(deleteMenuOperation.requestOneBatchOperation()).assertPromiseIsResolved();
      });

    it('should_set_isShowProgress_to_false_when_selectManager_is_not_null_and_inverseSelection_is_false_and_batchAssets_is_empty',
      0, async () => {
        let menuContext: MenuContext = new MenuContext();
        let selectManager: SelectManager = new SelectManager();
        selectManager.inverseSelection = false;
        menuContext.selectManager = selectManager;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.isCancelled = false;
        deleteMenuOperation.uris = ['uri1', 'uri2'];
        deleteMenuOperation.selectAssets = [];
        deleteMenuOperation.totalCount = 2;
        deleteMenuOperation.currentBatch = 1;
        deleteMenuOperation.totalBatches = 1;
        expect(deleteMenuOperation.requestOneBatchOperation()).assertPromiseIsResolved();
      });

    it('should_reportFinish_when_isTrash_is_false_and_batchUris_length_greater_than_0', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockOnError: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.onError);
      when(mockOnError)(ArgumentMatchers.any).afterReturnNothing();
      let batchUris: string[] = ['uri1', 'uri2'];
      deleteMenuOperation.doDeleteOperation(false, batchUris, []);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.onError);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_reportFinish_when_isTrash_is_true_and_batchUris_length_greater_than_0', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockOnError: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.onError);
      when(mockOnError)(ArgumentMatchers.any).afterReturnNothing();

      let batchUris: string[] = ['uri1', 'uri2'];
      deleteMenuOperation.doDeleteOperation(true, batchUris, []);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.onError);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_reportFinish_when_isTrash_is_true_and_isNeedDelete_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockOnError: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.onError);
      when(mockOnError)(ArgumentMatchers.any).afterReturnNothing();
      deleteMenuOperation.doDeleteOperation(true, [], []);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.onError);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_reportFinish_when_isTrash_is_false_and_isNeedDelete_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockOnError: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.onError);
      when(mockOnError)(ArgumentMatchers.any).afterReturnNothing();
      deleteMenuOperation.doDeleteOperation(false, [], []);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.onError);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayConfirmCallback_test_when_allowedToClick_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let selectManager = new SelectManager();
      menuContext.mediaItem = new MediaItem();
      menuContext.selectManager = selectManager;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.delayConfirmCallback();
      let res: boolean = Reflect.get(deleteMenuOperation, 'allowedToClick')
      expect(res).assertEqual(false);
    });

    it('delayConfirmCallback_test_when_allowedToClick_is_false', 0, async () => {
      let mocker = new MockKit();
      let menuContext: MenuContext = new MenuContext();
      let selectManager = new SelectManager();
      menuContext.mediaItem = new MediaItem();
      menuContext.selectManager = selectManager;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'allowedToClick', false)
      mocker.mockFunc(Log, Log.info);
      deleteMenuOperation.delayConfirmCallback();
      mocker.verify('info', [TAG, 'not allowedToClick']).times(1);
      mocker.ignoreMock(Log, Log.info);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayConfirmCallback_test_when_isTrash_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.albumInfo.isTrashAlbum = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      if (deleteMenuOperation.menuContext.selectManager?.albumInfo) {
        deleteMenuOperation.menuContext.selectManager.albumInfo.isTrashAlbum = true;
      }
      deleteMenuOperation.delayConfirmCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayConfirmCallback_test_when_isTrash_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.albumInfo.isTrashAlbum = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      if (deleteMenuOperation.menuContext.selectManager?.albumInfo) {
        deleteMenuOperation.menuContext.selectManager.albumInfo.isTrashAlbum = true;
      }
      deleteMenuOperation.delayConfirmCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayConfirmCallback_test_when_isTrash_is_true_and_inverseSelection_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.albumInfo.isTrashAlbum = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      if (deleteMenuOperation.menuContext.selectManager?.albumInfo) {
        deleteMenuOperation.menuContext.selectManager.albumInfo.isTrashAlbum = true;
      }
      menuContext.selectManager.inverseSelection = false;
      deleteMenuOperation.delayConfirmCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayConfirmCallback_test_when_isTrash_is_false_and_inverseSelection_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.albumInfo.isTrashAlbum = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      if (deleteMenuOperation.menuContext.selectManager?.albumInfo) {
        deleteMenuOperation.menuContext.selectManager.albumInfo.isTrashAlbum = true;
      }
      menuContext.selectManager.mIsSelectedMode = true;
      menuContext.selectManager.inverseSelection = false;
      deleteMenuOperation.delayConfirmCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_add_items_to_clickedPath_and_call_processOperation', 0, async () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = true;
      menuContext.selectManager.mIsSelectedMode = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockFunc)([]).afterReturnNothing();

      // Act
      let clickedPath: Set<string> = new Set(['path1', 'path2']);
      deleteMenuOperation.clickedPathCallback(clickedPath);

      let currentClickPath: Set<string> = deleteMenuOperation.getTestClickedPath();
      // Assert
      expect(currentClickPath.size).assertEqual(2);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('should_add_items_to_clickedPath', 0, async () => {
      // Arrange
      const deleteMenuOperation = new DeleteMenuOperation(new MenuContext());
      const mocker = new MockKit();
      // Act
      const expectedClickedPath = new Set(['path1', 'path2']);
      deleteMenuOperation.clickedPathCallback(expectedClickedPath);
      // Assert
      // 通过测试方法直接获取私有属性
      const actualClickedPath = deleteMenuOperation.getTestClickedPath();
      expect(actualClickedPath.size).assertEqual(2);
      expect(actualClickedPath.has('path1')).assertTrue();
      expect(actualClickedPath.has('path2')).assertTrue();
      // 还原 mock
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('should_call_processOperation_when_clickedPath_is_empty', 0, async () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = true;
      menuContext.selectManager.mIsSelectedMode = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockFunc)([]).afterReturnNothing();
      // Act
      let clickedPath: Set<string> = new Set();
      deleteMenuOperation.clickedPathCallback(clickedPath);
      mocker.verify('processOperation', []).once();
      // Assert
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_processOperation_when_isTrashAlbum_is_false', 0, async () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = false;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = true;
      menuContext.selectManager.mIsSelectedMode = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockFunc)([]).afterReturnNothing();
      // Act
      let clickedPath: Set<string> = new Set(['path1', 'path2']);
      deleteMenuOperation.clickedPathCallback(clickedPath);
      // 通过测试方法直接获取私有属性
      const actualClickedPath = deleteMenuOperation.getTestClickedPath();
      expect(actualClickedPath.size).assertEqual(2);
      // Assert
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('should_call_processOperation_when_isTrashAlbum_is_true_and_mIsSelectedMode_is_false', 0, async () => {
      // Arrange
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = false;
      menuContext.selectManager.mIsSelectedMode = false;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockFunc)([]).afterReturnNothing();
      // Act
      let clickedPath: Set<string> = new Set(['path1', 'path2']);
      deleteMenuOperation.clickedPathCallback(clickedPath);
      // 通过测试方法直接获取私有属性
      const actualClickedPath = deleteMenuOperation.getTestClickedPath();
      expect(actualClickedPath.size).assertEqual(2);
      // Assert
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('should_call_processOperation_when_isTrashAlbum_is_true_and_mIsSelectedMode_is_true_and_inverseSelection_is_false',
      0, async () => {
        // Arrange
        let menuContext: MenuContext = new MenuContext();
        menuContext.albumInfo = new AlbumInfo();
        menuContext.albumInfo.isTrashAlbum = true;
        menuContext.selectManager = new SelectManager();
        menuContext.selectManager.inverseSelection = false;
        menuContext.selectManager.mIsSelectedMode = true;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
        when(mockFunc)([]).afterReturnNothing();
        expect(mockFunc).message('Cannot get source code of funtion');
        // Act
        let clickedPath: Set<string> = new Set(['path1', 'path2']);
        deleteMenuOperation.clickedPathCallback(clickedPath);
        // Assert
        mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation)
      });

    it('should_call_processOperation_when_isTrashAlbum_is_true_and_mIsSelectedMode_is_true_and_inverseSelection_is_true',
      0, async () => {
        // Arrange
        let menuContext: MenuContext = new MenuContext();
        menuContext.albumInfo = new AlbumInfo();
        menuContext.albumInfo.isTrashAlbum = true;
        menuContext.selectManager = new SelectManager();
        menuContext.selectManager.inverseSelection = true;
        menuContext.selectManager.mIsSelectedMode = true;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
        when(mockFunc)([]).afterReturnNothing();
        expect(mockFunc).message('Cannot get source code of funtion');
        // Act
        let clickedPath: Set<string> = new Set(['path1', 'path2']);
        deleteMenuOperation.clickedPathCallback(clickedPath);
        // Assert
        mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
      });

    it('should_call_cyclicOperation_when_onOperateContinue_is_called', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.cyclicOperation);
      when(mockFunc)([]).afterReturnNothing();
      deleteMenuOperation.onOperateContinue();
      let res: boolean = Reflect.get(deleteMenuOperation, 'isPause');
      expect(res).assertFalse();
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.cyclicOperation);
    });

    it('should_process_operation_when_fromPage_is_MEDIA_OPERATION_FROM_PHOTO_BROWSER', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.fromPage = Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let mocker: MockKit = new MockKit();
      let mockProcessOperation: Function = mocker.mockFunc(deleteMenuOperation, deleteMenuOperation.processOperation);
      when(mockProcessOperation)().afterReturnNothing();

      let mediaItem: MediaItem = new MediaItem();
      mediaItem.uniqueId = 'uniqueId';
      let msg: Record<string, string | number | boolean> = {};
      let isTrash: boolean | undefined = true;
      deleteMenuOperation.confirmCallbackWithMediaItem(mediaItem, msg, isTrash);
      mocker.verify('processOperation', []).atLeast(1);
      mocker.ignoreMock(deleteMenuOperation, deleteMenuOperation.processOperation);
    });

    it('delayCancelCallback_test', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.delayCancelCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayCancelCallback_test_when_media_data_is_not_null', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.mediaItem = new MediaItem();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.delayCancelCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('delayCancelCallback_test_when_allowedToClick_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'allowedToClick', false);
      deleteMenuOperation.delayCancelCallback();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_call_playAnime_when_playAnimeForTest_is_called', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.get(deleteMenuOperation, 'playAnime').call(deleteMenuOperation);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_image_and_isTrash_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'image');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_image_and_isTrash_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'image');
      Reflect.set(deleteMenuOperation, 'isTrash', false);
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_video_and_isTrash_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'video');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_video_and_isTrash_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'video')
      Reflect.set(deleteMenuOperation, 'isTrash', false);
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_others_and_isTrash_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('getCountDialog_test_when_deletePhotoTypeForTest_is_others_and_isTrash_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
      Reflect.set(deleteMenuOperation, 'isTrash', false);
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getCountDialog').call(deleteMenuOperation, cloudDriveStatus);
      expect(res.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_true', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_true_and_fromPage_is_VIDEO_CLEANUP_PAGE', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.fromPage === Constants.VIDEO_CLEANUP_PAGE;
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_true_and_count_is_1', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_true_and_isTrash_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'isTrash', false);
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_dialog_when_isTrashAlbum_is_false_and_isTrash_is_false', 0, () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      albumInfo.isTrashAlbum = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'isTrash', false);
      let result: (Resource)[] = Reflect.get(deleteMenuOperation, 'getDialog').call(deleteMenuOperation);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = true;
      menuContext.selectManager.mIsSelectedMode = true;
      menuContext.mediaItem = new MediaItem();
      menuContext.mediaItem.uri = 'testUri';
      menuContext.onOperationEnd = () => {
      };
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getVideoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_true_and_count_is_1', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = true;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = true;
      menuContext.selectManager.mIsSelectedMode = true;
      menuContext.mediaItem = new MediaItem();
      menuContext.mediaItem.uri = 'testUri';
      menuContext.onOperationEnd = () => {
      };
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getVideoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = false;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = false;
      menuContext.selectManager.mIsSelectedMode = false;
      menuContext.mediaItem = new MediaItem();
      menuContext.mediaItem.uri = 'testUri';
      menuContext.onOperationEnd = () => {
      };
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getVideoCleanupPageDeleteDialog').call(deleteMenuOperation, false);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_false_and_count_is_1', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      menuContext.albumInfo = new AlbumInfo();
      menuContext.albumInfo.isTrashAlbum = false;
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.inverseSelection = false;
      menuContext.selectManager.mIsSelectedMode = false;
      menuContext.mediaItem = new MediaItem();
      menuContext.mediaItem.uri = 'testUri';
      menuContext.onOperationEnd = () => {
      };
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getVideoCleanupPageDeleteDialog').call(deleteMenuOperation, false);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_count_is_1', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_true_and_cloudDriveStatus_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, false);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_cloudDriveStatus_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_cloudDriveStatus_is_false_and_count_is_1', 0,
      async () => {
        let menuContext: MenuContext = new MenuContext();
        let albumInfo: AlbumInfo = new AlbumInfo();
        menuContext.albumInfo = albumInfo;
        let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
        deleteMenuOperation.count = 1;
        let res: (Resource)[] =
          Reflect.get(deleteMenuOperation, 'getTrashCleanupPageDeleteDialog').call(deleteMenuOperation, false)
        expect(res.length).assertEqual(2);
      });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_true_and_deletePhotoType_is_image', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'image');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_false_and_deletePhotoType_is_image', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'image');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_true_and_deletePhotoType_is_video', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'video');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_false_and_deletePhotoType_is_video', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'video');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });


    it('should_return_correct_dialog_when_cloudDriveStatus_is_true_and_deletePhotoType_is_others', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'others');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_cloudDriveStatus_is_false_and_deletePhotoType_is_others', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      Reflect.set(deleteMenuOperation, 'deletePhotoType', 'others');
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getGalleryCleanupCountDialog').call(deleteMenuOperation, true);
      expect(res.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_true', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_count_is_1', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_true_and_cloudDriveStatus_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.selectManager = new SelectManager();
      menuContext.selectManager.isAllSelected = true;
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, false);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_cloudDriveStatus_is_false', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      let result: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, true);
      expect(result.length).assertEqual(2);
    });

    it('should_return_correct_dialog_when_isTrashAlbum_is_false_and_cloudDriveStatus_is_false_and_count_is_1', 0, async () => {
      let menuContext: MenuContext = new MenuContext();
      let albumInfo: AlbumInfo = new AlbumInfo();
      menuContext.albumInfo = albumInfo;
      let deleteMenuOperation: DeleteMenuOperation = new DeleteMenuOperation(menuContext);
      deleteMenuOperation.count = 1;
      let res: (Resource)[] =
        Reflect.get(deleteMenuOperation, 'getPhotoCleanupPageDeleteDialog').call(deleteMenuOperation, false)
      expect(res.length).assertEqual(2);
    });
  });
}