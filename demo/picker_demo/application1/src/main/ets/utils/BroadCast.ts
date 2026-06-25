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

import lazy { Log } from './Log';

const TAG = 'BroadCast';

export class BroadCast {
  private callbackArray: Map<string, Function[]> = new Map();

  constructor() {
  }

  public on(event: string, callback: Function): void {
    let cbs = this.callbackArray.get(event);
    if (!cbs) {
      cbs = new Array<Function>();
      this.callbackArray.set(event, cbs);
    }
    cbs.push(callback);
  }

  public off(event?: string, callback?: Function): void {
    if (!event) {
      this.callbackArray = new Map();
      return;
    }
    if (!callback) {
      this.callbackArray.delete(event);
      return;
    }

    const cbs = this.callbackArray.get(event);
    if (!cbs) {
      return;
    }
    let length = cbs.length;
    for (let i = 0; i < length; i++) {
      let cb = cbs[i];
      if (cb === callback) {
        cbs.splice(i, 1);
        break;
      }
    }

    // Delete callback array if empty
    let newLength = cbs.length;
    if (newLength === 0) {
      this.callbackArray.delete(event);
    }
  }

  public has(event: string): boolean {
    return Boolean(this.callbackArray.get(event)?.length);
  }

  public emit(event: string, args: unknown[] = []): void {
    let cbs = this.callbackArray.get(event);
    if (!cbs) {
      return;
    }
    let l = cbs.length;
    for (let i = 0; i < l; i++) {
      try {
        cbs[i]?.(...args);
      } catch (e) {
        Log.error(TAG, 'callbackFunc: ' + cbs[i]?.name + ' error: ' + e + 'params: ' + String(...args));
      }
    }
  }

  public async emitAsync(event: string, args: unknown[] = []): Promise<void> {
    let cbs = this.callbackArray.get(event);
    if (!cbs) {
      return;
    }
    let l = cbs.length;
    for (let i = 0; i < l; i++) {
      try {
        await cbs[i]?.(...args);
      } catch (e) {
        Log.error(TAG, 'callbackFunc: ' + cbs[i]?.name + ' error: ' + e + 'params: ' + String(...args));
      }
    }
  }

  public release(): void {
    this.callbackArray.clear();
  }
}