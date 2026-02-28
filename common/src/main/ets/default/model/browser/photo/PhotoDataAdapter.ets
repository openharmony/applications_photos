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
/* instrument ignore file */

import lazy image from '@ohos.multimedia.image';
import type common from '@ohos.app.ability.common';
import type { ImageRequest } from './pipeline/ImageRequest';
import lazy { Builder } from './pipeline/ImageRequest';
import lazy { ImagePipeline } from './pipeline/ImagePipeline';
import type { RequestContext } from './pipeline/RequestContext';
import type { RequestListener } from './pipeline/RequestListener';
import lazy { Thumbnail } from './Thumbnail';
import lazy { PerformanceTracker } from './PerformaceTracker';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { PhotoDataSource } from './PhotoDataSource';
import lazy { Log, reportEmpty } from '../../../utils/Log';
import lazy { ReportToBigDataUtil } from '../../../utils/ReportToBigDataUtil';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { ResultsData } from '../../ResultsData';
import type { MediaItem } from './MediaItem';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import type { BrowserDataInterface } from '../../../interface/BrowserDataInterface';
import lazy { PhotoDataImpl } from './PhotoDataImpl';
import lazy { Constants } from '../../../model/common/Constants';
import lazy { SelectParams } from '../../../model/common/SelectParams';
import lazy { DecodeProcessor } from './pipeline/DecodeProcessor';
import lazy { BrowserDataFactory } from '../../../interface/BrowserDataFactory';
import lazy { DeviceInfo } from '../../../utils/DeviceInfo';
import lazy { SystemPropertiesManager } from '../../../utils/SystemPropertiesManager';
import lazy { ImageDecodeUtils } from './ImageDecodeUtils';
import lazy { BroadCastManager } from '../../common/BroadCastManager';
import type { BroadCast } from '../../../utils/BroadCast';
import { MovingPhoto } from '../../../access/UserFileManagerAccess';

const TAG = 'PhotoDataAdapter';
const CACHE_RANGE: number = 1;
const IMAGE_DECODE_STRATEGY_EVENT_ID = 'DECODE_STRATEGY';
const STRATEGY_ORIGIN: string = 'origin';
const STRATEGY_DOWNSAMPLING: string = 'downsampling';

enum TaskType {
  /**
   * 适应屏幕
   */
  FIT,

  /**
   * 高清
   */
  HIGH_RESOLUTION
}

export class DecodeFinishParam {
  public uri: string = '';
  public uniqueId: string = '';
  public thumb: Thumbnail | undefined;
  public isMovingPhoto: boolean = false;
  public movingPhoto: MovingPhoto | undefined;
}

class RequestResultDispatcher implements RequestListener<Thumbnail> {
  private dataAdapter: PhotoDataAdapter;
  private dataSource: PhotoDataSource;
  public onDeCodeFinishCb: Function = (dfp: DecodeFinishParam): void => {
  };

  constructor(dataAdapter: PhotoDataAdapter, dataSource: PhotoDataSource, cb: Function) {
    this.dataAdapter = dataAdapter;
    this.dataSource = dataSource;
    this.onDeCodeFinishCb = cb;
  }

  public onRequestStart(context: RequestContext<Thumbnail>): void {
  }

  public onRequestFinish(context: RequestContext<Thumbnail>): void {
    if (!context || context.isCancelled) {
      Log.warn(TAG, `onRequestFinish failed context is null`);
      context?.result?.release();
      return;
    }

    let current: number = this.dataSource.getCurrentIndex();
    for (let i = current - CACHE_RANGE; i <= current + CACHE_RANGE; i++) {
      let result: ResultsData = this.dataSource.getRawData(i);
      if (!result) {
        continue;
      }
      let item: MediaItem | undefined = result.data;
      if (!item || !context.request?.item) {
        continue;
      }
      let isValid: boolean = !context.request?.item?.getDateModified() &&
      PhotoDataAdapter.isUriValid(context.request?.item, item);
      if (PhotoDataAdapter.isUriValid(context.request?.item, item) && this.onDeCodeFinishCb) {
        Log.info(TAG, `onRequestFinish uri: ${item.uri}`)
        const dfp: DecodeFinishParam = {
          uri: item.uri,
          uniqueId: item.uniqueId,
          thumb: this.dataAdapter.getCachedThumbnail(item.uri),
          isMovingPhoto: false,
          movingPhoto: undefined,
        }
        this.onDeCodeFinishCb(dfp);
      }
    }
  }

