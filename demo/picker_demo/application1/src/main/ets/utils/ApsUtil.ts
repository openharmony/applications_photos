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

import lazy apsManager from '@ohos.graphic.apsManager';
import lazy { Log } from '../utils/Log';
import lazy { StringUtil } from '../utils/StringUtil';

/* instrument ignore file */
const TAG: string = 'common_ApsUtil';

const APS_SCENE_GRID_SCROLLBAR_SCROLL: string = 'GALLERY_GRID_SCROLLBAR_SCROLL';

const APS_SCENE_STATE_ON: number = 1;

const APS_SCENE_STATE_OFF: number = 0;

/**
 * APS帧率工具类
 */
export class ApsUtil {
  /**
   * 判断是否支持APS模块
   *
   * @returns true表示支持APS
   */
  public static isSupportAps(): boolean {
    if (apsManager === undefined || apsManager === null) {
      Log.warn(TAG, 'not support aps');
      return false;
    }
    return true;
  }

  /**
   * 设置APS场景状态
   *
   * @param pkgName 所要生效的应用包名
   * @param scene APS场景
   * @param state APS状态
   */
  public static setApsSceneState(pkgName: string, scene: string, state: number): void {
    if (apsManager === undefined || apsManager === null) {
      return;
    }
    if (StringUtil.isEmpty(pkgName) || StringUtil.isEmpty(scene)) {
      return;
    }

    try {
      Log.info(TAG, `start set ${pkgName}'s aps scene:${scene} state to ${state}`);
      apsManager.setScene(pkgName, scene, state);
    } catch (error) {
      Log.warn(TAG, `set ${pkgName}'s aps scene:${scene} state to ${state} failed, error:${error}`);
    }
  }

  /**
   * 使能宫格滚动条拖拽场景帧率控制
   */
  public static enableGridDragScrollApsState(): void {
    ApsUtil.setApsSceneState('com.ohos.photos', APS_SCENE_GRID_SCROLLBAR_SCROLL, APS_SCENE_STATE_ON);
  }

  /**
   * 关闭宫格滚动条拖拽场景帧率控制
   */
  public static disableGridDragScrollApsState(): void {
    ApsUtil.setApsSceneState('com.ohos.photos', APS_SCENE_GRID_SCROLLBAR_SCROLL, APS_SCENE_STATE_OFF);
  }
}