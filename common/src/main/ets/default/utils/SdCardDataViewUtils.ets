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
import lazy { DeviceInfo } from './DeviceInfo';
import lazy { Log } from './Log';
import lazy volumemanager from '@ohos.file.volumeManager';
import lazy { DataStoreUtil } from './DataStoreUtil';
import lazy CommonEventManager from '@ohos.commonEventManager';
import type Base from '@ohos.base';

const TAG = 'SdCardDataViewUtils';

export class SdCardDataViewUtils {
  public static instance: SdCardDataViewUtils = new SdCardDataViewUtils();
  /**
   * 存储设备变化公共事件监听器
   */
  private subscriber?: CommonEventManager.CommonEventSubscriber;
  /**
   * 存储设备变化的时间列表
   */
  private static readonly eventList = [
    CommonEventManager.Support.COMMON_EVENT_VOLUME_REMOVED, // 提示已移除外部存储设备
    CommonEventManager.Support.COMMON_EVENT_VOLUME_UNMOUNTED, // 提示已卸载外部存储设备
    CommonEventManager.Support.COMMON_EVENT_VOLUME_MOUNTED, // 提示已挂载外部存储设备
    CommonEventManager.Support.COMMON_EVENT_VOLUME_BAD_REMOVAL, // 提示外部存储设备在挂载状态下被移除
    CommonEventManager.Support.COMMON_EVENT_VOLUME_EJECT// 提示用户已作出弹出外部存储介质的操作
  ];

  private constructor() {
  }

  public static getInstance(): SdCardDataViewUtils {
    return SdCardDataViewUtils.instance;
  }

  public async getSdCardNameByUuid(uri: string): Promise<volumemanager.Volume> {
    let volume: volumemanager.Volume = await volumemanager.getVolumeByUuid(uri);
    return volume;
  }

  public async getSdCardName(): Promise<string[] | undefined> {
    let uris: string[] = [];
    // 适配PAD、直板机、xxx、PC
    if (!DeviceInfo.isTablet() && !DeviceInfo.isPhoneUx() && !DeviceInfo.isPc()) {
      Log.error(TAG, 'current device is not available with sdCard.');
      return undefined;
    }

    // 是否插入SD卡
    try {
      const allVolumes: volumemanager.Volume[] = await volumemanager.getAllVolumes();
      for (const volume of allVolumes) {
        if (!volume?.description || !volume?.uuid) {
          Log.warn(TAG, 'getRoots, description or uuid is null');
          continue;
        }
        if (volume?.uuid) {
          uris.push(volume?.uuid);
        }
      }
    } catch (e) {
      Log.error(TAG, `get sdCard message failed: ${e?.message}`);
    }
    Log.info(TAG, `sdCard inserted, cardName: ${uris?.toString()}`);
    return uris;
  }

  /**
   * 注册监听存储设备挂载和移除的公共事件
   */
  public async subscribeStorageDeviceChangeEvent(callback: Function): Promise<void> {
    if (!DeviceInfo.isTablet() && !DeviceInfo.isPhoneUx() && !DeviceInfo.isPc()) {
      Log.info(TAG, 'current device is not available with this feature.');
      return;
    }
    this.subscriber = await CommonEventManager.createSubscriber({
      events: SdCardDataViewUtils.eventList,
    });
    CommonEventManager.subscribe(this.subscriber,
      (error: Base.BusinessError, commonEventData: CommonEventManager.CommonEventData) => {
        Log.info(TAG, `external device event: ${commonEventData?.event}`);
        callback?.(error, commonEventData);
      });
  }

  /**
   * 取消监听存储设备挂载和移除的公共事件
   */
  public unsubscribeStorageDeviceChangeEvent(): void {
    try {
      CommonEventManager.unsubscribe(this.subscriber, (error: Base.BusinessError) => {
        Log.error(TAG, `unsubscribeStorageDeviceChangeEvent fail, error: ${error?.message}`);
      });
    } catch (error) {
      Log.error(TAG, `unsubscribeStorageDeviceChangeEvent fail, error: ${error?.message}`);
    }
  }
}