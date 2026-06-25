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
import lazy { FormIndex, MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM } from '../../statemanager/constants/GridDefine';
import lazy { SWITCH_BOTTOM_MARGIN, SWITCH_HEIGHT, SWITCH_TOP_AVOID } from '../../statemanager/constants/SwitchDefine';
import lazy { GridObserverProxy } from '../../statemanager/GridStateManager';
import lazy { GridStateObserverProxy } from '../../statemanager/GridStateObserverProxy';

/* instrument ignore file */

/**
 * 图片项位置大小
 */
export interface ItemRect {
  /**
   * 左边位置
   */
  left: number;

  /**
   * 上方位置
   */
  top: number;

  /**
   * 右边位置
   */
  right: number;

  /**
   * 底部位置
   */
  bottom: number;
}

/**
 * 切换通用工具类
 */
export class SwitchCommonUtils {
  private constructor() {
  }

  /**
   * 计算宫格图片高度，包括行间距
   *
   * @param gridOp 宫格状态观察者代理
   * @param gridForm? 宫格形态
   * @returns 包括行间距的宫格图片高度
   */
  public static getImageHeight(gridOp: GridObserverProxy, gridForm?: FormIndex): number {
    return gridOp.getGridImageHeight(gridForm) + gridOp.getGridImageGutter(gridForm);
  }

  /**
   * 计算宫格图片宽度，包括间距
   *
   * @param gridOp 宫格状态观察者代理
   * @param gridForm? 宫格形态
   * @returns 包括行间距的宫格图片宽度
   */
  public static getImageWidth(gridOp: GridObserverProxy, gridForm?: FormIndex): number {
    return gridOp.getGridImageHeight(gridForm) + gridOp.getGridImageColumnGutter(gridForm);
  }

  /**
   * 计算锚点所在列
   *
   * @param startX 操作点X轴坐标
   * @param gridOp 宫格状态观察者代理
   * @param gridForm 宫格形态
   * @returns 锚点所在列
   */
  public static getAnchorColumn(startX: number, gridOp: GridObserverProxy, gridForm?: FormIndex): number {
    return Math.floor(startX / SwitchCommonUtils.getImageWidth(gridOp, gridForm))
  }

  /**
   * 查询分组头高度
   *
   * @param gridOp 宫格状态观察者代理
   * @param gridForm 宫格形态
   * @returns 分组头高度
   */
  public static getGroupTitleHeight(gridOp: GridObserverProxy, gridForm?: FormIndex): number {
    return gridOp.getGroupTitleHeight() + gridOp.getGridImageGutter(gridForm);
  }

  /**
   * 计算宫格顶部被遮挡高度
   *
   * @param op 宫格状态观察者代理
   * @returns 遮挡高度
   */
  public static getTopOcclusionHeight(op: GridStateObserverProxy): number {
    // 计算遮挡高度
    let occlusionHeight: number = 0;
    if (!op.gridObserverProxy.getIsImmersive()) {
      // 非沉浸态场景，遮挡高度为标题栏高度
      occlusionHeight += op.titleBarObserverProxy.getTitleBarHeight();
    }
    return occlusionHeight;
  }

  /**
   * 获取切换组件避让高度
   *
   * @returns 避让高度
   */
  public static getSwitchAvoidHeight(): number {
    return SWITCH_BOTTOM_MARGIN + SWITCH_HEIGHT + SWITCH_TOP_AVOID;
  }

  /**
   * 获取单个分组图片数量
   *
   * @param op 宫格状态观察者代理
   * @param groupIndex 分组索引
   * @returns 分组数量
   */
  public static getGroupCount(op: GridStateObserverProxy, groupIndex: number): number {
    return op.groupInfo.getGroupCount(groupIndex);
  }

  /**
   * 获取分组数量
   *
   * @param op 宫格状态观察者代理
   * @param groupIndex 分组索引
   * @returns 分组数量
   */
  public static getTotalGroupSize(op: GridStateObserverProxy): number {
    return op.groupInfo.groupSize;
  }

