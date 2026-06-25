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

/**
 * 文本框允许最大行数
 */
const MAX_LINE_COUNT: number = 2;
/* instrument ignore file */
const TAG = 'SecondLevelTitle';

/**
 * 状态类
 */
@Observed
export class SecondLevelTitleProp {
  /**
   * 标题内容
   */
  public content: string | Resource = '';
  /**
   * 字体大小
   */
  public fontSize: number | string | Resource = $r('app.float.first_level_title_font_size');
  /**
   * 字体权重
   */
  public fontWeight: number | FontWeight | string = AppBarStyles.FIRST_LEVEL_TITLE_FONT_WEIGHT;
  /**
   * 字体颜色
   */
  public fontColor: ResourceColor = ActionBarProp.NORMAL_TEXT_COLOR;
  /**
   * 是否可获焦
   */
  public focusable: boolean = true;
  /**
   * 最大行数
   */
  public maxLines: number = MAX_LINE_COUNT;
  /**
   * 最小字体大小
   */
  public minFontSize: number | string | Resource | undefined = undefined;
  /**
   * 最大字体大小
   */
  public maxFontSize: number | string | Resource | undefined = undefined;
  /**
   * 文字溢出
   */
  public textOverflow: TextOverflowOptions | undefined = undefined;
  /**
   * key值
   */
  public key: string | undefined = undefined;
}

/**
 * 构造器函数
 * @param obj 参数
 */
@Builder
export function secondLevelTitleBuilder(obj: Object | undefined) {
  SecondLevelTitle({ prop: obj as SecondLevelTitleProp })
}

/**
 * 手机用一级界面标题
 */
@Component
export struct SecondLevelTitle {
  @State public prop: SecondLevelTitleProp = new SecondLevelTitleProp();

  build() {
    Text(this.prop.content)
      .draggable(false)
      .fontSize(this.prop.fontSize)
      .maxFontScale(1.0)
      .minFontScale(1.0)
      .maxLines(this.prop.maxLines)
      .fontWeight(this.prop.fontWeight)
      .fontColor(this.prop.fontColor)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxFontScale(1.0)
      .minFontScale(1.0)
      .minFontSize(this.prop.minFontSize)
      .maxFontSize(this.prop.maxFontSize)
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
      .lineHeight(-1)
      .textOverflow(this.prop.textOverflow)
      .wordBreak(WordBreak.BREAK_ALL)
      .key(this.prop.key ?? 'FirstLevelTitle')
      .focusable(this.prop.focusable)
      .opacity(1)
      .width(0)
      .textAlign(TextAlign.Start)
      .onAppear((): void => {
        Log.info(TAG, 'SingleTitle onAppear');
      })
      .flexGrow(1)
  }
}