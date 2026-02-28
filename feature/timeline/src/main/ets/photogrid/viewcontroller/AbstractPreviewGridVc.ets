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
import lazy { FormStateType, FormStateTypeUtils } from '../statemanager/GridFormFsm';
import lazy { PreloadStateType, PreloadStateTypeUtils } from '../statemanager/GridPreloadFsm';
import lazy { AbstractPreviewGridVm } from '../viewmodel/AbstractPreviewGridVm';
import lazy { AbstractFormVc } from './AbstractFormVc';
import lazy { GridAttributeUpdater } from './AbstractGridVc';
import lazy { ViewId } from './constants/ViewDefine';
import lazy { LengthMetrics } from '@kit.ArkUI';

/**
 * 预览宫格属性更新器
 */
export class PreviewGridAttributeUpdater extends GridAttributeUpdater {
  protected override initInstance(instance: GridAttribute): void {
    super.initInstance(instance);
    instance
      .alignRules({
        top: { anchor: ViewId.TITLE_BAR, align: VerticalAlign.Bottom },
        bottom: { anchor: ViewId.CONTAINER, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
  }
}

/**
 * 抽象预览宫格视图控制器
 */
@Observed
export abstract class AbstractPreviewGridVc<V extends AbstractPreviewGridVm, U extends PreviewGridAttributeUpdater>
  extends AbstractFormVc<V, U, GridAttribute> {
  /**
   * 宫格宽度
   */
  @Track public gridItemWidth: number = 0;
  /**
   * 宫格加载数目
   */
  @Track public drawnThumbnailCount: number = 0;
  /**
   * 加载数目限制
   */
  protected drawnCountPointPhone: number = 28;

  protected override initStates(): void {
    super.initStates();

    // 更新宫格左右padding
    let gridPaddingLeftAndRight: number = this.gridObserverProxy.getGridPaddingLeftAndRight();
    this.attributeUpdater.updatePadding({
      start: LengthMetrics.vp(gridPaddingLeftAndRight),
      end: LengthMetrics.vp(gridPaddingLeftAndRight),
    });
    
    // 更新行间距
    this.attributeUpdater.updateGridGutter(this.gridObserverProxy.getGridImageGutter(this.gridForm));

    // 更新列间距
    this.attributeUpdater.updateGridColumnGutter(this.gridObserverProxy.getGridImageColumnGutter(this.gridForm));

    // 初始化宫格高度
    this.gridObserverProxy.getGridImageHeight(this.gridForm, (_oldState, gridItemWidth) => {
      this.gridItemWidth = gridItemWidth;
    });

    // 初始化宫格列数监听
    this.gridObserverProxy.getGridColumn(this.gridForm, (_oldState, gridColumn) => {
      this.attributeUpdater.updateGridColumn(gridColumn);
    });

    // 性能打点需要等待绘制完成的节点数量
    this.drawnThumbnailCount = Math.min(this.viewModel?.totalCount() ?? 0, this.drawnCountPointPhone);
    this.registerDataSourceListener({
      onDataUpdate: (count) => {
        this.drawnThumbnailCount = Math.min(count, this.drawnCountPointPhone);
      }
    });

    // 监听形态状态机
    this.getFormState((_oldState, newState): void => {
      this.updateIsCanShowState(newState, this.getPreloadState());
    });

    // 监听预加载状态机，放在最后，若以完成加载，则清楚所有监听
    this.getPreloadState((_oldState, newState): void => {
      this.updateIsCanShowState(this.getFormState(), newState);
      if (newState === PreloadStateType.HIDDEN_STATE) {
        // 主宫格加载后，取消所有监听，避免性能浪费
        this.release();
        this.viewModel?.preloadViewHidden();
      }
    });
    this.isShow = true;
  }

  private updateIsCanShowState(formState: FormStateType, preloadState: PreloadStateType): void {
    let isCanShow: boolean = FormStateTypeUtils.isInFormState(formState, this.gridForm) &&
    PreloadStateTypeUtils.isInPreloadState(preloadState);
    LogUtils.info(this.tag, `preloadViewHidden updateIsCanShowState:${isCanShow}`);
    this.updateCanShowState(isCanShow);
    this.proxy.gridStateManager.updateIsShowPreview(isCanShow,
      'updateIsShowPreview');
  }
}