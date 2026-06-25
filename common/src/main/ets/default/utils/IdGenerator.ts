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
 * Id生成器，从1开始生成
 */
export class IdGenerator {
  /**
   * 最后的ID
   */
  private _lastId: number = 0;
  private static staticId: number = 0;
  private static oldStaticId: number = 0;

  /**
   * 生成新ID
   *
   * @returns 新ID
   */
  public generatorId(): number {
    if (this._lastId === Number.MAX_VALUE) {
      this._lastId = 0;
    }
    return ++this._lastId;
  }
  /**
   * 生成大图controller新ID
   *
   * @returns 大图controller新ID
   */
  public static generatorIdStatic(): number {
    if (this.staticId === Number.MAX_VALUE) {
      this.staticId = 0;
    }
    return ++this.staticId;
  }
  /**
   * 生成旧大图controller新ID
   *
   * @returns 旧大图controller新ID
   */
  public static generatorIdOldStatic(): number {
    if (this.oldStaticId === Number.MIN_VALUE) {
      this.oldStaticId = 0;
    }
    return --this.oldStaticId;
  }
}