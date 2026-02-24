/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
 * @kit ImageKit
 */

import image from './@ohos.multimedia.image';

declare namespace detailEnhancer {
  /**
   * Image zoom out width and height. This method uses a promise to return the result.
   *
   * @param { number } x The zoom value of width.
   * @param { number } y The zoom value of height.
   * @param { image.PixelMap } input pixelmap.
   * @returns { image.PixelMap } Returns the instance if the operation is successful;Otherwise, return undefined.
   * @syscap SystemCapability.Multimedia.Image.Core
   * @crossplatform
   * @form
   * @atomicservice
   * @since 12
   */
  function process(x: number, y: number, input: image.PixelMap): image.PixelMap;

  /**
   * Init detail enhancer
   *
   * @returns { boolean } Returns the true if the operation is successful;Otherwise, return false.
   * @syscap SystemCapability.Multimedia.Image.Core
   * @crossplatform
   * @form
   * @atomicservice
   * @since 12
   */
  function init(): boolean;

  /**
   * Init detail enhancer
   *
   * @returns { boolean } Returns the true if the operation is successful;Otherwise, return false.
   * @syscap SystemCapability.Multimedia.Image.Core
   * @crossplatform
   * @form
   * @atomicservice
   * @since 12
   */
  function destroy(): boolean;
}

export default detailEnhancer;