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
import lazy window from '@ohos.window';

/**
 * 提供窗口操作的工具类
 */
export class WindowUtil {
  /**
   * 隐藏应用程序的标题栏并进入全屏模式
   * @param context 应用程序上下文，用于获取和操作窗口
   */
  static hideTitleBar(context) {
    try {
      window.getLastWindow(context, (err, data) => {
        if (err) {
          console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        const windowClass = data;
        console.info('Succeeded in obtaining the top window. Data: ' + JSON.stringify(data));
        windowClass.setFullScreen(true, () => {});
      });
    } catch (exception) {
      console.error('Failed to obtain the top window. Cause: ' + JSON.stringify(exception));
    }
  }
}
