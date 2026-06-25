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
import { DeviceUtil } from '../../../common/util/DeviceUtil'
import { BaseEditor, TabName } from '../../App'
import { Asset } from '../../BaseEditor'

@Observed
export class MenuAttr {
  public editor: BaseEditor;
  public asset: Asset;
  public changeTabIndex: TabName = DeviceUtil.isPhone() || DeviceUtil
    .isPad() ? TabName.TabCrop : TabName.TabAdjust

  constructor(editor: BaseEditor, asset: Asset) {
    this.editor = editor;
    this.asset = asset;
  }

  enterMenu() {
    this.editor.setLastEditStatus();
  }

  changeMenuAnimate(index: TabName) {
    this.editor.tabIndex = index;
  }

  leaveMenu(index: TabName, close = false): Promise<void> | void {
  }
}