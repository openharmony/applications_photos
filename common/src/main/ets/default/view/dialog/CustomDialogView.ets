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
import { tryFunc } from '../../utils/ErrUtil';

const TAG: string = 'common_CustomDialogView';

@Component
export struct CustomDialogView {
  @State isShow: boolean = false;
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide deleteProgress: number = 0;
  @Provide removeProgress: number = 0;
  @Provide dialogCallback: DialogCallback = { confirmCallback: (): void => {}, cancelCallback: () => {} };
  @Provide saveDialogCallback: SaveDialogCallback = { saveAsNewCallback: (): void => {},
    replaceOriginalCallback: () => {} };
  @Provide editExitDialogCallback: EditExitDialogCallback = { discardCallback: (): void => {} };
  @Link broadCast: BroadCast;
  @Provide progressParam: ProgressParam = { cancelFunc: (): void => {}, operationType: '' };
  @Provide deleteProgressParam: DeleteProgressParam = { currentCount: 0, totalCount: 0, message: undefined };
  @Provide removeProgressParam: RemoveProgressParam = { currentCount: 0, totalCount: 0, message: undefined };
  @Provide cancelParam: CancelParam = { continueFunc: (): void => {}, cancelFunc: () => {} };
  @Provide operateParam: OperateParam = { moveFunc: (): void => {}, copyFunc: () => {} };
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
  @StorageLink('isHorizontal') @Watch('refreshDialogs') isHorizontal: boolean = ScreenManager.getInstance()
    .isHorizontal();
  @StorageLink('isSidebar') @Watch('refreshDialogs') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  dialogController?: CustomDialogController | null;
  multiSelectDialog?: CustomDialogController | null;
  deleteDialogController?: CustomDialogController | null;
  thirdDeleteDialogController?: CustomDialogController | null;
  removeDialogController?: CustomDialogController | null;
  deleteProgressDialogController?: CustomDialogController | null;
  removeProgressDialogController?: CustomDialogController | null;
  progressDialogController?: CustomDialogController | null;
  cancelDialogController?: CustomDialogController | null;
  renameFileDialogController?: CustomDialogController | null;
  saveDialogController?: CustomDialogController | null;
  editExitDialogController?: CustomDialogController | null;
  addNotesDialogController?: CustomDialogController | null;
  newAlbumDialogController?: CustomDialogController | null;
  copyOrMoveDialogController?: CustomDialogController | null;
  downloadCancelOperationDialog?: CustomDialogController | null;
  saveImageDialogController?: CustomDialogController | null;

  private showDetailDialogFunc: Function =
    (item: MediaItem, isDistributed: boolean): void => this.showDetailDialog(item,isDistributed);

  private showMultiSelectDialogFunc: Function =
    (count: number, size: number): void => this.showMultiSelectDialog(count, size);

  private showDeleteDialogFunc: Function =
    (deleteMessage: Resource, confirmCallback: Function, cancelCallback: Function, isAlbumDelete: boolean): void =>
    this.showDeleteDialog(deleteMessage, confirmCallback, cancelCallback);

  private showThirdDeleteDialogFunc: Function =
    (deleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function): void =>
    this.showThirdDeleteDialog(deleteMessage, confirmCallback, cancelCallback);

  private showRemoveDialogFunc: Function =
    (removeMessage: Resource, confirmCallback: Function, cancelCallback?: Function): void =>
    this.showRemoveDialog(removeMessage, confirmCallback, cancelCallback);

  private showRenamePhotoDialogFunc:Function =
    (fileName: string, confirmCallback: Function, cancelCallback?: Function): void =>
  this.showRenamePhotoDialog(fileName, confirmCallback, cancelCallback);

  private showAddNotePhotoDialogFunc: Function = (confirmCallback: Function, cancelCallback?: Function): void =>
  this.showAddNotePhotoDialog(confirmCallback, cancelCallback);

  private showProgressDialogFunc: Function = (message: Resource, operationType: string, cancelFunc?: Function): void =>
  this.showProgressDialog(message, operationType,cancelFunc);

  private updateProgressFunc: Function = (progress: number, currentCount: number): void =>
  this.updateProgress(progress, currentCount);