  public onProcessorStart(context: RequestContext<Thumbnail>, processorName: string): void {
  }

  public onProcessorFinish(context: RequestContext<Thumbnail>, processName: string): void {
  }
}

/**
 * 大图缩略图缓存，统一管理大图缩略图的请求以及编排
 */
export class PhotoDataAdapter {
  /**
   * 缩略图加载完成事件
   */
  public static readonly EVENT_THUMBNAIL_LOADED_PREFIX = 'event_thumbnail_loaded_';
  public static readonly REFRESH_MOVING_PHOTO_AFTER_REQ = 'refresh_moving_photo_after_req';
  public static readonly PHOTO_LARGE_IMAGE_SIZE: number = 6000;
  private static readonly PRELOAD_ORIGIN_MAX_SIZE: number = 4500;
  private static readonly DECODE_ORIGIN_THRESHOLD: number = 10000;
  private static readonly HEIC_DECODE_ORIGIN_THRESHOLD: number = 10000;
  private static readonly DECODE_MAX_HEIGHT_OR_WIDTH: number = 8192;
  private static readonly HEIC_DECODE_MAX_HEIGHT_OR_WIDTH: number = 16000;
  private readonly KEY_TASK_TYPE: string = 'key_task_type';
  private caches: Map<string, RequestContext<Thumbnail>> = new Map();
  private performanceTracker: PerformanceTracker = new PerformanceTracker();
  public static yuvEnable: boolean = true;
  private requests: RequestContext<Thumbnail>[] = []; // 高质量图任务队列
  private currentRequest: RequestContext<Thumbnail> | undefined = undefined; // 当前正在进行的高质量图任务，完成后置空，再从队列里取下一个
  private broadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  /**
   * 清除缓存
   */
  public clear(): void {
    this.caches.forEach((request: RequestContext<Thumbnail>, uri: string): void => {
      this.releaseCache(request);
    });
    this.caches.clear();
    this.requests = [];
  }

  /**
   * 获取缓存的缩略图
   *
   * @returns 缩略图数据
   */
  public getThumbnail(item: MediaItem): Thumbnail | undefined {
    Log.info(TAG, "getThumbnail: " + item);
    if (!item) {
      Log.info(TAG, 'getThumbnail: invalid');
      return new Thumbnail();
    }

    // step1 尝试获取缓存的缩略图数据
    let thumbReq: RequestContext<Thumbnail> | undefined = this.caches.get(item.uri);
    if (thumbReq) {
      // 缩略图请求存在的情况下取缓存数据
      let cached: Thumbnail | undefined = this.getCachedThumbnail(item?.uri);
      if (cached) {
        Log.info(TAG, `getThumbnail: cached ${JSON.stringify(cached)}`);
        return cached;
      }
    }

    // step2 获取不到的情况下返回默认的lcd图
    let result: Thumbnail = this.getThumbnailInner(item);
    Log.info(TAG, `getThumbnail: new ${JSON.stringify(result)}`);
    return result;
  }

  public getCachedThumbnail(uri: string): Thumbnail | undefined {
    let request: RequestContext<Thumbnail> | undefined = this.caches.get(uri);
    if (!request || !request.result) {
      return;
    }
    Log.info(TAG, `getCachedThumbnail-success: ${JSON.stringify(request.result)}`);
    return request.result;
  }

  private getThumbnailInner(item: MediaItem): Thumbnail {
    // uri传-1、-1,媒体库直接返回lcd图,对应媒体库MediaLibraryManager::QueryThumbnail接口
    if (item?.width === 0 || item?.height === 0) {
      Log.warn(TAG, `getThumbnailSafe with width==0 and height==0, sourceUri: ${item?.uri}}`);
    }
    let lcdUri = ImageUtil.getLCDUri(item?.uri, item?.path, item?.getDateModified?.());
    let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    if (userId > 0) {
      Log.info(TAG, `getThumbnailInner lcdUri and userId : lcdUri = ${lcdUri}`);
      lcdUri += `&user=${userId}`;
    }
    return new Thumbnail(lcdUri);
  }

