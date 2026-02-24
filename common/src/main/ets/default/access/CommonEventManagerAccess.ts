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

import lazy eventMgr from '@ohos.commonEventManager';
import type { BusinessError } from '@ohos.base';
import lazy { Log } from '../utils/Log';

const TAG: string = 'CommonEventManagerAccess';

export declare type Event = eventMgr.CommonEventData;

export declare type Subscriber = eventMgr.CommonEventSubscriber;

export declare type EventHandler = (event: Event) => void;

export class CommonEventManagerAccess {
  /**
   * 创建事件订阅者对象
   * @param events 订阅的事件数组
   * @returns CommonEventSubscriber对象
   */
  public static async createSubscriber(events: string[]): Promise<Subscriber> {
    let subscribeInfo = {
      events: events,
    };
    //创建订阅者
    let subscriber = await eventMgr.createSubscriber(subscribeInfo);
    /* instrument ignore if */
    if (!subscriber) {
      Log.error(TAG, 'createSubscriber failed');
      return undefined;
    }
    Log.info(TAG, 'create subscriber success.');
    return subscriber;
  }

  //订阅公共事件
  public static subscribe(subscriber: Subscriber, onSucceed?: EventHandler): void {
    eventMgr.subscribe(subscriber, (error: BusinessError<void>, event: Event): void => {
      /* instrument ignore if */
      if (error) {
        Log.error(TAG, `eventMgr subscribee failed, ${error}, code: ${error?.code}`);
        return;
      }
      Log.info(TAG, 'eventMgr subscribed');
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
        /* instrument ignore if*/
        if (err) {
          Log.error(TAG, `ucommonEventManager unsubscribed failed ${err}, code: ${err?.code}`);
          return;
        }
        Log.info(TAG, 'eventMgr unsubscribed');
      });
      /* instrument ignore next */
    } catch (error) {
      Log.error(TAG, `eventMgr unsubscribe error catched: ${error}, code: ${error?.code}`);
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
    CommonEventManagerAccess.subscribe(subscriber, onSucceed);
    /* instrument ignore next */
  } catch (error) {
    Log.error(TAG, `subscribe error catched: ${error}, code: ${error?.code} at ${where ?? ''}`);
  }
}