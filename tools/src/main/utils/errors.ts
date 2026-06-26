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
import type { BusinessError } from '@kit.BasicServicesKit';

/* instrument ignore file */
const TAG: string = 'errors';

export type WithErr<R> = [R | undefined, Error | undefined];

export namespace errors {
  export function tryFunc<R = void, P = never>(func?: (...params: P[]) => R, ...params: P[]): R | undefined {
    if (typeof func !== 'function') {
      Log.error(TAG, `func.name, is not a func ${typeof func}` + params);
      return undefined;
    }
    let res: R | undefined = undefined;
    try {
      res = func(...params);
    } catch (error) {
      Log.error(TAG, `err: ${errors.toString(error)} ${
      func?.name ? 'funcName: ' + func.name : ''}, params: ${params}`);
    }
    return res;
  }

  export async function catchPromise<R>(promise: Promise<R>): Promise<R> {
    return promise
      .then((data: R): R => data)
      .catch(genericCatch(String(promise)));
  }

  export function genericCatch<R>(msg?: string): (error: Error) => Promise<R> {
    return (error: Error): Promise<R> => {
      Log.error(TAG, error?.message + msg);
      return undefined;
    };
  }

  export async function catchWithErr<R>(promise: Promise<R>): Promise<WithErr<R>> {
    return promise
      .then<[R, undefined]>((data: R): [R, undefined] => [data, undefined])
      .catch<[undefined, Error]>((err: Error): [undefined, Error] => [undefined, err]);
  }

  export async function tryPromise<R, P = void>(func: (...params: P[]) => Promise<R>, ...params: P[]):
    Promise<R | undefined> {
    if (typeof func !== 'function') {
      Log.error(TAG, `func.name, is not a func ${typeof func}` + params);
      return undefined;
    }
    let res: R | undefined = undefined;
    try {
      res = await catchPromise(func(...params));
    } catch (error) {
      Log.error(TAG, `err: ${errors.toString(error)} ${
      func?.name ? 'funcName: ' + func.name : ''}, params: ${params}`);
    }
    if (!res) {
      return undefined;
    }
    return res;
  }

  export async function tryWithErr<R, P = void>(func: Function, ...params: P[]): Promise<WithErr<R>> {
    if (typeof func !== 'function') {
      Log.error(TAG, `func.name, is not a func ${typeof func}` + params);
      return [undefined, undefined];
    }
    let [res, err]: WithErr<R> = [undefined, undefined];
    try {
      [res, err] = await func(...params).then((data: R): [R, undefined] => [data, undefined])
        .catch((error: Error): void => {
          Log.error(TAG, `tryWithErr err: ${
          error?.message ?? ''} ${func?.name ? 'funcName: ' + func.name : ''}, params: ${params}`);
          err = error;
        });
    } catch (error) {
      Log.error(TAG, `err: ${errors.toString(error)} ${
      func?.name ? 'funcName: ' + func.name : ''}, params: ${params}`);
      err = err ?? error;
    }
    if (!res) {
      return [undefined, err];
    }
    return [res, undefined];
  }

  export function toString(error?: BusinessError): string {
    return `BusinessError occured: ${error ?? ''} code: ${error?.code ?? ''}; `;
  }
}