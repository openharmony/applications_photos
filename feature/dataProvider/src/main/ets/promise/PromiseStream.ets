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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const PS_LINK_TAG: string = 'PipeStreamLinkedNode';
 
class PipeStreamLinkedNode<T> {
  private asyncFn?: () => Promise<T | undefined>;
  private id: string;
  private head?: PipeStreamLinkedNode<T>;
  private tail?: PipeStreamLinkedNode<T>;
  private handler?: () => void;
  private done: boolean = false;
 
  constructor(asyncFn: () => Promise<T | undefined>, id: string) {
    this.asyncFn = asyncFn;
    this.id = id
  }
 
  public setHead(head: PipeStreamLinkedNode<T>) {
    this.head = head;
  }
 
  public setTail(tail: PipeStreamLinkedNode<T>) {
    this.tail = tail;
  }
 
  public noTail() {
    return !this.tail;
  }
 
  public getDone(): boolean {
    return this.done;
  }
 
  private release(): void {
    if (this.tail) {
      this.tail.head = undefined;
      this.tail = undefined;
    }
    this.handler = undefined;
    this.asyncFn = undefined;
  }
 
  public async execute(): Promise<T | undefined> {
    try {
      let resolveFn: (value: T | PromiseLike<T> | undefined) => void;
      const current = new Promise<T | undefined>(((resolve) => {
        resolveFn = resolve;
      }))
      this.handler = () => {
        // head通知当前promise，断开链接
        Log.debug(PS_LINK_TAG, `key: ${this.id} , msg: invoke handler, release head`);
        if (this.head) {
          this.head.release();
        }
        // 处理当前promise逻辑
        this.asyncFn?.()
          .then((value) => {
            Log.debug(PS_LINK_TAG, `key: ${this.id} , msg: invoke asyncFn success, do resolve`);
            resolveFn(value);
          })
          .catch(() => {
            Log.debug(PS_LINK_TAG, `key: ${this.id} , msg: invoke asyncFn error, do resolve`);
            // 不对异常进行处理，以保证链路正常
            resolveFn(undefined);
          })
          .finally(() => {
            this.done = true;
            // 处理完成后, 通知下条promise
            Log.debug(PS_LINK_TAG, `key: ${this.id} , msg: notify to invoke promise`);
            this.tail?.handler?.();
          });
      }
      if (!this.head) {
        this.handler();
      }
      return current;
    } catch (err) {
      Log.debug(PS_LINK_TAG, `key: ${this.id} , msg: execute catch error`);
      return;
    }
  }
}
 
const PS_TAG: string = 'PipeStream';
 
/**
 * promise 管道流
 * 1. 前一个promise执行完之后，再执行下一个promise
 * 2. 基于key的节流，防止相同key在throttlingTime内执行多次
 * 3. throttlingTime 默认值为0时，表示不进行节流
 * 4. 整个管道内没有下一个promise时，重置cache
 * */
export class PipeStream<T> {
  private throttling: number = 0;
  private cache: Map<string, number> = new Map();
  private current?: PipeStreamLinkedNode<T>;
 
  constructor(throttlingTime: number = 0) {
    this.throttling = throttlingTime;
  }
 
  public async emitAndGetStream(asyncFn: () => Promise<T>, id: string): Promise<T | undefined> {
    if (!this.check(id)) {
      Log.debug(PS_TAG, 'msg: emitAndGetStream return : ' + id);
      return;
    }
    const link = new PipeStreamLinkedNode(asyncFn, id);
    if (!this.current || this.current.getDone()) {
      this.current = link;
    } else {
      this.current.setTail(link);
      link.setHead(this.current);
      this.current = link;
    }
    try {
      return this.current.execute().finally(() => {
        // 异步方法执行完成之后,判断当前节点是否是最后一个
        if (link?.noTail()) {
          // 表示最后一个节点才统一重置,中间节点不进行重置
          this.reset();
        }
      });
    } catch (err) {
      Log.info(PS_TAG, 'msg: execute finally error : ' + id);
      return;
    }
  }
 
  // 判断当前id是否有效
  private check(id: string): boolean {
    if (!this.throttling) {
      return true;
    }
    const now = Date.now();
    const last = this.cache.get(id) ?? 0;
    const isValid = now - last > this.throttling;
    this.cache.set(id, now);
    return isValid;
  }
 
  private reset(): void {
    const now = Date.now();
    const keys = this.cache.keys();
    for (let key of keys) {
      const last = this.cache.get(key) ?? 0;
      if (now - last > this.throttling) {
        this.cache.delete(key);
      }
    }
    Log.debug(PS_TAG, 'msg: reset the cache, size: ' + this.cache.size);
  }
}
