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

import lazy { Log } from '../../utils/Log';
import type { SelectManager } from '../../model/browser/SelectManager';
import type { MenuContext } from './MenuContext';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import type { MediaItem } from '../../model/browser/photo/MediaItem';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { display, window } from '@kit.ArkUI';
import lazy { getScreen } from '../../model/common/ScreenManager';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { BroadCast } from '../../utils/BroadCast'
import type { MenuOptionOtherParams } from './interfaces';
import lazy { MenuContextConstants } from '../../model/common/MenuContextConstants';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { ImageUtil } from '../../utils/ImageUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { MenuConstants } from '../actionbar/Menu';
import lazy { DataListener, LoadingResult } from '../../model/DataSource';

const TAG: string = 'DeleteMenuOperation';
const DELETE: string = 'single_photo_delete';

/**
 * 调整删除弹窗位置的参数，目前仅xxx需要
 * isClearRecycle: 是否是由“清空最近删除”按钮触发的删除弹窗
 * isHoldPosition: 是否是由图片长按触发的删除弹窗
 */
export interface PositionParams {
  isClearRecycle?: boolean;
  isHoldPosition?: boolean;
}

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
const PAGE_LIST: string [] = [Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER,Constants.MEDIA_OPERATION_FROM_PHOTO_GRID,
  Constants.MEDIA_OPERATION_FROM_TIMELINE,Constants.MEDIA_OPERATION_FROM_HIDDEN_PHOTO_GRID];