  public getImageSource(item: MediaItem, size: image.Size): string {
    let photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let thumbnail = photoDataImpl?.getThumbnailSafe(item.uri, item.path, item.getDateModified(), size);
    Log.info(TAG, `getImageSource thumbnail: ${thumbnail == undefined}
          ,getDateModified:${item.getDateModified()}, uri:${item.uri},`);
    return thumbnail;
  }

  // 大图缩略图uri获取
  /* instrument ignore next */
  private getThumbnailSafe(sourceUri: string, path: string, modifiedDate: number, size?: image.Size): string {
    try {
      if (size) {
        if (size.width === 0 || size.height === 0) {
          Log.warn(TAG, `getThumbnailSafe with width==0 and height==0, sourceUri: ${sourceUri}}, size: ${
          JSON.stringify(size)}`);
        }
        return `${sourceUri}?timestampApp=${
        modifiedDate}&oper=thumbnail&width=${size.width}&height=${size.height}&path=${path}`;
      } else {
        return `${sourceUri}?timestampApp=${modifiedDate}&oper=thumbnail&width=${256}&height=${256}&path=${path}`;
      }
    } catch (err) {
      Log.warn(TAG, `get Thumbnail Failed! msg:${err}, code: ${err?.code}`);
      return '';
    }
  }

  /**
   * 释放超大图
   *
   * @param currentUri 当前展示的照片uri
   */
  public clearCache(currentUri?: string | undefined) {
    this.caches.forEach((thumbnail: RequestContext<Thumbnail>, uri: string): void => {
      if (thumbnail.request?.item?.getIsMovingPhoto?.()) {
        // 动图不需要释放
        return;
      }
      const width: number = thumbnail?.result?.width ?? 0;
      const height: number = thumbnail?.result?.height ?? 0;
      const MAX_SIZE: number = PhotoDataAdapter.PHOTO_LARGE_IMAGE_SIZE * PhotoDataAdapter.PHOTO_LARGE_IMAGE_SIZE;
      if ((width * height > MAX_SIZE) && uri !== currentUri) {
        Log.info(TAG, `clearCache remove request ${uri}`);
        this.releaseCache(thumbnail);
        this.caches.delete(uri);
        this.deleteRequest(uri);
      }
    });
  }

  /**
   * 更新缓存，按需发起请求
   *
   * @param dataSource 数据源
   * @param broadcast 广播器
   * @param current swiper当前元素index
   * @returns
   */
  public updateRequests(dataSource: PhotoDataSource, onDeCodeFinishCb: Function, current: number,
    isAnimating: boolean): void {
    Log.info(TAG, `updateRequests current: ${current}`);
    if (!dataSource || !onDeCodeFinishCb) {
      return;
    }

    // 确定新缓存范围的数据
    const TASK_ID: number = new Date().getTime();
    TraceControllerUtils.startTraceWithTaskId(`updateRequests-${current}`, TASK_ID);
    let toBeAdded: Map<number, MediaItem> = new Map();
    for (let i = current - CACHE_RANGE; i <= current + CACHE_RANGE; i++) {
      let result: ResultsData = dataSource.getRawData(i);
      if (!reportEmpty?.(result)) {
        continue;
      }
      let item: MediaItem | undefined = reportEmpty?.(result.data);
      if (!item || item.mediaType === photoAccessHelper.PhotoType.VIDEO || item.isGifOrWebpType?.()) {
        continue;
      }
      toBeAdded.set(i, item);
    }
    // 清理掉不在缓存区的请求及数据
    this.removeUnusedCaches(toBeAdded);

    // 按需发起请求
    this.submitTasks(dataSource, onDeCodeFinishCb, toBeAdded, current, isAnimating);
    TraceControllerUtils.finishTraceWithTaskId(`updateRequests-${current}`, TASK_ID);
  }

