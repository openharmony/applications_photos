/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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

import type Context from './application/Context';
import type image from './@ohos.multimedia.image';
import lang from '@arkts.lang';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

/**
 * Helper functions to access image and video assets
 *
 * @namespace sendablePhotoAccessHelper
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @atomicservice
 * @since 12
 */
declare namespace sendablePhotoAccessHelper {
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
   * @since 12
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
   * Enumeration of different types of photos
   *
   * @enum { number } PhotoType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  const enum PhotoType {
    /**
     * Image asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    IMAGE = 1,
    /**
     * Video asset
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    VIDEO
  }

  /**
   * Enumeration of different categories of photos
   *
   * @enum { number } PhotoSubtype
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 14
   */
  enum PhotoSubtype {
    /**
     * Default Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    /**
     * Default Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 14
     */
    DEFAULT = 0,

    /**
     * Screenshot Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    SCREENSHOT = 1,

    /**
     * Moving Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 14
     */
    MOVING_PHOTO = 3,

    /**
     * Burst Photo Type
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 14
     */
    BURST = 4
  }

  /**
   * Enumeration of dynamic range type
   *
   * @enum { number } DynamicRangeType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 14
   */
  enum DynamicRangeType {
    /**
     * SDR(Standard-Dynamic Range) format
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 14
     */
    SDR = 0,

    /**
     * HDR(High-Dynamic Range) format
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 14
     */
    HDR = 1
  }

  /**
   * Ability to access thumbnail
   *
   * @enum { number } ThumbnailVisibilty
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 14
   */
  enum ThumbnailVisibility {
    /**
     * Unable to access thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 14
     */
    INVISIBLE = 0,
    /**
     * able to access thumbnail
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
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
   * @since 14
   */
  enum PositionType {
    /**
     * Asset exists only in local device
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    LOCAL = 1 << 0,

    /**
     * Asset exists only in cloud
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    CLOUD = 1 << 1
  }

  /**
   * Enumeration of moving photo effect mode.
   *
   * @enum { number } MovingPhotoEffectMode
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  enum MovingPhotoEffectMode {
    /**
     * Default
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    DEFAULT = 0,

    /**
     * Bounce play
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    BOUNCE_PLAY = 1,

    /**
     * Loop play
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    LOOP_PLAY = 2,

    /**
     * Long exposure
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    LONG_EXPOSURE = 3,

    /**
     * Multi exposure
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    MULTI_EXPOSURE = 4,

    /**
     * Cinema graph
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    CINEMA_GRAPH = 5,

    /**
     * Image only
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    IMAGE_ONLY = 10
  }

  /**
   * Defines the photo asset
   *
   * @interface PhotoAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  interface PhotoAsset extends lang.ISendable {
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
     * @since 12
     */
    readonly photoType: PhotoType;

    /**
     * Display name (with a file name extension) of the asset.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly displayName: string;

    /**
     * Returns the value of the specified member.
     *
     * @param { string } member - Photo asset member. for example : get(PhotoKeys.SIZE)
     * @returns { MemberType } Returns the value of the specified photo asset member
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    get(member: string): photoAccessHelper.MemberType;

    /**
     * Set a new value to the specified member
     *
     * @param { string } member - Photo asset member
     * @param { string } value - The new value of the member.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     * @example : set(PhotoKeys.TITLE, "newTitle"), call commitModify after set
     */
    set(member: string, value: string): void;

    /**
     * Modify metadata of the asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    commitModify(): Promise<void>;

    /**
     * Get thumbnail of the asset
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { image.Size } [size] - Thumbnail's size
     * @returns { Promise<image.PixelMap> } Returns the thumbnail's pixelMap.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getThumbnail(size?: image.Size): Promise<image.PixelMap>;

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
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getAnalysisData(analysisType: photoAccessHelper.AnalysisType): Promise<string>;

    /**
     * Requests the read-only FD of the source asset.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @returns { Promise<number> }  Returns opened source asset fd.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    requestSource(): Promise<number>;

    /**
     * Creates a photoAccessHelper photoasset from sendable photoAccessHelper photoasset.
     *
     * @returns { photoAccessHelper.PhotoAsset } Returns the instance if the operation is successful.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    convertToPhotoAsset(): photoAccessHelper.PhotoAsset;
  }

  /**
   * The fetch result of assets or albums
   *
   * @interface FetchResult
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  interface FetchResult<T> extends lang.ISendable {
    /**
     * Obtains the total number of objects in the fetch result.
     *
     * @returns { number } Total number of objects.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getCount(): number;

    /**
     * Checks whether the result set points to the last row.
     * You need to check whether the object is the last one before calling getNextObject.
     *
     * @returns { boolean } Whether the object is the last one in the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    isAfterLast(): boolean;

    /**
     * Obtains the first object in the fetch result.
     *
     * @returns { Promise<T> } Returns the first object in the fetch result.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getFirstObject(): Promise<T>;

    /**
     * Obtains the next object in the fetch result.
     * Before calling this method, you must use isAfterLast() to check whether the current position is the last row
     * in the fetch result. This method only works when the current position is not the last row.
     *
     * @returns { Promise<T> } Returns the next object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getNextObject(): Promise<T>;

    /**
     * Obtains the last object in the fetch result
     *
     * @returns { Promise<T> } Returns the last object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 13900020 - Invalid argument
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getLastObject(): Promise<T>;

    /**
     * Obtains the object with the specified index in the fetch result.
     *
     * @param { number } index - Index of the asset to obtain.
     * @returns { Promise<T> } Returns the object
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 10
     */
    getObjectByPosition(index: number): Promise<T>;

    /**
     * Obtains all objects in the fetch result.
     *
     * @returns { Promise<Array<T>> } Returns all the objects
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAllObjects(): Promise<Array<T>>;

    /**
     * Releases the fetch result.
     *
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    close(): void;
  }

  /**
   * Album type.
   *
   * @enum { number } AlbumType
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  const enum AlbumType {
    /**
     * Album created by user.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    USER = 0,
    /**
     * Album created by system, which metadata cannot be modified.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    SYSTEM = 1024,
    /**
     * Album created by smart abilities.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SMART = 4096
  }

  /**
   * Album subtype
   *
   * @enum { number } AlbumSubtype
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  const enum AlbumSubtype {
    /**
     * Generic user-created albums.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    USER_GENERIC = 1,
    /**
     * Favorite album, which assets are marked as favorite.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    FAVORITE = 1025,
    /**
     * Video album, which contains all video assets.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    VIDEO,
    /**
     * Hidden album, which assets are marked as hidden.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    HIDDEN,
    /**
     * Trash album, which assets are deleted.
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    TRASH,
    /**
     * Screenshot album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SCREENSHOT,
    /**
     * Camera album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    CAMERA,
    /**
     * Image album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    IMAGE = 1031,
    /**
     * Source album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SOURCE_GENERIC = 2049,
    /**
     * Classify album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    CLASSIFY = 4097,
    /**
     * Location album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    GEOGRAPHY_LOCATION = 4099,
    /**
     * City album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    GEOGRAPHY_CITY,
    /**
     * ShootingMode album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    SHOOTING_MODE,
    /**
     * Portrait album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
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
    /**
     * Any album
     *
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    ANY = 2147483647
  }

  /**
   * Defines the abstract interface of albums.
   *
   * @interface AbsAlbum
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  interface AbsAlbum extends lang.ISendable {
    /**
     * Album type
     *
     * @type { AlbumType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly albumType: AlbumType;

    /**
     * Album subtype
     *
     * @type { AlbumSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly albumSubtype: AlbumSubtype;

    /**
     * Album name.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    albumName: string;

    /**
     * Album uri.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly albumUri: string;

    /**
     * Number of assets in the album
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly count: number;

    /**
     * Cover uri for the album
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly coverUri: string;

    /**
     * Fetch assets in an album.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Fetch options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAssets(options: photoAccessHelper.FetchOptions): Promise<FetchResult<PhotoAsset>>;

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
     * @since 14
     */
    getSharedPhotoAssets(options: photoAccessHelper.FetchOptions): Array<SharedPhotoAsset>;
  }

  /**
   * Defines the album.
   *
   * @interface Album
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 12
   */
  interface Album extends AbsAlbum {
    readonly lpath?: string;
    /**
     * Number of image assets in the album
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly imageCount?: number;

    /**
     * Number of video assets in the album
     *
     * @type { ?number }
     * @readonly
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    readonly videoCount?: number;

    /**
     * Modify metadata for the album
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    commitModify(): Promise<void>;

    /**
     * Creates a photoAccessHelper album from sendable photoAccessHelper album.
     *
     * @returns { photoAccessHelper.Album } Returns the instance if the operation is successful.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    convertToPhotoAlbum(): photoAccessHelper.Album;
  }

  /**
   * Defines the shared photo asset
   *
   * @interface SharedPhotoAsset
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  interface SharedPhotoAsset extends lang.ISendable {
    /**
     * File id of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    fileId: number;

    /**
     * URI of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    uri: string;

    /**
     * Path data of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    data: string;

    /**
     * Media type of photo asset
     *
     * @type { PhotoType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    mediaType: PhotoType;

    /**
     * Display name of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    displayName: string;

    /**
     * Size of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    size: number;

    /**
     * Added date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateAdded: number;

    /**
     * Modify date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateModified: number;

    /**
     * Duration of video photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    duration: number;

    /**
     * Width of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    width: number;

    /**
     * Height of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    height: number;

    /**
     * DateTaken of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateTaken: number;

    /**
     * Orientation of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    orientation: number;

    /**
     * Favorite state of photo asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    isFavorite: boolean;

    /**
     * Title of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    title: string;

    /**
     * Position of photo asset
     *
     * @type { PositionType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    position: PositionType;

    /**
     * Trashed date of photo asset
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateTrashed: number;

    /**
     * Hidden state of photo asset
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    hidden: boolean;

    /**
     * User comment info of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    userComment: string;

    /**
     * Camera shot key of photo asset
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    cameraShotKey: string;

    /**
     * The year of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateYear: string;

    /**
     * The month of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateMonth: string;

    /**
     * The day of the file created
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateDay: string;

    /**
     * Pending state of the asset, true means asset is pending
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    pending: boolean;

    /**
     * Added date of photo asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateAddedMs: number;

    /**
     * Modified time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateModifiedMs: number;

    /**
     * Trashed time of the asset in milliseconds
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dateTrashedMs: number;

    /**
     * Subtype of photo asset
     *
     * @type { PhotoSubtype }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    subtype: PhotoSubtype;

    /**
     * Effect mode of moving photo
     *
     * @type { MovingPhotoEffectMode }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    movingPhotoEffectMode: MovingPhotoEffectMode;

    /**
     * Dynamic range type of the asset
     *
     * @type { DynamicRangeType }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    dynamicRangeType: DynamicRangeType;

    /**
     * Ready state of thumbnail
     *
     * @type { boolean }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    thumbnailReady: boolean;

    /**
     * Width and height information of lcd picture
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
     */
    lcdSize: string;

    /**
     * Width and height information of thumbnail picture
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 14
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
   * Helper functions to access photos and albums.
   *
   * @interface PhotoAccessHelper
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @atomicservice
   * @since 12
   */
  interface PhotoAccessHelper extends lang.ISendable {
    /**
     * Fetch photo assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } options - Retrieval options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result.
     * @throws { BusinessError } 201 - Permission denied.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAssets(options: photoAccessHelper.FetchOptions): Promise<FetchResult<PhotoAsset>>;

    /**
     * Fetch a group of burst assets
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { string } burstKey - Burst asset options.
     * @returns { Promise<FetchResult<PhotoAsset>> } Returns the fetch result.
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getBurstAssets(burstKey: string, options: photoAccessHelper.FetchOptions): Promise<FetchResult<PhotoAsset>>;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @returns { Promise<PhotoAsset> } Returns the newly created asset
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    createAsset(displayName: string): Promise<PhotoAsset>;

    /**
     * Create a photo asset
     *
     * @permission ohos.permission.WRITE_IMAGEVIDEO
     * @param { string } displayName - Asset name
     * @param { PhotoCreateOptions } options - Create operation
     * @throws { BusinessError } 201 - Permission denied
     * @returns { Promise<PhotoAsset> } Returns the newly created asset
     * @throws { BusinessError } 202 - Called by non-system application.
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    createAsset(displayName: string, options: photoAccessHelper.PhotoCreateOptions): Promise<PhotoAsset>;

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
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @atomicservice
     * @since 12
     */
    createAsset(photoType: PhotoType, extension: string, options?: photoAccessHelper.CreateOptions): Promise<string>;

    /**
     * Fetch albums.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { FetchOptions } [options] - options to fetch albums
     * @returns { Promise<FetchResult<Album>> } - Returns the fetch result
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAlbums(options: photoAccessHelper.FetchOptions): Promise<FetchResult<Album>>;

    /**
     * Fetch albums.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO
     * @param { AlbumType } type - Album type.
     * @param { AlbumSubtype } subtype - Album subtype.
     * @param { FetchOptions } [options] - options to fetch albums
     * @returns { Promise<FetchResult<Album>> } - Returns the fetch result
     * @throws { BusinessError } 201 - Permission denied
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    getAlbums(type: AlbumType, subtype: AlbumSubtype, options?: photoAccessHelper.FetchOptions):
      Promise<FetchResult<Album>>;

    /**
     * Fetch albums containing hidden assets.
     *
     * @permission ohos.permission.READ_IMAGEVIDEO and ohos.permission.MANAGE_PRIVATE_PHOTOS
     * @param { HiddenPhotosDisplayMode } mode - Display mode of albums containing hidden assets.
     * @param { FetchOptions } [options] - Options to fetch albums.
     * @returns { Promise<FetchResult<Album>> } Returns fetchResult of albums containing hidden assets.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed,
     * application which is not a system application uses system API.
     * @param mode
     * @param options
     * @returns
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types; 3. Parameter verification failed.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @systemapi
     * @since 12
     */
    getHiddenAlbums(mode: photoAccessHelper.HiddenPhotosDisplayMode, options?: photoAccessHelper.FetchOptions):
      Promise<FetchResult<Album>>;

    /**
     * Release PhotoAccessHelper instance
     *
     * @returns { Promise<void> } Returns void
     * @throws { BusinessError } 401 - Parameter error. Possible causes: 1. Mandatory parameters are left unspecified;
     * <br>2. Incorrect parameter types.
     * @throws { BusinessError } 14000011 - Internal system error
     * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
     * @since 12
     */
    release(): Promise<void>;

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
     * @since 14
     */
    getSharedPhotoAssets(options: photoAccessHelper.FetchOptions): Array<SharedPhotoAsset>;
  }
}

export default sendablePhotoAccessHelper;