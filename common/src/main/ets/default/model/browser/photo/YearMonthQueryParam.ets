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

export enum Priority {
  LOW = 0,
  HIGH = 1,
}

export class YearMonthQueryParam {
  /**
   * 元数据查询起始
   */
  public start: number;
  /**
   * 元数据查询个数
   */
  public count: number;
  /**
   * 元数据查询优先级
   */
  public priority: Priority;
  /**
   * 是否为预查询。例如，针对预加载发起的查询即为预查询
   */
  public isPreQuery: boolean = false;
  /**
   * 是否强制同步查询（默认否）。同步查询在主线程，异步查询在子线程
   */
  public isForceSyncQuery: boolean = false;

  constructor(start: number, count: number, priority: Priority, isPreQuery?: boolean, isForceSyncQuery?: boolean) {
    this.start = start;
    this.count = count;
    this.priority = priority;
    if (isPreQuery) {
      this.isPreQuery = isPreQuery;
    }
    if (isForceSyncQuery) {
      this.isForceSyncQuery = isForceSyncQuery;
    }
  }

  public toString(): string {
    return `queryParam:[prio:${this.priority}, start:${this.start}, cnt:${this.count}]`;
  }

  public isValid(): boolean {
    return this.start >= 0 && this.count > 0;
  }
}