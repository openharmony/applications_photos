/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

/**
 * @file Helper functions to access image and video assets
 * @kit MediaLibraryKit
 */

import type { AsyncCallback, Callback } from './@ohos.base';
import type Context from './application/Context';
import type image from './@ohos.multimedia.image';
import type dataSharePredicates from './@ohos.data.dataSharePredicates';
import type { CustomColors } from './@ohos.arkui.theme';
import { relationalStore } from '@kit.ArkData';

/**
 * Helper functions to access image and video assets
 *
 * @namespace photoAccessHelper
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @since 10
 */
/**
 * Helper functions to access image and video assets
 *
 * @namespace photoAccessHelper
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @atomicservice
 * @since 11
 */
declare namespace photoAccessHelper {
  class AnalysisAlbum implements Album {
    imageCount?: number | undefined;
    videoCount?: number | undefined;

    commitModify(callback: AsyncCallback<void, void>): void;

    commitModify(): Promise<void>;

    addAssets(assets: PhotoAsset[], callback: AsyncCallback<void, void>): void;

    addAssets(assets: PhotoAsset[]): Promise<void>;

    removeAssets(assets: PhotoAsset[], callback: AsyncCallback<void, void>): void;

    removeAssets(assets: PhotoAsset[]): Promise<void>;

    recoverAssets(assets: PhotoAsset[], callback: AsyncCallback<void, void>): void;

    recoverAssets(assets: PhotoAsset[]): Promise<void>;

    deleteAssets(assets: PhotoAsset[], callback: AsyncCallback<void, void>): void;

    deleteAssets(assets: PhotoAsset[]): Promise<void>;

    setCoverUri(uri: string, callback: AsyncCallback<void, void>): void;

    setCoverUri(uri: string): Promise<void>;

    getFaceId(): Promise<string>;

    albumType: AlbumType;
    albumSubtype: AlbumSubtype;
    albumName: string;
    albumUri: string;
    count: number;
    coverUri: string;

    getAssets(options: FetchOptions, callback: AsyncCallback<FetchResult<PhotoAsset>, void>): void;

    getAssets(options: FetchOptions): Promise<FetchResult<PhotoAsset>>;

    getAssetsSync(options: FetchOptions): PhotoAsset[];
    getIntimacyInfo(options: FetchOptions): Promise<string>;
    getSharedPhotoAssets(options: FetchOptions): SharedPhotoAsset[];

    constructor(album: Album);
    getOrderPosition(assets: Array<PhotoAsset>): Promise<Array<number>>;
    getAlbumInfo(option: string): Promise<string>;

    static getAnalysisAlbum(subtype: AlbumSubtype, option?: string): Promise<FetchResult<Album>>;
  }
  /**
   * Returns an instance of PhotoAccessHelper
   *
   * @param { Context } context - Hap context information
   * @returns { PhotoAccessHelper } Instance of PhotoAccessHelper
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * <br>2. Incorrect parameter types; 3. Parameter verification failed.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @StageModelOnly
   * @since 10
   */
  /**
   * Returns an instance of PhotoAccessHelper
   *
   * @param { Context } context - Hap context information
   * @returns { PhotoAccessHelper } Instance of PhotoAccessHelper
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * <br>2. Incorrect parameter types; 3. Parameter verification failed.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @StageModelOnly
   * @atomicservice
   * @since 11
   */
  function getPhotoAccessHelper(context: Context): PhotoAccessHelper;

  /**
   * Returns an instance of PhotoAccessHelper
   *
   * @param { Context } context - Hap context information
   * @param { number } userId - user id
   * @returns { PhotoAccessHelper } Instance of PhotoAccessHelper
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
   * <br>2. Incorrect parameter types; 3. Parameter verification failed.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @StageModelOnly
   * @atomicservice
   * @since 11
   */
  function getPhotoAccessHelper(context: Context, userId: number): PhotoAccessHelper;
  /**
   * Enumeration change types of data change.
   *
   * @enum { number } NotifyChangeType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  enum NotifyChangeType {
    /**
     * Data(assets or albums) have been newly created.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    NOTIFY_CHANGE_ADD = 0,
    /**
     * Data(assets or albums) have been modified.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    NOTIFY_CHANGE_UPDATE = 1,
    /**
     * Data(assets or albums) have been removed.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    NOTIFY_CHANGE_REMOVE = 2,
  }

  /**
   * Enumeration of different types of photos
   *
   * @enum { number } PhotoType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * Enumeration of different types of photos
   *
   * @enum { number } PhotoType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  enum PhotoType {
    /**
     * Image asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Image asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    IMAGE = 1,
    /**
     * Video asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Video asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    VIDEO
  }

  /**
   * Enumeration type of watermarktypes of photos
   *
   * @enum { number } WatermarkType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  enum WatermarkType {
    /**
     * WatermarkType of Default
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    DEFAULT = 0,

    /**
     * WatermarkType of BRAND_COMMON
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    BRAND_COMMON = 1,

    /**
     * WatermarkType of COMMON
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    COMMON = 2,

    /**
     * WatermarkType of BRAND
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    BRAND = 3,
  }

  /**
   * Enumeration of different categories of photos
   *
   * @enum { number } PhotoSubtype
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 10
   */
  /**
   * Enumeration of different categories of photos
   *
   * @enum { number } PhotoSubtype
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  enum PhotoSubtype {
    /**
     * Default Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    /**
     * Default Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    DEFAULT = 0,
    /**
     * Screenshot Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    SCREENSHOT = 1,
    /**
     * Moving Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    MOVING_PHOTO = 3,
    /**
     * Burst Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    BURST = 4,
  }

  /**
   * Enumeration of dynamic range type
   *
   * @enum { number } DynamicRangeType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  enum DynamicRangeType {
    /**
     * SDR(Standard-Dynamic Range) format
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    SDR = 0,
    /**
     * HDR(High-Dynamic Range) format
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    HDR = 1
  }

  /**
   * Ability to access thumbnail
   *
   * @enum { number } ThumbnailVisibility
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  enum ThumbnailVisibility {
    /**
     * Unable to access thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    INVISIBLE = 0,
    /**
     * able to access thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    VISIBLE = 1
  }

  /**
   * Photo asset position
   *
   * @enum { number } Photo asset position, such as local device or cloud
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 10
   */
  enum PositionType {
    /**
     * Asset exists only in local device
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    LOCAL = 1 << 0,
    /**
     * Asset exists only in cloud
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    CLOUD = 1 << 1
  }

  /**
   * The format in which the image is saved
   *
   * @enum { number } ImageFileType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 13
   */
  enum ImageFileType {
    /**
     * Jpeg type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    JPEG = 1,

    /**
     * Heif type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    HEIF = 2
  }

  /**
   * Analysis type
   *
   * @enum { number } AnalysisType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  enum AnalysisType {
    /**
     * Analysis of aesthetics score
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_AESTHETICS_SCORE = 0,
    /**
     * Analysis of label
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_LABEL,
    /**
     * Analysis of ocr
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_OCR,
    /**
     * Analysis of face
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_FACE,
    /**
     * Analysis of object
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_OBJECT,
    /**
     * Analysis of recommendation
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_RECOMMENDATION,
    /**
     * Analysis of segmentation
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_SEGMENTATION,
    /**
     * Analysis of composition
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_COMPOSITION,
    /**
     * Analysis of saliency
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_SALIENCY,
    /**
     * Analysis of photo detail address info
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ANALYSIS_DETAIL_ADDRESS,
    /**
     * Analysis of human face tag
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_HUMAN_FACE_TAG,
    /**
     * Analysis of head position
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_HEAD_POSITION,
    /**
     * Analysis of bone pose
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_BONE_POSE,
    /**
     * Analysis of video label
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_VIDEO_LABEL,
    /**
     * Analysis of 2D camera movement
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_MULTI_CROP,
    /**
     * Analysis of highlight
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ANALYSIS_HIGHLIGHT,
    /**
     * Analysis of search index
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 18
     */
    ANALYSIS_SEARCH_INDEX = 16
  }

  /**
   * Enumeration of different recommendation type
   *
   * @enum { number } RecommendationType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  enum RecommendationType {
    /**
     * QR_OR_BAR_CODE indicates that QR code or barcode photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    QR_OR_BAR_CODE = 1,

    /**
     * QR_CODE indicates that QR code photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    QR_CODE = 2,

    /**
     * BAR_CODE indicates that barcode photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    BAR_CODE = 3,

    /**
     * ID_CARD indicates that QR code or barcode photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    ID_CARD = 4,

    /**
     * PROFILE_PICTURE indicates that profile picture photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    PROFILE_PICTURE = 5,

    /**
     * PASSPORT indicates that passport photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    PASSPORT = 6,

    /**
     * BANK_CARD indicates that bank card photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    BANK_CARD = 7,

    /**
     * DRIVER_LICENSE indicates that driver license photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    DRIVER_LICENSE = 8,

    /**
     * DRIVING_LICENSE indicates that driving license photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    DRIVING_LICENSE = 9,

    /**
     * FEATURED_SINGLE_PORTRAIT indicates that featured single portrait photos can be recommended
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    FEATURED_SINGLE_PORTRAIT = 10
  }

  /**
   * Enumeration of delivery mode.
   *
   * @enum { number } DeliveryMode
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 11
   */
  enum DeliveryMode {
    /**
     * Fast delivery mode
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    FAST_MODE = 0,

    /**
     * High quality delivery mode
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    HIGH_QUALITY_MODE = 1,

    /**
     * Balance delivery mode
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    BALANCE_MODE = 2
  }

  /**
   * Enumeration of source mode
   *
   * @enum { number } SourceMode
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  enum SourceMode {
    /**
     * Original mode
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ORIGINAL_MODE = 0,

    /**
     * Edited mode
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    EDITED_MODE = 1
  }

  /**
   * Enumeration type of permissions for accessing asset uri.
   *
   * @enum { number } PhotoPermissionType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  enum PhotoPermissionType {
    /**
     * Temporary access to photos, this permission could be canceled when APP dies.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    TEMPORARY_READ_IMAGEVIDEO = 0,

    /**
     * Persistence access to photos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    PERSISTENT_READ_IMAGEVIDEO = 1
  }

  /**
   * Enumeration type of hide sensitive information.
   *
   * @enum { number } HideSensitiveType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  enum HideSensitiveType {
    /**
     * Hide location information and shooting param.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIDE_LOCATION_AND_SHOOTING_PARAM = 0,

    /**
     * Hide location information.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIDE_LOCATION_ONLY = 1,

    /**
     * Hide shooting param.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIDE_SHOOTING_PARAM_ONLY = 2,

    /**
     * Hide nothing.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    NO_HIDE_SENSITIVE_TYPE = 3
  }


  /**
   * Enum: complete button text
   *
   * @enum { number } CompleteButtonText
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  enum CompleteButtonText {
    /**
     * Complete button text: done
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    TEXT_DONE = 0,
    /**
     * Complete button text: send
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    TEXT_SEND = 1,

    /**
     * Complete button text: add
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    TEXT_ADD = 2,
  }

  enum FilterOperator {
    EQUAL_TO = 0,
    NOT_EQUAL_TO = 1,
    MORE_THAN = 2,
    LESS_THAN = 3,
    MORE_THAN_OR_EQUAL_TO = 4,
    LESS_THAN_OR_EQUAL_TO = 5,
    BETWEEN = 6
  }

  /**
   * Options to request media asset
   *
   * @interface RequestOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 11
   */
  interface RequestOptions {
    /**
     * Indicates the delivery mode
     *
     * @type { DeliveryMode }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    deliveryMode: DeliveryMode;

    /**
     * Indicates the source mode
     *
     * @type { ?SourceMode }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    sourceMode?: SourceMode
  }

  /**
   * Media asset data handler
   *
   * @interface MediaAssetDataHandler
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 11
   */
  interface MediaAssetDataHandler<T> {
    /**
     * Indicates required media asset data is prepared
     *
     * @param { T } data - the returned data of media asset
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    /**
     * Indicates required media asset data is prepared
     *
     * @param { T } data - the returned data of media asset
     * @param { Map<string, string> } [map] - additional information for the data
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    onDataPrepared(data: T, map?: Map<string, string>): void;
  }

  /**
   * Data handler when quick request image is finished
   *
   * @typedef QuickImageDataHandler
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 13
   */
  interface QuickImageDataHandler<T> {
    /**
     * Indicates required media asset data quickly is prepared
     *
     * @param { T } data - the returned data of picture
     * @param { image.ImageSource } imageSource - the returned data of imageSource
     * @param { Map<string, string> } map - additional information for the data
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    onDataPrepared(data: T, imageSource: image.ImageSource, map: Map<string, string>): void;
  }

  /**
   * Photo Proxy used to save image data
   *
   * @interface PhotoProxy
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  interface PhotoProxy {}

  /**
   * Media asset manager
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 11
   */
  class MediaAssetManager {
    /**
     * Request image
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { PhotoAsset } asset - the photo asset requested
     * @param { RequestOptions } requestOptions - the request options
     * @param { MediaAssetDataHandler<image.ImageSource> } dataHandler - data handler used to obtain media asset data when ImageSource is prepared
     * @returns { Promise<string> } Returns request id
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    static requestImage(
      context: Context,
      asset: PhotoAsset,
      requestOptions: RequestOptions,
      dataHandler: MediaAssetDataHandler<image.ImageSource>
    ): Promise<string>;

    /**
     * Quick request image
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { PhotoAsset } asset - the photo asset requested
     * @param { RequestOptions } requestOptions - the request options
     * @param { QuickImageDataHandler<image.Picture> } dataHandler - data handler used to obtain image data quickly when picture is prepared
     * @returns { Promise<string> } Returns request id
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    static quickRequestImage(
      context: Context,
      asset: PhotoAsset,
      requestOptions: RequestOptions,
      dataHandler: QuickImageDataHandler<image.Picture>
    ): Promise<string>;

    /**
     * Request image data
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { PhotoAsset } asset - the photo asset requested
     * @param { RequestOptions } requestOptions - the request options
     * @param { MediaAssetDataHandler<ArrayBuffer> } dataHandler - data handler used obtain media asset data when data is prepared
     * @returns { Promise<string> } Returns request id
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    static requestImageData(
      context: Context,
      asset: PhotoAsset,
      requestOptions: RequestOptions,
      dataHandler: MediaAssetDataHandler<ArrayBuffer>
    ): Promise<string>;

    /**
     * Request moving photo
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { PhotoAsset } asset - the photo asset requested
     * @param { RequestOptions } requestOptions - the request options
     * @param { MediaAssetDataHandler<MovingPhoto> } dataHandler - data handler used to obtain moving photo when data is prepared
     * @returns { Promise<string> } Returns request id
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    static requestMovingPhoto(
      context: Context,
      asset: PhotoAsset,
      requestOptions: RequestOptions,
      dataHandler: MediaAssetDataHandler<MovingPhoto>
    ): Promise<string>;

    /**
     * Cancel request
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { string } requestId - the request id to be canceled
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    static cancelRequest(context: Context, requestId: string): Promise<void>;

    /**
     * Request video file
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { PhotoAsset } asset - the photo asset requested
     * @param { RequestOptions } requestOptions - the request options
     * @param { string } fileUri - the destination file uri to save the video data
     * @param { MediaAssetDataHandler<boolean> } dataHandler - data handler used to notify the client that data has been written to the application sandbox
     * @returns { Promise<string> } Returns request id
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    static requestVideoFile(
      context: Context,
      asset: PhotoAsset,
      requestOptions: RequestOptions,
      fileUri: string,
      dataHandler: MediaAssetDataHandler<boolean>
    ): Promise<string>;

    /**
     * Load moving photo
     *
     * @param { Context } context - Hap context information
     * @param { string } imageFileUri - image file uri of the moving photo to be loaded
     * @param { string } videoFileUri - video file uri of the moving photo to be loaded
     * @returns { Promise<MovingPhoto> } Returns moving photo
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    static loadMovingPhoto(
      context: Context,
      imageFileUri: string,
      videoFileUri: string
    ): Promise<MovingPhoto>;
  }

  /**
   * Indicates the type of photo asset member.
   *
   * @typedef { number | string | boolean } MemberType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  type MemberType = number | string | boolean;

  enum ThumbnailType {
    LCD,
    THM
  }

  interface GalleryFormInfo {
    formId: string;
    assetUris: Array<string>;
  }

  /**
   * Defines the photo asset
   *
   * @interface PhotoAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * Defines the photo asset
   *
   * @interface PhotoAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  interface PhotoAsset {
    /**
     * uri of the asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * uri of the asset.
     *
     * @type { string }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    readonly uri: string;

    /**
     * Photo type, image or video
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly photoType: PhotoType;

    /**
     * Display name (with a file name extension) of the asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly displayName: string;

    /**
     * Returns the value of the specified member.
     *
     * @param { string } member - Photo asset member. for example : get(PhotoKeys.SIZE)
     * @returns { MemberType } Returns the value of the specified photo asset member
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000014 - Member is not a valid PhotoKey
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    get(member: string): MemberType;

    /**
     * Set a new value to the specified member
     *
     * @param { string } member - Photo asset member
     * @param { string } value - The new value of the member.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000014 - Member is not a valid PhotoKey
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @example : set(PhotoKeys.TITLE, "newTitle"), call commitModify after set
     */
    set(member: string, value: string): void;

