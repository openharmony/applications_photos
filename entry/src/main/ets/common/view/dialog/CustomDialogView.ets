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
import { Constants } from '../../model/common/Constants';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { BroadcastConstants } from '@ohos/base/src/main/ets/constants/BroadcastConstants';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { MediaDetails, DetailsDialog } from './DetailsDialog';
import { MultiSelectDetails, MultiSelectDialog } from './MultiSelectDialog';
import { DeleteDialog } from './DeleteDialog';
import type { DialogCallback } from '../../model/common/DialogUtil';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { CancelOperationDialog, CancelParam } from './CancelOperationDialog';
import { RenameDialog } from './RenameDialog';
import { AddNotesDialog } from './AddNotesDialog';
import { ProgressDialog, ProgressParam } from './ProgressDialog';
import { DeleteProgressDialog, DeleteProgressParam } from './DeleteProgressDialog';
import { SaveDialog, SaveDialogCallback } from './SaveDialog';
import { EditExitDialog, EditExitDialogCallback } from './EditExitDialog';
import { NewAlbumDialog } from './NewAlbumDialog';
import { CopyOrMoveDialog, OperateParam } from './CopyOrMoveDialog';
import { FindSameNameDialog, FindSameNameParam } from './FindSameNameDialog';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { SaveImageDialog } from './SaveImageDialog';

const TAG: string = 'CustomDialogView'

@Component
export struct CustomDialogView {
    @State isShow: boolean = false;
    @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide dialogDeleteMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide dialogCallback: DialogCallback = { confirmCallback: null, cancelCallback: null };
    @Provide saveDialogCallback: SaveDialogCallback = { saveAsNewCallback: null, replaceOriginalCallback: null };
    @Provide editExitDialogCallback: EditExitDialogCallback = { discardCallback: null };
    @Consume broadCast: Broadcast;
    @Provide progressParam: ProgressParam = { cancelFunc: null, operationType: '' };
    @Provide deleteProgress: number = 0;
    @Provide deleteProgressParam: DeleteProgressParam = { currentCount: 0, totalCount: 0, message: null, deleteProgress: 0};
    @Provide cancelParam: CancelParam = { continueFunc: null, cancelFunc: null };
    @Provide operateParam: OperateParam = { moveFunc: null, copyFunc: null };
    @Provide findSameNameParam: FindSameNameParam = {
        sourceFileAsset: null,
        targetFileAsset: null,
        replaceFunc: null,
        skipFunc: null,
        cancelFunc: null,
        singlePhoto: null,
        doSameFunc: null
    };
    @Provide cancelMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide renameFileName: string = '';
    @Provide isDistributedAlbum: boolean = false;
    @Provide mediaDetails: MediaDetails = {
        mediaType: 0,
        height: 0,
        width: 0,
        size: 0,
        path: '',
        duration: 0,
        title: '',
        dateTaken: 0,
        dateAdded: 0,
        uri: '',
        displayName: '',
        dateModified: 0
    };
    @Provide targetMediaDetails: MediaDetails = {
        mediaType: 0,
        height: 0,
        width: 0,
        size: 0,
        path: '',
        duration: 0,
        title: '',
        dateTaken: 0,
        dateAdded: 0,
        uri: '',
        displayName: '',
        dateModified: 0
    };
    @Provide multiSelectDetails: MultiSelectDetails = {
        count: 0,
        size: 0,
    };
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
    dialogController: CustomDialogController;
    multiSelectDialog: CustomDialogController;
    deleteDialogController: CustomDialogController;
    deleteProgressDialogController: CustomDialogController;
    progressDialogController: CustomDialogController;
    cancelDialogController: CustomDialogController;
    renameFileDialogController: CustomDialogController;
    saveDialogController: CustomDialogController;
    editExitDialogController: CustomDialogController;
    addNotesDialogController: CustomDialogController;
    newAlbumDialogController: CustomDialogController;
    copyOrMoveDialogController: CustomDialogController;
    findSameNameDialog: CustomDialogController;
    downloadCancelOperationDialog: CustomDialogController;
    saveImageDialogController: CustomDialogController;
    
    aboutToDisappear(): void {
        Log.info(TAG, 'aboutToDisappear');
        delete this.dialogController;
        this.dialogController = undefined;
        delete this.multiSelectDialog;
        this.multiSelectDialog = undefined;
        delete this.deleteDialogController;
        this.deleteDialogController = undefined;
        delete this.deleteProgressDialogController;
        this.deleteProgressDialogController = undefined;
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
        delete this.findSameNameDialog;
        this.findSameNameDialog = undefined;
        delete this.downloadCancelOperationDialog;
        this.downloadCancelOperationDialog = undefined;
        delete this.saveImageDialogController;
        this.saveImageDialogController = undefined;
    }

