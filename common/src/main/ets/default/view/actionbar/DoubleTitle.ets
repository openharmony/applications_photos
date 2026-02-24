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
import lazy { FirstLevelTitleProp } from './FirstLevelTitle';
import lazy { AccessibilityUtil } from '../../utils/AccessibilityUtil';

/* instrument ignore file */
const TAG = 'DoubleTitle';
const KEY: string = 'MainTitle';

/**
 * 状态类
 */
@Observed
export class DoubleTitleProp {
  /**
   * 主标题
   */
  public mainTitle: FirstLevelTitleProp = new FirstLevelTitleProp();
  /**
   * 副标题
   */
  public subTitle: FirstLevelTitleProp = new FirstLevelTitleProp();
}

/**
 * 构造器函数
 * @param obj 参数
 */
@Builder
export function doubleTitleBuilder(obj: Object | undefined) {
  DoubleTitle({ main: (obj as DoubleTitleProp).mainTitle, sub: (obj as DoubleTitleProp).subTitle })
}

/**
 * 手机用一级界面标题
 */
@Component
export struct DoubleTitle {
  @State public main: FirstLevelTitleProp = new FirstLevelTitleProp();
  @State public sub: FirstLevelTitleProp = new FirstLevelTitleProp();

  build() {
    Column() {
      if (this.main?.content) {
        Text(this.main.content)
          .draggable(false)
          .fontSize(this.main.fontSize)
          .maxLines(this.main.maxLines)
          .fontWeight(this.main.fontWeight)
          .fontColor(this.main.fontColor)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxFontScale(this.main.maxFontScale)
          .minFontScale(this.main.minFontScale)
          .minFontSize(this.main.minFontSize)
          .maxFontSize(this.main.maxFontSize)
          .textOverflow(this.main.textOverflow)
          .key(KEY)
          .focusable(this.main.focusable)
          .opacity(1)
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)
          .transition(this.main.transitionEffect)
          .onAppear((): void => {
            Log.info(TAG, 'DoubleTitle onAppear');
            AccessibilityUtil.sendFocusAccessibilityEvent(KEY);
          })
      }
      if (this.sub?.content) {
        Text(this.sub.content)
          .fontFamily('HarmonyHeiTi')
          .fontSize(this.sub.fontSize)
          .maxLines(this.sub.maxLines)
          .fontColor(this.sub.fontColor)
          .fontWeight(FontWeight.Medium)
          .maxFontScale(this.sub.maxFontScale)
          .minFontScale(this.sub.minFontScale)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)
          .key('SubTitle')
          .visibility(this.sub.visibility)
          .transition(this.sub.transitionEffect)
      }
    }.flexGrow(1).justifyContent(FlexAlign.Start).width(0)
  }
}