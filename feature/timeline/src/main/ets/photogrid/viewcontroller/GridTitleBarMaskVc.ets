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
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { ShowMode } from '../statemanager/constants/GridDefine';
import lazy { DefaultVm } from '../viewmodel/DefaultVm';
import lazy { BaseAttributeUpdater, AbstractVc } from './AbstractVc';
import lazy { AnimationOpacity } from './animation/AnimationDefine';
import lazy { ViewId, ViewZIndex } from './constants/ViewDefine';
import uiEffect from '@ohos.graphics.uiEffect';
import lazy { curves } from '@kit.ArkUI';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

const MATH_TREBLE: number = 3;
const MATH_DOUBLE: number = 2;
const TAG: string = 'GridTitleBarMaskVc';
const HEAD_BLUR_RADIUS: number = 16;
const MASK_OPACITY_DURATION: number = 150;

/**
 * 标题栏下方蒙层属性更新器
 */
export class GridTitleBarMaskAttributeUpdater extends BaseAttributeUpdater<ColumnAttribute> {
  protected override enabled: boolean = false;

  protected override initInstance(instance: ColumnAttribute): void {
    super.initInstance(instance);
    instance
      .id(ViewId.TITLE_BAR_MASK)
      .zIndex(ViewZIndex.TITLE_BAR_MASK)
      .accessibilityLevel('no-hide-descendants')
      .alignRules({
        top: { anchor: ViewId.CONTAINER, align: VerticalAlign.Top },
        start: { anchor: ViewId.CONTAINER, align: HorizontalAlign.Start },
        end: { anchor: ViewId.CONTAINER, align: HorizontalAlign.End },
      });
  }
}

/**
 * 标题栏下方蒙层属性更新器
 */
export class MaskAttributeUpdater extends BaseAttributeUpdater<ColumnAttribute> {
  protected override enabled: boolean = false;
  private filter: uiEffect.Filter = uiEffect.createFilter();
  curve = curves.cubicBezierCurve(0.37, 0.0, 0.36, 0.73);
  curve2 = curves.cubicBezierCurve(0.6, 0.0, 0.7, 1.0);
  private color: number = 0.3;

  protected override initInstance(instance: ColumnAttribute): void {
    let isSupportBlur: boolean = !UiUtil.isLiteDeviceUI();
    if (isSupportBlur) {
      super.initInstance(instance);
      instance
        .alignItems(HorizontalAlign.Start)
        .height(this.height)
        .opacity(0)
        .width('100%')
        .compositingFilter(this.getBlurCompositingFilter(this.filter))
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors:
          [
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0))*this.color + ')', 0],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.05))*this.color + ')', 0.05],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.1))*this.color + ')', 0.1],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.15))*this.color + ')', 0.15],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.2))*this.color + ')', 0.2],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.25))*this.color + ')', 0.25],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.3))*this.color + ')', 0.3],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.35))*this.color + ')', 0.35],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.4))*this.color + ')', 0.4],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.45))*this.color + ')', 0.45],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.5))*this.color + ')', 0.5],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.55))*this.color + ')', 0.55],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.6))*this.color + ')', 0.6],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.65))*this.color + ')', 0.65],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.7))*this.color + ')', 0.7],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.75))*this.color + ')', 0.75],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.8))*this.color + ')', 0.8],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.85)) *this.color+ ')', 0.85],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.9))*this.color + ')', 0.9],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(0.95))*this.color + ')', 0.95],
            ['rgba(0, 0, 0, ' + (1- this.curve2.interpolate(1))*this.color +')', 0.999],
            ['#00000000', 1]
          ],
        })
    } else {
      super.initInstance(instance);
      instance
        .alignItems(HorizontalAlign.Start)
        .height(this.height)
        .opacity(0)
        .width('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [[$r('app.color.timeline_mask_end_color'), 0.0], [$r('app.color.timeline_mask_start_color'), 1.0]],
        })
    }
  }
  /**
   * 设置渐变模糊合成滤镜效果
   *
   * @param filter Filter实例
   * @returns filter | undefined 挂载了模糊效果的Filter实例，异常时返回undefined
   */
  public getBlurCompositingFilter(filter: uiEffect.Filter): Filter | undefined {
    try {
      filter = uiEffect.createFilter();
      return filter.radiusGradientBlur(HEAD_BLUR_RADIUS, {
        fractionStops: [
          [1- this.curve.interpolate(0), 0],
          [1 - this.curve.interpolate(0.1), 0.1],
          [1 - this.curve.interpolate(0.3), 0.3],
          [1 - this.curve.interpolate(0.4), 0.4],
          [1 - this.curve.interpolate(0.5), 0.5],
          [1 - this.curve.interpolate(0.6), 0.6],
          [1 - this.curve.interpolate(0.7), 0.7],
          [1 - this.curve.interpolate(0.8), 0.8],
          [1 - this.curve.interpolate(0.85), 0.85],
          [1 - this.curve.interpolate(0.9), 0.9],
          [1 - this.curve.interpolate(0.95), 0.95],
          [1 - this.curve.interpolate(1), 1]
        ],
        direction: GradientDirection.Bottom
      });
    } catch (e) {
      LogUtils.error(TAG, `get HeadBlurArea radiusGradientBlur failed, err: ${e}`);
      return undefined;
    }
  }
}

/**
 * 宫格标题栏蒙层控制器
 */
@Observed
export class GridTitleBarMaskVc extends AbstractVc<DefaultVm, GridTitleBarMaskAttributeUpdater> {
  /**
   * 是否可显示
   */
  @Track public maskUpdater: MaskAttributeUpdater = new MaskAttributeUpdater();
  // 照片页右上角按钮的上下padding
  private readonly menuButtonPadding: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('sys.float.padding_level4')));
  // 照片页右上角按钮内容高度
  private readonly menuButtonContentHeight: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('app.float.action_bar_button_height')));
  // 照片页右上角按钮高度
  private readonly menuButtonHeight: number = MATH_DOUBLE * this.menuButtonPadding + this.menuButtonContentHeight;

  public constructor() {
    super(new GridTitleBarMaskAttributeUpdater(), 'GridTitleBarMaskVc', ShowMode.VISIBLE);
  }

  protected override initStates(): void {
    super.initStates();
    let isSupportBlur: boolean = !UiUtil.isLiteDeviceUI();

    // 沉浸态时显示
    this.gridObserverProxy.getIsImmersive((_oldState, isImmersive) => {
      LogUtils.info(this.tag, `GridTitleBarMask updateOpacity isImmersive:${isImmersive}`);
      let maskOpacity: number = AnimationOpacity.DEFAULT;
      if (!isImmersive) {
        maskOpacity = AnimationOpacity.TRANSPARENT;
      }
      animateToImmediately({
        curve: Curve.Sharp,
        duration: MASK_OPACITY_DURATION,
        onFinish: () => {
          LogUtils.info(this.tag, `GridTitleBarMask onFinish:${isImmersive}`);
        }
      }, () => {
        this.attributeUpdater.updateVisible(isImmersive);
        this.maskUpdater.updateOpacity(maskOpacity);
      })
    });

    // 设置高度
    this.displayObserverProxy.getTopAvoidHeight((_oldState, topAvoidHeight) => {
      //渐变模糊时为组件高度+32vp
      let maskHeight: number = isSupportBlur ? topAvoidHeight + this.menuButtonHeight + 32 :
        topAvoidHeight + MATH_TREBLE * this.menuButtonHeight;
      LogUtils.info(this.tag, `updateHeight: ${maskHeight}`);
      this.maskUpdater.updateHeight(maskHeight);
    });
  }
}