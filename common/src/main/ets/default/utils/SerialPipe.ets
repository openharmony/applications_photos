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
import lazy { Log } from './Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'SerialPipe';
const FIND_ADDRESS_TIMEOUT = 2500;
const CLEAR_ACTION_TIMEOUT = 5000;

interface actionHandlerType<T> {
  action: () => Promise<T> | undefined;
  result: (value: T) => void;
  time: number;
}

/**
 * 串行管道，给定调用函数，将函数调用方式改为串行调用
 */
export class SerialPipe<T> {
  public readonly timeout: number;
  private readonly tag: string;
  private actions: actionHandlerType<T>[] = [];
  public runAble: boolean = true;
  private clearActionAble: boolean = false;
  private defaultValue: T;
  private batchCount = 1;
  public runCount: number = 0;

  public constructor(timeout: number, defaultValue: T, tag?: string, clearActionAble = false) {
    this.timeout = Math.max(timeout, 0);
    this.defaultValue = defaultValue;
    this.tag = tag ?? TAG;
    this.clearActionAble = clearActionAble;
  }

  public pipe(action: () => Promise<T> | undefined): Promise<T> {
    return new Promise((resolve) => {
      let actionHandler: actionHandlerType<T> = {
        action,
        time: new Date().getTime(),
        result(value) {
          resolve(value);
        }
      }
      this.actions.push(actionHandler);
      this.tryRunHandler();
    })
  }

  private tryRunHandler(isFromNext = false) {
    if (!this.runAble) {
      return;
    }
    let batchActions = this.actions.slice(0, this.batchCount);
    if (!batchActions[0]) {
      return;
    }
    this.runAble = false;
    if (!isFromNext) {
    }
    this.runCount += this.batchCount;
    Promise.all(batchActions.map(actionHandler => this.getRunPromise(actionHandler)))
      .then(() => {
        this.runNext();
      })
  }

  private getRunPromise = (actionHandler: actionHandlerType<T>): Promise<T> => {
    return new Promise(resolve => {
      let onFinish = (value: T) => {
        this.runCount -= this.batchCount;
        actionHandler.result(value);
        resolve(value)
      }
      let result = actionHandler.action();
      if (result) {
        let isTimeout = false;
        let runTimeoutTimer = setTimeout((): void => {
          isTimeout = true;
          onFinish(this.defaultValue)
        }, this.timeout);

        result.then((value) => {
          if (!isTimeout) {
            clearTimeout(runTimeoutTimer)
            onFinish(value)
          }
        }).catch((err: BusinessError) => {
          Log.error(this.tag, `batch data error: ${err}, code: ${err?.code}`);
          if (!isTimeout) {
            clearTimeout(runTimeoutTimer)
            onFinish(this.defaultValue)
          }
        })
      } else {
        onFinish(this.defaultValue)
      }
    })
  }

  private runNext() {
    this.actions = this.actions.slice(this.batchCount);
    if (this.clearActionAble) {
      this.clearLongTimeoutAction();
    }
    this.runAble = true;
    this.tryRunHandler(true);
  }

  private clearLongTimeoutAction() {
    let time = new Date().getTime();
    let newActions: actionHandlerType<T>[] = [];
    this.actions.forEach(actionHandler => {
      if (time - actionHandler.time > CLEAR_ACTION_TIMEOUT) {
        actionHandler.result(this.defaultValue)
      } else {
        newActions.push(actionHandler)
      }
    });
    this.actions = newActions;
  }
}


export const findAddressSerialPipe = new SerialPipe(FIND_ADDRESS_TIMEOUT, '[]', TAG, true);
