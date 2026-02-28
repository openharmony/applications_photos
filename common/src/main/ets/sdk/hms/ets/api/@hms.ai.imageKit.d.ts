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
import type { AsyncCallback } from '@ohos.base';
import type image from '@ohos.multimedia.image';

/**
 * This module is used for intelligent image analyze including text detect and recognition, entity anlyze and image segmentation
 * The returned result can be used for UI interaction.
 * @namespace imageKit
 * @syscap SystemCapability.Ai.ImageKit
 * @systemapi
 * @since 10
 */
declare namespace imageKit {

  /**
   * Visual configuration information, including related content such as pictures or video frame to be recognized.
   * @interface VisionInfo
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface VisionInfo {
    /**
     * Image information to be identified.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly pixelMap: image.PixelMap;
  }

  /**
   * Indicates the position of the pixel point
   * @interface PixelPoint
   * @systemapi
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface PixelPoint {
    /**
     * Horizontal coordinates of pixel point.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly x: number;

    /**
     * The vertical coordinate of the pixel point
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly y: number;
  }

  /**
   * ImageSegmentation configuration information, including related content such as pictures or video frame to be recognized, PixelPoint and flag to interact.
   * @interface VisionInfo
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface ImageSegmentationInfo {
    /**
     * Image information to be identified.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly pixelMap: image.PixelMap;

    /**
     * The specifc PixelPoint selected to interact
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly segPoint: PixelPoint;

    /**
     * The Optional cache for fast image processing.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly cache?: Int32Array,

    /**
     * Whether only singleSalientSubject(on segPoint) needed
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly singleSalientSubject?: boolean;

    /**
     * Whether face info needed
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly enableFaceDetect?: boolean;

  }

  /**
   * RawImageInfo, including related content such as pictures or video frame to be segmented.
   * @interface VisionInfo
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface RawImageInfo {
    /**
     * Image information to be identified.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly pixelMap: image.PixelMap;

    /**
     * The mask of the subjects for image segmentation.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly maskList: Array<Int32Array>,
  }

  /**
   * Indicates the position of the BoundingBox
   * @interface BoundingBox
   * @systemapi
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface BoundingBox {
    /**
     * The min horizontal coordinate of BoundingBox.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly xMin: number;

    /**
     * The min vertical coordinate of BoundingBox.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly yMin: number;

    /*
     * The max horizontal coordinate of BoundingBox.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly xMax: number;

    /**
     * The max vertical coordinate of BoundingBox.
     * @syscap SystemCapability.Ai.ImageKit
     * @systemapi
     * @since 4.1.0(11)
     */
    readonly yMax: number;
  }

  /**
   * Indicates the result of ImageSegmentation ability
   * @interface ImageSegmentationResult
   * @systemapi
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface FaceDetectResult {
    readonly resultCode: number;

    /**
     * @default Indicates the face rects in the raw image
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly faceDesc: string;
  }

  /**
   * Indicates the result of ImageSegmentation ability
   * @interface ImageSegmentationResult
   * @systemapi
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface ImageSegmentationResult {
    /**
     * @default Indicates the width of the image
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.ImageKit
     */
    readonly width: number;

    /**
     * @default Indicates the height of the image
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly height: number;

    /**
     * @default Indicates the maskList
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly maskList: Array<Int32Array>;

    /**
     * @default Indicates the contourList
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    // readonly contourList: Array<Array<PixelPoint>>;
    readonly contourList: Array<Int32Array>;

    /**
     * @default Indicates the salientBox
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly salientBox: BoundingBox;

    /**
     * @default Indicates the salient subject photo based on salientBox box size
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly salientSubject: image.PixelMap;

    /**
     * @default Indicates the maskResult
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly maskResult: Int32Array;

  }

  /**
   * Indicates the pixel map of every single salient subject based on original input photo size
   * @interface SalientSubjectPhoto
   * @systemapi
   * @syscap SystemCapability.Ai.ImageKit
   * @since 4.1.0(11)
   */
  export interface SalientSubjectPhoto {
    /**
     * @default Indicates the all salient subject photo
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly salientSubjectPhoto: Array<image.PixelMap>;

    /**
     * @default Indicates the all salient subject bounding box
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly salientSubjectBox: Array<BoundingBox>;

  }

  export interface ImageAnalyzerResult {
    /**
     * @default Indicates the all salient subject photo
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly imageSegmentationResult: ImageSegmentationResult;

    /**
     * @default Indicates the all salient subject bounding box
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly faceDetectResult: FaceDetectResult;

  }

  export interface RawSubject {
    /**
     * @default Indicates the all salient subject photo
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly subjectPixelMap: image.PixelMap;

    /**
     * @default Indicates the all salient subject bounding box
     * @systemapi
     * @since 4.1.0(11)
     * @syscap SystemCapability.Ai.AiEngine
     */
    readonly subjectBoundingBox: BoundingBox;
  }

  /**
   * Segment salient in an image based on provided ImageSegmentationInfo.
   * @param imageSegmentationInfo - The ImageSegmentationInfo object, including the image to be processed, PixelPoint and flag to interact.
   * @param segmentationCallback - callback function, will be invoked with error object as first parameter and ImageSegmentationResult as second.
   * @param subjectCallback - Optional callback function, will be invoked with error object as first parameter and SalientSubjectPhoto as second.
   */
  function imageSegment(imageSegmentationInfo: ImageSegmentationInfo,
    segmentationCallback: AsyncCallback<ImageAnalyzerResult>,
    subjectCallback?: AsyncCallback<SalientSubjectPhoto>): void;

  /**
   * Segment salient in an image based on provided ImageSegmentationInfo.
   * @param imageSegmentationInfo - The ImageSegmentationInfo object, including the image to be processed, maskList and flag to interact.
   * @param segmentationCallback - callback function, will be invoked with error object as first parameter and ObtainSubjectResult as second.
   */
  function getRawSubject(rawImageInfo: RawImageInfo): Promise<RawSubject>;

  /**
   * Detect text in an image based on provided VisionInfo.
   * @param visionInfo - The VisionInfo object, including the image to be processed.
   * @param callback - Optional callback function, will be invoked with error object as first parameter and detected text as second.
   * @returns If callback is not provided, returns Promise object which when resolved, returns detected text.
   */
  function textDetect(visionInfo: VisionInfo, callback: AsyncCallback<string>): void;

  /**
   * Async version of textDetect. Returns detected text as Promise.
   * @param visionInfo - The VisionInfo object, including the image to be processed.
   * @returns Promise object which when resolved, returns detected text.
   */
  function textDetect(visionInfo: VisionInfo): Promise<string>;

  /**
   * Recognize text in an image based on provided VisionInfo and detected lines.
   * @param visionInfo - The VisionInfo object, including the image to be processed.
   * @param LinesH - Detected text lines to be recognized.
   * @param configuration - Optional Configuration object for text recognition.
   * @param callback - Optional callback function, will be invoked with error object as first parameter and recognized text as second.
   */
  function textRecognize(visionInfo: VisionInfo, LinesH: string, configuration?: textRecognitiion.Configuration,
    callback: AsyncCallback<string>): void;

  /**
   * Async version of textRecognize. Returns recognized text as Promise.
   * @param visionInfo - The VisionInfo object, including the image to be processed.
   * @param LinesH - Detected text lines to be recognized.
   * @param configuration - Optional Configuration object for text recognition.
   * @returns Promise object which when resolved, returns recognized text.
   */
  function textRecognize(visionInfo: VisionInfo, LinesH: string,
    configuration?: textRecognitiion.Configuration): Promise<string>;

  /**
   * Analyze the entities in a given text document.
   * @param Text - The text document to be analyzed.
   * @param callback - Callback function will be invoked with error object as first parameter and entity analysis result as second.
   */
  function entityAnalyze(Text: string, callback: AsyncCallback<String>): void;

  /**
   * Analyze the entities in a given text document.
   * @param Text - The text document to be analyzed.
   * @param entityModule - Optional entity module to analyze. Default is "default".
   * @param callback - Callback function will be invoked with error object as first parameter and entity analysis result as second.
   */
  function entityAnalyze(Text: string, entityModule: string, callback: AsyncCallback<String>): void;

  /**
   * Async version of entityAnalyze. Returns entity analysis result as Promise.
   * @param Text - The text document to be analyzed.
   * @param entityModule - Optional entity module to analyze. Default is "default".
   * @returns Promise object which when resolved, returns entity analysis result.
   */
  function entityAnalyze(Text: string, entityModule?: string): Promise<string>;


}

export default imageKit;