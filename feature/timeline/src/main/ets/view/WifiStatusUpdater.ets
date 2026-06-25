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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy eventMgr from '@ohos.commonEventManager';
import lazy subscribeEvent, {
  CommonEventManagerAccess
} from '@ohos/common/src/main/ets/default/access/CommonEventManagerAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { AttributeStateManager } from '@ohos/common/src/main/ets/default/model/AttributeStateManager';

const TAG: string = 'WifiStatusUpdater';

export class WifiStatusUpdater extends AttributeStateManager<boolean> {
  public static readonly COMMON_EVENT_WIFI_CONN_STATE: string = 'usual.event.wifi.CONN_STATE';
  private static readonly TIMER_DELAY: number = 300;
  private updateWifiStatusTimer: number = 0;
  private subscriber: eventMgr.CommonEventSubscriber | undefined = undefined;
  private isAboutToRelease = false;

  public constructor(persistentId: number, initState: boolean) {
    super(persistentId, initState, TAG);
  }

  protected doInit(param?: number | undefined): void {
    Log.info(TAG, `init isWifiConnect: ${this.currentState}`);
    this.updateWifiStatusTimer = setTimeout((): void => {
      this.updateWifiStatus();
    }, WifiStatusUpdater.TIMER_DELAY);
  }

  private async updateWifiStatus(): Promise<void> {
    this.subscriber = await CommonEventManagerAccess.createSubscriber([WifiStatusUpdater.COMMON_EVENT_WIFI_CONN_STATE]);
    if (this.isAboutToRelease) {
      this.subscriber = undefined;
      return;
    }
    subscribeEvent(this.subscriber, (data: eventMgr.CommonEventData): void => {
      this.updateState(data.code === Constants.WIFI_CONNECT, 'subscriber callback');
    }, TAG);
  }

  protected doRelease(): void {
    this.isAboutToRelease = true;
    clearTimeout(this.updateWifiStatusTimer);
    if (this.subscriber !== undefined) {
      CommonEventManagerAccess.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    }
  }

  protected isSupport(param?: number | undefined): boolean {
    return true;
  }
}