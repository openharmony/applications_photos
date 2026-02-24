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

import lazy { MediaDataManager } from '../data/MediaDataManager';
import lazy { Constants } from '../common/Constants';
import type common from '@ohos.app.ability.common';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

/* instrument ignore file */
const TAG: string = 'FormController';

export interface FormListener {
  onDeleteForm(formId: string): void;

  onUpdateFormData(formId: string): void;

  onEvent(formId: string): void;

  onCallback(formId: string): void;

  onShowForm(formId: string): void;

  updateFormData(formId: string): void;

  onVisibleChange(formId: string, isVisible: Boolean): void;
}

export class FormController implements FormListener {
  private mediaDataManager: MediaDataManager | undefined = new MediaDataManager();
  private formId: string;

  constructor(formId: string) {
    this.formId = formId;
  }

  async init(playInterval: number = 15): Promise<void> {
    if (!this.mediaDataManager) {
      Log.info(TAG, `FormController init failed, mediaDataManager is undefined`);
      return;
    }

    this.mediaDataManager.setPlayInterval(playInterval);

    Log.info(TAG, `FormController init start, formId = ${this.formId}`);
    await this.mediaDataManager.initData(this.formId);
    Log.info(TAG, `FormController init end, formId = ${this.formId}`);
  }

  async updateFormData(formId: string): Promise<void> {
    if (!this.mediaDataManager) {
      return;
    }
    Log.info(TAG, 'updateFormData start:' + formId);
  }

  async onDeleteForm(formId: string): Promise<void> {
    Log.info(TAG, 'onDeleteForm start:' + formId);
    this.onDestroy(formId);
  }

  onDestroy(formId: string): void {
    if (this.mediaDataManager) {
      this.mediaDataManager.onDestroy(formId);
    }
    this.mediaDataManager = undefined;
  }

  async onUpdateFormData(formId: string): Promise<void> {
    Log.info(TAG, `onUpdateFormData formId: ${formId}`);
  }

  onEvent(formId: string): void {
    Log.debug(TAG, 'onEvent!');
  }

  onCallback(formId: string): void {
    Log.info(TAG, 'onCallback end!');
  }

  async onShowForm(formId: string): Promise<void> {
    Log.info(TAG, 'onShowForm start!');
  }

  onVisibleChange(formId: string, isVisible: Boolean) {
    if (formId != this.formId) {
      return;
    }
    Log.info(TAG, 'onVisibleChange! :' + isVisible);
  }
}