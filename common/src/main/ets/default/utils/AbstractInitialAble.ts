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
 * 初始化接口
 *
 * @param T 初始化参数类型
 */
export interface InitialAble<T = number> {
  /**
   * 初始化
   *
   * @param param 初始化参数
   */
  init(param?: T): void;

  /**
   * 释放
   */
  release(): void;
}

/**
 * 抽象可初始化基类
 *
 * @param T 初始化参数类型
 */
export abstract class AbstractInitialAble<T = number> implements InitialAble<T> {
  /**
   * 实例ID
   */
  protected _persistentId?: number;

  // 标签
  private readonly _tag: string;

  // 是否初始化
  private _hasInit: boolean = false;

  public constructor(tag?: string) {
    this._tag = tag ?? this.constructor.name;
  }

  /**
   * 初始化
   */
  public init(param?: T): void {
    if (this.isSupport === undefined || this.isSupport?.(param)) {
      this.doInit(param);
      this.initPersistentId(param);
      this._hasInit = true;
    }
  }

  /**
   * 释放
   */
  public release(): void {
    if (this._hasInit) {
      this.doRelease();
      this._hasInit = false;
    }
  }

  /**
   * 是否已经初始化
   *
   * @returns true是/false否
   */
  public hasInit(): boolean {
    return this._hasInit;
  }

  /**
   * 获取实例ID
   *
   * @returns 实例ID
   */
  public get persistentId(): number {
    return this._persistentId ?? 0;
  }

  /**
   * 设置持久化ID
   *
   * @param persistentId 持久化ID
   */
  public setPersistentId(persistentId?: number): void {
    if (this._persistentId === undefined) {
      this._persistentId = persistentId;
    }
  }

  /**
   * 获取标记
   *
   * @returns 标记
   */
  public get tag(): string {
    return this._tag + this._persistentId;
  }

  /**
   * 是否支持初始化
   *
   * @returns true支持/false不支持
   */
  protected isSupport?(param?: T): boolean;

  /**
   * 执行初始化
   *
   * @param param 初始化参数
   */
  protected abstract doInit(param?: T): void;

  /**
   * 执行释放
   */
  protected abstract doRelease(): void;

  protected initPersistentId(param?: T): void {
    if (this.persistentId !== undefined) {
      return;
    }
    if (typeof param === 'number') {
      this._persistentId = param;
    }
  }
}