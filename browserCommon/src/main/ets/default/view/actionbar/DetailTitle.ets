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
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';

const TAG: string = 'common_DetailTitle';

/**
 * 默认行高
 */
const DEFAULT_LINE_HEIGHT: number = 18;

/**
 * 标题最小行高
 */
const TITLE_MIN_HEIGHT: number = 48;

/**
 * 标题跟工具栏的最小距离
 */
const TITLE_MIN_MARGIN_TOOLBAR: number = 16;

const TITLE_LINE_HEIGHT_FOR_TV: number = 47;

/**
 * 用于大图显示，包含日期、时间、地点信息
 */
@Component
export struct DetailTitle {
  @Consume('dateTitle') title: string;
  @Consume('timeLocationTitle') subTitle: string;

  @Builder
  browserTitleForTv() {
    Text(this.title)
      .draggable(false)
      .fontSize(40)
      .fontColor('#E6FFFFFF')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Medium)
      .lineHeight(TITLE_LINE_HEIGHT_FOR_TV)
      .height($r('app.float.tv_sidebar_text_height'))
      .margin({ top: $r('app.float.tv_sidebar_button_padding'), })
  }

  build() {
    Row() {
      Column() {
        /* instrument ignore next */
        if (DeviceInfo.isTv()) {
          this.browserTitleForTv();
        } else {
          Text(this.title)
            .draggable(false)
            .fontSize(AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .minFontScale(1.0)
            .minFontSize($r('sys.float.Subtitle_S'))
            .maxFontSize($r('sys.float.Title_S'))
            .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
            .fontWeight(AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .key('PhotoBrowserDateTitle')
          Text(this.subTitle)
            .draggable(false)
            .fontSize(ActionBarProp.SUBTITLE_TEXT_SIZE)
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .minFontScale(1.0)
            .fontFamily(ActionBarProp.REGULAR_FONT)
            .fontWeight(FontWeight.Regular)
            .fontColor(ActionBarProp.NORMAL_SUBTITLE_TEXT_COLOR)
            .maxLines(1)
            .lineHeight(DEFAULT_LINE_HEIGHT)
            .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .key('PhotoBrowserTimeLocationTitle')
        }
      }
      .constraintSize({ minHeight: TITLE_MIN_HEIGHT })
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Center)
  }

  private onBuildDone(): void {
    Log.debug(TAG, `onBuildDone, title: ${this.title}, subTitle: ${this.subTitle}`);
  }
}