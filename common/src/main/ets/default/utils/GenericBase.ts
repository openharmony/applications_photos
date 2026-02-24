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

import lazy { reportEmpty } from './Log';

export abstract class GenericBase<T> {
  public storage = new Map<string, T>();
  readonly onEmpty: T;

  public get(value: string): T {
    return this.storage.get(value);
  }

  public set(key: string, value?: T): void {
    if (value === undefined) {
      reportEmpty(value, key, 'global context');
      return;
    }
    this.storage.set(key, value);
  }

  public delete(key: string): void {
    this.storage.delete(key);
  }
}