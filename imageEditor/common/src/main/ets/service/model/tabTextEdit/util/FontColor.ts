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

export enum UiFontColor {
  WHITE = '#FFFFFF',
  RED_DARK_OPAQUE = '#E64566',
  YELLOW_DARK_OPAQUE = '#F7CE00',
  GREEN_YELLOW_DARK_OPAQUE = '#64BB5C',
  INDIGO_OPAQUE = '#46B1E3',
  BLUE_OPAQUE = '#0A59F7',
  MAROON_OPAQUE = '#AC49F5',
  BLACK_OPAQUE = '#000000',
}

/**
 * 富文本颜色管理
 */
export class FontColorManager {
  private static instance: FontColorManager;
  public fontColorList: string[] = [
    UiFontColor.WHITE,
    UiFontColor.RED_DARK_OPAQUE,
    UiFontColor.YELLOW_DARK_OPAQUE,
    UiFontColor.GREEN_YELLOW_DARK_OPAQUE,
    UiFontColor.INDIGO_OPAQUE,
    UiFontColor.BLUE_OPAQUE,
    UiFontColor.MAROON_OPAQUE,
    UiFontColor.BLACK_OPAQUE,
  ];

  public static getInstance(): FontColorManager {
    if (!FontColorManager.instance) {
      FontColorManager.instance = new FontColorManager();
    }
    return FontColorManager.instance;
  }
}
