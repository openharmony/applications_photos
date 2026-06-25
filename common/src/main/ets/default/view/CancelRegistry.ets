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
 * 取消监听注册管理
 */
export class CancelRegistry {
  private readonly cancelListeners: Array<() => void> = [];

  /**
   * 注册
   *
   * @param cancel 取消监听
   */
  public register(cancel?: () => void): void {
    if (!cancel || this.cancelListeners.indexOf(cancel) != -1) {
      return;
    }
    this.cancelListeners.push(cancel);
  }

  /**
   * 取消注册
   *
   * @param cancel 监听
   */
  public unregister(cancel: () => void): void {
    if (!cancel) {
      return;
    }
    let idx: number = this.cancelListeners.indexOf(cancel);
    if (idx === -1) {
      return;
    }
    this.cancelListeners.splice(idx, 1);
  }

  /**
   * 取消回调，发出取消后清除，因为取消一般就关闭了
   */
  public cancel(): void {
    for (let i: number = this.cancelListeners.length - 1; i >= 0; i--) {
      let listener: () => void = this.cancelListeners[i];
      if (listener !== undefined) {
        listener();
      }
      this.cancelListeners.splice(i, 1);
    }
  }

  /**
   * 清除监听
   */
  public clear(): void {
    this.cancelListeners.splice(0, this.cancelListeners.length);
  }
}