  /**
   * 生成高质量图请求任务
   * @param dataSource
   * @param onDeCodeFinishCb
   * @param toBeAdded
   * @param currentItem
   * @param isAnimating
   */
  private submitTasks(dataSource: PhotoDataSource, onDeCodeFinishCb: Function, toBeAdded: Map<number, MediaItem>,
    currentItem: number, isAnimating: boolean): void {
    const TASK_ID: number = new Date().getTime();
    TraceControllerUtils.startTraceWithTaskId('submitTasks', TASK_ID);
    const appCtx: common.Context = AppStorage.get<common.Context>('photosGlobalContext') as common.Context;
    toBeAdded.forEach((item: MediaItem, index: number) => {
      let isCloud: boolean = item.getPosition?.() === photoAccessHelper.PositionType.CLOUD;
      if (isCloud) {
        Log.debug(TAG, `submitTasks isCloud return, uri: ${item.uri}, index: ${index}`);
        return;
      }

      let shouldReqHighRes: boolean;
      // 在大图打开时解码首张，一镜到底动效结束后解码左1右1
      if (isAnimating) {
        shouldReqHighRes = index === currentItem;
      } else {
        shouldReqHighRes = Math.abs(index - currentItem) <= 1;
      }

      if (!shouldReqHighRes) {
        // 非当前图片，取消原图请求，通知替换thumbnail
        Log.info(TAG, `submitTasks should not requests, uri: ${item.uri}, index: ${index}`);
        this.releaseRequestIfInValid(item);
        if (!item.getIsMovingPhoto?.()) {
          const dfp: DecodeFinishParam = {
            uri: item.uri,
            uniqueId: item.uniqueId,
            thumb: this.getCachedThumbnail(item.uri),
            isMovingPhoto: false,
            movingPhoto: undefined,
          }
          onDeCodeFinishCb(dfp);
        }
        return;
      }

      let request: RequestContext<Thumbnail> | undefined = this.caches.get(item.uri);
      if (request) {
        // 任务已经在队列里，触发一次
        this.pickAndSendRequest();
        return;
      }

      // 大图浏览场景，heif格式的图片，前后各一张低于4.5k * 4.5k分辨率的照片则进行源码解析
      const isHeicImage: boolean = this.isHeicImage(item.mimeType);
      const maxSize: number = PhotoDataAdapter.PRELOAD_ORIGIN_MAX_SIZE * PhotoDataAdapter.PRELOAD_ORIGIN_MAX_SIZE;
      if (index !== currentItem && (item.imgOriginWidth * item.imgOriginHeight >= maxSize)) {
        let msg: string[] = [];
        msg.push(`PhotoItem HEIF Preloaded: ${isHeicImage}`);
        msg.push(`index !== currentItem: ${index !== currentItem}, index：${index}, currentIten ${currentItem}`);
        msg.push(`width: ${item.imgOriginWidth}, height: ${item.imgOriginHeight}`);
        Log.info(TAG, msg.join(', '));
        return;
      }

      Log.info(TAG, `createHighResRequest, uri: ${item.uri}, index: ${index}`);
      this.createHighResRequest(appCtx, dataSource, onDeCodeFinishCb, item);
    });
    TraceControllerUtils.finishTraceWithTaskId('submitTasks', TASK_ID);
  }

  private releaseRequestIfInValid(item: MediaItem) {
    let request: RequestContext<Thumbnail> | undefined = this.caches.get(item.uri);
    if (request && !request.isCancelled || !PhotoDataAdapter.isValid(request?.request?.item, item)) {
      this.releaseCache(request);
    }
  }

  public updateHighResRequest(dataSource: PhotoDataSource, onDeCodeFinishCb: Function, item: MediaItem): void {
    if (!dataSource || !onDeCodeFinishCb) {
      return;
    }
    const TASK_ID: number = new Date().getTime();
    TraceControllerUtils.startTraceWithTaskId('updateHighResRequest-current', TASK_ID);
    this.submitHighResTasks(dataSource, onDeCodeFinishCb, item);
    TraceControllerUtils.finishTraceWithTaskId('updateHighResRequest-current', TASK_ID);
  }

  private submitHighResTasks(dataSource: PhotoDataSource, onDeCodeFinishCb: Function, item: MediaItem): void {
    if (this.caches.get(item.uri)) {
      return;
    }
    const appCtx: common.Context = AppStorage.get<common.Context>('photosGlobalContext') as common.Context;
    this.createHighResRequest(appCtx, dataSource, onDeCodeFinishCb, item);
  }

