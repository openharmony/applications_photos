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

import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Log } from '../../utils/Log';
import lazy { DeleteDialog } from './DeleteDialog';
import lazy { RemoveDialog } from './RemoveDialog';
import lazy { DialogCallback, MoveDialogCallback } from '../../model/common/DialogUtil';
import lazy { LockDialog } from './LockDialog';
import lazy { CancelOperationDialog, CancelParam } from './CancelOperationDialog';
import lazy { RenameDialog } from './RenameDialog';
import lazy { MergeDialog } from './MergeDialog';
import lazy { CustomBuilderParam, ProgressDialog, ProgressParam } from './ProgressDialog';
import lazy { NewAlbumDialog } from './NewAlbumDialog';
import lazy { CopyOrMoveDialog, OperateParam } from './CopyOrMoveDialog';
import lazy { getScreen, isOrientationHorizontal, ScreenManager, WindowMode } from '../../model/common/ScreenManager';
import lazy { MoveDialog } from './MoveDialog';
import lazy { SaveImageDialog } from './SaveImageDialog';
import lazy { NetworkConnectionSwitchDialog } from './NetworkConnectionSwitchDialog';
import lazy { DownloadProgressDialog } from './DownloadProgressDialog';
import lazy { BatchDownloadProgressDialog } from './BatchDownloadProgressDialog';
import lazy { Constants } from '../../model/common/Constants';
import lazy { PromptNewAlbumDialog } from './PromptNewAlbumDialog';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { CancelRegistry } from '../CancelRegistry';
import lazy router from '@ohos.router';
import lazy { PositionParams } from '../browserOperation/DeleteMenuOperation';
import lazy { StopMediaAnalysisServiceDialog } from './StopMediaAnalysisServiceDialog';
import lazy { display } from '@kit.ArkUI';
import lazy { Region } from '../../model/common/DataTypes';
import lazy { ShortCut } from '../../model/ShortCut';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

export type PhotoAsset = photoAccessHelper.PhotoAsset;

export type PhotoAlbum = photoAccessHelper.Album;

/* instrument ignore file */
const TAG: string = 'common_CustomDialogView';
const HALF: number = 2;
const NEGATION: number = -1;
// 非三键导航上移16vp
const DIALOG_POSITION: number = -16;
// 三键导航上移18vp
const DIALOG_POSITION_MORE: number = -18;
// 删除弹窗位置变化时延
const DELETE_DIALOG_CREATE_TIMEOUT_MS: number = 100;

