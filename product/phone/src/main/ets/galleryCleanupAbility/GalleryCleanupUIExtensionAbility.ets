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

import lazy UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import lazy { NetworkConnectionAccess } from '@ohos/privacy/src/main/ets/access/NetworkConnectionAccess';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy uiExtensionHost from '@ohos.uiExtensionHost';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { window } from '@kit.ArkUI';

/* instrument ignore file */
const TAG: string = 'GalleryCleanupUIExtensionAbility';

// 设置-存储-图库清理卡片点击立即优化，进入优化图库空间
export default class GalleryCleanupUIExtensionAbility extends UIExtensionAbility {
  private storage: LocalStorage = new LocalStorage();
  private isCleanupPageShow: boolean = true;

  onCreate() {
    Log.info(TAG, 'onCreate');
    try {
      this.context?.getApplicationContext()?.setSupportedProcessCache(true);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Log.info(TAG, `GalleryCleanupUIExtensionAbility setSupported returns code ${code}, returns msg ${message}`)
    }
  }

  onForeground() {
    Log.info(TAG, 'onForeground');
    this.context?.eventHub?.emit(Constants.GALLERY_CLEANUP_ON_FOREGROUND, true);
    if (!this.isCleanupPageShow) {
      this.isCleanupPageShow = true;
      AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
    }
  }

  onBackground() {
    Log.info(TAG, 'onBackground');
    this.context?.eventHub?.emit(Constants.GALLERY_CLEANUP_ON_FOREGROUND, false);
    if (this.isCleanupPageShow) {
      this.isCleanupPageShow = false;
      AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
    }
  }

  onDestroy() {
    Log.info(TAG, 'onDestroy');
    this.storage?.delete(Constants.APP_KEY_SCREEN_MANAGER);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    Log.info(TAG, 'GalleryCleanupUIExtensionAbility onRemoteReadyonSessionCreate');
    // UIExtensionAbility无法直接获取mainWindow
    let extensionWindow: uiExtensionHost.UIExtensionHostWindowProxy | undefined =
      session.getUIExtensionHostWindowProxy();
    extensionWindow?.hidePrivacyContentForHost(true);
    this.storage?.setOrCreate('photosAbilityContext', this.context);
    this.storage?.setOrCreate(Constants.PHOTO_PICKER_EXTENSION_WINDOW, extensionWindow);
    this.storage?.setOrCreate('GalleryCleanupSession', session);

    let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 导航条避让
    let avoidArea = extensionWindow?.getWindowAvoidArea(type);
    let bottomRectHeight = avoidArea?.bottomRect?.height; // 获取到导航条区域的高度
    AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);

    type = window.AvoidAreaType.TYPE_SYSTEM; // 状态栏避让
    avoidArea = extensionWindow?.getWindowAvoidArea(type);
    let topRectHeight = avoidArea?.topRect?.height; // 获取状态栏区域高度
    AppStorage.setOrCreate('topRectHeight', topRectHeight);

    // 监听状态栏和导航条的变化
    extensionWindow?.on('avoidAreaChange', (data) => {
      if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
        let topRectHeight = data.area.topRect.height;
        AppStorage.setOrCreate('topRectHeight', topRectHeight);
      } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        let bottomRectHeight = data.area.bottomRect.height;
        AppStorage.setOrCreate('bottomRectHeight', bottomRectHeight);
      }
    });

    let pagePath: string;
    let wantParam: Record<string, Object> = want.parameters as Record<string, Object>;
    let isVideoCleanupPage: boolean = wantParam?.targetPage as string === 'VideoCleanupEntryPage';
    let isPhotoCleanupPage: boolean = wantParam?.targetPage as string === 'PhotoCleanupEntryPage';
    if (isVideoCleanupPage) {
      pagePath = 'galleryCleanupAbility/view/VideoCleanupEntryPage';
    } else if (isPhotoCleanupPage) {
      pagePath = 'galleryCleanupAbility/view/PhotoCleanupEntryPage';
    } else {
      pagePath = 'galleryCleanupAbility/view/GalleryCleanupPage';
    }
    UserFileManagerAccess.getInstance(this.storage).onCreate(this.context);
    NetworkConnectionAccess.register();
    MediaObserver.getInstance().subscribe(this.context, TAG);
    getScreen(this.storage).initializationSize().then((): void => {
      getScreen(this.storage).getAvoidArea();
      getScreen(this.storage).setMainWindow();
      getScreen(this.storage).registerWindowAvoidArea();
      AppStorage.setOrCreate('isCleanupPageShow', this.isCleanupPageShow);
      session.loadContent(pagePath, this.storage);
      session.setWindowBackgroundColor('#00000000');
      Log.info(TAG, `onSessionCreate${extensionWindow}`);
    });
    CommonUtil.registerProgDispSwitchObserver(this.context);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Log.info(TAG, 'onSessionDestroy');
    NetworkConnectionAccess.unregister();
    getScreen(this.storage).destroyMainWindow();
    getScreen(this.storage).unRegisterWindowAvoidArea();
    UserFileManagerAccess.getInstance(this.storage).onDestroy();
    this.storage?.delete(Constants.PHOTO_CLEANUP_DATA_SOURCE_MANAGER);
    this.storage?.delete(Constants.PHOTO_PICKER_EXTENSION_WINDOW);
    this.storage?.delete('photosAbilityContext');
    this.storage?.delete('GalleryCleanupSession');
    this.storage?.clear();
    CommonUtil.unregisterProgDispSwitchObserver(this.context);
    AppStorage.delete('isCleanupPageShow');
  }
}