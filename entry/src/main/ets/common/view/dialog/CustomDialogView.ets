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
import { Constants } from '../../model/common/Constants'
import { BroadCast } from '../../utils/BroadCast'
import { BroadCastConstants } from '../../model/common/BroadCastConstants'
import { Logger } from '../../utils/Logger'
import { MediaDetails, DetailsDialog } from './DetailsDialog'
import { MultiSelectDetails, MultiSelectDialog } from './MultiSelectDialog'
import { DeleteDialog } from './DeleteDialog'
import { DialogCallback } from '../../model/common/DialogUtil'
import { MediaItem } from '../../model/browser/photo/MediaItem';

import { CancelOperationDialog, CancelParam } from './CancelOperationDialog';
import { RenameDialog } from './RenameDialog';
import { AddNotesDialog } from './AddNotesDialog';
import { ProgressDialog, ProgressParam } from './ProgressDialog';
import { DeleteProgressDialog, DeleteProgressParam } from './DeleteProgressDialog';
import { SaveDialog, SaveDialogCallback } from './SaveDialog'
import { EditExitDialog, EditExitDialogCallback } from './EditExitDialog'
import { NewAlbumDialog } from './NewAlbumDialog'
import { CopyOrMoveDialog, OperateParam } from './CopyOrMoveDialog'
import { FindSameNameDialog, FindSameNameParam } from './FindSameNameDialog'
import { ScreenManager } from '../../model/common/ScreenManager'
import { SaveImageDialog } from './SaveImageDialog'

