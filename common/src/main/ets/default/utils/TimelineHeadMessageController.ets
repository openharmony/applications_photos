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

import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { Log } from '../utils/Log';
import lazy { FetchOptions, UserFileManagerAccess } from '../access/UserFileManagerAccess';

const TAG: string = 'TimelineHeadMessageController';

export class TimelineHeadMessageController {
  private static instance: TimelineHeadMessageController;
  private isQuerying: boolean = false;
  private uploadingCount: number = 0;
  private listeners: ((newCount: number) => void)[] = [];

  // 获取单例实例
  static getInstance(): TimelineHeadMessageController {
    if (!TimelineHeadMessageController.instance) {
      TimelineHeadMessageController.instance = new TimelineHeadMessageController();
    }
    return TimelineHeadMessageController.instance;
  }

  // 更新上传数量
  async updateUploadingCount(): Promise<void> {
    if (this.isQuerying) {
      Log.debug(TAG, ' Query is already in progress. Skipping...');
      return;
    }
    try {
      this.isQuerying = true;
      let requestTime = Date.now();
      let fetchOpt: FetchOptions = AlbumDefine.getUploadingFetchOpt();
      this.uploadingCount = await UserFileManagerAccess.getInstance().getCount(fetchOpt, TAG);
      this.notifyListeners();
      Log.i(TAG, `took ${Date.now() - requestTime} ms to get uploading count: ${this.uploadingCount}`);
    } catch (error) {
      Log.info(TAG, 'get uploadingCount error');
    } finally {
      this.isQuerying = false;
    }
  }

  // 添加监听器
  addListener(listener: (newCount: number) => void) {
    if (listener) {
      this.listeners.push(listener);
      Log.i(TAG, `add listener, listener.lenght = ${this.listeners.length}`);
    }
  }

  removeListener(listener: (newCount: number) => void) {
    const index = this.listeners.indexOf(listener);
    if (index !== -1) {
      this.listeners.splice(index, 1);
    }
    Log.i(TAG, `remove listener, listener.lenght = ${this.listeners.length}`);
  }

  // 通知所有监听器
  private notifyListeners() {
    this.listeners.forEach(listener => listener(this.uploadingCount));
  }
}