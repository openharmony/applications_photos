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
 * CustomTransitionManager
 *
 * @since 2025-06-26
 */
export interface AnimateCallback {
  callback: ((isPush: boolean) => void | undefined) | undefined;
  timeout: (number | undefined) | undefined;
}

export class CustomTransitionManager {
  private static instance = new CustomTransitionManager();
  private customTransitionMap: Map<string, AnimateCallback> = new Map();

  static getInstance() {
    return CustomTransitionManager.instance;
  }

  /**
   * 注册某个页面的动画回调
   *
   * @param name 注册页面的唯一id
   * @param callback 注册的转场动效
   * @param timeout 转场结束的超时时间
   */
  public registerNavParam(name: string, callback: (operation: boolean) => void,
    timeout: number): void {
    if (this.customTransitionMap.has(name)) {
      let param = this.customTransitionMap.get(name);
      if (param != undefined) {
        param.callback = callback;
        param.timeout = timeout;
        return;
      }
    }
    let params: AnimateCallback = {
      timeout: timeout,
      callback: callback,
    };
    this.customTransitionMap.set(name, params);
  }

  /**
   * 注销页面转场动画
   *
   * @param name 注册页面的唯一id
   */
  public unRegisterNavParam(name: string): void {
    this.customTransitionMap.delete(name);
  }

  /**
   * 获取页面转场动画
   *
   * @param name 注册页面的唯一id
   * @returns 转场动画
   */
  public getAnimateParam(name?: string): AnimateCallback | undefined {
    if (!name) {
      return undefined;
    }
    return this.customTransitionMap.get(name);
  }
}