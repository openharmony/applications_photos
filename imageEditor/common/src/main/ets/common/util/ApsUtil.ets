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

import { HiLog } from './HiLog';

export const APS_SCENE_STATE_ON: number = 1;
export const APS_SCENE_STATE_OFF: number = 0;
export const PHOTO_IN_EDIT_CROP: string = 'PHOTO_IN_EDIT_CROP';
export const PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';

const TAG: string = 'Editor_ApsUtil';

/**
 * APS帧率工具类
 */
export class ApsUtil {
  /**
   * 设置APS场景状态
   *
   * @param pkgName 所要生效的应用包名
   * @param scene APS场景
   * @param state APS状态
   */
  public static setApsSceneState(pkgName: string, scene: string, state: number): void {
    HiLog.i(TAG, `setApsSceneState: ${pkgName},${scene}`);
    if (!pkgName || !scene) {
      return;
    }
    try {
      HiLog.i(TAG, `start set ${pkgName}'s aps scene:${scene} state to ${state}`);
      // apsManager.setScene(pkgName, scene, state);
    } catch (error) {
      HiLog.w(TAG, `set ${pkgName}'s aps scene:${scene} state to ${state} failed, error:${error}`);
    }
  }
}