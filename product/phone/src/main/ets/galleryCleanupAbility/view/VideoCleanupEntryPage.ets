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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { VideoCleanupPage } from './VideoCleanupPage';
import type { BrowserDataInterface } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';
import lazy { AlbumDataImpl } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumDataImpl';
import lazy { BrowserDataFactory } from '@ohos/common/src/main/ets/default/interface/BrowserDataFactory';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy ThirdAppLockUtil from '@ohos/common/src/main/ets/default/utils/ThirdAppLockUtil';
import lazy { common, ConfigurationConstant } from '@kit.AbilityKit';
import lazy { ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { AlbumAssetInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumAssetInfo';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { ActionBarMode } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ActionBar } from '@ohos/browsercommon/src/main/ets/default/view/actionbar/ActionBar';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';

/* instrument ignore file */
let storage: LocalStorage = LocalStorage.getShared();
const TAG: string = 'VideoCleanupEntryPage';

/**
 * 视频专清跳转页
 *
 * @since 2025-02-25
 */
@Entry(storage)
@Component
export struct VideoCleanupEntryPage {
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private albumDataImpl: BrowserDataInterface | undefined;
  @State private albumInfo: AlbumInfo | undefined = undefined;
  @Provide pageInfo: NavPathStack = new NavPathStack();
  @StorageProp('currentColorMode') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
  // 应用锁是否展示
  @State isAppLockShow: boolean = false;
  @State appLockUtil: ThirdAppLockUtil = new ThirdAppLockUtil();
  private isUIExt = ScreenManager.getInstance(storage).isUIExtensionEnv();
  @State private isAgreed: boolean = false;
  @StorageLink('isCleanupPageShow') @Watch('onPageChanged') isCleanupPageShow: boolean = true;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  @StorageLink('topRectHeight') topRectHeight: number = 0;

  private appLockUpdate = (state: boolean) => {
    Log.info(TAG, `appLockUpdate ${state}`);
    this.isAppLockShow = state;
  };

  private galleryCleanupOnForegroundFun: (isOnForeground: boolean) => Promise<void> =
    async (isOnForeground: boolean): Promise<void> => {
      Log.info(TAG, `VideoCleanupEntryPage galleryCleanupOnForegroundFun: isOnForeground=${isOnForeground}`);
      if (isOnForeground) {
        LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
      } else {
        LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
      }
    }

  private createActionBar(): ActionBarProp {
    let menuList: Action[] = [];
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(Action.BACK)
      .setTitle($r('app.string.album_video'))
      .setMenuList(menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
    return actionBarProp;
  }

  @Builder
  buildActionBar() {
    Column() {
      ActionBar({
        actionBarProp: this.actionBarProp,
        isNeedPlaceholder: false,
        actionMoreMenuList: undefined,
        onMenuClicked: (): void => this.onBack()
      })
        .padding({
          top: px2vp(this.topRectHeight),
        })
    }
    .zIndex(2)
    .position({ y: 0 })
    .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
    .backgroundColor($r('app.color.transparent'))
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      if (!this.isAgreed) {
        this.buildActionBar();
        NoPhotoComponent({
          title: $r('app.string.no_videos_head_title_videoAlbum'),
          isFromEmptyAlbum: true,
        });
      } else if (this.albumInfo) {
        VideoCleanupPage({
          albumInfo: this.albumInfo,
          storage: storage,
          isFromVideoCleanupEntryPage: true,
        });
      }
      if (this.isAppLockShow && this.isUIExt) {
        // PickerMaskLayer({
        //   onclose: () => {
        //     Log.info(TAG, 'PickerMaskLayer onclose!');
        //   },
        //   appInfos: [{
        //     bundleName: 'com.ohos.photos',
        //     appIndex: 0,
        //   }],
        //   maskShow: this.isAppLockShow,
        //   unlockProxy: true,
        //   currentMode: this.currentMode,
        // })
      }
    }
  }

  /**
   * 获取视频相册信息
   *
   * @returns
   */
  private async getVideoAlbum(): Promise<void> {
    this.albumDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    if (this.albumDataImpl && this.albumDataImpl instanceof AlbumDataImpl) {
      const videoAlbumInfo = await this.albumDataImpl.getVideoAlbum();
      let videoAlbumAssetInfo: AlbumAssetInfo = await videoAlbumInfo.getAlbumAssetInfo(Constants.VIDEO_CLEANUP_PAGE);
      videoAlbumInfo.setAlbumName($r('app.string.album_video'));
      videoAlbumInfo.setAlbumLocalAssetCount(videoAlbumAssetInfo.albumLocalAssetCount);
      this.albumInfo = videoAlbumInfo;
      ReportToBigDataUtil.report(BigDataConstants.ENTER_VIDEO_CLEANUP_ENTRY);
      Log.info(TAG, `getVideoAlbum: Get VideoAlbum done! albumUri=${this.albumInfo.uri}`);
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.updateIsAgreed();
    getContext(this)?.eventHub?.on(Constants.GALLERY_CLEANUP_ON_FOREGROUND, this.galleryCleanupOnForegroundFun);
    this.appBroadCast.on(Constants.THIRD_APP_LOCK_UPDATE, this.appLockUpdate);
    this.appLockUtil.init(Constants.GALLERY_CLEANUP_ON_FOREGROUND);
    this.actionBarProp = this.createActionBar();
    if (this.isAgreed) {
      this.getVideoAlbum();
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    getContext(this)?.eventHub?.off(Constants.GALLERY_CLEANUP_ON_FOREGROUND, this.galleryCleanupOnForegroundFun);
    this.appBroadCast.off(Constants.THIRD_APP_LOCK_UPDATE, this.appLockUpdate);
    this.appLockUtil.destroy();
  }

  onBackPress(): boolean | void {
    Log.info(TAG, 'Navigation onBackPress');
    if (!this.isAgreed) {
      this.onBack();
    } else {
      this.appBroadCast.emit(BroadCastConstants.PROCESS_VIDEO_PAGE_BACK, []);
    }

    return true;
  }

  private onPageChanged(): void {
    Log.info(TAG, `onPageChanged: this.isCleanupPageShow=${this.isCleanupPageShow}`);
    if (this.isCleanupPageShow) {
      this.updateIsAgreed();
    }
  }

  private onBack(): void {
    Log.info(TAG, `UIExtensionContentSession onBackPressed`);
    let session: UIExtensionContentSession | undefined =
      storage.get<UIExtensionContentSession>('GalleryCleanupSession');
    session?.terminateSelf();
  }

  private async updateIsAgreed(): Promise<void> {
    if (this.isAgreed) {
      return;
    }
    let context: common.UIAbilityContext | undefined =
      storage.get<common.UIAbilityContext>('photosAbilityContext');
    if (context) {
      this.isAgreed = await Protocol.getIsAgreedPref(context) ?? false;
    }
    if (this.isAgreed) {
      this.getVideoAlbum();
    }
    Log.info(TAG, `VideoCleanupEntryPage-isAgreed=${this.isAgreed}`)
  }
}