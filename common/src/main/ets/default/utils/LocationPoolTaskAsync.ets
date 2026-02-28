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

import lazy { image } from '@kit.ImageKit';
import lazy common from '@ohos.app.ability.common';
import lazy { Log } from './Log';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy {
  SendablePhotoAccessHelper,
  SendablePhotoAsset,
  SendablePhotoAlbum,
} from '../access/SendablePhotoAccessHelper';
import lazy { TraceControllerUtils } from './TraceControllerUtils';
import lazy { THUMB_IMG_WIDTH, THUMB_IMG_HEIGHT } from './MapUtil';
import lazy taskpool from '@ohos.taskpool';

// instrument ignore next
@Concurrent
export async function getCoverAssetsTask(coverFileIdList: number[],
  context: common.UIAbilityContext): Promise<SendablePhotoAsset[]> {
  if (!coverFileIdList || !coverFileIdList.length) {
    return [];
  }

  let startTime: number = Date.now();
  let fetchOpt = AlbumDefine.getFileFetchOptByUriList(coverFileIdList);
  let userFileManager: SendablePhotoAccessHelper = new SendablePhotoAccessHelper();
  userFileManager.onCreate(context);
  let assets: SendablePhotoAsset[] = await userFileManager.getAllObject(fetchOpt);
  userFileManager.onDestroy();

  Log.info('LocationPoolTaskAsync', `mapAlbum query coverAssets: ${assets?.length}, cost: ${Date.now() - startTime}ms`);
  return assets;
}

@Concurrent
export async function getPhotoCoverAssetsTask(uri: string,
  context: common.UIAbilityContext): Promise<SendablePhotoAsset> {
  let startTime: number = Date.now();
  let fetchOpt = AlbumDefine.getFileFetchOptByUri(uri);
  let userFileManager: SendablePhotoAccessHelper = new SendablePhotoAccessHelper();
  userFileManager.onCreate(context);
  let assets: SendablePhotoAsset[] = await userFileManager.getAllObject(fetchOpt);
  userFileManager.onDestroy();

  Log.info('LocationPoolTaskAsync', `mapAlbum query coverAssets: ${assets?.length}, cost: ${Date.now() - startTime}ms`);
  return assets[0];
}

// instrument ignore next
@Concurrent
export async function getThumbnailTask(asset?: SendablePhotoAsset): Promise<void> {
  let requestTime: number = Date.now();
  TraceControllerUtils.startTraceWithTaskId('getThumbnail', requestTime);
  let result = await asset?.getThumbnail({ width: THUMB_IMG_WIDTH, height: THUMB_IMG_HEIGHT });
  Log.info('getThumbnailTask', `getThumbnail cost: ${Date.now() - requestTime}ms}`);
  TraceControllerUtils.finishTraceWithTaskId('getThumbnail', requestTime);
  taskpool.Task.sendData(result);
}