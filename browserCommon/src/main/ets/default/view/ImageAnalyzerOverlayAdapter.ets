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

import lazy Matrix4 from '@ohos.matrix4';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { Log, reportEmpty } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { MsgDownloadFinish } from '@ohos/common/src/main/ets/default/model/common/BigDataDotting';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy image from '@ohos.multimedia.image';
import lazy { FaceBeautyHelper } from '../utils/FaceBeautyHelper';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_ImageAnalyzerOverlayAdapter';

export interface OcrCacheData {
  ocr_text?: string;
  ocr_text_msg?: string;
  width?: number;
  height?: number;
}

export interface SubjectObject {
  pixelMap: image.PixelMap;
  rect: Rect;
}

export interface Rect {
  left: number,
  top: number,
  right: number,
  bottom: number,
}

/**
 * 除以 2 计算常数
 */
const HALF_DIVIDER: number = 2;

/**
 * 图片缩放矩阵中，x 轴方向偏移参数下标
 */
const MATRIX_TRANSLATE_X_INDEX: number = 12;

/**
 * 图片缩放矩阵中，y 轴方向偏移参数下标
 */
const MATRIX_TRANSLATE_Y_INDEX: number = 13;

/**
 * AI 组件，用于识别图片上文字内容
 */

class SubjectCacheDataItem {
  public uri: string;
  public dateModified: number;
  public cacheData: Object;

  constructor(uri: string, dateModified: number, cacheData: Object) {
    this.uri = uri;
    this.dateModified = dateModified;
    this.cacheData = cacheData;
  }
}

class TextCacheDataItem {
  public uri: string;
  public dateModified: number;
  public cacheData: string;

  constructor(uri: string, dateModified: number, cacheData: string) {
    this.uri = uri;
    this.dateModified = dateModified;
    this.cacheData = cacheData;
  }
}

class DownloadTask {
  public uri: string;
  public size: number;
  public timer: number;

  constructor(uri: string, size: number) {
    this.uri = uri;
    this.size = size;
    this.timer = 0;
  }
}

