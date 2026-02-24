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

import lazy { StringUtil } from './StringUtil';
import lazy systemParameter from '@ohos.systemparameter';
import lazy { Log } from './Log';
import lazy { systemParameterEnhance } from '@kit.BasicServicesKit';


const TAG = 'FeatureSwitchUtil';

/**
 * 人像开关
 */
const PORTRAIT_ENABLE: string = 'const.sys.photos.portrait.album.enable';
/**
 * 相册拖拽排序开关
 */
const ALBUM_DRAG_ENABLE: string = 'const.sys.photos.album.drag.enable';
const SWITCH_STATE_ON: string = 'on';

/**
 * 主角星球开关
 */
const PORTRAIT_PROTAGONIST_PLANET: string = 'const.photo.protagonist_planet.enable';

export class FeatureSwitchUtil {
  private static isSupportProtagonist?: boolean;

  /* instrument ignore next */
  private constructor() {
  }

  /**
   * 是否开启人像功能
   * @returns true:开启  false:关闭
   */
  /* instrument ignore next */
  public static portraitFeatureEnable(): boolean {
    let param: string = systemParameter.getSync(PORTRAIT_ENABLE, '');
    let flag = (StringUtil.size(param) === 0 ? true : false) || param === SWITCH_STATE_ON;
    return flag;
  }

  /**
   * 是否开启相册页拖拽排序功能
   * @returns true:开启  false:关闭
   */
  /* instrument ignore next */
  public static albumDragEnable(): boolean {
    let param: string = systemParameter.getSync(ALBUM_DRAG_ENABLE, '');
    let flag = StringUtil.size(param) !== 0 && param === SWITCH_STATE_ON;
    Log.info(TAG, `is start album page drag order: ${flag}`);
    return flag;
  }

  /**
   * 是否支持主角星球功能
   * @returns true:开启  false:关闭
   */
  public static protagonistPlanetEnable(): boolean {
    return false;
  }
}