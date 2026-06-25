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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { SwitchStartInfo as StartInfo, SwitchType } from '../../statemanager/common/SwitchStartInfo';
import lazy { FormIndex, FORM_SIZE, PullDownState } from '../../statemanager/constants/GridDefine';
import lazy { GridObserverProxy } from '../../statemanager/GridStateManager';
import lazy { GridStateObserverProxy as ObserverProxy } from '../../statemanager/GridStateObserverProxy';
import lazy { SwitchCommonUtils as ScUtils } from './SwitchCommonUtils';

const TAG: string = 'SwitchCalcUtils';

/* instrument ignore file */

/**
 * 对象模式
 */
export enum AlignMode {
  /**
   * 顶部对齐
   */
  TOP,

  /**
   * 中间对齐
   */
  MIDDLE,
}

/**
 * 切换计算参数
 */
export class CalcParams {
  /**
   * 起始信息
   */
  public startInfo?: StartInfo;

  /**
   * 观察者代理
   */
  public observerProxy?: ObserverProxy;

  /**
   * 起始形态（未指定时，使用startInfo中的startForm）
   */
  public startForm?: FormIndex = FormIndex.INVALID;

  /**
   * 目标形态
   */
  public targetForm: FormIndex = FormIndex.INVALID;

  /**
   * 锚点对齐方式
   */
  public anchorAlignMode: AlignMode = AlignMode.MIDDLE;
}

/**
 * 切换计算结果
 */
export class CalcResult {
  /**
   * 补位信息
   */
  public fillPosition: number = 0;
  /**
   * 滚动距离
   */
  public scrollOffset: number = 0;

  /**
   * 锚点中心X轴坐标
   */
  public centerX: number = 0;

  /**
   * 首个可见宫格的索引项
   */
  public firstIndex: number = 0;
}

/**
 * 切换计算工具类，计算切换时的补位和偏移信息
 */
export class SwitchCalcUtils {
  private constructor() {
  }

  /**
   * 计算切换信息（包括：补位、滚动距离、锚点中心）
   *
   * @param calcParams 计算参数
   * @returns 切换结果信息
   */
  public static calcSwitch(calcParams: CalcParams): CalcResult | undefined {
    if (!SwitchCalcUtils.isValidCalcParams(calcParams)) {
      return undefined;
    }

    const startInfo: StartInfo = calcParams.startInfo as StartInfo;
    const op: ObserverProxy = calcParams.observerProxy as ObserverProxy;
    const gridOp = op.gridObserverProxy;
    const startForm: FormIndex = calcParams.startForm ?? startInfo.startForm;
    const targetForm: FormIndex = calcParams.targetForm;
    const alignMode: AlignMode = calcParams.anchorAlignMode;

    // 计算补位
    let fillPosition = SwitchCalcUtils.calcFillPosition(startInfo, targetForm, gridOp);

    // 计算滚动
    let scrollOffset = SwitchCalcUtils.calcScrollOffset(startInfo, targetForm, op, fillPosition, alignMode);

    // 计算中心点X轴坐标
    let centerX = SwitchCalcUtils.calcAnchorCenterX(startInfo, startForm, targetForm, gridOp);

    // 计算首个可见宫格
    let firstIndex = SwitchCalcUtils.calcFirstIndex(targetForm, op, scrollOffset);

    if (firstIndex === 0 && fillPosition > 0) {
      LogUtils.info(op.tag, 'GRID_SWITCH fillPosition invalid at top, remove fillPosition');
      fillPosition = 0;
      scrollOffset = SwitchCalcUtils.calcScrollOffset(startInfo, targetForm, op, fillPosition, alignMode);
      firstIndex = SwitchCalcUtils.calcFirstIndex(targetForm, op, scrollOffset);
    }
    LogUtils.info(op.tag, `GRID_SWITCH calcSwitch ${FormIndex[startForm]}->${FormIndex[targetForm]} ` +
      `startInfo ${startInfo}, alignMode: ${AlignMode[alignMode]} result: [fillPosition: ${fillPosition}, ` +
      `scrollOffset: ${scrollOffset}, centerX: ${centerX}, firstIndex: ${firstIndex}]`);
    return { fillPosition: fillPosition, scrollOffset: scrollOffset, centerX: centerX, firstIndex: firstIndex };
  }