  /**
   * 获取分组总高度
   *
   * @param op 宫格状态观察者代理
   * @param gridForm 宫格形态
   * @param groupIndex 分组索引
   * @returns 分组数量
   */
  public static getTotalGroupHeight(op: GridStateObserverProxy): number {
    return op.groupInfo.totalHeight;
  }


  /**
   * 查找偏移距离所在分组
   *
   * @param op 宫格状态观察者代理
   * @param offset 宫格中的偏移距离
   * @returns 所在分组
   */
  public static findGroupIndexByOffset(op: GridStateObserverProxy, offset: number): number {
    return op.groupInfo.findGroupIndexByOffset(offset);
  }

  /**
   * 查找总索引所在分组
   *
   * @param op 宫格状态观察者代理
   * @param totalIndex 总索引
   * @returns 所在分组
   */
  public static findGroupIndexByTotalIndex(op: GridStateObserverProxy, totalIndex: number): number {
    return op.groupInfo.findGroupIndexByTotalIndex(totalIndex);
  }

  /**
   * 获取分组开始的偏移位置
   *
   * @param op 宫格状态观察者代理
   * @param groupIndex 所在分组
   * @returns 偏移位置
   */
  public static getGroupStartOffset(op: GridStateObserverProxy, groupIndex: number): number {
    return op.groupInfo.getGroupStartOffset(groupIndex);
  }

  /**
   * 获取分组的开始索引
   *
   * @param op 宫格状态观察者代理
   * @param groupIndex 所在分组
   * @returns 开始索引
   */
  public static getGroupStartIndex(op: GridStateObserverProxy, groupIndex: number): number {
    return op.groupInfo.getGroupStartIndex(groupIndex);
  }

  /**
   * 计算宫格总高度
   *
   * @param op 宫格状态观察者代理
   * @param gridForm 宫格形态
   * @returns 宫格总高度
   */
  public static calcGridTotalHeight(op: GridStateObserverProxy, gridForm: FormIndex): number {
    const gridOp = op.gridObserverProxy;
    // 宫格上方不规则区域高度
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm);
    // 宫格自身内容高度
    const gridHeight: number = gridOp.getGridHeight(gridForm);
    // 默认尾部高度
    const tailHeight: number = gridOp.getBottomHeight();

    LogUtils.debug(op.tag, `GRID_SWITCH ${FormIndex[gridForm]} calcGridTotalHeight ` +
      `irregularHeight: ${irregularHeight}, gridHeight: ${gridHeight}, tailHeight: ${tailHeight}`);