  private cancelOperateFunc: Function = (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void =>
  this.cancelOperate(cancelMessage, continueFunc, cancelFunc);

  private downloadCancelOperateFunc: Function =
    (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void =>
    this.downloadCancelOperate(cancelMessage, continueFunc, cancelFunc);

  private showSavePhotoDialogFunc: Function =
    (saveAsNewCallback: Function, replaceOriginalCallback: Function): void =>
    this.showSavePhotoDialog(saveAsNewCallback, replaceOriginalCallback);

  private showEditExitPhotoDialogFunc: Function = (discardCallback: Function): void =>
  this.showEditExitPhotoDialog(discardCallback);

  private showEditSaveProgressDialogFunc: Function = (): void => this.showEditSaveProgressDialog();

  private showNewAlbumDialogFunc: Function =
    (fileName: string, confirmCallback: Function, cancelCallback?: Function): void =>
    this.showNewAlbumDialog(fileName, confirmCallback, cancelCallback);

  private showCopyOrMoveDialogFunc: Function = (moveFunc: Function, copyFunc: Function): void =>
  this.showCopyOrMoveDialog(moveFunc, copyFunc);

  private deleteProgressDialogFunc: Function = (message: Resource, totalCount: number): void =>
  this.deleteProgressDialog(message, totalCount)

  private removeProgressDialogFunc: Function = (message: Resource, totalCount: number): void =>
  this.removeProgressDialog(message, totalCount);

  refreshDialogs(): void {
    this.buildDialogs(true);
  }

  buildDialogs(refreshFlag: boolean): void {
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
    this.buildDialogs(false);
    this.dialogController = null;
    this.multiSelectDialog = null;
    this.deleteDialogController = null;
    this.thirdDeleteDialogController = null;
    this.removeDialogController = null;
    this.deleteProgressDialogController = null;
    this.removeProgressDialogController = null;
    this.progressDialogController = null;
    this.cancelDialogController = null;
    this.renameFileDialogController = null;
    this.saveDialogController = null;
    this.editExitDialogController = null;
    this.addNotesDialogController = null;
    this.newAlbumDialogController = null;
    this.copyOrMoveDialogController = null;
    this.downloadCancelOperationDialog = null;
    this.saveImageDialogController = null;

    this.broadCast.off(BroadCastConstants.SHOW_DETAIL_DIALOG, this.showDetailDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG, this.showMultiSelectDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_THIRD_DELETE_DIALOG, this.showThirdDeleteDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_REMOVE_DIALOG, this.showRemoveDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG, this.showRenamePhotoDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG, this.showAddNotePhotoDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_PROGRESS_DIALOG, this.showProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.UPDATE_PROGRESS, this.updateProgressFunc);
    this.broadCast.off(BroadCastConstants.CANCEL_OPERATE, this.cancelOperateFunc);
    this.broadCast.off(BroadCastConstants.DOWNLOAD_CANCEL_OPERATE, this.downloadCancelOperateFunc);
    this.broadCast.off(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG, this.showSavePhotoDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG, this.showNewAlbumDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, this.showCopyOrMoveDialogFunc);
    this.broadCast.off(BroadCastConstants.DELETE_PROGRESS_DIALOG, this.deleteProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.REMOVE_PROGRESS_DIALOG, this.removeProgressDialogFunc);
  }

  private showDetailDialog(item: MediaItem, isDistributed: boolean): void {
    Log.info(TAG, item.uri, ' SHOW_DETAIL_DIALOG ');
    let title: string = item.getTitle ? tryFunc(((): string => item.getTitle())) : undefined;
    let dateTaken: number = item.getDataTaken ? tryFunc(((): number => item.getDataTaken())) : undefined;
    let dateModified: number = item.getDateModified ? tryFunc(((): number => item.getDateModified())) : undefined;
    this.mediaDetails = {
      mediaType: item.mediaType,
      height: item.height,
      width: item.width,
      size: item.size,
      duration: item.duration,
      title,
      dateTaken,
      uri: item.uri,
      displayName: item.displayName,
      dateModified
    };
    this.isDistributedAlbum = isDistributed;
    (this.dialogController as CustomDialogController).open();
  }

  private showMultiSelectDialog(count: number, size: number): void {
    Log.info(TAG, 'SHOW_MULTI_SELECT_DIALOG ');
    this.multiSelectDetails = {
      size: size,
      count: count
    };
    (this.multiSelectDialog as CustomDialogController).open();
  }

  private showDeleteDialog(deleteMessage: Resource, confirmCallback: Function, cancelCallback: Function): void {
    Log.info(TAG, 'SHOW_DELETE_DIALOG ');
    this.dialogMessage = deleteMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.deleteDialogController as CustomDialogController).open();
  }

  private showThirdDeleteDialog(deleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_THIRD_DELETE_DIALOG ');
    this.dialogMessage = deleteMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.thirdDeleteDialogController as CustomDialogController).open();
  }