@Component
export struct ImageAnalyzerOverlayAdapter {
  /**
   * 标记当前屏幕是否为横屏
   */
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  /**
   * 当前图片 index 信息
   */
  @Consume currentIndex: number;
  /**
   * 当前图片 MediaItem 信息，通过媒体库数据查询得到
   */
  @Link @Watch('onPhotoChanged') curItem: MediaItem;
  /**
   * 是否执行跟手下拉动效
   */
  @Link @Watch('onVisibilityChange') isPullDownAndDragPhoto: boolean;
  /**
   * 标记当前是否正在执行一镜到底动效
   */
  @Link @Watch('onVisibilityChange') isRunningAnimation: boolean;
  /**
   * AI 组件相关变量，标志图片的形变信息，同步给 AI 控件
   */
  @Link @Watch('onImageMatrixChange') analyzerMatrix: Matrix4.Matrix4Transit;
  /**
   * 标志 Swiper 组件是否正在执行切图动画
   */
  @Link @Watch('onVisibilityChange') isDoingImageSlideAnimation: boolean;
  @Link @Watch('onVisibilityChange') isInAnimateToPosition: boolean;
  /**
   * AI 组件相关变量，控制此时是否支持响应平移手势
   */
  @Link canRespondPanGesture: boolean;
  /**
   * 标志当前是否支持上滑唤出图片详情
   */
  @Consume @Watch('onVisibilityChange') isPullingUp: boolean;
  /**
   * 标记是否禁止 Swiper 滑动切图
   */
  @Consume disableSwipe: boolean;
  /**
   * AI 组件相关变量，控件宽高比
   */
  @Link analyzerRatio: number;
  /**
   * AI 组件相关变量，控件宽度
   */
  @Link analyzerImageWidth: string;
  /**
   * AI 组件相关变量，控件高度
   */
  @Link analyzerImageHeight: string;
  /**
   * 当前窗口高度，用于计算气泡位置
   */
  private windowLayoutHeight: number = getScreen().getWinLayoutHeight();
  /**
   * AI 组件相关变量，点击响应模式
   */
  @Link hitMode: HitTestMode;
  /**
   * AI 组件相关变量，控制 AI 组件是否可见
   */
  @Link analyzerVisibility: Visibility;
  /**
   * AI 组件相关变量，控制 AI Button 是否可见
   */
  @Link @Watch('onAIButtonVisibilityChange') aiButtonVisibility: boolean;
  /**
   * AI 组件相关变量，控制 AI 组件是否上组件树
   */
  @Link canShowImageAnalyzer: boolean;
  /**
   * AI 组件相关变量，标志当前是否点击了 AI 组件气泡
   */
  @Link isTappingAiButton: boolean;
  /**
   * AI 组件相关变量，标志当前 isTappingAiButton 状态是否改变
   */
  @Link isTappingAiButtonChange: boolean;
  /**
   * AI 组件相关变量，标志当前是否显示AI Menu
   */
  @Link isMenuShow: boolean;
  /**
   * AI 组件相关变量，标志当前 isMenuShow 状态是否改变
   */
  @Link isMenuShowStatusChange: boolean;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择文本
   */
  @Link hasSelectedText: boolean;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择的文本是否有变化
   */
  @Link isSelectedTextChange: boolean;
  /**
   * AI 组件相关变量，标志当前拖动，多选文本
   */
  @Link isOnDragText: boolean;
  /**
   * AI 组件相关变量，当前图片是否已有 LCD 图
   */
  @Link @Watch('onPhotoChanged') isCurrentLcdReady: boolean;
  @Link @Watch('onDataShow') isScrolling: boolean;
  @Link @Watch('onImageAnalyzePause') isImageAnalyzePaused: boolean;
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  /**
   * 图片内容分析器，用于图片文字识别
   */
  // @State imageAnalyzer: ImageAnalyzer = createImageAnalyzer();
  // /**
  //  * 图片形变矩阵，用于记录图片形变信息（缩放、位移、旋转等）
  //  */
  // @State layoutMatrix: LayoutMatrix = createLayoutMatrix();
  // /**
  //  * AI 组件手势交互回调
  //  */
  // private actionListener: CustomConfig = createCustomConfig();
  /**
   * AI 组件已选中文本
   */
  private selectText: string = '';
  /**
   * AI 组件气泡纵向位移值
   */
  private aiButtonOffset: number = 0;
  /**
   * AI 组件可见属性变化回调
   */
  private onVisibilityChangeCallback: Function = (): void => {
  };
  private onWinSizeChangedCallBack: Function = (): void => {
    this.onWinSizeChanged()
  };
  // Action name for AI button listener
  /**
   * AI 组件手势交互回调关键字，可见性变化
   */
  public static readonly MASK_VISIBILITY_CHANGE: string = 'onMaskVisibilityChange';
  /**
   * AI 组件手势交互回调关键字，可见性变化
   */
  public static readonly MENU_VISIBILITY_CHANGE: string = 'onMenuVisibilityChange';
  /**
   * AI 组件手势交互回调关键字，拖动选择文本开始
   */
  public static readonly DRAG_TEXT_START: string = 'onDragTextStart';
  /**
   * AI 组件手势交互回调关键字，拖动选择文本结束
   */
  public static readonly DRAG_TEXT_END: string = 'onDragTextEnd';
  /**
   * AI 组件手势交互回调关键字，长按
   */
  public static readonly LONG_PRESS_LINE: string = 'onLongPressLine';
  /**
   * AI 组件手势交互回调关键字，AI 气泡高亮
   */
  public static readonly TYPE_SHOW: string = 'show';
  public static readonly TIMEOUT_FOR_IMAGE_ANALYZE: number = 1600;
  public static readonly DELAY_FOR_IMAGE_ANALYZE: number = 500;
  public static readonly SUBJECT_CACHE_DATA_MAX_CNT: number = 5;
  private subjectCacheDataArray: SubjectCacheDataItem[] = [];
  public static readonly TEXT_CACHE_DATA_MAX_CNT: number = 50;
  private textCacheDataArray: TextCacheDataItem[] = [];
  private ocrCacheData: string = '';
  private ocrCacheDataFlag: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onOcrCacheDataReadyFunc: Function =
    (uri: string, ocrCacheData: string): void => this.onOcrCacheDataReady(uri, ocrCacheData);
  private onFaceBeautyStateReadyFunc: Function =
    (uri: string, faceBeautyState: string): void => this.onFaceBeautyStateReady(uri, faceBeautyState);
  private faceInfo: string = '';
  private subjectObject: SubjectObject[] = [];
  // private dataSource: PhotoDataSource | undefined = undefined;
  private itemHashCode: string = '';
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  public static readonly PENDDING_DOWNLOAD_TASK_MAX_CNT: number = 1;
  public static readonly DOWNLOAD_TIMEOUT: number = 600000;
  private downloadTaskArray: DownloadTask[] = [];
  private curDownloadTask: DownloadTask | undefined = undefined;
  private changeOverlayFlag: boolean = false;
  private jumpPhotoChange: boolean = false;

  aboutToAppear() {
    Log.info(TAG, 'aboutToAppear');
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    // if (FaceBeautyHelper.isSupportFaceBeauty(this.dataSource?.getAlbumUri())) {
    //   this.appBroadCast.on(FaceBeautyConstants.AI_FACE_BEAUTY_STATE_IS_READY, this.onFaceBeautyStateReadyFunc);
    // }
  }

  aboutToDisappear() {
    Log.info(TAG, 'aboutToDisappear');
    this.itemHashCode = '';
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    // if (FaceBeautyHelper.isSupportFaceBeauty(this.dataSource?.getAlbumUri())) {
    //   this.appBroadCast.off(FaceBeautyConstants.AI_FACE_BEAUTY_STATE_IS_READY, this.onFaceBeautyStateReadyFunc);
    // }
  }

