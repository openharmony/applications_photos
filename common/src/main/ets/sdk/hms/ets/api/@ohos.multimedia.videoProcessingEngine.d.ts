/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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
 * @file Provides the capability of image quality processing.
 * @kit ImageKit
 */

import image from './@ohos.multimedia.image';
import { AsyncCallback } from './@ohos.base';

/**
 * This module provides the capability of content processing for images, including image scaling.
 * @namespace videoProcessingEngine
 * @syscap SystemCapability.Multimedia.VideoProcessingEngine
 * @crossplatform
 * @form
 * @since 16
 */
declare namespace videoProcessingEngine {
  /**
   * Levels of processing quality for detail enhancement.
   * @enum {number}
   * @syscap SystemCapability.Multimedia.VideoProcessingEngine
   * @crossplatform
   * @form
   * @since 16
   */
  enum QualityLevel {
    /**
     * No detail enhancement.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    NONE = 0,
    /**
     * A low level of detail enhancement quality but with a fast speed. It's the default level.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    LOW = 1,
    /**
     * A medium level of detail enhancement quality. Its speed is between the low setting and high setting.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    MEDIUM = 2,
    /**
     * A high level of detail enhancement quality but with a relatively slow speed.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    HIGH = 3
  }

  /**
   * Provides the ImageProcessor type, including the processing function.
   * @typedef ImageProcessor
   * @syscap SystemCapability.Multimedia.VideoProcessingEngine
   * @crossplatform
   * @form
   * @since 16
   */
  interface ImageProcessor {
    /**
     * The function generate the destinationImage from sourceImage with necessary scaling operation
     * <br>according to width and height. Different levels of scaling methonds are provided to
     * <br>balance performance and image quality. This method uses a promise to return the result.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } width - The zoom value of width.
     * @param { number } height - The zoom value of height.
     * @param { QualityLevel } [level] - The quality level.
     * @returns { Promise<image.PixelMap> } A Promise instance used to return the PixelMap object.
     * @throws { BusinessError } 801 - Capability not supported. Function enhanceDetail can not work correctly due to
     * <br>limited device capabilities.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    enhanceDetail(sourceImage: image.PixelMap, width: number, height: number, level?: QualityLevel): Promise<image.PixelMap>;

    /**
     * The function generate the destinationImage from sourceImage with necessary scaling operation
     * <br>according to width and height. Different levels of scaling methonds are provided to
     * <br>balance performance and image quality.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } width - The zoom value of width.
     * @param { number } height - The zoom value of height.
     * @param { QualityLevel } [level] - The quality level.
     * @returns { image.PixelMap } Returns the destination pixelmap instance .
     * <br>if the operation is successful; Otherwise, return undefined.
     * @throws { BusinessError } 801 - Capability not supported. Function enhanceDetailSync can not work correctly due
     * <br>to limited device capabilities.
     * @throws { BusinessError } 29200004 - Failed to process image buffer. For example, the processing times out.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    enhanceDetailSync(sourceImage: image.PixelMap, width: number, height: number, level?: QualityLevel): image.PixelMap;

    /**
     * The function generate the destinationImage from sourceImage with necessary scaling operation
     * <br>according to the zoom ratio. Different levels of scaling methonds are provided to
     * <br>balance performance and image quality. This method uses a promise to return the result.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } scale - The zoom ratio.
     * @param { QualityLevel } [level] - The quality level.
     * @returns { Promise<image.PixelMap> } A Promise instance used to return the PixelMap object.
     * @throws { BusinessError } 801 - Capability not supported. Function enhanceDetail can not work correctly due to
     * <br>limited device capabilities.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    enhanceDetail(sourceImage: image.PixelMap, scale: number, level?: QualityLevel): Promise<image.PixelMap>;

    /**
     * The function generate the destinationImage from sourceImage with necessary scaling operation
     * <br>according to the zoom ratio. Different levels of scaling methonds are provided to
     * <br>balance performance and image quality.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } scale - The zoom ratio.
     * @param { QualityLevel } [level] - The quality level.
     * @returns { image.PixelMap } Returns the destination pixelmap instance
     * <br>if the operation is successful; Otherwise, return undefined.
     * @throws { BusinessError } 801 - Capability not supported. Function enhanceDetailSync can not work correctly due
     * <br>to limited device capabilities.
     * @throws { BusinessError } 29200004 - Failed to process image buffer. For example, the processing times out.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    enhanceDetailSync(sourceImage: image.PixelMap, scale: number, level?: QualityLevel): image.PixelMap;
      /**
     * The The function change the metadata of source image to enhance contrastness.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } pixelMapId - id of pixelMap.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * <br>if the operation is successful; Otherwise, return undefined.
     * @throws { BusinessError } 29200001 - The processing is not supported.
     * @throws { BusinessError } 29200004 - Failed to process image buffer. For example, the processing times out.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    setLcdImage(sourceImage: image.PixelMap, pixelMapId : number, defaultRatio : number): Promise<void>;
      /**
     * The function change the metadata of source image to enhance contrastness.
     * @param { image.PixelMap } sourceImage - The source pixelmap.
     * @param { number } pixelMapId - id of pixelMap.
     * @param { image.Region } pixelmapArea - region of block in pixelmap.
     * @param { image.Region } displayArea - region of display area in pixelmap.
     * @returns { Promise<void> } A Promise instance used to return the operation result.
     * <br>if the operation is successful; Otherwise, return undefined.
     * @throws { BusinessError } 29200001 - The processing is not supported.
     * @throws { BusinessError } 29200004 - Failed to process image buffer. For example, the processing times out.
     * @throws { BusinessError } 29200007 - Out of memory.
     * @throws { BusinessError } 29200009 - Input value is invalid. This error is returned for
     * <br>all of the following error conditions:
     * <br>1 - Invalid input or output image buffer - The image buffer width(height)
     * <br>is too large or colorspace is incorrect.
     * <br>2 - Invalid parameter - The parameter does not contain valid information,
     * <br>such as detail enhancer level is incorrect.
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 16
     */
    setDetailImage(srcTmp : image.PixelMap, pixelMapId : number, pixelmapArea : image.Region, displayArea : image.Region, oriResolution : image.Size, 
    genFinalEffect : boolean, maxRatio : number, duration : number, curRatio:number): Promise<void>;
	
