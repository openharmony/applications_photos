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

import lazy { PhotoItemConfig } from '../base/PhotoItemConfig';
import lazy { AttributeUpdater } from '@ohos.arkui.modifier';

export class PhonePhotoItemConfig implements PhotoItemConfig {
  public photoComponentAttr: AttributeUpdater<ColumnAttribute> = new PhotoComponentAttr;

  private initPhotoComponentAttr(): AttributeUpdater<ColumnAttribute> {
    return new PhotoComponentAttr();
  }
}

class PhotoComponentAttr extends AttributeUpdater<ColumnAttribute> {
  initializeModifier(instance: ColumnAttribute): void {
    instance;
  }
}