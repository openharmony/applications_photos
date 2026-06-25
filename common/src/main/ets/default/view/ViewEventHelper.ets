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
 * onClick事件处理工具类，先注册的处理优先级更高
 * 用法：
 * let helper: EventHelper<ClickEvent> = new EventHelper<ClickEvent>();
 * let helper2: EventHelper<KeyEvent> = new EventHelper<KeyEvent>();
 * 1、匿名函数
 * helper.register((event: ClickEvent) => {return true;})
 * 2、某个实例的方法
 * class Test {
 *   onClick(event: ClickEvent): boolean {
 *     return true;
 *   }
 * }
 * let test: Test = new Test();
 * helper.register((event:T) => test.onClick(event));
 */
/* instrument ignore file */
export class EventHelper<T> {
  private readonly handlers: Array<(event: T) => boolean> = [];

  /**
   * 注册
   *
   * @param handler 监听
   */
  public register(handler: (event: T) => boolean): void {
    if (!handler || this.handlers.indexOf(handler) !== -1) {
      return;
    }
    this.handlers.push(handler);
  }

  /**
   * 取消注册
   *
   * @param listener 监听
   */
  public unregister(handler: (event: T) => boolean): void {
    if (!handler) {
      return;
    }
    let index: number = this.handlers.indexOf(handler);
    if (index === -1) {
      return;
    }
    this.handlers.splice(index, 1);
  }

  /**
   * 处理事件
   *
   * @param event 事件
   * @returns 是否被处理
   */
  public process(event: T): boolean {
    for (let i = 0; i < this.handlers.length; i++) {
      let isHandled: boolean = this.handlers[i](event);
      if (isHandled) {
        return true;
      }
    }
    return false;
  }
}