@Component
export struct CustomDialogView {
  @State private coverImgSize: Size = { width: 0, height: 0 };
  @State private region: Region = {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  };
  @State isShow: boolean = false;
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', '');
  @Provide dialogContent: Resource = $r('app.string.common_place_holder', '');
  @Provide isAlbumDelete: boolean = false;
  @Provide isPhotoHide: boolean = false; //隐藏
  @Provide isRemoveFromPortrait: boolean = false;
  @Provide isSetForMe: boolean = false;
  @Provide progressMessage: Resource = $r('app.string.common_place_holder', '');
  @Provide progress: number = 0;
  @Provide dialogCallback: DialogCallback = {
    confirmCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  @Link broadCast: BroadCast;
  @State pageDeleteNum: number = 0;
  private deleteDialogIndex: number = 0;
  private isClearRecycle: boolean | undefined = false;
  private isHoldPosition: boolean | undefined = false;
  private albumInfoIsMe?: AlbumInfo; // 当前是‘我’的人像
  private albumInfoSetMe?: AlbumInfo; // 将要设置为‘我’的人像
  @State isRecycle: boolean = false;
  @Provide({ allowOverride: 'dialogBroadCast' }) dialogBroadCast: BroadCast = new BroadCast();
  @Provide progressParam: ProgressParam = {
    progress: 0,
    message: undefined,
    cancelFunc: (): void => {
    }
  };
  @State private progressTarget: number = 0;
  @State private progressDisplay: number = 0;
  private progressAnimTimer: number = Number.NaN;
  @Provide cancelParam: CancelParam = {
    continueFunc: (): void => {
    }, cancelFunc: (): void => {
    }
  };
  @Provide operateParam: OperateParam = {
    copyFunc: (): void => {
    }
  };
  public cancelMessage: Resource = $r('app.string.common_place_holder', '');
  @Provide renameFileName: string = '';
  @Provide isDistributedAlbum: boolean = false;
  @Provide downloadUri: string = '';
  private readonly MIN_PROGRESS_VISIBLE_TIME: number = 300 ;
  /** 进度到 100% 后再保留展示的时长（毫秒） */
  private readonly PROGRESS_HOLD_MS_AFTER_100: number = 200 ;
  private progressStartTime: number = 0;
  private progressCloseTimeout: number = Number.NaN;
  /**
   * 弹出弹框前，传参赋值是带option的DataSource，覆盖了此处初始化
   */
  @Provide isDuplicateNameMerge: boolean = false;
  @Provide repeatPhotos: PhotoAsset[] = [];
  @Provide moveDialogCallback: MoveDialogCallback = {
    replaceCallback: (): void => {
    }, skipCallback: (): void => {
    }, cancelCallback: (): void => {
    }
  };
  public removeDialogRight: number = px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_end')));
  public appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public dialogMarginBottom = Constants.MAP_DIALOG_BOTTOM;
  @StorageLink('getFoldStatus') @Watch('refreshPortraitNameDialog') isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('refreshVdeDialog') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @StorageLink('isHorizontal') @Watch('refreshDialogs') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('isSidebar') @Watch('refreshDialogs') isSidebar: boolean = getScreen().isSidebar();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  /*
  * 是否开启三键导航模式
  * */
  @StorageLink('floatNavigationButtonOpen') @Watch('processDeleteDialogPositionChange') floatNavigationButtonOpen: boolean =
    false;
  public lockDialogController?: CustomDialogController | undefined;
  public lockDialogOpenFlag: boolean = false;
  public deleteDialogOpenFlag: boolean = false;
  hiddenDialogController?: CustomDialogController | undefined; //隐藏
  public hiddenDialogOpenFlag: boolean = false; //隐藏
  aiRetouchProtocolDialogController?: CustomDialogController | undefined; // AiRetouch隐私协议
  public aiRetouchProtocolDialogOpenFlag: boolean = false; // AiRetouch隐私协议打开状态
  aiRetouchStoppingServiceDialogController?: CustomDialogController | undefined; // AiRetouch停止服务
  public aiRetouchStoppingServiceDialogOpenFlag: boolean = false; // AiRetouch停止服务
  aiWallpaperServiceDialogController?: CustomDialogController; // AiWallpaper服务
  public aiWallpaperServiceDialogOpenFlag: boolean = false; // AiWallpaper服务
  public aiWallpaperServiceDialogDisableType: boolean = false; // AiWallpaper服务是否是停止
  aiWallpaperServiceDisappearCallback?: Function; // AiWallpaper弹窗消失的回调
  portraitNameDialogController?: CustomDialogController | undefined; //人像
  public portraitNameDialogOpenFlag: boolean = false; //人像
  public isRemoveFromPortraitDialogOpenFlag: boolean = false;
  setForMeDialogController?: CustomDialogController | undefined; //设置为我
  public setForMeDialogOpenFlag: boolean = false; //设置为我
  public replaceMeDialogController?: CustomDialogController | undefined;
  public replaceMeDialogOpenFlag: boolean = false;
  public removeDialogController?: CustomDialogController | undefined;
  public removeDialogOpenFlag: boolean = false;
  public progressDialogController?: CustomDialogController | undefined;
  public progressDialogOpenFlag: boolean = false;
  public progressDialogDelayOpenFlag: boolean = false;
  public progressDialogTimeoutHdl: number = 0;
  public cancelDialogController?: CustomDialogController | undefined;
  public renameFileDialogController?: CustomDialogController | undefined;
  public renameFileDialogControllerFlag: boolean = false;
  public editExitDialogController?: CustomDialogController | undefined;
  public petalClipNotInstallDialogController?: CustomDialogController | undefined;
  public newAlbumDialogController?: CustomDialogController | undefined;
  public newAlbumDialogControllerFlag: boolean = false;
  public copyOrMoveDialogController?: CustomDialogController | undefined;
  public moveDialogController?: CustomDialogController | undefined;
  public saveImageDialogController?: CustomDialogController | undefined;
  public cleanupImmediatelyDialogController?: CustomDialogController;
  public cleanupNoSpaceReleaseDialogController?: CustomDialogController;
  public cleanupImmediatelyLoadingDialog?: CustomDialogController;
  public networkConnectionSwitchDialogController?: CustomDialogController;
  private networkConnectionSwitchDialogOpenFlag: boolean = false;
  private cleanupImmediatelyOpenFlag: boolean = false;
  private cleanupNoSpaceReleaseOpenFlag: boolean = false;
  private cleanupImmediatelyLoadingOpenFlag: boolean = false;
  private mediaAnalysisServiceSwitchDialogController?: CustomDialogController;
  private mediaAnalysisServiceSwitchDialogOpenFlag: boolean = false;
  // 判断协议确认弹框是否从setting页面弹出
  private isShowFromSetting: boolean = false;
  public downloadProgressDialogController?: CustomDialogController;
  public batchDownloadProgressDialogController?: CustomDialogController;
  public promptDialogOpenFlag: boolean = false;
  public promptNewAlbumsDialogController?: CustomDialogController | undefined;
  public probablyIsMeDialogController?: CustomDialogController | undefined;
  public probablyIsMeDialogControllerFlag: boolean = false;
  private showLockDialogFunc: Function =
    (cancelMessage: Resource, confirmCallback?: Function, cancelCallback?: Function,): void => {
      Log.info(TAG, 'showLockDialogFunc');
      this.showLockDialog(cancelMessage, confirmCallback, cancelCallback);
    };
  private hideLockDialogFunc: Function = (): void => this.hideLockDialog();
  private showNewAlbumDialogFunc: Function =
    (fileName: string, confirmCallback?: Function, cancelCallback?: Function): void => this.showNewAlbumDialog(
      fileName, confirmCallback, cancelCallback);
  private hideNewAlbumDialogFunc: Function = (): void => this.closeNewAlbumDialog();
  private showDeleteDialogFunc: Function =
    (deleteMessage: Resource[], confirmCallback: Function, cancelCallback: Function, isAlbumDelete: boolean,
      isExpandPositionParams: PositionParams, popoverDialog: boolean = false): void => this.showDeleteDialog(
      deleteMessage, confirmCallback, cancelCallback, isAlbumDelete, isExpandPositionParams, popoverDialog);
  private hideDeleteDialogFunc: Function = (): void => this.hideDeleteDialog();
  //隐藏
  private showHiddenDialogFunc: Function =
    (hideMessage: Resource, confirmCallback: Function, cancelCallback: Function, isPhotoHide: boolean):
      void => this.showHiddenDialog(hideMessage, confirmCallback, cancelCallback, isPhotoHide);
  //隐藏
  private hideHiddenDialogFunc: Function = (): void => this.hideHiddenDialog();
  // 设置为我
  private showSetForMeDialogFunc: Function =
    (setForMeMessage: Resource, confirmCallback?: Function, cancelCallback?: Function, albumInfoSetMe?: AlbumInfo):
      void => this.showSetForMeDialog(setForMeMessage, confirmCallback, cancelCallback, albumInfoSetMe);
  private hideSetForMeDialogFunc: Function = (): void => this.hideSetForMeDialog();
  private hideReplaceMeDialogFunc: Function = (): void => this.hideReplaceMeDialog();
  private showReplaceDialogFunc: Function =
    (confirmCallback?: Function, cancelCallback?: Function, albumInfoIsMe?: AlbumInfo, albumInfoSetMe?: AlbumInfo):
      void => this.showReplaceDialog(confirmCallback, cancelCallback, albumInfoIsMe, albumInfoSetMe);
  private hideProbablyIsMeDialogFunc: Function = (): void => this.hideProbablyIsMeDialog(); //人像
  private showRemoveDialogFunc: Function =
    (removeMessage: Resource, removeMsgContent: Resource, confirmCallback?: Function, cancelCallback?: Function):
      void => this.showRemoveDialog(removeMessage, removeMsgContent, confirmCallback, cancelCallback);
  private hideRemoveDialogFunc: Function = (): void => this.hideRemoveDialog();
  private showRenamePhotoDialogFunc: Function =
    (fileName: string, confirmCallback?: Function, cancelCallback?: Function):
      void => this.showRenamePhotoDialog(fileName, confirmCallback, cancelCallback);
  private hideRenamePhotoDialogFunc: Function = (): void => this.closeRenamePhotoDialog();
  private showProgressDialogFunc: Function = (message: Resource, cancelFunc?: Function, cancelDelay?: boolean,
    msgWidth?: number, custom?: CustomBuilderParam): void => this.showProgressDialog(message, cancelFunc, cancelDelay,
    msgWidth, custom);
  private hideProgressDialogFunc: Function = (): void => this.hideProgressDialog();
  private updateProgressFunc: Function = (progress: number, currentCount: number):
    void => this.updateProgress(progress, currentCount);
  private cancelOperateFunc: Function = (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function):
    void => this.cancelOperate(cancelMessage, continueFunc, cancelFunc);
  private showCleanupImmediatelyDialogFunc: Function = (cancelCallback: Function, confirmCallback: Function):
    void => this.showCleanupImmediatelyDialog(cancelCallback, confirmCallback);
  private showCleanupNoSpaceReleaseDialogFunc: Function = (cancelCallback: Function, confirmCallback: Function):
    void => this.showCleanupNoSpaceReleaseDialog(cancelCallback, confirmCallback);
  private showCleanupImmediatelyLoadingDialogFunc: Function = (cancelCallback: Function, confirmCallback: Function):
    void => this.showCleanupImmediatelyLoadingDialog(cancelCallback, confirmCallback);
  private closeCleanupImmediatelyDialogFunc: Function = (): void => this.closeCleanupImmediatelyDialog();
  private closeCleanupNoSpaceReleaseDialogFunc: Function = (): void => this.closeCleanupNoSpaceReleaseDialog();
  private closeCleanupImmediatelyLoadingDialogFunc: Function = (): void => this.closeCleanupImmediatelyLoadingDialog();
  private showNetworkConnectionSwitchDialogFunc: Function = (cancelCallback: Function, confirmCallback: Function):
    void => this.showNetworkConnectionSwitchDialog(cancelCallback, confirmCallback);
  private closeNetworkConnectionSwitchDialogFunc: Function = (): void => this.closeNetworkConnectionSwitchDialog();
  private showDownloadProgressDialogFunc: Function = (uri: string): void => this.showDownloadProgressDialog(uri);
  private closeDownloadProgressDialogFunc: Function = (): void => this.closeDownloadProgressDialog();
  private showBatchDownloadProgressDialogFunc: Function = (cancel?: () => void):
    void => this.showBatchDownloadProgressDialog(cancel);
  private closeBatchDownloadProgressDialogFunc: Function = (): void => this.closeBatchDownloadProgressDialog();
  private showEditSaveProgressDialogFunc: Function = (): void => this.showEditSaveProgressDialog();
  private showCopyOrMoveDialogFunc: Function = (copyFunc: Function):
    void => this.showCopyOrMoveDialog(copyFunc);
  private showMoveDialogFunc: Function =
    (repeatPhotos: PhotoAsset[], replaceCallback: Function, skipCallback: Function, cancelCallback: Function):
      void => this.showMoveDialog(repeatPhotos, replaceCallback, skipCallback, cancelCallback);
  private hideMoveDialogFunc: Function = (): void => this.hideMoveDialog();
  private promptNewAlbumsDialogFunc: Function =
    (cancelCallback: Function, newCallback: Function): void => this.promptNewAlbumsDialog(cancelCallback, newCallback);
  private hidePromptDialogFunc: Function = (): void => this.hidePromptDialog();
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  private onWinScreenRotationChangedCallBack = (): void => this.onWinScreenRotationChanged();
  @Provide inputText: string = '';
  @Provide isCloseTip: boolean = false;
  private batchDownloadCancelRegistry: CancelRegistry | undefined = undefined;
  private showMediaAnalysisServiceSwitchDialogFunc: Function =
    (cancelCallback: Function, confirmCallback: Function):
      void => this.showMediaAnalysisServiceSwitchDialog(cancelCallback, confirmCallback);
  private closeMediaAnalysisServiceSwitchDialogFunc: Function = ():
    void => this.closeMediaAnalysisServiceSwitchDialog();
  @State windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  @StorageLink('isHalfFold') @Watch('foldStatusChange') isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  @State private disScreenWidth: number = getScreen().getDisScreenWidth();
  @State private deleteDialogPositionY: Length = 0;
  @State private deleteDialogAlignment: DialogAlignment | undefined = DialogAlignment.Default;
  // 删除弹窗
  public deleteDialogController?: CustomDialogController | undefined;
  public isNeedDelDialogPositionChange : boolean = true;
  private isLemFoldState: boolean = display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
  @State private navigationPageInfos: NavPathStack | undefined = undefined;
  private selectUris: string[] = [];
  private isFromGalleryCleanupPage: boolean = false;

  refreshDialogs(): void {
    this.buildDialogs(true);
  }

  refreshPortraitNameDialog(): void {
    this.buildDialogs(true);
  }

  private getDeleteDialogPositionY(): Length {
    this.windowLayoutHeight = getScreen().getWinLayoutHeight();
    return this.isHalfFold && !this.isHorizontal ? this.windowLayoutHeight / 4 : 0;
  }

  private getDeleteDialogAlignment(): DialogAlignment {
    Log.info(TAG, 'getDeleteDialogPositionY');
    this.deleteDialogPositionY = this.getDeleteDialogPositionY();
    const isFloatingWindow: boolean = getScreen().isFloatModeReal() || getScreen().getWinMode() === WindowMode.FLOATING;
    // 设置页图库清理页面删除对话框居中显示
    if (this.isFromGalleryCleanupPage) {
      return DialogAlignment.Default;
    }
    Log.info(TAG, 'isVerdeFoldable');
    // Verde外屏则居中 全景模式也居中
    if (DeviceInfo.isVerdeFoldable() || getScreen().isFloatingFullMode()) {
      return DialogAlignment.Default;
    }
    Log.info(TAG, 'isFloatModeReal');
    if (isFloatingWindow) {
      this.isNeedDelDialogPositionChange = true;
      this.deleteDialogPositionY = 0;
      return DialogAlignment.Center;
    }
    Log.info(TAG, 'isFoldable');
    // 手机
    if (DeviceInfo.isFoldable()) {
      if (getScreen().isSplitModeReal()) {
        this.isNeedDelDialogPositionChange = true;
        // 上下分屏居中，宽度不变
        if (getScreen().getWindowRectWidth() === this.disScreenWidth) {
          return DialogAlignment.Default;
        }
        // 距离底部导航条16vp
        this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
        // xxx打开左右分屏、悬浮都底部
        return DialogAlignment.Bottom;
      }
      // xxx未打开分屏也未打开悬浮则默认居中
      return DialogAlignment.Default;
    } else {Log.info(TAG, 'isOrientationHorizontal');
      if (isOrientationHorizontal()) {
        // 分屏
        if (getScreen().isSplitModeReal()) {
          this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
          return DialogAlignment.Bottom;
        } else { // 未分屏
          return DialogAlignment.Default;
        }
      }
      Log.info(TAG, 'isSplitModeReal');
      if (getScreen().isSplitModeReal()) {
        // 上下分屏
        if (getScreen().getWindowRectWidth() === this.disScreenWidth) {
          return DialogAlignment.Default;
        } else {
          // 左右分屏
          this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
          // 直板手机竖屏未打开分屏或者悬浮都底部且距离底部导航条16vp
          return DialogAlignment.Bottom;
        }
      }
      this.deleteDialogPositionY = this.floatNavigationButtonOpen ? DIALOG_POSITION_MORE : DIALOG_POSITION;
      // 未分屏、悬浮
      return DialogAlignment.Bottom;
    }
  }

  private createDeleteDialogController(): void {
    Log.info(TAG, 'createDeleteDialogController');
    this.deleteDialogAlignment = this.getDeleteDialogAlignment();
    Log.info(TAG, 'getDeleteDialogAlignment end');
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog({
        confirmCallback: this.dialogCallback?.confirmCallback,
        cancelCallback: this.dialogCallback?.cancelCallback,
        dialogBroadCast: this.dialogBroadCast,
        dialogMessage: this.dialogMessage,
        dialogContent: this.dialogContent,
        isAlbumDelete: this.isAlbumDelete
      }),
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

  private refreshVdeDialog(): void {
    if (!DeviceInfo.isVerdeFoldable()) {
      return;
    }
    this.closeNewAlbumDialog();
    Log.info(TAG, 'closeNewAlbumDialog');
  }

  private buildAdvancedDialog(): void {

    // 相册、大图重命名弹窗
    this.renameFileDialogController = new CustomDialogController({
      builder: RenameDialog({ closeRenamePhotoDialog: (): void => this.closeRenamePhotoDialog() }),
      cancel: (): void => {
        Log.debug(TAG, 'Cancel Callback closeRenamePhotoDialog');
        this.closeRenamePhotoDialog();
      },
      autoCancel: false,
      customStyle: false,
    });

    // 取消批量任务进度弹窗
    this.cancelDialogController = new CustomDialogController({
      builder: CancelOperationDialog({
        cancelMessage: this.cancelMessage,
      }),
      autoCancel: false,
      customStyle: false,
    });

    this.networkConnectionSwitchDialogController = new CustomDialogController({
      builder: NetworkConnectionSwitchDialog(),
      autoCancel: false,
      customStyle: false,
      onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        // 侧滑返回或者ESC返回时,重置开关为网络开关为打开态
        if (dismissDialogAction.reason === DismissReason.PRESS_BACK) {
          this.dialogCallback && (this.dialogCallback as DialogCallback)?.cancelCallback?.();
          dismissDialogAction.dismiss();
          return;
        }
        dismissDialogAction.dismiss();
      },
    });

    // 媒体智慧分析服务停止服务弹窗
    this.mediaAnalysisServiceSwitchDialogController = new CustomDialogController({
      builder: StopMediaAnalysisServiceDialog(),
      autoCancel: false,
      customStyle: false,
      cancel: (): void => {
        Log.debug(TAG, 'Cancel mediaAnalysisServiceSwitchDialog');
        this.closeMediaAnalysisServiceSwitchDialog();
      },
    });

    // 新建相册弹窗
    this.newAlbumDialogController = new CustomDialogController({
      builder: NewAlbumDialog({ closeNewAlbumDialog: (): void => this.closeNewAlbumDialog() }),
      autoCancel: false,
      customStyle: false,
    });

    // 暂无可用相册弹窗
    this.promptNewAlbumsDialogController = new CustomDialogController({
      builder: PromptNewAlbumDialog(),
      cancel: () => {
        Log.debug(TAG, 'Cancel Callback HIDE_PROMPT_DIALOG');
        this.dialogBroadCast.emit(BroadCastConstants.HIDE_PROMPT_DIALOG, []);
      },
      autoCancel: false,
      customStyle: false,
    });

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

    // 进入隐藏相册弹窗
    this.lockDialogController = new CustomDialogController({
      builder: LockDialog({
        hideLockDialog: () => this.hideLockDialog(),
        cancelCallback: this.dialogCallback?.cancelCallback,
      }),
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
        this.broadCast.emit(BroadCastConstants.CANCEL_PROGRESS_DIALOG, []);
      },
      customStyle: false,
    });

    // 批量下载进度对话框
    this.batchDownloadCancelRegistry = new CancelRegistry();
    this.batchDownloadProgressDialogController = new CustomDialogController({
      builder: BatchDownloadProgressDialog({ cancelRegistry: this.batchDownloadCancelRegistry }),
      autoCancel: false,
      customStyle: false,
    });

    // 大图编辑下载进度
    this.downloadProgressDialogController = new CustomDialogController({
      builder: DownloadProgressDialog(),
      autoCancel: false,
      customStyle: false,
    });
  }

