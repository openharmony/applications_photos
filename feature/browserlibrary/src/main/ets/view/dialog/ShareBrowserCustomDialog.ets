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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy {
  CancelOperationDialog,
  CancelParam
} from '@ohos/common/src/main/ets/default/view/dialog/CancelOperationDialog';
import lazy { CopyOrMoveDialog, OperateParam } from '@ohos/common/src/main/ets/default/view/dialog/CopyOrMoveDialog';
import lazy { DeleteDialog } from '@ohos/common/src/main/ets/default/view/dialog/DeleteDialog';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { DialogCallback, MoveDialogCallback } from '@ohos/common/src/main/ets/default/model/common/DialogUtil';
import lazy { DownloadProgressDialog } from '@ohos/common/src/main/ets/default/view/dialog/DownloadProgressDialog';
import lazy { CustomBuilderParam, ProgressDialog, ProgressParam } from '@ohos/common/src/main/ets/default/view/dialog/ProgressDialog';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { NewAlbumDialog } from '@ohos/common/src/main/ets/default/view/dialog/NewAlbumDialog';
import lazy { RenameDialog } from '@ohos/common/src/main/ets/default/view/dialog/RenameDialog';
import lazy { SaveImageDialog } from '@ohos/common/src/main/ets/default/view/dialog/SaveImageDialog';
import lazy { PromptNewAlbumDialog } from '@ohos/common/src/main/ets/default/view/dialog/PromptNewAlbumDialog';
import lazy { BasePhotoBrowserController } from '../../model/BasePhotoBrowserController';
import lazy { PositionParams } from '@ohos/common/src/main/ets/default/view/browserOperation/DeleteMenuOperation';
import lazy display from '@ohos.display';
import lazy { SubScreenDeleteDialog } from '@ohos/common/src/main/ets/default/view/dialog/SubScreenDeleteDialog';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { MoveDialog } from '@ohos/common/src/main/ets/default/view/dialog/MoveDialog';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants'
import lazy { RemoveDialog } from '@ohos/common/src/main/ets/default/view/dialog/RemoveDialog';

export type PhotoAsset = photoAccessHelper.PhotoAsset;

const TAG: string = 'ShareBrowserCustomDialog';
// 非三键导航上移16vp
const DIALOG_POSITION: number = -16;
// 三键导航上移18vp
const DIALOG_POSITION_MORE: number = -18;

/**
 * 弹出式对话框 Toast整体归一
 * 提供给大图组件各个细分场景使用
 */
