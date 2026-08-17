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
import lazy { power } from '@kit.BasicServicesKit';
import lazy window from '@ohos.window';
import lazy { WindowUtil } from '../utils/WindowUtil';
import lazy { getScreen, ScreenManager, WindowMode } from '../model/common/ScreenManager';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { UiUtil } from '../utils/UiUtil';
import lazy { common, wantConstant } from '@kit.AbilityKit';
import lazy { display } from '@kit.ArkUI';
import lazy { BroadCastManager } from '../model/common/BroadCastManager';
import lazy { BroadCast } from '../utils/BroadCast';
import lazy { BroadCastConstants } from '../model/common/BroadCastConstants';
import lazy { DeviceInfo as DeviceInfoCommon } from '../utils/DeviceInfo';

/* instrument ignore file */
const TAG = 'WallpaperEditorComponent';

@Builder
export function WallpaperEditorLoader($$: WallpaperEditorLoaderParams) {
  WallpaperEditorComponent({
    navPageInfos: $$.navPageInfos,
  });
}

export interface WallpaperEditorLoaderParams {
  navPageInfos: NavPathStack;
}

interface SetWallpaperParams {
  imageUri: string,
  lcdUri: string,
  pixelMap: PixelMap | undefined,
}

@Component
export struct WallpaperEditorComponent {
  // 因为壁纸编辑加载完缩略图后，上屏存在延迟。增加延时避免屏闪
  static readonly LOAD_WALLPAPER_EDITOR_DELAY: number = 300;
  static readonly THUMBNAIL_SCALE: number = 1;
  private navPageInfos: NavPathStack = new NavPathStack();
  private imageUri: string = '';
  private lcdUri: string = '';
  @State pixelMap: PixelMap | undefined = undefined;
  @State private isLoading: boolean = true;
  private readonly onWindowChangedFunc: Function = (): void => this.updateUi();
  private hdrDelayTime: number = 600;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  public timerForHdr: number = 0;
  private hasBeenPopped: boolean = false;
  @StorageLink('windowStatus') @Watch('onWindowStatusChange') windowStatus: window.WindowStatusType =
    window.WindowStatusType.FULL_SCREEN;

