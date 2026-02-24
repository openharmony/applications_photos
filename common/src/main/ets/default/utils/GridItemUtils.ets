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

import lazy { settings } from '@kit.BasicServicesKit';
import lazy { SystemPropertiesManager } from './SystemPropertiesManager';

const PERSIST_KEY_GRID_TRACE_MODE: string = 'persist.photos.grid_trace_mode.enabled';
const PERSIST_KEY_GRID_REPORT_MODE: string = 'persist.photos.grid_report_mode.enabled';

export class GridItemUtils {
  public static gridTraceSwitch: boolean | undefined = undefined;
  public static gridReportSwitch: boolean | undefined = undefined;

  public static useGridTrace(): boolean {
    if (GridItemUtils.gridTraceSwitch) {
      return GridItemUtils.gridTraceSwitch;
    }
    GridItemUtils.gridTraceSwitch =
      SystemPropertiesManager.getInstance().get(PERSIST_KEY_GRID_TRACE_MODE, 'false') === 'true';
    return GridItemUtils.gridTraceSwitch;
  }

  public static useGridReport(): boolean {
    if (GridItemUtils.gridReportSwitch) {
      return GridItemUtils.gridReportSwitch;
    }
    GridItemUtils.gridReportSwitch =
      SystemPropertiesManager.getInstance().get(PERSIST_KEY_GRID_REPORT_MODE, 'false') === 'true';
    return GridItemUtils.gridReportSwitch;
  }
}