    /**
     * Modify metadata of the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Modify metadata of the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    commitModify(callback: AsyncCallback<void>): void;

    /**
     * Modify metadata of the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Modify metadata of the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    commitModify(): Promise<void>;

    /**
     * Open the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO or ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } mode - Mode for open, for example: rw, r, w.
     * @param { AsyncCallback<number> } callback - Callback return the fd of the asset.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     */
    open(mode: string, callback: AsyncCallback<number>): void;

    /**
     * Open the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO or ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } mode - Mode for open, for example: rw, r, w.
     * @returns { Promise<number> } Returns the fd
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     */
    open(mode: string): Promise<number>;

    /**
     * Open the asset in read only mode
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<number> } callback - Returns the read only fd
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     */
    getReadOnlyFd(callback: AsyncCallback<number>): void;

    /**
     * Open the asset in read only mode
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<number> } Returns the read only fd
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     */
    getReadOnlyFd(): Promise<number>;

    /**
     * Close the asset
     *
     * @param { number } fd - The opened fd of the asset.
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     */
    close(fd: number, callback: AsyncCallback<void>): void;

    /**
     * Close the asset
     *
     * @param { number } fd - The opened fd of the asset.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     */
    close(fd: number): Promise<void>;

    /**
     * Get thumbnail of the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<image.PixelMap> } callback - Returns the thumbnail's pixelMap.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getThumbnail(callback: AsyncCallback<image.PixelMap>): void;

    /**
     * Get thumbnail of the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { image.Size } size - Thumbnail's size
     * @param { AsyncCallback<image.PixelMap> } callback - Returns the thumbnail's pixelMap.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getThumbnail(size: image.Size, callback: AsyncCallback<image.PixelMap>): void;

    /**
     * Get thumbnail of the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { image.Size } [size] - Thumbnail's size
     * @returns { Promise<image.PixelMap> } Returns the thumbnail's pixelMap.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getThumbnail(size?: image.Size): Promise<image.PixelMap>;

    getThumbnailData(type: ThumbnailType): Promise<ArrayBuffer>;
    /**
     * Set favorite state for the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } favoriteState - true: Put the asset into favorite album; false: Remove the asset from favorite album.
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setFavorite
     */
    setFavorite(favoriteState: boolean, callback: AsyncCallback<void>): void;

    /**
     * Set favorite state for the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } favoriteState - true: Put the asset into favorite album; false: Remove the asset from favorite album.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setFavorite
     */
    setFavorite(favoriteState: boolean): Promise<void>;

    /**
     * Set asset hidden state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } hiddenState - true: Put the asset into hidden album; false: Recover the asset from hidden album.
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setHidden
     */
    setHidden(hiddenState: boolean, callback: AsyncCallback<void>): void;

    /**
     * Set asset hidden state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } hiddenState - true: Put the asset into hidden album; false: Recover the asset from hidden album.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setHidden
     */
    setHidden(hiddenState: boolean): Promise<void>;

    /**
     * Set user comment info to the asset.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } userComment - user comment info
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setUserComment
     */
    setUserComment(userComment: string, callback: AsyncCallback<void>): void;

    /**
     * Set user comment info to the asset.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } userComment - user comment info
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#setUserComment
     */
    setUserComment(userComment: string): Promise<void>;

    /**
     * Get exif info of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<string> } callback - Returns exif info into a json string
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    getExif(callback: AsyncCallback<string>): void;

    /**
     * Get analysis data of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AnalysisType } analysisType - Analysis type
     * @returns { Promise<string> } Returns analysis info into a json string
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    getAnalysisData(analysisType: AnalysisType): Promise<string>;

    /**
     * Get exif info of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<string> } Returns exif info into a json string
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    getExif(): Promise<string>;

    /**
     * Set asset pending state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } pendingState - true: Set asset in pending status; false: Recover asset from pending status.
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setPending(pendingState: boolean, callback: AsyncCallback<void>): void;

    /**
     * Set asset pending state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { boolean } pendingState - true: Set asset in pending status; false: Recover asset from pending status.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setPending(pendingState: boolean): Promise<void>;

    /**
     * Check if asset has been edited.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<boolean> } callback - Returns whether the asset has been edited.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    isEdited(callback: AsyncCallback<boolean>): void;

    /**
     * Check if asset has been edited.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<boolean> } Returns whether the asset has been edited.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    isEdited(): Promise<boolean>;

    /**
     * Request asset edit data.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<string> } callback - Returns asset edit data.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestEditData(callback: AsyncCallback<string>): void;

    /**
     * Request asset edit data.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<string> } Returns asset edit data.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestEditData(): Promise<string>;

    /**
     * Get media asset edit data.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<MediaAssetEditData> } Returns media asset edit data
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    getEditData(): Promise<MediaAssetEditData>;

    /**
     * Clone asset.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } title - The title of asset.
     * @returns { Promise<PhotoAsset> } Returns asset
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 14
     */
    clone(title: string): Promise<PhotoAsset>;

    /**
     * Copy a picture in the same album and convert it to a specified format.
     * The album here refers to the album created by user or application album.
     * The API supports media types include normal picture, moving(only picture part), and burst photo, but video is not include.
     * The API supports image format include heif and heic.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } title - The new image title.
     * @param { string } imageFormat - The target image format.
     * @returns { Promise<PhotoAsset> } Returns the new PhotoAsset.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 23800151 - Scene parameters validate failed, possible causes:
     * 1. The original file does not exist locally in PhotoAsset;
     * 2. The original file format is not within the supported range;
     * 3. The original file is a temporary file or is being edited;
     * 4. The title is the same with an image in the same album;
     * 5. PhotoAsset is a photo in the trash or a hidden photo;
     * 6. The title does not meet the parameter specifications.
     * @throws { BusinessError } 23800301 - Internal system error. It is recommended to retry and check the
     * kogs. Possible causes:
     * 1. Database corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     * @arkts 1.1&1.2
     */
    convertImageFormat(title: string, imageFormat: string): Promise<PhotoAsset>;

