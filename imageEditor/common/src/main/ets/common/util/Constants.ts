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
export class Constants {
  public static readonly PREDICATE_MEDIA_URI_KEY: string = 'uri';

  public static readonly ROUTER_AUDIO_EXTRACTED: string = 'extracted';

  public static readonly ROUTER_AUDIO_SOURCES: string = 'audio';

  static readonly NormalColor: string = '#FFFFFF';

  static readonly DarkColor: string = '#000000';

  public static readonly FILE_LOCATION_LOCAL: number = 1;

  public static readonly FILE_LOCATION_CLOUD: number = 2;

  public static readonly EDITOR_SWITCH_IN_DURATION: number = 200;

  public static readonly EDITOR_SWITCH_OUT_DURATION: number = 200;

  // 云图下载带画框水印图片后，执行200ms位移缩放动效
  public static readonly EDITOR_CLOUD_WATERMARK_DURATION: number = 200;

  public static readonly CROP_RATIO_MENU_INDEX: number = 3;

  public static readonly CROP_BTN_TOUCH_HOT_AREA: number = 12;

  public static readonly PREPARE_TERMINATE_EVENT_ID: number = 1;

  // Column Constants
  public static readonly COLUMN_MARGIN: number = 12;
  public static readonly COLUMN_GUTTER: number = 20;

  public static readonly STATUS_HEIGHT: number = 56;

  public static readonly BOTTOM_HEIGHT: number = 240;

  public static readonly TEXT_HEIGHT: number = 84;

  public static readonly PC_PRODUCT_SERVICE: string = 'HYM';
  public static readonly WGR_PRODUCT_SERVICE: string = 'WGR';

  public static readonly CROP_DELAY_TIME: number = 200;

  public static readonly MOVING_PHOTO_COLUMN_MARGIN: number = 16;

  public static readonly MOVING_PHOTO_COLUMN_GUTTER: number = 16;

  public static readonly MOVING_PHOTO_STATUS_HEIGHT: number = 56;

  public static readonly MOVING_PHOTO_BOTTOM_HEIGHT: number = 224;

  public static readonly MOVING_PHOTO_TEXT_HEIGHT: number = 84;

  public static readonly MOVING_PHOTO_CROP_DELAY_TIME: number = 110;

  // 编辑页面上下标题栏距离屏幕左右边距
  public static readonly EDITOR_GRID_SMALL_PADDING_LEFT_AND_RIGHT: number = 16;
  public static readonly EDITOR_GRID_MEDIUM_PADDING_LEFT_AND_RIGHT: number = 24;
  public static readonly EDITOR_GRID_LARGE_PADDING_LEFT_AND_RIGHT: number = 32;

  /**
   * 各个页面组件的组件key值，用于屏幕朗读手动聚焦
   */
  public static readonly TOP_TOOL_BAR_BACK: string = 'petalClip_topToolBar_back';
  public static readonly TOP_TOOL_BAR_BACK_VIDEO: string = 'videoEditor_topToolBar_back';

  // delay 250ms
  public static readonly DELAY_QUARTER_SECOND: number = 250;
  // MovingPhoto
  public static readonly EDITOR_MAIN_PAGE_ID: string = 'videoEditor_editorMain_pcPage';

  public static readonly SAVE_VIDEO: string = 'save_video';

  public static readonly MIME_TYPE: string = 'mime_type';

  public static readonly MOVING_PHOTO_EFFECT_MODE_CLOSE: number = 10;

  public static readonly EDITOR_COMPONENT_DELAY: number = 200;

  public static readonly RIGHT_MENU_WIDTH: number = 320; // PC右边菜单栏宽度

  public static readonly TOP_MENU_HEIGHT: number = 72; // PC顶部菜单栏宽度

  //横屏菜单栏宽度为：左侧边距+三级菜单宽度+二级菜单宽度+一级菜单宽度+设备边距-6（因为布局保持和保存栏居中，所以固定减6）
  public static readonly LEFT_MARGIN: number = 8; // 左侧边距

  public static readonly LEVEL_THREE_MENU_WIDTH: number = 56; // 三级菜单宽度

  public static readonly LEVEL_TWO_MENU_WIDTH: number = 96; // 二级菜单宽度

  public static readonly LEVEL_ONE_MENU_WIDTH: number = 52; // 一级菜单宽度

  public static readonly SCREEN_MARGIN: number = 6; // 设备边距

  public static readonly EXCEPTION_INFORMATION_CODE: number = -1;

  static readonly PC_TRIM_BOTTOM_HEIGHT: number = 108;

  static readonly TIME_BAR_HEIGHT = 36;

  static readonly BOTTOM_MARGIN = 16;

  static readonly PHOTO_UI_EXTENSION = 'photosUiExtensionStage';

  static readonly PHOTO_WINDOW_STAGE = 'photosWindowStage';
}

