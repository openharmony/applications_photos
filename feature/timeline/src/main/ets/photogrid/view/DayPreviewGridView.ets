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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { PreviewGridItem } from '@ohos/common/src/main/ets/default/view/PreviewGridItem';
import lazy { DayPreviewGridVc } from '../viewcontroller/DayPreviewGridVc';
import lazy { DayPreviewGridVm } from '../viewmodel/DayPreviewGridVm';

const TAG: string = 'DayPreviewGridView';

/**
 * 日预览宫格构建参数
 */
export interface DayPreviewBuildParams {
  /**
   * 实例ID
   */
  persistentId: number;

  /**
   * 视图控制器
   */
  controller?: DayPreviewGridVc;

  /**
   * 视图模型
   */
  viewModel?: DayPreviewGridVm;
}

/**
 * 日预览宫格视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function dayPreviewBuilder($$: DayPreviewBuildParams): void {
  // 优先创建预加载宫格节点
  DayPreviewGridView({
    persistentId: $$.persistentId,
    controller: $$.controller,
    viewModel: $$.viewModel,
  })
}

/**
 * 日预览宫格
 */
@Component
export struct DayPreviewGridView {
  public persistentId: number = 0;
  @State public controller: DayPreviewGridVc = new DayPreviewGridVc();
  @Provide broadCast: BroadCast = new BroadCast();
  public viewModel: DayPreviewGridVm = new DayPreviewGridVm(this.broadCast);

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    LogUtils.info(TAG, `this.controller.isCanShow:${this.controller.isCanShow} this.controller.isShow${this.controller.isShow}`);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.controller.release();
    this.viewModel.release();
  }

  @Builder
  buildMediaItems() {
    LazyForEach(this.viewModel.dayDataSource, (item: ViewData, index: number) => {
      if (item) {
        PreviewGridItem({
          item: item.mediaItem,
          index: index,
          gridItemWidth: this.controller.gridItemWidth,
          drawnThumbnailCount: this.controller.drawnThumbnailCount,
        })
      }
    }, (_item: MediaItem, index: number) => {
      return `${index}GridItemPreview`;
    })
  }

  @Builder
  buildPreviewGrid() {
    Grid(new Scroller()) {
      this.buildMediaItems();
    }
    .cachedCount(0)
    .attributeModifier(this.controller.attributeUpdater)
    .onWillScroll((): ScrollResult => {
      return { offsetRemain: 0 };
    })
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildPreviewGrid();
    }
  }
}