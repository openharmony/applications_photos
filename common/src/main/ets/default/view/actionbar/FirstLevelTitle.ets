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
const TAG = 'FirstLevelTitle';

/**
 * 状态类
 */
@Observed
export class FirstLevelTitleProp {
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
   * 字体最大放大倍数
   */
  public maxFontScale: number = 1.0;
  /**
   * 字体最小放大倍数
   */
  public minFontScale: number = 1.0;
  /**
   * 文字溢出
   */
  public textOverflow: TextOverflowOptions | undefined = undefined;
  /**
   * key值
   */
  public key: string | undefined = undefined;
  /**
   * 可见性
   */
  public visibility: Visibility = Visibility.Visible;

  /**
   * 边距
   */
  public padding: Padding | LocalizedPadding = {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  };
  /**
   * 进退多选动效
   */
  public transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
}

/**
 * 构造器函数
 * @param obj 参数
 */
@Builder
export function firstLevelTitleBuilder(obj: Object | undefined) {
  FirstLevelTitle({ prop: obj as FirstLevelTitleProp })
}

/**
 * 手机用一级界面标题
 */
@Component
export struct FirstLevelTitle {
  @State public prop: FirstLevelTitleProp = new FirstLevelTitleProp();

  build() {
    Text(this.prop.content)
      .draggable(false)
      .fontSize(this.prop.fontSize)
      .maxLines(this.prop.maxLines)
      .fontWeight(this.prop.fontWeight)
      .fontColor(this.prop.fontColor)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxFontScale(this.prop.maxFontScale)
      .minFontScale(this.prop.minFontScale)
      .minFontSize(this.prop.minFontSize)
      .maxFontSize(this.prop.maxFontSize)
      .textOverflow(this.prop.textOverflow)
      .key(this.prop.key ?? 'FirstLevelTitle')
      .focusable(this.prop.focusable)
      .opacity(1)
      .textAlign(TextAlign.Start)
      .padding(this.prop.padding)
      .transition(this.prop.transitionEffect)
      .onAppear((): void => {
        Log.info(TAG, 'SingleTitle onAppear');
      })
      .layoutWeight(1)
      .accessibilityLevel('yes')
  }
}