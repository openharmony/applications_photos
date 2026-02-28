/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
 * @file A component which support applications to show moving photo data
 * @kit MediaLibraryKit
 */

import photoAccessHelper from './@ohos.file.photoAccessHelper';
import media from './@ohos.multimedia.media'

/**
 * Enumerates pixel map formats.
 *
 * @enum { number }
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @systemapi
 * @since 14
 */
export declare enum PixelMapFormat {
  /**
   * Indicates an unknown format.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  UNKNOWN = 0,
  /**
   * Indicates that each pixel is stored on 32 bits. Each pixel contains 4 components：B(8bits), G(8bits), R(8bits), A(8bits)
   * and are stored from the higher-order to the lower-order bits.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  RGBA_8888 = 1,
  /**
   * Indicates that the storage order is to store Y first and then V U alternately each occupies 8 bits
   * and are stored from the higher-order to the lower-order bits.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  NV21 = 2,
  /**
   * Indicates that each pixel is stored on 32 bits. Each pixel contains 4 components：
   * R(10bits), G(10bits), B(10bits), A(2bits) and are stored from the higher-order to the lower-order bits.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 14
   */
  RGBA_1010102 = 3,

  /**
   * Indicates that the storage order is to store Y first and then U V alternately each occupies 10 bits
   * and are stored from the higher-order to the lower-order bits.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 14
   */
  YCBCR_P010 = 4,

  /**
   * Indicates that the storage order is to store Y first and then V U alternately each occupies 10 bits
   * and are stored from the higher-order to the lower-order bits.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @since 14
   */
  YCRCB_P010 = 5
}
/**
 * Dynamic range mode of moving photo.
 *
 * @enum { number }
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @systemapi
 * @since 14
 */
