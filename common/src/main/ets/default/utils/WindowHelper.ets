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
import lazy window from '@ohos.window';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy common from '@ohos.app.ability.common';
import lazy { Log } from './Log';

/* instrument ignore file */
const TAG: string = 'common_WindowHelper';

export interface WindowListener {
  windowStatusChange?: (status: window.WindowStatusType) => void;
  windowSizeChange?: (size: window.Size) => void;
}

export class WindowHelper {
  private readonly context: common.Context;
  private readonly listeners: WindowListener[] = [];
  private readonly windowStatusChangeCallback: Callback<window.WindowStatusType> =
    (status: window.WindowStatusType) => this.onWindowStatusChange(status);
  private readonly windowSizeChangeCallback: Callback<window.Size> =
    (size: window.Size) => this.onWindowSizeChange(size);
  private win: window.Window | undefined = undefined;

  public constructor(context: common.Context) {
    this.context = context;
  }

  private onWindowStatusChange(status: window.WindowStatusType): void {
    for (let listener of this.listeners) {
      listener.windowStatusChange?.(status);
    }
  }

  private onWindowSizeChange(size: window.Size): void {
    for (let listener of this.listeners) {
      listener.windowSizeChange?.(size);
    }
  }

  public register(listener: WindowListener): void {
    if (!listener || this.listeners.indexOf(listener) !== -1) {
      return;
    }
    this.listeners.push(listener);
  }

  public unregister(listener: WindowListener): void {
    if (!listener) {
      return;
    }
    let index: number = this.listeners.indexOf(listener);
    this.listeners.splice(index, 1);
  }

  public init(): void {
    try {
      window.getLastWindow(this.context, (err: BusinessError, data) => {
        const errCode: number = err.code;
        if (errCode) {
          Log.error(TAG, `Failed to obtain the top window. errCode: ${err.code}`);
          return;
        }
        this.win = data;
        this.win.on('windowStatusChange', this.windowStatusChangeCallback);
        this.win.on('windowSizeChange', this.windowSizeChangeCallback);
      });
    } catch (exception) {
      Log.error(TAG, `Failed to obtain the top window. exception: ${exception}`);
    }
  }

  public deInit(): void {
    try {
      if (!this.win) {
        Log.error(TAG, 'this win is undefined ');
        return;
      }
      this.win.off('windowStatusChange', this.windowStatusChangeCallback);
      this.win.off('windowSizeChange', this.windowSizeChangeCallback);
    } catch (exception) {
      Log.error(TAG, `Failed to WindowHelper.deInit. exception: ${exception}`);
    }
  }
}