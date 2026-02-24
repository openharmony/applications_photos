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
import { DisplayRotation } from '@kit.TestKit';
import { TestConstants } from './TestConstants';
import { DtLog } from './utils/DtLog';

/* instrument ignore file */
export interface Button {
  share: () => string;
  edit: () => string;
  favor: () => string;
  delete: () => string;
  download: () => string;
  videoScreenshot: () => string;
}

export class Ui extends DtLog {
  constructor(tag: string) {
    super(tag, TestConstants.TAG);
  }

  public button: Button = {
    share: (): string => {
      return `${this.barButton()}Share`;
    },
    edit: (): string => {
      return `${this.barButton()}Edit`;
    },
    favor: (): string => {
      return `${this.barButton()}Favor`;
    },
    delete: (): string => {
      return `${this.barButton()}Delete`;
    },
    download: (): string => {
      return `PhotoBrowserActionBarButtonPhotoBrowserDownload`;
    },
    videoScreenshot: (): string => {
      return `PhotoBrowserActionBarButtonvideoScreenshot`;
    },
  }

  public barButton(): string {
    return this.isLandscape() ? 'PhotoBrowserActionBarButton' : 'ToolBarButton';
  }

  public isLandscape(): boolean {
    return this.rotation !== DisplayRotation.ROTATION_0;
  }

  public rotation: DisplayRotation = DisplayRotation.ROTATION_0;
}