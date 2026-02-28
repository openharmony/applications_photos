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

import lazy { AbstractInitialAble } from '../utils/AbstractInitialAble';
import lazy { LogUtils } from '../utils/LogUtils';

/**
 * 抽象配置
 *
 * @param E 初始化参数类型
 */
export abstract class AbstractConfig<E> extends AbstractInitialAble<E> {
  public init(config?: E): void {
    super.init(config);
    if (this.hasInit()) {
      this.logInitConfig();
    }
  }

  protected override doRelease(): void {
  }

  /**
   * 获取属性值
   *
   * @param originalValue 传入值
   * @param defaultValue 默认值
   * @param condition 条件判定
   * @returns 属性值
   */
  protected getValue<T>(originalValue: T | undefined, defaultValue: T,
    condition?: (originalValue: T | undefined) => boolean): T {
    if (!!condition) {
      return condition(originalValue) ? originalValue : defaultValue;
    } else {
      return originalValue ?? defaultValue;
    }
  }

  /**
   * 记录初始配置
   */
  protected logInitConfig(): void {
    for (const propertyName of Reflect.ownKeys(this)) {
      if (typeof propertyName === 'string') {
        LogUtils.info(this.tag, `logInit${propertyName}: ${this[propertyName]}`);
      }
    }
  }
}