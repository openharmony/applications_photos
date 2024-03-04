/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { FifoCache } from '../browser/photo/FifoCache';
import { Thumbnail } from '../browser/photo/Thumbnail';
import { Log } from '../../utils/Log';
import { Constants } from './Constants';

const TAG: string = 'common_PixelMapManager';

export class PixelMapManager {
  public static readonly PIXEL_MAP_MANAGER: string = 'pixel_map_manager';
  private fifoMap: FifoCache<Thumbnail>;

  private constructor() {
    Log.info(TAG, 'constructor');
    this.fifoMap = new FifoCache<Thumbnail>(5);
  }

  public static getInstance(): PixelMapManager {
    if (AppStorage.get(Constants.PIXEL_MAP_MANAGER) == null) {
      AppStorage.setOrCreate(Constants.PIXEL_MAP_MANAGER, new PixelMapManager());
    }
    return AppStorage.get(Constants.PIXEL_MAP_MANAGER);
  }

  public getFifoCache(): FifoCache<Thumbnail> {
    return this.fifoMap;
  }

  public release(): void {
    this.fifoMap.releaseAll();
  }
}
