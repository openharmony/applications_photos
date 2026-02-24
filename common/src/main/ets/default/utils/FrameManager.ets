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
/* instrument ignore file*/
import lazy displaySync from '@ohos.graphics.displaySync';
import lazy { Log } from './Log';

const TAG: string = 'FrameManager';

export class FrameManager {
  private static instance: FrameManager | null = null;
  private taskMap = new Map<string, (() => void)[]>();
  private displaySync: displaySync.DisplaySync = displaySync.create();
  private isRunning = false;

  private constructor() {
    this.displaySync.on('frame', () => {
      if (this.taskMap.size === 0) {
        this.stop();
        return;
      }
      const keys = Array.from(this.taskMap.keys());
      for (const key of keys) {
        const tasks = this.taskMap.get(key);
        if (!tasks || tasks.length === 0) {
          this.taskMap.delete(key);
          continue;
        }
        try {
          const task = tasks.shift();
          if (task) {
            task();
          }
        } catch (error) {
          Log.e(TAG, `Task execution failed for key: ${key}. Error: ${error}`);
        }
        if (tasks.length === 0) {
          this.taskMap.delete(key);
        }
      }
    });
  }

  public static getInstance(): FrameManager {
    if (!FrameManager.instance) {
      Log.i(TAG, 'Creating new instance...');
      FrameManager.instance = new FrameManager();
    }
    return FrameManager.instance;
  }

  public postTask(key: string, task: () => void): void {
    if (!key || !task) {
      Log.i(TAG, `invalid key or task`);
      return;
    }
    if (!this.taskMap.has(key)) {
      this.taskMap.set(key, []);
    }

    const tasks = this.taskMap.get(key);
    if (tasks) {
      tasks.push(task);
    }

    if (!this.isRunning) {
      this.start();
    }
  }

  private start(): void {
    if (!this.isRunning) {
      this.isRunning = true;
      this.displaySync.start();
    }
  }

  private stop(): void {
    if (this.isRunning) {
      this.isRunning = false;
      this.displaySync.stop();
    }
  }

  public dispose(): void {
    if (FrameManager.instance === null) {
      Log.i(TAG, 'FrameManager instance is null. No action needed.');
      return;
    }
    Log.i(TAG, 'Disposing FrameManager...');
    this.stop();
    this.taskMap.clear();
    this.displaySync.off('frame');
    Log.i(TAG, 'Task queue cleared. Instance will be set to null.');
    FrameManager.instance = null;
  }
}