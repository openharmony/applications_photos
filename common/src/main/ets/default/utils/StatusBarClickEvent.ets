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
import lazy commonEventManager from '@ohos.commonEventManager';
import lazy { BusinessError } from '@ohos.base';
import lazy { LogUtils } from './LogUtils';

const TAG = 'StatusBarClickEvent';

const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.CLICK_STATUSBAR'
  ]
};

export class StatusBarClickEvent {
  private mSubscriber: commonEventManager.CommonEventSubscriber | undefined;

  public register(tag: string, callback: Function): void {
    this.mSubscriber = commonEventManager.createSubscriberSync(subscribeInfo);
    if (this.mSubscriber === null) {
      LogUtils.error(TAG, `create subscriber error!`);
      return;
    }
    commonEventManager.subscribe(this.mSubscriber, async (err: BusinessError) => {
      if (err) {
        LogUtils.error(TAG, `Can't handle common event, err: ${err.code}, err: ${err.message}`);
        return;
      }
      LogUtils.info(tag, 'Click the status bar event register success');
      callback();
    });
  }

  public unRegister(): void {
    try {
      if (this.mSubscriber) {
        commonEventManager.unsubscribe(this.mSubscriber);
        this.mSubscriber = undefined;
      }
    } catch (error) {
      LogUtils.error(TAG, `unsubscribe mSubscriber error : ${error.message}`)
    }
  }
}