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

interface TimeDelay {
  rapid: number,
  short: number,
  default: number,
  double: number,
  long: number,
  enormous: number,
}

export const DELAY: TimeDelay = {
  rapid: 50,
  short: 500,
  default: 1000,
  double: 2000,
  long: 5000,
  enormous: 10 * 1000,
};

export const DELAY_TIME: number = 1000;