  build() {
    Stack() {
      if (this.canShowImageAnalyzer && !this.isScrolling) {
        // ImageAnalyzerOverlay({
        //   layoutMatrix: this.layoutMatrix,
        //   imageAnalyzer: this.imageAnalyzer,
        //   componentCreateDelayTime: ImageAnalyzerOverlayAdapter.DELAY_FOR_IMAGE_ANALYZE,
        //   config: this.actionListener,
        // })
        //   .key('ImageAnalyzerOverlayAdapter')
        //   .aspectRatio(this.analyzerRatio)
        //   .width(this.analyzerImageWidth as string)
        //   .height(this.analyzerImageHeight as string)
        //   .visibility(this.analyzerVisibility)
        //   .onAreaChange((oldValue: Area, newValue: Area) => {
        //     this.updateOverlayBubble(newValue);
        //   })
      }
    }
  }

  private onImageAnalyzePause(): void {
    // if (this.imageAnalyzer) {
    //   Log.info(TAG, `onImageAnalyzePause ${this.isImageAnalyzePaused}`);
    //   if (this.isImageAnalyzePaused) {
    //     this.imageAnalyzer?.pause();
    //   } else {
    //     this.imageAnalyzer?.resume();
    //   }
    // }
  }

  private onFaceBeautyStateReady(uri: string, faceBeautyState: string): void {
    this.hitMode = HitTestMode.Transparent;
    if (!this.curItem) {
      return;
    }
    if (this.curItem.uri.length === 0) {
      return;
    }
    if (this.curItem.uri !== uri) {
      Log.info(TAG, 'this.curItem.uri !== uri');
      return;
    }
    this.curItem.beautyState = faceBeautyState;
    Log.info(TAG, `onFaceBeautyStateReady faceBeautyState is ${faceBeautyState}`);
  }

  private checkOriginalImage(): void {
    if (!this.isMediaLibraryUri(this.curItem.uri)) {
      return;
    }
    // if (UserFileManagerAccess.isRecycleBin(this.dataSource?.getAlbumUri())) {
    //   UserFileManagerAccess.getInstance().getTrashAssetByUri(this.curItem.uri).then(
    //     (fileAsset: PhotoAsset | undefined): void => {
    //       this.addOriginalImageDownload(fileAsset);
    //     });
    // } else {
    //   UserFileManagerAccess.getInstance()
    //     .getObject(AlbumDefine.getFileFetchOptByUri(this.curItem.uri))
    //     .then((fileAsset: PhotoAsset | undefined): void => {
    //       this.addOriginalImageDownload(fileAsset);
    //     });
    // }
  }

  private addOriginalImageDownload(fileAsset: PhotoAsset | undefined): void {
    if (!fileAsset) {
      return;
    }
    let filePosition: photoAccessHelper.PositionType =
      fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
    if (filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD) {
      let dropFlag: boolean = false;
      this.downloadTaskArray.forEach((downloadTaskItem: DownloadTask) => {
        if (downloadTaskItem.uri === fileAsset.uri) {
          dropFlag = true;
        }
      });
      if (dropFlag) {
        Log.info(TAG, `Double download ${fileAsset.uri}, downloadTaskArray.length: ${this.downloadTaskArray.length}`);
        return;
      }

      let downloadTask: DownloadTask = new DownloadTask(fileAsset.uri, Number(fileAsset.get('size')));
      Log.debug(TAG, `Need to download ${
      downloadTask?.uri}, downloadTaskArray.length: ${this.downloadTaskArray.length}`);
      if (this.curDownloadTask) {
        this.downloadTaskArray.push(downloadTask);
        Log.debug(TAG, `Add ${downloadTask?.uri}, downloadTaskArray.length: ${this.downloadTaskArray.length}`);
        if (this.downloadTaskArray.length > ImageAnalyzerOverlayAdapter.PENDDING_DOWNLOAD_TASK_MAX_CNT) {
          let delTask: DownloadTask | undefined = this.downloadTaskArray.shift();
          Log.debug(TAG, `After remove ${delTask?.uri}, downloadTaskArray.length: ${this.downloadTaskArray.length}`);
        }
        Log.info(TAG, `Add ${downloadTask?.uri}, downloadTaskArray.length: ${this.downloadTaskArray.length}`);
        return;
      }
      this.ExecuteDownloadTaskInner(downloadTask);
    }
  }

  private ExecuteNextDownloadTask(): void {
    Log.info(TAG, 'Start to download next photo');
    if (this.downloadTaskArray.length > 0) {
      let newDownloadTask: DownloadTask | undefined = this.downloadTaskArray.shift();
      if (newDownloadTask) {
        // if (UserFileManagerAccess.isRecycleBin(this.dataSource?.getAlbumUri())) {
        //   UserFileManagerAccess.getInstance()
        //     .getTrashAssetByUri(newDownloadTask.uri)
        //     .then((fileAsset: PhotoAsset | undefined): void => {
        //       this.ExecuteDownloadTask(newDownloadTask, fileAsset);
        //     });
        // } else {
        //   UserFileManagerAccess.getInstance()
        //     .getObject(AlbumDefine.getFileFetchOptByUri(newDownloadTask.uri))
        //     .then((fileAsset: PhotoAsset | undefined): void => {
        //       this.ExecuteDownloadTask(newDownloadTask, fileAsset);
        //     });
        // }
        return;
      }
    }
    this.curDownloadTask = undefined;
  }

