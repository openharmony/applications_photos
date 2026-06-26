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
import lazy { FormIndex, PullDownState } from '../../statemanager/constants/GridDefine';
import lazy { GridStateObserverProxy as ObserverProxy } from '../../statemanager/GridStateObserverProxy';
import lazy { SwitchCommonUtils as ScUtils } from './SwitchCommonUtils';

/* instrument ignore file */

/**
 * 切换开始工具类
 */
export class SwitchStartUtils {
  private constructor() {
  }

  /**
   * 构建胶囊切换开始信息
   *
   * @param op 状态观察者代理
   * @returns 切换开始信息
   */
  public static buildButtonSwitchStartInfo(op: ObserverProxy): StartInfo {
    const startInfo: StartInfo = new StartInfo(SwitchType.SWITCH_BUTTON, op.getCurrentForm(), 0, 0);
    SwitchStartUtils.fillAnchorByFirstItem(startInfo, op);
    LogUtils.info(op.tag, `GRID_SWITCH buildButtonSwitchStartInfo startInfo: ${startInfo}`);
    return startInfo;
  }

  /**
   * 构建点击宫格切换开始信息
   *
   * @param op 状态观察者代理
   * @param startX 点击点X轴坐标
   * @param startY 点击点Y轴坐标
   * @param anchorIndex 指定切换锚点
   * @returns 切换开始信息
   */
  public static buildClickGridStartInfo(op: ObserverProxy, startX: number, startY: number,
    anchorIndex?: number): StartInfo {
    const startInfo: StartInfo = new StartInfo(SwitchType.CLICK_GRID, op.getCurrentForm(), startX, startY);
    SwitchStartUtils.fillAnchorInfoByCenterPoint(startInfo, op, anchorIndex);
    LogUtils.info(op.tag, `GRID_SWITCH buildClickGridStartInfo startInfo: ${startInfo}`);
    return startInfo;
  }

  /**
   * 取首个完整可见宫格为锚点图片
   *
   * @param startInfo 切换开始信息
   * @param op 状态观察者代理
   */
  private static fillAnchorByFirstItem(startInfo: StartInfo, op: ObserverProxy): void {
    if (op.gridObserverProxy.getHeadMsgPullDownState() === PullDownState.FULL &&
      op.gridObserverProxy.getScrollOffset() === 0) {
      // 消息头下拉时，取消息头下方为锚点
      startInfo.anchorCenterY = op.gridObserverProxy.getHeadMsgHeight();
      startInfo.anchorItemIndex = 0;
      LogUtils.debug(op.tag, 'fillAnchorByFirstItem IsHeadMsgPullDown');
      return;
    }
    if (startInfo.startForm === FormIndex.GROUP_DAY) {
      SwitchStartUtils.fillGroupAnchorByFirstItem(startInfo, op);
    } else {
      SwitchStartUtils.fillDefaultAnchorByFirstItem(startInfo, op);
    }
  }

  /**
   * 取中心点所在宫格为锚点图片
   *
   * @param startInfo 切换开始信息
   * @param op 状态观察者代理
   * @param anchorIndex 指定切换锚点
   */
  private static fillAnchorInfoByCenterPoint(startInfo: StartInfo, op: ObserverProxy, anchorIndex?: number): void {
    if (startInfo.startForm === FormIndex.GROUP_DAY) {
      SwitchStartUtils.fillGroupAnchorByCenterPoint(startInfo, op, anchorIndex);
    } else {
      SwitchStartUtils.fillDefaultAnchorByCenterPoint(startInfo, op, anchorIndex);
    }
  }

  private static fillDefaultAnchorByFirstItem(startInfo: StartInfo, op: ObserverProxy): void {
    const gridOp = op.gridObserverProxy;
    // 计算遮挡高度
    const occlusionHeight: number = ScUtils.getTopOcclusionHeight(op);
    // 宫格上方不规则区域高度
    const irregularHeight: number = gridOp.getIrregularHeight();
    // 当前宫格偏移
    const yOffSet: number = gridOp.getScrollOffset();
    let startY: number;
    let anchorItemIndex: number;
    if (irregularHeight - yOffSet >= occlusionHeight) {
      // 此时第一个宫格完全可见
      startY = irregularHeight - yOffSet;
      anchorItemIndex = 0;
      LogUtils.debug(op.tag, `GRID_SWITCH no grid obscured, yOffSet: ${yOffSet}, occlusionHeight: ${occlusionHeight}`);
    } else {
      // 否则部分宫格已不可见，需要计算遮挡宫格行数
      const imageHeight: number = ScUtils.getImageHeight(gridOp);
      const rowCounts: number = Math.ceil((yOffSet + occlusionHeight - irregularHeight) / imageHeight);
      startY = rowCounts * imageHeight + (irregularHeight - yOffSet);
      anchorItemIndex = rowCounts * gridOp.getGridColumn() - gridOp.getFillPostion();
      LogUtils.debug(op.tag, `GRID_SWITCH grid obscured, yOffSet: ${yOffSet}, rowCounts: ${rowCounts}`);
    }
    startInfo.anchorCenterY = startY;
    startInfo.anchorItemIndex = Math.max(anchorItemIndex, 0);
    LogUtils.debug(op.tag, `GRID_SWITCH fillDefaultAnchorByFirstItem, startType: ` +
      `${SwitchType[startInfo.switchType]}, anchorItemIndex: ${anchorItemIndex}`);
  }

