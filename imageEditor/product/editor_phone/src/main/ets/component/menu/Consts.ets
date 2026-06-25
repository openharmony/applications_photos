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
import { HiLog } from '@oh-image-editor/editor-common';

const TAG = 'MenuConsts';

const MODAL_TEXT_MAP = new Map([
// 静态图切换
  ['static_mosaic_1', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_mosaic_param_one', ...params)],
  ['static_mosaic_2', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_mosaic_param_two', ...params)],
  ['static_mosaic_3', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_mosaic_param_three', ...params)],

  ['live_mosaic_0', (...params: Resource[]) => $r('app.string.some_functions_unsupport_mosaic_param_none', ...params)],
  ['live_mosaic_1', (...params: Resource[]) => $r('app.string.some_functions_unsupport_mosaic_param_one', ...params)],
  ['live_mosaic_2', (...params: Resource[]) => $r('app.string.some_functions_unsupport_mosaic_param_two', ...params)],
  ['live_mosaic_3', (...params: Resource[]) => $r('app.string.some_functions_unsupport_mosaic_param_three', ...params)],

  ['static_stylus_1', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_markup_param_one', ...params)],
  ['static_stylus_2', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_markup_param_two', ...params)],
  ['static_stylus_3', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_markup_param_three', ...params)],

  ['live_stylus_0', (...params: Resource[]) => $r('app.string.some_functions_unsupport_markup_param_none', ...params)],
  ['live_stylus_1', (...params: Resource[]) => $r('app.string.some_functions_unsupport_markup_param_one', ...params)],
  ['live_stylus_2', (...params: Resource[]) => $r('app.string.some_functions_unsupport_markup_param_two', ...params)],
  ['live_stylus_3', (...params: Resource[]) => $r('app.string.some_functions_unsupport_markup_param_three', ...params)],

  ['static_ai_1', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_ai_param_one', ...params)],
  ['static_ai_2', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_ai_param_two', ...params)],
  ['static_ai_3', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_ai_param_three', ...params)],

  ['live_ai_0', (...params: Resource[]) => $r('app.string.some_functions_unsupport_ai_param_none', ...params)],
  ['live_ai_1', (...params: Resource[]) => $r('app.string.some_functions_unsupport_ai_param_one', ...params)],
  ['live_ai_2', (...params: Resource[]) => $r('app.string.some_functions_unsupport_ai_param_two', ...params)],
  ['live_ai_3', (...params: Resource[]) => $r('app.string.some_functions_unsupport_ai_param_three', ...params)],

  ['static_textEdit_1', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_word_param_one', ...params)],
  ['static_textEdit_2', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_word_param_two', ...params)],
  ['static_textEdit_3', (...params: Resource[]) => $r('app.string.static_some_functions_unsupport_word_param_three', ...params)],

  ['live_textEdit_0', (...params: Resource[]) => $r('app.string.some_functions_unsupport_word_param_none', ...params)],
  ['live_textEdit_1', (...params: Resource[]) => $r('app.string.some_functions_unsupport_word_param_one', ...params)],
  ['live_textEdit_2', (...params: Resource[]) => $r('app.string.some_functions_unsupport_word_param_two', ...params)],
  ['live_textEdit_3', (...params: Resource[]) => $r('app.string.some_functions_unsupport_word_param_three', ...params)],
]);

export const getMutuallyExclusiveDesc = (key: string, ...params: Resource[]): Resource | string => {
  const fn = MODAL_TEXT_MAP.get(key);
  HiLog.i(TAG, `keys len = ${MODAL_TEXT_MAP.size}`)
  if (!fn) {
    HiLog.e(TAG, `getMutuallyExclusiveDesc failed, has not key: ${key}`);
    return '';
  }
  return fn(...params);
}

export enum ConflictFunc {
  AI = 'ai',
  TEXT = 'textEdit',
  MOSAIC = 'mosaic',
  STYLUS = 'stylus',
}

export interface ConflictContent {
  title: string | Resource,
  content: string | Resource,
}