@Component
export struct CustomDialogView {
    @State isShow: boolean = false;
    @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
    @Provide deleteProgress: number = 0;
    @Provide dialogCallback: DialogCallback = { confirmCallback: null, cancelCallback: null };
    @Provide saveDialogCallback: SaveDialogCallback = { saveAsNewCallback: null, replaceOriginalCallback: null };
    @Provide editExitDialogCallback: EditExitDialogCallback = { discardCallback: null };
    @Consume broadCast: BroadCast;
    @Provide progressParam: ProgressParam = { cancelFunc: null, operationType: '' };
    @Provide deleteProgressParam: DeleteProgressParam = { currentCount: 0, totalCount: 0, message: null };
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
    private logger: Logger = new Logger('CustomDialogView');
    @Provide mediaDetails: MediaDetails = {
        mediaType: 0,
        height: 0,
        width: 0,
        size: 0,
        path: '',
        duration: 0,
        title: '',
        dateTaken: 0,
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
        uri: '',
        displayName: '',
        dateModified: 0
    };
    @Provide multiSelectDetails: MultiSelectDetails = {
        count: 0,
        size: 0,
    };
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
    dialogController: CustomDialogController = new CustomDialogController({
        builder: DetailsDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    multiSelectDialog: CustomDialogController = new CustomDialogController({
        builder: MultiSelectDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    deleteDialogController: CustomDialogController = new CustomDialogController({
        builder: DeleteDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    deleteProgressDialogController: CustomDialogController = new CustomDialogController({
        builder: DeleteProgressDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    progressDialogController: CustomDialogController = new CustomDialogController({
        builder: ProgressDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    cancelDialogController: CustomDialogController = new CustomDialogController({
        builder: CancelOperationDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    renameFileDialogController: CustomDialogController = new CustomDialogController({
        builder: RenameDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    saveDialogController: CustomDialogController = new CustomDialogController({
        builder: SaveDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        customStyle: true
    });
    editExitDialogController: CustomDialogController = new CustomDialogController({
        builder: EditExitDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        customStyle: true
    });
    addNotesDialogController: CustomDialogController = new CustomDialogController({
        builder: AddNotesDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        customStyle: true
    });
    newAlbumDialogController: CustomDialogController = new CustomDialogController({
        builder: NewAlbumDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    copyOrMoveDialogController: CustomDialogController = new CustomDialogController({
        builder: CopyOrMoveDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    findSameNameDialog: CustomDialogController = new CustomDialogController({
        builder: FindSameNameDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    downloadCancelOperationDialog: CustomDialogController = new CustomDialogController({
        builder: DownloadCancelOperationDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        offset: {
            dx: 0,
            dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
        },
        customStyle: true
    });
    saveImageDialogController: CustomDialogController = new CustomDialogController({
        builder: SaveImageDialog(),
        autoCancel: false,
        alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
        customStyle: true
    });

    aboutToDisappear(): void {
        this.logger.info('aboutToDisappear');
    }

    aboutToAppear(): void {
        this.logger.info('aboutToAppear');
        let self = this;
        this.broadCast.on(BroadCastConstants.SHOW_DETAIL_DIALOG,
            function (item: MediaItem, isDistributed: boolean) {
                self.logger.info('SHOW_DETAIL_DIALOG ');
                self.mediaDetails = {
                    mediaType: item.mediaType,
                    height: item.height,
                    width: item.width,
                    size: item.size,
                    path: item.path,
                    duration: item.duration,
                    title: item.title,
                    dateTaken: item.dateTaken,
                    uri: item.uri,
                    displayName: item.displayName,
                    dateModified: item.dateModified
                };
                self.isDistributedAlbum = isDistributed;
                self.dialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_MULTI_SELECT_DIALOG,
            function (count: number, size: number) {
                self.logger.info('SHOW_MULTI_SELECT_DIALOG ');
                self.multiSelectDetails = {
                    size: size,
                    count: count
                };

                self.multiSelectDialog.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG,
            function (deleteMessage: Resource, confirmCallback: Function, cancelCallback?: Function) {
                self.logger.info('SHOW_DELETE_DIALOG ');
                self.dialogMessage = deleteMessage;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.deleteDialogController.open();
            });
        this.broadCast.on(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
            function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
                self.logger.info('SHOW_RENAME_PHOTO_DIALOG ');
                self.renameFileName = fileName;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.renameFileDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
            function (confirmCallback: Function, cancelCallback?: Function) {
                self.logger.info('SHOW_ADD_NOTES_PHOTO_DIALOG ');
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.addNotesDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_PROGRESS_DIALOG,
            function (message: Resource, operationType: string, cancelFunc?: Function) {
                self.logger.info('SHOW_PROGRESS_DIALOG');
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

        this.broadCast.on(BroadCastConstants.UPDATE_PROGRESS,
            function (progress: number, currentCount: number) {
                self.logger.info(`UPDATE_PROGRESS ${progress}`);
                self.deleteProgress = progress;
                self.deleteProgressParam.currentCount = currentCount;
                if (progress == Constants.PROGRESS_MAX) {
                    self.logger.info('Update progress 100%');
                    self.progressDialogController.close();
                    self.deleteProgress = 0;
                    self.deleteProgressDialogController.close();
                    self.deleteProgressParam.currentCount = 0;
                }
            });

        this.broadCast.on(BroadCastConstants.CANCEL_OPERATE,
            function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
                self.cancelMessage = cancelMessage;
                self.cancelParam.continueFunc = continueFunc;
                self.cancelParam.cancelFunc = cancelFunc;
                self.logger.info('CANCEL_OPERATE');
                self.cancelDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.DOWNLOAD_CANCEL_OPERATE,
            function (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) {
                self.cancelMessage = cancelMessage;
                self.cancelParam.continueFunc = continueFunc;
                self.cancelParam.cancelFunc = cancelFunc;
                self.logger.info('DOWNLOAD_CANCEL_OPERATE');
                self.downloadCancelOperationDialog.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
            function (saveAsNewCallback: Function, replaceOriginalCallback: Function) {
                self.logger.info('SHOW_SAVE_PHOTO_DIALOG');
                self.saveDialogCallback
                = { saveAsNewCallback: saveAsNewCallback, replaceOriginalCallback: replaceOriginalCallback };
                self.saveDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG,
            function (discardCallback: Function) {
                self.logger.info('SHOW_EDIT_EXIT_PHOTO_DIALOG');
                self.editExitDialogCallback = { discardCallback: discardCallback };
                self.editExitDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG,
            function () {
                self.logger.info('SHOW_EDIT_SAVE_PROGRESS_DIALOG');
                self.saveImageDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
            function (fileName: string, confirmCallback: Function, cancelCallback?: Function) {
                self.logger.info('SHOW_NEW_ALBUM_PHOTO_DIALOG');
                self.renameFileName = fileName;
                self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
                self.newAlbumDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
            function (moveFunc: Function, copyFunc: Function) {
                self.logger.info('SHOW_COPY_OR_MOVE_DIALOG');
                self.operateParam.moveFunc = moveFunc;
                self.operateParam.copyFunc = copyFunc;
                self.copyOrMoveDialogController.open();
            });

        this.broadCast.on(BroadCastConstants.FIND_SAME_FILE_DIALOG,
            function (assets: any, count: number, replaceFunc: Function, skipFunc: Function,
                      cancelFunc: Function, doSameFunc: Function) {
                self.logger.info('FIND_SAME_FILE_DIALOG');
                self.findSameNameParam.sourceFileAsset = assets.sourceAsset;
                self.findSameNameParam.targetFileAsset = assets.targetAsset;
                self.findSameNameParam.replaceFunc = replaceFunc;
                self.findSameNameParam.skipFunc = skipFunc;
                self.findSameNameParam.cancelFunc = cancelFunc;
                self.findSameNameParam.singlePhoto = (count == 1);
                self.findSameNameParam.doSameFunc = doSameFunc;
                self.findSameNameDialog.open();
            });

        this.broadCast.on(BroadCastConstants.DELETE_PROGRESS_DIALOG,
            function (message: Resource, totalCount: number) {
                self.logger.info('DELETE_PROGRESS_DIALOG');
                self.deleteProgressParam.currentCount = 0;
                self.deleteProgressParam.totalCount = totalCount;
                self.deleteProgressParam.message = message;
                self.deleteProgressDialogController.open();
            });
    }

    build() {
    }
}