  private static fillDefaultAnchorByCenterPoint(startInfo: StartInfo, op: ObserverProxy, anchorIndex?: number): void {
    // 计算锚点图片
    const gridOp = op.gridObserverProxy;

    // 宫格上方不规则区域高度
    const irregularHeight: number = gridOp.getIrregularHeight();
    // 当前宫格偏移
    const yOffSet: number = gridOp.getScrollOffset();
    if (startInfo.startY + yOffSet < irregularHeight) {
      // 点击处无宫格
      return;
    }

    // 宫格大小，包括边距
    const imageHeightWithGutter: number = ScUtils.getImageHeight(gridOp);
    // 计算Y值所在行数
    const row: number = Math.floor((startInfo.startY + yOffSet - irregularHeight) / imageHeightWithGutter);
    // 计算X值所在列数
    const column: number = ScUtils.getAnchorColumn(startInfo.startX, gridOp);
    // 锚点图片
    const anchorItemIndex: number = row * gridOp.getGridColumn() + column - gridOp.getFillPostion();
    if (anchorItemIndex < 0 || anchorItemIndex >= op.totalCount()) {
      // 此时说明点击处无宫格
      LogUtils.info(op.tag, `GRID_SWITCH fillDefaultAnchorByCenterPoint, startType: ` +
        `${SwitchType[startInfo.switchType]}, anchorItemIndex: ${anchorItemIndex}, total: ${op.totalCount()}`);
      return;
    }

    // 宫格高度
    const imageHeight: number = gridOp.getGridImageHeight();
    if (anchorIndex !== undefined) {
      startInfo.anchorItemIndex = anchorIndex;
    } else {
      startInfo.anchorItemIndex = anchorItemIndex;
    }
    startInfo.anchorCenterY = (irregularHeight + row * imageHeightWithGutter - yOffSet) + imageHeight / 2;
    LogUtils.debug(op.tag, `GRID_SWITCH fillDefaultAnchorByCenterPoint, startType: ` +
      `${SwitchType[startInfo.switchType]}, anchorItemIndex: ${startInfo.anchorItemIndex}`);
  }

