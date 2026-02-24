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

import lazy { Log } from './Log';
import lazy { DeviceInfo } from './DeviceInfo';
import type { MediaItem } from '../model/browser/photo/MediaItem';
import type { SelectManager } from '../model/browser/SelectManager';
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import lazy pasteboard from '@ohos.pasteboard';
import lazy { UiUtil } from './UiUtil';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import lazy { ProcessMenuOperation } from '../view/browserOperation/ProcessMenuOperation';
import lazy { UserFileManagerAccess, PhotoAsset } from '../access/UserFileManagerAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { checkIsVideo, checkIsImage } from './FileDisplayType';
/* instrument ignore file */
const TAG: string = 'common_PasteboardUtil';

export class PasteboardUtil {
  /**
   * Maximum number of copy count
   */
  private static readonly MAX_COPY_COUNT = 500;

  /**
   * Copy mediaItem to pasteboard
   *
   * @param currentPhoto mediaItem reference
   */
  static copyMediaItemToPasteboard(currentPhoto: MediaItem): void {
    // instrument ignore if
    if (!currentPhoto) {
      Log.warn(TAG, 'currentPhoto is undefined.');
      return;
    }
    Log.info(TAG, 'photoUri to pasteboard: ' + currentPhoto.uri);
    let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_URI, currentPhoto.uri);
    let systemPasteboard = pasteboard.getSystemPasteboard();
    let property: pasteboard.PasteDataProperty = pasteData.getProperty();
    property.shareOption = pasteboard.ShareOption.LOCALDEVICE;
    pasteData.setProperty(property);
    systemPasteboard.setData(pasteData);
    Log.info(TAG, 'copy success');
    let msg = {
      count: 1
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_COPY_PASTEBOARD, msg);
    // instrument ignore else
    if (!DeviceInfo.isPc()) {
      UiUtil.showToastShorter($r('app.string.copy_success'));
    }
  }

  /**
   * Copy mediaList to pasteboard with selectManager
   *
   * @param selectManager
   */
  static copyMediaListToPasteboardWithSelectManager(selectManager: SelectManager): void {
    let selectedCount = selectManager.getSelectedCount();
    let msg = {
      count: selectedCount
    };
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_COPY_PASTEBOARD, msg);
    if (selectedCount > PasteboardUtil.MAX_COPY_COUNT) {
      UiUtil.showToastShorter($r('app.string.number_of_copied_exceeds_the_limit_tips'), PasteboardUtil.MAX_COPY_COUNT);
      Log.error(TAG, 'The number of images to be copied exceeds the upper limit');
      return;
    }
    // instrument ignore if
    if (selectedCount === 0) {
      Log.error(TAG, 'no photos selected');
      return;
    }
    selectManager.getSelectedItems((selectedItems: Array<MediaItem>) => {
      PasteboardUtil.copyMediaListToPasteboard(selectedItems);
    });
  }

  /**
   * Copy mediaList to pasteboard
   *
   * @param mediaItems selectedItems reference
   */
  private static copyMediaListToPasteboard(mediaItems: Array<MediaItem>): void {
    // instrument ignore if
    if (mediaItems.length === 0) {
      Log.error(TAG, 'no photos selected');
      return;
    }
    Log.info(TAG, `Get selected items success, size: ${mediaItems.length}, start copy to clipboard`);
    try {
      let pasteData: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_URI, mediaItems[0].uri);
      let systemPasteboard = pasteboard.getSystemPasteboard();
      for (let index = 1; index < mediaItems.length; index++) {
        const element = mediaItems[index];
        pasteData.addRecord(pasteboard.MIMETYPE_TEXT_URI, element.uri);
      }
      let property: pasteboard.PasteDataProperty = pasteData.getProperty();
      property.shareOption = pasteboard.ShareOption.LOCALDEVICE;
      pasteData.setProperty(property);
      systemPasteboard.setData(pasteData);
      Log.info(TAG, 'copy success');
      // instrument ignore else
      if (!DeviceInfo.isPc()) {
        UiUtil.showToastShorter($r('app.string.copy_success'));
      }
    } catch (err) {
      Log.error(TAG, `copy error ${err}, code: ${err?.code}`);
    }
  }

  public static async pasteToPhoto(albumInfo?: AlbumInfo): Promise<PhotoAsset[]> {
    const systemPasteboard = pasteboard.getSystemPasteboard();
    let dataSource: string = systemPasteboard.getDataSource();
    Log.info(TAG, `pasteToPhoto dataSource: ${JSON.stringify(dataSource)}`);

    const pasteboardData: PasteboardDataModel = await PasteboardUtil.getUriFromPasteboard();
    if ((!pasteboardData) || !pasteboardData.fileUriList.length) {
      Log.warn(TAG, 'paste fail, pasteboardData or fileUriList is null');
      return [];
    }
    Log.debug(TAG, `pasteDataTag: ${pasteboardData.tag}`);
    let promiseList: Array<Promise<PhotoAsset>> =
      pasteboardData.fileUriList
        .map((uri: string): Promise<PhotoAsset> => PasteboardUtil.pasteSingle(uri, albumInfo));

    let res = await Promise.all(promiseList).catch((arr: Array<PhotoAsset | undefined>): Array<PhotoAsset> => {
      Log.warn(TAG, 'pasteToPhoto fail');
      return arr.filter((item: PhotoAsset | undefined): boolean => {
        return item !== undefined;
      });
    });
    return res;
  }

  private static async pasteSingle(sourceUri: string, albumInfo?: AlbumInfo): Promise<PhotoAsset> {
      return new Promise(async (res, rej): Promise<PhotoAsset> => {
        let photoAsset: PhotoAsset;
        if (sourceUri.indexOf(UserFileManagerAccess.REGISTER_TYPE_ALL_PHOTOS) > -1) {
          photoAsset = await PasteboardUtil.addToAlbum(sourceUri, albumInfo);
          if (photoAsset) {
            res(photoAsset);
          } else {
            rej(photoAsset);
          }
          return;
        }
        let destUri: string;
        let phAccessHelper: photoAccessHelper.PhotoAccessHelper = null;
        try {
          phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
          // 需要确保sourceUri对应的资源存在
          let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest;
          if (checkIsImage(sourceUri)) {
            Log.info(TAG, 'createImageAssetRequest');
            assetChangeRequest =
              photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(getContext(this), sourceUri);
          } else if (checkIsVideo(sourceUri)) {
            Log.info(TAG, 'createVideoAssetRequest');
            assetChangeRequest =
              photoAccessHelper.MediaAssetChangeRequest.createVideoAssetRequest(getContext(this), sourceUri);
          } else {
            res(photoAsset);
            return;
          }
          await phAccessHelper.applyChanges(assetChangeRequest);
          destUri = assetChangeRequest.getAsset().uri;
          Log.info(TAG, `apply createImageAssetRequest successfully destUri: ${destUri}`);
          photoAsset = await PasteboardUtil.addToAlbum(destUri, albumInfo);
          res(photoAsset);
        } catch (err) {
          if (err.code === 401) {
            Log.error(TAG, 'create*AssetRequest err , if parameter is invalid');
          } else if (err.code === 13900002) {
            Log.error(TAG, `create*AssetRequest err , No such file : ${sourceUri}`);
          } else if (err.code === 14000011) {
            Log.error(TAG, 'create*AssetRequest err , System inner fail');
          } else {
            Log.error(TAG, `pasteSingle err , ${JSON.stringify(err)}`);
          }
          rej(photoAsset);
        } finally {
          phAccessHelper?.release();
        }
      });
  }

  public static mediaItemList: string[] = [];

  public static async addMediaListToAlbum(albumInfo: AlbumInfo): Promise<PhotoAsset[]> {
    Log.info(TAG, `addMediaListToAlbum len:${PasteboardUtil.mediaItemList.length}`);
    let promiseList: Promise<PhotoAsset>[] =
      PasteboardUtil.mediaItemList.map((mediaItemUrl: string): Promise<PhotoAsset> => {
      return new Promise(async (res, rej): Promise<void> => {
          let ans: PhotoAsset | undefined = await PasteboardUtil.addToAlbum(mediaItemUrl, albumInfo);
          if (ans) {
            res(ans);
          } else {
            rej(ans);
          }
      });
    });

    let res: PhotoAsset[] = await Promise.all(promiseList)
      .catch((arr: Array<PhotoAsset | undefined>): Array<PhotoAsset> => {
        Log.warn(TAG, 'addMediaListToAlbum fail');
        return arr.filter((item: PhotoAsset | undefined): boolean => {
          return item !== undefined;
        });
      });

    return res;
  }

  private static async addToAlbum(uri: string, albumInfo?: AlbumInfo): Promise<PhotoAsset | undefined> {
    ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_START, null);
    let photoAsset = await ProcessMenuOperation.getFileAddOrMoveInfo(uri);
    Log.info(TAG, `photoAsset uri: ${photoAsset?.uri} albumInfo: ${albumInfo?.toString()}`);
    if (albumInfo?.uri) {
      await UserFileManagerAccess.getInstance().addFilesToAlbum(albumInfo.uri, [photoAsset]);
    }
    ReportToBigDataUtil.report(BigDataConstants.COPY_FILE_OPERATION_FINISH, null);
    return photoAsset;
  }

  /**
   * 获取剪切板里文件uri数据
   */
  public static async getUriFromPasteboard(): Promise<PasteboardDataModel> {
    let pasteboardData: PasteboardDataModel = new PasteboardDataModel();
    let index: number = 0;
    let uriList: string[] = [];
    let property: pasteboard.PasteDataProperty;
    try {
      let systemPasteboard = pasteboard.getSystemPasteboard();
      const hasUriData = PasteboardUtil.checkUriData();
      if (!hasUriData) {
        Log.warn(TAG, 'systemPasteboard has no uri data');
        return pasteboardData;
      }
      const pasteData: pasteboard.PasteData = systemPasteboard.getDataSync();
      property = pasteData.getProperty();
      const uriCount: number = pasteData.getRecordCount();
      Log.info(TAG, `property：${JSON.stringify(property)} uriCount：${uriCount}`);
      while (index < uriCount) {
        const pasteDataRecord: pasteboard.PasteDataRecord = pasteData.getRecord(index);
        Log.info(TAG, `pasteDataRecord: ${JSON.stringify(pasteDataRecord)} index:${index}`);
        if (pasteDataRecord.uri) {
          uriList.push(pasteDataRecord.uri);
        }
        index++;
      }
      if (uriList.length) {
        pasteboardData = {
          fileUriList: uriList,
          timestamp: property.timestamp,
          source: '',
          tag: property.tag || ''
        };
      }
    } catch (err) {
      if (err.code === 12900005) {
        Log.error(TAG, `systemPasteboard.getDataSync Request time out`);
      } else if (err.code === 12900001) {
        Log.error(TAG, `pasteData.getRecord : The index is out of the record. `);
        if (uriList.length) {
          pasteboardData = {
            fileUriList: uriList,
            timestamp: property?.timestamp,
            source: '',
            tag: property?.tag || ''
          };
        }
      } else {
        Log.info(TAG, `getUriFromPasteboard err ${JSON.stringify(err)}`);
      }
    }
    return pasteboardData;
  }

  /**
   * 检查剪切板上是否有uri数据
   * returns 是否有uri数据
   */
  public static checkUriData(): boolean {
    let result: boolean = false;
    try {
      let systemPasteboard = pasteboard.getSystemPasteboard();
      result = systemPasteboard.hasDataType(pasteboard.MIMETYPE_TEXT_URI);
    } catch (error) {
      if (error.code === 401) {
        Log.error(TAG, `systemPasteboard.hasDataType Type ${pasteboard.MIMETYPE_TEXT_URI} is not string.`);
      } else if (error.code === 12900005) {
        Log.error(TAG, `systemPasteboard.hasDataType Request time out.`);
      } else {
        Log.error(TAG, `getSystemPasteboard fail, error: ${JSON.stringify(error)}`);
      }
      result = false;
    }
    Log.info(TAG, `checkUriData result: ${result}`);
    return result;
  }
}

/**
 * 文件删除还原操作需要使用的数据模型
 */
class PasteboardDataModel {
  /**
   * 剪切板上文件的uri数组
   */
  fileUriList: string[] = [];

  /**
   *  剪切板上数据的时间戳
   */
  timestamp: number = -1;

  /**
   * 剪切板上数据的来源
   */
  source: string = '';

  /**
   * 剪切板上数据的标签，PC文管用于标记剪切还是复制
   */
  tag: string = '';
}