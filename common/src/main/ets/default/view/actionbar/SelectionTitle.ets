/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { ActionBarColorMode, ActionBarSelectionMode } from '../browserOperation/ActionBarMode';
import { Log } from '../../utils/Log';
import { ActionBarProp } from '../browserOperation/ActionBarProp';

const TAG: string = 'common_SelectionTitle';

// Select the mode title, the content changes with the number of selections
@Component
export struct SelectionTitle {
  @Link actionBarProp: ActionBarProp;
  @Consume('selectedCount') count: number;

  build() {
    Row() {
      Text(!this.actionBarProp.getIsNeedTitle() ? '' : (this.actionBarProp.getSelectionMode() == ActionBarSelectionMode.MULTI ?
        (this.count <= 0 ? ActionBarProp.MULTI_UNSELECT_TITLE :
          (this.actionBarProp.getMaxSelectCount() > 0 ?
          ActionBarProp.getCountDetailExternalSelectedTitle(this.count,
            this.actionBarProp.getMaxSelectCount()) :
          ActionBarProp.getCountDetailSelectedTitle(this.count))) :
      ActionBarProp.SINGLE_UNSELECT_TITLE))
        .fontSize(ActionBarProp.TITLE_TEXT_SIZE)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.actionBarProp.getColorMode() == ActionBarColorMode.TRANSPARENT ?
        ActionBarProp.TRANSPARENT_TEXT_COLOR : ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .key('SelectionTitleText')
    }
    .alignItems(VerticalAlign.Center)
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, count: ${this.count}`)
  }
}