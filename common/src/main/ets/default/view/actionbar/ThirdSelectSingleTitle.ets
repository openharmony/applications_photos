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

import lazy { Log } from '../../utils/Log';
import lazy { ActionBarProp } from '../browserOperation/ActionBarProp';
import lazy { AppBarStyles } from './AppBarStyles';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';

/* instrument ignore file */
const TAG: string = 'common_ThirdSelectSingleTitle';

// Single line title, fixed content
@Component
export struct ThirdSelectSingleTitle {
  @Link actionBarProp: ActionBarProp;
  @Consume albumName: string;
  @StorageLink('isHorizontal') @Watch('updateTitleFontSize') private isHorizontal: boolean = false;
  @State private nonSystemAlbumTitleFontSize: Resource = this.getNonSysAlbumTitleFontSize();
  @State isNeedShowPrivacyMask: boolean = false;
  @Prop privacyOptionsText: Resource | undefined = undefined;
  private changePrivacyViewStatus: Function | undefined;

  build() {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      Row() {
        this.thirdSelectTextBuilder();
      }
    } else {
      Row() {
        Column(){
          this.thirdSelectTextBuilder();
          this.privacyOptionsTextBuilder();
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
      }
      .height($r('app.float.icon_video_size'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .flexGrow(1)
    }
  }

  @Builder
  privacyOptionsTextBuilder(): void {
    if (this.isNeedShowPrivacyMask) {
      Text(this.privacyOptionsText)
        .fontColor($r('app.color.color_control_highlight'))
        .fontSize($r('app.float.label_text_default'))
        .maxFontScale(1.0)
        .minFontScale(1.0)
        .onClick(() => {
          if (this.changePrivacyViewStatus) {
            this.changePrivacyViewStatus(true)
          }
        })
    }
  }

  @Builder
  private thirdSelectTextBuilder(): void {
    if (this.albumName.length > 0) {
      Text(this.albumName)
        .fontSize(this.actionBarProp.getIsHeadTitle()
          ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
        .fontWeight(AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT)
        .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxFontScale(1.0)
        .minFontScale(1.0)
        .minFontSize($r('sys.float.Body_M'))
        .maxFontSize(this.nonSystemAlbumTitleFontSize)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .key('SingleTitleText')
    } else {
      Text(this.actionBarProp.getTitle())
        .fontSize(this.actionBarProp.getIsHeadTitle()
          ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE)
        .fontWeight(AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT)
        .fontColor(ActionBarProp.NORMAL_TEXT_COLOR)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxFontScale(1.0)
        .minFontScale(1.0)
        .minFontSize($r('sys.float.Body_M'))
        .maxFontSize(this.nonSystemAlbumTitleFontSize)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .key('SingleTitleText')
    }
  }

  /**
   * 用户相册，分类相册，搜索界面使用的单行标题字体大小
   */
  private getNonSysAlbumTitleFontSize(): Resource {
    if (DeviceInfo.isPc() || DeviceInfo.isFoldablePhone() || (DeviceInfo.isPhoneUx() && !this.isHorizontal)) {
      return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    }

    return this.actionBarProp.getIsHeadTitle()
      ? ActionBarProp.HEAD_TITLE_ONE_LINE_TEXT_SIZE : AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE
  }

  /* instrument ignore next */
  private updateTitleFontSize(): void {
    this.nonSystemAlbumTitleFontSize = this.getNonSysAlbumTitleFontSize();
  }

  private onBuildDone(): void {
    Log.info(TAG, `onBuildDone, title: ${this.actionBarProp.getTitle()}`);
  }
}