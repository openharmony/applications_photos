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

import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { DayPreviewGridVm } from '../viewmodel/DayPreviewGridVm';
import lazy { AbstractPreviewGridVc, PreviewGridAttributeUpdater } from './AbstractPreviewGridVc';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';

/**
 * 日预览宫格视图控制器
 */
@Observed
export class DayPreviewGridVc extends AbstractPreviewGridVc<DayPreviewGridVm, PreviewGridAttributeUpdater> {
  public constructor(attributeUpdater?: PreviewGridAttributeUpdater) {
    super(FormIndex.DAY,
      attributeUpdater ?? new PreviewGridAttributeUpdater(ViewId.DAY_PREVIEW_GRID, ViewZIndex.DAY_PREVIEW_GRID),
      'DayPreviewGridVc');
  }
}