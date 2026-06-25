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
/**
 * 滑窗数据抽象
 */
export class PageData<T> {
  private static innerVersion: number = 0;
  /**
   * 数据版本号，在仅滑窗更新场景不更新，在数据变更场景下更新
   */
  public readonly version: number;
  /**
   * 滑窗数据
   */
  public readonly data: (T | undefined)[] = [];
  /**
   * 前方占位符总量
   */
  public readonly placeholdersBefore: number = 0;
  /**
   * 后方占位符总量
   */
  public readonly placeholdersAfter: number = 0;

  /**
   * 构造函数
   * @param data 滑窗数据
   * @param placeholdersBefore 前方占位符总量
   * @param placeholdersAfter 后方占位符总量
   */
  public constructor(version: number = PageData.nextVersion(), data: (T | undefined) [] = [],
    placeholdersBefore: number = 0, placeholdersAfter: number = 0) {
    this.version = version;
    if (data) {
      this.data.push(...data);
    }
    this.placeholdersBefore = placeholdersBefore >= 0 ? placeholdersBefore : 0;
    this.placeholdersAfter = placeholdersAfter >= 0 ? placeholdersAfter : 0;
  }

  /**
   * 总数据量
   * @returns 大小
   */
  public get size(): number {
    return this.placeholdersBefore + this.data.length + this.placeholdersAfter;
  }

  /**
   * 获取数据
   * @param index 下标
   * @returns 数据
   */
  public getData(index: number): T | undefined {
    let actualIndex: number = index - this.placeholdersBefore;
    if (actualIndex < 0 || actualIndex >= this.data.length) {
      return undefined;
    }
    return this.data[actualIndex];
  }

  /**
   * 掐头去尾，挤掉data中两头的无效数据
   * @returns 新的PageData
   */
  public trim(): PageData<T> {
    let before: number = 0;
    while (before < this.data.length) {
      let item: (T | undefined) = this.data[before];
      if (!item) {
        before++;
      } else {
        break;
      }
    }

    let after: number = 0;
    while (after < this.data.length - before) {
      let item: (T | undefined) = this.data[this.data.length - after - 1];
      if (!item) {
        after++;
      } else {
        break;
      }
    }
    return new PageData<T>(this.version, this.data.slice(before, this.data.length - after),
      this.placeholdersBefore + before,
      this.placeholdersAfter + after);
  }

  /**
   * 生成下一个版本号
   * @returns 版本号
   */
  public static nextVersion(): number {
    PageData.innerVersion++;
    return PageData.innerVersion;
  }
}