  /**
   * 判断两者数据是否仍合法
   *
   * @param lhs 左侧输入
   * @param rhs 右侧输入
   * @returns 是否合法
   */
  public static isValid(lhs: MediaItem | undefined, rhs: MediaItem | undefined): boolean {
    if (!lhs || !rhs) {
      return false;
    }

    if (lhs === rhs) {
      return true;
    }

    return lhs.uri === rhs.uri && lhs.getDateModified?.() === rhs.getDateModified?.();
  }

  public static isUriValid(lhs: MediaItem | undefined, rhs: MediaItem | undefined): boolean {
    if (!lhs || !rhs) {
      return false;
    }

    if (lhs === rhs) {
      return true;
    }

    return lhs.uri === rhs.uri;
  }

  /**
   * 发起原图请求
   * @param appCtx
   * @param dataSource
   * @param onDeCodeFinishCb
   * @param item
   */
  private createHighResRequest(appCtx: common.Context, dataSource: PhotoDataSource, onDeCodeFinishCb: Function,
    item: MediaItem) {
    // 视频暂不支持抽帧，不发起高清请求
    if (item.mediaType === photoAccessHelper.PhotoType.VIDEO || item.width === 0 || item.height === 0) {
      return;
    }
    TraceControllerUtils.startTrace('createHighResRequest');
    const isHeicImage: boolean = this.isHeicImage(item.mimeType);
    let highResSize: image.Size = this.calculateDownSampledSize(item, isHeicImage);
    let highResOptions: image.DecodingOptions = { desiredSize: highResSize };
    highResOptions.desiredDynamicRange = image.DecodingDynamicRange.SDR;
    if (PhotoDataAdapter.yuvEnable) {
      this.getHighResOptions(highResOptions, highResSize, item);
    }
    let thumbnail: Thumbnail | undefined = this.getThumbnailInner(item);
    let photoDataImpl: PhotoDataImpl | BrowserDataInterface | undefined =
      dataSource?.getAlbumDataSource()?.photoDataImpl;
    let imageRequest: ImageRequest = new Builder()
      .setAlbum(dataSource.getAlbumDataSource()?.albumUri as string)
      .setItem(item)
      .setUri(thumbnail.url)
      .setOptions(highResOptions)
      .setIsNewApi((photoDataImpl?.getIsNewApiQuery() ? photoDataImpl?.getIsNewApiQuery() : false))
      .build();
    let listeners: RequestListener<Thumbnail>[] =
      [this.performanceTracker, new RequestResultDispatcher(this, dataSource, onDeCodeFinishCb)];
    let initParams: Map<string, Object> = new Map<string, Object>([[this.KEY_TASK_TYPE, TaskType.HIGH_RESOLUTION]]);

    let highRequest: RequestContext<Thumbnail> | undefined = ImagePipeline.getInstance()
      .create(appCtx, imageRequest, listeners, initParams) as RequestContext<Thumbnail> | undefined;
    this.addRequest(item, highRequest);
    TraceControllerUtils.finishTrace('createHighResRequest');
  }

  private calculateDownSampledSize(item: MediaItem, isHeicImage: boolean): image.Size {
    const DECODE_ORIGIN_THRESHOLD = isHeicImage ? PhotoDataAdapter.HEIC_DECODE_ORIGIN_THRESHOLD
      : PhotoDataAdapter.DECODE_ORIGIN_THRESHOLD;
    let highResSize: image.Size =
      this.getHighResSize(item.imgOriginWidth, item.imgOriginHeight, DECODE_ORIGIN_THRESHOLD);
    const DECODE_MAX_HEIGHT_OR_WIDTH = DeviceInfo.isNSVPlatform() ? PhotoDataAdapter.HEIC_DECODE_MAX_HEIGHT_OR_WIDTH
      : PhotoDataAdapter.DECODE_MAX_HEIGHT_OR_WIDTH;
    if (Math.max(highResSize.height, highResSize.width) > DECODE_MAX_HEIGHT_OR_WIDTH) {
      highResSize = this.maxWidthOrHeightResize(item.imgOriginWidth, item.imgOriginHeight, DECODE_MAX_HEIGHT_OR_WIDTH);
    }
    return highResSize;
  }