    return Math.max(0, irregularHeight + gridHeight + tailHeight);
  }

  /**
   * 计算宫格最大偏移量
   *
   * @param op 宫格状态观察者代理
   * @param gridForm 宫格形态
   * @returns 宫格最大偏移量
   */
  public static calcMaxOffset(op: GridStateObserverProxy, gridForm: FormIndex): number {
    // 宫格总高度
    const gridTotalHeight: number = SwitchCommonUtils.calcGridTotalHeight(op, gridForm);
    // 窗口高度
    const winHeight: number = op.displayObserverProxy.getGridAreaSize().height;

    LogUtils.debug(op.tag, `GRID_SWITCH ${FormIndex[gridForm]} calcMaxOffset gridTotalHeight: ${gridTotalHeight}, ` +
      `winHeight: ${winHeight}`);

    return Math.max(0, gridTotalHeight - winHeight);
  }


  /**
   * 计算宫格索引对应的偏移位置
   *
   * @param gridIndex 宫格索引
   * @returns 对应的偏移位置
   */
  public static calcGridOffset(gridIndex: number, op: GridStateObserverProxy, gridForm: FormIndex): number {
    const gridOp = op.gridObserverProxy;
    const imageHeightWithGutter = SwitchCommonUtils.getImageHeight(gridOp, gridForm);
    if (gridForm === FormIndex.GROUP_DAY) {
      const groupIndex = op.groupInfo.findGroupIndexByTotalIndex(gridIndex, true);
      const innerGroupIndex = gridIndex - (op.groupInfo.getGroupStartIndex(groupIndex) + groupIndex);
      let totalOffset = op.groupInfo.getGroupStartOffset(groupIndex);
      if (innerGroupIndex > 0) {
        totalOffset += (gridOp.getGroupTitleHeight() + gridOp.getGridImageGutter(gridForm) +
          Math.floor((innerGroupIndex - 1) / gridOp.getGridColumn(gridForm)) * imageHeightWithGutter);
      }
      LogUtils.debug(op.tag, `onScrollBarUpdate groupIndex: ${groupIndex}, innerGroupIndex: ${innerGroupIndex}`);
      return totalOffset;
    } else if (gridForm === FormIndex.DAY) {
      return Math.floor(gridIndex / gridOp.getGridColumn(gridForm)) * imageHeightWithGutter;
    } else {
      return gridIndex * MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM * imageHeightWithGutter;
    }
  }

  /**
   * 计算滚动距离对应的LayoutIndex信息
   *
   * @param op 宫格状态观察者代理
   * @param gridForm 所属宫格
   * @param offset 滚动距离
   * @returns [Layout索引，Layout上方偏移距离]
   */
  public static calcLayoutIndex(op: GridStateObserverProxy, gridForm: FormIndex, offset?: number): number[] {
    const gridOp = op.gridObserverProxy;
    // 获取滚动距离
    const scrollOffset = offset ?? gridOp.getScrollOffset(gridForm);
    // 不规则区域距离
    const irregularHeight: number = gridOp.getIrregularHeight(gridForm); // 宫格上方不规则区域高度
    if (scrollOffset <= irregularHeight) {
      return [0, 0];
    }
    const imageHeight = SwitchCommonUtils.getImageHeight(gridOp, gridForm);
    const gridColumn = gridOp.getGridColumn(gridForm);
    const gridOffset: number = scrollOffset - irregularHeight;
    const firstRow = Math.floor(gridOffset / imageHeight);
    const firstIndex = gridColumn * firstRow;
    let gridlayoutIndex: number;
    let gridlayoutIndexOffset: number;
    if (gridForm === FormIndex.YEAR || gridForm === FormIndex.MONTH) {
      const groupSize = gridColumn * MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM;
      gridlayoutIndex = Math.floor(firstIndex / groupSize);
      gridlayoutIndexOffset = gridlayoutIndex * imageHeight * MAX_COLUMN_COUNT_FOR_YEARMONTH_ITEM;
    } else if (gridForm === FormIndex.GROUP_DAY) {
      const groupIndex = SwitchCommonUtils.findGroupIndexByOffset(op, gridOffset);
      const groupStartIndex = SwitchCommonUtils.getGroupStartIndex(op, groupIndex);
      const groupStartOffset = SwitchCommonUtils.getGroupStartOffset(op, groupIndex);
      const groupTitleHeight = SwitchCommonUtils.getGroupTitleHeight(gridOp, groupIndex);
      if (gridOffset - groupStartOffset <= groupTitleHeight) {
        gridlayoutIndex = groupStartIndex + groupIndex; // 标题头数目
        gridlayoutIndexOffset = groupStartOffset;
      } else {
        const groupRow = Math.floor((gridOffset - groupStartOffset - groupTitleHeight) / imageHeight);
        gridlayoutIndex = groupStartIndex + groupIndex + 1 + gridOp.getGridColumn(gridForm) * groupRow;
        gridlayoutIndexOffset = groupStartOffset + groupTitleHeight + groupRow * imageHeight;
      }
    } else {
      gridlayoutIndex = firstIndex;
      gridlayoutIndexOffset = firstRow * imageHeight;
    }
    const layoutIndex = gridOp.getIrregularCount(gridForm) + gridlayoutIndex;
    const layoutIndexOffset = irregularHeight + gridlayoutIndexOffset;
    LogUtils.debug(op.tag, `GRID_SWITCH ${FormIndex[gridForm]} calcLayoutIndex offset: ${offset}, ` +
      `firstIndex: ${firstIndex}, layoutInof: [${layoutIndex}, ${layoutIndexOffset}]`);
    return [layoutIndex, layoutIndexOffset];
  }

  /**
   * 通过Item索引获取目标屏幕相对位置
   *
   * @param itemIndex Item索引
   * @param op 宫格状态观察者代理
   * @param gridForm 所属宫格
   * @returns 屏幕相对位置
   */
  public static calcRectFromItemIndex(itemIndex: number, op: GridStateObserverProxy, gridForm: FormIndex): ItemRect {
    if (gridForm === FormIndex.GROUP_DAY) {
      return SwitchCommonUtils.calcGroupRect(itemIndex, op, gridForm);
    } else {
      return SwitchCommonUtils.calcDefaultRect(itemIndex, op.gridObserverProxy, gridForm);
    }
  }

  private static calcDefaultRect(itemIndex: number, gridOp: GridObserverProxy, gridForm: FormIndex): ItemRect {
    // 宫格列数
    const gridColumn: number = gridOp.getGridColumn(gridForm);
    // item在宫格中所在索引
    const gridIndex: number = gridOp.getFillPostion(gridForm) + itemIndex;
    // item所在行前方行数
    const rowCount: number = Math.floor(gridIndex / gridColumn);
    // item所在列数
    const column: number = gridIndex % gridColumn;
    // item高度
    const imageHeightWithGutter: number = SwitchCommonUtils.getImageHeight(gridOp, gridForm);
    const imageWidthWitchGutter: number = SwitchCommonUtils.getImageWidth(gridOp, gridForm);
    const imageHeight: number = gridOp.getGridImageHeight(gridForm);

    // 生成计算结果
    const top: number = gridOp.getIrregularHeight() + rowCount * imageHeightWithGutter;
    const left: number = column * imageWidthWitchGutter;
    return {
      top: top,
      bottom: top + imageHeight,
      left: left,
      right: left + imageHeight,
    };
  }

  private static calcGroupRect(itemIndex: number, op: GridStateObserverProxy, gridForm: FormIndex): ItemRect {
    const gridOp = op.gridObserverProxy;
    const groupInfo = op.groupInfo;
    // 获取所在分组
    const groupIndex: number = groupInfo.findGroupIndexByTotalIndex(itemIndex);
    // 获取所在分组开始位置
    const groupStartIndex: number = groupInfo.getGroupStartIndex(groupIndex);
    const groupStartOffset: number = groupInfo.getGroupStartOffset(groupIndex);
    // 分组内位置
    const innerGroupIndex: number = itemIndex - groupStartIndex;
    // 宫格列数
    const gridColumn: number = gridOp.getGridColumn(gridForm);
    // item所在行前方行数
    const rowCount: number = Math.floor(innerGroupIndex / gridColumn);
    // item所在列数
    const column: number = innerGroupIndex % gridColumn;
    // item高度
    const imageHeightWithGutter: number = SwitchCommonUtils.getImageHeight(gridOp, gridForm);
    // item宽度
    const imageWidthWithGutter: number = SwitchCommonUtils.getImageWidth(gridOp, gridForm);
    const imageHeight: number = gridOp.getGridImageHeight(gridForm);

    // 生成计算结果
    const top: number = gridOp.getIrregularHeight() + groupStartOffset + imageHeightWithGutter * rowCount +
      gridOp.getGroupTitleHeight() + gridOp.getGridImageGutter(gridForm);
    const left: number = column * imageWidthWithGutter;
    LogUtils.info('SwitchCommonUtils', `calcGroupRect itemIndex:${itemIndex} groupIndex:${groupIndex}` +
      `, groupStartIndex:${groupStartIndex}, groupStartOffset:${groupStartOffset} ${innerGroupIndex}, rowCount:${rowCount}` +
      `, column:${column}, imageHeightWithGutter:${imageHeightWithGutter}, imageHeight:${imageHeight}`);
    return {
      top: top,
      bottom: top + imageHeight,
      left: left,
      right: left + imageHeight,
    };
  }
}