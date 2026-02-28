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

import lazy { TimelineData } from '@ohos/common/src/main/ets/default/model/browser/photo/TimelineData';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';

/* instrument ignore file */

const TAG: string = 'GroupInfo';

/**
 * 分组计算信息
 */
export class GroupInfo {
  /**
   * 索引表
   */
  private _indexArr: number[] = [];
  /**
   * off表
   */
  private _offsetArr: number[] = [];
  /**
   * count表
   */
  private _countArr: number[] = [];
  /**
   * 总数目
   */
  private _totalSize: number = 0;
  /**
   * 总高度
   */
  private _totalHeight: number = 0;
  /**
   * 分组数目
   */
  private _groupSize: number = 0;

  public get totalSize(): number {
    return this._totalSize;
  }

  public get totalHeight(): number {
    return this._totalHeight;
  }

  public get groupSize(): number {
    return this._groupSize;
  }

  /**
   * 更新分组信息
   *
   * @param groupInfo 原始分组信息
   * @param groupTitleHeight 分组头高度
   * @param imageHeight 宫格高度
   * @param gridColumn 宫格列数
   */
  public refresh(groupInfo: TimelineData[], groupTitleHeight: number, imageHeight: number, gridColumn: number): void {
    this._offsetArr.splice(0, this._offsetArr.length);
    this._indexArr.splice(0, this._indexArr.length);
    this._countArr.splice(0, this._countArr.length);
    this._totalSize = 0;
    this._totalHeight = 0;
    this._groupSize = 0;

    const count: number = groupInfo.length;
    if (count <= 0) {
      return;
    }
    this._groupSize = count;

    let size: number = 0;
    let height: number = 0;
    for (let index = 0; index < count; index++) {
      this._indexArr[index] = size;
      this._offsetArr[index] = height;
      const groupCount = groupInfo[index].count;
      this._countArr[index] = groupCount;
      size += groupCount;
      height += (groupTitleHeight + Math.ceil(groupCount / gridColumn) * imageHeight);
    }
    this._totalSize = size;
    this._totalHeight = height;
    LogUtils.info(TAG, `refresh totalSize: ${size}, totalHeight: ${height}, groupSize: ${count}, ` +
      `imageHeight: ${imageHeight}`);
  }

  /**
   * 查找总索引所在分组
   *
   * @param totalIndex 总索引
   * @param withGroupTitle 总索引是否包含分组头
   * @returns 所在分组索引
   */
  public findGroupIndexByTotalIndex(totalIndex: number, withGroupTitle: boolean = false): number {
    if (totalIndex <= 0) {
      return 0;
    }
    const groupIndex = this._indexArr.findIndex((groupIndex, index) => groupIndex +
      (withGroupTitle ? index : 0) > totalIndex);
    return (groupIndex > 0 ? groupIndex : this._groupSize) - 1;
  }

  /**
   * 查找偏移距离所在分组
   *
   * @param offset 宫格中的偏移距离
   * @returns 所在分组索引
   */
  public findGroupIndexByOffset(offset: number): number {
    if (offset <= 0) {
      return 0;
    }
    const groupIndex = this._offsetArr.findIndex(groupOffset => groupOffset >= offset);
    return (groupIndex > 0 ? groupIndex : this._groupSize) - 1;
  }

  /**
   * 获取分组的开始索引
   *
   * @param groupIndex 所在分组
   * @returns 开始索引
   */
  public getGroupStartIndex(groupIndex: number): number {
    if (groupIndex < 0) {
      return 0;
    }
    return this._indexArr[groupIndex] ?? this._totalSize;
  }

  /**
   * 获取分组开始的偏移位置
   *
   * @param groupIndex 所在分组
   * @returns 偏移位置
   */
  public getGroupStartOffset(groupIndex: number): number {
    if (groupIndex < 0) {
      return 0;
    }
    return this._offsetArr[groupIndex] ?? this._totalHeight;
  }

  /**
   * 获取单个分组图片数量
   *
   * @param groupIndex 分组索引
   * @returns 分组数量
   */
  public getGroupCount(groupIndex: number): number {
    if (groupIndex < 0 || groupIndex >= this._countArr.length) {
      return 0;
    }
    return this._countArr[groupIndex];
  }
}