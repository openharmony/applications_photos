/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import type { PendingCondition } from './PendingCondition';
// Pending task queue
export class PendingTask {
  private tasks: Function[] = new Array<Function>();
  private condition: PendingCondition;

  constructor(condition: PendingCondition) {
    if (condition == null) {
      throw Error('PendingTask condition is null');
    }
    this.condition = condition;
  }

  public execute(task: Function): void {
    if (task == null) {
      return;
    }
    if (this.condition.shouldPending()) {
      this.tasks.push(task)
    } else {
      task();
    }
  }

  public flush(): void {
    while (this.tasks.length > 0) {
      if (this.condition.shouldPending()) {
        return;
      }
      let task: Function = this.tasks.shift();
      if (task != null) {
        task();
      }
    }
  }

  public clear(): void {
    this.tasks = [];
  }
}

