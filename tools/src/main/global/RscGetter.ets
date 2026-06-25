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
import lazy { resourceManager } from '@kit.LocalizationKit';
import lazy { Log } from '../utils/Log';
import lazy Rsc from './RscString';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'tools_RscGetter';

/**
 * 使用前先初始化当前页面的RscGetter:
 * const rsc: RscGetter = new RscGetter(getContext().resourceManager);
 * 在任何地方调用都应该传入当前页面的getContext().resourceManager
 */
export default class RscGetter {
  private mgr: resourceManager.ResourceManager;

  /**
   * 传入 getContext().resourceManager
   */
  constructor(mgr: resourceManager.ResourceManager) {
    this.mgr = mgr;
  }

  /**
   * 后续如果出现此接口的返回为'',可通过错误信息，错误码进行确定问题原因
   * 增加捕获异常可避免jsCrash
   * @param rsc
   * @returns
   */
  public getString(rsc: Resource): string {
    try {
      return this.mgr.getStringSync(rsc.id);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Log.debug(TAG, `getStringSync failed, error code: ${code}, message: ${message}.`);
      return '';
    }
  }

  public toString(rsc?: Resource | string): string {
    if (!rsc) {
      return '';
    }
    if (typeof rsc === 'string') {
      return rsc;
    }
    return this.getString(rsc);
  }

  public getNumber(rsc: Resource): number {
    return this.mgr.getNumber(rsc.id);
  }

  public extractNumber(rsc: Resource): number {
    const rscString = this.mgr.getStringSync(rsc.id);
    return Rsc.extractNumber(rscString);
  }

  public getColor(rsc: Resource): number {
    return this.mgr.getColorSync(rsc.id);
  }
}
