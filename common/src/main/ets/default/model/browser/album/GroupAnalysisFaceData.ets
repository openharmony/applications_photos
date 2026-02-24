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

import lazy { ParamsWrapper } from '../../../view/actionbar/Menu';
import lazy { Log } from '../../../utils/Log';
import type { Region } from '../../../model/common/DataTypes';

/* instrument ignore file */
const TAG: string = 'GroupAnalysisFaceData';

export class GroupAnalysisFaceData {
  private readonly params: ParamsWrapper = new ParamsWrapper();

  public constructor(analysisData: object) {
    if (!analysisData) {
      Log.error(TAG, 'analysisData is undefined');
      return;
    }
    for (let key of Object.keys(analysisData)) {
      this.params.set(key, analysisData[key]);
    }
  }

  public get albumUri(): string {
    return this.params.get<string>('album_uri') ?? '';
  }

  public get jointBeautyBounderX(): number {
    return Number(this.params.get<string>('joint_beauty_bounder_x') ?? 0);
  }

  public get jointBeautyBounderY(): number {
    return Number(this.params.get<string>('joint_beauty_bounder_y') ?? 0);
  }

  public get jointBeautyBounderWidth(): number {
    return Number(this.params.get<string>('joint_beauty_bounder_width') ?? 0);
  }

  public get jointBeautyBounderHeight(): number {
    return Number(this.params.get<string>('joint_beauty_bounder_height') ?? 0);
  }

  public get aestheticsScore(): number {
    return Number(this.params.get<string>('joint_aesthetics_score') ?? 0);
  }

  // 获取优选区域
  public get region(): Region {
    return {
      x: this.jointBeautyBounderX,
      y: this.jointBeautyBounderY,
      width: this.jointBeautyBounderWidth,
      height: this.jointBeautyBounderHeight,
    }
  }
}