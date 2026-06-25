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

import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy {
  MoveOrCopyBroadCastProp
} from '@ohos/common/src/main/ets/default/view/browserOperation/MoveOrCopyBroadCastProp';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { SelectManager, ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { ThirdSelectPhotoBrowserBase } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoBrowserBase';
import lazy { ThirdSelectPhotoGridBase } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { PickerSelectTipToast } from '@ohos/thirdselect/src/main/ets/default/view/PickerSelectTipToast';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { display } from '@kit.ArkUI';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { image } from '@kit.ImageKit';
import lazy { clearAnimatePlayHistory } from '@ohos/thirdselect/src/main/ets/default/view/PickerSelectTip'
import lazy { FromBaseInfo } from '@ohos/thirdselect/src/main/ets/default/view/PickerCloseButton';

// instrument ignore file
const TAG: string = 'PickerBasePage';
const ACCESSIBILITY_FOCUS_DELAY: number = 350;

@Builder
export function PickerBasePageLoader($$: PickerBasePageParams) {
  PickerBasePage({
    param: $$.params,
    navPageInfos: $$.navPageInfos,
  });
}

export interface PickerBasePageParams {
  params: SelectParams,
  navPageInfos: NavPathStack,
}

let storage: LocalStorage = LocalStorage.getShared();

// Picker Page
@Entry(storage)
@Component
export struct PickerBasePage {
  private navPageInfos: NavPathStack = new NavPathStack();
  // 页面状态
  @State pageStatus: boolean = false;
  @Provide albumId: string = '';
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  @State isRunningAnimation: boolean = false;
  // 是否展示大图
  @State isBrowserShow: boolean = false;
  private onBackFunc: Function | null = null;
  // 广播
  @Provide broadCast: BroadCast = new BroadCast();
  private mSelectManager = new ThirdSelectManager();
  // 当前相册uri
  private currentAlbumUri: string = '';
  private newAlbumName: string = '';
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  // 设备朝向
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('onFoldDisplayModeChanged') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State private isShowPickerSelectTip: boolean = false;
  private param: SelectParams = new SelectParams();
  @Provide isSelectedMode: boolean = true;
  @State actionBarController: ActionBarController = new ActionBarController();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  @State private isSheetShow: boolean = true;
  private footerNavigationHeight: number = 28;
  private pickerActionBarHeight: number = 72;
  private pickerPanelHeight: number = 52;
  private updateSheetStateFun: Function = (isSheetShow: boolean): void => this.updateSheetState(isSheetShow);
  @State private searchKeyword: string = '';
  @State private isFromFa: boolean = false;
  private isPhotoInner: boolean = true;
  private sharedStorage = this.getUIContext().getSharedLocalStorage();

  /* instrument ignore next */
  onFinishPickerOperation(albumInfo: AlbumInfo): void {
    let isNewAlbum: boolean | undefined = AppStorage.get<boolean>(Constants.APP_KEY_NEW_ALBUM);
    AppStorage.setOrCreate<boolean>(Constants.APP_KEY_NEW_ALBUM, false);
    AppStorage.delete(Constants.APP_KEY_NEW_ALBUM);
    let selectManager: SelectManager |
    undefined = AppStorage.get<SelectManager>(Constants.APP_KEY_NEW_ALBUM_SELECTED);
    Log.info(TAG, `onPickerOperation, isNewAlbum=${isNewAlbum}`);
    selectManager?.onModeChange(false);
    if (isNewAlbum) {
      this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_NEW_ALBUM,
        [JSON.stringify(albumInfo)]);
    } else {
      this.navigationBroadCast
        .emit(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_EXIST_ALBUM, []);
    }
    if (this.param.isFromAlbumSetPage) {
      this.navPageInfos?.pop();
    }

    this.clearAppStorage();
  }

  // 窗口大小变更触发函数
  private onWindowSizeChangedFunc: Function = (): void => this.onWindowSizeChanged();
  @State private bindSheetHeight: Length | SheetSize = 0;

  aboutToAppear(): void {
    Log.info(TAG, `PickerPageAboutToAppear${JSON.stringify(this.param)}`);
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
    this.getUIContext().getSharedLocalStorage()?.setOrCreate<FromBaseInfo>('FromBaseInfo',
      new FromBaseInfo(true, (isFromCustomCloseButton?: boolean) => {
        this.cancelFunc(isFromCustomCloseButton);
      }));
    if (this.param) {
      this.newAlbumName = this.param.albumName;
      this.currentAlbumUri = this.param.albumUri;
      this.param.isNeedSelectBar = true;
      this.param.isFromPickerView = false;
      if (this.param.isNewAlbum) {
        AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM, true);
      } else {
        AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM, false);
      }
      this.isFromFa = this.param?.isFromFa ? true : false;
      if (this.isFromFa) {
        this.isPhotoInner = false;
      }
    }
    if (this.isVerdeFoldable) {
      this.isShowPickerSelectTip = true;
      setTimeout((): void => {
        this.isShowPickerSelectTip = false;
      }, Constants.DELAY_THREE_SECOND);
    }
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SOURCE, Constants.APP_NEW_ALBUM_SOURCE_PICKER);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET, this.newAlbumName);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_TARGET_URI, this.currentAlbumUri);
    AppStorage.setOrCreate(Constants.APP_KEY_NEW_ALBUM_SELECTED, this.mSelectManager);
    LocalStorage.getShared()?.setOrCreate(Constants.THIRD_SELECT_MANAGER, this.mSelectManager);
    LocalStorage.getShared()?.setOrCreate(Constants.PHOTO_PICKER_FROM_PHOTOS, true);
    LocalStorage.getShared()?.setOrCreate<boolean>('isBrowserShow', false);
    this.broadCast.on(Constants.UPDATE_SHEET_STATE, this.updateSheetStateFun);
    this.broadCast.on(BroadCastConstants.FINISH_PICKER_OPERATION, (albumInfo: AlbumInfo): void => {
      this.onFinishPickerOperation(albumInfo);
    });
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
    if (this.sharedStorage) {
      clearAnimatePlayHistory(this.sharedStorage)
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'PickerPageAboutToDisappear');
    this.actionBarController?.release();
    this.broadCast.emit(BroadCastConstants.PICKER_PAGE_DISAPPEAR, []);
    this.broadCast.off(Constants.UPDATE_SHEET_STATE, this.updateSheetStateFun);
    this.broadCast.off(BroadCastConstants.FINISH_PICKER_OPERATION, (albumInfo: AlbumInfo): void => {
      this.onFinishPickerOperation(albumInfo);
    });
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
    this.getUIContext().getSharedLocalStorage()?.delete('FromBaseInfo');
    LocalStorage.getShared()?.setOrCreate(Constants.PHOTO_PICKER_FROM_PHOTOS, false);
    LocalStorage.getShared()?.delete('isBrowserShow');
    storage.delete(BroadCastConstants.UPDATE_IS_PICKER_SPLIT_SCREEN);
    storage.delete(BroadCastConstants.UPDATE_IMAGE_HEIGHT);
    storage.delete(BroadCastConstants.UPDATE_STACK_HEIGHT);
  }

  private updateSheetState(isSheetShow: boolean) {
    this.isSheetShow = isSheetShow;
  }

  // 窗口大小变化
  private onWindowSizeChanged(): void {
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
  }

  onPageShow(): void {
    this.pageStatus = true;
  }

  onPageHide(): void {
    this.pageStatus = false;
  }

  /* instrument ignore next */
  onBackPress(): boolean | undefined {
    if (this.browserController.isBrowserShow) {
      this.browserController.browserBackFunc?.();
      return true;
    }
    if (this.onBackFunc !== null) {
      this.onBackFunc();
      return true;
    }

    return undefined;
  }

  bindBackFunc(backFunc: Function): void {
    this.onBackFunc = backFunc;
  }

  private cancelFunc(isFromCustomCloseButton?: boolean): void {
    Log.info(TAG, 'cancelFunc');
    this.clearAppStorage();
    Log.info(TAG, `cancelFunc navPageInfos size: ${this.navPageInfos.size()}`)
    const pathName: string[] = this.navPageInfos.getAllPathName();
    let hasPickerBasePageBeforeImmersiveOrCollage = this.hasPickerBasePageBeforeImmersiveOrCollage(pathName);
    if (hasPickerBasePageBeforeImmersiveOrCollage && !isFromCustomCloseButton) {
      Log.info(TAG, 'cancelFunc hasPickerBasePageBeforeImmersiveOrCollage return')
      return;
    }
    Log.info(TAG, `isSpecialPage is ${this.isSpecialPage()}`)
    // TODO 暂时全部通知
    // if (!this.isSpecialPage()) {
    //   this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, []);
    // }
    this.navigationBroadCast.emit(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK, []);
    if (isFromCustomCloseButton) {
      this.updateSheetState(false);
      if (this.isSpecialPage()) {
        this.navPageInfos?.pop();
      }
    }
  }

  private hasPickerBasePageBeforeImmersiveOrCollage(pages: string[]): boolean {
    const index = pages.indexOf('PickerBasePage');
    if (index === -1 || index === 0) {
      // 如果数组中不存在'PickerBasePage'，或者'PickerBasePage'是第一个元素，直接返回false
      return false;
    }
    const prevPage = pages[index - 1];
    return this.param.isHighlightPickerView;
  }

  // 清空app存储变量
  private clearAppStorage(): void {
    if (AppStorage.get<boolean>(Constants.APP_KEY_NEW_ALBUM)) {
      AppStorage.setOrCreate<boolean>(Constants.APP_KEY_NEW_ALBUM, false);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_TARGET_URI);
      AppStorage.delete(Constants.APP_KEY_NEW_ALBUM_SELECTED);
      LocalStorage.getShared()?.delete(Constants.THIRD_SELECT_MANAGER);
    }
  }

  /* instrument ignore next */
  private okFunc(): void {
    Log.info(TAG, 'okFunc');
    if (this.mSelectManager.isPreview) {
      this.mSelectManager.isPreview = false;
      this.mSelectManager.clickedSet.clear();

      this.mSelectManager.previewSet.forEach(
        (value: string) => {
          this.mSelectManager.clickedSet.add(value);
        });
    }
    MoveOrCopyBroadCastProp.getInstance().doAddOperation(this.broadCast);
  }

  // 图库拉起picker，横竖屏切换顶部需避让状态栏
  private bindSheetStatusBarHeight(): Length | SheetSize {
    if (!this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() && !getScreen().isSplitMode()) {
      // 底部弹窗距离信号栏为8vp
      return getScreen().getWinHeight() - getScreen().getStatusBarHeight() - 8;
    }
    return SheetSize.LARGE;
  }

  private isSpecialPage():boolean {
    let navPathNames: string[] = this.navPageInfos.getAllPathName();
    return (!navPathNames.includes(NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW));
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        this.buildSheetContainer();
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .id('modalRoot')
      .key('modalRoot')
      .width('100%')
      .height('100%')
    }.title('PickerBasePage')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }

  @Builder
  buildSheetContainer() {
    Stack() {
      CustomDialogView({ broadCast: $broadCast });
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      //判断当前是否是三分之一分屏模式,px2vp(display.getDefaultDisplaySync().height):转化为vp的屏幕高度,为false代表当前是三分之一屏
      let isPickerSplitScreen = Number(newValue.height) / px2vp(display.getDefaultDisplaySync().height) > 0.4;
      storage.setOrCreate(BroadCastConstants.UPDATE_IS_PICKER_SPLIT_SCREEN, isPickerSplitScreen);
      Log.info(TAG, `pickerAreaRatio: ${isPickerSplitScreen}`);
    })
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .bindSheet($$this.isSheetShow, this.buildPickerContent(), {
      showClose: !DeviceInfo.isPhoneOrTablet(),
      preferType: SheetType.CENTER,
      backgroundColor: $r('sys.color.ohos_id_color_panel_bg'),
      height: this.isVerdeFoldable ? SheetSize.LARGE : this.bindSheetHeight,
      onWillAppear: () => {
        performanceMonitor.begin('CUSTOM_ANIMATOR bindSheet', performanceMonitor?.ActionType.LAST_UP);
      },
      onAppear: () => {
        performanceMonitor.end('CUSTOM_ANIMATOR bindSheet');
        Log.info(TAG, 'onAppear SheetContainer, height: ' +
          `${ScreenManager.getInstance().getWinHeight() - ScreenManager.getInstance().getStatusBarHeight()}`);
      },
      onDisappear: () => {
        Log.info(TAG, 'onDisappear SheetContainer');
      },
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        Log.info(TAG, 'bind sheet onWillDismiss');
        if (this.browserController.isBrowserShow &&
          dismissSheetAction.reason == DismissReason.PRESS_BACK) {
          this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
          return;
        }
        this.cancelFunc();
        if (this.isSpecialPage()) {
          this.navPageInfos?.pop();
        }
        dismissSheetAction.dismiss();
      }),
      onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
        //没有注册springBack, 下拉半模态页面无回弹行为
      }),
    })
  }

  @Builder
  buildPickerContent() {
    Stack({ alignContent: Alignment.Bottom }) {
      this.buildGridContent();
      if (this.browserController.isBrowserShow) {
        this.buildBrowserContent();
      }
      if (this.isVerdeFoldable && this.isShowPickerSelectTip) {
        Column() {
          PickerSelectTipToast()
        }
        .margin({
          bottom: Constants.PICKER_SELECT_TIP_BOTTOM,
        });
      }
    }
    //防止子组件手势冲突
    .parallelGesture(
      GestureGroup(GestureMode.Exclusive,
        PanGesture()
      )
    )
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      /**
       * 单选模式下:获取半模态的高度减去buildActionBar:72vp,ThirdSelectedPanel内buildOriginButton容器高52,
       * 以及PickerSelectTip的高28vp和距离底部的28vp
       */
      const totalBarHeight: number = this.pickerActionBarHeight + this.pickerPanelHeight +
        this.footerNavigationHeight * 2;
      const imageDisplayHeight: number = Number(newValue.height) - totalBarHeight;
      const areaRatio: number = ImageUtil.calcRatio({
        width: newValue.width,
        height: imageDisplayHeight,
      } as image.Size);
      const maxImageHeight = Number(newValue.height) - this.pickerActionBarHeight - this.footerNavigationHeight * 2;
      LocalStorage.getShared().setOrCreate(BroadCastConstants.UPDATE_PICKER_IMAGE_DISPLAY_HEIGHT, areaRatio);
      LocalStorage.getShared().setOrCreate(BroadCastConstants.UPDATE_IMAGE_HEIGHT, maxImageHeight);
      LocalStorage.getShared().setOrCreate(BroadCastConstants.UPDATE_STACK_HEIGHT, Number(newValue.height));
      Log.info(TAG, `onRootAreaChange: ${newValue.width}, ${newValue.height}, ${imageDisplayHeight}, ${areaRatio}`);
    })
  }

  @Builder
  buildGridContent() {
    Column() {
      ThirdSelectPhotoGridBase({
        pageStatus: this.pageStatus,
        backFuncBinder: (backFunc: Function): void => {
          this.bindBackFunc(backFunc);
        },
        browserController: this.browserController,
        selectManager: this.mSelectManager,
        isPhotoInner: this.isPhotoInner,
        cancelFunc: (): void => {
          this.cancelFunc();
        },
        okFunc: (): void => {
          this.okFunc();
        },
        isNeedFilterSourceAlbum: true,
        sourceAlbumUri: this.currentAlbumUri,
        isSetOriginal: true,
        param: this.param,
        actionBarController: this.actionBarController,
        isSearchEnabled: false,
        navPageInfos: this.navPageInfos,
        searchKeyword: this.searchKeyword,
      })
        .margin({
          left: this.isHorizontal ? 0 : getScreen()
            .getLeftSafePadding($r('sys.float.ohos_id_card_margin_start'), false),
          right: this.isHorizontal ?
            0 : getScreen().getRightSafePadding($r('sys.float.ohos_id_card_margin_end'), false)
        })
        .transition({ type: TransitionType.All, opacity: 0 });
    }
  }

  @Builder
  /* instrument ignore next */
  buildBrowserContent() {
    Stack() {
      ThirdSelectPhotoBrowserBase({
        pageStatus: this.pageStatus,
        geometryTransitionEnable: this.browserController.geometryTransitionEnable,
        isRunningAnimation: $isRunningAnimation,
        browserController: this.browserController,
        canEditVideo: true,
        isPhotoInner: this.isPhotoInner,
        okFunc: (): void => {
          this.okFunc();
        },
        cancelFunc: (): void => {
          this.cancelFunc();
        },
        isSetOriginal: true,
        navPageInfos: this.navPageInfos,
      })
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      let maxImageHeight = Number(newValue.height) - this.pickerActionBarHeight - this.footerNavigationHeight * 2;
      storage.setOrCreate(BroadCastConstants.UPDATE_IMAGE_HEIGHT, maxImageHeight);
      storage.setOrCreate(BroadCastConstants.UPDATE_STACK_HEIGHT, Number(newValue.height));
    })
    // Opacity must change for TransitionEffect taking effect
    .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
    .enabled(!this.browserController.isAnimating)
  }

  /* instrument ignore next */
  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
  }

  /**
   * @Watch browserController勿删
   */
  /* instrument ignore next */
  private updateAnimationStatus(): void {
    if (this.isRunningAnimation !== this.browserController.isAnimating) {
      this.isRunningAnimation = this.browserController.isAnimating;
    }
    if (this.isBrowserShow !== this.browserController.isBrowserShow) {
      this.isBrowserShow = this.browserController.isBrowserShow;
    }
  }

  private onFoldDisplayModeChanged(): void {
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
  }
}
