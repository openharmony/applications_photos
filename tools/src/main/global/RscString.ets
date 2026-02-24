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

import type { resourceManager } from '@kit.LocalizationKit';
import lazy { global } from './Contexts';
import lazy { Log } from '../utils/Log';
import type common from '@ohos.app.ability.common';
/* instrument ignore file  */
/**
 *
 * 在任何地方调用都应该传入当前页面的getContext().resourceManager
 */
export namespace Rsc {
  export type Manager = resourceManager.ResourceManager;

  export function getString(rsc: Resource, rscMgr: Manager = getManager()): string {
    if (rsc.moduleName === 'browserlibrary') {
      return getManager(rscMgr, 'photoLibraryContext')?.getStringSync(rsc.id);
    }
    return getManager(rscMgr)?.getStringSync(rsc.id);
  }

  export function toString(rsc?: Resource | string, rscMgr: Manager = getManager()): string {
    if (!rsc) {
      return '';
    }
    if (typeof rsc === 'string') {
      return rsc;
    }
    return getString(rsc, rscMgr);
  }

  export function toPxStr(num: number): string {
    return String(num).concat('px');
  }

  export function extractNumber(rscString: string): number {
    const withoutUnit = Number(rscString.substring(0, rscString.length - 2));
    if (!Number.isFinite(withoutUnit)) {
      Log.fatal(rscString, 'is not a number with unit');
    }
    return withoutUnit;
  }

  function getManager(rscMgr?: Manager, src?: string): Manager {
    if (src === 'photoLibraryContext') {
      return LocalStorage.getShared()?.get<common.UIAbilityContext>(src)?.resourceManager as Manager;
    }
    if (rscMgr) {
      return rscMgr;
    }
    if (typeof getContext === 'function') {
      return getContext?.()?.resourceManager || global.uiAbilityContext().resourceManager;
    }
    return global.uiAbilityContext().resourceManager;
  }
}

export default Rsc;