    /**
     * Requests the read-only FD of the source asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<number> } callback - Returns opened source asset fd.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestSource(callback: AsyncCallback<number>): void;

    /**
     * Requests the read-only FD of the source asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<number> }  Returns opened source asset fd.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestSource(): Promise<number>;

    /**
     * Commit edit data and edited asset.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } editData - editData to be saved.
     * @param { string } uri - uri of the edited asset within the applications's own sandbox.
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    commitEditedAsset(editData: string, uri: string, callback: AsyncCallback<void>);

    /**
     * Commit edit data and edited asset.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } editData - editData to be saved.
     * @param { string } uri - uri of the edited asset within the applications's own sandbox.
     * @returns { Promise<void> } Returns void.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    commitEditedAsset(editData: string, uri: string): Promise<void>;

    /**
     * Revert asset edits to original state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { AsyncCallback<void> } callback - Returns void.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    revertToOriginal(callback: AsyncCallback<void>);

    /**
     * Revert asset edits to original state.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    revertToOriginal(): Promise<void>;

    /**
     * Request thumbnails of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AsyncCallback<image.PixelMap> } callback - Returns the required pixels
     * @returns { string } Returns request photo task id.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestPhoto(callback: AsyncCallback<image.PixelMap>): string;

    /**
     * Request thumbnails of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { RequestPhotoOptions } options - Request photo options
     * @param { AsyncCallback<image.PixelMap> } callback - Returns the required pixels
     * @returns { string } Returns request photo task id.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestPhoto(options: RequestPhotoOptions, callback: AsyncCallback<image.PixelMap>): string;

    /**
     * Cancel photo request
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } requestId - The request id to be canceled
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    cancelPhotoRequest(requestId: string): void;
  }

  /**
   * Enumeration of photo asset members
   *
   * @enum { string } PhotoKeys
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum PhotoKeys {
    /**
     * Asset uri, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    URI = 'uri',
    /**
     * Photo type of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    PHOTO_TYPE = 'media_type',
    /**
     * Asset name, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DISPLAY_NAME = 'display_name',
    /**
     * Size of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    SIZE = 'size',
    /**
     * Creation date of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DATE_ADDED = 'date_added',
    /**
     * Modified date of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DATE_MODIFIED = 'date_modified',
    /**
     * Duration of video files, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DURATION = 'duration',
    /**
     * Width of the image asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    WIDTH = 'width',
    /**
     * Height of the image asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    HEIGHT = 'height',
    /**
     * Date taken of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DATE_TAKEN = 'date_taken',
    /**
     * Orientation of the image asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    ORIENTATION = 'orientation',
    /**
     * Favorite state of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    FAVORITE = 'is_favorite',
    /**
     * Title of the asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    TITLE = 'title',
    /**
     * Asset position, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    POSITION = 'position',
    /**
     * Trashed date of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    DATE_TRASHED = 'date_trashed',
    /**
     * Hidden state of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    HIDDEN = 'hidden',
    /**
     * User comment info
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    USER_COMMENT = 'user_comment',
    /**
     * Camera shot key
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    CAMERA_SHOT_KEY = 'camera_shot_key',
    /**
     * The year of the file created, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    DATE_YEAR = 'date_year',
    /**
     * The month of the file created, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    DATE_MONTH = 'date_month',
    /**
     * The day of the file created, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    DATE_DAY = 'date_day',
    /**
     * Pending state of the asset, true means asset is pending, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    PENDING = 'pending',
    /**
     * Creation time of the asset in milliseconds, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    DATE_ADDED_MS = 'date_added_ms',
    /**
     * Modified time of the asset in milliseconds, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    DATE_MODIFIED_MS = 'date_modified_ms',
    /**
     * Trashed time of the asset in milliseconds, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    DATE_TRASHED_MS = 'date_trashed_ms',
    /**
     * Photo subtype of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    PHOTO_SUBTYPE = 'subtype',
    /**
     * Effect mode of moving photo, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    MOVING_PHOTO_EFFECT_MODE = 'moving_photo_effect_mode',
    /**
     * Dynamic range type of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    DYNAMIC_RANGE_TYPE = 'dynamic_range_type',
    /**
     * Cover position of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    COVER_POSITION = 'cover_position',
    /**
     * Unique uuid of the burst photos, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    BURST_KEY = 'burst_key',
    /**
     * Detail time of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    DETAIL_TIME = 'detail_time',
    /**
     * Date taken of the asset in milliseconds, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    DATE_TAKEN_MS = 'date_taken_ms',
    /**
     * Cloud enhancement status of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    CE_AVAILABLE = 'ce_available',

    IS_AUTO = 'is_auto',

    /**
     * watermark type of the asset, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    SUPPORTED_WATERMARK_TYPE = 'supported_watermark_type',
	
	/**
     * is style photo, read only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    IS_STYLE_PHOTO = 'is_style_photo',

    /**
     * visibility of thumbnails
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    THUMBNAIL_VISIBLE = 'thumbnail_visible'
  }

  /**
   * Enumeration of photo album members.
   *
   * @enum { string } AlbumKeys
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum AlbumKeys {
    /**
     * Album uri
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    URI = 'uri',
    /**
     * Album name
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    ALBUM_NAME = 'album_name',
    COVER_URI_SOURCE = 'cover_uri_source',
    UPLOAD_STATUS = 'upload_status',
  }

  /**
   * Enumeration of mode for displaying albums containing hidden assets
   *
   * @enum { number } HiddenPhotosDisplayMode
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  enum HiddenPhotosDisplayMode {
    /**
     * Display the system hidden album that contains all the hidden assets.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ASSETS_MODE,
    /**
     * Display all albums containing hidden assets(excluding the system hidden album and the system trash album).
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    ALBUMS_MODE
  }

  /**
   * Options to fetch assets or albums
   *
   * @interface FetchOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  interface FetchOptions {
    /**
     * Indicates the members to query.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    fetchColumns: Array<string>;

    /**
     * Predicates to query
     *
     * @type { dataSharePredicates.DataSharePredicates }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    predicates: dataSharePredicates.DataSharePredicates;
  }

  /**
   * Options to create a photo asset for system apps
   *
   * @interface PhotoCreateOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 10
   */
  interface PhotoCreateOptions {
    /**
     * Specify subtype of the asset to create
     *
     * @type { ?PhotoSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    subtype?: PhotoSubtype;

    /**
     * Camera shot key
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    cameraShotKey?: string;
  }

  /**
   * Config to create photo asset
   *
   * @interface PhotoCreationConfig
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  interface PhotoCreationConfig {
    /**
     * Title of the asset
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    title?: string;

    /**
     * Extension of the asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    fileNameExtension: string;

    /**
     * Specify photo type of the asset to create, include image or video
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    photoType: PhotoType;

    /**
     * Specify photo subtype of the asset to create, include default or moving_photo
     *
     * @type { ?PhotoSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    subtype?: PhotoSubtype;
  }

  /**
   * Options to create a photo asset
   *
   * @interface CreateOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * Options to create a photo asset
   *
   * @interface CreateOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  interface CreateOptions {
    /**
     * Title of the asset
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Title of the asset
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    title?: string;

    /**
     * Specify subtype of the asset to create
     *
     * @type { ?PhotoSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    subtype?: PhotoSubtype;
  }

  /**
   * Options to request photo
   *
   * @interface RequestPhotoOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  interface RequestPhotoOptions {
    /**
     * Size of thumbnail
     *
     * @type { ?image.Size }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    size?: image.Size;

    /**
     * Type of photo request
     *
     * @type { ?RequestPhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    requestPhotoType?: RequestPhotoType;
  }

  /**
   * The fetch result of assets or albums
   *
   * @interface FetchResult
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  interface FetchResult<T> {
    /**
     * Obtains the total number of objects in the fetch result.
     *
     * @returns { number } Total number of objects.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getCount(): number;

    /**
     * Checks whether the result set points to the last row.
     * You need to check whether the object is the last one before calling getNextObject.
     *
     * @returns { boolean } Whether the object is the last one in the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    isAfterLast(): boolean;

    /**
     * Obtains the first object in the fetch result.
     *
     * @param { AsyncCallback<T> } callback - Returns the first object in the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getFirstObject(callback: AsyncCallback<T>): void;

    /**
     * Obtains the first object in the fetch result.
     *
     * @returns { Promise<T> } Returns the first object in the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getFirstObject(): Promise<T>;

    /**
     * Obtains the next object in the fetch result.
     * Before calling this method, you must use isAfterLast() to check whether the current position is the last row
     * in the fetch result. This method only works when the current position is not the last row.
     *
     * @param { AsyncCallback<T> } callback - Returns the next object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getNextObject(callback: AsyncCallback<T>): void;

    /**
     * Obtains the next object in the fetch result.
     * Before calling this method, you must use isAfterLast() to check whether the current position is the last row
     * in the fetch result. This method only works when the current position is not the last row.
     *
     * @returns { Promise<T> } Returns the next object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getNextObject(): Promise<T>;

    /**
     * Obtains the last object in the fetch result
     *
     * @param { AsyncCallback<T> } callback - Returns the last object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getLastObject(callback: AsyncCallback<T>): void;

    /**
     * Obtains the last object in the fetch result
     *
     * @returns { Promise<T> } Returns the last object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getLastObject(): Promise<T>;

    /**
     * Obtains the object with the specified index in the fetch result.
     *
     * @param { number } index - Index of the object to obtain.
     * @param { AsyncCallback<T> } callback - Returns the object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getObjectByPosition(index: number, callback: AsyncCallback<T>): void;

    /**
     * Obtains the object with the specified index in the fetch result.
     *
     * @param { number } index - Index of the asset to obtain.
     * @returns { Promise<T> } Returns the object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getObjectByPosition(index: number): Promise<T>;

    /**
     * Obtains all objects in the fetch result.
     *
     * @param { AsyncCallback<Array<T>> } callback - Returns all the objects
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAllObjects(callback: AsyncCallback<Array<T>>): void;

    /**
     * Obtains all objects in the fetch result.
     *
     * @returns { Promise<Array<T>> } Returns all the objects
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAllObjects(): Promise<Array<T>>;

    /**
     * Releases the fetch result.
     *
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    close(): void;
  }

  /**
   * Album type.
   *
   * @enum { number } AlbumType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum AlbumType {
    /**
     * Album created by user.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    USER = 0,
    /**
     * Album created by system, which metadata cannot be modified.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    SYSTEM = 1024,
    /**
     * Album created by smart abilities.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    SMART = 4096
  }

  /**
   * Album subtype
   *
   * @enum { number } AlbumSubtype
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum AlbumSubtype {
    /**
     * Generic user-created albums.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    USER_GENERIC = 1,
    /**
     * Favorite album, which assets are marked as favorite.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    FAVORITE = 1025,
    /**
     * Video album, which contains all video assets.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    VIDEO,
    /**
     * Hidden album, which assets are marked as hidden.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    HIDDEN,
    /**
     * Trash album, which assets are deleted.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    TRASH,
    /**
     * Screenshot album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    SCREENSHOT,
    /**
     * Camera album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    CAMERA,
    /**
     * Image album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    /**
     * Image album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    IMAGE = 1031,
    /**
     * Cloud Enhancement album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    CLOUD_ENHANCEMENT = 1032,
    /**
     * Source album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    SOURCE_GENERIC = 2049,
    /**
     * Classify album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    CLASSIFY = 4097,
    /**
     * Location album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    GEOGRAPHY_LOCATION = 4099,
    /**
     * City album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    GEOGRAPHY_CITY,
    /**
     * ShootingMode album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    SHOOTING_MODE,
    /**
     * Portrait album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    PORTRAIT,
    /**
     * Group photo album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    GROUP_PHOTO,
    /**
     * Highlight album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIGHLIGHT = 4104,
    /**
     * Highlight suggestions album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIGHLIGHT_SUGGESTIONS,
    PET = 4106,
    PORTRAIT_ONLY = 4107,
    PORTRAIT_EXTENSION = 4108,
    SELECTED = 4109,
    PROTAGONIST_PLANET = 4110,
    PREVIEW_STORY = 4111,
    DUPLICATE = 4112,
    /**
     * Any album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    ANY = 2147483647
  }

  /**
   * Request photo type.
   *
   * @enum { number } RequestPhotoType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  enum RequestPhotoType {
    /**
     * Request all thumbnails: fast thumbnail and quality thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    REQUEST_ALL_THUMBNAILS = 0,
    /**
     * Only request fast thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    REQUEST_FAST_THUMBNAIL,
    /**
     * Only request quality thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    REQUEST_QUALITY_THUMBNAIL
  }

  /**
   * Defines the abstract interface of albums.
   *
   * @interface AbsAlbum
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  interface AbsAlbum {
    /**
     * Album type
     *
     * @type { AlbumType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly albumType: AlbumType;
    /**
     * Album type
     *
     * @type { coverUriSource }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly coverUriSource?: string;

    /**
     * Album subtype
     *
     * @type { AlbumSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly albumSubtype: AlbumSubtype;

    /**
     * Album name.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    albumName: string;

    /**
     * Album uri.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly albumUri: string;

    /**
     * Number of assets in the album
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly count: number;

    /**
     * Cover uri for the album
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    readonly coverUri: string;

    readonly uploadStatus: number;

    /**
     * Fetch assets in an album.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Fetch options.
     * @param { AsyncCallback<FetchResult<PhotoAsset>> } callback - Returns the fetch result
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAssets(options: FetchOptions, callback: AsyncCallback<FetchResult<PhotoAsset>>): void;

    /**
     * Fetch assets in an album.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Fetch options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAssets(options: FetchOptions): Promise<FetchResult<PhotoAsset>>;

    /**
     * Sync fetch photo assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Array<PhotoAsset> } Returns the photo assets
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAssetsSync(options: FetchOptions): Array<PhotoAsset>;

    /**
     * Fetch shared photo assets in an album.
     *
     * @permission ohos.permission.ACCESS_MEDIALIB_THUMB_DB
     * @param { FetchOptions } options - Fetch options.
     * @returns { Array<SharedPhotoAsset> } Returns the shared photo assets
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    getSharedPhotoAssets(options: FetchOptions): Array<SharedPhotoAsset>;
  }

  /**
   * Defines the album.
   *
   * @interface Album
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  interface Album extends AbsAlbum {
    readonly lpath?: string;
    /**
     * Number of image assets in the album
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    readonly imageCount?: number;

    /**
     * Number of video assets in the album
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    readonly videoCount?: number;

    /**
     * Modify metadata for the album
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    commitModify(callback: AsyncCallback<void>): void;

    /**
     * Modify metadata for the album
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    commitModify(): Promise<void>;

    /**
     * Add assets to the album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to add
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#addAssets
     */
    addAssets(assets: Array<PhotoAsset>, callback: AsyncCallback<void>): void;

    /**
     * Add assets to the album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to add
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#addAssets
     */
    addAssets(assets: Array<PhotoAsset>): Promise<void>;

    /**
     * Remove assets from the album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to remove
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#removeAssets
     */
    removeAssets(assets: Array<PhotoAsset>, callback: AsyncCallback<void>): void;

    /**
     * Remove assets from the album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to remove
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#removeAssets
     */
    removeAssets(assets: Array<PhotoAsset>): Promise<void>;

    /**
     * Recover assets from the trash album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to recover
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#recoverAssets
     */
    recoverAssets(assets: Array<PhotoAsset>, callback: AsyncCallback<void>): void;

    /**
     * Recover assets from the trash album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to recover
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#recoverAssets
     */
    recoverAssets(assets: Array<PhotoAsset>): Promise<void>;

