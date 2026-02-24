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

import lazy { LogUtils } from './LogUtils';

const TAG = 'ObjectPool';

/**
 * 可回收对象
 */
export interface Recyclable {
  /**
   * 回收方法
   */
  recycle(): void;
}

/**
 * 对象构建器
 */
export type ObjectBuilder<T> = () => T;

/**
 * 基础对象池实现
 */
export class ObjectPool<T extends Recyclable> {
  /**
   * 最大实例数
   */
  private readonly _maxCount: number;

  /**
   * 全部实例
   */
  private readonly _objs: Array<T>;

  /**
   * 空闲实例
   */
  private readonly _idleObjs: Set<T> = new Set();

  /**
   * 对象构造器
   */
  private readonly _objectBuilder: ObjectBuilder<T>;

  /**
   * 构造方法
   *
   * @param maxCount 最大实例数
   */
  constructor(maxCount: number, objectBuilder: () => T) {
    this._maxCount = maxCount;
    this._objs = new Array();
    this._objectBuilder = objectBuilder;
    LogUtils.debug(TAG, `maxCount: ${maxCount}`);
  }

  /**
   * 获取对象
   *
   * @returns 对象
   */
  public acquire(): T | null {
    if (this._idleObjs.size > 0) {
      let idleObj = this._idleObjs.values().next().value;
      this._idleObjs.delete(idleObj);
      if (idleObj) {
        LogUtils.debug(TAG, 'idleObj: success.');
        return idleObj;
      }
    }
    if (this._objs.length < this._maxCount) {
      let newObj = this._objectBuilder();
      if (newObj) {
        LogUtils.debug(TAG, 'newObj: success.');
        this._objs.push(newObj);
        return newObj;
      }
    }
    LogUtils.info(TAG,
      `acquire failed: <idle ${this._idleObjs.size}, current: ${this._objs.length}, max: ${this._maxCount}>.`);
    return null;
  }

  /**
   * 归还对象
   *
   * @returns 对象
   */
  public release(obj: T): void {
    if (!obj || this.isReleased(obj)) {
      return;
    }
    obj.recycle();
    this._idleObjs.add(obj);
  }

  /**
   * 判断对象是否空闲的
   *
   * @param obj 判断的对象
   * @returns 是否空闲的
   */
  public isReleased(obj: T): boolean {
    return this._idleObjs.has(obj);
  }

  /**
   * 销毁对象池
   */
  public destroy(): void {
    this._objs.forEach(obj => {
      if (!this.isReleased(obj)) {
        obj.recycle();
      }
    });
    this._objs.splice(0, this._objs.length);
    this._idleObjs.clear();
  }
}