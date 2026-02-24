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

import lazy { ActionBarProp } from '../browserOperation/ActionBarProp';
import lazy { Action } from '../browserOperation/Action';
import lazy { Log } from '../../utils/Log';
import lazy { SelectManager } from '../../model/browser/SelectManager';

const TAG: string = 'VideoCleanUpPageActionBar';

/**
 * 视频清理的actionBar，
 * 防止两个selectedCount重名
 */
@Component
export struct VideoCleanUpPageActionBar {
  @Link actionBarProp: ActionBarProp;
  @Watch('selectCountChange') @Link selectItemCount: number;
  @Provide selectedCount: number = 0;
  private onMenuClicked: Function = (action: Action): void => {
  };
  @Prop selectedManager: SelectManager;
  @Prop actionMoreMenuList: Action[] = [];
  @State private isNeedPlaceholder: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
  }

  selectCountChange(): void {
    Log.debug(TAG, `selectCountChange ${this.selectedCount}`);
    this.selectedCount = this.selectItemCount;
  }

  build() {
    // ActionBar({
    //   actionBarProp: this.actionBarProp,
    //   onMenuClicked: this.onMenuClicked,
    //   isNeedPlaceholder: this.isNeedPlaceholder,
    //   actionMoreMenuList: this.actionMoreMenuList,
    // })
  }
}