  /**
   * 计算首个可见的index (被裁剪也是可见)
   *
   * @param gridForm 视图类型
   * @param op 观察者代理
   * @param scrollOffset 滚动位移
   * @returns 首个可见宫格索引
   */
  public static calcFirstIndex(gridForm: FormIndex, op: ObserverProxy, scrollOffset: number): number {
    if (gridForm === FormIndex.GROUP_DAY) {
      return SwitchCalcUtils.calcGroupFirstIndex(gridForm, op, scrollOffset);
    } else {
      return SwitchCalcUtils.calcDefaultFirstIndex(gridForm, op.gridObserverProxy, scrollOffset);
    }
  }

  public static calcScrollOffset(startInfo: StartInfo, gridForm: FormIndex, op: ObserverProxy,
    fillPosition: number, alignMode: AlignMode): number {
    if (op.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.FULL &&
      op.gridObserverProxy.getScrollOffset() === 0 && startInfo.switchType === SwitchType.SWITCH_BUTTON) {
      // 消息头下拉时，直接滚动到0
      LogUtils.debug(op.tag, 'calcGroupScrollOffset IsHeadMsgPullDown');
      return 0;
    }
    if (gridForm === FormIndex.GROUP_DAY) {
      return SwitchCalcUtils.calcGroupScrollOffset(startInfo, gridForm, op, alignMode);
    } else {
      return SwitchCalcUtils.calcDefaultScrollOffset(startInfo, gridForm, op, fillPosition,
        alignMode);
    }
  }

  private static isValidCalcParams(calcParams: CalcParams): boolean {
    if (!calcParams.startInfo) {
      LogUtils.warn(TAG, 'GRID_SWITCH calcSwitch invalid startInfo.');
      return false;
    }
    if (!calcParams.observerProxy) {
      LogUtils.warn(TAG, 'GRID_SWITCH calcSwitch invalid observerProxy.');
      return false;
    }
    if (calcParams.targetForm < 0 || calcParams.targetForm >= FORM_SIZE) {
      LogUtils.warn(TAG, 'GRID_SWITCH calcSwitch invalid targetForm.');
      return false;
    }
    return true;
  }

  private static calcFillPosition(startInfo: StartInfo, gridForm: FormIndex, gridOp: GridObserverProxy): number {
    if (!gridOp.getIsSupportFp(gridForm)) {
      // 不支持补位场景，直接返回0
      return 0;
    }
    // 目标锚点图片所在列
    const targetColumn: number = ScUtils.getAnchorColumn(startInfo.startX, gridOp, gridForm);
    const gridColumn: number = gridOp.getGridColumn(gridForm); // 宫格列数
    const originalColumn: number = startInfo.anchorItemIndex % gridColumn; // 从0开始排时的列数
    let fillPosition: number = targetColumn - originalColumn;
    if (fillPosition < 0) {
      fillPosition += gridColumn;
    }
    return fillPosition;
  }

