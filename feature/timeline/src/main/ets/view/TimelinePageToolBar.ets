/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Action, Log } from '@ohos/common';
import { ToolBar } from '@ohos/common/CommonComponents';

const TAG: string = 'timeline_TimelinePageToolBar';

@Component
export struct TimelinePageToolBar {
  @Consume @Watch('updateToolbar') isSelectedMode: boolean;
  @Consume @Watch('updateToolbar') isAllSelected: boolean;
  @Link @Watch('updateToolbar') totalSelectedCount: number;
  @Provide selectedCount: number = 0;
  onMenuClicked: Function = (): void => {};
  @Provide toolMenuList: Action[] = [];
  @Consume moreMenuList: Action[];
  @Consume hidePopup: boolean;

  aboutToAppear(): void {
    this.updateToolbar();
  }

  build() {
    ToolBar({
      onMenuClicked: this.onMenuClicked
    })
  }

  private updateToolbar(): void {
    Log.info(TAG, 'updateToolbar');
    this.selectedCount = this.totalSelectedCount;
    if (this.isSelectedMode) {
      Log.info(TAG, 'pushActionToolbar');
      this.toolMenuList = [];
      this.toolMenuList.push(
        this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL,
        Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
    }
  }
}