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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy {
  UserFileManagerAccess,
  PhotoAsset,
  PhotoAlbum
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy DatabaseUtils from '@ohos/dataprovider/src/main/ets/database/DatabaseUtils';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy {
  PhotoProcessHandler
} from '@ohos/dataprovider/src/main/ets/database/service/PhotoProcessHandler';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ValuesBucket } from '@kit.ArkData';
import lazy formBindingData from '@ohos.app.form.formBindingData';
import lazy { formProvider } from '@kit.FormKit';
import lazy common from '@ohos.app.ability.common';
import lazy { AccessUtil } from '@ohos/dataprovider/src/main/ets/AccessUtil';
import lazy { IsShowAlbumName } from '../../../../../../feature/dataProvider/src/main/ets/database/databaseconstant/FaCardTable.ets';

/* instrument ignore file */
const TAG: string = 'FormAbilityStub';

export default class FormAbilityStub {
  public static async updateAlbumCardFirstImage(formId: string, context: common.Context): Promise<void> {
    try {
      let albumFormData: Record<string, Object> = {};

      UserFileManagerAccess.getInstance().onCreate(context);
      let albumUri = await FormAbilityStub.getFaAlbumUri();
      Log.info(TAG, `updateAlbumCardFirstImage getFaAlbumUri = ${albumUri} ${formId}`);
      if (!albumUri) {
        return;
      }

      const result: PhotoAsset[] = await FormAbilityStub.getAssetsInAlbum(albumUri, 1);
      Log.info(TAG, `updateAlbumCardFirstImage getAssetsInAlbum = ${result.length} ${formId}`);
      if (result.length) {
        const agendaObjList: ValuesBucket = await FormAbilityStub.getAgendaObjList(result[0], context, albumUri, formId);
        albumFormData['formId'] = formId;
        albumFormData['agendaObjList'] = [agendaObjList];
      }

      let formBinding: formBindingData.FormBindingData = formBindingData.createFormBindingData(albumFormData);
      formProvider.updateForm(formId, formBinding);
    } catch (err) {
      Log.error(TAG, `updateAlbumCardFirstImage catch ${err?.message} ${formId}`);
    }
  }

  private static async getCameraAlbum(): Promise<string> {
    try {
      let albumInfos: PhotoAlbum[] = await UserFileManagerAccess.getInstance().getSystemSourceAlbums();
      if (!albumInfos) {
        Log.debug(TAG, `getSourceAlbums, albums is undefined`);
        return '';
      }
      const cameraAlbum = albumInfos.find(item => item.lpath === Constants.LPATH_CAMERA);
      if (!cameraAlbum || !cameraAlbum.count) {
        Log.debug(TAG, `getSourceAlbums, cameraAlbum is undefined`);
        return '';
      }
      return cameraAlbum.albumUri;
    } catch (error) {
      Log.error(TAG, `getSourceAlbums error: ${error}`);
      return ''
    }
  }

  private static async getFaAlbumUri(): Promise<string | undefined> {
    const cameraUri = await FormAbilityStub.getCameraAlbum();
    if (cameraUri) {
      Log.info(TAG, `getFaAlbumUri from camera`);
      return cameraUri;
    }

    const album = await UserFileManagerAccess.getInstance().getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
    if (album) {
      return album.albumUri;
    }

    return undefined;
  }

  private static async getAssetsInAlbum(albumUri: string, count: number): Promise<PhotoAsset[]> {
    const userFileManagerAccess = UserFileManagerAccess.getInstance();
    let result: photoAccessHelper.PhotoAsset[] = [];
    let fetchResult: photoAccessHelper.FetchResult<PhotoAsset> | undefined = undefined;
    try {
      let album = (await userFileManagerAccess.getAlbumByUri(albumUri) as photoAccessHelper.Album);
      let fetchOpt = AlbumDefine.getFileFetchOptWithDate(count, AlbumDefine.FILTER_MEDIA_TYPE_IMAGE, 0);

      fetchResult = await album.getAssets(fetchOpt);
      if (!fetchResult || fetchResult.getCount() <= 0) {
        Log.warn(TAG, 'getAssetsInAlbum fetchResult is empty');
        return [];
      }
      result = await fetchResult.getAllObjects();
    } catch (err) {
      Log.error(TAG, `getAssetsInAlbum error: ${err?.message}`)
    } finally {
      fetchResult?.close();
    }
    return result;
  }

  private static async getAgendaObjList(asset: photoAccessHelper.PhotoAsset, context: common.Context,  albumUri: string, formId: string): Promise<ValuesBucket> {
    const pixelMapData = await asset.getThumbnailData(photoAccessHelper.ThumbnailType.THM);
    const pixelBase64: string = await DatabaseUtils.bufferToBase64(pixelMapData);
    const photoBound: string = JSON.stringify(await PhotoProcessHandler.getAllPhotoBound(asset));
    UserFileManagerAccess.getInstance().onCreate(context);
    const albumName: string = await UserFileManagerAccess.getInstance().getAlbumNameByUri(albumUri, context);

    const imageItem: ValuesBucket = {
      image_uri: asset.uri,
      image_data: pixelBase64,
      photo_bound: photoBound,
      album_uri: albumUri,
      album_name: albumName,
      is_show_album_name: IsShowAlbumName.ON,
      form_id: formId,
    };
    Log.info(TAG,
      `getAgendaObjList image_uri = ${asset.uri}, image_data.length = ${pixelBase64.length}, photo_bound = ${photoBound}, album_name = ${albumName}`);
    return imageItem;
  }
}