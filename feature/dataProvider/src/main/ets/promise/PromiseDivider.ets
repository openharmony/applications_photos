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
 * promise divider: 允许执行和结果在不同的方法中调用。
 */
export class PromiseDivider<T> {
  private bridge: Promise<T>;
  private resolver?: (value: T | PromiseLike<T>) => void;
  private done: boolean = false;
  private data!: T;

  constructor() {
    this.bridge = new Promise<T>(((resolve) => {
      this.resolver = resolve;
    }))
  }

  public emit(asyncFn: () => Promise<T>): void {
    asyncFn?.()
      .then((value) => {
        this.done = true;
        this.data = value;
        this.resolver?.(this.data);
      })
      .catch(() => {
        this.done = true;
        // 不对异常进行处理，以保证链路正常
        this.resolver?.(this.data);
      });
  }

  public async getStream(): Promise<T> {
    if (this.done) {
      return this.data;
    }
    return this.bridge;
  }
}