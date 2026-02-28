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

import lazy { Log } from './Log';
import lazy { BusinessError, commonEventManager, osAccount } from '@kit.BasicServicesKit';
import lazy { Constants } from '../model/common/Constants';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCast } from './BroadCast';

const TAG = 'ThirdAppLockUtil';
const LOCK_SCREEN_OR_EXIST_APP = 1;
const USER_ID_DEFAULT: number = 100;

@Observed
export default class ThirdAppLockUtil {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private userId: number = 0;
  // 应用锁是否展示
  public isAppLockShow = false;
  // 订阅锁屏解锁事件
  private subscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;

  private lockSubscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;

  // 页面锁屏标记
  private isPageLock: boolean = false;

  // 页面切换前后台回调
  private onForegroundCallback = (isOnForeground: boolean) => {
    this.onForeground(isOnForeground);
  }

  public async init(eventName: string) {
    this.userId = await this.getUserId();

    // 刷新应用锁状态
    this.updateAppLockShow();

    // 适配 应用退出后立即锁定
    getContext(this)?.eventHub?.on(eventName, this.onForegroundCallback);

    // 适配 锁屏后应用锁锁定
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.SCREEN_UNLOCKED'], // 订阅解锁公共事件
      priority: 80
    }
    try {
      this.subscriber = await commonEventManager.createSubscriber(subscribeInfo);
      Log.info(TAG, `Succeeded in creating subscriber.`);
      // 公共事件回调
      commonEventManager.subscribe(this.subscriber, (err, data) => {
        if (err) {
          Log.error(TAG, `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        } else {
          this.isPageLock = false;
          this.updateAppLockShow(true);
        }
      })
    } catch (err) {
      Log.error(TAG, `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
    // 订阅锁屏事件
    this.subscribeScreenOff();
  }

  private async subscribeScreenOff(): Promise<void> {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['usual.event.SCREEN_LOCKED'], // 订阅锁屏公共事件
      priority: 80
    }
    try {
      this.lockSubscriber = await commonEventManager.createSubscriber(subscribeInfo);
      Log.info(TAG, `Succeeded in creating subscribeScreenOff.`);
      // 解锁事件回调
      commonEventManager.subscribe(this.lockSubscriber, (err, data) => {
        if (err) {
          Log.error(TAG, `Failed to subscribeScreenOff. Code is ${err.code}, message is ${err.message}`);
          return;
        } else {
          this.isPageLock = true;
        }
      })
    } catch (err) {
      Log.error(TAG, `Failed to create subscribeScreenOff. Code is ${err.code}, message is ${err.message}`);
    }
  }

  public destroy() {
    getContext(this)?.eventHub?.off(Constants.GALLERY_CLEANUP_ON_FOREGROUND, this.onForegroundCallback);
    try {
      commonEventManager.unsubscribe(this.subscriber, (error: BusinessError) => {
        Log.error(TAG, `unsubscribe gallery cleanup event fail, error: ${error?.message}`);
      });
    } catch (error) {
      Log.error(TAG, `unsubscribe gallery cleanup event fail, error is : ${error?.message}`);
    }

    try {
      commonEventManager.unsubscribe(this.lockSubscriber, (error: BusinessError) => {
        Log.error(TAG, `lockSubscriber gallery cleanup event fail, error: ${error?.message}`);
      });
    } catch (error) {
      Log.error(TAG, `lockSubscriber gallery cleanup event fail, error is : ${error?.message}`);
    }
  }

  public async updateAppLockShow(isUnlockScreen: boolean = false) {
    // try {
    //   let authTypes = await appLock.getAllowedAuthTypes(this.userId);
    //   // 适配 应用锁类型为锁屏密码
    //   if (isUnlockScreen && authTypes.findIndex(type => type == appLock.AuthType.PIN) != -1) {
    //     let appInfo: appLock.AppInfo[] = [{
    //       bundleName: 'com.ohos.photos',
    //       appIndex: 0
    //     }];
    //     await appLock.setAppProtectedState(appInfo, false, this.userId);
    //   }
    //
    //   this.isAppLockShow = await appLock.isAppProtected('com.ohos.photos', { userId: this.userId });
    //   this.appBroadCast.emit(Constants.THIRD_APP_LOCK_UPDATE, [this.isAppLockShow]);
    //   Log.info(TAG, `updateAppLockShow isAppLockShow=${this.isAppLockShow}`);
    // } catch (e) {
    //   Log.error(TAG, `updateAppLockShow has error: ${e?.message}, code: ${e?.code}`);
    // }
  }

  private async onForeground(isOnForeground: boolean) {
    // let condition: appLock.AppLockCondition = await appLock.getAppLockCondition(this.userId);
    // Log.info(TAG, `onForeground: isOnForeground=${isOnForeground} condition=${condition}`);
    // if (condition.valueOf() !== LOCK_SCREEN_OR_EXIST_APP) {
    //   return;
    // }
    //
    // if (isOnForeground) {
    //   // 刷新应用锁
    //   if (this.isPageLock) {
    //     return;
    //   }
    //   this.updateAppLockShow();
    // } else {
    //   // 应用退出后立即锁定
    //   // let appInfo: appLock.AppInfo[] = [{
    //   //   bundleName: 'com.ohos.photos',
    //   //   appIndex: 0
    //   // }];
    //   // appLock.setAppProtectedState(appInfo, true, this.userId);
    // }
  }

  private async getUserId(): Promise<number> {
    if (this.userId > 0) {
      return this.userId;
    }
    try {
      const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      this.userId = await accountManager.getForegroundOsAccountLocalId();
      return this.userId;
    } catch (e) {
      Log.error(TAG, `getUserId has error: ${e?.message}, code: ${e?.code}`);
      return USER_ID_DEFAULT;
    }
  }
}