  build() {
    NavDestination() {
      Stack() {
        UIExtensionComponent({
          bundleName: 'com.ohos.sceneboard',
          abilityName: 'ThemeComponentExtAbility',
          parameters: {
            'ability.want.params.uiExtensionType': 'sys/commonUI',
            'nav': 'wallpaperEditor',
            'source': 'com.ohos.photos',
            'imageAesthetic': true,
            'imageUrl': this.imageUri,
          },
          flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
          uri: this.imageUri,
        })
          .defaultFocus(true)
          .width('100%')
          .height('100%')
          .onError((error) => {
            Log.error(TAG, `UIExtensionComponent onError ${JSON.stringify(error)}`)
          })
          .onReceive(this.onReceiveSCBData)

        if (this.isLoading) {
          Image(this.pixelMap ?? this.lcdUri)
            .width('100%')
            .height('100%')
            .scale({ x: WallpaperEditorComponent.THUMBNAIL_SCALE, y: WallpaperEditorComponent.THUMBNAIL_SCALE })
        }
      }
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor(Color.Black)
    .onReady((ctx: NavDestinationContext) => {
      let params: SetWallpaperParams = ctx?.pathInfo?.param as SetWallpaperParams;
      this.imageUri = params.imageUri;
      this.lcdUri = params.lcdUri;
      this.pixelMap = params.pixelMap;
    })
    .onWillAppear((): void => {
      this.updateUi();
      getScreen().setIsInImmersivePage(true);
    })
    .onWillDisappear(() => {
      getScreen().setIsInImmersivePage(false);
      getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onWindowChangedFunc);
      getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowChangedFunc);
      this.resetUi();
    })
  }

  aboutToAppear(): void {
    AppStorage.setOrCreate<boolean>('isEditingWallpaper', true);
    getScreen().on(ScreenManager.ON_ORIENTATION_CHANGED, this.onWindowChangedFunc);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowChangedFunc);
    /* instrument ignore next */
    if (DeviceInfo.isFoldablePhone()) {
      try {
        display.on('foldStatusChange', this.onFoldStatusChange);
      } catch (err) {
        Log.error(TAG, `foldStatusChange display.on, error code : ${err.code}`)
      }
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'wallpaper abouttodisappear');
    AppStorage.setOrCreate<boolean>('isEditingWallpaper', false);
    getScreen().off(ScreenManager.ON_ORIENTATION_CHANGED, this.onWindowChangedFunc);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowChangedFunc);
    /* instrument ignore next */
    if (DeviceInfo.isFoldablePhone()) {
      try {
        display.off('foldStatusChange', this.onFoldStatusChange);
      } catch (err) {
        Log.error(TAG, `foldStatusChange display.off, error code : ${err.code}`)
      }
    }
    if (!this.hasBeenPopped) {
      this.appBroadCast.emit(BroadCastConstants.CAST_START_ABILITY, []);
      this.appBroadCast.emit(BroadCastConstants.SHOW_WALLPAPER, [false]);
    }
  }

  private onReceiveSCBData: (data: object) => void = (data: object) => {
    Log.info(TAG, 'SCB UIExtension onReceive');
    if (data && data['back'] !== undefined) {
      this.navPageInfos.pop(this.imageUri);
      this.hasBeenPopped = true;
    }
    if (data && data['thumbnailSuccess'] !== undefined) {
      setTimeout((): void => {
        this.isLoading = false;
        this.pixelMap = undefined;
      }, WallpaperEditorComponent.LOAD_WALLPAPER_EDITOR_DELAY);
    }
  }

  private updateUi(): void {
    if (WallpaperEditorComponent.shouldBlockWallpaperEdit()) {
      if (!DeviceInfo.isVerdeFoldable()) {
        UiUtil.showToast($r('app.string.not_support_wallpaper_edit'));
      }
      this.navPageInfos.pop();
      return;
    }
    let mode = power.getPowerMode();
    if (mode === power.DevicePowerMode.MODE_CUSTOM_POWER_SAVE) {
      Log.info(TAG, 'MODE_CUSTOM_POWER_SAVE');
      UiUtil.showToast($r('app.string.not_support_wallpaper_change'));
      this.navPageInfos.pop();
      return;
    }

    if (DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) {
      WindowUtil.setOrientation(window.Orientation.PORTRAIT);
    }
    getScreen().setSystemUi(false);
  }

  private resetUi(): void {
    const context = LocalStorage.getShared()?.get<common.UIAbilityContext>('photosAbilityContext');
    if (context) {
      let browserOrientation = window.Orientation.AUTO_ROTATION_UNSPECIFIED;
      WindowUtil.setOrientation(browserOrientation);
    } else {
      WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    }
    getScreen().setSystemUi(true);
  }

  private onFoldStatusChange: Callback<display.FoldStatus> = (status: display.FoldStatus) => {
    if (status === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      WindowUtil.setOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    }
  };

  public static shouldBlockWallpaperEdit(): boolean {
    const isDesktop = DeviceInfo.isPcOrTablet();
    let winStatus = window.WindowStatusType.FULL_SCREEN;
    if (canIUse("SystemCapability.Window.SessionManager")) {
      winStatus = ScreenManager.getInstance().getMainWindow()?.getWindowStatus();
    }
    const isFullscreen = DeviceInfo.isPhoneVde() ? AppStorage.get('windowStatus') ===
      window.WindowStatusType.FULL_SCREEN : getScreen().getWinMode() === WindowMode.FULLSCREEN ;
    const isMobileNotFullscreen = !isDesktop && !isFullscreen;
    // const isDesktopNotFullscreenMode = isDesktop && winStatus !== window.WindowStatusType.FULL_SCREEN;
    // Log.info(TAG, `shouldBlockWallpaperEdit isDesktop:${isDesktop} isMobileNotFullscreen:${isMobileNotFullscreen} isDesktopNotFullscreenMode:${isDesktopNotFullscreenMode}`);
    Log.info(TAG, `shouldBlockWallpaperEdit isDesktop:${isDesktop} isMobileNotFullscreen:${isMobileNotFullscreen}`);
    if (isMobileNotFullscreen) {
    //   return true;
    // } else if (isDesktopNotFullscreenMode) {
      return true;
    }
    return false;
  }

  onWindowStatusChange(changedPropertyName: string) {
    this.updateUi();
  }
}