    /**
     * Delete assets permanently from the trash album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to delete
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#deleteAssets
     */
    deleteAssets(assets: Array<PhotoAsset>, callback: AsyncCallback<void>): void;

    /**
     * Delete assets permanently from the trash album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } assets - Assets to delete
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#deleteAssets
     */
    deleteAssets(assets: Array<PhotoAsset>): Promise<void>;

    /**
     * Set cover uri for this album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } uri - The asset uri to set
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#setCoverUri
     */
    setCoverUri(uri: string, callback: AsyncCallback<void>): void;

    /**
     * Set cover uri for this album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } uri - The asset uri to set
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#setCoverUri
     */
    setCoverUri(uri: string): Promise<void>;

    /**
     * Get the faceId of the portrait album or group photo album.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<string> } Returns tag_id if portrait album, Returns group_tag if group photo album,
     * <br>Returns empty if not found.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    getFaceId(): Promise<string>;
  }

  /**
   * Defines the album order.
   *
   * @interface AlbumOrder
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 20
   */
  interface AlbumOrder {
    /**
     * The album id of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    albumId: number;
    /**
     * The album order of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    albumOrder: number;
    /**
     * The order section of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    orderSection: number;
    /**
     * The order type of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    orderType: number;
    /**
     * The order status of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    orderStatus: number;
  }

  /**
   * Helper functions to access photos and albums.
   *
   * @interface PhotoAccessHelper
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * Helper functions to access photos and albums.
   *
   * @interface PhotoAccessHelper
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  interface PhotoAccessHelper {
    query(sql: string): Promise<relationalStore.ResultSet>;

    /**
     * Fetch photo assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Fetch options.
     * @param { AsyncCallback<FetchResult<PhotoAsset>> } callback - Returns the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAssets(options: FetchOptions, callback: AsyncCallback<FetchResult<PhotoAsset>>): void;

    /**
     * Fetch photo assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAssets(options: FetchOptions): Promise<FetchResult<PhotoAsset>>;

    /**
     * Fetch a group of burst assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } burstKey - Burst asset uuid
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getBurstAssets(burstKey: string, options: FetchOptions): Promise<FetchResult<PhotoAsset>>;

    /**
     * Sync fetch photo assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Array<PhotoAsset> } Returns the photo assets
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAssetsSync(options: FetchOptions): Array<PhotoAsset>;

    /**
     * Fetch file assets info
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Array<FileAssetInfo> } Returns the file assets info
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getFileAssetsInfo(options: FetchOptions): Array<FileAssetInfo>;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @param { AsyncCallback<PhotoAsset> } callback - Returns the newly created asset
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    createAsset(displayName: string, callback: AsyncCallback<PhotoAsset>): void;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @returns { Promise<PhotoAsset> } Returns the newly created asset
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    createAsset(displayName: string): Promise<PhotoAsset>;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @param { PhotoCreateOptions } options - Create operation
     * @returns { Promise<PhotoAsset> } Returns the newly created asset
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    createAsset(displayName: string, options: PhotoCreateOptions): Promise<PhotoAsset>;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @param { PhotoCreateOptions } options - Photo create operation
     * @param { AsyncCallback<PhotoAsset> } callback - Returns the newly created asset
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    createAsset(displayName: string, options: PhotoCreateOptions, callback: AsyncCallback<PhotoAsset>): void;

    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { CreateOptions } options - Asset create option
     * @param { AsyncCallback<string> } callback - Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { CreateOptions } options - Asset create option
     * @param { AsyncCallback<string> } callback - Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    createAsset(photoType: PhotoType, extension: string, options: CreateOptions, callback: AsyncCallback<string>): void;

    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { AsyncCallback<string> } callback - Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { AsyncCallback<string> } callback - Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    createAsset(photoType: PhotoType, extension: string, callback: AsyncCallback<string>): void;

    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { CreateOptions } [options] - Optional asset create option
     * @returns { Promise<string> } Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Create a photo asset:
     *   1. (Suggested)Integrate security component without WRITE_IMAGEVIDEO permission;
     *   2. Get WRITE_IMAGEVIDEO permission by ACL;
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { CreateOptions } [options] - Optional asset create option
     * @returns { Promise<string> } Returns the uri of the newly created asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    createAsset(photoType: PhotoType, extension: string, options?: CreateOptions): Promise<string>;

    /**
     * Create assets and grant save permission to the app which called the save dialog.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } bundleName - BundleName of the application which called the save dialog
     * @param { string } appName - AppName of the application which called the save dialog
     * @param { string } appId - AppId of the application which called the save dialog
     * @param { string } tokenID - tokenID of the application which called the save dialog
     * @param { AuthorizationMode } authorizationMode - authorizationMode of the application which called the save dialog
     * @param { Array<PhotoCreationConfig> } photoCreationConfigs - List of the photo asset creation configs
     * @returns { Promise<Array<string>> } - Returns the media library file uri list to application which has been authorized
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    createAssetsForAppWithMode(bundleName: string, appName: string, appId: string,
                               tokenID: number, authorizationMode: AuthorizationMode,
                               photoCreationConfigs: Array<PhotoCreationConfig>): Promise<Array<string>>;

    /**
     * Create a generic user album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } name - Album name to be created.
     * @param { AsyncCallback<Album> } callback - Returns the instance of newly created Album
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900015 - File exists
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#createAlbumRequest
     */
    createAlbum(name: string, callback: AsyncCallback<Album>): void;

    /**
     * Create a generic user album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } name - Album name to be created.
     * @returns { Promise<Album> } Returns the instance of newly created Album
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900015 - File exists
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#createAlbumRequest
     */
    createAlbum(name: string): Promise<Album>;

    /**
     * Delete generic user-created albums.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<Album> } albums - Specify which albums to delete
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#deleteAlbums
     */
    deleteAlbums(albums: Array<Album>, callback: AsyncCallback<void>): void;

    /**
     * Delete generic user-created albums.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<Album> } albums - Specify which albums to delete
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAlbumChangeRequest#deleteAlbums
     */
    deleteAlbums(albums: Array<Album>): Promise<void>;

    /**
     * Fetch albums.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AlbumType } type - Album type.
     * @param { AlbumSubtype } subtype - Album subtype.
     * @param { FetchOptions } options - options to fetch albums
     * @param { AsyncCallback<FetchResult<Album>> } callback - Returns the fetch result
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAlbums(
      type: AlbumType,
      subtype: AlbumSubtype,
      options: FetchOptions,
      callback: AsyncCallback<FetchResult<Album>>
    ): void;

    /**
     * Fetch albums.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AlbumType } type - Album type.
     * @param { AlbumSubtype } subtype - Album subtype.
     * @param { AsyncCallback<FetchResult<Album>> } callback - Returns the fetch result
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAlbums(type: AlbumType, subtype: AlbumSubtype, callback: AsyncCallback<FetchResult<Album>>): void;

    /**
     * Fetch albums.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AlbumType } type - Album type.
     * @param { AlbumSubtype } subtype - Album subtype.
     * @param { FetchOptions } [options] - options to fetch albums
     * @returns { Promise<FetchResult<Album>> } - Returns the fetch result
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getAlbums(type: AlbumType, subtype: AlbumSubtype, options?: FetchOptions): Promise<FetchResult<Album>>;

    getAlbums(options: FetchOptions): Promise<FetchResult<Album>>;

    /**
     * Fetch albums containing hidden assets.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { HiddenPhotosDisplayMode } mode - Display mode of albums containing hidden assets.
     * @param { FetchOptions } options - Options to fetch albums.
     * @param { AsyncCallback<FetchResult<Album>> } callback - Returns fetchResult of albums containing hidden assets.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    getHiddenAlbums(mode: HiddenPhotosDisplayMode, options: FetchOptions, callback: AsyncCallback<FetchResult<Album>>): void;

    /**
     * Fetch albums containing hidden assets.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { HiddenPhotosDisplayMode } mode - Display mode of albums containing hidden assets.
     * @param { AsyncCallback<FetchResult<Album>> } callback - Returns fetchResult of albums containing hidden assets.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    getHiddenAlbums(mode: HiddenPhotosDisplayMode, callback: AsyncCallback<FetchResult<Album>>): void;

    /**
     * Fetch albums containing hidden assets.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { HiddenPhotosDisplayMode } mode - Display mode of albums containing hidden assets.
     * @param { FetchOptions } [options] - Options to fetch albums.
     * @returns { Promise<FetchResult<Album>> } Returns fetchResult of albums containing hidden assets.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    getHiddenAlbums(mode: HiddenPhotosDisplayMode, options?: FetchOptions): Promise<FetchResult<Album>>;

    /**
     * Delete assets
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<string> } uriList - Uris of assets to delete
     * @param { AsyncCallback<void> } callback - No value returned
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000002 - Invalid uri
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#deleteAssets
     */
    deleteAssets(uriList: Array<string>, callback: AsyncCallback<void>): void;

    /**
     * Delete assets
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<string> } uriList - Uris of assets to delete
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000002 - Invalid uri
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#deleteAssets
     */
    deleteAssets(uriList: Array<string>): Promise<void>;

    /**
     * Register change notify for the specified uri.
     *
     * @param { string } uri - PhotoAsset's uri, album's uri or DefaultChangeUri
     * @param { boolean } forChildUris - Monitor the child uris.
     * @param { Callback<ChangeData> } callback - Returns the changed data
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    registerChange(uri: string, forChildUris: boolean, callback: Callback<ChangeData>): void;

    /**
     * Get analysis progress of the asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AnalysisType } analysisType - Analysis type
     * @returns { Promise<string> } Returns analysis progress info into a json string
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getDataAnalysisProgress(analysisType: AnalysisType): Promise<string>;

    /**
     * Unregister change notify for the specified uri.
     *
     * @param { string } uri - PhotoAsset's uri, album's uri or DefaultChangeUri
     * @param { Callback<ChangeData> } [callback] - The callback function to unregister.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    unRegisterChange(uri: string, callback?: Callback<ChangeData>): void;

    /**
     * Create a pop-up box to delete photos
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<string> } uriList - List of the asset uris to be deleted
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#deleteAssets
     */
    createDeleteRequest(uriList: Array<string>, callback: AsyncCallback<void>): void;

    /**
     * Create a pop-up box to delete photos
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<string> } uriList - List of the asset uris to be deleted
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     * @deprecated since 11
     * @useinstead photoAccessHelper.MediaAssetChangeRequest#deleteAssets
     */
    createDeleteRequest(uriList: Array<string>): Promise<void>;

    /**
     * Create a save dialog to save photos
     *
     * @param { Array<string> } srcFileUris - List of the file uris to be saved
     * @param { Array<PhotoCreationConfig> } photoCreationConfigs - List of the photo asset creation configs
     * @returns { Promise<Array<string>> } - Returns the media library file uri list to application which has been authorized
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    showAssetsCreationDialog(srcFileUris: Array<string>, photoCreationConfigs: Array<PhotoCreationConfig>): Promise<Array<string>>;

    /**
     * Create assets and grant save permission to the app which called the save dialog.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } bundleName - BundleName of the application which called the save dialog
     * @param { string } appName - AppName of the application which called the save dialog
     * @param { number } tokenId - TokenId of the application which called the save dialog
     * @param { Array<PhotoCreationConfig> } photoCreationConfigs - List of the photo asset creation configs
     * @returns { Promise<Array<string>> } - Returns the media library file uri list to application which has been authorized
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 15
     */
    createAssetsForApp(bundleName: string, appName: string, tokenId: number, photoCreationConfigs: Array<PhotoCreationConfig>): Promise<Array<string>>;

    /**
     * Get the index of the asset in the album
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } photoUri - The photo asset uri.
     * @param { string } albumUri - The album uri.
     * @param { FetchOptions } options - fetch options
     * @param { AsyncCallback<number> } callback - Returns the index of the asset in the album
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    getPhotoIndex(photoUri: string, albumUri: string, options: FetchOptions, callback: AsyncCallback<number>): void;

    /**
     * Get the index of the asset in the album
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } photoUri - The photo asset uri.
     * @param { string } albumUri - The album uri.
     * @param { FetchOptions } options - fetch options
     * @returns { Promise<number> } - Returns the index of the asset in the album
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900012 - Permission denied
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 10
     */
    getPhotoIndex(photoUri: string, albumUri: string, options: FetchOptions): Promise<number>;

