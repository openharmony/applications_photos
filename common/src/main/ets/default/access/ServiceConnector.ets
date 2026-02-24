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
/* instrument ignore file*/
import lazy { common } from '@kit.AbilityKit';
import lazy { Log } from '../utils/Log';
import lazy IdlCommonServiceProxy from './IdlCommonServiceProxy';
import lazy { BusinessError } from '@kit.BasicServicesKit';

/**
 * 绑定服务名
 */
const SERVICE_ABILITY_NAME = 'CommonServiceAbility';

/**
 * 云空间包名
 */
const APP_PACKAGE_NAME = 'com.ohos.clouddrive'

/**
 * TAG
 */
const TAG = 'ServiceConnector'

/**
 * ServiceConnector
 */
export default class ServiceConnector {
  /**
   * 绑定服务ID
   */
  public connectionId = -1;
  /**
   * 上下文
   */
  public context: common.UIAbilityContext;
  /**
   * 请求参数
   */
  public proxy: IdlCommonServiceProxy | undefined;
  /**
   * 连接参数
   */
  public options: common.ConnectOptions;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
    this.options = {
      // 连接成功回调
      onConnect: (elementName, proxy): void => {
        Log.info(TAG, 'cloudDrive commonService onConnect success');
        this.proxy = new IdlCommonServiceProxy(proxy);
      },
      onDisconnect: (): void => {
        Log.info(TAG, 'cloudDrive commonService onDisconnect');
        this.proxy = undefined;
      },
      onFailed: (): void => {
        Log.warn(TAG, 'cloudDrive commonService onFailed');
        this.proxy = undefined;
      }
    }
  }

  /**
   * 连接服务, 默认最多等待20x30ms
   */
  async connectServiceExtAbility(retryLimit: number = 20): Promise<IdlCommonServiceProxy | undefined> {
    Log.info(TAG, 'connect cloudDrive commonService');
    const want: Want = {
      bundleName: APP_PACKAGE_NAME,
      abilityName: SERVICE_ABILITY_NAME,
    }
    this.connectionId = this.context.connectServiceExtensionAbility(want, this.options);
    Log.info(TAG, `connectService connectionId: ${this.connectionId}`);
    // 重试次数
    let retryCount = 0;
    while (this.proxy == null) {
      Log.info(TAG, `connectService retry:${retryCount}`);
      retryCount++;
      if (retryCount >= retryLimit) {
        break;
      }
      await this.delayGet();
    }
    return this.proxy;
  }

  /**
   * 断连服务
   * @param callback
   */
  disconnectServiceExtAbility(): void {
    Log.info(TAG, 'disConnect cloudDrive commonService');
    this.context.disconnectServiceExtensionAbility(this.connectionId).then(() => {
      Log.info(TAG, 'disConnect success');
    }).catch((err: BusinessError) => {
      Log.error(TAG, `disConnect failed, code ${err.code} message ${err.message}`);
    })
  }

  /**
   * 延迟间隔 30ms
   */
  async delayGet(): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, 30));
  }
}