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

export interface UserGuideInfo {
  illustration: Resource | string,
  title: Resource | string,
  subTitle: Resource | string,
  buttonText: Resource | String,
  buttonType: number,
}

export class UserGuideConstants {
  // phone
  // Image相关
  public static readonly IMAGE_SCREEN_RATIO: number = 0.8;
  public static readonly IMAGE_SCREEN_RATIO_LEFT: number = 0.4;
  public static readonly IMAGE_LEFT_PLUS_RIGHT: number = 96;
  public static readonly ACTIONBAR_HEIGHT: number = 56;
  // Swiper Indicator 相关
  public static readonly INDICATOR_WIDTH: number = 8;
  public static readonly INDICATOR_SELECTED_WIDTH: number = 12;
  public static readonly INDICATOR_HORIZONTAL_BOTTOM_PADDING: number = 20;
  public static readonly SWIPER_AUTOPLAY_INTERVAL: number = 3000;
  public static readonly SWIPER_DURATION: number = 750;
  // 按钮相关
  public static readonly MAX_BUTTON_WIDTH: number = 448;
  public static readonly BUTTON_HEIGHT: number = 40;
  public static readonly BUTTON_INDICATOR_SPACE: number = 4;
  public static readonly NAVIGATION_BUTTON_SPACE: number = 16;
  public static readonly BUTTON_LIGHT_COLOR: ResourceColor = 0x0A59F7;
  public static readonly BUTTON_DARK_COLOR: ResourceColor = 0x317AF7;
  public static readonly BUTTON_RADIUS: number = 8;
  // 横屏相关
  public static readonly HORIZONTAL_PADDING: number = 48;
  public static readonly PAGE_TRANSITION_DURATION: number = 5000;
  public static readonly HORIZONTAL_COLUMN_NUM: number = 3;
  //pc
  public static readonly ICON_RADIUS = 6;
  public static readonly ICON_TEXT_SIZE = 16;
  public static readonly PC_BOTTOM_BUTTON_DIS = 2;
  public static readonly PC_INDICATOR_ARROW_SIZE = 24;
  //计算系数
  public static readonly CAL_HEIGHT_DIV_NUM = 2;
  public static readonly CAL_BUTTON_WIDTH_MUL_NUM = 2;
  //pc左上角图标
  public static readonly GALLERY_IMAGE_TEXT_MARGIN = 12;
  //图片和文字的间距
  public static readonly IMAGE_TEXT_PADDING = 24;
  //标题文字大小 px
  public static readonly TITLE_TEXT_SIZE = 20;
  //副标题文字大小 px
  public static readonly SUBTITLE_TEXT_SIZE = 14;
  //标题和副标题文字间距 vp
  public static readonly TITLE_SUBTITLE_PADDING = 8;
  // 全屏引导
  // 按钮间距
  public static readonly BUTTON_BOTTOM = 12;
  public static readonly BUTTON_BOTTOM_NAVIGATION = 16;
  public static readonly ZERO_WIDTH = 0;
  // Verde适配相关逻辑
  public static readonly VERDE_BUTTON_BOTTOM = 16;
  public static readonly VERDE_LEFT_RIGHT_MARGIN = 16;
  public static readonly PHOTO_TEXT_MARGIN = 8;
}

// 开屏引导数据集
export class UserGuideDataSource implements IDataSource {
  private list: UserGuideInfo[] = [];

  // 构造器
  constructor(list: UserGuideInfo[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): UserGuideInfo {
    return this.list[index]
  }

  getAllData(): UserGuideInfo[] {
    return this.list;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

