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


import type { MediaItem } from '../model/browser/photo/MediaItem';
import lazy { Constants } from '../model/common/Constants';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';

const standard = Constants.DEFAULT_COMPARE_IMAGE_RATIO;

export class CompareVerify {
  /**
   * 图片格式判断
   *
   * @param selectedItems 媒体项
   * @returns
   */
  public static suffix(...selectedItems: MediaItem[]): boolean {
    return selectedItems.some((photoItem: MediaItem) => {
      return Constants.suffixList.some((item: string) => photoItem.uri.endsWith(item) ||
      photoItem.uri.endsWith(item.toUpperCase()));
    });
  }

  /**
   * 图片大小判断
   *
   * @param selectedItems 媒体项
   * @returns
   */
  public static proportion(...selectedItems: MediaItem[]): boolean {
    const proportion = selectedItems.some(item => (item.width / item.height) > standard ||
      (item.height / item.width) > standard);
    return proportion;
  }

  /**
   * 图片格式符合
   *
   * @param selectedItems 媒体项
   * @returns
   */
  public static suffixVerify(photoItem: MediaItem): boolean {
    return Constants.suffixList.some((item: string) => photoItem.uri.endsWith(item) ||
    photoItem.uri.endsWith(item.toUpperCase()));
  }

  /**
   * 图片大小符合
   *
   * @param selectedItems 媒体项
   * @returns
   */
  public static size(photoItem: MediaItem): boolean {
    return ((photoItem.width / photoItem.height) <= standard && (photoItem.height / photoItem.width) <= standard);
  }

  /**
   * 图片选择数量判断
   *
   * @param selectedItems 媒体项
   * @returns
   */
  // 1.数量满足显示
  // 2.尺寸满足显示
  // 3.格式满足显示
  // 4.尺寸格式有一个满足就显示
  // 5.尺寸格式都不满足不显示 CompareVerify.suffixAndSize(photoItem)
  public static proportionNumber(selectedItems: MediaItem[]): boolean {
    if (selectedItems.length > 1 && selectedItems.length <= 20) {
      // 纯视频返回false
      if (selectedItems.every(item => item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO)) {
        return false;
      } else if (selectedItems.some(item => item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO)) { // 部分是视频
        // 视频不校验尺寸
        const arr = selectedItems.filter(item => item.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO);
        // 有图片的格式符合并且尺寸符合则显示
        arr.some(photoItem => {
          return CompareVerify.suffixVerify(photoItem) && CompareVerify.size(photoItem);
        });
        if (arr.some(photoItem => CompareVerify.suffixVerify(photoItem) && CompareVerify.size(photoItem))) {
          return true;
        } else {
          return false;
        }
      } else { // 全部是图片
        selectedItems.some(photoItem => {
          return CompareVerify.suffixVerify(photoItem) && CompareVerify.size(photoItem);
        });
        if (selectedItems.some(photoItem => CompareVerify.suffixVerify(photoItem) && CompareVerify.size(photoItem))) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }
}