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

import { Drv } from './Drv.test';
import { TestConstants } from './TestConstants';
import { Component, ON, UiDirection, WindowMode } from '@kit.TestKit';
import { expect } from '@ohos/hypium';
import { DELAY } from './Config.test';
import { PageTitle } from '../../main/global/pages/PageTitle';

export class MustAt extends Drv {
  /**
   * 确认当前处于大图页
   */
  public async mustAtBrowser() {
    await this.assertComponent(PageTitle.index);
    await this.assertComponent('browser_ActionBarView');
    await this.assertComponent('DetailMenuPanel');
    await this.assertComponent('photoItem_Column');
    await this.assertComponent('special_stack');
    await this.assertComponent('PhotoBrowserDateTitle');
    await this.assertComponent('PhotoBrowserTimeLocationTitle');
    await this.assertComponent('More_Image_More');
    await this.assertComponent('PhotoBrowserActionBarButtonBack');
    await this.assertComponent('AccessibilityComponent_BrowserBack');
  }

  /**
   * 确认当前处于宫格页
   */
  public async mustAtTimeline() {
    await this.assertComponentByText('年');
    await this.assertComponentByText('月');
    await this.assertComponentByText('日');
  }
}