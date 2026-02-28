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

import lazy { FifoCache } from '../browser/photo/FifoCache';
import type { Thumbnail } from '../browser/photo/Thumbnail';
import lazy { Log } from '../../utils/Log';
import type image from '@ohos.multimedia.image';
import type { PhotoAsset } from '../../access/PhotoAccessHelperAccess';
import lazy { PhotoAccessHelperAccess } from '../../access/PhotoAccessHelperAccess';
import type { Context } from '@ohos.abilityAccessCtrl';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { SendablePhotoAsset } from './../../access/SendablePhotoAccessHelper';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { getThumbnailTask } from './../../utils/LocationPoolTaskAsync';
import lazy { AsyncCallback } from './AsyncCallback';

/* instrument ignore file */
const TAG: string = 'common_PixelMapManager';

export class PixelMapManager {
  private fifoMap: FifoCache<Thumbnail>;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.fifoMap = new FifoCache<Thumbnail>(5);
  }

  public static getInstance(): PixelMapManager {
    if (!PixelMapManager.instance) {
      PixelMapManager.instance = new PixelMapManager();
    }
    return PixelMapManager.instance;
  }

  public static instance: PixelMapManager | undefined = undefined;

  public getFifoCache(): FifoCache<Thumbnail> {
    return this.fifoMap;
  }

  public release(): void {
    this.fifoMap.releaseAll();
  }

  /**
   * 根据uri获取图片缩略图PixelMap
   *
   * @param ctx 上下文
   * @param uri 图片uri
   * @param size 图片size
   * @returns 缩略图图片
   */
  public static async getThumbnailByUri(ctx: Context, uri: string, size?: image.Size):
    Promise<image.PixelMap | undefined> {
    if (!ctx) {
      Log.error(TAG, 'context null');
      return undefined;
    }
    try {
      let asset: PhotoAsset | undefined = await PhotoAccessHelperAccess.getPhotoByUri(ctx, uri);
      if (!asset) {
        Log.error(TAG, 'getThumbnailByUri no asset found: ' + `${uri}` + `, ${ctx}`);
        return undefined;
      }
      let pixelMap: image.PixelMap | undefined = await asset?.getThumbnail(size);
      if (!pixelMap) {
        Log.error(TAG, 'getThumbnailByUri no pixelMap: ' + `${uri}`  + `, ${ctx}`);
      }
      Log.info(TAG, `getThumbnailByUri success, uri: ${uri}`);
      return pixelMap;
    } catch (err) {
      Log.error(TAG, `getThumbnailByUri failed with err: ${err}`);
    }
    return undefined;
  }

  public static async getThumbnailByAsset(photoAsset: PhotoAsset): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      const width = Number(photoAsset?.get(photoAccessHelper.PhotoKeys.WIDTH));
      const height = Number(photoAsset?.get(photoAccessHelper.PhotoKeys.HEIGHT));
      let size: image.Size = {
        width: width,
        height: height,
      };
      if (!photoAsset) {
        Log.error(TAG, 'getThumbnailByAsset no asset found: ');
        return pixelMap;
      }
      pixelMap = await photoAsset?.getThumbnail(size);
      if (!pixelMap) {
        Log.error(TAG, 'getThumbnailByAsset no pixelMap: ');
      }
      Log.info(TAG, 'getThumbnailByAsset success ');
      return pixelMap;
    } catch (err) {
      Log.error(TAG, `getThumbnailByAsset failed with err: ${err}`);
    }
    return pixelMap;
  }

  public static async getThumbnailByAssetWithoutSize(callback: AsyncCallback,
    photoAsset?: SendablePhotoAsset): Promise<void> {
    if (!photoAsset) {
      Log.error(TAG, 'getThumbnailByAsset no asset found: ');
      return;
    }
    try {
      let task: taskpool.Task = new taskpool.Task(getThumbnailTask, photoAsset);
      task.onReceiveData(callback.callback);
      await taskpool.execute(task);
    } catch (err) {
      Log.error(TAG, `getThumbnailByAsset failed with err: ${err}`);
    }
  }
}
