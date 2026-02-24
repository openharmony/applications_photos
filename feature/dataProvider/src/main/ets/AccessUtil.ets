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
import lazy { PhotoAlbum, PhotoAsset,
  UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy fs from '@ohos.file.fs';
import lazy { QueryParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { HashSet, util } from '@kit.ArkTS';
import lazy { uriExistInProxyInfoI } from './database/service/FaCardAlbumService';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { image } from '@kit.ImageKit';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { Region as region } from '@ohos/common/src/main/ets/default/model/common/DataTypes';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';

const TAG = 'AccessUtil';
const MAX_EXECUTION_COUNT: number = 3;
export const MAX_BASE64_LEN: number = 400000;
const DEFAULT_QUALITY: number = 95;

/**
 * 时刻卡片数据静态方法
 */
export class AccessUtil {
  public static async getPhotoAssetByUri(context: Context, uri: string, fetchColumns?: string[]
  ): Promise<PhotoAsset | undefined> {
    const phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), uri);
      if (!fetchColumns) {
        fetchColumns = [photoAccessHelper.PhotoKeys.FAVORITE, photoAccessHelper.PhotoKeys.POSITION];
      }
      let options: photoAccessHelper.FetchOptions = {
        fetchColumns: fetchColumns,
        predicates: predicates,
      };
      fetchResult = await TraceControllerUtils.checkAsyncDelay(async ():
        Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> => {
        if (!phAccessHelper) {
          return undefined;
        }
        return await phAccessHelper.getAssets(options);
      }, 'getPhotoAssetByUri --> getAssets');
      if (fetchResult === undefined) {
        Log.info(TAG, 'getPhotoAssetByUri fetchResult is undefined');
        return undefined;
      }
      let result: PhotoAsset | undefined;
      Log.info(TAG, `getPhotoAssetByUri uri: ${uri} cnt: ${fetchResult.getCount()}`);
      result = await TraceControllerUtils.checkAsyncDelay(async (): Promise<PhotoAsset | undefined> => {
        return await fetchResult?.getFirstObject();
      }, 'getPhotoAssetByUri --> getFirstObject');
      return result;
    } catch (err) {
      Log.error(TAG, `getPhotoAssetByUri failed with error: ${err.code}, ${err.message}`);
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `getPhotoAssetByUri fetchResult is close.`);
    }
    return undefined;
  }

  public static async uriToBuffer(uri: string): Promise<ArrayBuffer | undefined> {
    let fileData: ArrayBuffer | undefined = undefined;
    let file: fs.File | undefined = undefined;
    try {
      file = await fs.open(uri, fs.OpenMode.READ_ONLY);
      let stat: fs.Stat = await fs.stat(file.fd);
      fileData = new ArrayBuffer(stat.size);
      let readLen = await fs.read(file.fd, fileData);
      Log.info(TAG, `uriToBuffer: ${uri}, ${readLen}`);
    } catch (err) {
      Log.error(TAG, `uriToBuffer failed with err: ${err}`);
    } finally {
      if (file) {
        fs.close(file.fd);
      }
    }
    return fileData;
  }

  public static async bufferToPixmap(fileData: ArrayBuffer): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      imageSource = image.createImageSource(fileData);
      pixelMap = await imageSource.createPixelMap({
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      });
      let imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
      Log.info(TAG, `bufferToPixmap, image info:, ${JSON.stringify(imageInfo)}`);
    } catch (err) {
      Log.error(TAG, `bufferToPixmap failed with err: ${err}`);
    } finally {
      imageSource?.release();
    }
    return pixelMap;
  }

  public static async pixelMapToBase64(pixelMap: image.PixelMap, limit: number): Promise<string> {
    const helper: util.Base64Helper = new util.Base64Helper();
    let pixelBase64 = '';
    let startTime = Date.now();
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    const packOpts: image.PackingOption = { format: 'image/png', quality: DEFAULT_QUALITY };
    try {
      // 如果pixelBase64大于400k，循环降采样至可插入。最多执行3次
      let executionCount: number = 1;
      do {
        await pixelMap.scale(0.5, 0.5);
        const pixelMapBuffer: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);
        const pixelMapArray: Uint8Array = new Uint8Array(pixelMapBuffer);
        pixelBase64 = await helper.encodeToString(pixelMapArray);
        Log.info(TAG, `executionCount is ${executionCount}, pixelBase64 = ${pixelBase64.length}` +
          ` encode cost ${Date.now() - startTime}`);
        executionCount++;
      } while (pixelBase64.length > limit && executionCount <= MAX_EXECUTION_COUNT);
      return pixelBase64;
    } catch (error) {
      Log.error(TAG, `pixelMapToBase64 error: ${JSON.stringify(error)}`);
      return pixelBase64;
    } finally {
      imagePackerApi?.release();
    }
  }

  private static buildFetchOptions(param?: QueryParam): photoAccessHelper.FetchOptions {
    return {
      fetchColumns: UserFileManagerAccess.ALL_IMAGE_VIDEO_FETCH_COLUMNS.slice(),
      predicates: new dataSharePredicates.DataSharePredicates()
        .orderByAsc(photoAccessHelper.PhotoKeys.DATE_TAKEN.toString())
        .limit(1, 0),
    } as photoAccessHelper.FetchOptions;
  }

  public static async preparePortraitCover(albumInfo: AlbumInfo, faceId: string,
    coverAsset: photoAccessHelper.PhotoAsset): Promise<AlbumInfo> {
    try {
      let size: Size = {
        width: 0,
        height: 0,
      };
      let lcdSize: Size | undefined = PhotoAccessHelperAccess.getLcdSize(coverAsset);
      if (lcdSize) {
        size = lcdSize;
      } else {
        let width: number = Number(coverAsset?.get(photoAccessHelper.PhotoKeys.WIDTH) || 0);
        let height: number = Number(coverAsset?.get(photoAccessHelper.PhotoKeys.HEIGHT) || 0);
        const orientation: number = Number(coverAsset?.get(photoAccessHelper.PhotoKeys.ORIENTATION));
        if (orientation === Constants.ANGLE_90 || orientation === Constants.ANGLE_270) {
          // 交换长宽
          size = { width: height, height: width };
        } else {
          size = { width: width, height: height };
        }
      }
      albumInfo.coverImgSize = size;
    } catch (err) {
      Log.info(TAG, `preparePortraitCover ImgSize err: ${err}`);
    }

    try {
      let mediaItem: MediaItem = new MediaItem(coverAsset);
      let size: Size = ImageUtil.resizeThumbnail(mediaItem.width, mediaItem.height);
      mediaItem.setThumbnail(mediaItem.getThumbnailSafe(size));
      albumInfo.setMediaItem(mediaItem);
      albumInfo.setCoverOrientation(mediaItem.orientation);
      let thumbnail: string = ImageUtil.getLCDUri(mediaItem.uri, mediaItem.path, mediaItem.getDateModified(),
        image.DecodingDynamicRange.SDR);
      albumInfo.setCoverPhotoUri(thumbnail);
      albumInfo.setCoverUri(thumbnail);
    } catch (err) {
      Log.info(TAG, `preparePortraitCover setMediaItem failed: ${err}`);
    }


    Log.info(TAG,
      `parseCover, Uri: ${albumInfo.coverUri}, Region: ${JSON.stringify(albumInfo.region)}, ImgSize: ${JSON.stringify(albumInfo.coverImgSize)}`);
    return albumInfo;
  }

}