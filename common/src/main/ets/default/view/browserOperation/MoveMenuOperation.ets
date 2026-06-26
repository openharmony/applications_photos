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
import type { MenuContext } from './MenuContext';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { Constants } from '../../model/common/Constants';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import type { SelectManager } from '../../model/browser/SelectManager';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy HashMap from '@ohos.util.HashMap';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { DynamicRangeMode } from '@ohos.multimedia.movingphotoview';

const TAG: string = 'common_MoveMenuOperation';
const operationImpl = BrowserOperationFactory.getFeature(BrowserOperationFactory.TYPE_PHOTO);

export type PhotoAlbum = photoAccessHelper.Album;

export class MoveMenuOperation extends ProcessMenuOperation {
  public albumUri: string;
  public albumName: string;
  public originalAlbumUri: string;
  public readonly BATCH_SIZE: number = 1000;
  protected readonly PROGRESS_MESSAGE_WIDTH: number = 120;
  public useUrlFlag: boolean = false;
  private photoAccessHelper?: photoAccessHelper.PhotoAccessHelper;
  private isFromUnionAlbum: boolean = false;
  private continueCallback: Function | undefined = undefined;
  private completedFilesCount: number = 0;
  private currentBatchFilesCount: number = 0;
  private readonly DELAY_TIME: number = 600;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  protected moveCancelFunc: Function = (): void => {
    this.cancelFunc();
  };

  constructor(menuContext: MenuContext) {
    super(menuContext);
    this.albumUri = menuContext.albumUri ?? '';
    this.albumName = menuContext.targetAlbumName ?? '';
    this.originalAlbumUri = menuContext.originalAlbumUri ?? '';
    this.photoAccessHelper = UserFileManagerAccess.getInstance().getMediaLibrary();
    const originalAlbumInfo: AlbumInfo | undefined = menuContext.albumInfo;
    if (originalAlbumInfo) {
      this.isFromUnionAlbum = originalAlbumInfo.isSourceAlbum && originalAlbumInfo.unionAlbumUris.length > 0;
    }
    this.operationType = 'ADD_PHOTOS_TO_ALBUM';
    this.traceOperationType = 'ADD_PHOTOS_TO_ALBUM';
    Log.info(TAG, `constructor, albumUri: ${this.albumUri}, originalAlbumUri: ${this.originalAlbumUri}`);
  }

  public doAction(): void {
    Log.info(TAG, 'doMoveAction');
    /* instrument ignore if */
    if (!this.menuContext) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    /* instrument ignore else*/
    if (this.menuContext.selectManager) {
      this.count = this.menuContext.selectManager.getSelectedCount();
      /* instrument ignore if */
      if (this.count <= 0) {
        Log.error(TAG, 'count <= 0, return');
        // 兜底：避免此前残留的进度弹窗造成“卡住”观感
        this.menuContext.broadCast?.emit(BroadCastConstants.HIDE_PROGRESS_DIALOG, []);
        return;
      }
      this.onOperationEnd = this.menuContext.onOperationEnd;
      this.setBatchSelectedInfo();
      let onOperationStart: Function = this.menuContext.onOperationStart;
      onOperationStart?.();
    } else {
      this.count = 1;
      let mediaItem = this.menuContext.mediaItem;
      this.onOperationEnd = this.menuContext.onOperationEnd;
      if (mediaItem == null) {
        Log.error(TAG, 'mediaItem is null, return');

        this.menuContext.broadCast?.emit(BroadCastConstants.HIDE_PROGRESS_DIALOG, []);
        return;
      }
      if (this.menuContext.isBurstPhotos) {
        this.selectAssetCallback(this.menuContext.burstPhotos?.map(item => item.data) as PhotoAsset[]);
      } else {
        this.callback([mediaItem.uri]);
      }
    }


    if (this.menuContext.fromPage === Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER) {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.move_progress', this.albumName), this.moveCancelFunc, undefined, this.PROGRESS_MESSAGE_WIDTH]);
    } else {
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_PROGRESS_DIALOG,
        [$r('app.string.move_progress', this.albumName), this.moveCancelFunc, true, this.PROGRESS_MESSAGE_WIDTH]);
    }

