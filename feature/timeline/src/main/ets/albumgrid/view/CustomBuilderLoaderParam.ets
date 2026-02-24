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
import lazy { DayViewBuildParams } from '../../photogrid/view/ViewLoader';
import lazy { DayGridView } from '../../photogrid/view/DayGridView';
import lazy { ArtisticDayGridVm } from '../../photogrid/viewmodel/ArtisticDayGridVm';
import lazy { DayScrollerBarView } from '../../photogrid/view/DayScrollerBarView';

export interface CustomBuilderLoaderParam {
  irregularViewBuilder?: ()=> void;
  dayViewBuilder: ($$: DayViewBuildParams)=> void;
}

@Builder
export function ArtisticDayViewBuilder($$: DayViewBuildParams): void {
  DayGridView({
    persistentId: $$.persistentId,
    controller: $$.gridController,
    viewModel: new ArtisticDayGridVm(),
    isShowSdCardTip: $$.isShowSdCardTip,
    broadCast: $$.broadCast,
  })

  DayScrollerBarView({
    persistentId: $$.persistentId,
    controller: $$.scrollerController,
    viewModel: $$.scrollerViewModel,
  })
}