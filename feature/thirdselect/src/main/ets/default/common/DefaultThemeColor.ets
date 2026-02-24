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
import lazy { CustomColors, CustomTheme } from '@ohos.arkui.theme';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'DefaultThemeColor';

export class DefaultThemeColor implements CustomColors {
  public static defaultThemeColor(): CustomColors {
    return {
      fontPrimary: $r('sys.color.ohos_id_color_text_primary_activated'),
      fontEmphasize: $r('sys.color.icon_emphasize'),
      compBackgroundEmphasize: $r('sys.color.comp_background_emphasize'),
    };
  }

  public static getCustomTheme(customColor: CustomColors | undefined): CustomTheme {
    if (customColor === undefined) {
      customColor = DefaultThemeColor.defaultThemeColor();
    } else {
      if (customColor.fontPrimary === undefined) {
        customColor.fontPrimary = $r('sys.color.ohos_id_color_text_primary_activated');
      }
      if (customColor.compBackgroundEmphasize === undefined) {
        customColor.fontEmphasize = $r('sys.color.icon_emphasize');
      }
      if (customColor.compBackgroundEmphasize === undefined) {
        customColor.compBackgroundEmphasize = $r('sys.color.comp_background_emphasize');
      }
    }
    let customTheme: CustomTheme = { colors: customColor };
    return customTheme;
  }
}