  private ExecuteDownloadTask(downloadTask: DownloadTask | undefined, fileAsset: PhotoAsset | undefined): void {
    if (downloadTask && fileAsset) {
      let filePosition: photoAccessHelper.PositionType =
        fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
      if (filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD) {
        this.ExecuteDownloadTaskInner(downloadTask);
        return;
      }
      Log.info(TAG, `${downloadTask.uri} has been downloaded, so drop it and download next`);
      this.ExecuteNextDownloadTask();
    }
  }

  private ExecuteDownloadTaskInner(downloadTask: DownloadTask): void {
    let startTime: number = 0;
    let downloadFinishCallback: Function = (err: string = '') => {
      ReportToBigDataUtil.downloadOriginReport(BigDataConstants.DOWNLOAD_FOR_EDIT, Date.now() - startTime, err);
      if (err) {
        return;
      }
      Log.info(TAG, `downloadFinishCallback photo: ${downloadTask.uri}`);
      // 下载完成打点
      let msg: MsgDownloadFinish = {
        scene: BigDataConstants.DOWNLOAD_FOR_EDIT,
        network: this.networkAvailable ? BigDataConstants.NETWORK_AVAILABLE : BigDataConstants.NETWORK_UNAVAILABLE,
        size: downloadTask.size ?? Number.NaN,
        timeCost: Date.now() - startTime,
      }
      ReportToBigDataUtil.report(BigDataConstants.DOWNLOAD_ORIGIN_PHOTO_ID, msg);
      if (this.curDownloadTask && this.curDownloadTask.timer > 0) {
        clearTimeout(this.curDownloadTask.timer);
        this.curDownloadTask.timer = 0;
      }
      this.ExecuteNextDownloadTask();
    }
    // 下载起始时间
    startTime = Date.now();
    this.curDownloadTask = downloadTask;
    this.curDownloadTask.timer = setTimeout((): void => {
      Log.info(TAG, 'download timeout');
      if (this.curDownloadTask) {
        this.curDownloadTask.timer = 0;
      }
      this.ExecuteNextDownloadTask();
    }, ImageAnalyzerOverlayAdapter.DOWNLOAD_TIMEOUT);
    Log.info(TAG, `Start to download current photo: ${this.curDownloadTask?.uri}`);
  }

  private refreshSubjectCache(uri: string): void {
    let i: number = 0;
    for (i = 0; i < this.subjectCacheDataArray.length; i++) {
      if (this.subjectCacheDataArray[i].uri === uri) {
        this.subjectCacheDataArray.splice(i, 1);
        // this.imageAnalyzer.setOriginResource(uri);
        return;
      }
    }
  }

  private saveCurrentFastEditState(): void {
    if (this.curItem.beautyState !== '') {
      // this.actionListener.setConfig(FaceBeautyConstants.AI_FACE_BEAUTY_STATE_KEY, Object(this.curItem.beautyState));
      Log.info(TAG, `saveCurrentFastEditState: item beautystate is ${this.curItem.beautyState}`)
    } else {
      // MediaItem刷新 重新查询美肤状态
      FaceBeautyHelper.isBeauty(this.curItem).then((state: string) => {
        if (state !== FaceBeautyConstants.AI_FAILURE_FACE_BEAUTY_STATE) {
          this.curItem.beautyState = state;
          // this.actionListener.setConfig(FaceBeautyConstants.AI_FACE_BEAUTY_STATE_KEY, Object(state));
          Log.info(TAG, `saveCurrentFastEditState: rebuild adapter beautystate is ${state}`)
        }
      });
    }
  }

  private isMediaLibraryUri(uri: string): boolean {
    // return (
    //   String(uri).startsWith(PhotoDataSource.MEDIA_URL_PREFIX_STR) ||
    //   String(uri).startsWith(PhotoDataSource.IMAGE_URL_PREFIX_STR_V10) ||
    //   String(uri).startsWith(PhotoDataSource.VIDEO_URL_PREFIX_STR_V10) ||
    //   String(uri).startsWith(PhotoDataSource.IMAGE_VIDEO_URL_PREFIX_STR_V10));
    return false
  }

  private onOcrCacheDataReady(uri: string, ocrCacheData: string): void {
    Log.debug(TAG, `onOcrCacheDataReady: uri[${uri}], ocrCacheData[${ocrCacheData}].`);
    if (!this.curItem) {
      return;
    }
    if (this.curItem.uri.length === 0) {
      return;
    }
    if (!this.curItem.ocrCacheDataFlag) {
      return;
    }
    if (this.curItem.uri !== uri) {
      return;
    }

    // if (!this.isMediaLibraryUri(uri)) {
    //   this.updateImageAnalyzerWithUri(uri);
    // } else if (UserFileManagerAccess.isRecycleBin(this.dataSource?.getAlbumUri())) {
    //   UserFileManagerAccess.getInstance().getTrashAssetByUri(this.curItem.uri).then(
    //     (fileAsset: PhotoAsset | undefined): void => {
    //       this.updateImageAnalyzer(fileAsset);
    //     });
    // } else {
    //   UserFileManagerAccess.getInstance()
    //     .getObject(AlbumDefine.getFileFetchOptByUri(this.curItem.uri))
    //     .then((fileAsset: PhotoAsset | undefined): void => {
    //       this.updateImageAnalyzer(fileAsset);
    //     });
    // }
  }

