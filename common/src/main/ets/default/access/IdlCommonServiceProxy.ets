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

import lazy IIdlCommonService, { ScenarioCallback } from './IIdlCommonService';
import lazy { rpc } from '@kit.IPCKit';
import lazy { Log } from '../utils/Log';
import lazy { ScenarioDefaultDataFactory } from './ScenarioDefaultDataFactory';

/**
 * TAG
 */
const TAG = 'IdlCommonServiceProxy';

/**
 * 云空间CommonService请求代理
 */
export default class IdlCommonServiceProxy implements IIdlCommonService {
  private proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  /**
   * 获取图库场景化数据
   */
  getGalleryScenarioOperation(params: string, callback: ScenarioCallback): void {
    if (params === undefined || callback === undefined) {
      Log.warn(TAG, 'getGalleryScenarioOperation params not exist');
      return;
    }
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeInterfaceToken(ScenarioDefaultDataFactory.GALLERY_INTERFACE_TOKEN);
    dataSequence.writeString(params);
    this.proxy.sendMessageRequest(IdlCommonServiceProxy.COMMAND_GET_GALLERY_SCENARIO_OPERATION, dataSequence,
      replySequence, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          if (errCodeVar !== 0) {
            callback(errCodeVar, '');
            return;
          }
          let returnValueVar = result.reply.readString();
          callback(errCodeVar, returnValueVar);
        } else {
          Log.error(TAG, `sendMessageRequest failed, errCode: ${result.errCode}`);
        }
      })
      .catch((e: Error) => {
        Log.error(TAG, `sendMessageRequest failed, message: ${e.message}`);
      })
      .finally(() => {
        dataSequence.reclaim();
        replySequence.reclaim();
      });
  }

  /**
   * 接口code
   */
  public static readonly COMMAND_GET_GALLERY_SCENARIO_OPERATION = 3;
}