export class DeleteMenuOperation extends ProcessMenuOperation {
  readonly BATCH_SIZE: number = 100;
  private readonly PROGRESS_MESSAGE_WIDTH: number = 120;
  private readonly MAX_LOAD_DATA_COST_TIME: number = 3000;
  private readonly NAVIGATE_AFTER_PROGRESS_CLOSE_TIMEOUT: number = 1500;
  private isTrash = true;
  public isClear = false;
  public isHoldPosition: boolean = false;
  /* instrument ignore next */
  private deleteCancelFunc: Function = (): void => {
    this.cancelFunc();
  };
  private deletePhotoType: string = '';
  private isLemFoldState: boolean = display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
  private retentionDays: number = 30;
  private isShowProgress: boolean = true;
  private allowedToClick: boolean = true;
  private clickDelay: number = 300;
  private clickedPath: Set<string> = new Set();
  private inverseSelection: boolean = false;
  private isCloseDeleteProgressPending: boolean = false;
  private isWaitingDataRefreshToComplete: boolean = false;
  private hasNavigatedAfterProgressComplete: boolean = false;
  private navigateAfterProgressCloseTimeout: number = Number.NaN;
  private onProgressDialogCompletedListener: Function | undefined = undefined;
  private dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(),
  };
  private progressDialogTimeout: number = Number.NaN;
  private completedFilesCount: number = 0;

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.operationType = 'DELETE_PHOTOS';
    this.traceOperationType = 'DELETE_PHOTOS';
  }

  private onDataLoadingFinished(): void {
    if (this.isCloseDeleteProgressPending && this.currentBatch >= this.totalBatches) {
      Log.info(TAG, `onDataLoadingFinished: currentBatch = ${this.currentBatch}, totalBatches = ${this.totalBatches}`);
      this.clearProgressDialogTimer();
      this.resetStateAndUpdateProgress();
    }
  }

  private resetStateAndUpdateProgress() {
    Log.info(TAG, `resetState`);
    this.isCloseDeleteProgressPending = false;
    this.isWaitingDataRefreshToComplete = false;
    this.menuContext.dataSource?.removeListener(this.dataListener);

    this.completedFilesCount = this.count;
    super.updateProgress(100, this.count);

    this.waitProgressDialogClosedThenNavigate();
  }

  private clearNavigateAfterProgressCloseTimer(): void {
    if (!Number.isFinite(this.navigateAfterProgressCloseTimeout)) {
      return;
    }
    clearTimeout(this.navigateAfterProgressCloseTimeout);
    this.navigateAfterProgressCloseTimeout = Number.NaN;
  }

  private clearProgressDialogCompletedListener(): void {
    if (!this.onProgressDialogCompletedListener) {
      return;
    }
    this.menuContext?.broadCast?.off?.(BroadCastConstants.PROGRESS_DIALOG_COMPLETED, this.onProgressDialogCompletedListener);
    this.onProgressDialogCompletedListener = undefined;
  }

  private waitProgressDialogClosedThenNavigate(): void {
    if (this.hasNavigatedAfterProgressComplete) {
      return;
    }
    if (!this.isShowProgress || !this.menuContext?.broadCast) {
      this.hasNavigatedAfterProgressComplete = true;
      setTimeout((): void => this.navigationPageFunc?.(), 0);
      return;
    }

    this.clearNavigateAfterProgressCloseTimer();
    this.clearProgressDialogCompletedListener();

    this.onProgressDialogCompletedListener = (): void => {
      this.clearNavigateAfterProgressCloseTimer();
      this.clearProgressDialogCompletedListener();
      if (this.hasNavigatedAfterProgressComplete) {
        return;
      }
      this.hasNavigatedAfterProgressComplete = true;
      setTimeout((): void => this.navigationPageFunc?.(), 0);
    };

    this.menuContext.broadCast.on(BroadCastConstants.PROGRESS_DIALOG_COMPLETED, this.onProgressDialogCompletedListener);

    this.navigateAfterProgressCloseTimeout = setTimeout((): void => {
      Log.warn(TAG, `waitProgressDialogClosedThenNavigate timeout, navigating anyway`);
      this.clearProgressDialogCompletedListener();
      if (this.hasNavigatedAfterProgressComplete) {
        return;
      }
      this.hasNavigatedAfterProgressComplete = true;
      this.navigationPageFunc?.();
    }, this.NAVIGATE_AFTER_PROGRESS_CLOSE_TIMEOUT);
  }

  private setClearProgressDialogTimer() {
    if (Number.isFinite(this.progressDialogTimeout)) {
      return;
    }
    Log.info(TAG, `setClearProgressDialogTimer`);
    this.progressDialogTimeout = setTimeout((): void => {
      Log.info(TAG, `handle time out`);
      this.resetStateAndUpdateProgress();
    },  this.MAX_LOAD_DATA_COST_TIME);
  }

  private clearProgressDialogTimer(): void {
    if (!Number.isFinite(this.progressDialogTimeout)) {
      return;
    }
    clearTimeout(this.progressDialogTimeout);
    this.progressDialogTimeout = Number.NaN;
    Log.info(TAG, `clearProgressDialogTimer`);
  }

  public setConfirmText(): void {
    const dialog = this.isTrash ? $r('app.string.dialog_delete') : $r('app.string.dialog_delete_permanently');
    AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, dialog);
  }

  public doAction(): void {
    Log.info(TAG, 'DeleteMenuOperation!');
    /* instrument ignore if */
    if (!this.menuContext) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    this.count = 1;
    const selectManager: SelectManager | undefined = this.menuContext.selectManager;
    if (selectManager) {
      this.count = selectManager.getSelectedCount();
      this.totalCount = this.count;
      if (this.count <= 0) {
        Log.error(TAG, 'count <= 0, return');
        return;
      }
    }
    Log.debug(TAG, 'prepare selectManager complete');
    const mediaItem: MediaItem | undefined = this.menuContext.mediaItem;
    if (mediaItem) {
      /* instrument ignore if */
      if (mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        this.deletePhotoType = 'image';
      } else if (mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        this.deletePhotoType = 'video';
      }
    }
    Log.debug(TAG, 'prepare selectManager complete');
    if (this.menuContext.albumInfo?.isTrashAlbum) {
      this.isTrash = false;
    }
    this.setConfirmText();

    let locationParams: PositionParams = {
      isClearRecycle: this.isClear,
      isHoldPosition: this.isHoldPosition,
    };
    if (this.menuContext.isSkipDeleteDialog) {
      this.confirmCallback();
    } else {
      if (this.isLemFoldState) {
        this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_SUB_SCREEN_DELETE_DIALOG,
          [this.confirmCallback, this.cancelCallback]);
      } else if (DeviceInfo.isFoldable() && getScreen().getWindowStatusType() === window.WindowStatusType.FULL_SCREEN &&
        !this.menuContext.fromLongPress
        && this.menuContext.fromPage && PAGE_LIST.includes(this.menuContext.fromPage)) {
        appBroadCast.emit(BroadCastConstants.SHOW_DELETE_POPOVER_DIALOG,
          [this.getDialog(), this.delayConfirmCallback, this.delayCancelCallback, false, locationParams]);
        this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
          [this.getDialog(), this.delayConfirmCallback, this.delayCancelCallback, false, locationParams, true]);
      } else {
        this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_DELETE_DIALOG,
          [this.getDialog(), this.delayConfirmCallback, this.delayCancelCallback, false, locationParams]);
      }
    }
  }

  // Asynchronous callback for selectedCallback
  /* instrument ignore next */
  callback = (uris: string[]): void => {
    if (this.isCancelled) {
      Log.info(TAG, 'deleteMenuOperation callback isCancelled, return');
      return;
    }
    this.uris = uris;
    this.processOperation();
  };

  public selectAssetCallback(assets: PhotoAsset[]): void {
    this.selectAssets = assets;
    Log.info(TAG, `selectAssetCallback ${this.selectAssets.length}`);
    this.processOperation();
  }

  public processOperation(): void {
    Log.info(TAG, 'processOperation start');
    this.completedFilesCount = 0;
    this.hasNavigatedAfterProgressComplete = false;
    this.clearNavigateAfterProgressCloseTimer();
    this.clearProgressDialogCompletedListener();
    super.processOperation();
  }

  public getExpectProgress(): number {
    Log.info(TAG, 'getExpectProgress');
    if (this.count === 0) {
      return this.MAX_PROGRESS;
    }
    let completedFiles: number = this.completedFilesCount;
    completedFiles = Math.min(completedFiles, this.count);
    let progress = Math.min(Math.floor(this.MAX_PROGRESS * completedFiles / this.count), this.MAX_PROGRESS);
    Log.info(TAG, `getExpectProgress result: ${progress}%, completedFiles: ${completedFiles}`);
    return progress;
  }

  private isGalleryCleanupPage(): boolean {
    return this.menuContext.fromPage === Constants.VIDEO_CLEANUP_PAGE ||
      this.menuContext.fromPage === Constants.GRID_CLEANUP_PAGE;
  }

  private addCompletedFilesCount(count: number): void {
    this.completedFilesCount += count;
    Log.info(TAG, `addCompletedFilesCount: added ${count} files, total completedFilesCount: ${this.completedFilesCount}`);
    let completedCount: number = Math.min(this.completedFilesCount, this.count);
    let progress: number = this.getExpectProgress();
    this.updateProgress(progress, completedCount);
  }

  // Delete a batch of data
  public async requestOneBatchOperation(): Promise<void> {
    Log.info(TAG, 'requestOneBatchOperation');
    if (this.isCancelled) {
      return;
    }
    this.currentBatch++;

    const isTrash: boolean | undefined =
      this.menuContext.albumInfo?.isTrashAlbum || this.isGalleryCleanupPage();
    Log.info(TAG, `requestOneBatchOperation: isTrash=${isTrash}`);

    const msg: Record<string, number | string | boolean | undefined> = { 'isTrashAlbum': isTrash };
    ReportToBigDataUtil.report(BigDataConstants.DELETE_FILE_OPERATION_START, msg);
    TraceControllerUtils.startTraceWithTaskId(isTrash ? 'delete' : 'trash', this.currentBatch);
    if (this.inverseSelection) {
      if (this.initialTotalCount === undefined && this.menuContext.selectManager) {
        this.initialTotalCount = this.menuContext.selectManager.totalCount;
        Log.info(TAG, `requestOneBatchOperation: captured initialTotalCount=${this.initialTotalCount} for inverseSelection`);
      }
      if (this.initialTotalCount !== undefined) {
        this.totalCount = this.initialTotalCount;
        this.totalBatches = Math.ceil(this.initialTotalCount / this.BATCH_SIZE);
        Log.info(TAG, `requestOneBatchOperation: using initialTotalCount=${this.initialTotalCount}, totalBatches=${this.totalBatches}, current selectManager.totalCount=${this.menuContext.selectManager?.totalCount}`);
      }
    } else {
      this.setTotalForInverseSelection();
    }
    const startIndex: number = (this.currentBatch - 1) * this.BATCH_SIZE;
    let endIndex: number = Math.min(this.currentBatch * this.BATCH_SIZE, this.count);
    // 单个删除照片 - 连拍照片处理
    if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
      endIndex = Math.min(this.currentBatch * this.BATCH_SIZE, this.menuContext.burstPhotos.length);
    }
    // 批量删除 - 连拍照片处理
    if (this.menuContext.selectManager) {
      const assetsLength = isTrash ? this.selectAssets?.length : this.uris?.length;
      endIndex = Math.min(this.currentBatch * this.BATCH_SIZE, assetsLength);
    }
    let batchUris: string[] = [];
    let batchAssets: PhotoAsset[] = [];
    let length = this.inverseSelection ? (this.initialTotalCount ?? this.totalCount ?? 0) : (this.totalCount ?? 0);
    // 计算查询起始位置
    let start = length - (this.currentBatch * this.BATCH_SIZE) > 0 ? length - (this.currentBatch * this.BATCH_SIZE) : 0;
    Log.info(TAG, `requestOneBatchOperation: length=${length} (initialTotalCount=${this.initialTotalCount}, totalCount=${this.totalCount}), currentBatch=${this.currentBatch}, totalBatches=${this.totalBatches}, start=${start}, selectManager.totalCount=${this.menuContext.selectManager?.totalCount}, inverseSelection=${this.inverseSelection}`)
    /* instrument ignore if */
    if (this.inverseSelection) {
      // 反选时分批查询
      if (isTrash && this.clickedPath) {
        this.menuContext.selectManager?.batchGetSelectAssetsWidthBurstPhotos(async (assets: PhotoAsset[]) => {
          batchAssets = assets;
          await this.doDeleteOperation(isTrash, batchUris, batchAssets);
        }, this.clickedPath, this.inverseSelection, true, start, this.BATCH_SIZE, this.currentBatch);
      } else if (this.clickedPath) {
        Log.info(TAG, `requestOneBatchOperation, clickedPath.size: ${this.clickedPath.size}`)
        this.menuContext.selectManager?.batchGetSelectAssetsWidthBurstPhotos(async (assets: PhotoAsset[]) => {
          batchUris = assets.map(item => item.uri);
          Log.info(TAG, `batchUris length is ${batchUris.length}`);
          if (batchUris.length <= 0) {
            this.isShowProgress = false;
          }
          await this.doDeleteOperation(isTrash, batchUris, batchAssets);
          Log.info(TAG, `requestOneBatchOperation uris length is ${batchUris.length}`);
        }, this.clickedPath, this.inverseSelection, false, start, this.BATCH_SIZE, this.currentBatch);
      }
    } else {
      if (isTrash) {
        batchAssets = this.selectAssets.slice(startIndex, Math.min(endIndex, this.selectAssets.length));
      } else {
        batchUris = this.uris.slice(startIndex, Math.min(endIndex, this.uris.length));
      }
      await this.doDeleteOperation(isTrash, batchUris, batchAssets);
    }
  }

  async doDeleteOperation(isTrash: boolean = false, batchUris: string[], batchAssets: PhotoAsset[]) {
    Log.info(TAG, `Start do delete operation for playAnime`)
    const operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);
    const BATCH_SIZE_FOR_PROGRESS: number = 50;
    let isFromSelectMode = true;
    Log.info(TAG, `Change isDoingDeleteBigPhotoAnim, fromPage:${this.menuContext.fromPage},
    batchUris: ${batchUris.length}, batchAssets: ${batchAssets.length}`);
    if (this.menuContext.fromPage === 'FromPhotoBrowser' &&
      ((!isTrash && batchUris.length !== 0) || (isTrash && batchAssets.length !== 0))) {
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', true);
      isFromSelectMode = false;
      this.playAnime();
      if (!this.menuContext.isSkipDeleteDialog) {
        this.menuContext.broadCast?.emit(BroadCastConstants.ON_DELETE_UI_FIRST, []);
      }
    }
    /* instrument ignore if */
    if (isTrash) {
      if (!this.isGalleryCleanupPage()) {
        this.reportTrashDeletedInfo(batchUris, isFromSelectMode);
      }
      // 将batchAssets拆分成小批次处理
      for (let i = 0; i < batchAssets.length; i += BATCH_SIZE_FOR_PROGRESS) {
        if (await this.waitIfPaused()) {
          Log.info(TAG, 'doDeleteOperation paused and cancelled, return');
          return;
        }
        if (this.isCancelled) {
          Log.info(TAG, 'doDeleteOperation is cancelled in batch loop, return');
          return;
        }
        let batchAssetsSub: PhotoAsset[] = batchAssets.slice(i, Math.min(i + BATCH_SIZE_FOR_PROGRESS, batchAssets.length));
        try {
          if (this.isGalleryCleanupPage() && batchAssetsSub.length > 0) {
            Log.info(TAG, `deleteAlbumAssetsPermanently: batchAssetsSub.length=${batchAssetsSub.length}`);
            await operationImpl.deleteAlbumAssetsPermanently(batchAssetsSub);
          } else {
            await operationImpl.deleteTrash(batchAssetsSub);
          }
          // 删除成功后，累加实际删除的文件数（用于逐张计算进度）
          this.addCompletedFilesCount(batchAssetsSub.length);
          await new Promise<void>((resolve: () => void) => setTimeout(resolve, 10));
        } catch (error) {
          Log.error(TAG, `delete operation failed: ${error}`);
          this.onError('on delete ' + String(error) + '; isTrash: ' + isTrash);
          return;
        }
      }
    } else {
      // 将batchUris拆分成小批次处理
      if (batchUris !== undefined && batchUris.length > 0) {
        for (let i = 0; i < batchUris.length; i += BATCH_SIZE_FOR_PROGRESS) {
          if (await this.waitIfPaused()) {
            Log.info(TAG, 'doDeleteOperation paused and cancelled, return');
            return;
          }
          if (this.isCancelled) {
            Log.info(TAG, 'doDeleteOperation is cancelled in batch loop, return');
            return;
          }
          let batchUrisSub: string[] = batchUris.slice(i, Math.min(i + BATCH_SIZE_FOR_PROGRESS, batchUris.length));
          try {
            await operationImpl.trash(batchUrisSub);
            // 删除成功后，累加实际删除的文件数（用于逐张计算进度）
            this.addCompletedFilesCount(batchUrisSub.length);
            await new Promise<void>((resolve: () => void) => setTimeout(resolve, 10));
          } catch (error) {
            Log.error(TAG, `trash operation failed: ${error}`);
            this.onError('on delete ' + String(error) + '; isTrash: ' + isTrash);
            return;
          }
        }
      } else {
        Log.error(TAG, `batchUris length is  ${batchUris?.length}`);
      }
    }
    // 所有批次处理完成后，调用reportFinish
    if (this.menuContext.fromPage !== 'FromPhotoBrowser') {
      this.playAnime();
    }
    TraceControllerUtils.finishTraceWithTaskId(isTrash ? 'delete' : 'trash', this.currentBatch);
    if (!this.isGalleryCleanupPage()) {
      const msg: Record<string, number | string | boolean | undefined> = { 'isTrashAlbum': isTrash };
      ReportToBigDataUtil.report(BigDataConstants.DELETE_FILE_OPERATION_FINISH, msg);
    }
    batchUris.splice(0, batchUris.length);
    batchAssets.splice(0, batchAssets.length);
    // 调用onCompleted继续处理下一批
    this.onCompleted();
  }

  delayConfirmCallback = (): void => {
    if (!this.allowedToClick) {
      return;
    }
    this.confirmCallback();
    this.allowedToClick = false;
    /* instrument ignore next */
    setTimeout((): void => {
      this.allowedToClick = true;
      if (this.menuContext.fromPage === MenuConstants.KEY_PAGE_FROM_HIGHLIGHT) {
        this.menuContext.broadCast?.emit(BroadCastConstants.HIGHLIGHT_DELETE_CAROUSEL, []);
      }
    }, this.clickDelay)
  }
  confirmCallback = (): void => {
    let mediaItem = this.menuContext.mediaItem;
    const isTrash = this.menuContext.albumInfo?.isTrashAlbum || this.isGalleryCleanupPage();
    Log.info(TAG, `Delete confirming isTrash ${this.isTrash},` + ` count: ${this.count},` + ` uri: ${mediaItem?.uri}`);
    // 1. Variable initialization
    this.onOperationEnd = this.menuContext.onOperationEnd;
    let msg: Record<string, number | string | boolean> = {
      'count': this.count,
      'from': BigDataConstants.DELETE_PHOTO_LARGER_ALBUM,
    };
    if (mediaItem && this.count === 1) {
      this.confirmCallbackWithMediaItem(mediaItem, msg, isTrash);
      return;
    }
    // 2. selectManager gets the URI of the data and starts processing deletion in the callback
    const selectManager = this.menuContext.selectManager;
    if (selectManager && isTrash) {
      const isRightClickMenu =  this.menuContext.get<boolean>(MenuConstants.KEY_RIGHT_CLICK_MENU);
      if (!selectManager.mIsSelectedMode && !isRightClickMenu) {
        selectManager.inverseSelection = true;
      }
      this.inverseSelection = selectManager?.inverseSelection ?? false;
      if (this.inverseSelection && this.initialTotalCount === undefined) {
        this.initialTotalCount = selectManager.totalCount;
        Log.info(TAG, `confirmCallback: captured initialTotalCount=${this.initialTotalCount} for inverseSelection`);
      }
      if (selectManager.inverseSelection) {
        selectManager?.getClickedPath((clickedPath: Set<string>) => this.clickedPathCallback(clickedPath));
      } else {
        selectManager.getSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => this.selectAssetCallback(assets), true);
      }
    } else if (selectManager) {
      Log.info(TAG, `confirmCallback, this.inverseSelection: ${selectManager.inverseSelection}`);
      this.inverseSelection = selectManager?.inverseSelection ?? false;
      if (this.inverseSelection && this.initialTotalCount === undefined) {
        this.initialTotalCount = selectManager.totalCount;
        Log.info(TAG, `confirmCallback: captured initialTotalCount=${this.initialTotalCount} for inverseSelection`);
      }
      if (selectManager.inverseSelection) {
        selectManager?.getClickedPath((clickedPath: Set<string>) => this.clickedPathCallback(clickedPath));
      } else {
        selectManager.getSelectAssetsWidthBurstPhotos((assets: PhotoAsset[]) => {
          Log.info(TAG, `getSelectAssetsWidthBurstPhotos callback assets length is ${assets.length}`);
          const uris = assets.map(item => item.uri);
          if (uris.length <= 0) {
            this.isShowProgress = false;
          }
          if (DeviceInfo.isPcOrTablet()) {
            uris.forEach(uri => this.clickedPath.add(uri))
          }
          Log.info(TAG, `requestOneBatchOperation uris length is ${uris.length}`);
          this.callback(uris);
        });
      }
    }
    Log.info(TAG, 'selectManager processing deletion complete');

    // 3. onDeleteStart exit selection mode
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();
    if (this.menuContext.dataSource) {
      this.menuContext.dataSource?.addListener(this.dataListener);
      this.isCloseDeleteProgressPending = true;
      Log.info(TAG, 'onOperationStart: addListener' + this.menuContext.dataSource);
      this.menuContext.dataSource?.switchRefreshOn?.();
    }
    msg.from = BigDataConstants.BATCH_DELETE_PHOTO_GRID_ALBUM;
    ReportToBigDataUtil.report(BigDataConstants.DELETE_MENU_RESPONSE, msg);
    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, this.cancelProgress.bind(this));
    if (this.isClear && this.menuContext.albumInfo?.isTrashAlbum) {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.action_clear_process'), this.deleteCancelFunc, true, this.PROGRESS_MESSAGE_WIDTH]);
    } else {
      if (this.isShowProgress) {
        this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
          [$r('app.string.action_delete_process'), this.deleteCancelFunc, true,
            this.PROGRESS_MESSAGE_WIDTH]);
      }
    }
    // 删除结束后，搜索宫格页清空选中信息
    if (DeviceInfo.isPcOrTablet()) {
      Log.info(TAG, `CLEAR_SELECT`)
      selectManager?.updateSelectCount(Array.from(this.clickedPath))
      // 删除后清除选择状态
      this.menuContext.broadCast?.emit(BroadCastConstants.CLEAR_SELECT, []);
    }
  };

  private reportTrashDeletedInfo(batchUris: string[], isFromSelectMode: boolean) {
    let scene: string;
    const count = batchUris.length;
    /* instrument ignore else */
    if (this.isTrash) {
      //回收站 清空
      scene = 'clear';
    } else if (isFromSelectMode) {
      // 回收站 宫格
      scene = 'grid';
    } else {
      // 回收站 大图
      scene = 'brower';
    }
    const msg: Record<string, number | string | boolean> = {
      'scene': scene,
      'count': count,
    };
    ReportToBigDataUtil.report(BigDataConstants.DELETE_FROM_TRASH, msg);
  }

  clickedPathCallback(clickedPath: Set<string>): void {
    clickedPath.forEach((item) => {
      this.clickedPath?.add(item);
    });
    this.processOperation();
  }

  confirmCallbackWithMediaItem(mediaItem: MediaItem, msg: Record<string, string |
  number | boolean>, isTrash: boolean | undefined): void {
    if (this.menuContext.fromPage === Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER) {
      appBroadCast.emit(BroadCastConstants.CURRENT_DELETE_UNIQUEID, [mediaItem.uniqueId]);
    }
    /* instrument ignore if */
    if (isTrash && mediaItem.data) {
      this.selectAssets = [mediaItem.data];
      if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
        this.selectAssets = [...this.menuContext.burstPhotos.map(item => item.data)] as PhotoAsset[];
      }
    } else {
      this.uris = [mediaItem.uri];
      if (this.menuContext.isBurstPhotos && this.menuContext.burstPhotos) {
        this.uris = this.menuContext.burstPhotos.map(item => item.uri);
      }
    }
    this.processOperation();
    ReportToBigDataUtil.report(BigDataConstants.DELETE_MENU_RESPONSE, msg);
    if (this.isGalleryCleanupPage()) {
      Log.info(TAG, `confirmCallbackWithMediaItem:reportCleanupPageDeleteInfo!!`);
      this.reportDeleteInfo(this.menuContext.albumInfo, mediaItem);
      let onOperationStart: Function = this.menuContext.onOperationStart;
      onOperationStart?.();
    }
    if (this.menuContext.isFromHighlight) {
      setTimeout((): void => {
        this.menuContext.broadCast?.emit(BroadCastConstants.HIGHLIGHT_DELETE_CAROUSEL, []);
      }, this.clickDelay)
    }
    Log.info(TAG, 'Single delete confirmed');
  }

  public onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    this.cyclicOperation();
  }

  public cyclicOperation(): void {
    Log.info(TAG, 'cyclicOperation successBatch: ' + this.successBatch + ', currentBatch: ' + this.currentBatch +
      `  totalBatches: ` + this.totalBatches + `, completedFilesCount: ${this.completedFilesCount}`);
    let completedCount: number = Math.min(this.completedFilesCount, this.count);
    if (this.successBatch >= this.totalBatches) {
      Log.info(TAG, 'All batches completed, updating progress to 100%');
      if (this.completedFilesCount < this.count) {
        this.completedFilesCount = this.count;
      }
      this.updateProgress(this.MAX_PROGRESS, this.count);
      this.onProcessDone();
    } else {
      this.updateProgress(this.getExpectProgress(), completedCount);

      if (this.isCancelled) {
        this.isCancelled = false;
      }

      Log.info(TAG, 'requestOneBatchOperation');
      this.requestOneBatchOperation();
    }
  }

  public onProcessDone(): void {
    Log.info(TAG, 'onProcessDone');
    if (this.completedFilesCount < this.count) {
      this.completedFilesCount = this.count;
    }
    if (this.isCloseDeleteProgressPending) {
      this.isWaitingDataRefreshToComplete = true;
      this.updateProgress(99, this.count);
    } else {
      this.updateProgress(this.MAX_PROGRESS, this.count);
    }

    if (this.isCloseDeleteProgressPending) {
      Log.info(TAG, 'onProcessDone: waiting for data refresh, navigationPageFunc will be called after refresh');
    } else {
      this.navigationPageFunc?.();
    }
    if (this.startTime != null) {
      let operateCount = this.currentBatch >= this.totalBatches ? this.count : this.currentBatch * this.BATCH_SIZE;
      let costTime = Date.now() - this.startTime;
      Log.debug(TAG, `process data operate done, operate ${operateCount} items, cost time ${costTime} ms,\
            average ${(costTime / operateCount)} .`);
      let e2eLatency = Date.now() - this.startTime;
      if (e2eLatency >= BigDataConstants.FAULT_THRESHOLD && this.operationType === 'DELETE_PHOTOS') {
        Log.info(TAG, 'onProcessDone reportOperationLatency');
        ReportToBigDataUtil.reportOperationLatency(this.operationType, this.startTime, e2eLatency, operateCount);
      }
    }
    TraceControllerUtils.finishTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
    this.onOperationEnd?.(this.isError, this.successBatch, this.count);
    this.selectAssets.splice(0, this.selectAssets.length);
  }

  /* instrument ignore next */
  public cancelFunc(): void {
    Log.info(TAG, `Cancel delete operation, wait for confirmation...`);
    this.onOperatePause();
    let cancelMessage: Resource | undefined = undefined;
    const isTrash = this.menuContext.albumInfo?.isTrashAlbum || this.isGalleryCleanupPage();
    if (isTrash && this.isClear) {
      cancelMessage = $r('app.string.delete_permanently_clear_cancel_message',
        `${this.getExpectProgress().toString()}%`);
    }
    if (isTrash && !this.isClear) {
      cancelMessage = $r('app.string.delete_permanently_forever_cancel_message',
        `${this.getExpectProgress().toString()}%`);
    }
    if (!isTrash) {
      cancelMessage = $r('app.string.delete_cancel_message', `${this.getExpectProgress().toString()}%`);
    }
    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, (): void => {
        this.onOperateContinue();
      }, (): void => {
        this.onOperateCancelled();
      }]);
  }

  public getTestClickedPath(): Set<string> {
    return this.clickedPath;
  }

  delayCancelCallback = (): void => {
    if (!this.allowedToClick) {
      return;
    }
    this.cancelCallback();
    this.allowedToClick = false;
    /* instrument ignore next */
    setTimeout((): void => {
      this.allowedToClick = true;
    }, this.clickDelay)
  }
  protected cancelCallback = (): void => {
    Log.info(TAG, 'Batch delete cancel');
    this.setConfirmText();
    if (!this.menuContext.fromSelectMode) {
      this.menuContext.selectManager?.deSelectAll();
    }
  };

  private playAnime(): void {
    Log.info(TAG, 'Delete data succeed!');
    /* instrument ignore if */
    if (this.menuContext.fromSelectMode || this.menuContext.fromLongPress) {
      this.onCompleted();
      return;
    }
    this.menuContext.broadCast?.emit(DELETE, []);
  }

  private getCountDialog(cloudDriveStatus: boolean | undefined): (Resource)[] {
    if (this.deletePhotoType === 'image') {
      return this.isTrash ? (cloudDriveStatus ? [$r('app.string.recycle_picture_tips'),
        $r('app.string.cloud_picture_recycle_delete_kept_tips', this.retentionDays)] :
        [$r('app.string.recycle_picture_tips'), $r('app.string.recycle_delete_kept_tips', this.retentionDays)]) :
        (cloudDriveStatus ? [$r('app.string.recycle_tips'),
          $r('app.string.cloud_picture_dialog_delete_permanently_not_recover_tips')] :
          [$r('app.string.recycle_tips'), $r('app.string.picture_dialog_delete_permanently_not_recover_tips')]);
    }
    if (this.deletePhotoType === 'video') {
      return this.isTrash ? (cloudDriveStatus ? [$r('app.string.recycle_video_tips'),
        $r('app.string.cloud_video_recycle_delete_kept_tips', this.retentionDays)] :
        [$r('app.string.recycle_video_tips'), $r('app.string.recycle_delete_kept_tips', this.retentionDays)]) :
        (cloudDriveStatus ? [$r('app.string.recycle_tips'),
          $r('app.string.cloud_video_dialog_delete_permanently_not_recover_tips')] :
          [$r('app.string.recycle_tips'), $r('app.string.video_dialog_delete_permanently_not_recover_tips')]);
    }
    return this.isTrash ? (cloudDriveStatus ? [$r('app.string.recycle_single_file_tips'),
      $r('app.string.cloud_single_file_recycle_delete_kept_tips', this.retentionDays)] :
      [$r('app.string.recycle_single_file_tips'), $r('app.string.recycle_delete_kept_tips', this.retentionDays)]) :
      (cloudDriveStatus ? [$r('app.string.recycle_tips'),
        $r('app.string.cloud_single_file_dialog_delete_permanently_not_recover_tips')] :
        [$r('app.string.recycle_tips'), $r('app.string.recycleAlbum_delete_message')]);
  }

  private getDialog(): (Resource)[] {
    let cloudDriveStatus: boolean | undefined = AppStorage.get<boolean>('cloudDriveStatus');
    Log.info(TAG, `getDialog: cloudDriveStatus=${cloudDriveStatus}`);
    if (this.isGalleryCleanupPage()) {
      const deleteTextKey =
        cloudDriveStatus ? $r('app.string.dialog_delete') : $r('app.string.dialog_delete_permanently');
      AppStorage.setOrCreate<Resource>(Constants.CONFIRM_TEXT_KEY, deleteTextKey);
    }
    let menuOptionOtherParams: MenuOptionOtherParams | undefined =
      this.menuContext.get<MenuOptionOtherParams>(MenuContextConstants.MENU_OPTION_OTHER_PARAMS);
    if (menuOptionOtherParams?.isFromGalleryCleanup) {
      return this.menuContext.albumInfo?.isTrashAlbum ?
        this.getTrashCleanupPageDeleteDialog(cloudDriveStatus ?? false) :
        this.getPhotoCleanupPageDeleteDialog(cloudDriveStatus ?? false);
    } else if (this.menuContext.fromPage === Constants.VIDEO_CLEANUP_PAGE) {
      return this.getVideoCleanupPageDeleteDialog(cloudDriveStatus ?? false);
    }
    if (this.menuContext.selectManager?.isAllSelected) {
      return this.isTrash ? (cloudDriveStatus ? [$r('app.string.recycle_all_files_tips'),
        $r('app.string.cloud_all_files_recycle_delete_kept_tips', this.retentionDays)] :
        [$r('app.string.recycle_all_files_tips'), $r('app.string.recycle_delete_kept_tips', this.retentionDays)])
        : (cloudDriveStatus ? [$r('app.string.recycle_tips'),
          $r('app.string.cloud_all_files_dialog_delete_permanently_not_recover_tips')] :
          [$r('app.string.recycle_tips'), $r('app.string.recycleAlbum_delete_all_images_message')]);
    }
    if (this.count === 1) {
      return this.getCountDialog(cloudDriveStatus);
    }
    return this.isTrash ? (cloudDriveStatus ? [$r('app.plural.recycle_files_tips',
      this.count, this.count), $r('app.plural.cloud_files_recycle_delete_kept_tips',
      this.count, this.count, this.retentionDays, this.retentionDays)] :
      [$r('app.plural.recycle_files_tips', this.count,
        this.count), $r('app.string.recycle_delete_kept_tips', this.retentionDays)]) :
      (cloudDriveStatus ? [$r('app.string.recycle_tips'),
        $r('app.plural.cloud_files_dialog_delete_permanently_not_recover_tips', this.count, this.count)] :
        [$r('app.string.recycle_tips'), $r('app.plural.recycleAlbum_delete_multiple_images_message',
          this.count, this.count)]);
  }

  private getVideoCleanupPageDeleteDialog(cloudDriveStatus: boolean): (Resource)[] {
    if (cloudDriveStatus) {
      // 开启云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_videos_tips'),
          $r('app.string.cloud_delete_all_videos_can_download_tips')] :
          [$r('app.plural.recycle_videos_tips_plural', this.count, this.count),
            $r('app.plural.cloud_delete_videos_can_download_tips', this.count, this.count)];
      }
    } else {
      // 关闭云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_videos_tips'),
          $r('app.string.local_all_videos_dialog_delete_permanently_not_recover_tips')] :
          [$r('app.plural.recycle_videos_tips_plural', this.count, this.count),
            $r('app.plural.local_videos_dialog_delete_permanently_not_recover_tips_plural', this.count, this.count)];
      }
    }
  }

  private getTrashCleanupPageDeleteDialog(cloudDriveStatus: boolean): (Resource)[] {
    if (cloudDriveStatus) {
      // 开启云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_files_tips'),
          $r('app.string.cloud_delete_all_files_can_download_tips')] :
          [$r('app.plural.recycle_files_tips', this.count, this.count),
            $r('app.plural.cloud_delete_files_can_download_tips', this.count, this.count)];
      }

    } else {
      // 关闭云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_files_tips'),
          $r('app.string.recycleAlbum_clear_message')] :
          [$r('app.plural.recycle_files_tips', this.count, this.count),
            $r('app.plural.recycleAlbum_delete_multiple_images_message', this.count, this.count)];
      }
    }
  }

  private getGalleryCleanupCountDialog(cloudDriveStatus: boolean | undefined): (Resource)[] {
    if (this.deletePhotoType === 'image') {
      return cloudDriveStatus ? [$r('app.string.recycle_picture_tips'),
        $r('app.string.cloud_delete_image_can_download_tips')] :
        [$r('app.string.recycle_picture_tips'), $r('app.string.picture_dialog_delete_permanently_not_recover_tips')];
    }
    if (this.deletePhotoType === 'video') {
      return cloudDriveStatus ? [$r('app.string.recycle_video_tips'),
        $r('app.string.cloud_delete_video_can_download_tips')] :
        [$r('app.string.recycle_video_tips'), $r('app.string.video_dialog_delete_permanently_not_recover_tips')];
    }
    return cloudDriveStatus ? [$r('app.string.recycle_picture_tips'),
      $r('app.string.cloud_delete_image_can_download_tips')] :
      [$r('app.string.recycle_picture_tips'), $r('app.string.picture_dialog_delete_permanently_not_recover_tips')];
  }

  private getPhotoCleanupPageDeleteDialog(cloudDriveStatus: boolean): (Resource)[] {
    if (cloudDriveStatus) {
      // 开启云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_photos_tips'),
          $r('app.string.cloud_delete_all_images_can_download_tips')] :
          [$r('app.plural.recycle_photos_tips_plural', this.count, this.count),
            $r('app.plural.cloud_delete_images_can_download_tips', this.count, this.count)];
      }
    } else {
      // 关闭云同步
      if (this.count === 1) {
        return this.getGalleryCleanupCountDialog(cloudDriveStatus);
      } else {
        return this.menuContext.selectManager?.isAllSelected ? [$r('app.string.recycle_all_photos_tips'),
          $r('app.string.local_all_photos_dialog_delete_permanently_not_recover_tips')] :
          [$r('app.plural.recycle_photos_tips_plural', this.count, this.count),
            $r('app.plural.local_photos_dialog_delete_permanently_not_recover_tips_plural', this.count, this.count)];
      }
    }
  }

  /**
   * 图库清理上报单个图片删除打点
   * @param albumInfo 相册信息
   */
  private reportDeleteInfo(albumInfo: AlbumInfo | undefined, mediaItem: MediaItem): void {
    if (albumInfo === undefined) {
      return;
    }
    Log.info(TAG, `reportDeleteInfo start!`);
    if (albumInfo.isTrashAlbum) {
      let trashAlbumMsg: Record<string, number | string | boolean> = {
        'deletedFilesCount': 1,
        'deletedFilesSize': ImageUtil.formatMBSize(mediaItem.size),
      };
      ReportToBigDataUtil.report(BigDataConstants.RECENTLY_DELETE_FILES, trashAlbumMsg);
      Log.info(TAG, `reportPhotoDeleteInfo TrashAlbum finished! msg=${JSON.stringify(trashAlbumMsg)}`);
    } else if (albumInfo.isScreenShotAlbum) {
      let screenShotAlbumMsg: Record<string, number | string | boolean> = {
        'deletedImagesCount': 1,
        'deletedImagesSize': ImageUtil.formatMBSize(mediaItem.size),
      };
      ReportToBigDataUtil.report(BigDataConstants.CLEANUP_DELETE_SCREENSHOTS, screenShotAlbumMsg);
      Log.info(TAG, `reportPhotoDeleteInfo ScreenShotAlbum finished! msg=${JSON.stringify(screenShotAlbumMsg)}`);
    } else if (albumInfo.isPhotoAlbum) {
      let cleanupPage: string = NavigationConstants.NAVIGATION_ALL_PHOTOS_PAGE;
      let screenShotAlbumMsg: Record<string, number | string | boolean> = {
        'cleanupPage': cleanupPage,
        'deletedImagesCount': 1,
        'deletedImagesSize': ImageUtil.formatMBSize(mediaItem.size),
      };
      ReportToBigDataUtil.report(BigDataConstants.CLEANUP_DELETE_IMAGES, screenShotAlbumMsg);
      Log.info(TAG, `reportPhotoDeleteInfo ScreenShotAlbum finished! msg=${JSON.stringify(screenShotAlbumMsg)}`);
    }
  }



  public updateProgress(progress: number, currenCount: number): void {
    // 允许进度条正常更新到100%，不拦截进度更新
    // 对话框的关闭仍然通过 onDataLoadingFinished 或超时机制来控制
    if (this.isCloseDeleteProgressPending && this.isWaitingDataRefreshToComplete && progress >= 100) {
      super.updateProgress(99, currenCount);
      return;
    }
    super.updateProgress(progress, currenCount);
    // 如果进度到100%且正在等待数据刷新，设置超时定时器（用于关闭对话框）
    if (progress === 100 && this.isCloseDeleteProgressPending && !this.isCancelled) {
      this.setClearProgressDialogTimer();
      Log.info(TAG, `updateProgress: progress reached 100%, waiting for data refresh`);
    }
  }

  public onOperateCancelled(): void {
    this.isCloseDeleteProgressPending = false;
    this.menuContext.dataSource?.removeListener(this.dataListener);
    this.clearProgressDialogTimer();
    this.clearNavigateAfterProgressCloseTimer();
    this.clearProgressDialogCompletedListener();
    Log.info(TAG, 'onOperateCancelled: removeListener');
    super.onOperateCancelled();
  }
}