  private onWinSizeChanged(): void {
    this.windowLayoutHeight = getScreen().getWinLayoutHeight();
  }

  /**
   * AI 组件可见性变化回调
   */
  private onVisibilityChange(): void {
    if (!this.onVisibilityChangeCallback) {
      Log.debug(TAG, 'onVisibilityChange: callback in undefined.');
      return;
    }
    this.onVisibilityChangeCallback();
  }

  /**
   * 图片形变矩阵信息变化回调
   */
  private onImageMatrixChange(): void {
    let analyzerMatrix: Matrix4.Matrix4Transit = this.analyzerMatrix;
    if (!analyzerMatrix || analyzerMatrix === undefined) {
      Log.error(TAG, 'onImageMatrixChange: analyzerMatrix is undefined.');
    }
    let mat: number[] | undefined = (analyzerMatrix.copy() as Matrix4x4).matrix4x4;
    if (!mat) {
      Log.warn(TAG, `mat is ${String(mat)}`);
      return;
    }
    let scale: number = mat[0];
    // this.layoutMatrix.scale = scale;
    // let xTranslate: number = mat[MATRIX_TRANSLATE_X_INDEX];
    // let yTranslate: number = mat[MATRIX_TRANSLATE_Y_INDEX];
    // this.layoutMatrix.offsetX = px2vp(xTranslate);
    // this.layoutMatrix.offsetY = px2vp(yTranslate);
    // Log.debug(TAG, `analyzerMatrix = ${JSON.stringify(analyzerMatrix)}, this.layoutMatrix.scale = ${
    // this.layoutMatrix.scale}, this.layoutMatrix.offsetX = ${
    // this.layoutMatrix.offsetX}, this.layoutMatrix.offsetY = ${this.layoutMatrix.offsetY}`);
  }

  private getSubjectCacehDataFromArray(uri: string, dateModified: number): SubjectCacheDataItem | undefined {
    let i: number = 0;
    for (i = 0; i < this.subjectCacheDataArray.length; i++) {
      if (this.subjectCacheDataArray[i].uri === uri) {
        if (this.subjectCacheDataArray[i].dateModified !== dateModified) {
          return undefined;
        }
        return this.subjectCacheDataArray[i];
      }
    }
    return undefined;
  }

  private getTextCacehDataFromArray(uri: string, dateModified: number): TextCacheDataItem | undefined {
    let i: number = 0;
    for (i = 0; i < this.textCacheDataArray.length; i++) {
      if (this.textCacheDataArray[i].uri === uri) {
        if (this.textCacheDataArray[i].dateModified !== dateModified) {
          return undefined;
        }
        return this.textCacheDataArray[i];
      }
    }
    return undefined;
  }

