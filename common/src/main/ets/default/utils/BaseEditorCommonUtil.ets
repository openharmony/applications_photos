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

import lazy { systemParameter } from '@kit.BasicServicesKit';

const TAG: string = 'BaseEditorCommonUtil';
const BASE_TEXT_EDIT_ENABLE: string = 'const.photos.image_editor.text_edit';
const BASE_EDITOR_MODEL_ENABLE: string = 'true';

export class BaseEditorCommonUtil {
  public static isBaseTextEditEnabled(): boolean {
    return systemParameter.getSync(BASE_TEXT_EDIT_ENABLE, 'false') === BASE_EDITOR_MODEL_ENABLE;
  }
}