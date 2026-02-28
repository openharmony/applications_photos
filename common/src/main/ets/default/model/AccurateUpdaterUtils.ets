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

import lazy { Log } from '../utils/Log';
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { OrderStrategy, DisplayNameOrderStrategy } from './AlbumAccurateUpdater';
import lazy { PhotoAssetChangeInfo } from './browser/dataObserver/MediaObserver';

const TAG: string = 'AccurateUpdaterUtils';

export interface CachedData {
  placeholdersBefore: number;
  placeholdersAfter: number;
  data: MediaItem[];
  groups?: TimelineData[];
}

export class AccurateUpdaterUtils {
  /**
   * 计算传入的照片在当前滑窗中的位置
   *
   * @param targetInfo 通知中包含的指定照片信息
   * @param orderStrategy 从对象中取值的方法类
   * @param mediaItems 整个滑窗内的照片信息缓存数组
   *
   * @returns 指定照片在当前滑窗中的位置
   */
  public static findMediaItemIndex(targetInfo: PhotoAssetChangeInfo, orderStrategy: OrderStrategy,
    mediaItems: MediaItem[]): number {
    if (!targetInfo || !orderStrategy || mediaItems.length === 0) {
      Log.error(TAG, `findMediaItemIndex params undefined`);
      return -1;
    }

    const targetDisplayName: string = orderStrategy.getNfyName?.(targetInfo) ?? '';
    const targetValue: number = orderStrategy.getNfyValue(targetInfo);

    let left = 0;
    let right = mediaItems.length - 1;
    if (!mediaItems.length) {
      return -1; // 数组为空，直接返回
    }

    let mid: number = Math.floor((left + right) / 2);
    let midValue: number = orderStrategy.getItemValue(mediaItems[mid]);
    let midDisplayName: string = orderStrategy.getItemName?.(mediaItems[mid]) ?? '';
    let isEqual: boolean = false;
    let isLeftEqual: boolean = false;
    let isRightEqual: boolean = false;
    let isTargetEqual: boolean = false;

    // 第一步：使用二分查找找到匹配的项
    while (left <= right) {
      mid = Math.floor((left + right) / 2);
      midValue = orderStrategy.getItemValue(mediaItems[mid]);
      midDisplayName = orderStrategy.getItemName?.(mediaItems[mid]) ?? '';

      isEqual = orderStrategy.isString ? (targetDisplayName === midDisplayName) : (targetValue === midValue);
      isTargetEqual = orderStrategy.isString ?
        (orderStrategy.isDesc ? (midDisplayName.localeCompare(targetDisplayName) > 0) :
          (midDisplayName.localeCompare(targetDisplayName) < 0)) :
        (orderStrategy.isDesc ? (midValue > targetValue) : (midValue < targetValue));
      Log.info(TAG, `[accurateNotify] handle isEqual ${isEqual},  isTargetequal ${isTargetEqual}`);

      if (isEqual) {
        // 找到dateTrashed匹配的项，检查uri是否匹配
        if (mediaItems[mid]?.uri === targetInfo.uri) {
          return mid; // 找到匹配项，返回索引
        } else {
          // dateTrashed匹配但uri不匹配，继续搜索其他可能的匹配项
          // 向左和向右扩展查找
          let leftIndex = mid - 1;
          let rightIndex = mid + 1;

          // 检查左边
          while (leftIndex >= left) {
            isLeftEqual = (orderStrategy instanceof DisplayNameOrderStrategy) ?
              (orderStrategy.getItemName?.(mediaItems[leftIndex]) === targetDisplayName) :
              (orderStrategy.getItemValue(mediaItems[leftIndex]) === targetValue);
            if (isLeftEqual && mediaItems[leftIndex]?.uri === targetInfo.uri) {
              Log.info(TAG, `[accurateNotify] findMediaItem index: ${leftIndex}`);
              return leftIndex;
            }
            leftIndex--;
          }

          // 检查右边
          while (rightIndex <= right) {
            isRightEqual = (orderStrategy instanceof DisplayNameOrderStrategy) ?
              (orderStrategy.getItemName?.(mediaItems[rightIndex]) === targetDisplayName) :
              (orderStrategy.getItemValue(mediaItems[rightIndex]) === targetValue);
            if (isRightEqual && mediaItems[rightIndex]?.uri === targetInfo.uri) {
              Log.info(TAG, `[accurateNotify] findMediaItem index: ${rightIndex}`);
              return rightIndex;
            }
            rightIndex++;
          }

          // 如果没有找到uri匹配的项，返回-1
          return -1;
        }
      } else if (isTargetEqual) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return -1; // 未找到匹配项
  }

  /**
   * 将指定的照片按照特定排序方式插入当前滑窗
   *
   * @param newItem 通知中包含的指定照片信息
   * @param orderStrategy 从对象中取值的方法类
   * @param mediaItems 整个滑窗内的照片信息缓存数组
   *
   * @returns 将指定照片按特定顺序插入当前滑窗中
   */
  public static insertMediaItem(newItem: MediaItem, orderStrategy: OrderStrategy, mediaItems: MediaItem[]): number {
    if (!newItem || !orderStrategy) {
      Log.error(TAG, `insertMediaItem params undefined`);
      return -1;
    }

    const newDataValue: number = orderStrategy.getItemValue(newItem);
    const newDisplayName: string = orderStrategy.getItemName?.(newItem) ?? '';

    if (mediaItems.length === 0) {
      mediaItems.push(newItem);
      return -1;
    } // 处理空数组的情况

    // 使用二分查找找到插入位置
    let left = 0;
    let right = mediaItems.length - 1;
    let insertIndex = mediaItems.length; // 默认插入到最后

    let mid = Math.floor((left + right) / 2);
    let midDataValue: number = orderStrategy.getItemValue(mediaItems[mid]);
    let midDisplayName: string = orderStrategy.getItemName?.(mediaItems[mid]) ?? '';
    let comparison: boolean = false;

    while (left <= right) {
      mid = Math.floor((left + right) / 2);
      midDataValue = orderStrategy.getItemValue(mediaItems[mid]);
      comparison = (midDataValue < newDataValue);

      if (orderStrategy instanceof DisplayNameOrderStrategy) {
        midDisplayName = (orderStrategy.getItemName?.(mediaItems[mid]) ?? '');
        comparison = (midDisplayName.localeCompare(newDisplayName) < 0);
      }
      Log.info(TAG, `[accurateNotify] insert value: ${midDataValue}  ${newDataValue}`);

      if (orderStrategy.isDesc) { // 降序排列
        if (comparison) {
          insertIndex = mid;
          right = mid - 1;
        } else {
          left = mid + 1;
        }
      } else { // 升序排列
        if (comparison) {
          insertIndex = mid + 1;
          left = mid + 1;
        } else {
          insertIndex = mid;
          right = mid - 1;
        }
      }
    }

    if (AccurateUpdaterUtils.checkLeftAndRightEqual(insertIndex, newItem, orderStrategy, mediaItems)) {
      return -1;
    }

    return insertIndex;
  }

  private static checkLeftAndRightEqual(insertIndex: number, newItem: MediaItem, orderStrategy: OrderStrategy,
    mediaItems: MediaItem[]): boolean {
    if (orderStrategy instanceof DisplayNameOrderStrategy) {
      if (insertIndex - 1 >= 0 && (orderStrategy.getItemName?.(newItem) ?? '') ===
      orderStrategy.getItemName?.(mediaItems[insertIndex - 1])) {
        return true;
      }
      if (insertIndex + 1 < newItem.size && orderStrategy.getItemName?.(newItem) ===
      orderStrategy.getItemName?.(mediaItems[insertIndex + 1])) {
        return true;
      }
    }

    if (insertIndex - 1 >= 0 && orderStrategy.getItemValue(newItem) ===
    orderStrategy.getItemValue(mediaItems[insertIndex - 1])) {
      return true;
    }

    if (insertIndex + 1 < newItem.size && orderStrategy.getItemValue(newItem) ===
    orderStrategy.getItemValue(mediaItems[insertIndex + 1])) {
      return true;
    }

    return false;
  }
}
