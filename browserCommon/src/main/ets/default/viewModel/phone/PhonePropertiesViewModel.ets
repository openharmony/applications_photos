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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PropertiesViewModel } from '../base/PropertiesViewModel';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { PropertiesConfig } from '../base/PropertiesConfig';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { PhonePropertiesConfig } from './PhonePropertiesConfig';

/* instrument ignore file */
const TAG = 'PropertiesViewModel';

export class PhonePropertiesViewModel extends PropertiesViewModel {
  public config: PropertiesConfig;

  constructor() {
    super()
    this.config = this.initConfig();
  }

  private initConfig(): PropertiesConfig {
    /* instrument ignore next */
    return new PhonePropertiesConfig();
  }

  // 计算人像大小
  public getOneThirdItemWidth(imageFaceDataSize: number): Length {
    // 手机或PAD，人像大于3时横向滚动，大小固定
    if (imageFaceDataSize > Constants.PORTRAIT_OPTIONS_COUNT) {
      return $r('app.float.portrait_probably_is_me_dialog_image_width');
    }
    return super.getOneThirdItemWidth(imageFaceDataSize);
  }
}