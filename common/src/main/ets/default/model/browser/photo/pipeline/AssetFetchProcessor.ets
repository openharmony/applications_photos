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

import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import type { PhotoAsset } from '../../../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../../../access/PhotoAccessHelperAccess';
import type { PhotoAlbum } from '../../../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../../../access/UserFileManagerAccess';
import lazy { Log } from '../../../../utils/Log';
import lazy { TraceControllerUtils } from '../../../../utils/TraceControllerUtils';
import type { Thumbnail } from '../Thumbnail';
import type { RequestContext } from './RequestContext';
import lazy { RequestProcessor } from './RequestProcessor';
import lazy { SelectParams } from '../../../common/SelectParams'
import lazy { Constants } from '../../../common/Constants'

/* instrument ignore file */
const TAG: string = 'AssetFetchProcessor';

/**
 * 获取文件
 *
 * @since 2023-10-18
 */
export class AssetFetchProcessor extends RequestProcessor<Thumbnail> {
  public static readonly KEY_IMAGE_ASSET: string = 'KEY_IMAGE_ASSET';

  public getProcessorName(): string {
    return TAG;
  }

  public async getResult(context: RequestContext<Thumbnail | undefined>): Promise<Thumbnail | undefined> {
    if (!context) {
      return undefined;
    }

    const TASK_ID = new Date().getTime();
    TraceControllerUtils.startTraceWithTaskId('getUserFileMgr', TASK_ID);
    let userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    let userFileMgr: photoAccessHelper.PhotoAccessHelper;
    if (userId < 0) {
      userFileMgr = photoAccessHelper.getPhotoAccessHelper(context.appCtx);
    } else {
      userFileMgr = photoAccessHelper.getPhotoAccessHelper(context.appCtx, userId);
    }
    TraceControllerUtils.finishTraceWithTaskId('getUserFileMgr', TASK_ID);
    if (!userFileMgr) {
      Log.error(TAG, 'failed to get UserFileManager');
      return undefined;
    }
    let asset: photoAccessHelper.PhotoAsset | undefined = undefined;
    if (context.request && context.request.albumUri?.length && context.request.albumUri?.length > 0) {
      if (context.request.isNewApi) {
        asset = await this.getAssetByNewApi(context);
      } else {
        asset = await this.getAssetByAlbum(context, userFileMgr);
      }
    }
    if (!asset) {
      asset = await this.getAssetByUri(context, userFileMgr);
    }

    if (!asset) {
      Log.error(TAG, 'failed to get asset:');
      return undefined;
    }
    context.params.set(AssetFetchProcessor.KEY_IMAGE_ASSET, asset);
    Log.debug(TAG, 'finished to get asset: ');
    return undefined;
  }

  private async getAssetByAlbum(context: RequestContext<Thumbnail | undefined>,
    userFileMgr: photoAccessHelper.PhotoAccessHelper): Promise<PhotoAsset | undefined> {
    let albumFetchResult: photoAccessHelper.FetchResult<PhotoAlbum> | undefined = undefined;
    let assetFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      let predicates = new dataSharePredicates.DataSharePredicates();
      if (!context.request) {
        Log.error(TAG, 'getAssetByAlbum request is undefined');
        return undefined;
      }
      predicates.equalTo(photoAccessHelper.AlbumKeys.URI.toString(), context.request.albumUri);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      // TODO: Switching off type checks with in-place comments is not allowed
      // Waiting: 支持不传入type时删掉 ts-ignore
      let isHiddenAlbum: boolean = UserFileManagerAccess.getInstance().getIsHiddenAlbum();
      if (isHiddenAlbum) {
        albumFetchResult = await userFileMgr.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
      } else {
        albumFetchResult = await userFileMgr.getAlbums(fetchOptions);
      }
      if (!albumFetchResult || albumFetchResult.getCount() <= 0) {
        Log.warn(TAG, `failed to getAlbumByUri: ${context.request.albumUri}`);
        return undefined;
      }
      let album: PhotoAlbum = await albumFetchResult.getFirstObject();
      if (!album) {
        Log.warn(TAG, `failed to getFirstObject: ${context.request.albumUri}`);
        return undefined;
      }
      if (!context.request.item) {
        Log.error(TAG, 'getAssetByAlbum request item is undefined');
        return undefined;
      }
      predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), context.request.item.uri);
      fetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      assetFetchResult = await album.getAssets(fetchOptions);
      if (!assetFetchResult || assetFetchResult.getCount() <= 0) {
        Log.error(TAG, `failed to get getAssetByAlbum ${
        JSON.stringify(assetFetchResult)} ${context.request.albumUri}`);
        return undefined;
      }
      return assetFetchResult.getFirstObject();
    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get Album by uri exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    } finally {
      albumFetchResult?.close();
      assetFetchResult?.close();
      Log.info(TAG, `albumFetchResult assetFetchResult are close.`);
    }
  }

  private async getAssetByNewApi(context: RequestContext<Thumbnail | undefined>):
    Promise<photoAccessHelper.PhotoAsset | undefined> {
    try {
      const helper = PhotoAccessHelperAccess.getInstance();
      if (!context.appCtx) {
        Log.error(TAG, 'getAssetByNewApi appCtx is undefined');
        return undefined;
      }
      if (!context.request || !context.request.albumUri) {
        Log.error(TAG, 'getAssetByNewApi request is undefined');
        return undefined;
      }
      const album = await PhotoAccessHelperAccess.getAlbumByUri(context.appCtx, {
        albumType: photoAccessHelper.AlbumType.SYSTEM,
        albumSubtype: photoAccessHelper.AlbumSubtype.HIDDEN,
        albumUri: context.request.albumUri,
        isHiddenSubAlbumQuery: true,
      });
      if (!album) {
        Log.error(TAG, `failed to get getAssetByNewApi ${context.request.albumUri}`);
        return undefined;
      }
      if (!context.request.item) {
        Log.error(TAG, 'getAssetByNewApi request item is undefined');
        return undefined;
      }
      return await helper.getObject(album, context.request.item.uri);

    } catch (err) {
      Log.error(TAG, `getAlbumByUri Get AssetByNewApi by uri exception! msg:  ${err}, code: ${err?.code}`);
      return undefined;
    }
  }

  private async getAssetByUri(context: RequestContext<Thumbnail | undefined>,
    userFileMgr: photoAccessHelper.PhotoAccessHelper):
    Promise<photoAccessHelper.PhotoAsset | undefined> {
    let assetFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      const TASK_ID = new Date().getTime();
      let predicates = new dataSharePredicates.DataSharePredicates();
      if (context.request?.item?.uri === undefined) {
        Log.error(TAG, 'getAssetByUri request item is undefined');
        return undefined;
      }
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI.toString(), context.request.item.uri);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };

      TraceControllerUtils.startTraceWithTaskId('getAssetByUri', TASK_ID);
      assetFetchResult = await userFileMgr.getAssets(fetchOptions);
      TraceControllerUtils.finishTraceWithTaskId('getAssetByUri', TASK_ID);
      if (!assetFetchResult || assetFetchResult.getCount() === 0) {
        Log.error(TAG, `failed to get getAssetByUri ${JSON.stringify(assetFetchResult)}`);
        return undefined;
      }

      return assetFetchResult.getFirstObject();
    } catch (err) {
      Log.error(TAG, `getAssetByUri failed with err: ${err}`);
      return undefined;
    } finally {
      assetFetchResult?.close();
      Log.info(TAG, `assetFetchResult is close.`);
    }
  }
}