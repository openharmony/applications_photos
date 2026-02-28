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

/* instrument ignore file */

import lazy { window } from '@kit.ArkUI';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { Log } from './Log';

const TAG: string = 'SubWindowUtil';

export class SubWindowUtil {
  public static PICKER_WARNING_SUB_WINDOW_NAME = 'PickerWarningSubWindow';
  public static PICKER_WARNING_SUB_WINDOW_PATH = 'pickerability/view/PickerWarningSubWindowPage';
  /**
   * 图库子窗
   */
  public static subWindow?: window.Window;

  /**
   * 创建子窗
   * @param session 调用方session
   * @param subWindowName 子窗名称
   * @param storage 携带参数
   * @param windowPath 子窗内容页面路径
   * @returns
   */
  public static createSubWindow(session: UIExtensionContentSession, subWindowName: string,
    storage: LocalStorage, windowPath: string): Promise<void> {
    return new Promise(async (resolve, reject) => {
      try {
        if (SubWindowUtil.subWindow) {
          Log.i(TAG, 'createSubWindow exist subWindow');
          await SubWindowUtil.destroySubWindow();
        }
        let extensionWinProxy = session?.getUIExtensionHostWindowProxy();
        if (!extensionWinProxy) {
          Log.e(TAG, 'createSubWindow extensionWinProxy invalid');
          reject();
          return;
        }
        let subWindowOpts: window.SubWindowOptions = {
          title: '',
          decorEnabled: false,
          isModal: false,
          isTopmost: true,
        };
        let newSubWindow: window.Window =
          await extensionWinProxy.createSubWindowWithOptions(subWindowName, subWindowOpts);
        SubWindowUtil.subWindow = newSubWindow;
        await newSubWindow.loadContent(windowPath, storage);
        newSubWindow?.setWindowBackgroundColor('#00000000');
        await newSubWindow?.setWindowLayoutFullScreen(true);
        newSubWindow?.setShadow(0.0);
        await newSubWindow?.showWindow();
        resolve();
      } catch (err) {
        Log.e(TAG, `createSubWindow failed code ${err?.code} and message ${err?.message}`);
        SubWindowUtil.subWindow = undefined;
        reject();
      }
    });
  }

  /**
   * 销毁子窗
   *
   * @returns
   */
  public static async destroySubWindow() {
    try {
      if (!SubWindowUtil.subWindow) {
        Log.e(TAG, 'destroySubWindow subWindow is undefined');
        return;
      }
      await SubWindowUtil.subWindow.destroyWindow();
      SubWindowUtil.subWindow = undefined;
      Log.i(TAG, 'destroySubWindow subWindow success');
    } catch (err) {
      Log.e(TAG, `destroySubWindow failed code ${err?.code} and message ${err?.message}`);
      SubWindowUtil.subWindow = undefined;
    }
  }
}