@Component
export struct ShareBrowserCustomDialog {
  @Consume browserController: BasePhotoBrowserController;
  @State isShow: boolean = false;
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide dialogContent: Resource = $r('app.string.common_place_holder', String(''));
  @Provide isAlbumDelete: boolean = false;
  @Provide isPhotoHide: boolean = false;
  private isClearRecycle: boolean | undefined = false;
  private isHoldPosition: boolean | undefined = false;
  @Provide repeatPhotos: PhotoAsset[] = [];
  @Provide moveDialogCallback: MoveDialogCallback = {
    replaceCallback: (): void => {
    }, skipCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  @Provide progressParam: ProgressParam = {
    progress: 0,
    message: undefined,
    cancelFunc: (): void => {
    }
  };
  @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide deleteProgress: number = 0;
  @Provide hiddenProgress: number = 0;
  @Provide removeProgress: number = 0;
  @Provide dialogCallback: DialogCallback = {
    confirmCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  @Consume dialogBroadCast: BroadCast;
  @Provide cancelParam: CancelParam = {
    continueFunc: (): void => {
    }, cancelFunc: (): void => {
    }
  };
  @Provide operateParam: OperateParam = {
    copyFunc: (): void => {
    }
  };
  private cancelMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide renameFileName: string = '';
  @Provide isDistributedAlbum: boolean = false;
  @Provide downloadUri: string = '';
  @StorageLink('isHorizontal') @Watch('refreshDialogs') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isSidebar') @Watch('refreshDialogs') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('getFoldStatus') @Watch('refreshDialogs') isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @Provide inputText: string = '';
  @Provide isCloseTip: boolean = false;
  public deleteDialogController: CustomDialogController | undefined;
  public removeDialogController: CustomDialogController | undefined;
  public moveDialogController?: CustomDialogController | undefined;
  public progressDialogController?: CustomDialogController | undefined;
  public progressDialogOpenFlag: boolean = false;
  public progressDialogDelayOpenFlag: boolean = false;
  public progressDialogTimeoutHdl: number = 0;
  public subScreenDeleteDialogController?: CustomDialogController | undefined;
  private portraitNameDialogController?: CustomDialogController | undefined;
  private portraitName: string = '';
  private portraitUri: string = '';
  public deleteDialogOpenFlag: boolean = false;
  public hideDialogController: CustomDialogController | undefined = undefined;
  public hideDialogOpenFlag: boolean = false;
  public cancelDialogController: CustomDialogController | undefined = undefined;
  public renameFileDialogController: CustomDialogController | undefined = undefined;
  public renameFileDialogControllerFlag: boolean = false;
  public editExitDialogController: CustomDialogController | undefined = undefined;
  public petalClipNotInstallDialogController: CustomDialogController | undefined = undefined;
  public addNotesDialogController: CustomDialogController | undefined = undefined;
  public newAlbumDialogController: CustomDialogController | undefined = undefined;
  public copyOrMoveDialogController: CustomDialogController | undefined = undefined;
  public saveImageDialogController: CustomDialogController | undefined = undefined;
  public downloadProgressDialogController: CustomDialogController | undefined = undefined;
  public promptDialogOpenFlag: boolean = false;
  public promptNewAlbumsDialogController?: CustomDialogController | null;
  public deleteDialogIndex: number = 2;
  private isFromSubScreen: boolean = false;
  @Prop private mediaType: number = 0;
  @LocalStorageLink('isDeleteDialogOpen') isDeleteDialogOpen: boolean = false;
  @State windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  @State private navigationPageInfos: NavPathStack | undefined = undefined;
  @StorageLink('isHalfFold') @Watch('foldStatusChange') isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  @State private deleteDialogPositionY: Length = 0;
  @State private deleteDialogAlignment: DialogAlignment | undefined = DialogAlignment.Default;
  private isLemFoldState: boolean = display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  /*
  * 是否开启三键导航模式
  * */
  @StorageLink('floatNavigationButtonOpen') @Watch('processDeleteDialogPositionChange') floatNavigationButtonOpen: boolean = false;
  @StorageLink('isShowDeleteFollowDialog') @Watch('refreshDeleteDialogStatus') isShowDeleteFollowDialog: boolean = false;

  refreshDialogs(): void {
    this.buildDialogs(true);
  }

  private buildAdvancedDialog(): void {
    // 相册、大图重命名弹窗
    this.buildRenameDialog();

    // 取消批量任务进度弹窗
    this.buildCancelDialog();

    // 删除弹窗
    this.buildDeleteDialog();

    this.createRemoveDialog();

    // 新建相册弹窗
    this.buildNewAlbumDialogDialog();

    // 暂无可用相册弹窗
    this.buildPromptNewAlbumsDialogDialog();

    // 批量进度弹窗
    this.buildProgressDialog();
  }

  private getDeleteDialogPositionY(): Length {
    this.windowLayoutHeight = getScreen().getWinLayoutHeight();
    return this.isHalfFold && !this.isHorizontal ? this.windowLayoutHeight / 4 : 0;
  }

  private createDeleteDialogController(): void {
    this.deleteDialogAlignment = this.getDeleteDialogAlignment();
    if (!(this.dialogCallback && typeof this.dialogCallback.confirmCallback === "function" && typeof this.dialogCallback.cancelCallback === "function")) {
      Log.error(TAG, 'DeleteDialog Callback not exist')
      return;
    }
    Log.info(TAG, 'DeleteDialog Callback exist, build DeleteDialog')
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog(),
      cancel: () => {
        Log.debug(TAG, 'Cancel Callback HIDE_DELETE_DIALOG');
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_DELETE_DIALOG, []);
      },
      offset: {
        dx: 0,
        dy: this.deleteDialogPositionY,
      },
      alignment: this.deleteDialogAlignment,
      autoCancel: false,
      customStyle: false,
      maskColor: DeviceInfo.isTv() ? $r('app.color.album_set_shadow_color') : undefined,
      openAnimation: {
        duration: 250,
        tempo: 0
      },
      closeAnimation: {
        duration: 250,
        tempo: 0
      }
    });
  }

  private createRemoveDialog(): void {
    // 移除弹窗
    this.removeDialogController = new CustomDialogController({
      builder: RemoveDialog(),
      cancel: () => {
        Log.debug(TAG, 'Cancel Callback HIDE_REMOVE_DIALOG');
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_REMOVE_DIALOG, []);
      },
      autoCancel: false,
      customStyle: false,
    });
  }

  private hideRemoveDialog(): void {
    Log.info(TAG, 'HIDE_REMOVE_DIALOG ');
    this.removeDialogController?.close?.();
  }

  private getDeleteDialogAlignment(): DialogAlignment {
    this.deleteDialogPositionY = this.getDeleteDialogPositionY();
    // 非手机
    if (!DeviceInfo.isPhoneUx()) {
      return DialogAlignment.Default;
    }
    // Verde外屏则居中 全景模式也居中
    if (DeviceInfo.isVerdeFoldable() || getScreen().isFloatingFullMode()) {
      return DialogAlignment.Default;
    }
    if (getScreen().isFloatModeReal()) {
      this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
      return DialogAlignment.Bottom;
    }
    // 手机
    if (DeviceInfo.isFoldable()) {
      if (getScreen().isSplitModeReal() || getScreen().isFloatModeReal()) {
        this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
        // xxx打开左右分屏、悬浮都底部
        return DialogAlignment.Bottom;
      }
      // xxx未打开分屏也未打开悬浮则默认居中
      return DialogAlignment.Default;

    } else {
      if (isOrientationHorizontal()) {
        // 分屏
        if (getScreen().isSplitModeReal()) {
          this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
          return DialogAlignment.Bottom;
        } else { // 未分屏
          return DialogAlignment.Default;
        }
      }
      this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
      // 未分屏、悬浮
      return DialogAlignment.Bottom;
    }
  }

  private buildRenameDialog(): void {
    this.renameFileDialogController = new CustomDialogController({
      builder: RenameDialog({ closeRenamePhotoDialog: (): void => this.closeRenamePhotoDialog() }),
      cancel: (): void => {
        Log.debug(TAG, 'Cancel Callback closeRenamePhotoDialog');
        this.closeRenamePhotoDialog();
      },
      autoCancel: false,
      customStyle: false,
    });
  }

  private buildCancelDialog(): void {
    this.cancelDialogController = new CustomDialogController({
      builder: CancelOperationDialog({
        cancelMessage: this.cancelMessage,
      }),
      autoCancel: false,
      customStyle: false,
    });
  }

  private buildDeleteDialog(): void {
    this.createDeleteDialogController();
    // 外屏删除弹窗
    this.subScreenDeleteDialogController = new CustomDialogController({
      builder: SubScreenDeleteDialog({
        mediaType: this.mediaType,
      }),
      cancel: () => {
        Log.debug(TAG, 'Cancel Callback HIDE_SUB_SCREEN_DELETE_DIALOG');
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_SUB_SCREEN_DELETE_DIALOG, []);
      },
      autoCancel: false,
      customStyle: true,
    });
  }

  // 创建新相册弹窗
  private buildNewAlbumDialogDialog(): void {
    this.newAlbumDialogController = new CustomDialogController({
      builder: NewAlbumDialog(),
      autoCancel: false,
      customStyle: false,
    });
  }

  private buildPromptNewAlbumsDialogDialog(): void {
    this.promptNewAlbumsDialogController = new CustomDialogController({
      builder: PromptNewAlbumDialog(),
      cancel: () => {
        Log.debug(TAG, 'Cancle Callback HIDE_PROMPT_DIALOG');
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);
      },
      autoCancel: false,
      customStyle: false,
    });
  }

  private buildProgressDialog(): void {
    // 批量进度弹窗
    this.progressDialogController = new CustomDialogController({
      builder: ProgressDialog({ progressParam: this.progressParam }),
      autoCancel: false,
      cancel: (): void => {
        this.browserController.broadCast.emit(BroadCastConstants.CANCEL_PROGRESS_DIALOG, []);
      },
      customStyle: false,
    });
  }

  // 创建弹窗
  buildDialogs(refreshFlag: boolean): void {
    this.processDeleteDialogPositionChange();
    this.downloadProgressDialogController = new CustomDialogController({
      builder: DownloadProgressDialog(),
      autoCancel: false,
      customStyle: false,
    });

    this.copyOrMoveDialogController = new CustomDialogController({
      builder: CopyOrMoveDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true,
    });

    this.saveImageDialogController = new CustomDialogController({
      builder: SaveImageDialog(),
      autoCancel: false,
      alignment: DialogAlignment.Center,
      customStyle: true,
    });

    if (!refreshFlag) {
      this.moveDialogController = new CustomDialogController({
        builder: MoveDialog({
          reshowProgressDialog: (): void => this.reshowProgressDialog(),
          broadCast: this.browserController.broadCast,
        }),
        autoCancel: false,
        cancel: (): void => {
          this.dialogBroadCast.emit(BroadCastConstants.HIDE_MOVE_DIALOG, []);
          this.moveDialogCallback && this.moveDialogCallback?.cancelCallback?.();
        },
        alignment: DialogAlignment.Center,
        customStyle: false,
      });
    }
  }

  private reshowProgressDialog(): void {
    Log.info(TAG, 'RESHOW_PROGRESS_DIALOG ');
    this.progressDialogController?.open?.();
  }

  private closeRenamePhotoDialog(): void {
    (this.renameFileDialogController as CustomDialogController)?.close();
    this.renameFileDialogControllerFlag = false;
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.dialogBroadCast.off();
    // todo lishang 取消逻辑是否正常
    this.browserController.broadCast.off(BroadCastConstants.SHOW_DELETE_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_SUB_SCREEN_DELETE_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_HIDDEN_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.CANCEL_OPERATE, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_MOVE_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.HIDE_MOVE_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_PROGRESS_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.HIDE_PROGRESS_DIALOG, undefined);
    this.browserController.broadCast.off(BroadCastConstants.UPDATE_PROGRESS, undefined);
    this.browserController.broadCast.off(BroadCastConstants.SHOW_REMOVE_DIALOG, undefined);
    this.dialogBroadCast.off(BroadCastConstants.HIDE_REMOVE_DIALOG);
    this.removeDialogController?.close();
    this.removeDialogController = undefined;
    if (this.progressDialogOpenFlag || this.progressDialogDelayOpenFlag) {
      this.progressParam?.cancelFunc?.();
    }
    if (this.progressDialogTimeoutHdl > 0) {
      this.progressDialogDelayOpenFlag = false;
      clearTimeout(this.progressDialogTimeoutHdl);
      this.progressDialogTimeoutHdl = 0;
    }

    if (this.deleteDialogOpenFlag) {
      this.deleteDialogOpenFlag = false;
      this.deleteDialogController?.close?.();
    }

    if (this.progressDialogOpenFlag) {
      this.progressDialogOpenFlag = false;
      this.progressDialogDelayOpenFlag = false;
      this.progressDialogController?.close?.();
    }
    this.dialogBroadCast.off(BroadCastConstants.HIDE_MOVE_DIALOG, undefined);

    // Release dialog controllers
    this.hideDialogController?.close();
    this.promptNewAlbumsDialogController?.close();
    this.newAlbumDialogController?.close();
    this.moveDialogController?.close();
    this.renameFileDialogController?.close();
    this.deleteDialogController = undefined;
    this.subScreenDeleteDialogController = undefined;
    this.portraitNameDialogController = undefined;
    this.hideDialogController = undefined;
    this.cancelDialogController = undefined;
    this.renameFileDialogController = undefined;
    this.editExitDialogController = undefined;
    this.petalClipNotInstallDialogController = undefined;
    this.addNotesDialogController = undefined;
    this.newAlbumDialogController = undefined;
    this.copyOrMoveDialogController = undefined;
    this.saveImageDialogController = undefined;
    this.promptNewAlbumsDialogController = undefined;
    this.moveDialogController = undefined;
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.buildAdvancedDialog();
    this.buildDialogs(false);
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      this.foldStatusChange();
    }
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.browserController.broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG,
      (deleteMessage: Resource[], confirmCallback: Function, cancelCallback: Function, isAlbumDelete: boolean,
        isExpandPositionParams: PositionParams, popoverDialog: boolean = false): void => {
        Log.info(TAG, `SHOW_DELETE_DIALOG ${this.deleteDialogOpenFlag}`);
        if (this.deleteDialogOpenFlag) {
          // Handle the multi-click issue, after that the delete dialog can not close.
          return;
        }
        this.deleteDialogOpenFlag = true;
        this.dialogMessage = deleteMessage[0];
        this.dialogContent = deleteMessage[1];
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        this.createDeleteDialogController();
        if (!popoverDialog) {
          this.deleteDialogController?.open();
        }
        this.isAlbumDelete = isAlbumDelete;
        this.isClearRecycle = isExpandPositionParams?.isClearRecycle;
        this.isHoldPosition = isExpandPositionParams?.isHoldPosition;
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_DELETE_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_DELETE_DIALOG ');
        this.deleteDialogOpenFlag = false;
        this.deleteDialogController?.close();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_SUB_SCREEN_DELETE_DIALOG,
      (confirmCallback: Function, cancelCallback: Function): void => {
        Log.info(TAG, 'SHOW_SUB_SCREEN_DELETE_DIALOG ');
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
        this.subScreenDeleteDialogController?.open?.();
        this.deleteDialogOpenFlag = true;
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_SUB_SCREEN_DELETE_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_SUB_SCREEN_DELETE_DIALOG ');
        this.deleteDialogOpenFlag = false;
        this.subScreenDeleteDialogController?.close?.();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_HIDDEN_DIALOG,
      (hideMessage: Resource, confirmCallback: Function, cancelCallback: Function, isPhotoHide: boolean) => {
        Log.info(TAG, 'SHOW_HIDDEN_DIALOG');
        this.dialogMessage = hideMessage;
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        this.hideDialogController?.open();
        this.isPhotoHide = isPhotoHide;
        this.hideDialogOpenFlag = true;
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_HIDDEN_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_HIDDEN_DIALOG ');
        this.hideDialogOpenFlag = false;
        this.hideDialogController?.close();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG,
      (fileName: string, confirmCallback: Function, cancelCallback?: Function) => {
        Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
        this.renameFileName = fileName;
        this.inputText = fileName;
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
        this.renameFileDialogController?.open();
        this.renameFileDialogControllerFlag = true;
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_RENAME_PHOTO_DIALOG ');
        this.renameFileDialogControllerFlag = false;
        this.renameFileDialogController?.close();
      });

    this.browserController.broadCast.on(BroadCastConstants.CANCEL_OPERATE,
      (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function) => {
        this.cancelMessage = cancelMessage;
        this.cancelParam.continueFunc = continueFunc;
        this.cancelParam.cancelFunc = cancelFunc;
        Log.info(TAG, 'CANCEL_OPERATE');
        this.cancelDialogController?.open();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_PROGRESS_DIALOG,
      (message: Resource, cancelFunc?: Function, cancelDelay?: boolean,
        msgWidth?: number, custom?: CustomBuilderParam) => {
        Log.info(TAG, `SHOW_PROGRESS_DIALOG msgWidth=${msgWidth}`);
        this.progressParam.progress = 0;
        this.progressParam.message = message;
        this.progressParam.custom = custom;
        if (cancelFunc && typeof cancelFunc === 'function') {
          this.progressParam.cancelFunc = cancelFunc;
        }
        this.progressParam.msgWidth = msgWidth;
        this.progressDialogDelayOpenFlag = true;
        this.progressDialogTimeoutHdl = setTimeout((): void => {
          if (this.progressDialogController && this.progressDialogDelayOpenFlag) {
            this.progressDialogController?.open?.();
            this.progressDialogOpenFlag = true;
          }
        }, cancelDelay ? 0 : Constants.PROGRESS_SHOW_TIME_THRESHOLD);
      });

    this.browserController.broadCast.on(BroadCastConstants.HIDE_PROGRESS_DIALOG, () => {
      Log.info(TAG, 'HIDE_PROGRESS_DIALOG ');
      if (this.progressDialogDelayOpenFlag && !this.progressDialogOpenFlag) {
        clearTimeout(this.progressDialogTimeoutHdl);
      }
      this.progressDialogController?.close?.();
    });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG,
      (uri: string) => {
        Log.info(TAG, 'show download progress dialog');
        this.downloadUri = uri;
        this.downloadProgressDialogController?.open();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG,
      (): void => {
        Log.info(TAG, 'SHOW_EDIT_SAVE_PROGRESS_DIALOG');
        this.saveImageDialogController?.open();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
      (fileName: string, confirmCallback: Function, cancelCallback?: Function) => {
        Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
        this.renameFileName = fileName;
        this.inputText = fileName;
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback as Function };
        this.newAlbumDialogController?.open();
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_NEW_ALBUM_PHOTO_DIALOG ');
        this.newAlbumDialogController?.close?.();
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG,
      (copyFunc: Function) => {
        Log.info(TAG, 'SHOW_COPY_OR_MOVE_DIALOG');
        this.operateParam.copyFunc = copyFunc;
        this.copyOrMoveDialogController?.open();
      });

    this.browserController.broadCast.on(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG,
      (cancelCallback: Function, newCallback: Function) => {
        Log.info(TAG, 'PROMPT_NEW_ALBUMS_DIALOG');
        this.dialogMessage = $r('app.string.prompt_new_album_dialog_message');
        this.dialogCallback = { confirmCallback: newCallback, cancelCallback: cancelCallback as Function };
        this.promptNewAlbumsDialogController?.open?.();
        this.promptDialogOpenFlag = true;
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_MOVE_DIALOG, (repeatPhotos: PhotoAsset[],
      replaceCallback: Function, skipCallback: Function, cancelCallback: Function): void => {
      Log.info(TAG, 'SHOW_MOVE_DIALOG');
      this.repeatPhotos = repeatPhotos;
      this.moveDialogCallback = {
        replaceCallback: replaceCallback, skipCallback: skipCallback,
        cancelCallback: cancelCallback,
      };
      this.moveDialogController?.open?.();
    }); // 移动弹窗

    this.browserController.broadCast.on(BroadCastConstants.HIDE_MOVE_DIALOG, (): void => {
      Log.info(TAG, 'HIDE_MOVE_DIALOG ');
      this.moveDialogController?.close?.();
    }); // 移动弹窗

    this.dialogBroadCast.on(BroadCastConstants.HIDE_MOVE_DIALOG, (): void => {
      Log.info(TAG, 'HIDE_MOVE_DIALOG ');
      this.moveDialogController?.close?.();
    }); // 移动弹窗

    this.browserController.broadCast.on(BroadCastConstants.UPDATE_PROGRESS,
      (progress: number, currentCount: number): void => {
        Log.info(TAG, `UPDATE_PROGRESS ${progress}`);
        this.progressParam.progress = progress;
        if (progress == 100) {
          Log.info(TAG, 'Update progress 100%');
          this.progressDialogOpenFlag = false;
          this.progressDialogDelayOpenFlag = false;
          this.progressDialogController?.close?.();
        }
      });

    this.browserController.broadCast.on(BroadCastConstants.SHOW_REMOVE_DIALOG,
      (removeMessage: Resource, removeMsgContent: Resource, confirmCallback?: Function, cancelCallback?: Function): void => {
        Log.info(TAG, 'SHOW_REMOVE_DIALOG ');
        this.dialogMessage = removeMessage;
        this.dialogContent = removeMsgContent;
        this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        this.removeDialogController?.open?.();
      });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_REMOVE_DIALOG, () => {
      this.hideRemoveDialog();
    });

    this.dialogBroadCast.on(BroadCastConstants.HIDE_PROMPT_DIALOG,
      (): void => {
        Log.info(TAG, 'HIDE_PROMPT_DIALOG ');
        this.promptDialogOpenFlag = false;
        this.promptNewAlbumsDialogController?.close?.();
      });
  }

  build() {
  }

  /**
   * xxx变化更新
   */
  private foldStatusChange(): void {
    try {
      display.on('foldStatusChange', async (status: display.FoldStatus) => {
        if (status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
          this.isHalfFold = true;
          this.deleteDialogController?.close();
          if (this.isHorizontal) {
            this.deleteDialogPositionY = 0;
          } else {
            this.deleteDialogPositionY = this.windowLayoutHeight / 4;
          }
          this.buildAdvancedDialog();
          if (this.deleteDialogOpenFlag) {
            this.deleteDialogController?.open();
          }
        } else if (status === display.FoldStatus.FOLD_STATUS_EXPANDED) {
          this.isHalfFold = false;
          this.deleteDialogController?.close();
          this.deleteDialogPositionY = 0;
          this.buildAdvancedDialog();
          if (this.deleteDialogOpenFlag) {
            this.deleteDialogController?.open();
          }
        }
      });
    } catch (err) {
      Log.error(TAG, `foldStatusChange display.on, error code : ${err.code}`)
    }
  }

  /**
   * xxx适配
   * @returns
   */
  private isHalfFoldStateEnable(): boolean {
    return DeviceInfo.isSmallFoldScreen() && !this.isLemFoldState && !this.isHorizontal;
  }

  private processDeleteDialogPositionChange(): void {
    if (this.deleteDialogOpenFlag && DeviceInfo.isPhoneUx()) {
      // 先关闭再开启可触发位置变化
      this.deleteDialogController?.close();
      this.createDeleteDialogController();
      this.deleteDialogController?.open()
    }
  }

  /**
   * 横竖屏适配
   */
  private onWinSizeChanged(): void {
    Log.info(TAG, `onWinSizeChanged`)
    this.processDeleteDialogPositionChange();
    if (!this.isHalfFold) {
      return;
    }
    this.deleteDialogController?.close();
    if (this.isHorizontal) {
      this.deleteDialogPositionY = this.windowLayoutHeight / 4;
    } else {
      this.deleteDialogPositionY = 0;
    }
    this.buildAdvancedDialog();
    if (this.deleteDialogOpenFlag) {
      this.deleteDialogController?.open();
    }
  }

  /**
   * 同步删除跟手弹窗状态
   */
  private refreshDeleteDialogStatus() {
    if (DeviceInfo.isGRLFoldScreen()) {
      Log.info(TAG, `isShowDeleteFollowDialog change: ${this.isShowDeleteFollowDialog}`);
      this.deleteDialogOpenFlag = this.isShowDeleteFollowDialog;
    }
  }
}