  private reportDecodeStrategy(item: MediaItem): void {
    if (item.width === 0 || item.height === 0) {
      return;
    }
    let lcdSize: image.Size = ImageUtil.toLcd(item.width, item.height);
    let highResSize: image.Size = this.getHighResSize(item.width, item.height);

    // 只要请求的lcd/high小于原图就是下采样，其他必然解原图
    let strategy: string = Math.max(item.width, item.height) > Math.max(lcdSize.width, lcdSize.height) &&
      Math.max(item.width, item.height) > Math.max(highResSize.width, highResSize.height) ?
      STRATEGY_DOWNSAMPLING : STRATEGY_ORIGIN;

    interface OriInfo {
      strategy: string;
      oriWidth: number;
      oriHeight: number;
    };
    let oriInfo: OriInfo = {
      'strategy': strategy,
      oriWidth: item.width,
      oriHeight: item.height,
    }

    ReportToBigDataUtil.statisticReport(IMAGE_DECODE_STRATEGY_EVENT_ID, oriInfo);
  }

  private getHighResOptions(highResOptions: image.DecodingOptions, highResSize: image.Size, item: MediaItem): void {
    if (PhotoDataAdapter.isNeedYuvDecode(item)) {
      if (highResOptions.desiredDynamicRange === image.DecodingDynamicRange.HDR) {
        // highResOptions.photoDesiredPixelFormat = image.PixelMapFormat.YCBCR_P010;
        highResOptions.desiredPixelFormat = image.PixelMapFormat.YCBCR_P010;
      } else {
        highResOptions.desiredPixelFormat = image.PixelMapFormat.NV21;
      }
    }
    Log.info(TAG, `picture mime, uri: ${item.uri} type: ${item.mimeType?.toLowerCase()}, height: ${
    highResSize.height}, width: ${highResSize.width}, photoDesiredPixelFormat: ${
    highResOptions.desiredPixelFormat}`);
  }

  public static isNeedYuvDecode(item: MediaItem): boolean {
    if ((item.mimeType?.toLowerCase() === Constants.MIME_TYPE_JPEG ||
      item.mimeType?.toLowerCase() === Constants.MIME_TYPE_HEIC)) {
      return true;
    }
    return false;
  }

  private getHighResSize(imageWidth: number, imageHeight: number,
    decodeOriginThreshold: number = PhotoDataAdapter.DECODE_ORIGIN_THRESHOLD): image.Size {
    // 总像素数低于阈值（DECODE_ORIGIN_THRESHOLD^2）解原图
    if (imageWidth * imageHeight <= decodeOriginThreshold * decodeOriginThreshold) {
      return { width: imageWidth, height: imageHeight };
    }

    // 总像素数高于阈值时，以阈值作为缩放后图片总像素数的上限，来进行缩放
    const ratio: number = imageWidth / imageHeight;

    // h * h * ratio = T * T，易得 scale = (T * T / ratio) ^ (1/2) / h
    const scale: number = Math.sqrt(decodeOriginThreshold * decodeOriginThreshold / ratio) / imageHeight;
    const NEAR_PIX: number = 0.01;
    return {
      width: Math.floor(imageWidth * scale + NEAR_PIX),
      height: Math.floor(imageHeight * scale + NEAR_PIX),
    };
  }

  private isHeicImage(mimeType: string): boolean {
    Log.info(TAG, `isHeicImage：${mimeType}`);
    return mimeType.toLowerCase().indexOf('heic') !== -1;
  }

  private maxWidthOrHeightResize(imageWidth: number, imageHeight: number, maxLength: number): image.Size {
    // 单边大于8000，需要对齐8000
    const ratio: number = maxLength / Math.max(imageWidth, imageHeight);

    const NEAR_PIX: number = 0.01;
    return {
      width: Math.floor(imageWidth * ratio + NEAR_PIX),
      height: Math.floor(imageHeight * ratio + NEAR_PIX),
    };
  }

  /**
   * 清理掉不在缓存区的请求及数据
   * @param toBeAdded
   */
  private removeUnusedCaches(toBeAdded: Map<number, MediaItem>): void {
    this.caches.forEach((request: RequestContext<Thumbnail>, uri: string): void => {
      let found: boolean = false;
      for (let item of toBeAdded.values()) {
        if (uri === item.uri) {
          found = true;
          break;
        }
      }
      if (!found) {
        Log.info(TAG, `removeUnusedCaches uri: ${uri}`);
        this.releaseCache(request);
        this.caches.delete(uri);
        this.deleteRequest(uri);
      }
    });
  }

