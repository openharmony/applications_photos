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

import lazy { QueryParam } from '../../../interface/BrowserDataInterface';
import lazy { AsyncCallback } from '../../common/AsyncCallback';
import lazy { MediaItem } from './MediaItem';
import lazy { PhotoDataImpl } from './PhotoDataImpl';
import lazy taskpool from '@ohos.taskpool';
import lazy { PhotoDataManager, PhotoDataManagerParam, IClassifyFromPhoto } from './PhotoDataManager';
import lazy common from '@ohos.app.ability.common';
import lazy { SendableMediaItem } from './SendableMediaItem';
import lazy { collections } from '@kit.ArkTS';
import lazy { Log } from '../../../utils/Log';
import lazy { TimeLineModelManager } from '../../../view/TimeLineModelManager';
import lazy { ImageUtil } from '../../../../default/utils/ImageUtil'
import lazy { AlbumGridSortHelper } from '../../AlbumGridSortHelper';
import lazy { camera } from '@kit.CameraKit';

/* instrument ignore file */
const TAG: string = 'DataImplAsync';

@Concurrent
function getPrelaunchTask(contxt: common.UIAbilityContext): void {
  camera.getCameraManager(contxt).prelaunch();
}

// taskpool执行的任务
/* instrument ignore next */
@Concurrent
async function getItemsTask(context: common.UIAbilityContext | common.ServiceExtensionContext,
  queryParam: QueryParam, param: PhotoDataManagerParam,
  result: collections.Array<SendableMediaItem>, isThumbnailReady: boolean,
  gridSortUtilInstance: AlbumGridSortHelper): Promise<void> {
  let task = new PhotoDataManager(context, queryParam, param, gridSortUtilInstance);
  try {
    // 直接操作共享实例, FileAsset部分暂不支持共享，这部分通过序列化形式返回，主线程组装。
    await task.getItemsTask(result, isThumbnailReady);
  } catch (err) {
    Log.error('PhotoDataImplAsync', `getItemsTask error: ${err}, code: ${err?.code}`);
  } finally {
    task.onDestroy();
  }
}

export class PhotoDataImplAsync extends PhotoDataImpl {
  protected classifyFromPhoto?: IClassifyFromPhoto;

  constructor(extendTag: string, classifyFromPhoto?: IClassifyFromPhoto) {
    super();
    this.extendTag = extendTag;
    this.classifyFromPhoto = classifyFromPhoto;
  }

  public static async startPrelaunch(context: common.UIAbilityContext): Promise<void> {
    await taskpool.execute(getPrelaunchTask, context);
  }

  public async getDataAsync(queryParam: QueryParam, photoDataMgrParam: PhotoDataManagerParam,
    context: common.UIAbilityContext | common.ServiceExtensionContext): Promise<MediaItem[]> {
    this.info(TAG, 'getDataAsync start');
    let mediaItemList: MediaItem[] = [];
    if (this.isAsyncParamLegal(context, photoDataMgrParam)) {
      let array: collections.Array<SendableMediaItem> = new collections.Array<SendableMediaItem>();
      let isThumbnailReady: boolean = ImageUtil.isThumbnailReady();
      try {
        queryParam.filterConditions = this.applyFilterConditions(queryParam.filterConditions);

        await taskpool.execute(getItemsTask, context, queryParam, photoDataMgrParam, array, isThumbnailReady,
          AlbumGridSortHelper.getInstance());
      } catch (err) {
        Log.error(TAG, `getDataAsync taskpool execute error: ${err}, code: ${err?.code}`);
      }
      this.info(TAG, `taskpool return data size: ${array.length}`);

      // 入参taskpool前后一致性校验，不匹配，返回空
      if (photoDataMgrParam.cameraShotKey !== AppStorage.get<string>('cameraShotKey') ||
        photoDataMgrParam.isOpenYearMonth !==
        AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine()) {
        this.error(TAG, 'taskpool out param is change.');
        return new Promise((resolve): void => {
          resolve(mediaItemList);
        });
      }

      let result = SendableMediaItem.createMediaItems(array);
      return result;
    }
    this.info(TAG, 'getDataAsync context is null');
    return new Promise((resolve): void => {
      resolve(mediaItemList);
    });
  }

