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
import lazy { abilityAccessCtrl, bundleManager } from '@kit.AbilityKit';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { settings } from '@kit.BasicServicesKit';

const TAG: string = 'CameraAuthLocationManager';

export enum CameraAuthLocationFromEnum {
  TimeLine,
  Browser
}

export class CameraAuthLocationManager {
  private static readonly cameraBundleName: string = 'com.ohos.camera';
  private static readonly CAMERA_LOCATION_SWITCH: string = 'camera_location_switch';
  // 三次
  private static readonly MAX_POPUP_COUNT: number = 3;
  private static readonly TIMELINE_CANCEL_TIME: string = 'TIMELINE_CANCEL_TIME';
  private static readonly BROWSER_CANCEL_TIME: string = 'BROWSER_CANCEL_TIME';
  private static readonly TIMELINE_SHOW_COUNT: string = 'TIMELINE_SHOW_COUNT';
  private static readonly BROWSER_SHOW_COUNT: string = 'BROWSER_SHOW_COUNT';
  // 30天
  private static readonly SHOW_CARD_INTERVAL: number = 30 * 24 * 60 * 60 * 1000;

  // 查询相机是否启动授权过
  private static async checkCameraAuth(): Promise<boolean> {
    try {
      let tokenId: number = bundleManager.getApplicationInfoSync(CameraAuthLocationManager.cameraBundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT).accessTokenId;
      const grantStatus =
        await abilityAccessCtrl.createAtManager()
          .checkAccessTokenSync(tokenId, 'ohos.permission.APPROXIMATELY_LOCATION');
      let isSuccess: boolean = grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
      return isSuccess;
    } catch (err) {
      Log.error(TAG, `checkCameraAuth error: ${err.code}`);
      return false;
    }
  }

  // 查询用户是否授权相机开启地理位置权限,0 false 1 true  undefined不弹卡片
  private static getCameraLocationSwich(context: Context): string {
    try {
      return settings.getValueSync(context, CameraAuthLocationManager.CAMERA_LOCATION_SWITCH, 'undefined');
    } catch (err) {
      Log.error(TAG, `getCameraLocationSwich error: ${err.code}`);
      return 'undefined';
    }
  }

  // 查询点击相机授权地理位置信息卡片取消按钮时间
  private static async getCancelTime(context: Context, keyName: string): Promise<number> {
    let clickTime = 0;
    try {
      let result: string =
        await CameraAuthLocationManager.getDataCommon(context, keyName);
      if (result !== '') {
        clickTime = Number(result);
      }
    } catch (err) {
      Log.error(TAG, `getCancelTime error code is: ${err.code}, message is: ${err.message}`);
    }
    return clickTime;
  }

  private static async getDataCommon(context: Context, keyName: string): Promise<string> {

    try {
      return settings.getValueSync(context, keyName, '');
    } catch (err) {
      Log.error(TAG, `getDataCommon error: ${err.code}`);
      return '';
    }
  }

  // 点击取消按钮，更新取消时间
  private static setCancelTime(context: Context, keyName: string): void {
    Log.info(TAG, `setCancelTime ${keyName}`);
    let value: string = Date.now().toString();
    CameraAuthLocationManager.updateDataCommon(context, keyName, value);
  }

  private static updateDataCommon(context: Context, keyName: string, value: string): void {
    try {
      settings.setValueSync(context, keyName, value);
      return;
    } catch (err) {
      Log.error(TAG, `updateDataCommon error: ${err.code}`);
      return;
    }
  }

  // 获取弹出授权卡片次数
  private static async getPopCount(context: Context, keyName: string): Promise<number> {
    let count = 0;
    try {
      let result: string = await CameraAuthLocationManager.getDataCommon(context, keyName);
      if (result.trim() !== '') {
        const parsed = Number(result.trim());
        if (!isNaN(parsed)) {
          count = parsed;
        }
      }
      Log.info(TAG, `getTimelinePopCount:${count} result:${result}`);
    } catch (err) {
      Log.error(TAG, `getTimelinePopCount error code is: ${err.code}, message is: ${err.message}`);
    }
    return count;
  }

  // 设置弹出授权卡片次数
  private static async setPopCount(context: Context, keyName: string, count: number): Promise<void> {
    Log.info(TAG, `setPopCount ${keyName} ${count}`);
    CameraAuthLocationManager.updateDataCommon(context, keyName, count.toString());
  }