  private showRemoveDialog(removeMessage: Resource, confirmCallback: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_REMOVE_DIALOG ');
    this.dialogMessage = removeMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.removeDialogController as CustomDialogController).open();
  }

  private showRenamePhotoDialog(fileName: string, confirmCallback: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
    this.renameFileName = fileName;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.renameFileDialogController as CustomDialogController).open();
  }

  private showAddNotePhotoDialog(confirmCallback: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_ADD_NOTES_PHOTO_DIALOG ');
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.addNotesDialogController as CustomDialogController).open();
  }

  private showProgressDialog(message: Resource, operationType: string, cancelFunc?: Function): void {
    Log.info(TAG, 'SHOW_PROGRESS_DIALOG');
    if (message != null) {
      this.progressMessage = message;
    }
    if (operationType) {
      this.progressParam.operationType = operationType;
    }

    if (cancelFunc) {
      this.progressParam.cancelFunc = cancelFunc;
    }
    this.deleteProgress = 0;
    this.removeProgress = 0;
    (this.progressDialogController as CustomDialogController).open();
  }

  private updateProgress(progress: number, currentCount: number): void {
    Log.info(TAG, `UPDATE_PROGRESS ${progress}`);
    this.deleteProgress = progress;
    this.removeProgress = progress;
    this.deleteProgressParam.currentCount = currentCount;
    this.removeProgressParam.currentCount = currentCount;
    if (progress == 100) {
      Log.info(TAG, 'Update progress 100%');
      (this.progressDialogController as CustomDialogController).close();
      (this.deleteProgressDialogController as CustomDialogController).close();
      this.deleteProgressParam.currentCount = 0;
      (this.removeProgressDialogController as CustomDialogController).close();
      this.removeProgressParam.currentCount = 0;
    }
  }

  private cancelOperate(cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void {
    this.cancelMessage = cancelMessage;
    this.cancelParam.continueFunc = continueFunc;
    this.cancelParam.cancelFunc = cancelFunc;
    Log.info(TAG, 'CANCEL_OPERATE');
    (this.cancelDialogController as CustomDialogController).open();
  }

  private downloadCancelOperate(cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void {
    this.cancelMessage = cancelMessage;
    this.cancelParam.continueFunc = continueFunc;
    this.cancelParam.cancelFunc = cancelFunc;
    Log.info(TAG, 'DOWNLOAD_CANCEL_OPERATE');
    (this.downloadCancelOperationDialog as CustomDialogController).open();
  }

  private showSavePhotoDialog(saveAsNewCallback: Function, replaceOriginalCallback: Function): void {
    Log.info(TAG, 'SHOW_SAVE_PHOTO_DIALOG');
    this.saveDialogCallback = {
      saveAsNewCallback: saveAsNewCallback,
      replaceOriginalCallback: replaceOriginalCallback };
    (this.saveDialogController as CustomDialogController).open();
  }

  private showEditExitPhotoDialog(discardCallback: Function): void {
    Log.info(TAG, 'SHOW_EDIT_EXIT_PHOTO_DIALOG');
    this.editExitDialogCallback = { discardCallback: discardCallback };
    (this.editExitDialogController as CustomDialogController).open();
  }

  private showEditSaveProgressDialog(): void {
    Log.info(TAG, 'SHOW_EDIT_SAVE_PROGRESS_DIALOG');
    (this.saveImageDialogController as CustomDialogController).open();
  }

  private showNewAlbumDialog(fileName: string, confirmCallback: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
    this.renameFileName = fileName;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
    (this.newAlbumDialogController as CustomDialogController).open();
  }

  private showCopyOrMoveDialog(moveFunc: Function, copyFunc: Function): void {
    Log.info(TAG, 'SHOW_COPY_OR_MOVE_DIALOG');
    this.operateParam.moveFunc = moveFunc;
    this.operateParam.copyFunc = copyFunc;
    (this.copyOrMoveDialogController as CustomDialogController).open();
  }

  private deleteProgressDialog(message: Resource, totalCount: number): void {
    Log.info(TAG, 'DELETE_PROGRESS_DIALOG');
    this.deleteProgressParam.currentCount = 0;
    this.deleteProgressParam.totalCount = totalCount;
    this.deleteProgressParam.message = message;
    (this.deleteProgressDialogController as CustomDialogController).open();
  }

  private removeProgressDialog(message: Resource, totalCount: number): void {
    Log.info(TAG, 'REMOVE_PROGRESS_DIALOG');
    this.removeProgressParam.currentCount = 0;
    this.removeProgressParam.totalCount = totalCount;
    this.removeProgressParam.message = message;
    (this.removeProgressDialogController as CustomDialogController).open();
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.buildDialogs(false);
    this.broadCast.on(BroadCastConstants.SHOW_DETAIL_DIALOG, this.showDetailDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG,this.showMultiSelectDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_THIRD_DELETE_DIALOG, this.showThirdDeleteDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_REMOVE_DIALOG, this.showRemoveDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG, this.showRenamePhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG, this.showAddNotePhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_PROGRESS_DIALOG, this.showProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_PROGRESS, this.updateProgressFunc);
    this.broadCast.on(BroadCastConstants.CANCEL_OPERATE, this.cancelOperateFunc);
    this.broadCast.on(BroadCastConstants.DOWNLOAD_CANCEL_OPERATE, this.downloadCancelOperateFunc);
    this.broadCast.on(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG, this.showSavePhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, this.showEditExitPhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, this.showEditSaveProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG, this.showNewAlbumDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, this.showCopyOrMoveDialogFunc);
    this.broadCast.on(BroadCastConstants.DELETE_PROGRESS_DIALOG, this.deleteProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.REMOVE_PROGRESS_DIALOG, this.removeProgressDialogFunc);
  }

  build() {
  }
}