  public async queryData(param: QueryParam): Promise<MediaItem[]> {
    return new Promise<MediaItem[]>((resolve) => {
      let callback: AsyncCallback<MediaItem[]> = {
        callback: (items: MediaItem[], albumUri: string) => resolve(items),
      };
      this.getData(callback, param);
    });
  }

  public getDataCount(callback: AsyncCallback<number>, param: QueryParam): void {
    const isClassifyFromPhoto = this.classifyFromPhoto;
    if (isClassifyFromPhoto) {
      if (!callback || !param) {
        this.error(TAG, 'getMediaItem, param or callback is undefined, return!');
        return;
      }
      this.info(TAG,
        `getMediaItemCount: ${JSON.stringify(param)}, isClassifyFromPhoto.count ${isClassifyFromPhoto.count}`);
      callback.callback(isClassifyFromPhoto.count);
    } else {
      super.getDataCount(callback, param);
    }
  }

  getData(callback: AsyncCallback<MediaItem[]> | undefined, param: QueryParam): void {
    this.info(TAG, `getMediaItemAsyc start ${JSON.stringify(param)}, filter: ${this.positionFilter}}`);
    if (!callback) {
      this.error(TAG, 'getMediaItem, param or callback is undefined, return!');
      return;
    }

    type commonContext = common.UIAbilityContext | common.ServiceExtensionContext;
    let context = getContext(this) as commonContext;
    let photoDataMgrParam: PhotoDataManagerParam = new PhotoDataManagerParam;
    photoDataMgrParam.cameraShotKey = AppStorage.get<string>('cameraShotKey') as string;
    const isClassifyFromPhoto = this.classifyFromPhoto;
    this.info(TAG, `isClassifyFromPhoto  ${JSON.stringify(isClassifyFromPhoto)}`);
    if (isClassifyFromPhoto) {
      photoDataMgrParam.isClassifyFromPhoto = isClassifyFromPhoto?.status;
      photoDataMgrParam.classifyFromPhotoKey = isClassifyFromPhoto?.subKey;
      photoDataMgrParam.classifyFromPhotoCount = isClassifyFromPhoto?.count;
    }

    photoDataMgrParam.isOpenYearMonth =
      AppStorage.get<TimeLineModelManager>('TimeLineModelManager')?.isOpenYearMonthTimeLine() as boolean;

    // taskpool支持传递的context是页面的context，第一次getData处于onWindowStageCreate前，无法获取页面context
    if (this.isAsyncParamLegal(context, photoDataMgrParam)) {
      this.getDataAsync(param, photoDataMgrParam, context).then((ret: MediaItem[]) => {
        this.info(TAG, `getDataAsync MediaItem size: ${ret.length},start: ${param.start},end: ${param.count},` +
          `startTime: ${param.startTime}`
        );
        this.info(TAG, 'call callback directly');
        callback.callback(ret, param.albumUri);
      });
    } else {
      this.info(TAG, 'context is null, get sync data');
      super.getData(callback, param);
    }
  }

  private isAsyncParamLegal(context: common.UIAbilityContext | common.ServiceExtensionContext, photoDataMgrParam:
    PhotoDataManagerParam): boolean {
    if (!context) {
      Log.info(TAG, 'isAsyncParamLegal !context');
      return false;
    }
    if (photoDataMgrParam?.cameraShotKey === null || photoDataMgrParam?.cameraShotKey === undefined) {
      Log.info(TAG, 'isAsyncParamLegal !photoDataMgrParam?.cameraShotKey');
      return false;
    }
    return true;
  }
}