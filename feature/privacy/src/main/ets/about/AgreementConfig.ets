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

import lazy common from '@ohos.app.ability.common';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy window from '@ohos.window';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy { Routers } from '@ohos/tools/src/main/global/pages/Routers';
import lazy { Privacy, Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { PageTitle } from '@ohos/tools/src/main/global/pages/PageTitle';
import lazy { PermissionPopup } from './consent/PermissionPopup';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy settings from '@ohos.settings';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

/* instrument ignore file */
const TAG: string = 'AgreementConfig';
const CLIENT_NAME: string = 'photos';

// 业务自己适配的接口
export namespace AgreementConfig {
  const PERMISSION_AGREED = 'PERMISSION_AGREED';
  const AGREEMENT_RECORDS = 'AGREEMENT_RECORDS';

  export let context: common.Context;

  export let windowStage: window.WindowStage | undefined;

  export function hasAgreed(): boolean {
    let agreed = Protocol.get<boolean>(PERMISSION_AGREED, false);
    Log.warn(TAG, `hasAgreed Type: ${agreed}`);
    return agreed;
  }

  // 设置自定义协议号
  export function getCustomAgreementTypes(protocol: number): Set<number> {
    const agreementTypes: Set<number> = new Set();
    agreementTypes.add(
      protocol
    );
    return agreementTypes;
  }

  /**
   * 撤销同意记录，是否有本地或服务器上有存储记录。包含时间、同意还是拒绝、隐私声明版本号、应用版本号
   * @param agreed 同意还是拒绝
   */
  export async function setAgreed(agreed: boolean): Promise<void> {
    AppStorage.setOrCreate(PERMISSION_AGREED, false);
    Protocol.set(PERMISSION_AGREED, agreed);
    Log.info(TAG, `Succeeded in putting the value of '${PERMISSION_AGREED}'.`);
    const agreeRecord: PermissionPopup.AgreeRecord = {
      time: new Date(),
      agreed: agreed,
      privacyStatementVer: Bundles.getInfo().name,
      appVer: Bundles.getInfo().versionName,
    };
    Protocol.set(AGREEMENT_RECORDS, agreeRecord)
    Log.warn(TAG, `PafAgreement revoke onSuccess ${agreed}`);
  }

  //签署协议
  // export class SignCallback implements CallBack {
  //   //成功
  //   public onSuccess(): void {
  //     Log.warn(TAG, 'PafAgreement sign onSuccess');
  //   }
  //
  //   //失败
  //   public onFailure(code: number, detail: string): void {
  //     Log.error(TAG, `PafAgreement sign onFailure: code:${code}, detail:${detail}`)
  //   }
  // }

  //撤销协议
  // export class RevokeCallback implements CallBack {
  //   //成功
  //   onSuccess(): void {
  //     Log.warn(TAG, 'PafAgreement revoke onSuccess');
  //   }
  //
  //   //失败
  //   onFailure(code: number, detail: string): void {
  //     Log.error(TAG, `PafAgreement revoke onFailure: code:${code}, detail:${detail}`);
  //   }
  // }

  //查询协议记录
  // export class QueryCallback implements QueryCallBack {
  //   // 失败
  //   public onFailure(code: number, detail: string): void {
  //     Log.error(TAG, `PafAgreement query onFailure: code:${code}, detail:${detail}`);
  //   }
  //
  //   // 弹儿童长大通知处理
  //   public popupChildGrowUp(): void {
  //     Log.info(TAG, 'PafAgreement QueryCallback popupChildGrowUp');
  //   }
  //
  //   // 弹权限启动页
  //   public popupPermission(): void {
  //     // 获取是否同意过欢迎页面
  //     let isProtocolAgreed = Protocol.get<boolean>(PERMISSION_AGREED, false);
  //     Log.debug(TAG, `isAgreed Protocol:${isProtocolAgreed}`)
  //     if (isProtocolAgreed) {
  //       Log.info(TAG, 'Permission is agreed, intercept the welcome page.');
  //       return;
  //     }
  //     Routers.softReplace(PageTitle.permissionNormal)
  //     Log.info(TAG, 'PafAgreement QueryCallback popupPermission, pull the welcome page.');
  //   }
  //
  //   // 弹协议更新
  //   public popupUpdate(): void {
  //     Log.info(TAG, 'PafAgreement QueryCallback popupUpdate');
  //   }
  //
  //   //用来判断签署的状态
  //   public popupNoUpdate(): void {
  //     Log.info(TAG, 'PafAgreement QueryCallback popupNoUpdate');
  //   }
  //
  //   //更新但不需要签署协议
  //   public popupUpdateNoResign(): void {
  //     Log.info(TAG, 'PafAgreement popupUpdateNoResign');
  //   }
  //
  //   //进入主页
  //   public loadMainPage(): void {
  //     Log.info(TAG, 'PafAgreement loadMainPage');
  //   }
  // }

  //客户端信息（APP版本信息）
  // export async function clientInfo(): Promise<PafClientInfo> {
    // let deviceType: DeviceType = DeviceType._2in1_;
    // if (DeviceInfo.isPhoneUx()) {
    //   deviceType = DeviceType.PHONE;
    // } else if (DeviceInfo.isPcOrTablet()) {
    //   deviceType = DeviceType.PAD;
    // }
    // let aaid: string = '';
    // try {
    //   Log.info(TAG, 'clientInfo getAAID start');
    //   aaid = await DeviceInfo.getAAID();
    // } catch (e) {
    //   Log.error(TAG, 'clientInfo error: %s', e);
    // } finally {
    //   Log.info(TAG, 'clientInfo getAAID finished');
    // }
    // let info: PafClientInfo = {
    //   name: CLIENT_NAME, // 客户端名称
    //   version: Bundles.getInfo().versionName, //客户端版本
    //   aaid: aaid, //客户端aaid，用于标识当前客户端，客户端卸载后该值会变化，UUID格式
    //   deviceId: DeviceInfo.getODID(), //当前设备Id
    //   deviceIdType: DeviceIdType.ODID, //设备Id类型: UDID = 1, ODID = 8
    //   deviceType, //设备类型: PHONE = 0,WATCH = 1,TV = 2,PC = 3,PAD = 4,SPEAKER = 5,_2in1_ = 6
    //   agreementConfigPath: 'consent/agreement_config.json',
    //   // extendOption: new consent.ExtendOption()
    // };
    // Log.info(TAG, 'get clientInfo end');
    // return info;
  // }

  // 客户端信息
  // export async function getClientInfo(): Promise<ClientInfo> {
  //   let deviceType: ClientDeviceType = ClientDeviceType._2in1_;
  //   if (DeviceInfo.isPhoneUx()) {
  //     deviceType = ClientDeviceType.PHONE;
  //   } else if (DeviceInfo.isPcOrTablet()) {
  //     deviceType = ClientDeviceType.PAD;
  //   }
  //   let info: ClientInfo = new ClientInfo();
  //   info.name = CLIENT_NAME;
  //   info.version = Bundles.getInfo().versionName;
  //   info.aaid = DeviceInfo.getAAID;
  //   info.deviceId = DeviceInfo.getODID;
  //   info.deviceIdType = 1;
  //   info.deviceType = deviceType;
  //   Log.info(TAG, 'getClientInfo end');
  //   return info;
  // }

  // 设置欢迎页隐私声明和用户协议标识(仅需要签署协议的涉及)
  export function getAgreementTypes(): Set<number> {
    const agreementTypes: Set<number> = new Set();
    agreementTypes.add(
      DeviceInfo.isTv() ? Privacy.PRIVACY_PROTOCOL_TV :
        (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL)
    );
    agreementTypes.add(
      Privacy.CLOUD_ENHANCE_PRIVACY_PROTOCOL
    );
    return agreementTypes;
  }
}
