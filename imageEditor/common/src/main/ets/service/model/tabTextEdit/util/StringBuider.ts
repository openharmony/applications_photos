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
const TAG = 'StringUtil';

/**
 * 仿写字符串拼接
 *
 * @since 2023-09-04
 */
export class StringBuilder {
  private _store: Array<string>;

  constructor();
  constructor(value: string);
  constructor(value: number);
  constructor(value: string[]);
  constructor(value: StringBuilder);
  constructor(value?: string | number | string[] | StringBuilder) {
    if (typeof value === 'string') {
      this._store = [value];
    } else if (value instanceof Array) {
      this._store = value;
    } else if (value instanceof StringBuilder) {
      this._store = value._store;
    } else if (value) {
      this._store = [value.toString()];
    } else {
      this._store = [];
    }
  }

  get length(): number {
    return this._store.length;
  }

  append(value: string): void;
  append(value: number): void;
  append(value: string[]): void;
  append(value: StringBuilder): void;
  append(value: string | number | boolean | string[] | StringBuilder): void {
    if (typeof value === 'string') {
      this._store.push(value);
    } else if (value instanceof Array) {
      this._store.push(...value);
    } else if (value instanceof StringBuilder) {
      this._store.push(...value._store);
    } else {
      this._store.push(value.toString());
    }
  }

  insert(index: number, value: string): void;
  insert(index: number, value: number): void;
  insert(index: number, value: boolean): void;
  insert(index: number, value: string[]): void;
  insert(index: number, value: StringBuilder): void;
  insert(index: number, value: string | number | boolean | string[] | StringBuilder): void {
    if (typeof value === 'string') {
      this._store.splice(index, 0, value);
    } else if (value instanceof Array) {
      this._store.splice(index, 0, ...value);
    } else if (value instanceof StringBuilder) {
      this._store.splice(index, 0, ...value._store);
    } else {
      this._store.splice(index, 0, value.toString());
    }
  }

  toString() {
    return this._store.join('');
  }
}