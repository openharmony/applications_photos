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

import lazy componentSnapshot from '@ohos.arkui.componentSnapshot';
import lazy image from '@ohos.multimedia.image';
import lazy { StateChangeCallback } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { RestoreFpStateType } from '../statemanager/GridRestoreFpFsm';
import lazy { GridSnapshotVm } from '../viewmodel/GridSnapshotVm';
import lazy { AbstractFormVc } from './AbstractFormVc';
import lazy { BaseAttributeUpdater } from './AbstractVc';
import lazy { AnimationCurve, AnimationDuration, AnimationOpacity } from './animation/AnimationDefine';
import lazy { ViewId } from './constants/ViewDefine';

/**
 * 宫格截图属性更新器
 */
export class GridSnapshotAttributeUpdater extends BaseAttributeUpdater<ImageAttribute> {
  // 缩略图Y轴偏移距离
  private snapshotOffset: number = 0;

  /**
   * 更新缩略图Y轴偏移距离
   *
   * @param snapshotOffset 缩略图Y轴偏移距离
   */
  public updateSnapshotOffset(snapshotOffset: number): void {
    if (this.snapshotOffset !== snapshotOffset) {
      this.snapshotOffset = snapshotOffset;
      this.attribute?.offset({ y: this.snapshotOffset });
    }
  }

  protected override initInstance(instance: ImageAttribute): void {
    super.initInstance(instance);
    instance
      .clip(false)
      .draggable(false)
      .hitTestBehavior(HitTestMode.Transparent)
      .objectFit(ImageFit.TOP)
      .alignRules({
        top: { anchor: ViewId.CONTAINER, align: VerticalAlign.Top },
        bottom: { anchor: ViewId.CONTAINER, align: VerticalAlign.Bottom },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      })
      .offset({ y: this.snapshotOffset });
  }
}

/**
 * 宫格截图视图控制器
 */
@Observed
export class GridSnapshotVc extends AbstractFormVc<GridSnapshotVm, GridSnapshotAttributeUpdater, ImageAttribute> {
  /**
   * 截图
   */
  @Track public snapShotImage?: image.PixelMap;
  // 更新滚动距离回调
  private readonly scrollOffsetListener: StateChangeCallback<number> = () => this.updateSnapshotOffset('scrollOffset');
  private readonly irregularHeightListener: StateChangeCallback<number> =
    () => this.updateSnapshotOffset('irregularHeight');

  public constructor(gridForm: FormIndex, viewId?: string, zIndex?: number) {
    super(gridForm, new GridSnapshotAttributeUpdater(viewId, zIndex), `${FormIndex[gridForm]}GridSnapshotVc`);
  }

  protected override initStates(): void {
    super.initStates();

    this.registerFillPositionObserver();
  }

  private registerFillPositionObserver(): void {
    if (!this.gridObserverProxy.getIsSupportFp(this.gridForm)) {
      return;
    }

    this.gridObserverProxy.getRestoreFpState(this.gridForm, (_oldState, restoreFpState) => {
      switch (restoreFpState) {
        case RestoreFpStateType.IDLE_STATE:
        case RestoreFpStateType.FILL_POSITION_STATE:
          this.cancelRestoreAnimation();
          break;
        case RestoreFpStateType.ANIMATION_PREPARE_STATE:
          this.prepareRestoreAnimation();
          break;
        case RestoreFpStateType.ANIMATION_READY_STATE:
          this.doRestoreAnimation();
          break;
      }
    });
  }

  private prepareRestoreAnimation(): void {
    // 准备动作
    const firstItemTop = this.getFirstItemTop();
    this.attributeUpdater.updateSnapshotOffset(firstItemTop);
    this.attributeUpdater.updateOpacity(AnimationOpacity.DEFAULT);
    this.gridObserverProxy.getScrollOffset(this.gridForm, this.scrollOffsetListener);
    this.gridObserverProxy.getIrregularHeight(this.gridForm, this.irregularHeightListener);
    if (!this.doSnapshot(firstItemTop)) {
      this.viewModel?.notifyAnimationComplete();
    }
  }

  private doSnapshot(firstItemTop: number): boolean {
    const gridSize = this.displayObserverProxy.getGridAreaSize();
    if (firstItemTop < 0 || firstItemTop > gridSize.height / 2) {
      return false;
    }
    try {
      this.snapShotImage = componentSnapshot.getSync(this.getGridViewId(), {
        waitUntilRenderFinished: true,
        region: {
          left: 0,
          right: vp2px(gridSize.width),
          top: vp2px(firstItemTop),
          bottom: vp2px(gridSize.height),
        }
      });
    } catch (err) {
      LogUtils.error(this.tag, `doSnapshot failed, error message: ${err?.code}, ${err?.msg}`);
      return false;
    }
    return true;
  }

  private getGridViewId(): string {
    switch (this.gridForm) {
      case FormIndex.DAY:
        return ViewId.DAY_GRID;
      case FormIndex.YEAR:
        return ViewId.YEAR_GRID;
      case FormIndex.MONTH:
        return ViewId.MONTH_GRID;
    }
    return ViewId.DAY_GRID;
  }

  private cancelRestoreAnimation(): void {
    this.snapShotImage = undefined;
    this.gridObserverProxy.releaseCallback(this.scrollOffsetListener);
    this.gridObserverProxy.releaseCallback(this.irregularHeightListener);
  }

  private doRestoreAnimation(): void {
    animateTo({
      duration: AnimationDuration.RESTORE_FILL_POSITION,
      curve: AnimationCurve.SHARP_CURVE,
      onFinish: () => {
        this.viewModel?.notifyAnimationComplete();
      }
    }, () => {
      this.attributeUpdater.updateOpacity(AnimationOpacity.TRANSPARENT);
    });
  }

  private updateSnapshotOffset(reason?: string): void {
    if (!!this.snapShotImage) {
      const snapshotOffset = this.getFirstItemTop();
      this.attributeUpdater.updateSnapshotOffset(snapshotOffset);
      LogUtils.info(this.tag, `updateSnapshotOffset: ${snapshotOffset} reason: ${reason}`);
    }
  }

  private getFirstItemTop(): number {
    return this.gridObserverProxy.getIrregularHeight(this.gridForm) -
      this.gridObserverProxy.getScrollOffset(this.gridForm);
  }
}