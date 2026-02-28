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

import { window } from '@kit.ArkUI';
import { WindowMode } from '@kit.TestKit';

/**
 * 专门用于在ts不报错的，但在ets报错且解决不了的函数
 */
export class TestKit {
  public static async getWindowMode(windowStage: window.WindowStage | undefined): Promise<WindowMode> {
    // @ts-ignore
    return await windowStage?.getWindowMode() as WindowMode;
  }
}



