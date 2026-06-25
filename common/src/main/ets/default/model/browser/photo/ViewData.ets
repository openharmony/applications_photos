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
import type { MediaItem } from './MediaItem';
import type { SimpleGridMediaItem } from './SimpleGridMediaItem';
import type { ViewType } from './ViewType';
import lazy { TimelineData } from './TimelineData';

const TAG: string = 'ViewData';

@Observed
export class ViewData {
  public deferLoad?: boolean = false;
  public mediaItem?: MediaItem;
  public viewType?: ViewType;
  public viewData?: TimelineData;
  public viewIndex?: number;
  public simpleMediaItem?: SimpleGridMediaItem;
  // 临时方案，兜底触发ViewData刷新
  public refreshKey?: string;

  constructor(item?: MediaItem) {
    if (!item) {
      Log.error(TAG, 'item undefined');
      return;
    }
    this.mediaItem = item;
  }

  public update(item: MediaItem): void {
    if (!item) {
      Log.error(TAG, 'update item undefined');
      return;
    }
    this.mediaItem = item;
  }

  public static getEmptyInstance(): ViewData {
    return new ViewData();
  }
}
