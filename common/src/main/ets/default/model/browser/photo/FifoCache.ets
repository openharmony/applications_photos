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

import lazy { Log } from '../../../utils/Log';
import type { Releasable } from '../../common/Releasable';

/* instrument ignore file */
const TAG: string = 'common_FifoCache';

export class FifoCache<T extends Releasable> {
  public map: Map<string, T> = new Map<string, T>();
  public pendingSet: Set<string> = new Set<string>();
  public limit: number;

  constructor(limit: number) {
    this.limit = limit || 5;
  }

  public set(key: string, value: T): void {
    if (this.pendingSet.has(key)) {
      this.pendingSet.delete(key);
      Log.debug(TAG, `FifoCache add new pixmap: ${key} ${this.map.size}`);
      if (this.map.has(key)) {
        Log.debug(TAG, `FifoCache has same pixmap value: ${key} ${this.map.size}`);
        value.release();
        return;
      }
      this.map.set(key, value);
    } else {
      Log.error(TAG, `FifoCache add new pixmap failed because pending set don't have it: ${key}`);
      value.release();
    }
  }

  public addPendingPixmap(key: string): boolean {
    Log.debug(TAG, `FifoCache add pending pixmap: ${key} ${this.pendingSet.size}`);
    if (!this.pendingSet.has(key)) {
      this.pendingSet.add(key);
      return true;
    }
    return false;
  }

  public get(key: string): T | undefined {
    Log.debug(TAG, `get: ${key}  map size: ${this.map.size}`);
    if (this.map.has(key)) {
      return this.map.get(key) as T;
    }
    return undefined;
  }

  public release(key: string): void {
    Log.debug(TAG, `release: ${key}`);
    if (this.pendingSet.has(key)) {
      this.pendingSet.delete(key);
    }
    if (this.map.has(key)) {
      let value: T = this.map.get(key) as T;
      value.release();
      this.map.delete(key);
    }
  }

  public releaseAll(): void {
    Log.debug(TAG, 'release all');
    this.map.forEach((item): void => {
      item.release();
    });
    this.map.clear();
    this.pendingSet.clear();
  }
}