  /**
   * AI 组件手势交互回调注册
   */
  private setAiButtonListener(): void {
    if (!this.changeOverlayFlag) {
      return;
    }
    // this.actionListener = createCustomConfig({
    //   functionTypes: ['subject', 'text'],
    //   subjectConfig: {
    //     onSubjectAnalyzed: (tag: string | undefined, subjects): void => {
    //       this.subjectObject = subjects;
    //       Log.info(TAG, `on subject analyzed callback, subjects: ${JSON.stringify(subjects)}`);
    //     },
    //     onSubjectCacheData: (tag: string | undefined, cachesData): void => {
    //       Log.info(TAG, 'on subject cache data callback');
    //       this.checkOriginalImage();
    //       if (this.getSubjectCacehDataFromArray(this.curItem.uri, this.curItem.getDateModified())) {
    //         return;
    //       }
    //       this.subjectCacheDataArray.push(
    //         new SubjectCacheDataItem(this.curItem.uri, this.curItem.getDateModified(), cachesData));
    //       Log.debug(TAG, `this.subjectCacehDataArray.length: ${this.subjectCacheDataArray.length}`);
    //       if (this.subjectCacheDataArray.length > ImageAnalyzerOverlayAdapter.SUBJECT_CACHE_DATA_MAX_CNT) {
    //         let delItem: SubjectCacheDataItem | undefined = this.subjectCacheDataArray.shift();
    //         Log.debug(TAG, `after remove ${delItem?.uri}, this.subjectCacehDataArray.length: ${
    //         this.subjectCacheDataArray.length}`);
    //       }
    //     },
    //     onSubjectFaceData: (tag: string | undefined, faces: string): void => {
    //       this.faceInfo = faces;
    //     },
    //     isEnableSkinSmoothing: FaceBeautyHelper.isSupportFaceBeauty(this.dataSource?.getAlbumUri()),
    //     onSubjectMenuClicked: (tag: string | undefined, action: string) => {
    //     }
    //   },
    //   textConfig: {
    //     aIButtonAllowedShow: true,
    //     allTextMaskAutoShow: false,
    //     pictureItemsAllowedShow: false,
    //     useDefaultTranslate: true,
    //     onTextSelectChanged: (tag: string | undefined, text: string, lineCount: number) => {
    //       this.isSelectedTextChange = this.selectText != text;
    //       this.hasSelectedText = lineCount > 0;
    //       Log.debug(TAG, `on text select changed: ${lineCount}, hasSelectedText = ${
    //       this.hasSelectedText}, this.isSelectedTextChange = ${this.isSelectedTextChange}`);
    //       this.selectText = text ? text : '';
    //       this.disableSwipe = this.hasSelectedText;
    //       if (!this.hasSelectedText) {
    //         this.hitMode = HitTestMode.Transparent;
    //       }
    //     },
    //     onImageAnalyzed: (tag: string | undefined, result: string) => {
    //       Log.debug(TAG, 'OnImageAnalyzed');
    //       this.hasSelectedText = false;
    //       if (this.getTextCacehDataFromArray(this.curItem.uri, this.curItem.getDateModified())) {
    //         return;
    //       }
    //       this.textCacheDataArray.push(new TextCacheDataItem(this.curItem.uri, this.curItem.getDateModified(), result));
    //       Log.debug(TAG, `this.textCacheDataArray.length: ${this.textCacheDataArray.length}`);
    //       if (this.textCacheDataArray.length > ImageAnalyzerOverlayAdapter.TEXT_CACHE_DATA_MAX_CNT) {
    //         let delItem: TextCacheDataItem | undefined = this.textCacheDataArray.shift();
    //         Log.debug(TAG, `after remove ${delItem?.uri}, ${delItem?.dateModified}, this.textCacheDataArray.length: ${
    //         this.textCacheDataArray.length}`);
    //       }
    //     }
    //   },
    //   // Respond when click AI button
    //   onTouchAction: (action: string, parameters) => {
    //     Log.debug(TAG, `OnTouchAction: ${action}, ${JSON.stringify(parameters)}`);
    //     if (action === ImageAnalyzerOverlayAdapter.MASK_VISIBILITY_CHANGE) {
    //       let isTap: boolean = parameters?.type === ImageAnalyzerOverlayAdapter.TYPE_SHOW;
    //       this.isTappingAiButtonChange = isTap != this.isTappingAiButton;
    //       this.isTappingAiButton = isTap;
    //       this.onAIButtonVisibilityChange();
    //     }
    //     if (action === ImageAnalyzerOverlayAdapter.MENU_VISIBILITY_CHANGE) {
    //       let isMenu: boolean = parameters?.type === ImageAnalyzerOverlayAdapter.TYPE_SHOW;
    //       this.isMenuShowStatusChange = isMenu != this.isMenuShow;
    //       this.isMenuShow = isMenu;
    //     }
    //     if (action === ImageAnalyzerOverlayAdapter.DRAG_TEXT_START ||
    //       action === ImageAnalyzerOverlayAdapter.LONG_PRESS_LINE) {
    //       this.isOnDragText = true;
    //     }
    //     // PhotoItem do not respond panGesture when analyzerOverlay is dragging for select text
    //     if (action === ImageAnalyzerOverlayAdapter.DRAG_TEXT_START) {
    //       this.hitMode = HitTestMode.Default;
    //       this.canRespondPanGesture = false;
    //       this.disableSwipe = true;
    //     }
    //     if (action === ImageAnalyzerOverlayAdapter.DRAG_TEXT_END) {
    //       this.hitMode = HitTestMode.Transparent;
    //       this.isOnDragText = false;
    //       this.disableSwipe = false;
    //     }
    //   },
    // });
  }

  private onPhotoChanged(): void {
    if (this.itemHashCode === this.curItem.hashCode || this.jumpPhotoChange) {
      return;
    }
    this.isTappingAiButton = false;
    this.isTappingAiButtonChange = false;
    this.isMenuShow = false;
    this.isMenuShowStatusChange = false;
    this.isSelectedTextChange = false;
    this.hasSelectedText = false;
    if (this.curItem === undefined || this.curItem.uri === undefined) {
      Log.debug(TAG, 'something wrong with loading current photo.');
      return;
    }
    let isImageType: boolean = this.curItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE;
    let isMovingPhoto: boolean = this.curItem.getIsMovingPhoto();
    if (!isImageType || isMovingPhoto) {
      this.canShowImageAnalyzer = false;
      this.itemHashCode = this.curItem.hashCode;
      Log.debug(TAG, `onPhotoChanged: mediaType = ${this.curItem.mediaType}, isMovingPhoto = ${isMovingPhoto}`);
      return;
    }
    if (!this.isCurrentLcdReady) {
      Log.debug(TAG, 'onPhotoChanged: LCD is not ready.');
      return;
    }
    this.isImageAnalyzePaused = false;
    this.analyzerRatio = ImageUtil.calcRatio({ width: this.curItem.width, height: this.curItem.height });
    this.itemHashCode = this.curItem.hashCode;
    Log.info(TAG, `onPhotoChanged: currentIndex = ${this.currentIndex}, uri = ${this.curItem.uri}, hashCode = ${
    this.curItem.hashCode}, ratio = ${this.analyzerRatio}, size = (${this.analyzerImageWidth}, ${
    this.analyzerImageHeight})`);
    this.doPhotoChanged();
  }

