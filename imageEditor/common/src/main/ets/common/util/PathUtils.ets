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
export class PathUtils {
  /**
   * 从文件路径或URL中提取文件后缀名（扩展名）
   * @param path 文件路径或URL字符串，可选参数
   * @param allowedExtensions 允许的后缀名白名单，可选参数
   * @returns 返回小写的文件后缀名（不带点）。如果路径无效、无后缀或不在白名单中则返回空字符串
   */
  public static extractFileSuffix(path?: string, allowedExtensions?: string[]): string {
    if (!path) {
      return '';
    }

    const cleanPath = path.replace(/[?#].*$/, '');
    const lastSegment = cleanPath.split(/[\\/]/).pop() || '';
    if (lastSegment.startsWith('.')) {
      return '';
    }
    const parts = lastSegment.split('.');
    const ext = parts.length > 1 ? parts[parts.length - 1].trim().toLowerCase() : '';

    if (allowedExtensions?.length && !allowedExtensions.includes(ext)) {
      return '';
    }

    return ext;
  }

}