    aboutToAppear(): void {
        Log.info(TAG, 'aboutToAppear');
        let self = this;
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
        this.findSameNameDialog = new CustomDialogController({
            builder: FindSameNameDialog(),
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
        
        this.broadCast.on(BroadcastConstants.SHOW_DETAIL_DIALOG, (item: MediaDataItem, isDistributed: boolean) => {
            this.showDetailDialog(item, isDistributed)
        });

        this.broadCast.on(BroadcastConstants.SHOW_MULTI_SELECT_DIALOG,
            function (count: number, size: number) {
                Log.info(TAG, 'SHOW_MULTI_SELECT_DIALOG ');
                self.multiSelectDetails = {
                    size: size,
                    count: count
                };

                self.multiSelectDialog.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_DELETE_DIALOG,
            function (deleteMessage: Resource, dialogDeleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function) {
               Log.info(TAG, 'SHOW_DELETE_DIALOG ');
                self.dialogMessage = deleteMessage;
                self.dialogDeleteMessage = dialogDeleteMessage;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.deleteDialogController.open();
            });
        this.broadCast.on(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
            function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
               Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
                self.renameFileName = fileName;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.renameFileDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
            function (confirmCallback: Function, cancelCallback?: Function) {
               Log.info(TAG, 'SHOW_ADD_NOTES_PHOTO_DIALOG ');
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.addNotesDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_PROGRESS_DIALOG,
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

                self.progressDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.UPDATE_PROGRESS,
            function (progress: number, currentCount: number) {
               Log.info(TAG, `UPDATE_PROGRESS ${progress}, ${currentCount}`);
                self.deleteProgress = progress;
                self.deleteProgressParam.deleteProgress = progress;
                self.deleteProgressParam.currentCount = currentCount;
                if (progress == Constants.PROGRESS_MAX) {
                   Log.info(TAG, 'Update progress 100%');
                    self.progressDialogController.close();
                    self.deleteProgress = 0;
                    self.deleteProgressParam.deleteProgress = 0;
                    self.deleteProgressDialogController.close();
                    self.deleteProgressParam.currentCount = 0;
                }
            });

        this.broadCast.on(BroadcastConstants.CANCEL_OPERATE,
            function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
                self.cancelMessage = cancelMessage;
                self.cancelParam.continueFunc = continueFunc;
                self.cancelParam.cancelFunc = cancelFunc;
               Log.info(TAG, 'CANCEL_OPERATE');
                self.cancelDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.DOWNLOAD_CANCEL_OPERATE,
            function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
                self.cancelMessage = cancelMessage;
                self.cancelParam.continueFunc = continueFunc;
                self.cancelParam.cancelFunc = cancelFunc;
               Log.info(TAG, 'DOWNLOAD_CANCEL_OPERATE');
                self.downloadCancelOperationDialog.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_SAVE_PHOTO_DIALOG,
            function (saveAsNewCallback: Function, replaceOriginalCallback: Function) {
               Log.info(TAG, 'SHOW_SAVE_PHOTO_DIALOG');
                self.saveDialogCallback
                = { saveAsNewCallback: saveAsNewCallback, replaceOriginalCallback: replaceOriginalCallback };
                self.saveDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG,
            function (discardCallback: Function) {
               Log.info(TAG, 'SHOW_EDIT_EXIT_PHOTO_DIALOG');
                self.editExitDialogCallback = { discardCallback: discardCallback };
                self.editExitDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG,
            function () {
               Log.info(TAG, 'SHOW_EDIT_SAVE_PROGRESS_DIALOG');
                self.saveImageDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
            function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
               Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
                self.renameFileName = fileName;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.newAlbumDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.SHOW_COPY_OR_MOVE_DIALOG,
            function (moveFunc: Function, copyFunc: Function) {
               Log.info(TAG, 'SHOW_COPY_OR_MOVE_DIALOG');
                self.operateParam.moveFunc = moveFunc;
                self.operateParam.copyFunc = copyFunc;
                self.copyOrMoveDialogController.open();
            });

        this.broadCast.on(BroadcastConstants.FIND_SAME_FILE_DIALOG,
            function (assets: any, count: number, replaceFunc: Function, skipFunc: Function,
                      cancelFunc: Function, doSameFunc: Function) {
               Log.info(TAG, 'FIND_SAME_FILE_DIALOG');
                self.findSameNameParam.sourceFileAsset = assets.sourceAsset;
                self.findSameNameParam.targetFileAsset = assets.targetAsset;
                self.findSameNameParam.replaceFunc = replaceFunc;
                self.findSameNameParam.skipFunc = skipFunc;
                self.findSameNameParam.cancelFunc = cancelFunc;
                self.findSameNameParam.singlePhoto = (count == 1);
                self.findSameNameParam.doSameFunc = doSameFunc;
                self.findSameNameDialog.open();
            });

        this.broadCast.on(BroadcastConstants.DELETE_PROGRESS_DIALOG,
            function (message: Resource, totalCount: number) {
               Log.info(TAG, 'DELETE_PROGRESS_DIALOG');
                self.deleteProgressParam.currentCount = 0;
                self.deleteProgressParam.totalCount = totalCount;
                self.deleteProgressParam.message = message;
                self.deleteProgress = 0;
                self.deleteProgressParam.deleteProgress = 0;
                self.deleteProgressDialogController.open();
            });
    }

    private showDetailDialog(item: MediaDataItem, isDistributed: boolean) {
        Log.info(TAG, 'SHOW_DETAIL_DIALOG ');
        item.load(true).then(() => {
            this.mediaDetails = {
                mediaType: item.mediaType,
                height: item.height,
                width: item.width,
                size: item.size,
                path: item.path,
                duration: item.duration,
                title: item.title,
                dateTaken: item.dateTaken,
                dateAdded: item.dateAdded,
                uri: item.uri,
                displayName: item.displayName,
                dateModified: item.dateModified
            };
            this.isDistributedAlbum = isDistributed;
            this.dialogController.open();
        })
    }

    build() {
    }
}