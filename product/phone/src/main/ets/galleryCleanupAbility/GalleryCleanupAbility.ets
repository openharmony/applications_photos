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

import lazy { NetworkConnectionAccess } from '@ohos/privacy/src/main/ets/access/NetworkConnectionAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { getScreen, ScreenManager, setHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Want from '@ohos.app.ability.Want';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { AbilityConstant, UIAbility } from '@kit.AbilityKit';
import lazy { errors } from '@ohos/tools/src/main/utils/errors';
import lazy window from '@ohos.window';

const TAG = "GalleryCleanupAbility"

// 设置-存储-图库-前往图库清理 入口
export default class GalleryCleanupAbility extends UIAbility {
  private storage: LocalStorage = new LocalStorage();
  private isCleanupPageShow: boolean = true;

  /* instrument ignore next */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info(TAG, 'Application onCreate start');
    let applicationContext = this.context.getApplicationContext();
    try {
      applicationContext.setSupportedProcessCache(true);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`setSupportedProcessCache fail, code: ${code}, msg: ${message}`);
    }
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
    let screenManager: ScreenManager = getScreen(this.storage);
    screenManager.destroyMainWindow();
    screenManager.unRegisterWindowAvoidArea();
    NetworkConnectionAccess.unregister();
    // 传参 this.storage 会新创建一个instance实例，放入storage里面
    UserFileManagerAccess.getInstance(this.storage).onDestroy();
    this.storage?.delete('photosAbilityContext');
    this.storage?.clear();
    // 取消注册
    CommonUtil.unregisterProgDispSwitchObserver(this.context);
    AppStorage.delete('isCleanupPageShow');
  }

  /* instrument ignore next */
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Log.info(TAG, 'Application onWindowStageCreate');
    windowStage.getMainWindow().then((win: window.Window): void => {
      this.storage?.setOrCreate('mainWindow', win);
      this.storage?.setOrCreate('photosAbilityContext', this.context);
      this.storage?.setOrCreate('isFromShortcut', true);
      UserFileManagerAccess.getInstance(this.storage).onCreate(this.context);
      NetworkConnectionAccess.register();
      MediaObserver.getInstance().subscribe(this.context, TAG);
      // Default orientation
      let screenManager: ScreenManager = getScreen(this.storage);
      screenManager.initializationSize().then((): void => {
        Log.info(TAG, 'initializationSize');
        screenManager.getAvoidArea();
        screenManager.setMainWindow();
        screenManager.registerWindowAvoidArea();
        AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
      }).catch((): void => {
        Log.error(TAG, 'get device screen info failed.');
      });
      // 默认全篇沉浸式
      windowStage.getMainWindowSync().setWindowLayoutFullScreen(true);

      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 导航条避让
      let avoidArea = win?.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea?.bottomRect?.height; // 获取到导航条区域的高度
      AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);

      type = window.AvoidAreaType.TYPE_SYSTEM; // 状态栏避让
      avoidArea = win?.getWindowAvoidArea(type);
      let topRectHeight = avoidArea?.topRect?.height; // 获取状态栏区域高度
      AppStorage.setOrCreate('topRectHeight', topRectHeight);

      win?.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height;
          AppStorage.setOrCreate('topRectHeight', topRectHeight);
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height;
          AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);
        }
      });

      windowStage.loadContent('galleryCleanupAbility/view/GalleryCleanupPage', this.storage,
        (err: BusinessError, data): void => {
          Log.info(TAG, 'loadContent');
          if (err.code) {
            Log.error(TAG, 'Failed to load the content. Cause: %{public}s' + errors.toString(err));
            return;
          }
        });
      CommonUtil.registerProgDispSwitchObserver(this.context);
    });
  }

  onBackPressed(): boolean {
    Log.info(TAG, 'onBackPressed');
    // back让设置完成动效，Ability不进行处理
    return false;
  }

  onForeground() {
    Log.info(TAG, 'onForeground');
    if (!this.isCleanupPageShow) {
      this.isCleanupPageShow = true;
      AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
    }
  }

  onBackground() {
    Log.info(TAG, 'onBackground');
    if (this.isCleanupPageShow) {
      this.isCleanupPageShow = false;
      AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
    }
  }
}