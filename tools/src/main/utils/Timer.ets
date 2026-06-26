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

export namespace Timer {
  /**
   * 手动触发延时, 比setTimeout节约圈复杂度
   *
   * 使用方法: await Timer.sleep(millisecond)
   * @param ms millisecond
   * @returns
   */
  export function sleep<T = void>(ms: number): PromiseLike<T> {
    return new Promise(
      (resolve: (value: T | PromiseLike<T>) => void): number => setTimeout(resolve, ms)
    );
  }

  /**
   * 执行异步函数, 并计算函数执行时间
   *
   * 使用方法: const duration = await Timer.getDuration(async (....
   * @param
   * @returns ms millisecond
   */
  export async function getDuration<T = void>(timeKiller: (...t: T[]) => Promise<void>,
    ...params: T[]): Promise<number> {
    const starts: number = new Date().getTime();
    await timeKiller(...params);
    const ends: number = new Date().getTime();
    return ends - starts;
  }
}

export default Timer;