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

import type { BusinessError } from '@ohos.base';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { fileIo as fs } from '@kit.CoreFileKit'
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { common, UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { MediaItemUtil } from '@ohos/common/src/main/ets/default/utils/MediaItemUtil';
import lazy { prompt } from '@kit.ArkUI';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

const TAG: string = 'SavePhotosManager';

export class SavePhotosManager {
  public static readonly SAVE_AS_PHOTOS: number = 0;
  public static readonly SAVE_AS_VIDEOS: number = 1;
  public static readonly SAVE_AS_PHOTOS_AND_VIDEOS: number = 2;
  public static readonly SAVE_PER_PHOTO_DELAY: number = 15;
  public static readonly SAVE_PER_VIDEO_DELAY: number = 30;

  public async saveReplacedPhotoAssets(replaceUrisMap: Map<MediaItem, MediaItem>, callback: Function,
    configs?: Array<photoAccessHelper.PhotoCreationConfig>, saveMode?: number, params?: SelectParams,
    appName?: string): Promise<void> {
    Log.info(TAG, `saveReplacedPhotoAssets enter saveMode: ${saveMode}`);
    if (saveMode !== undefined && saveMode === 1) {
      this.savePhotoAssetsOverride(replaceUrisMap, callback, saveMode);
    } else {
      this.savePhotoAssetsAsNew(replaceUrisMap, callback, configs, saveMode, params, appName);
    }
  }

  private async savePhotoAssetsAsNew(replaceUrisMap: Map<MediaItem, MediaItem>, callback: Function,
    configs?: Array<photoAccessHelper.PhotoCreationConfig>, saveMode?: number, params?: SelectParams,
    appName?: string): Promise<void> {
    try {
      const error: BusinessError = { code: 0, message: 'save success', name: 'BusinessError' };
      if (replaceUrisMap === undefined || replaceUrisMap.size === 0) {
        callback({ code: 14000002, message: 'Invalid URI', name: 'BusinessError' });
        return;
      }
      let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [];
      if (configs === undefined || configs === null) {
        this.initPhotoCreationConfigs(replaceUrisMap, photoCreationConfigs);
      } else {
        configs.forEach(config => {
          photoCreationConfigs.push(config);
        });
      }
      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext());
      let desFileUris: string[] = await phAccessHelper.createAssetsForApp(
        params?.bundleName,
        appName,
        params?.tokenId,
        photoCreationConfigs
      );

      let savePhotosCount = 0;
      let saveVideosCount = 0;
      let replaceUris: string[] = [];
      // instrument ignore next
      replaceUrisMap.forEach((mediaItem, oriMediaItem) => {
        replaceUris.push(mediaItem.uri);
        if (oriMediaItem.mediaType === photoAccessHelper.PhotoType.VIDEO) {
          saveVideosCount++;
        } else {
          savePhotosCount++;
        }
      });

      let successDesFileUris: string[] = this.writeMediaAssetsToGallery(replaceUris, desFileUris, error);
      let toastMode: number = this.getToastMode(savePhotosCount, saveVideosCount);
      let delayTime: number = SavePhotosManager.SAVE_PER_PHOTO_DELAY * savePhotosCount +
        SavePhotosManager.SAVE_PER_VIDEO_DELAY * saveVideosCount;
      callback(error, successDesFileUris, saveMode, toastMode, delayTime);
      Log.info(TAG, 'Photo savePhotoAssetsAsNew success.');
    } catch (err) {
      Log.error(TAG, `Photo savePhotoAssetsAsNew failed with error: ${err.code}, ${err.message}`);
      callback(err);
    }
  }

  private getToastMode(savePhotosCount: number, saveVideosCount: number) {
    if (savePhotosCount > 0 && saveVideosCount > 0) {
      return SavePhotosManager.SAVE_AS_PHOTOS_AND_VIDEOS;
    } else if (savePhotosCount > 0) {
      return SavePhotosManager.SAVE_AS_PHOTOS;
    } else if (saveVideosCount > 0) {
      return SavePhotosManager.SAVE_AS_VIDEOS;
    }
    return 0;
  }

  private writeMediaAssetsToGallery(replaceUris: Array<string>, desFileUris: Array<string>,
    error: BusinessError<void>): Array<string> {
    let successDesFileUris: string[] = [];
    try {
      for (let i = 0; i < replaceUris.length; i++) {
        let file = fs.openSync(replaceUris[i], fs.OpenMode.READ_ONLY);
        let file2 = fs.openSync(desFileUris[i], fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        fs.copyFileSync(file.fd, file2.fd);
        successDesFileUris.push(desFileUris[i]);
        fs.closeSync(file);
        fs.closeSync(file2);
      }
    } catch (err) {
      console.log(JSON.stringify(err));
      error.code = err.code;
      error.message = err.message;
    }
    return successDesFileUris;
  }

  private initPhotoCreationConfigs(replaceUrisMap: Map<MediaItem, MediaItem>,
    photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[]) {
    replaceUrisMap.forEach(async (mediaItem, oriMediaItem) => {
      Log.info(TAG,
        `pll - savePhotoAssetsAsNew displayName:${oriMediaItem.displayName}, photoType:${oriMediaItem.mediaType}, uri:${oriMediaItem.uri}`);
      let photoTitle: string = oriMediaItem.getTitle();
      let extension: string = oriMediaItem.displayName.split('.')[1];
      let photoType = oriMediaItem.mediaType;
      Log.info(TAG,
        `pll - savePhotoAssetsAsNew photoTitle:${photoTitle}, extension:${extension}, photoAsset.photoType:${photoType}`);
      let photoCreationConfig: photoAccessHelper.PhotoCreationConfig = {
        title: photoTitle,
        fileNameExtension: extension,
        photoType: photoType,
        subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
      };
      photoCreationConfigs.push(photoCreationConfig);
    });
  }

  private async savePhotoAssetsOverride(replaceUrisMap: Map<MediaItem, MediaItem>,
    callback: Function, saveMode?: number): Promise<void> {
    try {
      const error: BusinessError = {
        code: 0,
        message: 'save success',
        name: 'BusinessError',
      };
      let successDesFileUris: string[] = [];
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext());
      let savePhotosCount = 0;
      let saveVideosCount = 0;
      for (let it of replaceUrisMap.entries()) {
        let oriMediaItem = it[0];
        let mediaItem = it[1];
        let photoAsset = oriMediaItem.data;
        if (!photoAsset) {
          error.code = 14000002;
          error.message = 'Invalid URI';
        } else {
          let type = photoAccessHelper.ResourceType.IMAGE_RESOURCE;
          if (photoAsset.photoType === photoAccessHelper.PhotoType.IMAGE) {
            type = photoAccessHelper.ResourceType.IMAGE_RESOURCE;
            savePhotosCount++;
          } else {
            type = photoAccessHelper.ResourceType.VIDEO_RESOURCE;
            saveVideosCount++;
          }
          let changeRequest: photoAccessHelper.MediaAssetChangeRequest =
            new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
          changeRequest.addResource(type, mediaItem.uri);
          await phAccessHelper.applyChanges(changeRequest);
          successDesFileUris.push(oriMediaItem.uri);
        }
      }
      let toastMode: number = this.getToastMode(savePhotosCount, saveVideosCount);
      let delayTime: number = SavePhotosManager.SAVE_PER_PHOTO_DELAY * savePhotosCount +
        SavePhotosManager.SAVE_PER_VIDEO_DELAY * saveVideosCount;
      callback(error, successDesFileUris, saveMode, toastMode, delayTime);
      Log.info(TAG, 'Photo savePhotoAssetsOverride success.');
    } catch (err) {
      Log.error(TAG, `Photo savePhotoAssetsOverride failed with error: ${err.code}, ${err.message}`);
      callback(err);
    }
  }

  public handleSavePhotos(data: Record<string, Object>, replaceUriManager: ReplaceUriManager | undefined) {
    let context: common.UIAbilityContext | undefined =
      LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    if (context === undefined) {
      return;
    }
    let replaceUris = data['replaceUris'] as Array<string>;
    let configs: photoAccessHelper.PhotoCreationConfig[] = data['config'] as photoAccessHelper.PhotoCreationConfig[];
    let date = data['date'] as number;
    if (configs && configs.length !== replaceUris.length) {
      this.sendData(undefined, date, 401, 'Incorrect parameter types');
      return;
    }
    let saveMode = data['saveMode'] as number;
    let appName: string = data['appName'] as string;

    let realReplaceUrisMap: Map<MediaItem, MediaItem> = new Map();
    let finalConfigs: photoAccessHelper.PhotoCreationConfig[] | undefined = undefined;
    if (configs) {
      finalConfigs = [];
    }
    for (let i = 0; i < replaceUris.length; i++) {
      let replaceUri: string = replaceUris[i];
      let uri: string = MediaItemUtil.getSaveFileName(replaceUri, context?.filesDir);
      if (!replaceUriManager?.hasReplaceUri(uri)) {
        continue;
      }
      finalConfigs?.push(configs[i]);
      let mediaItems: MediaItem[] = replaceUriManager?.getReplaceOriAndReplaceMediaItem(uri);
      if (mediaItems.length !== 0 && !this.isExist(realReplaceUrisMap, mediaItems[1])) {
        realReplaceUrisMap.set(mediaItems[0], mediaItems[1]);
        replaceUriManager?.deleteByUri(uri);
      }
    }
    let params = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)
    this.saveReplacedPhotoAssets(realReplaceUrisMap, async (err: BusinessError, successDesFileUris: string[],
      saveMode: number, toastMode: number, delayTime: number) => {
      let tokenId = params?.tokenId;
      if (err.code === 0 && tokenId) {
        PickerUtil.addPermissionUsedWrite(tokenId);
      }
      // instrument ignore if
      let count = successDesFileUris.length;
      if (err.code === 0 && count > 0) {
        this.showToast(saveMode, toastMode, appName);
      }
      Log.info(TAG, 'handleSavePhotos successDesFileUris.length = ' + count);
      setTimeout(() => {
        this.sendData(successDesFileUris, date, err.code, err.message);
      }, delayTime);
    }, finalConfigs, saveMode, params, appName);
  }

  private sendData(successDesFileUris: Array<string> | undefined, date: number, code: number, message: string) {
    let session: UIExtensionContentSession | undefined =
      LocalStorage.getShared()?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    session?.sendData({
      'dataType': 'saveCallback',
      'data': successDesFileUris,
      'date': date,
      'code': code,
      'message': message
    })
  }

  private isExist(realReplaceUrisMap: Map<MediaItem, MediaItem>, item: MediaItem): boolean {
    for (let val of realReplaceUrisMap.values()) {
      if (val.uri == item.uri) {
        return true;
      }
    }
    return false;
  }

  public async showToast(saveMode: number, toastMode: number, appName: string) {
    let toastMsg: string = '';
    if (saveMode === 1) {
      if (toastMode === SavePhotosManager.SAVE_AS_VIDEOS) {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.edit_gallery_video'), appName);
      } else if (toastMode === SavePhotosManager.SAVE_AS_PHOTOS_AND_VIDEOS) {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.edit_gallery_photo_and_video'), appName);
      } else {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.edit_gallery_photo'), appName);
      }
    } else {
      if (toastMode === SavePhotosManager.SAVE_AS_VIDEOS) {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.app_save_as_new_video'), appName);
      } else if (toastMode === SavePhotosManager.SAVE_AS_PHOTOS_AND_VIDEOS) {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.save_as_new_photo_and_video'), appName);
      } else {
        toastMsg = await UiUtil.getResourceStringMessage($r('app.string.app_save_as_new_photo'), appName);
      }
    }
    Log.info(TAG, `saveReplacedPhotoAssets showToast toastMsg: ${toastMsg}`);
    prompt.showToast({
      message: toastMsg,
      duration: UiUtil.TOAST_DURATION,
      bottom: UiUtil.TOAST_BOTTOM,
    });
  }
}