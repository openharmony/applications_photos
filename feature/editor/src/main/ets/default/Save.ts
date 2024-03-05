/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import {
  BigDataConstants,
  BrowserDataFactory,
  Log,
  MediaItem,
  ReportToBigDataUtil,
  UserFileManagerAccess
} from '@ohos/common';
import { ImageFilterStack } from './ImageFilterStack';
import image from '@ohos.multimedia.image';
import fileIO from '@ohos.fileio';
import { DateUtil } from './utils/DateUtil';
import { Loader } from './Loader';
import userFileManager from '@ohos.filemanagement.userFileManager';
import type { Album, FileType } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';

const TAG: string = 'editor_Save';

export class Save {
  private static readonly QUALITY_95: number = 95;
  private static readonly PERCENT_100: number = 100;

  constructor() {
  }

  public static async save(item: MediaItem, albumUri: string, optStack: ImageFilterStack, isReplace: Boolean,
                           callback: Function): Promise<void> {
    Log.info(TAG, `${JSON.stringify(item)} ${isReplace}`);

    // Get quality of image first, making sure it's succeed even in replace mode
    let finalQuality: number = await this.getImageQuality(item);
    Log.debug(TAG, "save: final quality = " + finalQuality);
    let options = {
      format: 'image/jpeg',
      quality: finalQuality
    };

    try {
      let wrapper = await Loader.loadPixelMapWrapper(item);
      wrapper = optStack.apply(wrapper);
      Log.debug(TAG, 'Edit and restore operation execution end.');

      let fileAsset = await this.createFileAsset(item.uri, albumUri, isReplace);
      Log.info(TAG, `create fileAsset succeed: [${fileAsset}]`);
      let fd = await UserFileManagerAccess.getInstance().openAsset('RW', fileAsset);
      if (fd < 0) {
        Log.error(TAG, 'open asset failed.');
        return;
      }

      let packer = image.createImagePacker();
      let buffer = await packer.packing(wrapper.pixelMap, options);
      Log.info(TAG, 'Format pixelMap data to jpg data end.');

      await fileIO.write(fd, buffer);
      Log.info(TAG, 'write jpg file end.');
      try {
        let imageSourceApi: image.ImageSource = image.createImageSource(fd);
        await new Promise(async (resolve, reject) => {
          imageSourceApi.modifyImageProperty('CompressedBitsPerPixel', String(finalQuality / Save.PERCENT_100));
          resolve(Boolean(true));
        });
      } catch (e) {
        Log.error(TAG, 'sth wrong when set CompressedBitsPerPixel value is ' + (finalQuality / Save.PERCENT_100) +
          ', error is ' + JSON.stringify(e));
      }
      let newUri = fileAsset.uri;
      Log.info(TAG, `New saved file: ${newUri}`);
      callback && callback(newUri);
      await UserFileManagerAccess.getInstance().closeAsset(fd, fileAsset);
      wrapper && wrapper.release();
      await packer.release();

    } catch (e) {
      Log.error(TAG, `save catch error: ${JSON.stringify(e)}`);
      let msg = {
        'CatchError': JSON.stringify(e)
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.PHOTO_EDIT_SAVE_ERROR_ID, msg);
      callback && callback(undefined);
    }
  }

  private static async createFileAsset(uri: string, albumUri: string,  isReplace: Boolean) {
    let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);
    let fileAsset = await dataImpl.getDataByUri(uri);
    let batchUris: Array<string> = new Array();
    batchUris.push(uri)
    if (!fileAsset) {
      Log.error(TAG, 'get file error');
      return null;
    }
    let title = DateUtil.nameByDate(isReplace, fileAsset.displayName);
    if (null == title) {
      Log.error(TAG, `create picture name failed.`);
      return null;
    }
    let displayName = title + '.jpg';
    Log.debug(TAG, `file displayname = ${displayName}`);
    let favorite: boolean = false;
    if (isReplace) {
      favorite = Boolean(await fileAsset.get(userFileManager.ImageVideoKey.FAVORITE.toString()));
      await UserFileManagerAccess.getInstance().deleteToTrash(batchUris);
      Log.debug(TAG, `trash picture file uri ${uri} end.`);
    }
    fileAsset = await UserFileManagerAccess.getInstance().createAsset(fileAsset.mediaType, displayName);
    await fileAsset.favorite(favorite);
    let album: Album = await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri);
    let isSystemAlbum = UserFileManagerAccess.getInstance().isSystemAlbum(album);
    if (!isSystemAlbum) {
      await UserFileManagerAccess.getInstance().addFileToAlbum(albumUri, fileAsset);
    }
    return fileAsset;
  }

  private static async getImageQuality(item: MediaItem): Promise<number> {
    let quality = undefined;
    try {
      quality = await Loader.getCompressedBitsPerPixel(item);
    } catch (e) {
      Log.error(TAG, "sth wrong with getCompressedBitsPerPixel" + e);
    }
    let finalQuality: number = quality !== undefined ? quality * Save.PERCENT_100 : Save.QUALITY_95
    Log.debug(TAG, "save: final quality = " + finalQuality);
    return finalQuality;
  }
}