  private doPhotoChanged(): void {
    // if (!this.isMediaLibraryUri(this.curItem.uri)) {
    //   this.loadImageIntoAnalyzerWithUri(this.curItem.uri);
    //   this.setAiButtonListener();
    // } else if (UserFileManagerAccess.isRecycleBin(this.dataSource?.getAlbumUri())) {
    //   UserFileManagerAccess.getInstance().getTrashAssetByUri(this.curItem.uri).then(
    //     (fileAsset: PhotoAsset | undefined): void => {
    //       this.loadImageIntoAnalyzer(fileAsset);
    //       this.setAiButtonListener();
    //     });
    // } else {
    //   UserFileManagerAccess.getInstance().getObject(AlbumDefine.getFileFetchOptByUri(this.curItem.uri))
    //     .then((fileAsset: PhotoAsset | undefined): void => {
    //       this.loadImageIntoAnalyzer(fileAsset);
    //       this.setAiButtonListener();
    //       if (FaceBeautyHelper.isSupportFaceBeauty(this.dataSource?.getAlbumUri())) {
    //         this.saveCurrentFastEditState();
    //       }
    //     });
    // }
  }

  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  private getLcdUri(): string {
    let size: image.Size = { width: -1, height: -1 };
    if (this.curItem?.width !== 0 && this.curItem?.height !== 0) {
      size = ImageUtil.toLcd(this.curItem?.width ?? 0, this.curItem?.height ?? 0);
    }
    return ImageUtil.getLCDUriWithSize(this.curItem?.uri, this.curItem?.path, this.curItem?.getDateModified?.(), size);
  }

  private updateImageAnalyzer(fileAsset: PhotoAsset | undefined): void {
    let uri: string = this.curItem.uri;
    if (fileAsset) {
      let filePosition: photoAccessHelper.PositionType =
        fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
      if (filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD && this.curItem?.index != undefined) {
        let mediaResult: MediaResult | undefined;
        // if (this.curItem?.index !== undefined) {
        //   mediaResult = this.dataSource?.packData(this.curItem?.index, this.curItem);
        // }
        if (mediaResult) {
          uri = this.getLcdUri();
        }
      }
    }
    this.updateImageAnalyzerWithUri(uri);
  }

  private updateImageAnalyzerWithUri(uri: string): void {
    // Log.info(TAG, `Photo uri is ${uri}`);
    // let analyzer: ImageAnalyzer;
    // if (this.canShowImageAnalyzer === false) {
    //   analyzer = createImageAnalyzer();
    //   this.changeOverlayFlag = true;
    // } else {
    //   analyzer = this.imageAnalyzer;
    //   this.changeOverlayFlag = false;
    // }
    // let textCacheDataString: string = '';
    // let ocrCacheDataFlag: boolean = false;
    // if (this.curItem.ocrCacheDataFlag && this.curItem.ocrCacheData) {
    //   let textCacheDataObject: RecognizeData = {};
    //   let ocrObj: OcrCacheData = JSON.parse(this.curItem.ocrCacheData) as OcrCacheData;
    //   if (ocrObj.width && ocrObj.height) {
    //     let ocrDetectWidth: number = Number(ocrObj.width ? ocrObj.width : this.curItem.width);
    //     let ocrDetectHeight: number = Number(ocrObj.height ? ocrObj.height : this.curItem.height);
    //     textCacheDataObject = {
    //       ocrData: ocrObj.ocr_text_msg,
    //       detectWidth: ocrDetectWidth,
    //       detectHeight: ocrDetectHeight,
    //     };
    //     textCacheDataString = JSON.stringify(textCacheDataObject);
    //     ocrCacheDataFlag = true;
    //   } else {
    //     Log.info(TAG, `ocrObj width: ${ocrObj.width}, height: ${ocrObj.height}`);
    //   }
    // } else {
    //   let textCacehDataItem: TextCacheDataItem | undefined =
    //     this.getTextCacehDataFromArray(this.curItem.uri, this.curItem.getDateModified());
    //   if (textCacehDataItem) {
    //     Log.info(TAG, `getTextCacehDataFromArray for: ${this.curItem.uri}, ${this.curItem.getDateModified()}`);
    //     textCacheDataString = textCacehDataItem.cacheData;
    //     ocrCacheDataFlag = true;
    //   }
    // }
    //
    // let subjectCacehData: SubjectCacheDataItem | undefined =
    //   this.getSubjectCacehDataFromArray(this.curItem.uri, this.curItem.getDateModified());
    // let emptyObject: Object = new Object();
    //
    // if (textCacheDataString.length > 0) {
    //   Log.info(TAG, 'Start AI overlay with textCacheDataObject');
    // } else {
    //   Log.info(TAG, 'Start AI overlay without textCacheDataObject');
    // }
    // if (subjectCacehData?.cacheData) {
    //   Log.info(TAG, 'Start AI overlay with subjectCacehData');
    // } else {
    //   Log.info(TAG, 'Start AI overlay without subjectCacehData');
    // }
    //
    // let cacheData: Record<string, Object> = {
    //   'text': ocrCacheDataFlag ? textCacheDataString : emptyObject,
    //   'subject': subjectCacehData ? subjectCacehData.cacheData : emptyObject
    // }
    // analyzer.setOriginResource(uri, cacheData);
    //
    // this.imageAnalyzer = analyzer;
  }

