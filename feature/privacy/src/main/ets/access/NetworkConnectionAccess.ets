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

import lazy connection from '@ohos.net.connection';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

/* instrument ignore file */
const TAG: string = 'common_NetworkConnectionAccess';

export class NetworkConnectionAccess {
  // 创建NetConnection对象
  private static netConnect: connection.NetConnection = connection.createNetConnection();

  /**
   * 订阅指定网络状态变化的通知.
   * 设备从无网络到有网络会触发netAvailable事件、netCapabilitiesChange事件和netConnectionPropertiesChange事件；
   * 设备从有网络到无网络状态会触发netLost事件；
   * 设备从WiFi到蜂窝会触发netLost事件（WiFi丢失）之后触发 netAvailable事件（蜂窝可用）；
   */
  public static register(): void {
    // 订阅网络可用事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netAvailable', (data) => {
      Log.info(TAG, `netAvailable: ${JSON.stringify(data)}`);
      AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE, true);
    });

    // 订阅网络丢失事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netLost', (data) => {
      Log.info(TAG, `netLost: ${JSON.stringify(data)}`);
      AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE, false);
    });

    // 订阅网络不可用事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netUnavailable', (data) => {
      Log.info(TAG, `netUnavailable: ${JSON.stringify(data)}`);
      AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE, false);
    });

    // 订阅网络能力变化事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo): void => {
      Log.info(TAG, `netCapabilitiesChange: ${JSON.stringify(data)}`);
      // networkCap同时包含12和16代表有网络
      const NET_CAPABILITY: number[] = [12, 16];
      const NET_AVAILABLE: boolean = NET_CAPABILITY.every(((num: number):
      boolean | undefined => data.netCap.networkCap?.includes(num)));
      AppStorage.setOrCreate(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE, NET_AVAILABLE);
    });

    // 订阅网络阻塞状态事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
      Log.info(TAG, `netBlockStatusChange: ${JSON.stringify(data)}`);
    });

    // 订阅网络连接信息变化事件。调用register后，才能接收到此事件通知
    NetworkConnectionAccess.netConnect.on('netConnectionPropertiesChange',
      (data: connection.NetConnectionPropertyInfo) => {
        Log.info(TAG, 'netConnectionPropertiesChange.');
      });

    // 使用register接口注册订阅事件
    NetworkConnectionAccess.netConnect.register((error) => {
      if (!error) {
        return;
      }
      Log.error(TAG, 'register error:' + error + `, code: ${error?.code}`);
    });
  }

  // 取消订阅默认网络状态变化的通知。
  public static unregister(): void {
    NetworkConnectionAccess.netConnect.unregister((error) => {
      if (!error) {
        return;
      }
      Log.error(TAG, 'unregister error: ' + error + `, code: ${error?.code}`);
    });
  }

  public static canAccessNetWork(): boolean {
    let data: connection.NetHandle[] = connection.getAllNetsSync();
    for (let i = 0; i < data.length; i++) {
      let netCapabilities: connection.NetCapabilities = connection.getNetCapabilitiesSync(data[i]);
      let indexOf: number =
          netCapabilities.networkCap ?
          netCapabilities.networkCap.indexOf(connection.NetCap.NET_CAPABILITY_INTERNET) : -1;
      if (indexOf !== -1) {
        return true;
      }
    }
    return false;
  }
}

/**
 * 业务：账号
 */
export namespace AccountVar {
  export let isNeedSilentSignOnNetChange: boolean = false;
}