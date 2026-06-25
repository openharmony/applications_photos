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
import lazy { DeviceInfo } from '../../utils/DeviceInfo';

/**
 * AppBar样式参数
 */
export class AppBarStyles {
  /**
   * 一级界面标题 字体大小
   */
  public static readonly FIRST_LEVEL_TITLE_FONT_SIZE: Resource = $r('sys.float.Title_S');
  /**
   * 一级界面标题 字体权重
   */
  public static readonly FIRST_LEVEL_TITLE_FONT_WEIGHT: FontWeight = FontWeight.Bold;
  /**
   * 按钮 背景颜色
   */
  public static readonly BUTTON_BG_COLOR: ResourceColor = $r('sys.color.ohos_id_color_button_normal');
  /**
   * 按钮 背景颜色 PC
   */
  public static readonly BUTTON_BG_COLOR_PC: ResourceColor = $r('app.color.transparent');
  /**
   * 按钮 填充颜色
   */
  public static readonly BUTTON_FILL_COLOR: ResourceColor = $r('sys.color.ohos_id_color_titlebar_icon');
  /**
   * 收藏按钮 填充颜色
   */
  public static readonly FAVORITE_BUTTON_FILL_COLOR: ResourceColor = $r('sys.color.icon_emphasize');
  /**
   * 按钮 沉浸态填充颜色
   */
  public static readonly BUTTON_FILL_COLOR_IMMERSIVE: ResourceColor = '#cc808080';
  /**
   * 字体放大倍数
   */
  public static readonly MAX_FONT_SIZE_SCALE: number = DeviceInfo.isPc() ? 1.45 : 1;
  /**
   * 工具栏左右padding
   */
  public static readonly TOOLBAR_PADDING: number = 14;
  /**
   * 少于3个菜单时左右padding
   */
  public static readonly TOOLBAR_LESS_THAN_THRESHOLD_PADDING: number = 24;
  /**
   * ActionBar按钮高度
   */
  public static readonly ACTION_BAR_BUTTON_HEIGHT: number = 40;
  /**
   * 文本 最大行数
   */
  public static readonly MAX_LINES: number = 1;
  /**
   * 进退多选动效时长
   */
  public static readonly MULTISELECT_ANIMATION_DURATION: number = 200;
}