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
import { BusinessError } from '@kit.BasicServicesKit';

export interface Resolvers<T> {
  resolve: (data?: T) => void;
  reject: (error: BusinessError) => void;
  promise: Promise<T>;
}

export class PromiseUtil {
  public static withResolvers = <T>() => {
    let resolve: (data: T) => void = (data: T) => {
    };
    let reject: (error: BusinessError) => void = () => {
    };
    const promise = new Promise<T>((_resolve, _reject) => {
      resolve = _resolve;
      reject = reject;
    });

    return {
      promise,
      resolve,
      reject
    } as Resolvers<T>;
  };
}