    /**
     * Release PhotoAccessHelper instance
     *
     * @param { AsyncCallback<void> } callback - Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    release(callback: AsyncCallback<void>): void;

    /**
     * Release PhotoAccessHelper instance
     *
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    release(): Promise<void>;

    /**
     * Saves form information
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { FormInfo } info - Information store with the form.
     * @param { AsyncCallback<void> } callback - No value returned.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    saveFormInfo(info: FormInfo, callback: AsyncCallback<void>): void;

    /**
     * Saves form information
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { FormInfo } info - Information store with the form.
     * @returns { Promise<void> } Return void.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    saveFormInfo(info: FormInfo): Promise<void>;

    /**
     * Removes form information
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { FormInfo } info - Information store with the form.
     * @param { AsyncCallback<void> } callback - No value returned.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    removeFormInfo(info: FormInfo, callback: AsyncCallback<void>): void;

    /**
     * Removes form information
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { FormInfo } info - Information store with the form.
     * @returns { Promise<void> } Return void.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    removeFormInfo(info: FormInfo): Promise<void>;

    /**
     * Apply the change request of asset or album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { MediaChangeRequest } mediaChangeRequest - The change request to be applied
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    applyChanges(mediaChangeRequest: MediaChangeRequest): Promise<void>;

    /**
     * Get index construction progress.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<string> } Returns progress of the photo and video
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getIndexConstructProgress(): Promise<string>;

    /**
     * Grant permission of assets to an APP.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { number } tokenId - tokenId
     * @param { Array<string> } uriList - List of asset uris whose permission will be granted to an App,
     * <br>the capacity of uriList is 1000.
     * @param { PhotoPermissionType } photoPermissionType - Permission type of accessing assets.
     * @param { HideSensitiveType } hideSensitiveType - Hide sensitive info type of accessing assets.
     * @returns { Promise<number> } Returns result of grant permission
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    grantPhotoUrisPermission(tokenId: number, uriList: Array<string>, photoPermissionType: PhotoPermissionType,
                             hideSensitiveType: HideSensitiveType): Promise<number>;

    /**
     * Grant permission of asset to an APP.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { number } tokenId - tokenId
     * @param { string } uri - Asset uri whose permission will be granted to an App.
     * @param { PhotoPermissionType } photoPermissionType - Permission type of accessing assets.
     * @param { HideSensitiveType } hideSensitiveType - Hide sensitive info type of accessing assets.
     * @returns { Promise<number> } Returns result of grant permission
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    grantPhotoUriPermission(tokenId: number, uri: string, photoPermissionType: PhotoPermissionType, hideSensitiveType: HideSensitiveType): Promise<number>;

    /**
     * Cancel permission of asset to an APP.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { number } tokenId - tokenId
     * @param { string } uri - Asset uri whose permission will be granted to an App.
     * @param { PhotoPermissionType } photoPermissionType - Permission type of accessing assets.
     * @returns { Promise<number> } Returns result of cancel permission
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    cancelPhotoUriPermission(tokenId: number, uri: string, photoPermissionType: PhotoPermissionType): Promise<number>;

    /**
     * Provides the capability of thumbnail generation according to specified rules.
     *
     * @param { dataSharePredicates.DataSharePredicates } predicate - Rule options for generating thumbnails.
     * @param { AsyncCallback<void> } callback - Returns void.
     * @returns { number } Create task id for generating thumbnails
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @StageModelOnly
     * @atomicservice
     * @since 12
     */
    startCreateThumbnailTask(predicate: dataSharePredicates.DataSharePredicates, callback: AsyncCallback<void>): number;

    /**
     * Provides the capability of stop generating thumbnails.
     *
     * @param { number } taskId - Stop generating thumbnail task id.
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @StageModelOnly
     * @atomicservice
     * @since 12
     */
    stopCreateThumbnailTask(taskId: number): void;

    /**
     * Fetch shared photo assets.
     *
     * @permission ohos.permission.ACCESS_MEDIALIB_THUMB_DB
     * @param { FetchOptions } options - Fetch options.
     * @returns { Array<SharedPhotoAsset> } Returns the shared photo assets
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    getSharedPhotoAssets(options: FetchOptions): Array<SharedPhotoAsset>;

    saveGalleryFormInfo(info: GalleryFormInfo): Promise<void>;
    removeGalleryFormInfo(info: GalleryFormInfo): Promise<void>;
    updateGalleryFormInfo(info: GalleryFormInfo): Promise<void>;

    /**
     * Start asset analysis service
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { AnalysisType } type - Analysis type
     * @param { Array<string> } assetUris - The uris of asset.
     * @returns { Promise<number> } Returns the task id of the service.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 18
     */
    startAssetAnalysis(type: AnalysisType, assetUris?: Array<string>): Promise<number>;

    /**
     * Obtains photo albums based on the specified options. This API uses a promise to return the result.
     * Before the operation, ensure that the albums to obtain exist.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } [options] - Options for fetching the albums.
     * @returns { Promise<FetchResult<Album>> } - Return the fetch result
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800301 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    getPhotoAlbums(options?: FetchOptions): Promise<FetchResult<Album>>;

    /**
     * Get Order of Photo Albums
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { number } orderStyle - Order style for albums.
     * @param { FetchOptions } [options] - Options for fetching the albums.
     * @returns { Promise<FetchResult<AlbumOrder>> } - Return FetchResult of AlbumOrder.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The input parameter is not within the valid range.
     * @throws { BusinessError } 23800301 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    getPhotoAlbumOrder(orderStyle: number, options?: FetchOptions): Promise<FetchResult<AlbumOrder>>;

    /**
     * Set Order of Photo Albums
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { number } orderStyle - Order style for albums.
     * @param { Array<AlbumOrder> } albumOrders - Array AlbumOrder of the content.
     * @returns { Promise<void> } - Return void
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The input parameter is not within the valid range.
     * @throws { BusinessError } 23800301 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    setPhotoAlbumOrder(orderStyle: number, albumOrders: Array<AlbumOrder>): Promise<void>;

    /**
     * Register the callback of photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'photoChange' } type - The value is fixed at 'photoChange', indicating the photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback invoked when the photo is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'photoChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    on(type: 'photoChange', callback: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Unregister the callback of photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'photoChange' } type - The value is fixed at 'photoChange', indicating the photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'photoChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    off(type: 'photoChange', callback?: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Register the callback of hidden photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { 'hiddenPhotoChange' } type - The value is fixed at 'hiddenPhotoChange', indicating the hidden photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback invoked when the hidden photo is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'hiddenPhotoChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    on(type: 'hiddenPhotoChange', callback: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Unregister the callback of hidden photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { 'hiddenPhotoChange' } type - The value is fixed at 'hiddenPhotoChange', indicating the hidden photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'hiddenPhotoChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    off(type: 'hiddenPhotoChange', callback?: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Register the callback of trashed photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'trashedPhotoChange' } type - The value is fixed at 'trashedPhotoChange', indicating the trashed photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback invoked when the trashed photo is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'trashedPhotoChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    on(type: 'trashedPhotoChange', callback: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Unregister the callback of trashed photo changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'trashedPhotoChange' } type - The value is fixed at 'trashedPhotoChange', indicating the trashed photo change event.
     * @param { Callback<PhotoAssetChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'trashedPhotoChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    off(type: 'trashedPhotoChange', callback?: Callback<PhotoAssetChangeInfos>): void;

    /**
     * Register the callback of album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'photoAlbumChange' } type - The value is fixed at 'photoAlbumChange', indicating the album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback invoked when the album is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'photoAlbumChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    on(type: 'photoAlbumChange', callback: Callback<AlbumChangeInfos>): void;

    /**
     * Unregister the callback of album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'photoAlbumChange' } type - The value is fixed at 'photoAlbumChange', indicating the album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'photoAlbumChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    off(type: 'photoAlbumChange', callback?: Callback<AlbumChangeInfos>): void;

    /**
     * Register the callback of hidden album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { 'hiddenAlbumChange' } type - The value is fixed at 'hiddenAlbumChange', indicating the hidden album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback invoked when the hidden album is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'hiddenAlbumChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    on(type: 'hiddenAlbumChange', callback: Callback<AlbumChangeInfos>): void;

    /**
     * Unregister the callback of hidden album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { 'hiddenAlbumChange' } type - The value is fixed at 'hiddenAlbumChange', indicating the hidden album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'hiddenAlbumChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    off(type: 'hiddenAlbumChange', callback?: Callback<AlbumChangeInfos>): void;

    /**
     * Register the callback of trashed album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'trashedAlbumChange' } type - The value is fixed at 'trashedAlbumChange', indicating the trashed album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback invoked when the trashed album is changed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'trashedAlbumChange'; 2. The same callback is registered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    on(type: 'trashedAlbumChange', callback: Callback<AlbumChangeInfos>): void;

    /**
     * Unregister the callback of trashed album changes.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { 'trashedAlbumChange' } type - The value is fixed at 'trashedAlbumChange', indicating the trashed album change event.
     * @param { Callback<AlbumChangeInfos> } callback - Callback to be removed.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800151 - The scenario parameter verification fails.
     * <br>Possible causes: 1. The type is not fixed at 'trashedAlbumChange'; 2. The same callback is unregistered repeatedly.
     * @throws { BusinessError } 23800301 - Internal system error. You are advised to retry and check the logs.
     * <br>Possible causes: 1. The database is corrupted. 2. The file system is abnormal. 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    off(type: 'trashedAlbumChange', callback?: Callback<AlbumChangeInfos>): void;
  }

  /**
   * Enumeration status of thumbnail change.
   *
   * @enum { number } ThumbnailChangeStatus
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 20
   */
  enum ThumbnailChangeStatus {
    /**
     * Thumbnail not exists.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    THUMBNAIL_NOT_EXISTS = 0,

    /**
     * Thumbnail have been newly created.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    THUMBNAIL_ADD = 1,

    /**
     * Thumbnail have been modified.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    THUMBNAIL_UPDATE = 2,

    /**
     * Thumbnail no change.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    THUMBNAIL_NOT_CHANGE = 3
  }

  /**
   * Enumeration of strong association types of photos.
   *
   * @enum { number } StrongAssociationType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 20
   */
  enum StrongAssociationType {
    /**
     * Normal photo type.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    NORMAL = 0,
    /**
     * Cloud enhancement photo type.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    CLOUD_ENHANCEMENT = 1
  }

  /**
   * Defines the photo asset change infos.
   *
   * @interface PhotoAssetChangeInfos
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface PhotoAssetChangeInfos {
    /**
     * Notification type of photo asset.
     *
     * @type { NotifyChangeType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    type: NotifyChangeType;

    /**
     * The changed asset datas.
     *
     * @type { PhotoAssetChangeData[] | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    assetChangeDatas: PhotoAssetChangeData[] | null;

    /**
     * Whether the application should recheck the photo asset infos that use to solve abnormal notification scenarios.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    isForRecheck: boolean;
  }

  /**
   * Defines the photo asset change data.
   *
   * @interface PhotoAssetChangeData
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface PhotoAssetChangeData {
    /**
     * The photo asset info before change.
     *
     * @type { PhotoAssetChangeInfo | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    assetBeforeChange: PhotoAssetChangeInfo | null;

    /**
     * The photo asset info after change.
     *
     * @type { PhotoAssetChangeInfo | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    assetAfterChange: PhotoAssetChangeInfo | null;

    /**
     * Whether the photo asset content is changed.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    isContentChanged: boolean;

    /**
     * Whether the photo asset is deleted.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    isDeleted: boolean;

    /**
     * Thumbnail change status of The photo asset.
     *
     * @type { ThumbnailChangeStatus }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    thumbnailChangeStatus: ThumbnailChangeStatus;

    /**
     * The version of the photo asset info used to determine the order of notification changes.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    version: number;
  }

  /**
   * Defines the photo asset info.
   *
   * @interface PhotoAssetChangeInfo
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface PhotoAssetChangeInfo {
    /**
     * The uri of photo asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    uri: string;

    /**
     * The media type of photo asset.
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    mediaType: PhotoType;

    /**
     * The album uri of photo asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumUri: string;

    /**
     * The file id of photo asset.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    fileId: number;

    /**
     * The date day of photo asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    dateDay: string;

    /**
     * The favorite state of photo asset.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    isFavorite: boolean;

    /**
     * The hidden state of photo asset.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    isHidden: boolean;

    /**
     * The strong association value of photo asset.
     *
     * @type { StrongAssociationType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    strongAssociation: StrongAssociationType;

    /**
     * The visibility of photo asset thumbnail.
     *
     * @type { ThumbnailVisibility }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    thumbnailVisible: ThumbnailVisibility;

    /**
     * The trashed time of photo asset in milliseconds.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    dateTrashedMs: number;

    /**
     * The added time of photo asset in milliseconds.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    dateAddedMs: number;

    /**
     * The taken time of photo asset in milliseconds.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    dateTakenMs: number;

    /**
     * asset position.
     *
     * @type { ?PositionType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 22
     */
    position?: PositionType;

    /**
     * Display name of photo asset.
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 22
     */
    displayName?: string;

    /**
     * Size of photo asset.
     *
     * @type { ?number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 22
     */
    size?: number;
  }