    /**
     * This function register the callback function which can notify the processing completed status.
     * @param { AsyncCallback<PixelMap> } callback - Callback used to return the processing completed status. 1: Processing completed, 2: Invalid
     * @syscap SystemCapability.Multimedia.VideoProcessingEngine
     * @crossplatform
     * @form
     * @since 14
     */
    registerCallback(callback: AsyncCallback<number>): void;
  }

  /**
   * Initialize global environment for image processing.
   * @returns { Promise<void> } A Promise instance used to return the operation result.
   * If the operation fails, an error message is returned.
   * @throws { BusinessError } 801 - Capability not supported. Function initializeEnvironment can not work correctly
   * <br>due to limited device capabilities.
   * @throws { BusinessError } 29200002 - The global environment initialization for image processing failed,
   * <br>such as failure to initialize the GPU environment.
   * @throws { BusinessError } 29200006 - The operation is not permitted. This may be caused by incorrect status.
   * @throws { BusinessError } 29200007 - Out of memory.
   * @syscap SystemCapability.Multimedia.VideoProcessingEngine
   * @crossplatform
   * @form
   * @since 16
   */
  function initializeEnvironment(): Promise<void>;
  /**
   * Deinitialize global environment for image processing.
   * @returns { Promise<void> } A Promise instance used to return the operation result.
   * If the operation fails, an error message is returned.
   * @throws { BusinessError } 29200006 - The operation is not permitted. This may be caused by incorrect status.
   * @syscap SystemCapability.Multimedia.VideoProcessingEngine
   * @crossplatform
   * @form
   * @since 16
   */
  function deinitializeEnvironment(): Promise<void>;
  /**
   * Create an image processing instance.
   * @returns { ImageProcessor } Returns the ImageProcessor instance if
   * <br>the operation is successful; returns null otherwise.
   * @throws { BusinessError } 801 - Capability not supported. Function create can not work correctly due to limited
   * <br>device capabilities.
   * @throws { BusinessError } 29200003 - Failed to create image processing instance. For example,
   * <br>the number of instances exceeds the upper limit.
   * @throws { BusinessError } 29200007 - Out of memory.
   * @syscap SystemCapability.Multimedia.VideoProcessingEngine
   * @crossplatform
   * @form
   * @since 16
   */
  function create(): ImageProcessor;
}

export default videoProcessingEngine;
