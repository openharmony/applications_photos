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

import eventMgr from '@ohos.commonEventManager';
import type { BusinessError } from '@ohos.base';
import { HiLog } from './HiLog';

const TAG: string = 'ImageEditorCommonEventManagerAccess';

export declare type Event = eventMgr.CommonEventData;

export declare type Subscriber = eventMgr.CommonEventSubscriber;

export declare type EventHandler = (event: Event) => void;

export class ImageEditorCommonEventManagerAccess {
  /**
   * 创建事件订阅者对象
   * @param events 订阅的事件数组
   * @returns CommonEventSubscriber对象
   */
  public static async createSubscriber(events: string[]): Promise<Subscriber | undefined> {
    let subscribeInfo: eventMgr.CommonEventSubscribeInfo = {
      events: events,
    };

    //创建订阅者
    let subscriber = await eventMgr.createSubscriber(subscribeInfo);
    // instrument ignore if
    if (!subscriber) {
      HiLog.e(TAG, 'createSubscriber failed');
      return undefined;
    }
    HiLog.i(TAG, 'create subscriber success.');
    return subscriber;
  }

  //订阅公共事件
  public static subscribe(subscriber: Subscriber, onSucceed?: EventHandler): void {
    eventMgr.subscribe(subscriber, (error: BusinessError<void>, event: Event): void => {
      // instrument ignore if
      if (error) {
        HiLog.e(TAG, `eventMgr subscribee failed, ${error}, code: ${error?.code}`);
        return;
      }
      HiLog.i(TAG, 'eventMgr subscribed');
      onSucceed?.(event);
    });
  }

  /**
   * 取消订阅
   * @param subscriber CommonEventSubscriber对象
   */
  public static unsubscribe(subscriber: Subscriber): void {
    //取消订阅公共事件
    try {
      eventMgr.unsubscribe(subscriber, (err: BusinessError<void>): void => {
        // instrument ignore if
        if (err) {
          HiLog.e(TAG, `ucommonEventManager unsubscribed failed ${err}, code: ${err?.code}`);
          return;
        }
        HiLog.i(TAG, 'eventMgr unsubscribed');
      });
    } catch (error) {
      HiLog.e(TAG, `eventMgr unsubscribe error catched: ${error}, code: ${error?.code}`);
    }
  }
}

/**
 * 通过CommonEventManager订阅公共事件
 * @param subscriber CommonEventSubscriber对象
 * @param callback 事件触发时的回调
 */
export default function subscribeEvent(subscriber: Subscriber, onSucceed?: EventHandler, where?: string): void {
  //订阅公共事件
  try {
    ImageEditorCommonEventManagerAccess.subscribe(subscriber, onSucceed);
  } catch (error) {
    HiLog.e(TAG, `subscribe error catched: ${error}, code: ${error?.code} at ${where ?? ''}`);
  }
}