  /**
   * Defines the album change infos.
   *
   * @interface AlbumChangeInfos
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface AlbumChangeInfos {
    /**
     * Notification type of album.
     *
     * @type { NotifyChangeType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    type: NotifyChangeType;

    /**
     * The changed album datas.
     *
     * @type { AlbumChangeData[] | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumChangeDatas: AlbumChangeData[] | null;

    /**
     * Whether the application should recheck the album infos that use to solve abnormal notification scenarios.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    isForRecheck: boolean;
  }

  /**
   * Defines the album change data.
   *
   * @interface AlbumChangeData
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface AlbumChangeData {
    /**
     * The album info before change.
     *
     * @type { AlbumChangeInfo | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumBeforeChange: AlbumChangeInfo | null;

    /**
     * The album info after change.
     *
     * @type { AlbumChangeInfo | null }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumAfterChange: AlbumChangeInfo | null;

    /**
     * The version of the album info used to determine the order of notification changes.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    version: number;
  }

  /**
   * Defines the album info.
   *
   * @interface AlbumChangeInfo
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 20
   */
  interface AlbumChangeInfo {
    /**
     * Type of the album.
     *
     * @type { AlbumType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumType: AlbumType;

    /**
     * Subtype of the album.
     *
     * @type { AlbumSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumSubtype: AlbumSubtype;

    /**
     * Name of the album.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumName: string;

    /**
     * URI of the album.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    albumUri: string;

    /**
     * Number of images in the album.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    imageCount: number;

    /**
     * Number of videos in the album.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    videoCount: number;

    /**
     * Number of files in the album.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    count: number;

    /**
     * URI of the cover file of the album.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 20
     */
    coverUri: string;

    /**
     * Number of hidden files in the album.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    hiddenCount: number;

    /**
     * URI of the hidden cover file of the album.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    hiddenCoverUri: string;

    /**
     * Change state of the cover content.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    isCoverChanged: boolean;

    /**
     * Change state of the hidden cover content in the album.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    isHiddenCoverChanged: boolean;

    /**
     * Change info of the cover file of the album.
     *
     * @type { ?PhotoAssetChangeInfo }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    coverInfo?: PhotoAssetChangeInfo;

    /**
     * Change info of the hidden cover file of the album.
     *
     * @type { ?PhotoAssetChangeInfo }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    hiddenCoverInfo?: PhotoAssetChangeInfo;
  }

  /**
   * Form information.
   *
   * @interface FormInfo
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  interface FormInfo {
    /**
     * Id of the form.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    formId: string;

    /**
     * URI of the photo or album.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    uri: string;
  }

  enum AuthorizationMode {
    SHORT_TIME_AUTHORIZATION = 0,
  }

  /**
   * Enumeration types of data change.
   *
   * @enum { number } NotifyType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum NotifyType {
    /**
     * Data(assets or albums) have been newly created
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    NOTIFY_ADD,
    /**
     * Data(assets or albums) have been modified
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    NOTIFY_UPDATE,
    /**
     * Data(assets or albums) have been removed
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    NOTIFY_REMOVE,
    /**
     * Assets have been added to an album.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    NOTIFY_ALBUM_ADD_ASSET,
    /**
     * Assets have been removed from an album.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    NOTIFY_ALBUM_REMOVE_ASSET
  }

  /**
   * Enumeration uris for registerChange.
   *
   * @enum { string } DefaultChangeUri
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  enum DefaultChangeUri {
    /**
     * Uri for default PhotoAsset, use with forDescendant{true}, will receive all PhotoAsset's change notifications
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DEFAULT_PHOTO_URI = 'file://media/Photo',
    /**
     * Uri for default Album, use with forDescendant{true}, will receive all Album's change notifications
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    DEFAULT_ALBUM_URI = 'file://media/PhotoAlbum',
    /**
     * Uri for albums in hidden album view.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    DEFAULT_HIDDEN_ALBUM_URI = 'file://media/HiddenAlbum'
  }

  /**
   * Defines the change data
   *
   * @interface ChangeData
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  interface ChangeData {
    /**
     * The NotifyType of ChangeData
     *
     * @type { NotifyType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    type: NotifyType;

    /**
     * The changed uris
     *
     * @type { Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    uris: Array<string>;

    /**
     * Change details of the asset uris to an album.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    extraUris: Array<string>;

    /**
     * sharedPhotoAssets of the same type
     *
     * @type { Array<SharedPhotoAsset> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    sharedPhotoAssets: Array<SharedPhotoAsset>;

    /**
     * sharedAlbumAssets of the same type
     *
     * @type { Array<SharedAlbumAsset> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    sharedAlbumAssets: Array<SharedAlbumAsset>;

    /**
     * sharedExtraPhotoAssets of the same type
     *
     * @type { Array<SharedPhotoAsset> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    sharedExtraPhotoAssets: Array<SharedPhotoAsset>;
  }

  /**
   * PhotoViewMIMETypes represents the type of media resource that photo picker selects.
   *
   * @enum { string } PhotoViewMIMETypes
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * PhotoViewMIMETypes represents the type of media resource that photo picker selects.
   *
   * @enum { string } PhotoViewMIMETypes
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  export enum PhotoViewMIMETypes {
    /**
     * IMAGE_TYPE indicates that the selected media resources are images.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * IMAGE_TYPE indicates that the selected media resources are images.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    IMAGE_TYPE = 'image/*',
    /**
     * VIDEO_TYPE indicates that the selected media resources are videos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * VIDEO_TYPE indicates that the selected media resources are videos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    VIDEO_TYPE = 'video/*',
    /**
     * IMAGE_VIDEO_TYPE indicates that the selected media resources are images and videos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * IMAGE_VIDEO_TYPE indicates that the selected media resources are images and videos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    IMAGE_VIDEO_TYPE = '*/*',

    /**
     * MOVING_PHOTO_IMAGE_TYPE indicates that the selected media resources are moving photos.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    MOVING_PHOTO_IMAGE_TYPE = 'image/movingPhoto',
    GIF_IMAGE_TYPE = 'image/gif',
    PNG_IMAGE_TYPE = 'image/png',
    JPEG_IMAGE_TYPE = 'image/jpeg',
    HEIC_IMAGE_TYPE = 'image/heic',
    HEIF_IMAGE_TYPE = 'image/heif',
    BMP_IMAGE_TYPE = 'image/bmp',
    WEBP_IMAGE_TYPE = 'image/webp',
    AVIF_IMAGE_TYPE = 'image/avif',
    BURST_IMAGE_TYPE = 'image/Burst',
    MP4_VIDEO_TYPE = 'video/mp4',
    MOV_VIDEO_TYPE = 'video/quicktime'
  }

  /**
   * Class BaseSelectOptions, which is extracted from class PhotoSelectOptions
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  class BaseSelectOptions {
    /**
     * The Type of the file in the picker window.
     *
     * @type { ?PhotoViewMIMETypes }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * The Type of the file in the picker window.
     *
     * @type { ?PhotoViewMIMETypes }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * The Type of the file in the picker window.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?PhotoViewMIMETypes }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    MIMEType?: PhotoViewMIMETypes;
    /**
     * Maximum number of images for a single selection.
     *
     * @type { ?number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Maximum number of images for a single selection.
     *
     * @type { ?number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Maximum number of images for a single selection.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    maxSelectNumber?: number;
    /**
     * Support search.
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Support search.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    isSearchSupported?: boolean;
    /**
     * Support taking photos.
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * Support taking photos.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    isPhotoTakingSupported?: boolean;
    /**
     * The recommendation options when use recommendation photo function.
     *
     * @type { ?RecommendationOptions }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * The recommendation options when use recommendation photo function.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?RecommendationOptions }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    recommendationOptions?: RecommendationOptions;
    /**
     * The uri for the preselected files.
     *
     * @type { ?Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    /**
     * The uri for the preselected files.
     * Move from class PhotoSelectOptions to it's base class BaseSelectOptions
     *
     * @type { ?Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    preselectedUris?: Array<string>;
    /**
     * Support preview in single selection mode or not
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    isPreviewForSingleSelectionSupported?: boolean;

    /**
     *
     */
    mimeTypeFilter?: MimeTypeFilter;

    /**
     *
     */
    fileSizeFilter?: FileSizeFilter;
    /**
     *
     */
    videoDurationFilter?: VideoDurationFilter;
    /**
     * Configures filter conditions as a string array, supporting multiple combined
     * conditions to specify supported file types. When this parameter is set, the
     * original file type configuration parameters `MIMEType` and `mimeTypeFilter` become invalid.
     *
     * @type { ?Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 20
     */
    combinedMediaTypeFilter?: Array<string>;

    /**
     * Media file type and size combined filtering configuration. The array supports a maximum length of 3.
     * Setting this parameter will cause the `fileSizeFilter` and `MIMEType` parameters to be ignored.
     *
     * @type { ?Array<PhotoViewMimeTypeFileSizeFilter> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 20
     */
    photoViewMimeTypeFileSizeFilters?: Array<PhotoViewMimeTypeFileSizeFilter>;
  }

  /**
   *
   */
  class MimeTypeFilter {
    /**
     * 最多十种
     */
    mimeTypeArray: Array<string>;
  }

  class FileSizeFilter {
    filterOperator: FilterOperator;
    fileSize: number;
    extraFileSize?: number;
  }

  class VideoDurationFilter {
    filterOperator: FilterOperator;
    videoDuration: number;
    extraVideoDuration?: number;
  }

  /**
   * Media file video duration filtering configuration.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 20
   */
  class PhotoViewMimeTypeFileSizeFilter {
    /**
     * Specifing filter Type.
     *
     * @type { PhotoViewMIMETypes }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 20
     */
    photoViewMimeType: PhotoViewMIMETypes;

    /**
     * Specifing file size filtering configuration.
     *
     * @type { FileSizeFilter }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 20
     */
    sizeFilter: FileSizeFilter;
  }

  /**
   * PhotoSelectOptions Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * PhotoSelectOptions Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  /**
   * PhotoSelectOptions extends base class BaseSelectOptions
   *
   * @extends BaseSelectOptions
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  class PhotoSelectOptions extends BaseSelectOptions {
    /**
     * Support editing photos.
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    isEditSupported?: boolean;
    /**
     * Support select original photo or not
     *
     * @type { ?boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    isOriginalSupported?: boolean;
    /**
     * SubWindow name
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    subWindowName?: string;
    /**
     * Theme color
     *
     * @type { ?CustomColors }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    themeColor?: CustomColors;
    /**
     * Complete button text
     *
     * @type { ?CompleteButtonText }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    completeButtonText?: CompleteButtonText;

    /**
     * user id
     *
     * @type { ?number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @systemapi
     * @since 15
     */
    userId?: number;
  }

