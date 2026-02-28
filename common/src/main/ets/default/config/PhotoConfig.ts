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

/* instrument ignore file */
export enum Environment {
  ENV_LIBRARY,
  ENV_COMMON
}

export class PhotoConfig {
  public static environment: Environment = Environment.ENV_COMMON;
  // 是否为畅联拉起大图组件
  public static isFromMeetime: boolean = false;
  public static isSwitchSwiper: boolean = false;
  private static isSupportFastThumbnail: boolean = false;
  public static enableSlideshow: boolean = false;

  public static setIsSupportFastThumbnail(isSupportFastThumbnail: boolean): void {
    PhotoConfig.isSupportFastThumbnail = isSupportFastThumbnail;
  }

  public static getIsSupportFastThumbnail(): boolean {
    if (PhotoConfig.isFromMeetime) {
      return false;
    }
    return PhotoConfig.isSupportFastThumbnail;
  }

  public static setEnvironment(environment: Environment): void {
    PhotoConfig.environment = environment;
  }

  public static setIsFromMeetime(isFromMeetime: boolean): void {
    PhotoConfig.isFromMeetime = isFromMeetime;
  }

  public static isLibrary(): boolean {
    return PhotoConfig.environment === Environment.ENV_LIBRARY;
  }

  public static setIsSwitchSwiper(isSwitchSwiper: boolean): void {
    PhotoConfig.isSwitchSwiper = isSwitchSwiper;
  }
}