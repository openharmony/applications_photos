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
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { HiLog } from './HiLog';
import { dataSharePredicates } from '@kit.ArkData';
import { NullUtil } from './NullUtil';
import { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';

const TAG: string = 'PhotoAssetUtil';

export default class PhotoAssetUtil {
  private static readonly NEW_NAME_IMG: string = 'IMG_';
  private static readonly SCREENSHOT_NAME_IMG: string = 'screenshot_';
  private static readonly SCREENSHOT_NAME_IMG_BIG: string = 'Screenshot_';

  /**
   * subtype属性是否为动图
   *
   * @param asset photoAccessHelper.PhotoAsset
   * @returns true为动图
   */
  public static isMovingPhoto(asset: photoAccessHelper.PhotoAsset | undefined): boolean {
    const effectMode: number = Number(asset?.get(photoAccessHelper.PhotoKeys.MOVING_PHOTO_EFFECT_MODE));
    return asset !== undefined &&
      (asset.get(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE) === photoAccessHelper.PhotoSubtype.MOVING_PHOTO ||
        effectMode === 10);
  }

  /**
   * 构造新图片显示名称
   *
   * @returns 名称字符串
   */
  public static buildNewAssetDisplayName(srcTitle: string | undefined): string {
    if (srcTitle !== undefined && (srcTitle.startsWith(PhotoAssetUtil.SCREENSHOT_NAME_IMG) ||
    srcTitle.startsWith(PhotoAssetUtil.SCREENSHOT_NAME_IMG_BIG))) {
      return PhotoAssetUtil.SCREENSHOT_NAME_IMG + DateUtil.format(new Date(), 'yyyyMMdd_HHmmss');
    } else {
      return PhotoAssetUtil.NEW_NAME_IMG + DateUtil.format(new Date(), 'yyyyMMdd_HHmmss');
    }
  }

  /**
   * 将图片添加到相册，跳过系统相册
   *
   * @param asset PhotoAsset
   * @param albumUri 目标相册
   * @returns void
   */
  /* instrument ignore next */
  public static async addPhotoToAlbum(asset: photoAccessHelper.PhotoAsset, albumUri: string): Promise<void> {
    if (NullUtil.isStrNull(albumUri)) {
      return;
    }
    HiLog.i(TAG, `add asset to album: ${asset.uri} -> ${albumUri}`)
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let albumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.AlbumKeys.URI, albumUri);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext());
      // 获取要添加到的目标相册
      albumFetchResult =
        await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.USER, photoAccessHelper.AlbumSubtype.USER_GENERIC,
          fetchOptions);
      let album: photoAccessHelper.Album = await albumFetchResult.getFirstObject();
      // 获取系统相册，从图库系统相册 移动到 用户相册当前操作相册
      if (album.albumType !== photoAccessHelper.AlbumType.SYSTEM) {
        let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest =
          new photoAccessHelper.MediaAlbumChangeRequest(album);
        albumChangeRequest.addAssets([asset]);
        await phAccessHelper.applyChanges(albumChangeRequest);
        HiLog.i(TAG, `add asset to album successfully: ${albumUri}`);
      }
    } catch (err) {
      HiLog.e(TAG, `add asset to album failed with error: ${err.code}, ${err.message}`);
    } finally {
      albumFetchResult?.close();
      phAccessHelper?.release();
      HiLog.i(TAG, `finally albumFetchResult is close.`);
    }
  }

  /**
   * 彻底删除，不会再到回收相册
   *
   * @param asset PhotoAsset
   * @returns void
   */
  public static async deleteAssetThoroughly(asset?: photoAccessHelper.PhotoAsset): Promise<void> {
    if (!asset) {
      HiLog.i(TAG, 'deleteAssetThoroughly asset undefined');
      return;
    }
    try {
      await photoAccessHelper.MediaAssetChangeRequest.deleteAssets(getContext(), [asset]);
      await PhotoAssetUtil.deleteAssetFromTrash(asset);
    } catch (err) {
      HiLog.e(TAG, `deleteAssetThoroughly failed: ${err.message}`);
    }
  }

  /* instrument ignore next */
  public static async deleteAssetFromTrash(asset: photoAccessHelper.PhotoAsset): Promise<void> {
    // 获取回收站彻底删除
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext());
      fetchResult =
        await phAccessHelper.getAlbums(photoAccessHelper.AlbumType.SYSTEM, photoAccessHelper.AlbumSubtype.TRASH);
      if (fetchResult.getCount() <= 0) {
        HiLog.w(TAG, 'The trash albumn not found!');
        return;
      }
      let trashAlbum: photoAccessHelper.Album = await fetchResult.getFirstObject()
      // 在最近删除相册中删除
      HiLog.i(TAG, `delete asset from trash start: ${asset.uri}`);
      let albumChangeRequest: photoAccessHelper.MediaAlbumChangeRequest = new photoAccessHelper
        .MediaAlbumChangeRequest(trashAlbum);
      albumChangeRequest.deleteAssets([asset]);
      await phAccessHelper.applyChanges(albumChangeRequest);
      HiLog.i(TAG, 'delete asset from trash end');
    } catch (err) {
      HiLog.e(TAG, `delete asset from trash failed with error: ${err.code}, ${err.message}`);
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      HiLog.i(TAG, `fetchResult is close.`);
    }
  }
}