  buildDialogs(refreshFlag: boolean): void {
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

    if (!refreshFlag) {
      this.moveDialogController = new CustomDialogController({
        builder: MoveDialog({
          reshowProgressDialog: (): void => this.reshowProgressDialog(),
          broadCast: this.broadCast,
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

    this.saveImageDialogController = new CustomDialogController({
      builder: SaveImageDialog(),
      autoCancel: false,
      alignment: DialogAlignment.Center,
      customStyle: true,
    });
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.appBroadCast.emit(BroadCastConstants.SETTING_MULTIPLE_CLICKS, []);
    this.appBroadCast.emit(BroadCastConstants.HAS_CLICKED_ALBUM_DELETE_BUTTON, []);
    this.broadCast.off(BroadCastConstants.SHOW_LOCK_DIALOG, this.showLockDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_LOCK_DIALOG, this.hideLockDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_DELETE_DIALOG, this.hideDeleteDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_HIDDEN_DIALOG, this.showHiddenDialogFunc); //隐藏
    this.broadCast.off(BroadCastConstants.SHOW_HIDDEN_DIALOG, this.showHiddenDialogFunc); //隐藏
    this.broadCast.off(BroadCastConstants.SHOW_REMOVE_DIALOG, this.showRemoveDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_MOVE_DIALOG, this.showMoveDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_MOVE_DIALOG, this.hideMoveDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG, this.showRenamePhotoDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, this.hideRenamePhotoDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_PROGRESS_DIALOG, this.showProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_PROGRESS_DIALOG, this.hideProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.UPDATE_PROGRESS, this.updateProgressFunc);
    this.broadCast.off(BroadCastConstants.CANCEL_OPERATE, this.cancelOperateFunc);
    this.broadCast.off(BroadCastConstants.CLOSE_CLEANUP_NO_SPACE_RELEASE_DIALOG,
      this.closeCleanupNoSpaceReleaseDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_NETWORK_CONNECTION_SWITCH_DIALOG,
      this.showNetworkConnectionSwitchDialogFunc);
    this.broadCast.off(BroadCastConstants.CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG,
      this.closeNetworkConnectionSwitchDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, this.showDownloadProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.CLOSE_DOWNLOAD_PROGRESS_DIALOG, this.closeDownloadProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_BATCH_DOWNLOAD_PROGRESS_DIALOG,
      this.showBatchDownloadProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.CLOSE_BATCH_DOWNLOAD_PROGRESS_DIALOG,
      this.closeBatchDownloadProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, this.showEditSaveProgressDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG, this.showNewAlbumDialogFunc);
    this.broadCast.off(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG, this.hideNewAlbumDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, this.showCopyOrMoveDialogFunc);
    this.broadCast.off(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, this.promptNewAlbumsDialogFunc);
    this.broadCast.off(BroadCastConstants.SHOW_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
      this.showMediaAnalysisServiceSwitchDialogFunc);
    this.broadCast.off(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
      this.closeMediaAnalysisServiceSwitchDialogFunc);
    this.dialogBroadCast.off(BroadCastConstants.HIDE_DELETE_DIALOG, this.hideDeleteDialogFunc);
    this.dialogBroadCast.off(BroadCastConstants.HIDE_REMOVE_DIALOG, this.hideRemoveDialogFunc);
    this.dialogBroadCast.off(BroadCastConstants.HIDE_MOVE_DIALOG, this.hideMoveDialogFunc);
    this.dialogBroadCast.off(BroadCastConstants.HIDE_PROMPT_DIALOG, this.hidePromptDialogFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onWinScreenRotationChangedCallBack);
    if (this.progressDialogOpenFlag || this.progressDialogDelayOpenFlag) {
      this.hideProgressDialog();
      this.progressDialogOpenFlag = false;
      this.progressDialogDelayOpenFlag = false;
    }
    if (this.progressDialogTimeoutHdl > 0) {
      this.progressDialogDelayOpenFlag = false;
      clearTimeout(this.progressDialogTimeoutHdl);
      this.progressDialogTimeoutHdl = 0;
    }
    if (this.progressDialogOpenFlag) {
      this.progressDialogOpenFlag = false;
      this.progressDialogDelayOpenFlag = false;
      this.progressDialogController?.close?.();
    }

    if (this.deleteDialogOpenFlag) {
      this.hideDeleteDialog();
    }
    if (this.newAlbumDialogControllerFlag && DeviceInfo.isGRLFoldScreen()) {
      this.closeNewAlbumDialog();
    }
    if (this.renameFileDialogControllerFlag && DeviceInfo.isGRLFoldScreen()) {
      this.closeRenamePhotoDialog();
    }
    if (DeviceInfo.isFoldablePhone()) {
      try {
        display.off('foldStatusChange', this.onFoldStatusChange);
      } catch (e) {
        Log.error(TAG, 'unRegister callback failed')
      }
    }

    // Release dialog controllers
    this.hiddenDialogController?.close?.();
    this.deleteDialogController = undefined;
    this.hiddenDialogController = undefined; //隐藏
    this.portraitNameDialogController = undefined; //人像
    this.setForMeDialogController = undefined; //设置为我
    this.aiRetouchProtocolDialogController = undefined; // AiRetouch服务
    this.aiRetouchStoppingServiceDialogController = undefined; // AiRetouch停止服务
    this.removeDialogController?.close();
    this.removeDialogController = undefined;
    this.progressDialogController = undefined;
    this.cancelDialogController = undefined;
    this.renameFileDialogController = undefined;
    this.editExitDialogController = undefined;
    this.petalClipNotInstallDialogController = undefined;
    this.newAlbumDialogController = undefined;
    this.copyOrMoveDialogController = undefined;
    this.moveDialogController = undefined;
    this.saveImageDialogController = undefined;
    this.cleanupImmediatelyDialogController = undefined;
    this.cleanupNoSpaceReleaseDialogController = undefined;
    this.cleanupImmediatelyLoadingDialog = undefined;
    this.networkConnectionSwitchDialogController = undefined;
    this.mediaAnalysisServiceSwitchDialogController = undefined;
    this.downloadProgressDialogController = undefined;
    this.batchDownloadProgressDialogController = undefined;
    this.batchDownloadCancelRegistry = undefined;
    this.promptNewAlbumsDialogController = undefined;
    this.lockDialogController = undefined;
    this.replaceMeDialogController = undefined;
    this.probablyIsMeDialogController = undefined;
    this.aiWallpaperServiceDialogController = undefined;
    this.dialogBroadCast.release();
  }

  private showLockDialog(cancelMessage: Resource, confirmCallback?: Function, cancelCallback?:
    Function,): void {
    Log.info(TAG, 'SHOW_LOCK_DIALOG ');
    this.cancelMessage = cancelMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.lockDialogController?.open();
    this.lockDialogOpenFlag = true;
  }

  private hideLockDialog(): void {
    Log.info(TAG, 'HIDE_LOCK_DIALOG ');
    this.lockDialogOpenFlag = false;
    this.lockDialogController?.close();
  }

  // 设置为我
  private showSetForMeDialog(setForMeMessage: Resource, confirmCallback?: Function, cancelCallback?: Function,
    albumInfoSetMe?: AlbumInfo): void {
    Log.info(TAG, 'SHOW_SET_FOR_ME ');
    this.dialogMessage = setForMeMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.albumInfoSetMe = albumInfoSetMe;
    this.setForMeDialogController?.open();
    this.setForMeDialogOpenFlag = true;
  }

  private hideSetForMeDialog(): void {
    Log.info(TAG, 'HIDE_SET_FOR_ME');
    this.setForMeDialogOpenFlag = false;
    this.setForMeDialogController?.close();
  }

  private showReplaceDialog(confirmCallback?: Function,
    cancelCallback?: Function, albumInfoIsMe?: AlbumInfo, albumInfoSetMe?: AlbumInfo): void {
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.albumInfoIsMe = albumInfoIsMe;
    this.albumInfoSetMe = albumInfoSetMe;
    if (this.replaceMeDialogController instanceof CustomDialogController) {
      this.replaceMeDialogController?.open();
    }
    this.replaceMeDialogOpenFlag = true;
  }

  private hideReplaceMeDialog(): void {
    this.replaceMeDialogOpenFlag = false;
    if (this.replaceMeDialogController instanceof CustomDialogController) {
      this.replaceMeDialogController?.close();
    }
  }

  private showNewAlbumDialog(fileName: string, confirmCallback?: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
    this.renameFileName = fileName;
    this.inputText = fileName;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.newAlbumDialogController?.open?.();
    this.newAlbumDialogControllerFlag = true;
  }

  private closeNewAlbumDialog() {
    Log.info(TAG, 'closeNewAlbumDialog');
    this.newAlbumDialogController?.close?.();
    this.inputText = '';
    this.newAlbumDialogControllerFlag = false;
  }

  /**
   * 删除相册弹窗
   *
   * @param deleteMessage msg
   * @param confirmCallback positive callback
   * @param cancelCallback negative callback
   * @param isAlbumDelete isDelete
   * @param isExpandPositionParams unknown
   */
  private showDeleteDialog(deleteMessage: Resource[], confirmCallback: Function, cancelCallback:
    Function, isAlbumDelete: boolean, isExpandPositionParams: PositionParams, popoverDialog: boolean = false): void {
    Log.info(TAG, `SHOW_DELETE_DIALOG ${this.deleteDialogOpenFlag}`);
    if (this.deleteDialogOpenFlag) {
      // Handle the multi-click issue, after that the delete dialog can not close.
      return;
    }
    this.deleteDialogOpenFlag = true;
    this.isClearRecycle = isExpandPositionParams?.isClearRecycle;
    this.isHoldPosition = isExpandPositionParams?.isHoldPosition;
    this.refreshDialogs();
    this.dialogMessage = deleteMessage[0];
    this.dialogContent = deleteMessage[1];
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.createDeleteDialogController();
    Log.info(TAG,"popoverDialog: " + popoverDialog);
    if (!popoverDialog) {
      this.deleteDialogController?.open();
    }
    Log.info(TAG,"popoverDialog: " + popoverDialog);
    this.isAlbumDelete = isAlbumDelete;
    ShortCut.deleteDialogOpenFlag = true;
  }

  private hideDeleteDialog(): void {
    Log.info(TAG, 'HIDE_DELETE_DIALOG ');
    this.deleteDialogOpenFlag = false;
    ShortCut.deleteDialogOpenFlag = false;
    this.deleteDialogController?.close?.();
  }

  //隐藏
  private showHiddenDialog(hideMessage: Resource, confirmCallback: Function, cancelCallback:
    Function, isPhotoHide: boolean): void {
    Log.info(TAG, 'SHOW_HIDDEN_DIALOG ');
    this.dialogMessage = hideMessage;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.isCloseTip = false;
    this.hiddenDialogController?.open();
    this.isPhotoHide = isPhotoHide;
    this.hiddenDialogOpenFlag = true;
  }

  private hideHiddenDialog(): void {
    Log.info(TAG, 'HIDE_HIDDEN_DIALOG ');
    this.hiddenDialogOpenFlag = false;
    this.hiddenDialogController?.close();
  }

  private hideProbablyIsMeDialog(): void {
    Log.info(TAG, 'HIDE_PROBABLY_IS_ME_DIALOG ');
    this.probablyIsMeDialogControllerFlag = false;
    this.probablyIsMeDialogController?.close();
  }

  private showRemoveDialog(removeMessage: Resource, removeMsgContent: Resource, confirmCallback?: Function,
    cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_REMOVE_DIALOG ');
    this.dialogMessage = removeMessage;
    this.dialogContent = removeMsgContent;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.removeDialogController?.open?.();
    this.removeDialogOpenFlag = true;
  }

  private hideRemoveDialog(): void {
    Log.info(TAG, 'HIDE_REMOVE_DIALOG ');
    this.removeDialogOpenFlag = false;
    this.removeDialogController?.close?.();
  }

  private showRenamePhotoDialog(fileName: string, confirmCallback?: Function, cancelCallback?: Function): void {
    Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
    this.renameFileName = fileName;
    this.inputText = fileName;
    this.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
    this.renameFileDialogController?.open?.();
    this.renameFileDialogControllerFlag = true;
  }

  private closeRenamePhotoDialog(): void {
    this.renameFileDialogController?.close?.();
    this.inputText = '';
    this.renameFileDialogControllerFlag = false;
  }

  private showProgressDialog(message: Resource, cancelFunc?: Function, cancelDelay?: boolean,
    msgWidth?: number, custom?: CustomBuilderParam): void {
    Log.info(TAG, `SHOW_PROGRESS_DIALOG msgWidth=${msgWidth}, cancelFunc=${cancelFunc}`);
    this.progressParam.progress = 0;
    this.progressParam.message = message;
    this.progressParam.custom = custom;
    this.progressTarget = 0;
    this.progressDisplay = 0;
    this.progressParam.progress = 0;
    if (cancelFunc && typeof cancelFunc === 'function') {
      this.progressParam.cancelFunc = cancelFunc;
    } else {
      this.progressParam.cancelFunc = (): void => {
        Log.info(TAG, 'Default cancel function called');
        this.broadCast.emit(BroadCastConstants.CANCEL_PROGRESS_DIALOG, []);
      };
    }
    this.progressParam.msgWidth = msgWidth;
    this.progressDialogDelayOpenFlag = true;
    this.progressDialogTimeoutHdl = setTimeout((): void => {
      if (this.progressDialogController && this.progressDialogDelayOpenFlag) {
        this.progressStartTime = Date.now();
        this.progressDialogController?.open?.();
        this.progressDialogOpenFlag = true;
      }
    }, cancelDelay ? 0 : Constants.PROGRESS_SHOW_TIME_THRESHOLD);
  }

  private hideProgressDialog(): void {
    Log.info(TAG, 'HIDE_PROGRESS_DIALOG ');
    if (Number.isFinite(this.progressAnimTimer)) {
      clearInterval(this.progressAnimTimer);
      this.progressAnimTimer = Number.NaN;
    }
    if (Number.isFinite(this.progressCloseTimeout)) {
      clearTimeout(this.progressCloseTimeout);
      this.progressCloseTimeout = Number.NaN;
    }
    if (this.progressDialogDelayOpenFlag && !this.progressDialogOpenFlag) {
      clearTimeout(this.progressDialogTimeoutHdl);
    }
    this.progressDialogController?.close?.();
  }

  private reshowProgressDialog(): void {
    Log.info(TAG, 'RESHOW_PROGRESS_DIALOG ');
    this.progressDialogController?.open?.();
  }

  private updateProgress(progress: number, currentCount: number): void {
    Log.info(TAG, `UPDATE_PROGRESS ${progress}, progressDisplay: ${this.progressDisplay}, progressTarget: ${this.progressTarget}`);
    if (Number.isFinite(this.progressAnimTimer)) {
      clearInterval(this.progressAnimTimer);
      this.progressAnimTimer = Number.NaN;
    }
    this.progressTarget = Math.min(Math.max(progress, 0), 100);
    this.progressDisplay = this.progressTarget;
    this.progressParam.progress = this.progressDisplay;

    if (progress == 100) {
      Log.info(TAG, 'Update progress 100%, ensuring minimum display time');
      if (Number.isFinite(this.progressCloseTimeout)) {
        clearTimeout(this.progressCloseTimeout);
      }
      const now: number = Date.now();
      const elapsed: number = this.progressStartTime ? now - this.progressStartTime : 0;
      const minVisibleRemainder: number =
        elapsed < this.MIN_PROGRESS_VISIBLE_TIME ? this.MIN_PROGRESS_VISIBLE_TIME - elapsed : 0;
      const delay: number = minVisibleRemainder + this.PROGRESS_HOLD_MS_AFTER_100;
      Log.info(TAG, `Progress reached 100%, elapsed: ${elapsed}ms, delay: ${delay}ms`);
      this.progressCloseTimeout = setTimeout((): void => {
        Log.info(TAG, 'Closing progress dialog after showing 100% for sufficient time');
        this.progressDialogOpenFlag = false;
        this.progressDialogDelayOpenFlag = false;
        this.progressDialogController?.close?.();
        this.progressCloseTimeout = Number.NaN;
        this.broadCast.emit(BroadCastConstants.PROGRESS_DIALOG_COMPLETED, []);
      }, delay);
    }
  }

  private cancelOperate(cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void {
    this.cancelMessage = cancelMessage;
    this.cancelParam.continueFunc = (): void => {
      continueFunc();
      this.reshowProgressDialog();
    };
    this.cancelParam.cancelFunc = (): void => {
      cancelFunc();
    };
    Log.info(TAG, `CANCEL_OPERATE, Check whether the cancelParam variable not exists: ${!this.cancelParam}`);
    this.progressDialogController?.close?.();
    this.cancelDialogController?.open?.();
  }

  private showCleanupImmediatelyDialog(cancelCallback: Function, confirmCallback: Function): void {
    Log.info(TAG, 'show cloud optimize storage dialog');
    this.dialogCallback = {
      cancelCallback: cancelCallback,
      confirmCallback: confirmCallback,
    };
    this.cleanupImmediatelyDialogController?.open?.();
    this.cleanupImmediatelyOpenFlag = true;
  }

  private showCleanupNoSpaceReleaseDialog(cancelCallback: Function, confirmCallback: Function): void {
    Log.info(TAG, 'show cloud optimize storage dialog');
    this.dialogCallback = {
      cancelCallback: cancelCallback,
      confirmCallback: confirmCallback,
    };
    this.cleanupNoSpaceReleaseDialogController?.open?.();
    this.cleanupNoSpaceReleaseOpenFlag = true;
  }

  private showCleanupImmediatelyLoadingDialog(cancelCallback: Function, confirmCallback: Function): void {
    Log.info(TAG, 'show cloud optimize storage dialog');
    this.dialogCallback = {
      cancelCallback: cancelCallback,
      confirmCallback: confirmCallback,
    };
    this.cleanupImmediatelyLoadingDialog?.open?.();
    this.cleanupImmediatelyLoadingOpenFlag = true;
  }

  private closeCleanupImmediatelyDialog(): void {
    Log.info(TAG, 'close cloud optimize storage dialog');
    this.cleanupImmediatelyDialogController?.close?.();
    this.cleanupImmediatelyOpenFlag = false;
  }

  private closeCleanupNoSpaceReleaseDialog(): void {
    Log.info(TAG, 'close cloud no optimize storage dialog');
    this.cleanupNoSpaceReleaseDialogController?.close?.();
    this.cleanupNoSpaceReleaseOpenFlag = false;
  }

  private closeCleanupImmediatelyLoadingDialog(): void {
    Log.info(TAG, 'close cloud optimizing storage dialog');
    this.cleanupImmediatelyLoadingDialog?.close?.();
    this.cleanupImmediatelyLoadingOpenFlag = false;
  }

  private showNetworkConnectionSwitchDialog(cancelCallback: Function, confirmCallback: Function): void {
    Log.info(TAG, 'open Network Connection switch dialog');
    this.dialogCallback = {
      cancelCallback: cancelCallback,
      confirmCallback: confirmCallback,
    };
    this.networkConnectionSwitchDialogController?.open?.();
    this.networkConnectionSwitchDialogOpenFlag = true;
  }

  private closeNetworkConnectionSwitchDialog(): void {
    Log.info(TAG, 'close Network Connection switch dialog');
    this.networkConnectionSwitchDialogController?.close?.();
    this.networkConnectionSwitchDialogOpenFlag = false;
  }

  private showMediaAnalysisServiceSwitchDialog(cancelCallback: Function, confirmCallback: Function): void {
    Log.info(TAG, 'show cloud sync switch dialog');
    this.dialogCallback = {
      cancelCallback: cancelCallback,
      confirmCallback: confirmCallback,
    };
    this.mediaAnalysisServiceSwitchDialogController?.open?.();
    this.mediaAnalysisServiceSwitchDialogOpenFlag = true;
  }

  private closeMediaAnalysisServiceSwitchDialog(): void {
    Log.info(TAG, 'close cloud sync switch dialog');
    getContext().eventHub.emit(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE);
    this.mediaAnalysisServiceSwitchDialogController?.close?.();
    this.mediaAnalysisServiceSwitchDialogOpenFlag = false;
  }

  private showDownloadProgressDialog(uri: string): void {
    Log.info(TAG, 'show download progress dialog');
    this.downloadUri = uri;
    this.downloadProgressDialogController?.open?.();
  }

  private closeDownloadProgressDialog(): void {
    Log.info(TAG, 'close download progress dialog');
    this.downloadProgressDialogController?.close?.();
  }

  private showBatchDownloadProgressDialog(cancel?: () => void): void {
    Log.info(TAG, `show download progress dialog ${cancel}`);
    this.batchDownloadCancelRegistry?.register(cancel);
    this.batchDownloadProgressDialogController?.open?.();
  }

  private closeBatchDownloadProgressDialog(): void {
    Log.info(TAG, 'close download progress dialog');
    AppStorage.setOrCreate<number>('batchDownloadProgress', 0);
    this.batchDownloadProgressDialogController?.close?.();
    this.batchDownloadCancelRegistry?.clear();
  }

  private showEditSaveProgressDialog(): void {
    Log.info(TAG, 'SHOW_EDIT_SAVE_PROGRESS_DIALOG');
    this.saveImageDialogController?.open?.();
  }

  private showCopyOrMoveDialog(copyFunc: Function): void {
    Log.info(TAG, 'SHOW_COPY_OR_MOVE_DIALOG');
    this.operateParam.copyFunc = copyFunc;
    this.copyOrMoveDialogController?.open?.();
  }

  private showMoveDialog(repeatPhotos: PhotoAsset[], replaceCallback: Function, skipCallback: Function,
    cancelCallback: Function): void {
    Log.info(TAG, 'SHOW_MOVE_DIALOG');
    this.repeatPhotos = repeatPhotos;
    this.moveDialogCallback = {
      replaceCallback: replaceCallback, skipCallback: skipCallback,
      cancelCallback: cancelCallback,
    };
    this.moveDialogController?.open?.();
  }

  private hideMoveDialog(): void {
    Log.info(TAG, 'HIDE_MOVE_DIALOG ');
    this.moveDialogController?.close?.();
  }

  private promptNewAlbumsDialog(cancelCallback: Function, newCallback: Function): void {
    Log.info(TAG, 'PROMPT_NEW_ALBUMS_DIALOG');
    this.dialogMessage = $r('app.string.prompt_new_album_dialog_message');
    this.dialogCallback = { confirmCallback: newCallback, cancelCallback: cancelCallback };
    this.promptNewAlbumsDialogController?.open?.();
    this.promptDialogOpenFlag = true;
  }

  private hidePromptDialog(): void {
    Log.info(TAG, 'HIDE_PROMPT_DIALOG ');
    this.promptDialogOpenFlag = false;
    this.promptNewAlbumsDialogController?.close?.();
  }

  private buildDialogBroadCast(): void {
    this.broadCast.on(BroadCastConstants.SHOW_LOCK_DIALOG, this.showLockDialogFunc);
    this.broadCast.on(BroadCastConstants.HIDE_LOCK_DIALOG, this.hideLockDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_DELETE_DIALOG, this.showDeleteDialogFunc);
    this.broadCast.on(BroadCastConstants.HIDE_DELETE_DIALOG, this.hideDeleteDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_HIDDEN_DIALOG, this.showHiddenDialogFunc); //隐藏
    this.broadCast.on(BroadCastConstants.SHOW_REMOVE_DIALOG, this.showRemoveDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_MOVE_DIALOG, this.showMoveDialogFunc); // 移动弹窗
    this.broadCast.on(BroadCastConstants.HIDE_MOVE_DIALOG, this.hideMoveDialogFunc); // 隐藏移动弹窗
    this.broadCast.on(BroadCastConstants.SHOW_RENAME_PHOTO_DIALOG, this.showRenamePhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.HIDE_RENAME_PHOTO_DIALOG, this.hideRenamePhotoDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_PROGRESS_DIALOG, this.showProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.HIDE_PROGRESS_DIALOG, this.hideProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_PROGRESS, this.updateProgressFunc);
    this.broadCast.on(BroadCastConstants.CANCEL_OPERATE, this.cancelOperateFunc);
    this.broadCast.on(BroadCastConstants.CLOSE_CLEANUP_NO_SPACE_RELEASE_DIALOG,
      this.closeCleanupNoSpaceReleaseDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_NETWORK_CONNECTION_SWITCH_DIALOG,
      this.showNetworkConnectionSwitchDialogFunc);
    this.broadCast.on(BroadCastConstants.CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG,
      this.closeNetworkConnectionSwitchDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, this.showDownloadProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.CLOSE_DOWNLOAD_PROGRESS_DIALOG, this.closeDownloadProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_BATCH_DOWNLOAD_PROGRESS_DIALOG, this.showBatchDownloadProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.CLOSE_BATCH_DOWNLOAD_PROGRESS_DIALOG,
      this.closeBatchDownloadProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_EDIT_SAVE_PROGRESS_DIALOG, this.showEditSaveProgressDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG, this.showNewAlbumDialogFunc);
    this.broadCast.on(BroadCastConstants.HIDE_NEW_ALBUM_PHOTO_DIALOG, this.hideNewAlbumDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_COPY_OR_MOVE_DIALOG, this.showCopyOrMoveDialogFunc);
    this.broadCast.on(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, this.promptNewAlbumsDialogFunc);
    this.broadCast.on(BroadCastConstants.SHOW_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
      this.showMediaAnalysisServiceSwitchDialogFunc);
    this.broadCast.on(BroadCastConstants.CLOSE_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG,
      this.closeMediaAnalysisServiceSwitchDialogFunc);
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.buildAdvancedDialog();
    this.buildProgressDialog();
    this.buildDialogs(false);
    this.buildDialogBroadCast();
    /* instrument ignore next */
    if (DeviceInfo.isSmallFoldScreen()) {
      this.foldStatusChange();
    }
    if (DeviceInfo.isFoldablePhone()) {
      try {
        display.on('foldStatusChange', this.onFoldStatusChange);
      } catch (e) {
        Log.error(TAG, 'register callback failed')
      }
    }
    this.dialogBroadCast.on(BroadCastConstants.HIDE_DELETE_DIALOG, this.hideDeleteDialogFunc);
    this.dialogBroadCast.on(BroadCastConstants.HIDE_HIDDEN_DIALOG, this.hideHiddenDialogFunc); //隐藏
    this.dialogBroadCast.on(BroadCastConstants.HIDE_REMOVE_DIALOG, this.hideRemoveDialogFunc);
    this.dialogBroadCast.on(BroadCastConstants.HIDE_MOVE_DIALOG, this.hideMoveDialogFunc);
    this.dialogBroadCast.on(BroadCastConstants.HIDE_PROMPT_DIALOG, this.hidePromptDialogFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    getScreen().on(ScreenManager.ON_ORIENTATION_CHANGED, this.onWinScreenRotationChangedCallBack);
  }

  build() {

  }

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
    } catch (e) {
      Log.error(TAG, `foldStatusChange error: stack${e?.stack}, code: ${e?.code}`);
    }
  }

  private isHalfFoldStateEnable(): boolean {
    return DeviceInfo.isSmallFoldScreen() && !this.isLemFoldState && !this.isHorizontal;
  }

  /**
   * 窗口大小变化回调
   */
  private onWinSizeChanged(): void {
    Log.info(TAG, `onWinSizeChanged`)
    try {
      let displayClass: display.Display = display.getDefaultDisplaySync();
      this.disScreenWidth = displayClass.width;
    } catch (e) {
      Log.error(TAG, `getDefaultDisplaySync error: stack${e?.stack}, code: ${e?.code}`);
    }
    // 窗体变化回调比横竖屏回调方法块，横竖屏判断异常
    setTimeout((): void => {
      const isFloatingWindow: boolean = getScreen().isFloatModeReal() || getScreen().getWinMode() === WindowMode.FLOATING;
      // xxx展开太横竖屏旋转不需要位置变更
      if (DeviceInfo.isFoldable() && !getScreen().isSplitModeReal() && !isFloatingWindow &&
        !this.isNeedDelDialogPositionChange) {
        return;
      }
      this.processDeleteDialogPositionChange();
    }, DELETE_DIALOG_CREATE_TIMEOUT_MS)
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
   * 窗体发生旋转变化回调
   */
  private onWinScreenRotationChanged(): void {
    Log.info(TAG, 'onWinScreenRotationChanged')
    if (DeviceInfo.isFoldable()) {
      this.isNeedDelDialogPositionChange = false;
    }
  }

  private processDeleteDialogPositionChange(): void {
    if (this.deleteDialogOpenFlag && DeviceInfo.isPhoneUx()) {
      // 先关闭再开启可触发位置变化
      this.deleteDialogController?.close();
      this.createDeleteDialogController();
      this.deleteDialogController?.open();
    }
  }

  private onFoldStatusChange: Callback<display.FoldStatus> = (status: display.FoldStatus) => {
    if (status === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isNeedDelDialogPositionChange = true;
    }
  }

}