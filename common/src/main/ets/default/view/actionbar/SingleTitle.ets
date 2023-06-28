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

import { Log } from '../../utils/Log';
import { ActionBarProp } from '../browserOperation/ActionBarProp';

const TAG: string = 'common_SingleTitle';

// Single line title, fixed content
@Component
export struct SingleTitle {
  @Link actionBarProp: ActionBarProp;

  build() {
    Row() {
      Text(this.actionBarProp.getTitle())
        .fontSize(this.actionBarProp.getIsHeadTitle()
          ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : ActionBarProp.TITLE_TEXT_SIZE)
        .fontWeight(FontWeight.Medium)
        .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .key('SingleTitleText')
    }
    .alignItems(VerticalAlign.Center)
    .flexGrow(1)
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, title: ${this.actionBarProp.getTitle()}`)
  }
}