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

/**
 * 表征区间范围
 */
export class Region {
  /**
   * 无效位置
   */
  public static readonly POS_INVALID: number = -1;
  /**
   * 区间起点
   */
  public start: number = Region.POS_INVALID;
  /**
   * 区间终点
   */
  public end: number = Region.POS_INVALID;
  /**
   * 区间名称
   */
  private name: string = '';

  constructor(name: string, start?: number, end?: number) {
    this.name = name;
    if (start !== undefined) {
      this.start = start;
    }
    if (end !== undefined) {
      this.end = end;
    }
  }

  /**
   * 区间是否有效
   *
   * @returns true表示区间有效
   */
  public isValid(): boolean {
    return this.start !== Region.POS_INVALID && this.end !== Region.POS_INVALID && this.start <= this.end;
  }

  /**
   * 比较两个区间是否相同
   *
   * @param region 待比较的另一个区间
   * @returns true表示区间相同
   */
  public equals(region: Region): boolean {
    return region !== null && this.start === region.start && this.end === region.end;
  }

  /**
   * 获取区间长度
   *
   * @returns 区间长度
   */
  public length(): number {
    return this.isValid() ? this.end - this.start + 1 : 0;
  }

  /**
   * 重设区间
   */
  public reset(): void {
    this.start = Region.POS_INVALID;
    this.end = Region.POS_INVALID;
  }

  /**
   * 获取区间信息
   *
   * @returns 区间信息
   */
  public toString(): string {
    return `${this.name}:[${this.start}, ${this.end}]`;
  }
}