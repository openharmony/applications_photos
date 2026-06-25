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

export enum ModeType {
  /**
   * Default
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  DEFAULT = 'Default',

  /**
   * Loop play
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  LOOP = 'LoopVideo',

  /**
   * Cinema graph
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 13
   */
  CINEMA_GRAPH = 'CinemaGraph',

  /**
   * Long exposure
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  LONG_EXPOSURE = 'LongExpo',

  /**
   * Multi exposure
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  MULTIPLE_EXPOSURE = 'MultiExpo',

  /**
   * Bounce play
   *
   * @syscap SystemCapability.FileManagement.PhotoAccessHelper.Core
   * @systemapi
   * @since 12
   */
  BOUNCE_PLAY = 'BouncePlay',

  // 关闭动态
  CLOSE = 'Close',
}
