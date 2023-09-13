/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { DownloadCancelOperationDialog } from './DownloadCancelOperationDialog';
import { BroadCast } from '../../utils/BroadCast';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { Log } from '../../utils/Log';
import { DetailsDialog, MediaDetails } from './DetailsDialog';
import { MultiSelectDetails, MultiSelectDialog } from './MultiSelectDialog';
import { DeleteDialog } from './DeleteDialog';
import { ThirdDeleteDialog } from './ThirdDeleteDialog';
import { RemoveDialog } from './RemoveDialog';
import { DialogCallback } from '../../model/common/DialogUtil';
import { MediaItem } from '../../model/browser/photo/MediaItem';

import { CancelOperationDialog, CancelParam } from './CancelOperationDialog';
import { RenameDialog } from './RenameDialog';
import { AddNotesDialog } from './AddNotesDialog';
import { ProgressDialog, ProgressParam } from './ProgressDialog';
import { DeleteProgressDialog, DeleteProgressParam } from './DeleteProgressDialog';
import { RemoveProgressDialog, RemoveProgressParam } from './RemoveProgressDialog';
import { SaveDialog, SaveDialogCallback } from './SaveDialog';
import { EditExitDialog, EditExitDialogCallback } from './EditExitDialog';
import { NewAlbumDialog } from './NewAlbumDialog';
import { CopyOrMoveDialog, OperateParam } from './CopyOrMoveDialog';
import { ScreenManager } from '../../model/common/ScreenManager';
import { SaveImageDialog } from './SaveImageDialog';

const TAG: string = 'common_CustomDialogView';

@Component
export struct CustomDialogView {
  @State isShow: boolean = false;
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide deleteProgress: number = 0;
  @Provide removeProgress: number = 0;
  @Provide dialogCallback: DialogCallback = { confirmCallback: null, cancelCallback: null };
  @Provide saveDialogCallback: SaveDialogCallback = { saveAsNewCallback: null, replaceOriginalCallback: null };
  @Provide editExitDialogCallback: EditExitDialogCallback = { discardCallback: null };
  @Link broadCast: BroadCast;
  @Provide progressParam: ProgressParam = { cancelFunc: null, operationType: '' };
  @Provide deleteProgressParam: DeleteProgressParam = { currentCount: 0, totalCount: 0, message: null };
  @Provide removeProgressParam: RemoveProgressParam = { currentCount: 0, totalCount: 0, message: null };
  @Provide cancelParam: CancelParam = { continueFunc: null, cancelFunc: null };
  @Provide operateParam: OperateParam = { moveFunc: null, copyFunc: null };
  @Provide cancelMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide renameFileName: string = '';
  @Provide isDistributedAlbum: boolean = false;
  @Provide mediaDetails: MediaDetails = {
    mediaType: 0,
    height: 256,
    width: 256,
    size: 256,
    duration: 1028,
    title: 'title',
    dateTaken: 10280000,
    uri: '',
    displayName: '',
    dateModified: 0
  };
  @Provide targetMediaDetails: MediaDetails = {
    mediaType: 0,
    height: 256,
    width: 256,
    size: 256,
    duration: 1028,
    title: 'title',
    dateTaken: 10280000,
    uri: '',
    displayName: '',
    dateModified: 0
  };
  @Provide multiSelectDetails: MultiSelectDetails = {
    count: 500,
    size: 256,
  };
  @StorageLink('isHorizontal') @Watch('buildDialogs') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @StorageLink('isSidebar') @Watch('buildDialogs') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  dialogController: CustomDialogController;
  multiSelectDialog: CustomDialogController;
  deleteDialogController: CustomDialogController;
  thirdDeleteDialogController: CustomDialogController;
  removeDialogController: CustomDialogController;
  deleteProgressDialogController: CustomDialogController;
  removeProgressDialogController: CustomDialogController;
  progressDialogController: CustomDialogController;
  cancelDialogController: CustomDialogController;
  renameFileDialogController: CustomDialogController;
  saveDialogController: CustomDialogController;
  editExitDialogController: CustomDialogController;
  addNotesDialogController: CustomDialogController;
  newAlbumDialogController: CustomDialogController;
  copyOrMoveDialogController: CustomDialogController;
  downloadCancelOperationDialog: CustomDialogController;
  saveImageDialogController: CustomDialogController;

