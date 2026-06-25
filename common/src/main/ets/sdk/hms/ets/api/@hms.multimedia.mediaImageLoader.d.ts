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

/**
 * @file This module provides the capabilities of media image loading.
 * @kit SystemKit
 */

import type Context from '@ohos.app.ability.common';

/**
 * Provides the capabilities of media image loading.
 *
 * @namespace mediaImageLoader
 * @syscap SystemCapability.Multimedia.ImageLoader.Core
 * @systemapi
 * @StageModelOnly
 * @since 5.0.0(12)
 */
declare namespace mediaImageLoader {
  /**
   * Provides the global configuration capability of media image loading module.
   *
   * @interface Config
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  interface Config {
    /**
     * Global memory cache size in bytes.
     *
     * @type { ?number }
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.0(12)
     */
    memoryCacheSize?: number;
  }

  /**
   * Provides configuration capability for each media image loading request.
   *
   * @interface RequestOptions
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  interface RequestOptions {
    /**
     * Image decoding width.
     *
     * @type { number }
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.0(12)
     */
    width: number;

    /**
     * Image decoding height.
     *
     * @type { number }
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.0(12)
     */
    height: number;
  }

  /**
   * Image loading performance parameters.
   *
   * @enum { number } LoadingPerformanceLevel
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.1(13)
   */
  enum LoadingPerformanceLevel {
    /**
     * Default image loading I/O parameter.
     *
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.1(13)
     */
    DEFAULT = 0,

    /**
     * Improve the I/O performance of image loading, which affects the power consumption.
     *
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.1(13)
     */
    HIGH = 1
  }

  /**
   * Defines the ASTC resource.
   *
   * @interface ASTCResource
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  interface ASTCResource {
    /**
     * Array of ASTC uri resources, indicating the range of ASTC data to be obtained.
     *
     * @type { Array<string> }
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.0(12)
     */
    sources: Array<string>;

    /**
     * Column size, indicating the number of ASTC resources to splice per row.
     *
     * @type { number }
     * @syscap SystemCapability.Multimedia.ImageLoader.Core
     * @systemapi
     * @StageModelOnly
     * @since 5.0.0(12)
     */
    column: number;
  }

  /**
   * Provides the customized global configuration capability of media image loading module.
   *
   * @param { Config } config - Customized configuration.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  function initConfig(config: Config): void;

  /**
   * Provides the capability of caching images for later use.
   *
   * @param { Context } context - Current context.
   * @param { Array<string> } srcURIs - URIs of images to cache.
   * @param { RequestOptions } requestOptions - Options of each image request.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  function startCachingImages(context: Context, srcURIs: Array<string>, requestOptions: RequestOptions): void;

  /**
   * Provides the capability to cancel image caching.
   *
   * @param { Context } context - Current context.
   * @param { Array<string> } srcURIs - URIs of images to cancel caching.
   * @param { RequestOptions } requestOptions - Options of each image request.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  function stopCachingImages(context: Context, srcURIs: Array<string>, requestOptions: RequestOptions): void;

  /**
   * Setting image loading performance parameters.
   *
   * @param { LoadingPerformanceLevel } level - Image loading performance parameter.
   * @param { number } duration - The maximum duration for the loading performance improvement parameter
   * <br>to take effect, the default maximum is 30 seconds.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @concurrentcontextprohibited Mainthread use only
   * @systemapi
   * @StageModelOnly
   * @since 5.0.1(13)
   */
  function setLoadingPerformanceParam(level: LoadingPerformanceLevel, duration?: number): void;

  /**
   * Provides the capability of caching AstcResources for later use.
   *
   * @param { Context } context - Current context.
   * @param { Array<ASTCResource> } astcResources - Array of Astc resources to cache.
   * @param { RequestOptions } requestOptions - Options of each image request.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  function startCachingASTCResources(context: Context, astcResources: Array<ASTCResource>,
    requestOptions: RequestOptions): void;

  /**
   * Provides the capability to cancel AstcResources caching.
   *
   * @param { Context } context - Current context.
   * @param { Array<ASTCResource> } astcResources - Array of Astc resources to cancel caching.
   * @param { RequestOptions } requestOptions - Options of each image request.
   * @throws { BusinessError } 202 - Called by non-system application.
   * @throws { BusinessError } 401 - Invalid input parameter.
   * @syscap SystemCapability.Multimedia.ImageLoader.Core
   * @systemapi
   * @StageModelOnly
   * @since 5.0.0(12)
   */
  function stopCachingASTCResources(context: Context, astcResources: Array<ASTCResource>,
    requestOptions: RequestOptions): void;
}

export default mediaImageLoader;