  public static async getIsShowCameraAuthLocationCard(context: Context,
    from: CameraAuthLocationFromEnum): Promise<boolean> {
    let cameraSwitchStatus: string = CameraAuthLocationManager.getCameraLocationSwich(context);
    // 相机未启动过，不弹卡片
    if (cameraSwitchStatus === 'undefined') {
      Log.warn(TAG, 'getIsShowCameraAuthLocationCard cameraSwitchStatus undefined');
      return false
    }
    let cameraAuthStatus: boolean = await CameraAuthLocationManager.checkCameraAuth();
    Log.info(TAG, `getIsShowCameraAuthLocationCard SwitchStatus:${cameraSwitchStatus} ` +
      `AuthStatus:${cameraAuthStatus}`);
    // 相机已经授权时重置次数和时间
    if (cameraAuthStatus && cameraSwitchStatus === '1') {
      return false;
    }
    let lastCancelCardTime: number = 0;
    let cancelCardCount: number = 0;
    let nowTime: number = Date.now();
    let durationTime: number = 0;
    if (from === CameraAuthLocationFromEnum.TimeLine) {

      lastCancelCardTime =
        await CameraAuthLocationManager.getCancelTime(context, CameraAuthLocationManager.TIMELINE_CANCEL_TIME);
      durationTime= nowTime - lastCancelCardTime;

      cancelCardCount =
        await CameraAuthLocationManager.getPopCount(context, CameraAuthLocationManager.TIMELINE_SHOW_COUNT);


    } else if (from === CameraAuthLocationFromEnum.Browser) {
      lastCancelCardTime =
        await CameraAuthLocationManager.getCancelTime(context, CameraAuthLocationManager.BROWSER_CANCEL_TIME);
      durationTime= nowTime - lastCancelCardTime;

      cancelCardCount =
        await CameraAuthLocationManager.getPopCount(context, CameraAuthLocationManager.BROWSER_SHOW_COUNT);
    } else {
      Log.warn(TAG, 'getIsShowCameraAuthLocationCard from invalid');
      return false;
    }

    let isSatisfyPeriod: boolean = durationTime > CameraAuthLocationManager.SHOW_CARD_INTERVAL;

    Log.info(TAG, `getIsShowCameraAuthLocationCard cameraAuthStatus:${cameraAuthStatus} ` +
      `cameraSwitchStatus:${cameraSwitchStatus} lastCancelCardTime:${lastCancelCardTime} durationTime:${durationTime}` +
      ` cancelCardCount:${cancelCardCount} isSatisfyPeriod:${isSatisfyPeriod}`);

    if (!isSatisfyPeriod) {
      return false;
    }
    if (cancelCardCount === CameraAuthLocationManager.MAX_POPUP_COUNT) {
      Log.info(TAG, 'cancel 3 times');
      return false;
    }
    return true;
  }

  // 点击取消按钮，1、更新取消时间 2、更新取消次数
  public static async setCancel(context: Context, from: CameraAuthLocationFromEnum): Promise<void> {
    if (from === CameraAuthLocationFromEnum.TimeLine) {
      CameraAuthLocationManager.setCancelTime(context, CameraAuthLocationManager.TIMELINE_CANCEL_TIME);
      let count: number =
        await CameraAuthLocationManager.getPopCount(context, CameraAuthLocationManager.TIMELINE_SHOW_COUNT);
      Log.info(TAG, `setCancel Timeline count:${count}`);
      CameraAuthLocationManager.setPopCount(context, CameraAuthLocationManager.TIMELINE_SHOW_COUNT, ++count);
    } else if (from === CameraAuthLocationFromEnum.Browser) {
      CameraAuthLocationManager.setCancelTime(context, CameraAuthLocationManager.BROWSER_CANCEL_TIME);
      let count: number =
        await CameraAuthLocationManager.getPopCount(context, CameraAuthLocationManager.BROWSER_SHOW_COUNT);
      Log.info(TAG, `setCancel Browser count:${count}`);
      CameraAuthLocationManager.setPopCount(context, CameraAuthLocationManager.BROWSER_SHOW_COUNT, ++count);
    } else {
      Log.warn(TAG, 'setCancel from invalid');
    }
  }
}