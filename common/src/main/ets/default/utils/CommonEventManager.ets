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
import lazy CommonEventMg from '@ohos.commonEventManager';
import type { BroadCast } from './BroadCast';
import lazy { Log } from './Log';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { BusinessError } from '@kit.BasicServicesKit';

/* instrument ignore file */
const TAG: string = 'CommonEventManager';

interface EventInfoParam {
  events: string[],
}

const COMMON_EVENT_INFO: EventInfoParam = {
  events: [CommonEventMg.Support.COMMON_EVENT_SCREEN_OFF, CommonEventMg.Support.COMMON_EVENT_SCREEN_ON],
};


export default class CommonEventManager {
  public static readonly SCREEN_CHANGE_EVENT = 'SCREEN_CHANGE_EVENT';
  private static instance: CommonEventManager;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  public static getInstance(): CommonEventManager {
    if (!CommonEventManager.instance) {
      CommonEventManager.instance = new CommonEventManager();
    }
    return CommonEventManager.instance;
  }

  public async init(): Promise<void> {
    Log.info(TAG, 'init.');
    //订阅者信息
    let subscriber: CommonEventMg.CommonEventSubscriber; //用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作

    //订阅者信息
    let subscribeInfo = COMMON_EVENT_INFO;

    //订阅公共事件回调
    let subscribeCB = (err: BusinessError, data: CommonEventMg.CommonEventData): void => {
      if (err) {
        Log.error(TAG, `subscribeCB err, code is ${err.code}, message is ${err.message}.`);
      } else {
        Log.info(TAG, `subscribeCB data: ${JSON.stringify(data)}.`);
        switch (data.event) {
          case CommonEventMg.Support.COMMON_EVENT_SCREEN_OFF:
            Log.warn(TAG, 'subscribeCB COMMON_EVENT_SCREEN_OFF.');
            global.terminateSelf(TAG, 'subscribeCB COMMON_EVENT_SCREEN_OFF.');
            CommonEventManager.getInstance().notifyScreenEvent(false);
            break;
          case CommonEventMg.Support.COMMON_EVENT_SCREEN_ON:
            Log.info(TAG, 'subscribeCB COMMON_EVENT_SCREEN_ON.');
            CommonEventManager.getInstance().notifyScreenEvent(true);
            break;
          default:
            Log.info(TAG, 'unKnow event.');
        }
      }
    };

    //创建订阅者回调
    let createCB = (err: BusinessError, commonEventSubscriber: CommonEventMg.CommonEventSubscriber): void => {
      if (!err) {
        Log.info(TAG, 'createSubscriber.');
        subscriber = commonEventSubscriber;
        //订阅公共事件
        try {
          CommonEventMg.subscribe(subscriber, subscribeCB);
          Log.error(TAG, 'createSubscriber.1111111');
        } catch (err) {
          Log.error(TAG, `createCB err, code is ${err.code}, message is ${err.message}.`);
        }
      } else {
        Log.error(TAG, `createCB failed, code is ${err.code}, message is ${err.message}.`);
      }
    };

    //创建订阅者
    try {
      CommonEventMg.createSubscriber(subscribeInfo, createCB);
      Log.info(TAG, 'createdSubscriber');
    } catch (err) {
      Log.error(TAG, `createSubscriber failed, code is ${err.code}, message is ${err.message}.`);
    }
  }

  public notifyScreenEvent(isScreenOn: boolean): void {
    this.appBroadCast.emit(CommonEventManager.SCREEN_CHANGE_EVENT, [isScreenOn]);
    Log.info(TAG, `Publish ${CommonEventManager.SCREEN_CHANGE_EVENT} screenState: ${isScreenOn}.`);
  }
}