  private static fillGroupAnchorByFirstItem(startInfo: StartInfo, op: ObserverProxy): void {
    const gridOp = op.gridObserverProxy;
    // 计算遮挡高度
    const occlusionHeight: number = ScUtils.getTopOcclusionHeight(op);
    // 宫格上方不规则区域高度
    const irregularHeight: number = gridOp.getIrregularHeight();
    // 分组头高度
    const groupTitleHeight: number = ScUtils.getGroupTitleHeight(gridOp);
    // 当前宫格偏移
    const yOffSet: number = gridOp.getScrollOffset();
    let startY: number;
    let anchorItemIndex: number;
    if (irregularHeight - yOffSet >= occlusionHeight) {
      // 此时第一个宫格完全可见
      startY = irregularHeight - yOffSet + groupTitleHeight;
      anchorItemIndex = 0;
      LogUtils.debug(op.tag, `GRID_SWITCH no grid obscured, yOffSet: ${yOffSet}, occlusionHeight: ${occlusionHeight}`);
    } else {
      // 否则部分宫格已不可见，需要计算遮挡宫格行数
      const gridOcclusionHeight = yOffSet + occlusionHeight - irregularHeight;
      // 锚点所在分组索引
      const groupIndex = ScUtils.findGroupIndexByOffset(op, gridOcclusionHeight);
      const groupStartOffset = ScUtils.getGroupStartOffset(op, groupIndex);
      // 所在分组被遮挡高度
      const groupOcclusionHeight = gridOcclusionHeight - groupStartOffset;
      if (groupOcclusionHeight <= groupTitleHeight) {
        startY = groupStartOffset + groupTitleHeight + (irregularHeight - yOffSet);
        anchorItemIndex = ScUtils.getGroupStartIndex(op, groupIndex);
        LogUtils.debug(op.tag, `GRID_SWITCH group no obscured, yOffSet: ${yOffSet}, groupIndex: ${groupIndex}`);
      } else {
        const imageHeight = ScUtils.getImageHeight(gridOp);
        const occlusionRow = Math.ceil((groupOcclusionHeight - groupTitleHeight) / imageHeight);
        const totalRowCount = Math.ceil(ScUtils.getGroupCount(op, groupIndex) / imageHeight);
        if (occlusionRow === totalRowCount && groupIndex < ScUtils.getTotalGroupSize(op) - 1) {
          // 所有行数都被遮挡，取下一个分组的第一个索引
          startY = ScUtils.getGroupStartOffset(op, groupIndex + 1) + groupTitleHeight + (irregularHeight - yOffSet);
          anchorItemIndex = ScUtils.getGroupStartIndex(op, groupIndex + 1);
          LogUtils.debug(op.tag, `GRID_SWITCH group all obscured, yOffSet: ${yOffSet}, groupIndex: ${groupIndex}`);
        } else {
          startY = ScUtils.getGroupStartOffset(op, groupIndex) + groupTitleHeight + occlusionRow * imageHeight +
            (irregularHeight - yOffSet);
          anchorItemIndex = ScUtils.getGroupStartIndex(op, groupIndex) + occlusionRow * gridOp.getGridColumn();
          LogUtils.debug(op.tag, `GRID_SWITCH group partial obscured, yOffSet: ${yOffSet}, groupIndex: ${groupIndex}`);
        }
      }
    }
    startInfo.anchorCenterY = startY;
    startInfo.anchorItemIndex = Math.max(anchorItemIndex, 0);
    LogUtils.debug(op.tag, `GRID_SWITCH fillGroupAnchorByFirstItem, startType: ${SwitchType[startInfo.switchType]}` +
      `, anchorItemIndex: ${anchorItemIndex}`);
  }

  private static fillGroupAnchorByCenterPoint(startInfo: StartInfo, op: ObserverProxy, anchorIndex?: number): void {
    // 计算锚点图片
    const gridOp = op.gridObserverProxy;

    // 宫格上方不规则区域高度
    const irregularHeight: number = gridOp.getIrregularHeight();
    // 当前宫格偏移
    const yOffSet: number = gridOp.getScrollOffset();
    if (startInfo.startY + yOffSet < irregularHeight) {
      // 点击处无宫格
      return;
    }

    // 分组头高度
    const groupTitleHeight: number = ScUtils.getGroupTitleHeight(gridOp);
    // 宫格大小，包括边距
    const imageHeightWithGutter: number = ScUtils.getImageHeight(gridOp);
    const gridOffset = startInfo.startY + yOffSet - irregularHeight;
    const groupIndex = ScUtils.findGroupIndexByOffset(op, gridOffset);
    const groupStartIndex = ScUtils.getGroupStartIndex(op, groupIndex);
    const groupStartOffset = ScUtils.getGroupStartOffset(op, groupIndex);
    const groupRow = Math.floor(Math.max(gridOffset - groupStartOffset - groupTitleHeight, 0) / imageHeightWithGutter);
    // 计算X值所在列数
    const column: number = ScUtils.getAnchorColumn(startInfo.startX, gridOp);
    // 锚点图片
    const anchorItemIndex = groupStartIndex + groupRow * gridOp.getGridColumn() + column;
    if (anchorItemIndex < 0 || anchorItemIndex >= op.totalCount()) {
      // 此时说明点击处无宫格
      LogUtils.info(op.tag, `GRID_SWITCH fillGroupAnchorByCenterPoint anchorItemIndex not found. ` +
        `startType: ${startInfo.switchType}, anchorItemIndex: ${anchorItemIndex}`);
      return;
    }

    // 宫格高度
    const imageHeight: number = gridOp.getGridImageHeight();
    if (anchorIndex !== undefined) {
      startInfo.anchorItemIndex = anchorIndex;
    } else {
      startInfo.anchorItemIndex = anchorItemIndex;
    }
    startInfo.anchorCenterY = groupStartOffset + groupTitleHeight + groupRow * imageHeightWithGutter +
      (irregularHeight - yOffSet) + imageHeight / 2;
    LogUtils.debug(op.tag, `GRID_SWITCH ${SwitchType[startInfo.switchType]} fillGroupAnchorByCenterPoint ` +
      `groupStartIndex: ${groupStartIndex} groupRow: ${groupRow}, column: ${column}, ` +
      `anchorItemIndex: ${startInfo.anchorItemIndex}`);
  }
}