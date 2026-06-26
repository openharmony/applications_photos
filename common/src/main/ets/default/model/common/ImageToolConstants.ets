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

/**
 * 画中画布局相关常量
 */
export class ImageToolConstants {
  // 画中画 进入 宽高比
  public static readonly SHOW_IMAGE_TOOL_MIN_RATIO: number = 2;
  public static readonly SHOW_IMAGE_TOOL_MAX_RATIO: number = 1 / 2;
  // 背板透明度
  public static readonly SCROLL_BACKGROUND_OPACITY: number = 0.4;
  // 背板边框
  public static readonly SCROLL_OUT_BORDER_WIDTH: number = 0.5;
  // 选择框 弧度
  public static readonly SCROLL_TOOL_INNER_BORDER_RADIUS: number = 2;
  // 选择框内描边宽度
  public static readonly SCROLL_INNER_WIDTH: number = 0.4;
  // 选择框外描边宽度
  public static readonly SCROLL_OUTER_WIDTH: number = 1;
  // 选择框内描边颜色
  public static readonly SCROLL_INNER_COLOR: string = '#33000000';
  // Zero
  public static readonly IMAGE_TOOL_ZERO: number = 0;
  // 画中画 单边距离
  public static readonly IMAGE_TOOL_SINGLE_LEN: number = 56;
  // PhotoItem 各设备模拟List高度
  public static readonly PAD_SLIDER_BAR_HORIZON_HEIGHT: number = 72;
  public static readonly SLIDER_BAR_HORIZON_HEIGHT: number = 68;
  public static readonly PC_SLIDER_BAR_HEIGHT: number = 44;
  public static readonly SLIDER_BAR_HEIGHT: number = 40;
  public static readonly TV_SWIPER_ITEM_SIZE: number = 124;
  // Imagetool margin bottom
  public static readonly IMAGE_TOOL_MARGIN_STATUS_HORIZONTAL: number = 4;
  // 未操作画中画自动隐藏时长
  public static readonly IMAGE_TOOL_AUTOHIDE_DURATION: number = 3000;
  // 画中画出现动效时长
  public static readonly IMAGE_TOOL_ANIMATION_DURATION: number = 150;
  // 画中画适配旋转 360 度
  public static readonly IMAGE_TOOL_THREE_SIX_ZERO: number = 360;
  // 画中画特殊比例图片 出现屏幕宽高比界限
  public static readonly IMAGE_TOOL_SCREEN_RATIO_MIN: number = 0.8;
  public static readonly IMAGE_TOOL_SCREEN_RATIO_NAX: number = 1.25;
  // 画中画特殊比例图片 图片宽高比
  public static readonly IMAGE_TOOL_SPECIAL_RATIO_FIRST: number = 3;
  public static readonly IMAGE_TOOL_SPECIAL_RATIO_SECOND: number = 2.5;
  public static readonly IMAGE_TOOL_SPECIAL_RATIO_THIRD: number = 3.5;
}

// 画中画打点传参
export class ImageToolReportParams {
  public uri: string = '';
  public imageWidth: number = -1;
  public imageHeight: number = -1;
  public enterInnerPicWay: string = '';
  public curScale: number = -1;
}

export enum EnterInnerPicWay {
  PINCH = 'pinch',
  DOUBLE_TAP = 'doubleTap',
}