  private releaseCache(request: RequestContext<Thumbnail> | undefined): void {
    if (request === undefined) {
      return;
    }
    if (request.request?.uri === this.currentRequest?.request?.uri) {
      Log.info(TAG, `releaseCache, release current request`)
      this.currentRequest = undefined;
    }
    request.isCancelled = true;
    if (request.result !== undefined) {
      request.result.release();
      request.result = undefined;
    } else if (request.params.has(DecodeProcessor.KEY_ORIGIN_REQUEST_ID)) {
      const requestId: string = String(request.params.get(DecodeProcessor.KEY_ORIGIN_REQUEST_ID));
      photoAccessHelper.MediaAssetManager.cancelRequest(request.appCtx, requestId);
      Log.info(TAG, `releaseCache requestId = ${requestId}`);
    } else {
      Log.warn(TAG, `request.result = undefined, requestId = null, uri = ${request.request?.uri}`);
    }
  }

  /**
   * 重启任务，再获取一次
   * */
  public resetPhotoRequest(uri: string) {
    Log.info(TAG, `resetPhotoRequest uri: ${uri}`)
    let request: RequestContext<Thumbnail> | undefined = this.caches.get(uri);
    if (request) {
      this.releaseCache(request);
      this.caches.delete(uri);
      this.deleteRequest(uri);
    } else {
      Log.error(TAG, `resetPhotoRequest failed request is undefined`);
    }
  }

  // 添加任务并开始执行任务
  private addRequest(item: MediaItem, context: RequestContext<Thumbnail> | undefined) {
    if (context !== undefined) {
      Log.info(TAG, `addRequest, uri: ${item.uri}, isFinished: ${context.isFinished}`);
      this.caches.set(item.uri, context);
      // 二阶段完成已完成的高质量图直接sendRequest，不再添加任务到requests
      if (item.isHighQuality) {
        this.sendRequest(context);
        return;
      }
      this.requests.push(context);
      this.pickAndSendRequest();
    } else {
      Log.warn(TAG, `createHighResRequest add request failed, uri: ${item.uri}`);
    }
  }

  // 任务取消后，找到并删除任务
  private deleteRequest(uri: string) {
    let indexToRemove = -1;
    for (let i = 0; i < this.requests.length; i++) {
      if (uri === this.requests[i].request?.item?.uri) {
        indexToRemove = i;
        break;
      }
    }
    if (indexToRemove !== -1) {
      this.requests.splice(indexToRemove, 1);
    }
  }

  // 从队列中取出第一个任务，并执行
  public pickAndSendRequest() {
    // 1，如果当前正在进行一个任务，或者没有等待执行的任务了 return
    Log.info(TAG,
      `pickAndSendRequest requests: ${this.requests.length}, currentRequest: ${this.currentRequest?.request?.item?.uri}, isFinished: ${this.currentRequest?.isFinished}`);
    if (this.currentRequest && !this.currentRequest.isFinished) {
      return;
    }
    if (this.requests.length === 0) {
      return;
    }
    // 2，从队列里取一个任务，并send，记录当前正在进行的任务
    this.currentRequest = this.requests.shift();
    this.sendRequest(this.currentRequest);
  }

  private sendRequest(context: RequestContext<Thumbnail> | undefined) {
    if (!context) {
      Log.warn(TAG, `sendRequest faile context is null`);
      return;
    }
    let request: ImageRequest | undefined = context.request;
    if (!request) {
      Log.warn(TAG, `sendRequest faile request is null`);
      return;
    }
    let item = request.item;
    if (!item) {
      Log.warn(TAG, `sendRequest faile item is null`);
      return;
    }

    if (item.getIsMovingPhoto?.()) {
      // 动图
      Log.info(TAG, `[movingPhoto] request medialibrary start, uri: ${item.uri}}`);
      let onDeCodeFinishCb: Function | undefined = context.onDeCodeFinishCb;

      // 静态图
      Log.info(TAG, `submit high request uri: ${item.uri}, options: ${JSON.stringify(context.request?.options)}`);
      ImagePipeline.getInstance().submitContext(context);
      TraceControllerUtils.startTrace(`HighResRequest${item.uri}`);
    }
  }
}