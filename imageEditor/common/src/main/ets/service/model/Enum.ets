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
export enum EditorType {
  Base,
  AI,
  Aperture
}

export enum TabName {
  TabCrop,
  TabAdjust,
  TabXTStyle,
  TabFilter,
  TabAperture,
  TabSeal,
  TabStylus,
  TabTextEdit,
  TabMosaic,
  TabSport
}

export enum AiTabName {
  TabRefineMaster,
  TabRemove,
  TabReplaceEmo,
  TabExpandImage,
  TabBackground,
  TabMove,
  TabRemoveReflect
}

export enum FillCropType {
  Interrupt,
  MoveStart,
  MoveEnd,
  PinchStart,
  PinchEnd
}

export enum Algorithms {
  Haze_Removal,
  IntelligentCorrection,
  XTStyle,
  WideAperture
}

export enum FoldPhoneTypeValue {
  /**
   * 无效值
   */
  INVALID_VALUE = -1,
  /**
   * 直板机
   */
  STRAIGHT = 0,
  /**
   * 大xxx（内xxx） X5
   */
  LARGE_FOLD = 1,
  /**
   * xxx（只有内xxx） pocket
   */
  SMALL_FOLD = 2,
  /**
   * 外xxx XS2
   */
  EXTERNAL_FOLD = 3,
  /**
   * 扩展新形态
   */
  EXPANDING_NEX_FORMS = 4,
}