  /**
   * Options for recommend photos
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  class RecommendationOptions {
    /**
     * The recommendation photo type when select photo in photo picker.
     *
     * @type { ?RecommendationType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    recommendationType?: RecommendationType;
    /**
     * The textContextInfo to recommend images.
     *
     * @type { ?TextContextInfo }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    textContextInfo?: TextContextInfo;
  }

  /**
   * Defines the text context info.
   *
   * @interface TextContextInfo
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  interface TextContextInfo {
    /**
     * The Simplified Chinese(UTF-8) text within 250 to recommend images.
     *
     * @type { ?string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    text?: string;
  }

  /**
   * PhotoSelectResult Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * PhotoSelectResult Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  class PhotoSelectResult {
    /**
     * The uris for the selected files.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * The uris for the selected files.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    photoUris: Array<string>;
    /**
     * Original option.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Original option.
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    isOriginalPhoto: boolean;
  }

  /**
   * PhotoViewPicker Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 10
   */
  /**
   * PhotoViewPicker Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  class PhotoViewPicker {
    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { PhotoSelectOptions } [option] - represents the options provided in select mode.
     * @returns { Promise<PhotoSelectResult> } Returns the uris for the selected files.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { PhotoSelectOptions } [option] - represents the options provided in select mode.
     * @returns { Promise<PhotoSelectResult> } Returns the uris for the selected files.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    select(option?: PhotoSelectOptions): Promise<PhotoSelectResult>;

    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { PhotoSelectOptions } option - represents the options provided in select mode.
     * @param { AsyncCallback<PhotoSelectResult> } callback - Returns the PhotoSelectResult by photo picker
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { PhotoSelectOptions } option - represents the options provided in select mode.
     * @param { AsyncCallback<PhotoSelectResult> } callback - Returns the PhotoSelectResult by photo picker
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    select(option: PhotoSelectOptions, callback: AsyncCallback<PhotoSelectResult>): void;

    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { AsyncCallback<PhotoSelectResult> } callback - Returns the PhotoSelectResult by photo picker
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    /**
     * Pull up the photo picker based on the selection mode.
     *
     * @param { AsyncCallback<PhotoSelectResult> } callback - Returns the PhotoSelectResult by photo picker
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900042 - Unknown error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    select(callback: AsyncCallback<PhotoSelectResult>): void;
  }

  /**
   * MediaAssetEditData Object
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  class MediaAssetEditData {
    /**
     * The constructor to create a MediaAssetEditData instance.
     *
     * @param { string } compatibleFormat - Compatible format
     * @param { string } formatVersion - Format version
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    constructor(compatibleFormat: string, formatVersion: string);

    /**
     * Compatible format
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    compatibleFormat: string;
    /**
     * Format version
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    formatVersion: string;
    /**
     * Edit data
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    data: string;
  }

  /**
   * Enumeration of resource type.
   *
   * @enum { number } ResourceType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  enum ResourceType {
    /**
     * Image resource
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    IMAGE_RESOURCE = 1,

    /**
     * Video resource
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    VIDEO_RESOURCE = 2,

    /**
     * Photo proxy
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    PHOTO_PROXY = 3
  }

  /**
   * Enumeration of moving photo effect mode.
   *
   * @enum { number } MovingPhotoEffectMode
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  enum MovingPhotoEffectMode {
    /**
     * Default
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    DEFAULT = 0,

    /**
     * Bounce play
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    BOUNCE_PLAY = 1,

    /**
     * Loop play
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    LOOP_PLAY = 2,

    /**
     * Long exposure
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    LONG_EXPOSURE = 3,

    /**
     * Multi exposure
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    MULTI_EXPOSURE = 4,
    /**
     * Cinema graph
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    CINEMA_GRAPH = 5,

    /**
     * Image only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    IMAGE_ONLY = 10
  }

  /**
   * Defines the interface of media change request.
   *
   * @interface MediaChangeRequest
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  interface MediaChangeRequest {}

  /**
   * Defines the class of media asset change request.
   *
   * @implements MediaChangeRequest
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 11
   */
  class MediaAssetChangeRequest implements MediaChangeRequest {
    /**
     * The constructor to create a MediaAssetChangeRequest instance.
     *
     * @param { PhotoAsset } asset - Specify which asset to change
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    /**
     * The constructor to create a MediaAssetChangeRequest instance.
     *
     * @param { PhotoAsset } asset - Specify which asset to change
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    constructor(asset: PhotoAsset);

    /**
     * Create image asset change request.
     *
     * @param { Context } context - Hap context information
     * @param { string } fileUri - File uri
     * @returns { MediaAssetChangeRequest } - Returns a MediaAssetChangeRequest instance
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900002 - No such file
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    /**
     * Create image asset change request.
     *
     * @param { Context } context - Hap context information
     * @param { string } fileUri - File uri
     * @returns { MediaAssetChangeRequest } - Returns a MediaAssetChangeRequest instance
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900002 - No such file
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    static createImageAssetRequest(context: Context, fileUri: string): MediaAssetChangeRequest;

    /**
     * Create video asset change request.
     *
     * @param { Context } context - Hap context information
     * @param { string } fileUri - File uri
     * @returns { MediaAssetChangeRequest } - Returns a MediaAssetChangeRequest instance
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900002 - No such file
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    static createVideoAssetRequest(context: Context, fileUri: string): MediaAssetChangeRequest;

    /**
     * Create asset change request.
     *
     * @param { Context } context - Hap context information
     * @param { string } displayName - Asset name
     * @param { PhotoCreateOptions } [options] - Optional photo create option
     * @returns { MediaAssetChangeRequest } - Returns a MediaAssetChangeRequest instance
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000001 - Invalid display name
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    static createAssetRequest(context: Context, displayName: string, options?: PhotoCreateOptions): MediaAssetChangeRequest;

    /**
     * Create asset change request.
     *
     * @param { Context } context - Hap context information
     * @param { PhotoType } photoType - Photo asset type
     * @param { string } extension - Asset extension
     * @param { CreateOptions } [options] - Optional asset create option
     * @returns { MediaAssetChangeRequest } - Returns a MediaAssetChangeRequest instance
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    static createAssetRequest(context: Context, photoType: PhotoType, extension: string, options?: CreateOptions): MediaAssetChangeRequest;

    /**
     * Delete assets.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<PhotoAsset> } assets - Assets to delete
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    static deleteAssets(context: Context, assets: Array<PhotoAsset>): Promise<void>;

    /**
     * Delete assets.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<string> } uriList - Uris of assets to delete
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000002 - Invalid asset uri
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    static deleteAssets(context: Context, uriList: Array<string>): Promise<void>;

    /**
     * Get the asset.
     *
     * @returns { PhotoAsset } - Returns the asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    /**
     * Get the asset.
     *
     * @returns { PhotoAsset } - Returns the asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    getAsset(): PhotoAsset;

    /**
     * Set favorite state of the asset.
     *
     * @param { boolean } favoriteState - true: Put the asset into favorite album; false: Remove the asset from favorite album.
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setFavorite(favoriteState: boolean): void;

    /**
     * Set hidden state of the asset.
     *
     * @param { boolean } hiddenState - true: Put the asset into hidden album; false: Recover the asset from hidden album.
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setHidden(hiddenState: boolean): void;

    /**
     * Set user comment of the asset.
     *
     * @param { string } userComment - user comment info
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setUserComment(userComment: string): void;

    /**
     * Set location of the asset.
     *
     * @param { number } longitude - longitude value of the asset
     * @param { number } latitude - latitude value of the asset
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setLocation(longitude: number, latitude: number): void;

    /**
     * Set title of the asset.
     *
     * @param { string } title - the new title of the asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    /**
     * Set title of the asset.
     *
     * @param { string } title - the new title of the asset
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    setTitle(title: string): void;

    /**
     * Save edit data.
     *
     * @param { MediaAssetEditData } editData - edit data of the asset
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setEditData(editData: MediaAssetEditData): void;

    /**
     * Get write cache handler.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<number> } Returns the write cache handler
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    getWriteCacheHandler(): Promise<number>;

    /**
     * Add resource of the asset using file uri.
     *
     * @param { ResourceType } type - Resource type
     * @param { string } fileUri - File uri
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 13900002 - No such file
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    addResource(type: ResourceType, fileUri: string): void;

    /**
     * Add resource of the asset using ArrayBuffer.
     *
     * @param { ResourceType } type - Resource type
     * @param { ArrayBuffer } data - Data buffer to add
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 11
     */
    addResource(type: ResourceType, data: ArrayBuffer): void;

    /**
     * Add resource of the asset using PhotoProxy.
     *
     * @param { ResourceType } type - Resource type
     * @param { PhotoProxy } proxy - Photo proxy used to add resource
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    addResource(type: ResourceType, proxy: PhotoProxy): void;

    /**
     * Set camera shot key.
     *
     * @param { string } cameraShotKey - Camera shot key of the asset
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    setCameraShotKey(cameraShotKey: string): void;

    /**
     * Save the photo asset captured by camera.
     *
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    saveCameraPhoto(): void;

    /**
     * Save the photo asset captured by camera with imageFileType.
     *
     * @param { ImageFileType } imageFileType - Image file type
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 13
     */
    saveCameraPhoto(imageFileType: ImageFileType): void;

    /**
     * Discard the photo asset captured by camera.
     *
     * @throws { BusinessError } 14000011 - Internal system error
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    discardCameraPhoto(): void;

    /**
     * Set effect mode of moving photo.
     *
     * @param { MovingPhotoEffectMode } mode - the new effect mode of the moving photo
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    setEffectMode(mode: MovingPhotoEffectMode): void;

    /**
     * Set watermark type of the asset.
     *
     * @param { WatermarkType } watermarkType - the new watermark type of the asset
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    setSupportedWatermarkType(watermarkType: WatermarkType): void;

    /**
     * Delete local assets permanently from the album.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<PhotoAsset> } assets - the assets to be deleted permanently
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 16
     */
    static deleteLocalAssetsPermanently(context: Context, assets: Array<PhotoAsset>): Promise<void>;

    setSupportedDeferredEffects(effects: number): void;

    setDeferredEffectsStatus(status: number): void;

    static deleteLocalAssetsWithUri(context: Context, assetUris: string[]): Promise<void>;

    static deleteCloudAssetsWithUri(context: Context, assetUris: string[]): Promise<void>;
  }

  /**
   * Defines the class of media assets change request.
   *
   * @implements MediaChangeRequest
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 11
   */
  class MediaAssetsChangeRequest implements MediaChangeRequest {
    /**
     * The constructor to create a MediaAssetsChangeRequest instance.
     *
     * @param { Array<PhotoAsset> } assets - Specify which assets to change
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    constructor(assets: Array<PhotoAsset>);

    /**
     * Set favorite state of the assets.
     *
     * @param { boolean } favoriteState - true: Put the assets into favorite album; false: Remove the assets from favorite album.
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setFavorite(favoriteState: boolean): void;

    /**
     * Set hidden state of the assets.
     *
     * @param { boolean } hiddenState - true: Put the assets into hidden album; false: Recover the assets from hidden album.
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setHidden(hiddenState: boolean): void;

    /**
     * Set user comment of the assets.
     *
     * @param { string } userComment - user comment info
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setUserComment(userComment: string): void;
  }

  /**
   * Defines the class of media album change request.
   *
   * @implements MediaChangeRequest
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 11
   */
  class MediaAlbumChangeRequest implements MediaChangeRequest {
    /**
     * The constructor to create a MediaAlbumChangeRequest instance.
     *
     * @param { Album } album - Specify which album to change
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    constructor(album: Album);

    /**
     * Create album change request.
     *
     * @param { Context } context - Hap context information
     * @param { string } name - Album name
     * @returns { MediaAlbumChangeRequest } - Returns a MediaAlbumChangeRequest instance
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    static createAlbumRequest(context: Context, name: string): MediaAlbumChangeRequest;

    /**
     * Delete albums.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<Album> } albums - Albums to delete
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    static deleteAlbums(context: Context, albums: Array<Album>): Promise<void>;

    /**
     * Delete highlight albums.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<Album> } albums - Highlight albums to delete
     * @returns { Promise<void> } - Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    static deleteHighlightAlbums(context: Context, albums: Array<Album>): Promise<void>;

    /**
     * Get the album.
     *
     * @returns { Album } - Returns the album
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    getAlbum(): Album;

    /**
     * Set cover uri of the album.
     *
     * @param { string } coverUri - the asset uri to set
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setCoverUri(coverUri: string): void;

    /**
     * Set name of the album.
     *
     * @param { string } name - the new name to set
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    setAlbumName(name: string): void;

    /**
     * Add assets into the album.
     *
     * @param { Array<PhotoAsset> } assets - the assets to add
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    addAssets(assets: Array<PhotoAsset>): void;

    /**
     * Remove assets from the album.
     *
     * @param { Array<PhotoAsset> } assets - the assets to be removed
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 11
     */
    removeAssets(assets: Array<PhotoAsset>): void;

    /**
     * Move assets to the target album.
     *
     * @param { Array<PhotoAsset> } assets - the assets to move
     * @param { Album } targetAlbum - target album
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    moveAssets(assets: Array<PhotoAsset>, targetAlbum: Album): void;

    /**
     * Recover assets from the trash album.
     *
     * @param { Array<PhotoAsset> } assets - the assets to recover
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    recoverAssets(assets: Array<PhotoAsset>): void;

    /**
     * Delete assets permanently from the trash album.
     *
     * @param { Array<PhotoAsset> } assets - the assets to be deleted permanently
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    deleteAssets(assets: Array<PhotoAsset>): void;

    /**
     * Set portrait album to me
     *
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setIsMe(): void;

    /**
     * Set display level of the portrait album
     *
     * @param { number } displayLevel - The level of display interface for portrait albums, such as homepage and more pages
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    setDisplayLevel(displayLevel: number): void;

    /**
     * Remove assets from the smart album
     *
     * @param { Array<PhotoAsset> } assets - List of assets that need to be removed
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    dismissAssets(assets: Array<PhotoAsset>): void;

    /**
     * Merge two portrait albums
     *
     * @param { Album } target - Albums that need to be merged
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @throws { BusinessError } 14000016 - Operation Not Support
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    mergeAlbum(target: Album): void;

    /**
     * Place the current album in front of the target album.
     *
     * @param { Album } album - Specify the target album to be placed before
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 11
     */
    placeBefore(album: Album): void;
    /**
     * reset the album cover.
     *
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800301 - Internal system error.It is recommended to retry and check the logs.
     * <br>Possible causes:1. Database corrupted.2. The file system is abnormal.3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     * @arkts 1.1&1.2
     */
    resetCoverUri(): void;

    dismiss(): void;
    static setUploadStatus(context: Context, albums: Album[], allowUpload: boolean): Promise<void>;
  }

