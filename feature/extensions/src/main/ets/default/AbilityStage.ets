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

import lazy AbilityStage from '@ohos.app.ability.AbilityStage';
import lazy { Configuration, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PafUiWidget } from '@ohos/privacy/src/main/ets/about/consent/PafUiWidget';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { accessibility } from '@kit.AccessibilityKit';
import lazy {
  Constants as PhotoConstants,
  LargePictureBrowsingStatus
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy settings from '@ohos.settings';

const TAG = 'SharedAbilityStage';

export default class SharedAbilityStage extends AbilityStage {
  private accessibilityStateChangeFunc: (state: boolean) => void =
    (state: boolean) => this.accessibilityStateChange(state);

  private accessibilityStateChange(state: boolean): void {
    Log.warn(TAG, `accessibilityStateChange:${state},${accessibility.isOpenTouchGuideSync()}`);
    AppStorage.setOrCreate<boolean>('isOpenTouchGuide', state);
  }
  onCreate(): void {
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode', this.context.config.colorMode);
    AppStorage.setOrCreate<number>('currentFontSizeScale', this.context.config.fontSizeScale);
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('paf.currentColorMode', this.context.config.colorMode)
    AppStorage.setOrCreate<Context>('photosGlobalContext', this.context);
    AppStorage.setOrCreate<number>('fontSizeScale', this.context.config.fontSizeScale);
    AppStorage.setOrCreate<boolean>('isOpenTouchGuide', accessibility.isOpenTouchGuideSync());
    Log.info(TAG, `AbilityStage onCreate currentColorMode: ${this.context.config.colorMode}`);
    Log.info(TAG, `AbilityStage onCreate currentFontSizeScale: ${this.context.config.fontSizeScale}`);
    accessibility.on('accessibilityStateChange', this.accessibilityStateChangeFunc);
    //是否开启触摸浏览功能
    AppStorage.setOrCreate<boolean>('touchGuideState', accessibility.isOpenTouchGuideSync());
    accessibility.on('touchGuideStateChange', (state: boolean) => {
      Log.info(TAG, `touchGuideStateChange ${state}`)
      AppStorage.setOrCreate<boolean>('touchGuideState', state);
    });

    // 设置pc热启动
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      let applicationContext = this.context.getApplicationContext();
      try {
        applicationContext.setSupportedProcessCache(true);
      } catch (error) {
        let code = (error as BusinessError).code;
        let message = (error as BusinessError).message;
        Log.info(TAG, `abilitystage setSupported returns code ${code}, returns msg ${message}`)
      }
    }
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    AppStorage.setOrCreate<ConfigurationConstant.ColorMode>('currentColorMode', newConfig.colorMode);
    AppStorage.setOrCreate<number>('currentFontSizeScale', newConfig.fontSizeScale);
    AppStorage.setOrCreate<string>('currentLanguage', newConfig.language);
    AppStorage.setOrCreate<number>('fontSizeScale', newConfig.fontSizeScale);
    Log.info(TAG, `AbilityStage onConfigurationUpdate currentColorMode: ${newConfig.colorMode}`);
    Log.info(TAG, `AbilityStage onConfigurationUpdate currentFontSizeScale: ${newConfig.fontSizeScale}`);
    AppStorage.setOrCreate<boolean>('isOpenTouchGuide', accessibility.isOpenTouchGuideSync());
    // if (!PafUiWidget.configurationUpdate) {
    //   Log.error(TAG, `Ability onConfigurationUpdate func:${PafUiWidget
    //     .configurationUpdate} name:${PafUiWidget.configurationUpdate?.name}`);
    //   return;
    // }
    // PafUiWidget.configurationUpdate(newConfig);
    Log.info(TAG, `Ability onConfigurationUpdate language:${newConfig.language}`);
    Log.info(TAG, `Ability onConfigurationUpdate fontSizeScale:${AppStorage.get<number>('fontSizeScale')}`);
  }

  onDestroy(): void {
    Log.info(TAG, 'AbilityStage onDestroy, close listeners.');
    accessibility.off('accessibilityStateChange');
    accessibility.off('touchGuideStateChange');
    if (DeviceInfo.isPc()) {
      let context: Context = getContext(this);
      if (context) {
        try {
          let isSuccess: boolean = settings.setValueSync(context, PhotoConstants.LARGE_PICTURE_BROWSING_STATUS,
            LargePictureBrowsingStatus.ZERO);
          Log.info(TAG, `set large_picture_browsing_status: 0, isSuccess: ${isSuccess}`);
        } catch (err) {
          Log.error(TAG, `set large_picture_browsing_status: 0, error, message: ${err?.message }, code: ${err?.code}`);
        }
      }
    }
  }
}