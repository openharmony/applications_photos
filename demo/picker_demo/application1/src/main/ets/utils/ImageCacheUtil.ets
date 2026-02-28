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

import lazy { Constants } from '../model/common/Constants';
import lazy mediaImageLoader from '@ohos.multimedia.mediaImageLoader';
import lazy { Log } from '../utils/Log';

const TAG: string = 'common_ImageCacheUtil';

// Decode size of the gird image.
const REQUEST_OPTIONS: mediaImageLoader.RequestOptions = {
  width: Constants.GRID_IMAGE_SIZE,
  height: Constants.GRID_IMAGE_SIZE,
};

/**
 * Image cache util.
 */
export class ImageCacheUtil {
  /**
   * Init cache size.
   *
   * @param cacheSize Cache size.
   */
  public static initCacheSize(cacheSize: number): void {
    try {
      let config: mediaImageLoader.Config = {
        memoryCacheSize: cacheSize,
      };
      mediaImageLoader.initConfig(config);
    } catch (error) {
      Log.warn(TAG, `initConfig failed, error.code:${error.code}, error.message:${error.message}`);
    }
  }

  /**
   * Batch preloading.
   *
   * @param uriArr URI array to be preloaded.
   */
  public static startCachingImages(uriArr: Array<string>): void {
    if (uriArr == null || uriArr.length == 0) {
      return;
    }

    try {
      mediaImageLoader.startCachingImages(getContext(), uriArr, REQUEST_OPTIONS);
    } catch (error) {
      Log.warn(TAG, `startCachingImages failed, error.code:${error.code}, error.message:${error.message}`);
    }
  }

  /**
   * Batch canceling preload.
   *
   * @param uriArr URI array to cancel preload.
   */
  public static stopCachingImages(uriArr: Array<string>): void {
    if (uriArr == null || uriArr.length == 0) {
      return;
    }

    try {
      mediaImageLoader.stopCachingImages(getContext(), uriArr, REQUEST_OPTIONS);
    } catch (error) {
      Log.warn(TAG, `stopCachingImages failed, error.code:${error.code}, error.message:${error.message}`);
    }
  }
}