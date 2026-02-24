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

/* instrument ignore file */

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy settings from '@ohos.settings';
import lazy common from '@ohos.app.ability.common';
import lazy { DataStoreUtil } from '../../utils/DataStoreUtil';
import lazy { ValueType } from '@kit.ArkData';

const TAG: string = 'AIRetouchPrivacyManager';


export interface AiRetouchDataStore {
  key: string,
  value: ValueType,
}

export class AiRetouchPrivacyManager {
  private static readonly APP_KEY_AI_RETOUCH_PRIVACY_MANAGER = 'app_key_ai_retouch_privacy_manager';
  private static readonly privacyAgreementVersion: string = '20230430';
  // 同意true 撤销false
  private static readonly KEY_AGREE_AI_RETOUCH_POLICY = 'key_need_agree_policy';
  // 同意app版本号
  private static readonly KEY_AGREE_APP_VERSION = 'agree_app_version';
  // 协议的版本号
  private static readonly AGREE_AI_RETOUCH_PRIVACY_VERSION = 'agree_ai_retouch_privacy_version';
  // 同意协议的时间
  private static readonly KEY_AGREE_TIME = 'agree_time';
  // 撤销同意记录时间
  private static readonly KEY_DISAGREE_TIME = 'disagree_time';
  // 撤销同意记录的隐私协议版本号
  private static readonly KEY_DISAGREE_PRIVACY_VERSION = 'disagree_privacy_version';
  // 撤销同意记录的app版本号
  private static readonly KEY_DISAGREE_APP_VERSION = 'disagree_app_version';
  private startTime = new Date().getTime();
  public customCallback?: (agree: boolean, msg?: string) => void;
  public signCallback?: (agree: boolean) => Promise<boolean>;

  constructor() {
  }

  setCustomCallback(callback: (agree: boolean, msg?: string) => void): void {
    this.customCallback = callback;
  }

  setSignCallback(callback: (agree: boolean) => Promise<boolean>): void {
    this.signCallback = callback;
  }

  public static getInstance(): AiRetouchPrivacyManager {
    let instance: AiRetouchPrivacyManager | undefined =
      AppStorage.get(AiRetouchPrivacyManager.APP_KEY_AI_RETOUCH_PRIVACY_MANAGER);
    if (instance === undefined) {
      instance = new AiRetouchPrivacyManager();
      AppStorage.setOrCreate(AiRetouchPrivacyManager.APP_KEY_AI_RETOUCH_PRIVACY_MANAGER, instance);
    }
    let manager: AiRetouchPrivacyManager = instance;
    return manager;
  }

  /**
   * 同意、撤销授权数据持久化
   *
   * @param isAiRetouchProtocolFlag 同意状态
   */
  agreeRevokeDataStore(isAiRetouchProtocolFlag: boolean): void {
    let dataStoreList: AiRetouchDataStore[] = [{
      key: AiRetouchPrivacyManager.KEY_AGREE_AI_RETOUCH_POLICY,
      value: isAiRetouchProtocolFlag,
    }, {
      key: isAiRetouchProtocolFlag ?
      AiRetouchPrivacyManager.KEY_AGREE_TIME : AiRetouchPrivacyManager.KEY_DISAGREE_TIME,
      value: this.startTime,
    }, {
      key: isAiRetouchProtocolFlag ? AiRetouchPrivacyManager.AGREE_AI_RETOUCH_PRIVACY_VERSION :
      AiRetouchPrivacyManager.KEY_DISAGREE_PRIVACY_VERSION,
      value: AiRetouchPrivacyManager.privacyAgreementVersion,
    }, {
      key: isAiRetouchProtocolFlag ? AiRetouchPrivacyManager.KEY_AGREE_APP_VERSION :
      AiRetouchPrivacyManager.KEY_DISAGREE_APP_VERSION,
      value: this.getAppVersion(),
    }];
    dataStoreList.forEach((item: AiRetouchDataStore) => {
      this.isTipsPermanentSet(item);
    });
  }

  /**
   * 获取应用版本号
   * @returns
   */
  getAppVersion(): string {
    let bundleInfo: bundleManager.BundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    return bundleInfo.versionName;
  }

  /**
   * 数据持久化
   *
   * @param isAiRetouchProtocolFlag
   * @returns
   */
  public async isTipsPermanentSet(row: AiRetouchDataStore): Promise<void> {
    Log.debug(TAG, `isTipsPermanentSet ${row}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    await dataStore.putData(row.key, row.value);
    await dataStore.flush();
  }

  /**
   * 修图服务开关存储到系统设置
   *
   * @param context
   * @param isAiRetouchProtocolFlag
   */
  setProtocolSystemSettings(context: common.Context, isAiRetouchProtocolFlag: boolean): void {
    try {
      settings.setValueSync(context, 'persist.aiRetouch.protocol.enable', isAiRetouchProtocolFlag.toString());
    } catch (err) {
      Log.error(TAG, `Set persist.photos.protocol.enable error: ${err}`);
    }
  }

  /**
   * 获取修图协议的签署
   *
   * @param context
   * @param isAiRetouchProtocolFlag
   */
  public getProtocolSystemSettings(ctx: common.Context): boolean {
    let value = settings.getValueSync(ctx, 'persist.aiRetouch.protocol.enable', 'false');
    Log.info(TAG, `get persist.photos.protocol.enable: ${value}`);
    return value === 'true';
  }

  /**
   * 获取用户同意的隐私协议版本
   * @returns
   */
  public async isPrivacyAgreementVersion(): Promise<string> {
    return await DataStoreUtil.getInstance()
      .getData(AiRetouchPrivacyManager.AGREE_AI_RETOUCH_PRIVACY_VERSION, '') as string;
  }
}