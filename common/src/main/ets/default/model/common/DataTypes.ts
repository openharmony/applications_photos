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

export interface Size {
  width: number;
  height: number;
}

export interface Region {
  x: number;
  y: number;
  width: number;
  height: number;
}

export type DisplayName = Resource | string;

export type Loggable = Resource | string | number | boolean | undefined | object | Object | Error | Function;

export type SelfObject = Loggable;

// 节点信息
export interface PositionInfo {
  id: string;
  index: number;
}

// 首尾节点信息
export interface HeadTailPosition {
  headPosition: PositionInfo | undefined;
  tailPosition: PositionInfo | undefined;
}
;