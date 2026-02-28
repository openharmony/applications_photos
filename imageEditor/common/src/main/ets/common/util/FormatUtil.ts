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
import { HiLog } from './HiLog';
export class FormatUtil {
  private static readonly NEW_NAME_IMG: string = 'IMG_';
  private static readonly NEW_NAME_VIDEO: string = 'VID_';

  public static nameByDate(isVideo: Boolean): string {
    if (isVideo) {
      return FormatUtil.NEW_NAME_VIDEO + FormatUtil.formatDate(new Date(), 'yyyyMMdd_HHmmss');
    } else {
      return FormatUtil.NEW_NAME_IMG + FormatUtil.formatDate(new Date(), 'yyyyMMdd_HHmmss');
    }
  }

  /**
   * 格式化输出时间
   * @param date 待格式化的Date对象
   * @param pattern 时间的格式范例，如yyyyMMdd_HHmmss
   */
  public static formatDate(date: Date, pattern?: any): string {
    if (!date) {
      return;
    }
    const dict: any = {
      yyyy: date.getFullYear(),
      M: date.getMonth() + 1,
      d: date.getDate(),
      H: date.getHours(),
      m: date.getMinutes(),
      s: date.getSeconds(),
      MM: ('' + (date.getMonth() + 101)).substr(1),
      dd: ('' + (date.getDate() + 100)).substr(1),
      HH: ('' + (date.getHours() + 100)).substr(1),
      mm: ('' + (date.getMinutes() + 100)).substr(1),
      ss: ('' + (date.getSeconds() + 100)).substr(1),
      lll: ('' + (date.getMilliseconds() + 1000)).substr(1),
    };
    return pattern.replace(/(yyyy|MM?|dd?|HH?|mm?|ss?|lll?)/g, function (...args) {
      return dict[args[0]];
    });
  }

  /**
   * 将RGBA 十六进制的颜色，转成 R_G_B
   * @param hex 十六进制的 RGBA
   * */
  public static RGBAHexToR_G_B(hex: string): string {
    try {
      // 去掉字符串前面的 #
      hex = hex.slice(1);
      // 检查是否是有效的十六进制颜色代码
      if (!/^[0-9A-Fa-f]{8}$/.test(hex)) {
        HiLog.i('rgbFormat', `addXTStyle error no curr rgb}`);
        return '000_000_000';
      }
      // 将每两个字符转换为十进制数
      let r = parseInt(hex.slice(2, 4), 16).toString().padStart(3, '0');
      let g = parseInt(hex.slice(4, 6), 16).toString().padStart(3, '0');
      let b = parseInt(hex.slice(6, 8), 16).toString().padStart(3, '0');
      // 返回 RGB 字符串格式
      return `${r}_${g}_${b}`;
    } catch (error) {
      HiLog.i('rgbFormat', `addXTStyle error${error}`);
      return '000_000_000';
    }
  }
}
