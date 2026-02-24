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


import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { Log } from '../../utils/Log';
import lazy { BusinessError } from '@ohos.base';

/* instrument ignore file */
const TAG: string = 'common_StatusBarColorController';

export enum StatusBarColorMode {
  NORMAL,
  TRANSPARENT,
  PHOTO_BROWSER
}

export class StatusBarColorController {
  private mode?: StatusBarColorMode;
  private statusBarColor: string = '';

  private constructor() {
    Log.info(TAG, 'constructor');
    UiUtil.getResourceString($r('sys.color.background_secondary')).then((value): void => {
      this.statusBarColor = value;
      Log.info(TAG, `statusBarColor: ${value}`);
    })
      .catch((error: BusinessError): void => {
        Log.error(TAG, `getResourceString error: ${error?.message}, code: ${error?.code}`);
      });
  }

  public static getInstance(): StatusBarColorController {
    if (!StatusBarColorController.instance) {
      StatusBarColorController.instance = new StatusBarColorController();
    }
    return StatusBarColorController.instance;
  }

  public static instance: StatusBarColorController | undefined = undefined;

  public setMode(mode: StatusBarColorMode): void {
    this.mode = mode;
    this.invalidate();
  }

  public release(): void {
  }

  private invalidate(): void {
    Log.info(TAG, `invalidate mode: ${this.mode}`);
    switch (this.mode) {
      case StatusBarColorMode.TRANSPARENT:
        UiUtil.getResourceString($r('app.color.transparent')).then(() => {
        })
          .catch((error: BusinessError): void => {
            Log.error(TAG, `getResourceString for transparent color error: ${error}, code: ${error?.code}`);
          });
        break;
      case StatusBarColorMode.PHOTO_BROWSER:
        this.checkColorAvailable();
        break;
      default:
        this.checkColorAvailable();
        break;
    }
  }

  private async checkColorAvailable(): Promise<boolean> {
    if (this.statusBarColor) {
      return true;
    }
    try {
      let color = await UiUtil.getResourceString($r('sys.color.background_secondary'));
      this.statusBarColor = color;
      Log.info(TAG, `statusBarColor: ${color}`);
      return color != null;
    } catch (error) {
      Log.error(TAG, `getResourceString error: ${error?.message}, code: ${error?.code}`);
      return false;
    }
  }
}