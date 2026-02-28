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
import type { ImageRequest } from './pipeline/ImageRequest';
import type { RequestContext } from './pipeline/RequestContext';
import type { RequestListener } from './pipeline/RequestListener';
import type { Thumbnail } from './Thumbnail';

const TAG: string = 'PerformanceTracker';

/**
 * 性能跟踪
 *
 * @since 2023-10-17
 */
export class PerformanceTracker implements RequestListener<Thumbnail> {
  private requests: Map<ImageRequest, number> = new Map();

  public onRequestStart(context: RequestContext<Thumbnail>): void {
    if (!context) {
      return;
    }
    if (context.request) {
      this.requests.set(context.request, new Date().getTime());
    }
  }

  public onRequestFinish(context: RequestContext<Thumbnail>): void {
    if (!context) {
      return;
    }
    if (context.request) {
      let startTime: number | undefined = this.requests.get(context.request);
      if (!startTime) {
        return;
      }

      let timeCost = new Date().getTime() - startTime;
      Log.info(TAG, `decode cost: ${timeCost}, uri: ${context.request.item?.uri}`);
      this.requests.delete(context.request);
    }
  }

  public onProcessorStart(context: RequestContext<Thumbnail>, processorName: string): void {
  }

  public onProcessorFinish(context: RequestContext<Thumbnail>, processName: string): void {
  }
}
