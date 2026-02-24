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
 * 下标转换接口
 */
export interface IndexConvertor {
  /**
   * 布局下标转为数据下标
   * @param index 布局下标
   * @returns 数据下标，异常场景返回 -1
   */
  layoutToData: (index: number) => number;

  /**
   * 数据下标转为布局下标
   * @param index 数据下标
   * @returns 布局下标，异常场景返回 -1
   */
  dataToLayout: (index: number) => number;
}