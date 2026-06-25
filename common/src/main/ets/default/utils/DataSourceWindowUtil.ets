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

/* instrument ignore file */

import lazy { Constants } from '../model/common/Constants';
import lazy { DeviceInfo } from './DeviceInfo';

export class DataWindow {
  public activeStart: number;
  public activeEnd: number;
  public windowSize: number;
  public stepSize: number;

  constructor(activeStart: number, activeEnd: number, windowSize: number, stepSize: number) {
    this.activeStart = activeStart;
    this.activeEnd = activeEnd;
    this.windowSize = windowSize;
    this.stepSize = stepSize;
  }
}

export class DataSourceWindowUtil {
  public static readonly INIT_FIRST_PATCH_LOAD_COUNT: number = 72;
  public static readonly GRID_STEP_SIZE: number =
    DeviceInfo.isPcOrTablet() ? Constants.STEP_PAD_AND_PC : Constants.SLIDING_STEP_DEFAULT;
  private static readonly BROWSER_WINDOW_SIZE: number = 200;
  private static readonly BROWSER_STEP_SIZE: number = 50;

  public static getDataWindow(isOpenBrowser: boolean, curIndex: number, oldActiveStart: number): DataWindow {
    if (isOpenBrowser) {
      let halfWindowSize: number = DataSourceWindowUtil.BROWSER_WINDOW_SIZE / 2;
      let activeStart = (curIndex - halfWindowSize) >= 0 ? (curIndex - halfWindowSize) : 0;
      let activeEnd = activeStart + DataSourceWindowUtil.BROWSER_WINDOW_SIZE;
      return new DataWindow(activeStart, activeEnd, DataSourceWindowUtil.BROWSER_WINDOW_SIZE,
        DataSourceWindowUtil.BROWSER_STEP_SIZE);
    } else {
      let expandsSize: number =
        (Constants.DEFAULT_SLIDING_WIN_SIZE - DataSourceWindowUtil.BROWSER_WINDOW_SIZE) / 2;
      let activeStart = (oldActiveStart - expandsSize) >= 0 ? (oldActiveStart - expandsSize) : 0;
      let activeEnd = activeStart + Constants.DEFAULT_SLIDING_WIN_SIZE;
      return new DataWindow(activeStart, activeEnd, Constants.DEFAULT_SLIDING_WIN_SIZE,
        DataSourceWindowUtil.GRID_STEP_SIZE);
    }
  }
}