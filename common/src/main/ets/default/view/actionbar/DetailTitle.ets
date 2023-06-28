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

const TAG: string = 'common_DetailTitle';

// Large picture title, including primary date title and secondary time and place title
@Component
export struct DetailTitle {
  @Consume('dateTitle') title: string;
  @Consume('timeLocationTitle') subTitle: string;
  isVideoPage: boolean = false;

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(ActionBarProp.TITLE_TEXT_SIZE)
          .fontColor(this.isVideoPage ? $r('app.color.white') : ActionBarProp.NORMAL_TEXT_COLOR)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .key('PhotoBrowserDateTitle')
        Text(this.subTitle)
          .fontSize(ActionBarProp.SUBTITLE_TEXT_SIZE)
          .fontFamily(ActionBarProp.REGULAR_FONT)
          .fontColor(this.isVideoPage ? $r('app.color.white') : ActionBarProp.NORMAL_SUBTITLE_TEXT_COLOR)
          .maxLines(1)
          .lineHeight(18)
          .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .key('PhotoBrowserTimeLocationTitle')
      }
      .constraintSize({ minHeight: 48 })
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Center)
  }

  private onBuildDone(): void {
    Log.debug(TAG, `onBuildDone, title: ${this.title}, subTitle: ${this.subTitle}`)
  }
}