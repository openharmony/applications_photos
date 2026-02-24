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
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'EditorTestUtil';

export function retriesAsync<T>(asyncFn: () => Promise<T>, retries: number): Promise<T> {
  return Promise.resolve(asyncFn().catch(() => {
    if (--retries > 0) {
      Log.info(TAG, `retries left ${retries}`);
      return Promise.resolve(retriesAsync<T>(asyncFn, retries));
    } else {
      return Promise.reject('retry limit exceeded');
    }
  }));
}