  private static calcDefaultScrollOffset(startInfo: StartInfo, gridForm: FormIndex, op: ObserverProxy,
    fillPosition: number, alignMode: AlignMode): number {
    const gridOp = op.gridObserverProxy;
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm); // 宫格上方不规则区域高度
    const aboveImageRows: number = Math.floor(
      (startInfo.anchorItemIndex + fillPosition) / gridOp.getGridColumn(gridForm)); // 上方图片行数
    const imageHeightWithGutter: number = ScUtils.getImageHeight(gridOp, gridForm);
    const hideGridHeight: number = aboveImageRows * imageHeightWithGutter; // 被挡住宫格总高度
    const imageAlignHeight: number = alignMode === AlignMode.TOP ? 0 : gridOp.getGridImageHeight(gridForm) / 2;
    let scrollOffset = irregularHeight + hideGridHeight + imageAlignHeight - startInfo.anchorCenterY;
    return Math.min(Math.max(scrollOffset, 0), ScUtils.calcMaxOffset(op, gridForm));
  }

  private static calcGroupScrollOffset(startInfo: StartInfo, gridForm: FormIndex, op: ObserverProxy,
    alignMode: AlignMode): number {
    const gridOp = op.gridObserverProxy;
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm); // 宫格上方不规则区域高度
    // 根据索引找分组
    const groupIndex = ScUtils.findGroupIndexByTotalIndex(op, startInfo.anchorItemIndex);
    const groupFirstIndex = ScUtils.getGroupStartIndex(op, groupIndex);
    // 索引所在行
    const groupRow = Math.floor((startInfo.anchorItemIndex - groupFirstIndex) / gridOp.getGridColumn(gridForm));
    const imageHeightWithGutter: number = ScUtils.getImageHeight(gridOp, gridForm);
    // 被挡住宫格总高度
    const hideGridHeight: number = ScUtils.getGroupStartOffset(op, groupIndex) +
      ScUtils.getGroupTitleHeight(gridOp, gridForm) + groupRow * imageHeightWithGutter;
    const imageAlignHeight: number = alignMode === AlignMode.TOP ? 0 : gridOp.getGridImageHeight(gridForm) / 2;
    let scrollOffset = irregularHeight + hideGridHeight + imageAlignHeight - startInfo.anchorCenterY;
    return Math.min(Math.max(scrollOffset, 0), ScUtils.calcMaxOffset(op, gridForm));
  }

  private static calcAnchorCenterX(startInfo: StartInfo, startForm: FormIndex, targetForm: FormIndex,
    gridOp: GridObserverProxy): number {
    // 源信息
    const originalWidth: number = ScUtils.getImageWidth(gridOp, startForm);
    const originalColumn: number = ScUtils.getAnchorColumn(startInfo.startX, gridOp, startForm);
    const originalStartX: number = originalColumn * originalWidth;

    // 目标信息
    const targetWidth: number = ScUtils.getImageWidth(gridOp, targetForm);
    const targetColumn: number = ScUtils.getAnchorColumn(startInfo.startX, gridOp, targetForm);
    const targetStartX: number = targetColumn * targetWidth;

    // 计算中心点X轴坐标
    let anchorCenterX: number = originalStartX;
    if (originalWidth !== targetWidth) {
      anchorCenterX += (originalStartX - targetStartX) * originalWidth / (targetWidth - originalWidth);
    }
    return anchorCenterX;
  }

  private static calcDefaultFirstIndex(gridForm: FormIndex, gridOp: GridObserverProxy, scrollOffset: number): number {
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm); // 宫格上方不规则区域高度
    if (scrollOffset <= irregularHeight) {
      return 0;
    }
    return gridOp.getGridColumn(gridForm) *
      Math.floor((scrollOffset - irregularHeight) / ScUtils.getImageHeight(gridOp, gridForm));
  }

  public static calcGroupFirstIndex(gridForm: FormIndex, op: ObserverProxy, scrollOffset: number): number {
    const gridOp = op.gridObserverProxy;
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm); // 宫格上方不规则区域高度
    if (scrollOffset <= irregularHeight) {
      return 0;
    }
    // 分组头高度
    const groupTitleHeight: number = ScUtils.getGroupTitleHeight(gridOp, gridForm);
    // 计算遮挡高度
    const occlusionHeight: number = ScUtils.getTopOcclusionHeight(op);
    // 否则部分宫格已不可见，需要计算遮挡宫格行数
    const gridOcclusionHeight = scrollOffset + occlusionHeight - irregularHeight;
    const groupIndex = ScUtils.findGroupIndexByOffset(op, gridOcclusionHeight);

    // 分组被遮挡高度
    const groupOcclusionHeight = gridOcclusionHeight - ScUtils.getGroupStartOffset(op, groupIndex);
    if (groupOcclusionHeight <= groupTitleHeight) {
      return ScUtils.getGroupStartIndex(op, groupIndex);
    }
    // 遮挡行数
    const imageHeight = ScUtils.getImageHeight(gridOp, gridForm);
    const occlusionRowCount = Math.floor((groupOcclusionHeight - groupTitleHeight) / imageHeight);
    return ScUtils.getGroupStartIndex(op, groupIndex) + occlusionRowCount * gridOp.getGridColumn(gridForm);
  }
}