  /**
   * Defines the file assets info
   *
   * @interface FileAssetInfo
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  interface FileAssetInfo {
    /**
     * File id of file assets
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    file_id: number;

    /**
     * URI of the file assets.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    uri: string;

    /**
     * Media type of file assets
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    media_type: PhotoType;

    /**
     * Display name of file assets.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    display_name: string;

    /**
     * Size of the asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    size: number;

    /**
     * Add date of file assets
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    date_added: number;

    /**
     * Modify date of file assets
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    date_modified: number;

    /**
     * Duration of video files
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    duration: number;

    /**
     * Width of the image asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    width: number;

    /**
     * Height of the image asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    height: number;

    /**
     * DateTaken of file assets
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    date_taken: number;

    /**
     * Orientation of the image asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    orientation: number;

    /**
     * Favorite state of the asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    is_favorite: boolean;

    /**
     * Title of the asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    title: string;

    /**
     * Asset position
     *
     * @type { PositionType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    position: PositionType;

    /**
     * Trashed date of the asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    date_trashed: number;

    /**
     * Hidden state of the asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    hidden: boolean;

    /**
     * User comment info
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    user_comment: string;

    /**
     * Camera shot key
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    camera_shot_key: string;

    /**
     * The year of the file created, read only
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    date_year: string;

    /**
     * The month of the file created, read only
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    date_month: string;

    /**
     * The day of the file created, read only
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    date_day: string;

    /**
     * Pending state of the asset, true means asset is pending
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    pending: boolean;

    /**
     * Creation time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    date_added_ms: number;

    /**
     * Modified time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    date_modified_ms: number;

    /**
     * Trashed time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    date_trashed_ms: number;

    /**
     * Photo subtype of the asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    subtype: PhotoSubtype;
  }

  /**
   * Defines the shared photo asset
   *
   * @interface SharedPhotoAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  interface SharedPhotoAsset {
    /**
     * File id of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    fileId: number;
    /**
     * URI of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    uri: string;
    /**
     * Path data of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    data: string;
    /**
     * Media type of photo asset
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    mediaType: PhotoType;
    /**
     * Display name of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    displayName: string;
    /**
     * Size of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    size: number;
    /**
     * Added date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateAdded: number;
    /**
     * Modify date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateModified: number;
    /**
     * Duration of video photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    duration: number;
    /**
     * Width of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    width: number;
    /**
     * Height of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    height: number;
    /**
     * DateTaken of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateTaken: number;
    /**
     * Orientation of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    orientation: number;
    /**
     * Favorite state of photo asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    isFavorite: boolean;
    /**
     * Title of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    title: string;
    /**
     * Position of photo asset
     *
     * @type { PositionType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    position: PositionType;
    /**
     * Trashed date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateTrashed: number;
    /**
     * Hidden state of photo asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    hidden: boolean;
    /**
     * User comment info of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    userComment: string;
    /**
     * Camera shot key of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    cameraShotKey: string;
    /**
     * The year of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateYear: string;
    /**
     * The month of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateMonth: string;
    /**
     * The day of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateDay: string;
    /**
     * Pending state of the asset, true means asset is pending
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    pending: boolean;
    /**
     * Added date of photo asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateAddedMs: number;
    /**
     * Modified time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateModifiedMs: number;
    /**
     * Trashed time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dateTrashedMs: number;
    /**
     * Subtype of photo asset
     *
     * @type { PhotoSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    subtype: PhotoSubtype;
    /**
     * Effect mode of moving photo
     *
     * @type { MovingPhotoEffectMode }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    movingPhotoEffectMode: MovingPhotoEffectMode;
    /**
     * Dynamic range type of the asset
     *
     * @type { DynamicRangeType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    dynamicRangeType: DynamicRangeType;
    /**
     * Ready state of thumbnail
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    thumbnailReady: boolean;
    /**
     * Width and height information of lcd picture
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    lcdSize: string;
    /**
     * Width and height information of thumbnail picture
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    thmSize: string;
    /**
     * modified time of thumbnail status
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    thumbnailModifiedMs: number;
    /**
     * visibility of thumbnails
     *
     * @type { ThumbnailVisibility }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    thumbnailVisible: ThumbnailVisibility;
  }

  /**
   * Defines the shared album asset
   *
   * @interface SharedAlbumAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  interface SharedAlbumAsset {
    /**
     * album id of album asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    albumId: number;
    /**
     * type of album asset
     *
     * @type { AlbumType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    albumType: AlbumType;
    /**
     * subtype of album asset
     *
     * @type { AlbumSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    albumSubType: AlbumSubtype;
    /**
     * album name
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    albumName: string;
    /**
     * uri of album cover
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    coverUri: string;
    /**
     * number of assets in this album
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    count: number;
    /**
     * number of photo assets in this album
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    imageCount: number;
    /**
     * number of video assets in this album
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    videoCount: number;
    /**
     * sharedPhotoAsset of album cover
     *
     * @type { SharedPhotoAsset }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    coverSharedPhotoAsset: SharedPhotoAsset;
  }

  /**
   * Defines the moving photo.
   *
   * @interface MovingPhoto
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  interface MovingPhoto {
    /**
     * Request the image and video content of the moving photo and write to destination uri.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } imageFileUri - Destination uri of the image content to be written
     * @param { string } videoFileUri - Destination uri of the video content to be written
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    requestContent(imageFileUri: string, videoFileUri: string): Promise<void>;

    /**
     * Request content of the moving photo for the given resource type and write to destination uri.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { ResourceType } resourceType - The resource type of the content to request
     * @param { string } fileUri - Destination uri of the content to be written
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    requestContent(resourceType: ResourceType, fileUri: string): Promise<void>;

    /**
     * Request content of the moving photo for the given resource type and return the array buffer.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { ResourceType } resourceType - The resource type of the content to request
     * @returns { Promise<ArrayBuffer> } Returns array buffer of the content
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    requestContent(resourceType: ResourceType): Promise<ArrayBuffer>;

    /**
     * Get uri of the moving photo.
     *
     * @returns { string } Returns uri of the moving photo
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - System inner fail
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    getUri(): string;

    /**
     * Check if the video of the moving photo is ready.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<boolean> } Returns whether the video is ready
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 23800301 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 20
     */
    isVideoReady(): Promise<boolean>;
  }

  /**
   * Highlight album info type
   *
   * @enum { number } HighlightAlbumInfoType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  enum HighlightAlbumInfoType {
    /**
     * Highlight cover info
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    COVER_INFO = 0,
    /**
     * Highlight play info
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    PLAY_INFO
  }

  /**
   * Highlight user action type
   *
   * @enum { number } HighlightUserActionType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  enum HighlightUserActionType {
    /**
     * Highlight album inserted picture count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    INSERTED_PIC_COUNT = 0,
    /**
     * Highlight album removed picture count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    REMOVED_PIC_COUNT,
    /**
     * Highlight album shared screenshot count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SHARED_SCREENSHOT_COUNT,
    /**
     * Highlight album shared cover count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SHARED_COVER_COUNT,
    /**
     * Highlight album renamed count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    RENAMED_COUNT,
    /**
     * Highlight album changed cover count
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    CHANGED_COVER_COUNT,
    /**
     * Highlight album render viewed times
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    RENDER_VIEWED_TIMES = 100,
    /**
     * Highlight album render viewed duration
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    RENDER_VIEWED_DURATION,
    /**
     * Highlight album art layout viewed times
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ART_LAYOUT_VIEWED_TIMES,
    /**
     * Highlight album art layout viewed duration
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    ART_LAYOUT_VIEWED_DURATION
  }

  /**
   * Defines the class of highlight album.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  class HighlightAlbum {
    /**
     * The constructor to create a highlight instance.
     *
     * @param { Album } album - Analysis album
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    constructor(album: Album);

    /**
     * Get highlight album info.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { HighlightAlbumInfoType } type - Highlight album info type
     * @returns { Promise<string> } Returns highlight album info into a json string
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getHighlightAlbumInfo(type: HighlightAlbumInfoType): Promise<string>;

    /**
     * Get highlight resource array buffer.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } resourceUri - highlight resource uri
     * @returns { Promise<ArrayBuffer> } Returns array buffer of the content
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getHighlightResource(resourceUri: string): Promise<ArrayBuffer>;

    /**
     * Set highlight user action data
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { HighlightUserActionType } type - Highlight user action type
     * @param { number } actionData - User action highlight album data
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    setHighlightUserActionData(type: HighlightUserActionType, actionData: number): Promise<void>;

    /**
     * Set highlight sub title
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } subTitle - Highlight sub title
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 16
     */
    setSubTitle(subTitle: string): Promise<void>;

    /**
     * Delete highlight albums
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Context } context - Hap context information
     * @param { Array<Album> } albums - Highlight albums to delete
     * @returns { Promise<number> } Returns result of delete highlight album
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 16
     */
    static deleteHighlightAlbums(context: Context, albums: Array<Album>): Promise<number>;
  }

  /**
   * Cloud enhancement task stage.
   *
   * @enum { number } CloudEnhancementTaskStage
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  enum CloudEnhancementTaskStage {
    /**
     * Cloud enhancement task exception stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_EXCEPTION = -1,
    /**
     * Cloud enhancement task preparing stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_PREPARING,
    /**
     * Cloud enhancement task uploading stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_UPLOADING,
    /**
     * Cloud enhancement task executing stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_EXECUTING,
    /**
     * Cloud enhancement task downloading stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_DOWNLOADING,
    /**
     * Cloud enhancement task failed stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_FAILED,
    /**
     * Cloud enhancement task completed stage.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    TASK_STAGE_COMPLETED
  }

  /**
   * Task state of cloud enhancement.
   *
   * @interface CloudEnhancementTaskState
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  interface CloudEnhancementTaskState {
    /**
     * Indicates the cloud enhancement task stage.
     *
     * @type { CloudEnhancementTaskStage }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    readonly taskStage: CloudEnhancementTaskStage;

    /**
     * Indicates the transferred file size.
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    readonly transferredFileSize?: number;

    /**
     * Indicates the total file size.
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    readonly totalFileSize?: number;

    /**
     * Indicates the expected duration of cloud enhancement queue time.
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    readonly expectedDuration?: number;

    /**
     * Status code when failed in cloud enhancement.
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    readonly statusCode?: number;
  }

  /**
   * Defines the class of cloud enhancement.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  class CloudEnhancement {
    /**
     * Get cloud enhancement instance.
     *
     * @param { Context } context - Hap context information
     * @returns { CloudEnhancement } Returns cloud enhancement instance
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    static getCloudEnhancementInstance(context: Context): CloudEnhancement;

    /**
     * Submit cloud enhancement tasks.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } photoAssets - The photo assets requested
     * @param { boolean } hasCloudWatermark - true: Persistent cloud watermark; false: Not persistent cloud watermark.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    submitCloudEnhancementTasks(photoAssets: Array<PhotoAsset>, hasCloudWatermark: boolean, isAuto?: number): Promise<void>;

    /**
     * Prioritize cloud enhancement task.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { PhotoAsset } photoAsset - The photo asset requested
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    prioritizeCloudEnhancementTask(photoAsset: PhotoAsset): Promise<void>;

    /**
     * Cancel cloud enhancement tasks.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { Array<PhotoAsset> } photoAssets - The photo assets requested
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    cancelCloudEnhancementTasks(photoAssets: Array<PhotoAsset>): Promise<void>;

    /**
     * Cancel all cloud enhancement tasks.
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    cancelAllCloudEnhancementTasks(): Promise<void>;

    /**
     * Query cloud enhancement task state.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { PhotoAsset } photoAsset - The photo asset requested
     * @returns { Promise<CloudEnhancementTaskState> } Returns cloud enhancement task state
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    queryCloudEnhancementTaskState(photoAsset: PhotoAsset): Promise<CloudEnhancementTaskState>;

    /**
     * Sync cloud enhancement task status.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    syncCloudEnhancementTaskStatus(): Promise<void>;

    /**
     * Get cloud enhancement pair.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { PhotoAsset } asset - The asset requested
     * @returns { Promise<PhotoAsset> } Returns cloud-enhanced asset
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    getCloudEnhancementPair(asset: PhotoAsset): Promise<PhotoAsset>;
  }

  /**
   * Cloud enhancement state.
   *
   * @enum { number } CloudEnhancementState
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  enum CloudEnhancementState {
    /**
     * Cloud enhancement unavailable state.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    UNAVAILABLE = 0,
    /**
     * Cloud enhancement available state.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    AVAILABLE,
    /**
     * Cloud enhancement executing state.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    EXECUTING,
    /**
     * Cloud enhancement completed state.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 13
     */
    COMPLETED
  }

  enum CloudMediaRetainType {
    /**
     * Deletes the local metadata and thumbnail of the original files from the cloud.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    RETAIN_FORCE = 0
  }

  class CloudMediaAssetManager {

    /**
     * Obtains a CloudMediaAssetManager instance.
     *
     * @param { Context } context - Obtains a CloudMediaAssetManager instance.
     * @returns { CloudMediaAssetManager } Returns cloud media asset manager instance
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @static
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     */
    static getCloudMediaAssetManagerInstance(context: Context): CloudMediaAssetManager;

    /**
     * Deletes local metadata and files of cloud media assets.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC_MANAGER
     * @param { CloudMediaRetainType } retainType - Mode for deleting cloud media assets.
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error. It is recommended to retry and check the logs.
     * <br>Possible causes: 1. Database corrupted; 2. The file system is abnormal; 3. The IPC request timed out.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     */
    retainCloudMediaAsset(retainType: CloudMediaRetainType): Promise<void>;
  }
}

export default photoAccessHelper;
