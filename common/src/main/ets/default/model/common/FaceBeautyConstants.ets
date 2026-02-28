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

export class FaceBeautyConstants {
  /**
   * ImageEffect
   */
  public static readonly BEAUTY_EFFECT_NAME: string = 'beauty';
  public static readonly BEAUTY_EFFECT_ALREADY: number = 0;
  public static readonly BEAUTY_EFFECT_NO: number = 1;
  public static readonly BEAUTY_EFFECT_ERROR: number = 2;
  public static readonly REVERT_TO_ORIGINAL: string = 'revert to original';
  public static readonly BEAUTY_FAIL: string = 'beauty fail';
  public static readonly SINGLE_BEAUTY_JSON: string =
    '{\"name\":\"Beauty\",\"values\":{\"FILTER_LOADMODEL\":\"beauty\"}';
  public static readonly SINGLE_THIRD_JSON: string = '{\"third\":{\"extra_info\":';
  /**
   * UI
   */
  public static readonly BEAUTY_EFFECT_TIME: number = 3000;
  public static readonly MAX_WINDOW_SCALE_RATIO = 0.8;
  public static readonly SCALE_RATIO: number = 1.5;
  /**
   * AI
   */
  public static readonly AI_FACE_BEAUTY_STATE_KEY: string = 'subject_config_skin_smoothing_state';
  public static readonly AI_ALREADY_FACE_BEAUTY_STATE: string = 'already_skin_smoothed';
  public static readonly AI_NO_FACE_BEAUTY_STATE: string = 'no_skin_smoothing';
  public static readonly AI_ACTION_DO_BEAUTY: string = 'enable_skin_smoothing';
  public static readonly AI_ACTION_CANCEL_BEAUTY: string = 'disable_skin_smoothing';
  /**
   * BroadCastConstants
   */
  public static readonly AI_FACE_BEAUTY_STATE_IS_READY: string = 'ai_face_beauty_state_is_ready';
  public static readonly AI_FACE_INFO_IS_READY = 'ai_face_info_is_ready';
  public static readonly AI_DO_FACE_BEAUTY_OLD: string = 'ai_do_face_beauty_old';
  public static readonly AI_DO_FACE_BEAUTY: string = 'ai_do_face_beauty';
  public static readonly AI_CANCEL_FACE_BEAUTY: string = 'ai_cancel_face_beauty';
  public static readonly AI_FAILURE_FACE_BEAUTY_STATE = 'ai_failure_face_beauty_state';
  public static readonly AI_THIRD_FACE_BEAUTY_STATE = '';
}
