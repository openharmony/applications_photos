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
export interface optionType {
  label: ResourceStr,
  key: string,
}

export interface sortOptionType {
  label?: Resource,

  // 排序选择弹框内文字
  dialogLabel: Resource,

  // 宫格左上角“按xxx排序”
  titleLabel: Resource,
  key: string,
}

export interface DialogItemOptionType {
  dialogLabel: Resource,
  buttonLabel?: Resource,
  type?: string,
  key: string,
}

export interface SelectOptionType {
  value: ResourceStr,
  key: string,
}


export interface DividerStyleType {
  marginLeft?: number,
  marginRight?: number,
  width?: string
}

export interface selectedType {
  selected: string,
  sortType: string,
}

export type SortSelectMenuParamType = () => selectedType;

export type selectEmitType = ((selected: string, sortType: string) => void) | null;

export interface MenuItemContentModifierParamType {
  isSelected: (index: number) => boolean;
  sortType: string;
  optionLength: number;
}