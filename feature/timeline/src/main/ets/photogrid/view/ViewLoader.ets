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

import lazy  { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy  { FormIndex } from '../statemanager/constants/GridDefine';
import lazy  { ViewId, ViewZIndex } from '../viewcontroller/constants/ViewDefine';
import lazy  { DayGridVc } from '../viewcontroller/DayGridVc';
import lazy  { DayScrollerBarVc } from '../viewcontroller/DayScrollerBarVc';
import lazy  { GridSnapshotVc } from '../viewcontroller/GridSnapshotVc';
import lazy  { DayGridVm } from '../viewmodel/DayGridVm';
import lazy  { DayScrollerBarVm } from '../viewmodel/DayScrollerBarVm';
import lazy  { GridSnapshotVm } from '../viewmodel/GridSnapshotVm';
import lazy  { GridSnapshotView } from './common/GridSnapshotView';
import lazy  { DayGridView } from './DayGridView';
import lazy  { DayScrollerBarView } from './DayScrollerBarView';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';

/**
 * 宫格通用构建参数
 */
interface GridBuildParams<GC, SC, GM, SM> {
  /**
   * 实例ID
   */
  persistentId: number;

  /**
   * 年宫格视图控制器
   */
  gridController?: GC;

  /**
   * 年滚动条视图控制器
   */
  scrollerController?: SC;

  /**
   * 年宫格视图模型
   */
  gridViewModel?: GM;

  /**
   * 年滚动条视图模型
   */
  scrollerViewModel?: SM;

  /**
   * 是否显示云同步卡片
   */
  isShowSdCardTip?: boolean;

  /**
   * 广播
   */
  broadCast?: BroadCast;

  /**
   * 相册信息(相册宫格特有)
   */
  albumInfo?: AlbumInfo;
}

/**
 * 控件通用构建参数
 */
export interface BaseBuildParams {
  persistentId: number,
}

/**
 * 空实现构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function emptyBuildBuilder($$: BaseBuildParams): void {
}

/**
 * 日视图构建参数
 */
export interface DayViewBuildParams extends GridBuildParams<DayGridVc, DayScrollerBarVc, DayGridVm, DayScrollerBarVm> {
  // 图库最近删除相册图片与文本的间距(当前仅在PC上用到)
  recycleBottomHeight?: number;
}

/**
 * 日视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function dayViewBuilder($$: DayViewBuildParams): void {
  DayGridView({
    persistentId: $$.persistentId,
    controller: $$.gridController,
    viewModel: $$.gridViewModel,
    isShowSdCardTip: $$.isShowSdCardTip,
    broadCast: $$.broadCast,
  })
  GridSnapshotView({
    persistentId: $$.persistentId,
    viewModel: new GridSnapshotVm(FormIndex.DAY),
    controller: new GridSnapshotVc(FormIndex.DAY, ViewId.DAY_GRID_SNAPSHOT, ViewZIndex.DAY_GRID_SNAPSHOT),
  })

  DayScrollerBarView({
    persistentId: $$.persistentId,
    controller: $$.scrollerController,
    viewModel: $$.scrollerViewModel,
  })
}
