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
import { HiLog } from '../util/HiLog';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import userFileManager from '@ohos.filemanagement.userFileManager';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { GlobalThisUtil } from '../util/GlobalThisUtil';
import { App } from '../../service/App';
import systemParameter from '@ohos.systemparameter';
import { Trace } from '../util/Trace'
import { contextConstant } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import { MediaSaveManager } from '../../feature/basic/model/common/MediaSaveManager';

/* instrument ignore file */
const HMC_INVALID_FD: number = -1;

const TAG = 'MediaLibraryProxy';

interface FileResult {
  fd: number;
  path: string;
  name: string;
  fileSuffix: string;
}

export class ImageMediaLibraryProxy {
  private context: common.Context;
  private static sportFile: fs.File | undefined = undefined;
  private nativeWindowAddress: number | undefined = undefined;

  private constructor(context: common.Context) {
    this.context = context;
  }

  public static getInstance(context: common.Context): ImageMediaLibraryProxy {
    if (globalThis.image_editor_MediaLibraryProxy === undefined) {
      globalThis.image_editor_MediaLibraryProxy = new ImageMediaLibraryProxy(context);
    }
    return globalThis.image_editor_MediaLibraryProxy;
  }

  /**
   * 打开媒体uri，通过callback 返回 fd
   *
   * @param uri 媒体uri
   * @param mode 读写方式
   * @param callback 回调
   */
  openUri(uri: string, mode: string, callback: Function): void {
    let isHidden: boolean = App.getInstance().myEditor().isHiddenSource;
    HiLog.i(TAG, 'openUri ' + uri + ` mode=${mode}` + ' isHidden = ' + isHidden);
    if (isHidden) {
      let context = GlobalThisUtil.getLocalProperty('photosAbilityContext') as common.Context;
      let helper = photoAccessHelper.getPhotoAccessHelper(context);
      // 隐藏相册
      helper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE).then(async (albumFetchResult) => {
        const hiddenAlbum: photoAccessHelper.Album = await albumFetchResult.getFirstObject();
        albumFetchResult.close();
        HiLog.i(TAG, `albumFetchResult is close.`);
        let opt: photoAccessHelper.FetchOptions = {
          predicates: new dataSharePredicates.DataSharePredicates(),
          fetchColumns: [],
        }
        opt.predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
        const hiddenAssetFetchResult = await hiddenAlbum.getAssets(opt);
        let photoAsset = await hiddenAssetFetchResult.getFirstObject();
        hiddenAssetFetchResult.close();
        HiLog.i(TAG, `hiddenAssetFetchResult is close.`);
        HiLog.i(TAG, `hiddenAlbum=${hiddenAlbum} -- photoAsset=${photoAsset.uri}`);
        if (photoAsset) {
          let fd = await photoAsset.open(mode);
          callback(fd);
        } else {
          callback(HMC_INVALID_FD);
        }
      });
    } else {
      Trace.begin('openUri');
      let mgr = userFileManager.getUserFileMgr(this.context);
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(userFileManager.ImageVideoKey.URI.toString(), uri);
      let fetchOptions: userFileManager.FetchOptions = {
        fetchColumns: [],
        predicates: predicates,
      };
      mgr.getPhotoAssets(fetchOptions).then(async (fetchResult) => {
        if (!fetchResult) {
          throw new Error('fetchResult is null');
        }
        let count = fetchResult.getCount();
        if (count <= 0) {
          fetchResult.close();
          throw new Error('getPhotoAssets failed, fetchResult count is 0');
        } else {
          let fileAsset = await fetchResult.getFirstObject();
          fetchResult.close();
          if (fileAsset) {
            let fd = await fileAsset.open(mode);
            Trace.end('openUri');
            callback(fd);
          } else {
            throw new Error('fileAsset is null');
          }
        }
      }).catch((err: BusinessError) => {
        HiLog.e(TAG, 'fs.open failed, message =' + err.message + `, error code = ${err.code}`);
        callback(HMC_INVALID_FD);
      }).finally(() => {
        mgr.release();
      });
    }
  }

  isDebugEnable(key: string, callback: Function): void {
    HiLog.i(TAG, ` isDebugEnable key = ${key}`);
    let param: string = systemParameter.getSync(key, 'false');
    HiLog.i(TAG, ` isDebugEnable value = ${param}`);
    callback(param === 'true' ? true : false);
  }

  /**
   * 转换PixelMap格式为RGBA
   *
   * @param pixelMap PixelMap
   * @param callback 回调函数
   */
  convertPixelMap2RGBA(pixelMap: image.PixelMap, callback: Function): void {
    HiLog.i(TAG, `convertPixelMap2RGBA start, pixelMapSize: ${pixelMap.getPixelBytesNumber()}`);
    new Promise<void>(async () => {
      try {
        // YUV和RGB类型互转，目前仅支持NV12/NV21与RGB888/RGBA8888/RGB565/BGRA8888/RGBAF16互转，
        // YCRCB_P010/YCBCR_P010与RGBA1010102互转
        await pixelMap.convertPixelFormat(image.PixelMapFormat.NV12);
        await pixelMap.convertPixelFormat(image.PixelMapFormat.RGBA_8888);
        HiLog.i(TAG, `convertPixelMap2RGBA end`);
      } catch (error) {
        HiLog.i(TAG, `convertPixelMap2RGBA error: ${error}}`);
      } finally {
        callback(pixelMap);
      }
    })
  }

  releaseNapiPixelMap(pixelMap: image.PixelMap): void {
    pixelMap?.release();
  }

  saveNativeWindow(address: number): void {
    this.nativeWindowAddress = address;
  }

  getNativeWindow(): number | undefined {
    return this.nativeWindowAddress;
  }

  public static closeSportFile() {
    if (ImageMediaLibraryProxy.sportFile !== undefined) {
      try {
        HiLog.i(TAG, `closeSportFile fd = ${ImageMediaLibraryProxy.sportFile?.fd}`);
        fs.unlinkSync(ImageMediaLibraryProxy.sportFile?.path);
        fs.closeSync(ImageMediaLibraryProxy.sportFile);
        ImageMediaLibraryProxy.sportFile = undefined;
      } catch (e) {
        HiLog.e(TAG, `closeSportFile error:${e}`);
      }
    }
  }

  createFd(fileName: string, fileNameSuffix: string): string {
    try {
      let context = getContext(this);
      if (context === undefined) {
        HiLog.i(TAG, 'createFd failed, context undefined');
        return '';
      }
      let tmpArea = context.area;
      context.area = contextConstant.AreaMode.EL3;
      let fileSuffix: string = '';
      if (fileNameSuffix !== '') {
        fileSuffix = fileNameSuffix;
      } else {
        let tmp = App.getInstance().myEditor().mediaUri.split('.');
        fileSuffix = tmp[tmp.length - 1].toLowerCase();
      }
      HiLog.i(TAG, 'createFd createNewAssetFile fileName :' + fileName + `, fileNameSuffix :${fileSuffix}`);
      let filePath: string = context.filesDir + `/${fileName}` + '.' + fileSuffix;
      context.area = tmpArea;

      ImageMediaLibraryProxy.closeSportFile();
      ImageMediaLibraryProxy.sportFile = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let result: FileResult = {
        fd: ImageMediaLibraryProxy.sportFile.fd,
        path: ImageMediaLibraryProxy.sportFile.path,
        name: ImageMediaLibraryProxy.sportFile.name,
        fileSuffix: fileSuffix
      };
      let resJson: string = JSON.stringify(result);
      HiLog.i(TAG, `createFd res = ${resJson}`);
      return resJson;
    } catch (e) {
      HiLog.e(TAG, `createFd error ${e}`);
    }
    return '';
  }

  async addResource(type: number, path: string): Promise<void> {
    HiLog.i(TAG, `addResource start, type = ${type}`);
    let phAccessHelper:photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      let uri: string = fileuri.getUriFromPath(path);
      let mediaManager = new MediaSaveManager(App.getInstance().myEditor());
      let asset: photoAccessHelper.PhotoAsset =
        await mediaManager.getEditorAsset(App.getInstance().myEditor().mediaUri);
      let changeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(asset);
      changeRequest.addResource(type as photoAccessHelper.ResourceType, uri);
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      await phAccessHelper.applyChanges(changeRequest);
      HiLog.i(TAG, 'addResource finish');
    } catch (e) {
      HiLog.e(TAG, 'addResource failed: %{public}o', e);
    } finally {
      phAccessHelper?.release();
      ImageMediaLibraryProxy.closeSportFile();
    }
  }

  isParamEnable(key: string): boolean {
    HiLog.i(TAG, ` isParamEnable key = ${key}`);
    let param: string = systemParameter.getSync(key, 'false');
    HiLog.i(TAG, ` isParamEnable value = ${param}`);
    return param === 'true' ? true : false;
  }
}