  /**
   * 向 imageAnalyzer 加载图片回调
   */
  private loadImageIntoAnalyzer(fileAsset: PhotoAsset | undefined): void {
    Log.info(TAG, `current photo in analyzer is ${this.curItem.uri}, this.aiButtonOffset = ${
    this.aiButtonOffset}, this.analyzerVisibility = ${this.analyzerVisibility}, this.aiButtonVisibility = ${
    this.aiButtonVisibility}`);
    this.updateImageAnalyzer(fileAsset);
    this.loadImageIntoAnalyzerInner();
  }

  private loadImageIntoAnalyzerWithUri(uri: string) {
    Log.info(TAG, `current photo in analyzer is ${this.curItem.uri}, this.aiButtonOffset = ${
    this.aiButtonOffset}, this.analyzerVisibility = ${this.analyzerVisibility}, this.aiButtonVisibility = ${
    this.aiButtonVisibility}`);
    this.updateImageAnalyzerWithUri(uri);
    this.loadImageIntoAnalyzerInner();
  }

  private loadImageIntoAnalyzerInner() {
    // let layoutMatrix: LayoutMatrix = createLayoutMatrix();
    // layoutMatrix.overlayObjectFit = ImageFit.Cover;
    // this.layoutMatrix = layoutMatrix;
    // this.layoutMatrix.aiButtonBottomOffset = this.aiButtonOffset;
    // this.layoutMatrix.aiButtonVisibility = this.aiButtonVisibility;
    //
    // this.onImageMatrixChange();
    // this.canShowImageAnalyzer = true;
    // this.onVisibilityChange();
  }

  /**
   * 刷新 AI 组件气泡绘制
   * @param area 当前图片绘制区域信息
   */
  private updateOverlayBubble(area: Area): void {
    // let componentHeight = area.height;
    // if (typeof componentHeight !== 'number' || !Number.isFinite(componentHeight)) {
    //   reportEmpty(componentHeight, 'componentHeight');
    //   return;
    // }
    // let delta = (this.windowLayoutHeight - componentHeight) / HALF_DIVIDER;
    // let res: Resource = this.isHorizontal || this.isFoldExpanded ?
    // $r('app.float.slider_bar_horizon_height') : this.isFullMode ?
    //   $r('app.float.slider_ai_bar_height') : $r('app.float.slider_bar_height');
    // let context: Context = getContext(this).createModuleContext(res.bundleName, res.moduleName);
    // // Thumbnails list height (vp)
    // let listHeight: number = context.resourceManager.getNumber(res.id);
    // let offset: number = (this.isHorizontal || this.isFoldExpanded ?
    //   0 : Constants.ToolBarHeight) + listHeight - delta;
    // this.aiButtonOffset = offset > 0 ? offset : 0;
    // if (this.canShowImageAnalyzer) {
    //   this.layoutMatrix.aiButtonBottomOffset = this.aiButtonOffset;
    // }
    // Log.debug(TAG, `complete event info, canShowImageAnalyzer = ${this.canShowImageAnalyzer}, currentIndex= ${
    // this.currentIndex}, aiButtonBottomOffset = ${this.layoutMatrix.aiButtonBottomOffset}, componentHeight = ${
    // componentHeight}, delta = ${delta}, offset = ${offset}, listHeight = ${listHeight}, area = ${
    // JSON.stringify(area)}`);
  }

  /**
   * 刷新 AI 组件气泡状态
   */
  private onAIButtonVisibilityChange(): void {
    // if (this.canShowImageAnalyzer) {
    //   if (!this.isTappingAiButton || this.aiButtonVisibility) {
    //     this.layoutMatrix.aiButtonVisibility = this.aiButtonVisibility;
    //   }
    //   Log.info(TAG, `onAIButtonVisibilityChange, this.aiButtonVisibility=${
    //   this.aiButtonVisibility}, this.isTappingAiButton = ${this.isTappingAiButton}`);
    // }
  }

  private onDataShow() {
    Log.info(TAG, `isScrolling Change ${this.isScrolling}`);
    if (!this.isScrolling) {
      this.jumpPhotoChange = false;
      this.onPhotoChanged();
    } else {
      this.jumpPhotoChange = true;
      this.canShowImageAnalyzer = false;
    }
  }
}