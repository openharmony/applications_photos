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

/**
 * 管理Picker前台实例
 */
export class PickerForegroundManager {
  private static instance: PickerForegroundManager;
  private foregroundInstanceCount: number = 0;

  public static getInstance(): PickerForegroundManager {
    if (!PickerForegroundManager.instance) {
      PickerForegroundManager.instance = new PickerForegroundManager();
    }
    return PickerForegroundManager.instance;
  }

  public addForegroundInstance(): void {
    this.foregroundInstanceCount++;
  }

  public deleteInstance(): number {
    this.foregroundInstanceCount--;
    return this.foregroundInstanceCount;
  }
}