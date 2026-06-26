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

import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { AppBarHugeScreenStyler } from './AppBarHugeScreenStyler';
import lazy { AppBarController } from './AppBar';

const TAG = 'PhotoBrowserAppBarStyler';

/**
 * PhotoBrowserAppBar样式管理器，用来管理AppBar边距
 */
export class PhotoBrowserAppBarStyler extends AppBarHugeScreenStyler {
  // 是否相机进大图显示的actionBar场景
  private isPhotoBrowserScene: boolean = false;

  /**
   * 构造函数
   * @param controller 控制器
   */
  public constructor(controller: AppBarController, isPhotoBrowserScene: boolean) {
    super(controller);
    Log.info(TAG, `AppBarHugeScreenStyler ${isPhotoBrowserScene}`);
    if (isPhotoBrowserScene) {
      this.isPhotoBrowserScene = isPhotoBrowserScene;
    }
  }

  /**
   * 计算padding
   */
  protected updateLayout() {
    const isInBreakPoint: boolean = this.manager.getIsInBreakPoint();
    Log.info(TAG, `updateLayout. isInBreakPoint:${isInBreakPoint}`);
    this.controller.padding = {
      start: LengthMetrics.vp(this.isPhotoBrowserScene ? 16 : (isInBreakPoint ? 64 : 16)),
      end: LengthMetrics.vp(this.extraWidth),
    };
  }
}