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
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';
import lazy { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { Log } from '../../../utils/Log';
import lazy { AlbumDefine } from '../AlbumDefine';
import lazy { SendableMediaItem } from './SendableMediaItem';
import lazy { collections } from '@kit.ArkTS';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { common } from '@kit.AbilityKit';
import lazy { SendablePhotoAccessHelper, SendablePhotoAlbum } from '../../../access/SendablePhotoAccessHelper';
import type { SendablePhotoAsset } from '../../../access/SendablePhotoAccessHelper';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import type { FetchOptions } from '../../../access/UserFileManagerAccess';

const TAG: string = 'CleanupDataManager';

/**
 * Description.
 *
 * @since 2025-04-01
 */
export class CleanupDataManager {
  private context: common.Context;
  private queryParam: QueryParam;
  private userFileManager: SendablePhotoAccessHelper;
  private fromPage: string;
  private imageOrderByName: string = photoAccessHelper.PhotoKeys.DATE_TAKEN_MS;

  public constructor(context: common.Context, queryParam: QueryParam, fromPage: string, imageOrderByName: string) {
    this.context = context;
    this.queryParam = queryParam;
    this.fromPage = fromPage;
    this.imageOrderByName = imageOrderByName;
    this.userFileManager = new SendablePhotoAccessHelper();
    this.userFileManager.onCreate(this.context);
  }

  // photo
  public async getItemsTask(result: collections.Array<SendableMediaItem>): Promise<void> {
    let dataList = await this.getItems(this.queryParam) as SendablePhotoAsset[];
    if (dataList) {
      Log.info(TAG, `addItemIntoArray begin, dataList.length: ${dataList.length}`);
      let index: number = 0;
      for (let item of dataList) {
        if (!item?.uri) {
          Log.warn(TAG, `photoAsset's uri:${item?.uri} is invalid, start:${this.queryParam?.start}, index:${index}`);
          continue;
        }
        try {
          this.addItemIntoArray(item, result);
        } catch (err) {
          Log.error(TAG, `getMediaItem error: ${err}, code: ${err?.code}`);
        }
        index++;
      }
      dataList.splice(0, dataList.length);
    }
    Log.info(TAG,
      `mediaItemList size: ${result.length}, start:${this.queryParam.start},` + `count: ${this.queryParam.count}`);
  }

  public async getItems(queryParam: QueryParam): Promise<SendablePhotoAsset[]> {
    Log.info(TAG, 'getItems start!');
    let result: SendablePhotoAsset[] = [];
    if (queryParam.albumUri) {
      let startTime: number = Date.now();
      TraceControllerUtils.startTrace('CleanupDataGetItems');
      let album: SendablePhotoAlbum | undefined = await this.userFileManager.getAlbumByUri(queryParam.albumUri);
      let fetchOpt: FetchOptions;
      if (album) {
        fetchOpt = this.getFetchOpt(queryParam);
        Log.info(TAG, `getItems album fetchOpt ${JSON.stringify(fetchOpt)}, album : ${JSON.stringify(album)}`);
        let fetchResult: sendablePhotoAccessHelper.FetchResult<SendablePhotoAsset> | undefined = undefined;
        try {
          fetchResult = await album.getAssets(fetchOpt);
          if (fetchResult.getCount() <= 0) {
            return [];
          }
          result = await fetchResult.getAllObjects();
        } catch (err) {
          Log.error(TAG, `getItems error: ${err}, code: ${err?.code}`);
        } finally {
          fetchResult?.close();
          Log.info(TAG, `fetchResult is close.`);
        }
      }
      TraceControllerUtils.finishTrace('CleanupDataGetItems');
      Log.info(TAG, 'getItems cost: ' + (Date.now() - startTime));
    }
    Log.info(TAG, `getItems result : ${result.length},start: ${queryParam?.start},end: ${queryParam?.count}`);
    return result;
  }

  public addItemIntoArray(item: SendablePhotoAsset, mediaItemList: collections.Array<SendableMediaItem>): void {
    // let mediaItem: SendableMediaItem = new SendableMediaItem(item);
    // mediaItem.setThumbnail(ImageUtil.getThumbnailUri(mediaItem.uri, mediaItem.path, mediaItem.dateModified,
    //   true, mediaItem?.thumbnailReady));
    // mediaItemList.push(mediaItem);
    // return;
  }

  public getFetchOpt(query: QueryParam): photoAccessHelper.FetchOptions {
    const startIndex: number | undefined = query?.start;
    const count: number | undefined = query?.count;
    const needThumbnailReady: boolean | undefined = query?.needThumbnailReady;
    return AlbumDefine.getFileFetchOptWithCleanupPage(this.fromPage, startIndex, count, needThumbnailReady,
      this.imageOrderByName);
  }

  public onDestroy(): void {
    this.userFileManager.onDestroy();
  }
}