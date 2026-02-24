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

import lazy { Constants } from '../model/common/Constants';
import lazy { resourceManager } from '@kit.LocalizationKit';
import lazy { Log } from './Log';

const TAG: string = 'FontUtil';

export class FontUtil {
  private static readonly FONT_SCALE_MAP: Map<number, Resource> = new Map([
    [Constants.FONT_SCALE_HEAVY_SIZE, $r('sys.float.padding_level12')],
    [Constants.FONT_SCALE_STRONG_SIZE, $r('sys.float.padding_level10')],
    [Constants.FONT_SCALE_LARGE_SIZE, $r('sys.float.padding_level8')]
  ]);
  // 特大一挡
  public static readonly LARGE_FONT_SIZE: number = 1.75;
  // 特大二挡
  public static readonly STRONG_FONT_SIZE: number = 2;
  // 特大三挡
  public static readonly HEAVY_TEXT_SIZE: number = 3.2;

  /**
   * 根据字体放大倍数，获取列表上下间距高度（当放大倍数不在map中，当成原始大小1倍处理）
   */
  public static getPaddingByFontScale(fontSizeScale: number): Resource {
    return FontUtil.FONT_SCALE_MAP.get(fontSizeScale) || $r('sys.float.padding_level6');
  }

  /**
   * 限制最大字体放大倍数
   * @param scale 当前倍数
   * @param limitScale 限制放大倍速
   * @param originalSizeRes 原始大小
   * @returns
   */
  public static getLimitedTextMagnification(scale: number, limitScale: number, originalSizeRes: Resource): ResourceStr {
    let originalSize = FontUtil.getNumber(originalSizeRes, false);
    let limitedScale = Math.min(scale, limitScale);
    let limitedSize = Math.floor(limitedScale * originalSize);
    return `${limitedSize}vp`;
  }

  /**
   * 获取系统资源对应的数字，默认单位vp
   * @param resource 系统资源
   * @param isReturnPx 是否以px作为单位返回
   * @returns number
   */
  public static getNumber(resource: Resource, isReturnPx: boolean = false): number {
    if (resource === null || resource === undefined) {
      return 0;
    }
    try {
      const rm: resourceManager.ResourceManager = getContext().resourceManager;
      const px = rm.getNumber(resource.id)
      if (isReturnPx) {
        return px;
      } else {
        return px2vp(px);
      }
    } catch (error) {
      Log.e(TAG, `getNumber fail, error: ${error}`);
    }
    return 0;
  }
}