  buildDialogs(): void {
    this.dialogController = new CustomDialogController({
      builder: DetailsDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.multiSelectDialog = new CustomDialogController({
      builder: MultiSelectDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.thirdDeleteDialogController = new CustomDialogController({
      builder: ThirdDeleteDialog(),
      autoCancel: false,
      alignment: this.isHorizontal ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.removeDialogController = new CustomDialogController({
      builder: RemoveDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.deleteProgressDialogController = new CustomDialogController({
      builder: DeleteProgressDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.removeProgressDialogController = new CustomDialogController({
      builder: RemoveProgressDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.progressDialogController = new CustomDialogController({
      builder: ProgressDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.cancelDialogController = new CustomDialogController({
      builder: CancelOperationDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.renameFileDialogController = new CustomDialogController({
      builder: RenameDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.saveDialogController = new CustomDialogController({
      builder: SaveDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });

    this.editExitDialogController = new CustomDialogController({
      builder: EditExitDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });

    this.addNotesDialogController = new CustomDialogController({
      builder: AddNotesDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });

    this.newAlbumDialogController = new CustomDialogController({
      builder: NewAlbumDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.copyOrMoveDialogController = new CustomDialogController({
      builder: CopyOrMoveDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.downloadCancelOperationDialog = new CustomDialogController({
      builder: DownloadCancelOperationDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });

    this.saveImageDialogController = new CustomDialogController({
      builder: SaveImageDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.broadCast.off(null, null);
    delete this.dialogController;
    this.dialogController = undefined;
    delete this.multiSelectDialog;
    this.multiSelectDialog = undefined;
    delete this.deleteDialogController;
    this.deleteDialogController = undefined;
    delete this.thirdDeleteDialogController;
    this.thirdDeleteDialogController = undefined;
    delete this.removeDialogController;
    this.removeDialogController = undefined;
    delete this.deleteProgressDialogController;
    this.deleteProgressDialogController = undefined;
    delete this.removeProgressDialogController;
    this.removeProgressDialogController = undefined;
    delete this.progressDialogController;
    this.progressDialogController = undefined;
    delete this.cancelDialogController;
    this.cancelDialogController = undefined;
    delete this.renameFileDialogController;
    this.renameFileDialogController = undefined;
    delete this.saveDialogController;
    this.saveDialogController = undefined;
    delete this.editExitDialogController;
    this.editExitDialogController = undefined;
    delete this.addNotesDialogController;
    this.addNotesDialogController = undefined;
    delete this.newAlbumDialogController;
    this.newAlbumDialogController = undefined;
    delete this.copyOrMoveDialogController;
    this.copyOrMoveDialogController = undefined;
    delete this.downloadCancelOperationDialog;
    this.downloadCancelOperationDialog = undefined;
    delete this.saveImageDialogController;
    this.saveImageDialogController = undefined;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    let self = this;
    this.buildDialogs();
    this.broadCast.on(BroadCastConstants.SHOW_DETAIL_DIALOG,
      function (item: MediaItem, isDistributed: boolean) {
        Log.info(TAG, 'SHOW_DETAIL_DIALOG ');
        self.mediaDetails = {
          mediaType: item.mediaType,
          height: item.height,
          width: item.width,
          size: item.size,
          duration: item.duration,
          title: item.getTitle(),
          dateTaken: item.getDataTaken(),
          uri: item.uri,
          displayName: item.displayName,
          dateModified: item.getDateModified()
        };
        self.isDistributedAlbum = isDistributed;
        self.dialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG,
      function (count: number, size: number) {
        Log.info(TAG, 'SHOW_MULTI_SELECT_DIALOG ');
        self.multiSelectDetails = {
          size: size,
          count: count
        };

        self.multiSelectDialog.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG,
      function (deleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_DELETE_DIALOG ');
        self.dialogMessage = deleteMessage;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.deleteDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_THIRD_DELETE_DIALOG,
      function (deleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_THIRD_DELETE_DIALOG ');
        self.dialogMessage = deleteMessage;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.thirdDeleteDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_REMOVE_DIALOG,
      function (removeMessage: Resource, confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_REMOVE_DIALOG ');
        self.dialogMessage = removeMessage;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.removeDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
      function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
        self.renameFileName = fileName;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.renameFileDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
      function (confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_ADD_NOTES_PHOTO_DIALOG ');
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.addNotesDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      function (message: Resource, operationType: string, cancelFunc?: Function) {
        Log.info(TAG, 'SHOW_PROGRESS_DIALOG');
        if (message != null) {
          self.progressMessage = message;
        }

        if (operationType) {
          self.progressParam.operationType = operationType;
        }

        if (cancelFunc) {
          self.progressParam.cancelFunc = cancelFunc;
        }
        self.deleteProgress = 0;
        self.removeProgress = 0;
        self.progressDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.UPDATE_PROGRESS,
      function (progress: number, currentCount: number) {
        Log.info(TAG, `UPDATE_PROGRESS ${progress}`);
        self.deleteProgress = progress;
        self.removeProgress = progress;
        self.deleteProgressParam.currentCount = currentCount;
        self.removeProgressParam.currentCount = currentCount;
        if (progress == 100) {
          Log.info(TAG, 'Update progress 100%');
          self.progressDialogController.close();
          self.deleteProgressDialogController.close();
          self.deleteProgressParam.currentCount = 0;
          self.removeProgressDialogController.close();
          self.removeProgressParam.currentCount = 0;
        }
      });

    this.broadCast.on(BroadCastConstants.CANCEL_OPERATE,
      function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
        self.cancelMessage = cancelMessage;
        self.cancelParam.continueFunc = continueFunc;
        self.cancelParam.cancelFunc = cancelFunc;
        Log.info(TAG, 'CANCEL_OPERATE');
        self.cancelDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.DOWNLOAD_CANCEL_OPERATE,
      function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
        self.cancelMessage = cancelMessage;
        self.cancelParam.continueFunc = continueFunc;
        self.cancelParam.cancelFunc = cancelFunc;
        Log.info(TAG, 'DOWNLOAD_CANCEL_OPERATE');
        self.downloadCancelOperationDialog.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
      function (saveAsNewCallback: Function, replaceOriginalCallback: Function) {
        Log.info(TAG, 'SHOW_SAVE_PHOTO_DIALOG');
        self.saveDialogCallback
        = { saveAsNewCallback: saveAsNewCallback, replaceOriginalCallback: replaceOriginalCallback };
        self.saveDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG,
      function (discardCallback: Function) {
        Log.info(TAG, 'SHOW_EDIT_EXIT_PHOTO_DIALOG');
        self.editExitDialogCallback = { discardCallback: discardCallback };
        self.editExitDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG,
      function () {
        Log.info(TAG, 'SHOW_EDIT_SAVE_PROGRESS_DIALOG');
        self.saveImageDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
      function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
        Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
        self.renameFileName = fileName;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.newAlbumDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
      function (moveFunc: Function, copyFunc: Function) {
        Log.info(TAG, 'SHOW_COPY_OR_MOVE_DIALOG');
        self.operateParam.moveFunc = moveFunc;
        self.operateParam.copyFunc = copyFunc;
        self.copyOrMoveDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.DELETE_PROGRESS_DIALOG,
      function (message: Resource, totalCount: number) {
        Log.info(TAG, 'DELETE_PROGRESS_DIALOG');
        self.deleteProgressParam.currentCount = 0;
        self.deleteProgressParam.totalCount = totalCount;
        self.deleteProgressParam.message = message;
        self.deleteProgressDialogController.open();
      });

    this.broadCast.on(BroadCastConstants.REMOVE_PROGRESS_DIALOG,
      function (message: Resource, totalCount: number) {
        Log.info(TAG, 'DELETE_PROGRESS_DIALOG');
        self.removeProgressParam.currentCount = 0;
        self.removeProgressParam.totalCount = totalCount;
        self.removeProgressParam.message = message;
        self.removeProgressDialogController.open();
      });
  }

  build() {
  }
}