    AppStorage.setOrCreate<string>('choiceMode', 'None');
    this.doActionNext();
  }

  doActionNext(): void {
    let isTargetSystem: boolean = false;
    let systemAlbumUris: IterableIterator<string> =
      UserFileManagerAccess.getInstance().getSystemAlbumUriMap?.().values();
    for (let uri of systemAlbumUris) {
      if (this.albumUri === uri) {
        isTargetSystem = true;
        break;
      }
    }

    let msg: Record<string, number | string | boolean | undefined> = {
      'type': BigDataConstants.MEDIA_COPY,
      'targetAlbumType': isTargetSystem,
      'count': this.count,
      'ALBUM_TYPE': this.menuContext.albumInfo?.subType,
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);
    this.menuContext.broadCast?.on(BroadCastConstants.CANCEL_PROGRESS_DIALOG, this.cancelProgress.bind(this));
  }

  public callback(uris: string[]): void {
    this.uris = uris;
    this.useUrlFlag = true;
    this.processOperation();
  }

  public selectAssetCallback(assets: PhotoAsset[]): void {
    this.useUrlFlag = false;
    this.selectedAssetCallback(assets);
  }

  public requestOneBatchOperation(): void {
    /* instrument ignore if */
    if (this.isCancelled) {
      Log.info(TAG, 'requestOneBatchOperation is cancelled');
      return;
    }
    if (this.useUrlFlag) {
      this.currentBatch++;
      let startIndex = (this.currentBatch - 1);
      let endIndex = this.currentBatch;
      let batchUrls: string[] = this.uris?.slice(startIndex, Math.min(endIndex, this.uris?.length));
      Log.info(TAG, `requestOneBatchOperation ${this.albumUri}, ${batchUrls.length}`);
      TraceControllerUtils.startTraceWithTaskId('move', this.currentBatch);
      this.currentBatchFilesCount = batchUrls.length > 0 ? 1 : 0;
      this.getFileAddOrMoveInfo(batchUrls[0]).then((fileAsset: PhotoAsset | undefined) => {
        TraceControllerUtils.finishTraceWithTaskId('move', this.currentBatch);
        this.move(fileAsset ? [fileAsset] : []);
      });
      Log.info(TAG, `requestOneBatchOperation batchUrls:${JSON.stringify(batchUrls)}`);
    } else {
      this.batchOperationWidthBurstPhotos({
        callback: (batchAssets: PhotoAsset[]): Promise<void> => this.doMoveOperation(batchAssets)
      });
    }
  }

  /* instrument ignore next */
  public cancelFunc(): void {
    Log.info(TAG, `progress cancel, successBatch: ${this.successBatch}, currentBatch: ${this.currentBatch}, totalBatches: ${this.totalBatches}, count: ${this.count}, useUrlFlag: ${this.useUrlFlag}`);
    this.onOperatePause();
    let progress: number = this.getExpectProgress();
    Log.info(TAG, `cancelFunc getExpectProgress result: ${progress}%`);
    progress = Math.round(Math.min(Math.max(progress, 0), 100));
    let cancelMessage = $r('app.string.move_files_cancel_message', `${progress.toString()}%`);

    this.menuContext.broadCast?.emit(BroadCastConstants.CANCEL_OPERATE,
      [cancelMessage, (): void => {
        this.onOperateContinue();
      }, (): void => {
        this.onOperateCancelled();
      }]);
  }

  // Copy cancel callback
  /* instrument ignore next */
  public onOperateContinue(): void {
    Log.info(TAG, 'Operate Continue');
    this.isPause = false;
    if (this.totalBatches > 0) {
      this.cyclicOperation();
    } else {
      this.continueCallback = () => this.cyclicOperation();
    }
  }

  private addCompletedFilesCount(count: number): void {
    this.completedFilesCount += count;
    Log.info(TAG, `addCompletedFilesCount: added ${count} files, total completedFilesCount: ${this.completedFilesCount}`);
    let completedCount: number = Math.min(this.completedFilesCount, this.count);
    let progress: number = this.getExpectProgress();
    this.updateProgress(progress, completedCount);
  }
  public onCompleted(): void {
    Log.info(TAG, `onCompleted successBatch: ${this.successBatch}, completedFilesCount: ${this.completedFilesCount}`);
    this.successBatch++;
    if (!this.isPause) {
      this.cyclicOperation();
    }
  }

  public processOperation(): void {
    Log.info(TAG, 'processOperation start');
    this.completedFilesCount = 0;
    this.currentBatchFilesCount = 0;
    TraceControllerUtils.startTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
    let length = 0;
    /* instrument ignore else */
    if (this.uris && this.uris.length > 0) {
      Log.info(TAG, 'processOperation start and length is uris length');
      length = this.uris.length;
    } else if (this.selectAssets) {
      Log.info(TAG, 'processOperation start and length is selectAssets.length');
      length = this.selectAssets.length;
    } else {
      Log.error(TAG, 'Invalid callback data, uris and selectAssets is null!');
      return;
    }
    Log.info(TAG, `selected count: ${this.count}, uris's length: ${length}`);
    // Batch deletion
    this.totalCount = this.menuContext.selectManager?.totalCount;
    length = length > 0 ? length : (this.totalCount ?? 0);
    if (this.useUrlFlag) {
      this.totalBatches = length;
    } else {
      this.totalBatches = Math.floor(length / this.BATCH_SIZE) + ((length % this.BATCH_SIZE) ? 1 : 0);
    }
    Log.info(TAG, `The count to be operate is ${length}, operate in ${this.totalBatches} batches, useUrlFlag: ${this.useUrlFlag}`);
    /* instrument ignore if */
    if (this.isCancelled) {
      return;
    }
    /* instrument ignore if */
    if (this.continueCallback) {
      this.continueCallback();
      this.continueCallback = undefined;
      return;
    }
    this.startTime = Date.now();
    this.requestOneBatchOperation();
  }

  private async doMoveOperation(batchAssets: PhotoAsset[]): Promise<void> {
    Log.info(TAG, `requestOneBatchOperation ${this.albumUri}, ${batchAssets.length}`);
    TraceControllerUtils.startTraceWithTaskId('move', this.currentBatch);
    this.currentBatchFilesCount = batchAssets.length;
    this.move(batchAssets);
    TraceControllerUtils.finishTraceWithTaskId('move', this.currentBatch);
  }

  /* instrument ignore next */
  protected async move(source: PhotoAsset[]): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'move is cancelled, return');
      this.onProcessDone();
      return;
    }
    this.currentBatchFilesCount = source.length;
    try {
      ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_START, undefined);
      Log.info(TAG, `move, albumUri: ${this.albumUri}, originalAlbumUri: ${this.originalAlbumUri}`);
      await this.moveFilesToAlbum(this.albumUri, source, this.originalAlbumUri);
      if (this.isCancelled) {
        Log.info(TAG, 'moveFilesToAlbum completed but operation is cancelled, return');
        this.onProcessDone();
        return;
      }
      ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_FINISH, undefined);
    } catch (error) {
      if (this.isCancelled) {
        Log.info(TAG, 'move error but operation is cancelled, return');
        this.onProcessDone();
        return;
      }
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.MEDIA_COPY_ERROR,
        'count': this.count,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.error(TAG, `copyFile is error ${error}, code: ${error?.code}`);
      this.onError();
    }
  }

  /**
   * 移动至目标相册
   * @param albumUri 相册uri
   * @param sourceAssets 资产数组
   * @param originalAlbumUri 源相册uri
   * @return void
   */
  private async moveFilesToAlbum(albumUri: string, sourceAssets: PhotoAsset[],
    originalAlbumUri?: string): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'moveFilesToAlbum is cancelled, return');
      return;
    }
    /* instrument ignore if */
    if (!this.photoAccessHelper) {
      Log.warn(TAG, 'moveFilesToAlbum photoAccessHelper undefined');
      return;
    }
    let startTime: number = Date.now();
    AppStorage.setOrCreate<string>('hasSameAssets', 'None');
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let predicatesArray: string[] = [];
    // 提取移动图像的display_name作为筛选值
    for (let i = 0; i < sourceAssets.length; i++) {
      predicatesArray.push(sourceAssets[i].displayName);
    }
    predicates.in('display_name', predicatesArray);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [photoAccessHelper.PhotoKeys.URI.toString(),
        photoAccessHelper.PhotoKeys.SIZE.toString(),
        photoAccessHelper.PhotoKeys.DATE_MODIFIED_MS.toString(),
        photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString(),
        photoAccessHelper.PhotoKeys.ORIENTATION.toString(),
        photoAccessHelper.PhotoKeys.DISPLAY_NAME.toString(),
      ],
      predicates: predicates,
    };
    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    let originalAlbum: PhotoAlbum | undefined =
      await UserFileManagerAccess.getInstance().getAlbumByUri(originalAlbumUri);
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      TraceControllerUtils.startTraceWithTaskId('moveFilesToAlbum', startTime);
      Log.info(TAG, 'moveFilesToAlbum start');
      fetchResult = await this.photoAccessHelper.getAssets(fetchOptions);
      if (this.isCancelled) {
        Log.info(TAG, 'moveFilesToAlbum is cancelled after getAssets, return');
        return;
      }
      let repeatPhotoAlbumResult: PhotoAsset[] = await (await album?.getAssets(fetchOptions))?.getAllObjects() ?? [];
      /* instrument ignore if */
      if (!album) {
        Log.error(TAG, 'album is null');
        this.onProcessDone();
        return;
      }
      /* instrument ignore if */
      if (!sourceAssets.length) {
        Log.error(TAG, 'sourceAssets is invalid');
        this.onProcessDone();
        return;
      }
      let isMoveFilesDirectly: boolean | undefined =
        originalAlbum && !this.isFromUnionAlbum && !UserFileManagerAccess.getInstance().isSmartAlbum(originalAlbum);
      let logMsg: string[] = ['moveFilesToAlbum'];
      logMsg.push(`originalAlbum: ${originalAlbum}`);
      logMsg.push(`originalAlbumUri: ${originalAlbumUri}`);
      logMsg.push(`isFromUnionAlbum: ${this.isFromUnionAlbum}`);
      logMsg.push(`isMoveFilesDirectly: ${isMoveFilesDirectly}`);
      Log.info(TAG,logMsg.join(','));
      if (this.isCancelled) {
        Log.info(TAG, 'moveFilesToAlbum is cancelled before processing, return');
        return;
      }
      if (isMoveFilesDirectly) {
        // 直接移动文件，场景如：1、相机进大图，更多按钮弹窗中的移动到按钮，点击移动到其他相册
        if (!repeatPhotoAlbumResult || repeatPhotoAlbumResult.length === 0) {
          await this.moveFile(sourceAssets, originalAlbum, album, startTime);
          if (this.isCancelled) {
            Log.info(TAG, 'moveFilesToAlbum is cancelled after moveFile, return');
            TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
            return;
          }
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          this.onCompleted();
        } else {
          await this.handelAssets(sourceAssets, repeatPhotoAlbumResult, originalAlbum, album, startTime);
        }
      } else {
        // 照片页源相册划分
        let originalAlbumMap: HashMap<string, PhotoAsset[]> = new HashMap();
        // 循环获取相同相册数据
        for (let source of sourceAssets) {
          /* instrument ignore else */
          if (source.photoType === photoAccessHelper.PhotoType.IMAGE) {
            originalAlbumUri =
              UserFileManagerAccess.getInstance().getSystemAlbumUriMap().get(photoAccessHelper.AlbumSubtype.IMAGE);
          } else if (source.photoType === photoAccessHelper.PhotoType.VIDEO) {
            originalAlbumUri =
              UserFileManagerAccess.getInstance().getSystemAlbumUriMap().get(photoAccessHelper.AlbumSubtype.VIDEO);
          } else {
            Log.error(TAG, 'the source not a image or video')
            continue;
          }
          /* instrument ignore else */
          if (!originalAlbumMap.hasKey(originalAlbumUri)) {
            originalAlbumMap.set(originalAlbumUri, [source]);
          } else {
            originalAlbumMap.get(originalAlbumUri).push(source);
          }
        }
        await this.handelAllAssets(repeatPhotoAlbumResult, album, originalAlbumMap, startTime);
      }
    } catch (err) {
      /* instrument ignore next */
      Log.error(TAG, ` moveFilesToAlbum: ${err.message}`);
      if (this.isCancelled) {
      } else {
        this.onError(err);
      }
    } finally {
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      fetchResult?.close();
      Log.info(TAG, `fetchResult is close.`);
    }
  }

  // 重名文件创建Map
  private getRepeatHashMap(repeatPhotoAlbumResult: PhotoAsset[],
    repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>) {
    for (let i = 0; i < repeatPhotoAlbumResult.length; i++) {
      repeatPhotoAlbumResultMap.set(repeatPhotoAlbumResult[i].displayName, repeatPhotoAlbumResult[i]);
    }
  }

  // 移动照片资源
  private async moveFile(sourceAssets: PhotoAsset[], originalAlbum: PhotoAlbum | undefined,
    targetAlbum: PhotoAlbum | undefined, startTime: number): Promise<void> {
    /* instrument ignore if */
    if (this.isCancelled) {
      Log.info(TAG, 'moveFile is cancelled, return');
      return;
    }
    if (!sourceAssets.length) {
      Log.error(TAG, 'sourceAssets is null')
      return;
    }
    // 为了逐张计算进度，将文件拆分成小批次处理（每次100张）
    const BATCH_SIZE_FOR_PROGRESS: number = 100;
    for (let i = 0; i < sourceAssets.length; i += BATCH_SIZE_FOR_PROGRESS) {
      if (await this.waitIfPaused()) {
        Log.info(TAG, 'moveFile paused and cancelled, return');
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'moveFile is cancelled in batch loop, return');
        return;
      }
      let batchAssets: PhotoAsset[] = sourceAssets.slice(i, Math.min(i + BATCH_SIZE_FOR_PROGRESS, sourceAssets.length));
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
      try {
        albumChangeRequest.moveAssets(batchAssets, targetAlbum);
      } catch (err) {
        Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
        this.onProcessDone();
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'moveFile is cancelled before applyChanges, return');
        return;
      }
      try {
        await this.photoAccessHelper?.applyChanges(albumChangeRequest);
        // 移动成功后，累加实际移动的文件数（用于逐张计算进度）
        this.addCompletedFilesCount(batchAssets.length);
      } catch (err) {
        Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
      }
    }
  }

  // 区分重名文件
  private async hasSameName(sourceAssets: PhotoAsset[], diffSourceArray: PhotoAsset[], sameSourceArray: PhotoAsset[],
    repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>) {
    for (let source of sourceAssets) {
      // 是否重名
      /* instrument ignore if */
      if (repeatPhotoAlbumResultMap.hasKey(source.displayName)) {
        let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(source.displayName);
        // 是否完全一致
        if (source.get('size') !== repeatPhotoAsset.get('size') ||
          source.get('orientation') !== repeatPhotoAsset.get('orientation')) {
          // 重命名
          await this.renameSource(source);
          diffSourceArray.push(source);
        } else {
          sameSourceArray.push(source);
        }
      } else {
        diffSourceArray.push(source);
      }
    }
  }

  // 处理包含重名文件的资源，包括重名分组、分组处理、重名不一致重命名、重名一致弹窗
  private async handelAssets(sourceAssets: PhotoAsset[], repeatPhotoAlbumResult: PhotoAsset[],
    originalAlbum: PhotoAlbum | undefined, targetAlbum: PhotoAlbum | undefined, startTime: number): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'handelAssets is cancelled, return');
      return;
    }
    // 目标相册重复图片数据存入HashMap，key为name，value为PhotoAsset
    let repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset> = new HashMap();
    this.getRepeatHashMap(repeatPhotoAlbumResult, repeatPhotoAlbumResultMap);
    // 重名分组
    let diffSourceArray: PhotoAsset[] = [];
    let sameSourceArray: PhotoAsset[] = [];
    await this.hasSameName(sourceAssets, diffSourceArray, sameSourceArray, repeatPhotoAlbumResultMap);
    if (this.isCancelled) {
      Log.info(TAG, 'handelAssets is cancelled after hasSameName, return');
      return;
    }
    // 如果有重名一致文件需要弹窗，先不执行移动操作，等待用户选择后再执行
    if (sameSourceArray.length > 0) {
      // 先弹出对话框，等待用户选择后再执行移动操作
      await this.handleWithDiffFiles(sameSourceArray, diffSourceArray, repeatPhotoAlbumResultMap, 0, originalAlbum, targetAlbum, startTime);
      return;
    }
    // 没有重名一致文件，直接移动不重名、重命名文件
    await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
    if (this.isCancelled) {
      Log.info(TAG, 'handelAssets is cancelled after moveFile, return');
      return;
    }
    Log.info(TAG, 'handelAssets no same name files to handle, complete batch');
    this.onCompleted();
  }

  // 处理包含多个源相册重名文件的资源
  /* instrument ignore next */
  private async handelAllAssets(repeatPhotoAlbumResult: PhotoAsset[], targetAlbum: PhotoAlbum | undefined,
    originalAlbumMap: HashMap<string, PhotoAsset[]>, startTime: number) {
    if (this.isCancelled || this.isPause) {
      Log.info(TAG, 'handelAllAssets is cancelled or paused, return');
      return;
    }
    // 目标相册重复图片数据存入HashMap，key为name，value为PhotoAsset
    let repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset> = new HashMap();
    this.getRepeatHashMap(repeatPhotoAlbumResult, repeatPhotoAlbumResultMap);
    // 存储每个源相册的不重名和重命名文件
    let diffSourceMap: HashMap<string, PhotoAsset[]> = new HashMap();
    let iterator: IterableIterator<[string, PhotoAsset[]]> = originalAlbumMap.entries();
    let hasSameNameFiles: boolean = false;
    let it = iterator.next();
    while (!it.done) {
      if (this.isCancelled) {
        Log.info(TAG, 'handelAllAssets is cancelled in loop, break');
        break;
      }
      let originalAlbumUri: string = it.value[0];
      // 重名分组
      let diffSourceArray: PhotoAsset[] = [];
      let sameSourceArray: PhotoAsset[] = [];
      await this.hasSameName(it.value[1], diffSourceArray, sameSourceArray, repeatPhotoAlbumResultMap);
      // 保存不重名和重命名的文件，稍后再移动
      if (diffSourceArray.length > 0) {
        diffSourceMap.set(originalAlbumUri, diffSourceArray);
      }
      // 重名, 回填map
      if (sameSourceArray.length > 0) {
        originalAlbumMap.set(originalAlbumUri, sameSourceArray);
        hasSameNameFiles = true;
      } else {
        originalAlbumMap.remove(originalAlbumUri);
      }
      it = iterator.next();
    }
    // 是否有完全一致图片需要弹窗
    if (this.isCancelled) {
      Log.info(TAG, 'handelAllAssets is cancelled, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    // 如果有重名文件需要弹窗，先不执行移动操作，等待用户选择后再执行
    if (hasSameNameFiles && !originalAlbumMap.isEmpty()) {
      iterator = originalAlbumMap.entries();
      let it = iterator.next();
      if (!it.done) {
        let originalAlbumUri: string = it.value[0];
        let originalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(originalAlbumUri);
        await this.handleAllAlbumsWithDiffFiles(it.value[1], diffSourceMap, repeatPhotoAlbumResultMap, 0, originalAlbumUri, originalAlbum, targetAlbum, iterator, startTime);
      }
      return;
    }
    // 没有重名文件，直接移动所有不重名和重命名的文件
    let diffIterator = diffSourceMap.entries();
    let diffIt = diffIterator.next();
    while (!diffIt.done) {
      if (this.isCancelled) {
        Log.info(TAG, 'handelAllAssets is cancelled when moving diff files, break');
        break;
      }
      let originalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(diffIt.value[0]);
      await this.moveFile(diffIt.value[1], originalAlbum, targetAlbum, startTime);
      diffIt = diffIterator.next();
    }
    if (this.isCancelled) {
      Log.info(TAG, 'handelAllAssets is cancelled after moving diff files, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
    this.onCompleted();
  }

  // 处理包含不重名文件和重名一致文件的场景，先弹出对话框，等待用户选择后再执行移动操作
  private async handleWithDiffFiles(sameSourceArray: PhotoAsset[], diffSourceArray: PhotoAsset[],
    repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>, index: number, originalAlbum: PhotoAlbum | undefined,
    targetAlbum: PhotoAlbum | undefined, startTime: number): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'handleWithDiffFiles is cancelled, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    if (!sameSourceArray || index >= sameSourceArray.length) {
      // 所有重名文件处理完成，现在移动不重名和重命名的文件
      if (diffSourceArray.length > 0) {
        await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
        if (this.isCancelled) {
          Log.info(TAG, 'handleWithDiffFiles is cancelled after moveFile, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
      }
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    }
    let currentSourceAssets = sameSourceArray[index];
    let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(currentSourceAssets.displayName);
    let choiceMode: string | undefined = AppStorage.get('choiceMode');
    Log.info(TAG, `MoveMenuOperation choiceMode = ${choiceMode}`);
    // 记住操作为替换
    if (choiceMode === 'Replace') {
      // 先移动不重名和重命名的文件
      if (diffSourceArray.length > 0) {
        await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
        if (this.isCancelled) {
          Log.info(TAG, 'handleWithDiffFiles is cancelled after moveFile, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
      }
      // 然后移动剩余的所有重名文件
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
      let movedFiles = sameSourceArray.slice(index,);
      try {
        albumChangeRequest.moveAssets(movedFiles, targetAlbum);
        let trashAssetUris: string[] = [];
        for (let asset of movedFiles) {
          let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(asset.displayName);
          if (asset.uri !== repeatPhotoAsset.uri) {
            trashAssetUris.push(repeatPhotoAsset.uri);
          }
        }
        operationImpl.trash(trashAssetUris);
      } catch (err) {
        Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'handleWithDiffFiles is cancelled before applyChanges, return');
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        return;
      }
      try {
        await this.photoAccessHelper?.applyChanges(albumChangeRequest);
        this.addCompletedFilesCount(movedFiles.length);
      } catch (err) {
        Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
      }
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else if (choiceMode === 'Skip') {
      // 先移动不重名和重命名的文件
      if (diffSourceArray.length > 0) {
        await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
        if (this.isCancelled) {
          Log.info(TAG, 'handleWithDiffFiles is cancelled after moveFile, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
      }
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else {
      AppStorage.set<boolean>('hasSameAssets', true);
      let replaceCallback = async (): Promise<void> => {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
        try {
          albumChangeRequest.moveAssets([currentSourceAssets], targetAlbum);
          if (currentSourceAssets.uri !== repeatPhotoAsset.uri) {
            operationImpl.trash([repeatPhotoAsset.uri]);
          }
        } catch (err) {
          Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          this.onProcessDone();
          return;
        }
        if (this.isCancelled) {
          Log.info(TAG, 'replaceCallback is cancelled before applyChanges, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
        try {
          await this.photoAccessHelper?.applyChanges(albumChangeRequest);
          this.addCompletedFilesCount(1);
        } catch (err) {
          Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
        }
        await this.handleWithDiffFiles(sameSourceArray, diffSourceArray, repeatPhotoAlbumResultMap, index + 1, originalAlbum, targetAlbum, startTime);
      };
      let skipCallback = async (): Promise<void> => {
        await this.handleWithDiffFiles(sameSourceArray, diffSourceArray, repeatPhotoAlbumResultMap, index + 1, originalAlbum, targetAlbum, startTime);
      };
      let cancelCallback = (): void => {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      };
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_MOVE_DIALOG,
        [[currentSourceAssets, repeatPhotoAsset], replaceCallback, skipCallback, cancelCallback]);
    }
  }

  // 递归处理弹窗图片
  /* instrument ignore next */
  private async handle(sourceAssets: PhotoAsset[], repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>,
    index: number, originalAlbum: PhotoAlbum | undefined, targetAlbum: PhotoAlbum | undefined,
    startTime: number): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'handle is cancelled, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    if (!sourceAssets || index >= sourceAssets.length) {
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    }
    let currentSourceAssets = sourceAssets[index];
    let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(currentSourceAssets.displayName);
    let choiceMode: string | undefined = AppStorage.get('choiceMode');
    Log.info(TAG, `MoveMenuOperation choiceMode = ${choiceMode}`);
    // 记住操作为替换
    if (choiceMode === 'Replace') {
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
      try {
        albumChangeRequest.moveAssets(sourceAssets.slice(index,), targetAlbum);
        let trashAssetUris: string[] = [];
        for (let asset of sourceAssets.slice(index,)) {
          let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(asset.displayName);
          if (asset.uri !== repeatPhotoAsset.uri) {
            trashAssetUris.push(repeatPhotoAsset.uri);
          }
        }
        operationImpl.trash(trashAssetUris);
      } catch (err) {
        Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'handle is cancelled before applyChanges, return');
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        return;
      }
      try {
        await this.photoAccessHelper?.applyChanges(albumChangeRequest);
        let movedCount = sourceAssets.length - index;
        this.addCompletedFilesCount(movedCount);
      } catch (err) {
        Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
      }
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else if (choiceMode === 'Skip') {
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else {
      AppStorage.set<boolean>('hasSameAssets', true);
      let replaceCallback = async (): Promise<void> => {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
        try {
          albumChangeRequest.moveAssets([currentSourceAssets], targetAlbum);
          if (currentSourceAssets.uri !== repeatPhotoAsset.uri) {
            operationImpl.trash([repeatPhotoAsset.uri]);
          }
        } catch (err) {
          Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          this.onProcessDone();
          return;
        }
        if (this.isCancelled) {
          Log.info(TAG, 'replaceCallback is cancelled before applyChanges, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
        try {
          await this.photoAccessHelper?.applyChanges(albumChangeRequest);
          this.addCompletedFilesCount(1);
        } catch (err) {
          Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
        }
        await this.handle(sourceAssets, repeatPhotoAlbumResultMap, index + 1, originalAlbum, targetAlbum, startTime);
      };
      let skipCallback = async (): Promise<void> => {
        await this.handle(sourceAssets, repeatPhotoAlbumResultMap, index + 1, originalAlbum, targetAlbum, startTime);
      };
      let cancelCallback = (): void => {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      };
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_MOVE_DIALOG,
        [[currentSourceAssets, repeatPhotoAsset], replaceCallback, skipCallback, cancelCallback]);
    }
  }

  // 处理多源相册包含不重名文件和重名一致文件的场景，先弹出对话框，等待用户选择后再执行移动操作
  /* instrument ignore next */
  private async handleAllAlbumsWithDiffFiles(sourceAssets: PhotoAsset[], diffSourceMap: HashMap<string, PhotoAsset[]>,
    repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>, index: number, originalAlbumUri: string,
    originalAlbum: PhotoAlbum | undefined, targetAlbum: PhotoAlbum | undefined,
    iterator: IterableIterator<[string, PhotoAsset[]]>, startTime: number): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    // 当前相册数据处理完成
    if (index >= sourceAssets.length) {
      // 先移动当前相册的不重名和重命名文件
      if (diffSourceMap.hasKey(originalAlbumUri)) {
        let diffSourceArray = diffSourceMap.get(originalAlbumUri);
        if (diffSourceArray && diffSourceArray.length > 0) {
          await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
          if (this.isCancelled) {
            Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled after moveFile, return');
            TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
            return;
          }
        }
        diffSourceMap.remove(originalAlbumUri);
      }
      // 跳转下一相册
      let it = iterator.next();
      // 是否处理完所有相册
      if (!it.done) {
        let nextOriginalAlbumUri: string = it.value[0];
        let nextOriginalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(nextOriginalAlbumUri);
        await this.handleAllAlbumsWithDiffFiles(it.value[1], diffSourceMap, repeatPhotoAlbumResultMap, 0, nextOriginalAlbumUri,
          nextOriginalAlbum, targetAlbum, iterator, startTime);
      } else {
        // 所有相册处理完成，移动剩余的不重名和重命名文件
        let diffIterator = diffSourceMap.entries();
        let diffIt = diffIterator.next();
        while (!diffIt.done) {
          if (this.isCancelled) {
            Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled when moving remaining diff files, break');
            break;
          }
          let originalAlbumTemp = await UserFileManagerAccess.getInstance().getAlbumByUri(diffIt.value[0]);
          await this.moveFile(diffIt.value[1], originalAlbumTemp, targetAlbum, startTime);
          diffIt = diffIterator.next();
        }
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onCompleted();
      }
      return;
    }
    let choiceMode: string | undefined = AppStorage.get('choiceMode');
    Log.info(TAG, `MoveMenuOperation choiceMode = ${choiceMode}`);
    // 记住操作为替换
    if (choiceMode === 'Replace') {
      // 先移动当前相册的不重名和重命名文件
      if (diffSourceMap.hasKey(originalAlbumUri)) {
        let diffSourceArray = diffSourceMap.get(originalAlbumUri);
        if (diffSourceArray && diffSourceArray.length > 0) {
          await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
          if (this.isCancelled) {
            Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled after moveFile, return');
            TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
            return;
          }
        }
        diffSourceMap.remove(originalAlbumUri);
      }
      // 然后移动剩余的所有重名文件
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
      try {
        albumChangeRequest.moveAssets(sourceAssets.slice(index,), targetAlbum);
        let trashAssetUris: string[] = [];
        for (let asset of sourceAssets.slice(index,)) {
          let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(asset.displayName);
          if (asset.uri !== repeatPhotoAsset.uri) {
            trashAssetUris.push(repeatPhotoAsset.uri);
          }
        }
        operationImpl.trash(trashAssetUris);
      } catch (err) {
        Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled before applyChanges, return');
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        return;
      }
      try {
        await this.photoAccessHelper?.applyChanges(albumChangeRequest);
        let movedCount = sourceAssets.length - index;
        this.addCompletedFilesCount(movedCount);
      } catch (err) {
        Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
      }
      // 移动剩余的不重名和重命名文件
      let diffIterator = diffSourceMap.entries();
      let diffIt = diffIterator.next();
      while (!diffIt.done) {
        if (this.isCancelled) {
          Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled when moving remaining diff files, break');
          break;
        }
        let originalAlbumTemp = await UserFileManagerAccess.getInstance().getAlbumByUri(diffIt.value[0]);
        await this.moveFile(diffIt.value[1], originalAlbumTemp, targetAlbum, startTime);
        diffIt = diffIterator.next();
      }
      let it = iterator.next();
      if (!it.done) {
        let nextOriginalAlbumUri: string = it.value[0];
        let nextOriginalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(nextOriginalAlbumUri);
        await this.handleAllAlbumsWithDiffFiles(it.value[1], diffSourceMap, repeatPhotoAlbumResultMap, 0, nextOriginalAlbumUri,
          nextOriginalAlbum, targetAlbum, iterator, startTime);
      } else {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onCompleted();
      }
      return;
    } else if (choiceMode === 'Skip') {
      // 先移动当前相册的不重名和重命名文件
      if (diffSourceMap.hasKey(originalAlbumUri)) {
        let diffSourceArray = diffSourceMap.get(originalAlbumUri);
        if (diffSourceArray && diffSourceArray.length > 0) {
          await this.moveFile(diffSourceArray, originalAlbum, targetAlbum, startTime);
          if (this.isCancelled) {
            Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled after moveFile, return');
            TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
            return;
          }
        }
        diffSourceMap.remove(originalAlbumUri);
      }
      // 移动剩余的不重名和重命名文件
      let diffIterator = diffSourceMap.entries();
      let diffIt = diffIterator.next();
      while (!diffIt.done) {
        if (this.isCancelled) {
          Log.info(TAG, 'handleAllAlbumsWithDiffFiles is cancelled when moving remaining diff files, break');
          break;
        }
        let originalAlbumTemp = await UserFileManagerAccess.getInstance().getAlbumByUri(diffIt.value[0]);
        await this.moveFile(diffIt.value[1], originalAlbumTemp, targetAlbum, startTime);
        diffIt = diffIterator.next();
      }
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else {
      AppStorage.set<boolean>('hasSameAssets', true);
      // 处理当前相册当前图片
      let currentSourceAsset: PhotoAsset = sourceAssets[index];
      let repeatSourceAsset: PhotoAsset = repeatPhotoAlbumResultMap.get(currentSourceAsset.displayName);
      let replaceCallback = async (): Promise<void> => {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
        try {
          albumChangeRequest.moveAssets([currentSourceAsset], targetAlbum);
          if (currentSourceAsset.uri !== repeatSourceAsset.uri) {
            operationImpl.trash([repeatSourceAsset.uri]);
          }
        } catch (err) {
          Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          this.onProcessDone();
          return;
        }
        if (this.isCancelled) {
          Log.info(TAG, 'replaceCallback is cancelled before applyChanges, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
        try {
          await this.photoAccessHelper?.applyChanges(albumChangeRequest);
          this.addCompletedFilesCount(1);
        } catch (err) {
          Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
        }
        await this.handleAllAlbumsWithDiffFiles(sourceAssets, diffSourceMap, repeatPhotoAlbumResultMap, index + 1, originalAlbumUri,
          originalAlbum, targetAlbum, iterator, startTime);
      };
      let skipCallback = async (): Promise<void> => {
        await this.handleAllAlbumsWithDiffFiles(sourceAssets, diffSourceMap, repeatPhotoAlbumResultMap, index + 1, originalAlbumUri,
          originalAlbum, targetAlbum, iterator, startTime);
      };
      let cancelCallback = (): void => {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      };
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_MOVE_DIALOG,
        [[currentSourceAsset, repeatSourceAsset], replaceCallback, skipCallback, cancelCallback]);
    }
  }

  // 递归处理多源相册弹窗图片
  /* instrument ignore next */
  private async handleAllAlbums(sourceAssets: PhotoAsset[], repeatPhotoAlbumResultMap: HashMap<string, PhotoAsset>,
    index: number, originalAlbum: PhotoAlbum | undefined, targetAlbum: PhotoAlbum | undefined,
    iterator: IterableIterator<[string, PhotoAsset[]]>, startTime: number): Promise<void> {
    if (this.isCancelled) {
      Log.info(TAG, 'handleAllAlbums is cancelled, return');
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      return;
    }
    // 当前相册数据处理完成
    if (index >= sourceAssets.length) {
      // 跳转下一相册
      let it = iterator.next();
      // 是否处理完所有相册
      if (!it.done) {
        let originalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(it.value[0]);
        await this.handleAllAlbums(it.value[1], repeatPhotoAlbumResultMap, 0, originalAlbum,
          targetAlbum, iterator, startTime);
      } else {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onCompleted();
      }
      return;
    }
    let choiceMode: string | undefined = AppStorage.get('choiceMode');
    Log.info(TAG, `MoveMenuOperation choiceMode = ${choiceMode}`);
    // 记住操作为替换
    if (choiceMode === 'Replace') {
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
        new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
      try {
        albumChangeRequest.moveAssets(sourceAssets.slice(index,), targetAlbum);
        let trashAssetUris: string[] = [];
        for (let asset of sourceAssets.slice(index,)) {
          let repeatPhotoAsset = repeatPhotoAlbumResultMap.get(asset.displayName);
          if (asset.uri !== repeatPhotoAsset.uri) {
            trashAssetUris.push(repeatPhotoAsset.uri);
          }
        }
        operationImpl.trash(trashAssetUris);
      } catch (err) {
        Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      }
      if (this.isCancelled) {
        Log.info(TAG, 'handleAllAlbums is cancelled before applyChanges, return');
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        return;
      }
      try {
        await this.photoAccessHelper?.applyChanges(albumChangeRequest);
        let movedCount = sourceAssets.length - index;
        this.addCompletedFilesCount(movedCount);
      } catch (err) {
        Log.error(TAG, `applyChanges failed :${err?.code}---${err}`);
      }
      let it = iterator.next();
      if (!it.done) {
        let originalAlbum = await UserFileManagerAccess.getInstance().getAlbumByUri(it.value[0]);
        await this.handleAllAlbums(it.value[1], repeatPhotoAlbumResultMap, 0, originalAlbum,
          targetAlbum, iterator, startTime);
      } else {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onCompleted();
      }
      return;
    } else if (choiceMode === 'Skip') {
      TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
      this.onCompleted();
      return;
    } else {
      AppStorage.set<boolean>('hasSameAssets', true);
      // 处理当前相册当前图片
      let currentSourceAsset: PhotoAsset = sourceAssets[index];
      let repeatSourceAsset: PhotoAsset = repeatPhotoAlbumResultMap.get(currentSourceAsset.displayName);
      let replaceCallback = async (): Promise<void> => {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(originalAlbum as PhotoAlbum);
        try {
          albumChangeRequest.moveAssets(sourceAssets, targetAlbum);
          if (currentSourceAsset.uri !== repeatSourceAsset.uri) {
            operationImpl.trash([repeatSourceAsset.uri]);
          }
        } catch (err) {
          Log.error(TAG, `albumChangeRequest.moveAssets is error : ${err.message}`);
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          this.onProcessDone();
          return;
        }
        if (this.isCancelled) {
          Log.info(TAG, 'replaceCallback is cancelled before applyChanges, return');
          TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
          return;
        }
        await UserFileManagerAccess.getInstance().getMediaLibrary().applyChanges(albumChangeRequest);
        this.addCompletedFilesCount(1);
        await this.handleAllAlbums(sourceAssets, repeatPhotoAlbumResultMap, index + 1, originalAlbum,
          targetAlbum, iterator, startTime);
      };
      let skipCallback = async (): Promise<void> => {
        await this.handleAllAlbums(sourceAssets, repeatPhotoAlbumResultMap, index + 1, originalAlbum,
          targetAlbum, iterator, startTime);
      };
      let cancelCallback = (): void => {
        TraceControllerUtils.finishTraceWithTaskId('moveFilesToAlbum', startTime);
        this.onProcessDone();
        return;
      };
      this.menuContext.broadCast?.emit(BroadCastConstants.SHOW_MOVE_DIALOG,
        [[currentSourceAsset, repeatSourceAsset], replaceCallback, skipCallback, cancelCallback]);
    }
  }

  public getExpectProgress(): number {
    Log.info(TAG, `getExpectProgress successBatch: ${this.successBatch}, currentBatch: ${this.currentBatch}, count: ${this.count}, totalBatches: ${this.totalBatches}, useUrlFlag: ${this.useUrlFlag}, completedFilesCount: ${this.completedFilesCount}`);
    if (this.count === 0) {
      return this.MAX_PROGRESS;
    }
    let progress: number;
    let completedFiles: number = this.completedFilesCount;
    completedFiles = Math.min(completedFiles, this.count);
    progress = Math.min(Math.floor(this.MAX_PROGRESS * completedFiles / this.count), this.MAX_PROGRESS);
    Log.info(TAG, `getExpectProgress result: ${progress}%, completedFiles: ${completedFiles}`);
    return progress;
  }

  public cyclicOperation(): void {
    Log.info(TAG, 'cyclicOperation successBatch: ' + this.successBatch + ', currentBatch: ' + this.currentBatch + `  totalBatches: ` + this.totalBatches + `, completedFilesCount: ${this.completedFilesCount}`);
    let completedCount: number = Math.min(this.completedFilesCount, this.count);
    if (this.successBatch >= this.totalBatches) {
      Log.info(TAG, 'All batches completed, updating progress to 100%');
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
    Log.info(TAG, 'onProcessDone: All batches completed, ensuring progress is 100%');
    this.updateProgress(this.MAX_PROGRESS, this.count);
    setTimeout(() => {
      this.navigationPageFunc?.();
      if (this.startTime != null) {
        let operateCount = this.count;
        let costTime = Date.now() - this.startTime;
        Log.debug(TAG, `process data operate done, operate ${operateCount} items, cost time ${costTime} ms,\
              average ${(costTime / operateCount)} .`);
        let e2eLatency = Date.now() - this.startTime;
        // operationTypeList 是基类的私有属性，这里直接检查 operationType 是否为 ADD_PHOTOS_TO_ALBUM
        if (e2eLatency >= BigDataConstants.FAULT_THRESHOLD && this.operationType === 'ADD_PHOTOS_TO_ALBUM') {
          Log.info(TAG, 'onProcessDone reportOperationLatency');
          ReportToBigDataUtil.reportOperationLatency(this.operationType, this.startTime, e2eLatency, operateCount);
        }
      }
      TraceControllerUtils.finishTraceWithTaskId(this.traceOperationType + '_ProgressOperation', this.requestTime);
      this.onOperationEnd?.(this.isError, this.successBatch, this.count);
      this.selectAssets.splice(0, this.selectAssets.length);
    }, 1000);
  }

  // 重命名
  private async renameSource(source: PhotoAsset) {
    let title: string = photoAccessHelper.PhotoKeys.TITLE.toString();
    source.set(title, source.get(title) + '_' + String(Date.now()));
    await source.commitModify(); // 修改title
  }
}