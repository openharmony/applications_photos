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

import lazy { Log } from './Log';
import type common from '@ohos.app.ability.common';
import lazy { ConfigurationConstant, EnvironmentCallback } from '@kit.AbilityKit';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'common_EnvironmentHelper';

export interface ConfigurationChangeListener {
  onConfigurationUpdated: (oldConfig: Configuration | undefined, newConfig: Configuration) => void;
}

export class EnvironmentHelper {
  private static instance: EnvironmentHelper | undefined = undefined;
  private currentConfig: Configuration | undefined = undefined;
  private listeners: ConfigurationChangeListener[] = [];

  private constructor() {
  }

  public static getInstance(context: Context | undefined): EnvironmentHelper | undefined {
    if (EnvironmentHelper.instance) {
      return EnvironmentHelper.instance;
    }

    if (!context || !context.getApplicationContext()) {
      Log.warn(TAG, 'invalid context');
      return undefined;
    }

    let instance: EnvironmentHelper = new EnvironmentHelper();
    let envCallback: EnvironmentCallback = {
      onConfigurationUpdated(config: Configuration) {
        let oldConfig: Configuration | undefined = instance.currentConfig;
        AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode', config.colorMode);
        let msg: string[] = [`onConfigurationUpdated lang: ${oldConfig?.language}->${config.language}`];
        msg.push(`colorMode: ${oldConfig?.colorMode}->${config.colorMode}`);
        msg.push(`direction: ${oldConfig?.direction}->${config.direction}`);
        msg.push(`fontSize: ${oldConfig?.fontSizeScale}->${config.fontSizeScale}`);
        msg.push(`fontWeight: ${oldConfig?.fontWeightScale}->${config.fontWeightScale}`);
        Log.info(TAG, msg.join(', '));
        instance.currentConfig = config;
        EnvironmentHelper.instance?.listeners.forEach((listener: ConfigurationChangeListener) => {
          listener.onConfigurationUpdated(oldConfig, config);
        });
      },

      onMemoryLevel(level) {
        Log.info(TAG, `onMemoryLevel level: ${level}`);
      },
    };
    try {
      let applicationContext: common.ApplicationContext = context.getApplicationContext();
      let callbackId: number = applicationContext.on('environment', envCallback);
      Log.info(TAG, `callbackId: ${callbackId}`);
      EnvironmentHelper.instance = instance;
      return instance;
    } catch (paramError) {
      Log.error(TAG, `error: ${(paramError as BusinessError).code}, ${(paramError as BusinessError).message}`);
      return undefined;
    }
  }

  public addListener(listener: ConfigurationChangeListener): void {
    if (!listener || this.listeners.indexOf(listener) >= 0) {
      return;
    }
    this.listeners.push(listener);
  }

  public removeListener(listener: ConfigurationChangeListener): void {
    if (!listener) {
      return;
    }
    let index: number = this.listeners.indexOf(listener);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }
}