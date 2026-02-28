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

import lazy { settings, systemParameter } from '@kit.BasicServicesKit';
import lazy { Log } from './Log';

const TAG: string = 'AiEditorCommonUtil';
const AI_REMOVE_ENABLE: string = 'const.photo.ai_remove.enable';
const AI_MOVE_ENABLE: string = 'const.photo.ai_move.enable';
const AI_TRANDITIONAL_REMOVE_ENABLE: string = 'const.photo.ai_tranditional_remove.enable';
const AI_EXPAND_ENABLE: string = 'const.photo.ai_expand.enable';
const AI_REFINE_ENABLE: string = 'const.photos.ai_refine.enable';
const AI_REFINE_HDR_ENABLE: string = 'const.photos.ai_refine.hdr.enable';
const AI_BACKGROUND_ENABLE: string = 'const.photo.ai_background.enable';
const AI_REPLACE_EMO_ENABLE: string = 'const.photo.ai_replace_emo.enable';
const AI_REFLECT_ENABLE: string = 'const.photo.ai_remove_reflect.enable';
const AI_LIGHT_ENABLE: string = 'const.photo.ai_close_light.enable';
const AI_EDITOR_MODEL_ENABLE: string = 'true';

export class AiEditorCommonUtil {
  public static isAiRemoveEnabled(): boolean {
    return systemParameter.getSync(AI_REMOVE_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiMoveEnabled(): boolean {
    return systemParameter.getSync(AI_MOVE_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiTraditionalRemoveEnabled(): boolean {
    return systemParameter.getSync(AI_TRANDITIONAL_REMOVE_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiExpandEnabled(): boolean {
    return systemParameter.getSync(AI_EXPAND_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiBackgroundEnabled(): boolean {
    return systemParameter.getSync(AI_BACKGROUND_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiReplaceEmoEnabled(): boolean {
    return systemParameter.getSync(AI_REPLACE_EMO_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiRefineMasterEnabled(): boolean {
    return systemParameter.getSync(AI_REFINE_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiRefineHdrEnabled(): boolean {
    return systemParameter.getSync(AI_REFINE_HDR_ENABLE, 'true') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiRemoveReflectEnabled(): boolean {
    return systemParameter.getSync(AI_REFLECT_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiLightEnabled(): boolean {
    return systemParameter.getSync(AI_LIGHT_ENABLE, 'false') === AI_EDITOR_MODEL_ENABLE;
  }

  public static isAiEditorEnabled(): boolean {
    const isAiRemoveEnabled: boolean = AiEditorCommonUtil.isAiRemoveEnabled();
    const isAiExpandEnabled: boolean = AiEditorCommonUtil.isAiExpandEnabled();
    const isAiBackgroundEnabled: boolean = AiEditorCommonUtil.isAiBackgroundEnabled();
    const isAiReplaceEmoEnabled: boolean = AiEditorCommonUtil.isAiReplaceEmoEnabled();
    const isAiRefineMasterEnabled: boolean = AiEditorCommonUtil.isAiRefineMasterEnabled();
    const isAiRemoveReflectEnabled: boolean = AiEditorCommonUtil.isAiRemoveReflectEnabled();
    const isAiTranditionalRemoveEnabled: boolean = AiEditorCommonUtil.isAiTraditionalRemoveEnabled();
    Log.info(TAG,
      `current  isAiRemoveEnabled: ${
      isAiRemoveEnabled}, isAiExpandEnabled: ${
      isAiExpandEnabled}, isAiBackgroundEnabled: ${isAiBackgroundEnabled}, isAiTranditionalRemoveEnabled: ${
      isAiTranditionalRemoveEnabled}, isAiRefineMasterEnabled:${isAiRefineMasterEnabled},
       isAiReplaceEmoEnable:${isAiReplaceEmoEnabled}, isAiRemoveReflectEnabled:${isAiRemoveReflectEnabled}`);
    return isAiRemoveEnabled || isAiExpandEnabled || isAiBackgroundEnabled || isAiTranditionalRemoveEnabled ||
      isAiRefineMasterEnabled || isAiReplaceEmoEnabled || isAiRemoveReflectEnabled;
  }

  public static isCloudAiRetouchEnabled(): boolean {
    const isAiRemoveEnabled: boolean = AiEditorCommonUtil.isAiRemoveEnabled();
    const isAiExpandEnabled: boolean = AiEditorCommonUtil.isAiExpandEnabled();
    const isAiRefineMasterEnabled: boolean = AiEditorCommonUtil.isAiRefineMasterEnabled();
    const isAiRemoveReflectEnabled: boolean = AiEditorCommonUtil.isAiRemoveReflectEnabled();
    const isAiMoveEnabled: boolean = AiEditorCommonUtil.isAiMoveEnabled();
    Log.info(TAG,
      'current isCloudAiRetouchEnabled, isAiRemoveEnabled: ' + isAiRemoveEnabled + ', isAiExpandEnabled: ' +
        isAiExpandEnabled + ', isAiRefineMasterEnabled: ' + isAiRefineMasterEnabled + ', isAiMoveEnabled:' +
        isAiMoveEnabled + ', isAiRemoveReflectEnabled:' + isAiRemoveReflectEnabled);
    return isAiRemoveEnabled || isAiExpandEnabled || isAiRefineMasterEnabled || isAiMoveEnabled ||
      isAiRemoveReflectEnabled;
  }

  public static isTraditionalRemoveMode(): boolean {
    const isAiRemoveEnabled: boolean = AiEditorCommonUtil.isAiRemoveEnabled();
    const isAiTraditionalRemoveEnabled: boolean = AiEditorCommonUtil.isAiTraditionalRemoveEnabled();
    Log.debug(TAG, `current isCloudAiRetouchEnabled, isAiRemoveEnabled: ${
    isAiRemoveEnabled}, isAiTraditionalRemoveEnabled: ${isAiTraditionalRemoveEnabled}`);
    return !isAiRemoveEnabled && isAiTraditionalRemoveEnabled;
  }
}