export declare enum DynamicRangeMode {
  /**
   * Allow image content to use an unrestricted extended range
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  HIGH = 0,
  /**
   * Allow image content to use some extended range
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  CONSTRAINT = 1,
  /**
   * Restrict the image content to dynamic range to the standard range
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  STANDARD = 2,
}
/**
 * Defines the moving photo view options.
 *
 * @interface MovingPhotoViewOptions
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare interface MovingPhotoViewOptions {
  /**
   * moving photo data.
   *
   * @type { photoAccessHelper.MovingPhoto }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  movingPhoto: photoAccessHelper.MovingPhoto;
  /**
   * controller of MovingPhotoView.
   *
   * @type { ?MovingPhotoViewController }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  controller?: MovingPhotoViewController;
  /**
   * image ai options of MovingPhotoView.
   *
   * @type { ?ImageAIOptions }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 18
   */
  imageAIOptions?: ImageAIOptions;
  /**
   * format of MovingPhotoView.
   *
   * @type { ?PixelMapFormat }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  movingPhotoFormat?: PixelMapFormat;
  /**
   * range mode of MovingPhotoView.
   *
   * @type { ?DynamicRangeMode }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 14
   */
  dynamicRangeMode?: DynamicRangeMode;
  /**
   * the watermask of the cover photo whether to contain during movingphoto playback
   *
   * @type { ?boolean }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 19
   */
  playWithMask?: boolean;
}
/**
 * Defines the moving photo view interface.
 *
 * @interface MovingPhotoViewInterface
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
interface MovingPhotoViewInterface {
  /**
   * Set the options.
   *
   * @param { MovingPhotoViewOptions } options
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  (options: MovingPhotoViewOptions): MovingPhotoViewAttribute;
}

/**
 * function that moving photo view media events callback.
 *
 * @typedef { function } MovingPhotoViewEventCallback
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare type MovingPhotoViewEventCallback = () => void;

/**
 * Defines the moving photo view attribute functions.
 *
 * @extends CommonMethod<MovingPhotoViewAttribute>
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare class MovingPhotoViewAttribute extends CommonMethod<MovingPhotoViewAttribute> {
  /**
   * Called when judging whether the video is muted.
   *
   * @param { boolean } isMuted
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  muted(isMuted: boolean): MovingPhotoViewAttribute;
  /**
   * Called when determining the zoom type of the view.
   *
   * @param { ImageFit } value
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  objectFit(value: ImageFit): MovingPhotoViewAttribute;
  /**
   * Called when the image load completed.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 13
   */
  onComplete(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when the video is played.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  onStart(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when the video playback stopped.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  onStop(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when the video playback paused.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  onPause(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when the video playback ends.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  onFinish(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when playback fails.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  onError(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Called when playback prepared.
   *
   * @param { MovingPhotoViewEventCallback } callback
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  onPrepared(callback: MovingPhotoViewEventCallback): MovingPhotoViewAttribute;
  /**
   * Sets automatic play period, If not set, the moving photo plays in the full video duration.
   * If set, the moving photo plays in the automatic play period.
   *
   * @param { number } startTime video plays start time
   * @param { number } endTime   video plays end time
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 13
   */
  autoPlayPeriod(startTime: number, endTime: number): MovingPhotoViewAttribute;
  /**
   * Sets whether to allow automatic play. If the value is true, the moving photo starts
   * automatic after the resource is loaded.
   *
   * @param { boolean } isAutoPlay  Whether to automatic play
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 13
   */
  autoPlay(isAutoPlay: boolean): MovingPhotoViewAttribute;
  /**
   * Sets whether to allow repeat play. If the value is true, the moving photo plays
   * repeat after the resource is loaded.
   *
   * @param { boolean } isRepeatPlay  Whether to repeat play
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 13
   */
  repeatPlay(isRepeatPlay: boolean): MovingPhotoViewAttribute;

  /**
   * Sets whether to enable moving photo analyzer. If the value is true, the moving photo can
   * be analyzed by AI.
   *
   * @param { boolean } enabled - whether to enable moving photo analyzer
   * @returns { MovingPhotoViewAttribute }
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 18
   */
  enableAnalyzer(enabled: boolean): MovingPhotoViewAttribute;

  /**
   * Sets playback strategy.
   *
   * @param { media.PlaybackStrategy } strategy - playback strategy
   * @returns { MovingPhotoViewAttribute }
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  setPlaybackStrategy(strategy: media.PlaybackStrategy): MovingPhotoViewAttribute;
}
/**
 * Defines the MovingPhotoView controller.
 *
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
export class MovingPhotoViewController {
  /**
   * constructor.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  constructor();
  /**
   * Start play moving photo.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  startPlayback();
  /**
   * Stop play moving photo.
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  stopPlayback();
  /**
   * refresh moving photo data
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @crossplatform
   * @atomicservice
   * @since 18
   */
  refreshMovingPhoto();
  /**
   * pause moving photo and show current frame, start playing from the current frame when
   * playing again
   *
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  pause();
  /**
   * reset moving photo playback options as default
   *
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  reset();
  /**
   * restart to play the video with current options
   *
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  restart();
  /**
   * Enable or disable the zoom transition effect and can be set during initialization
   *
   * @param { boolean } enabled - whether to enable the transition effect
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  enableTransition(enabled: boolean);
  /**
   * Set moving photo playback period.
   *
   * @param { double } startTime - video playback start time
   * @param { double } endTime   - video playback end time
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  setPlaybackPeriod(startTime: double, endTime: double);
  /**
   * Dynamically refresh the autoplay property, which will force to play after
   * moving photo is initialized
   *
   * @param { boolean } enabled - Whether to auto play
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @crossplatform
   * @atomicservice
   * @since 20
   * @arkts 1.1&1.2
   */
  enableAutoPlay(enabled: boolean);

  /**
   * Notify the component to execute the picture transition animation.
   *
   * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs.
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 20
   * @arkts 1.1&1.2
   */
  notifyMovingPhotoTransition();
}
/**
 * Defines MovingPhotoView Component.
 *
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @uicomponent
 * @since 12
 */
declare const MovingPhotoView: MovingPhotoViewInterface;
/**
 * Defines MovingPhotoView Component instance.
 *
 * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
 * @crossplatform
 * @atomicservice
 * @since 12
 */
declare const MovingPhotoViewInstance: MovingPhotoViewAttribute;
