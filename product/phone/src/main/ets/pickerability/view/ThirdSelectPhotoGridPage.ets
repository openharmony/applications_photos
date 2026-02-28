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

import lazy { ThirdSelectPhotoGridBase } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy common from '@ohos.app.ability.common';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { ThirdSelectBrowserParams } from './ThirdSelectBrowserParams';
import lazy {
  ThirdSelectGridController,
  ThirdSelectGridListener
} from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BurstPhotoUtils } from '@ohos/common/src/main/ets/default/utils/BurstPhotoUtils';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy ability from '@ohos.ability.ability';
import lazy { THIRD_SELECT_IS_ORIGIN } from '@ohos/thirdselect/src/main/ets/default/utils/ThirdSelectConstants';

const PICKER_VIEW_TOAST_SAFETY_DISTANCE: number = 64;

/* instrument ignore file */
const TAG: string = 'ThirdSelectPhotoGridPage';

let storage = LocalStorage.getShared();

// Third Select Album Page
@Entry(storage)
@Component
export struct ThirdSelectPhotoGridPage {
  private navPageInfos: NavPathStack = new NavPathStack();
  @Provide pageStatus: boolean = false;
  @Provide albumId: string = '';
  @Provide @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  private onBackFunc: Function = (): void => {
  };
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isSelectedMode: boolean = true;
  @Provide isShow: boolean = true;
  param: SelectParams = new SelectParams();
  // 是否横屏
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @Provide displaySearchWords: string = '';
  @State isCompareTip: boolean = true;
  @State actionBarController: ActionBarController = new ActionBarController();
  @State isBrowserShow: boolean = false;
  private updateShoeCloseFun: Function = (showClose: boolean): void => this.updateShoeCloseStatue(showClose);
  private updateSheetStateFun: Function = (isSheetShow: boolean): void => this.updateSheetState(isSheetShow);
  @State showClose: boolean = true;
  @BuilderParam selectBrowserLoader: ($$: ThirdSelectBrowserParams) => void;
  @State private isSheetShow: boolean = true;
  // 合一编辑器场景默认避让的摄像头高度
  private defaultCameraHeight: number = 38;
  // bindSheet默认的避让高度，参考半模态转场说明
  private defaultAvoidHeight: number = 8;
  private onWindowSizeChangedFunc: Function = (): void => this.onWindowSizeChanged();
  @State private bindSheetHeight: Length | SheetSize = 0;
  @State private searchKeyword: string = '';
  @State private thirdSelectGridController: ThirdSelectGridController = new ThirdSelectGridController();
  private readonly thirdSelectGridListener: ThirdSelectGridListener = {
    onCompleted: (items: MediaItem[]) => this.onThirdSelectComplete(items),
    onCompletedWithUris: (uris: string[]) => this.onThirdSelectCompleteWithUris(uris),
    onCancelled: (): void => this.onThirdSelectCancel(),
  } as ThirdSelectGridListener;

  private async onThirdSelectComplete(items: MediaItem[]): Promise<void> {
    Log.info(TAG, 'onThirdSelectComplete');
    this.isSheetShow = false;
    if (items && items.length === 0) {
      setTimeout((): void => {
        let context: common.UIAbilityContext =
          LocalStorage.getShared().get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
        context?.terminateSelf();
      }, 100);
    } else {
      let uris = await BurstPhotoUtils.getBurstUris(items);
      this.onThirdSelectCompleteWithUris(uris);
    }
  }

  private async onThirdSelectCompleteWithUris(uris: string[]): Promise<void> {
    this.isSheetShow = false;
    Log.info(TAG, 'onThirdSelectCompleteWithUris terminate');
    let result: number | undefined =
      await PhotoAccessHelperAccess.grantPermissionForUris(getContext(), this.param?.tokenId, uris);
    Log.info(TAG, `grantPermissionForUris, uris size:${uris?.length}, result is: ${result}`);
    let isOrigin: boolean = LocalStorage.getShared()?.get<boolean>(THIRD_SELECT_IS_ORIGIN) ?? false;
    let abilityResult = {
      resultCode: uris ? 0 : -1,
      want: {
        flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
        parameters: {
          'ability.params.stream': uris as Object,
          'select-item-list': uris as Object,
          isOriginal: isOrigin,
        }
      }
    } as ability.AbilityResult;
    setTimeout((): void => {
      let context: common.UIAbilityContext =
        LocalStorage.getShared().get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    }, 100);
  }

  private onThirdSelectCancel() {
    Log.info(TAG, 'onThirdSelectCancel');
    this.isSheetShow = false;
    setTimeout((): void => {
      let context: common.UIAbilityContext =
        LocalStorage.getShared().get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context?.terminateSelf().then((result: void) => {
        Log.info(TAG, 'terminateSelfWithResult for handleBindSheetDisappear');
      });
    }, 100)
  }

  async aboutToAppear() {
    Log.info(TAG, 'ThirdSelectPhotoGridPage aboutToAppear');
    LocalStorage.getShared().setOrCreate<string>('geometryTransitionBrowserId', '');
    let params = tryGetRouterParam() as SelectParams;
    if (params) {
      this.param = params;
    }
    Log.info(TAG, `ThirdSelectPhotoGridPageAboutToAppear param: ${JSON.stringify(this.param)}`);
    this.isCompareTip = await DataStoreUtil.getInstance().getData(Constants.IS_CLOSE_COMPARE_TIP, true) as boolean;
    this.broadCast.on(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, this.updateShoeCloseFun);
    this.broadCast.on(Constants.UPDATE_SHEET_STATE, this.updateSheetStateFun);
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
    this.thirdSelectGridController.hasDelegate = true;
    this.thirdSelectGridController.register(this.thirdSelectGridListener);
  }

  aboutToDisappear() {
    Log.info(TAG, 'ThirdSelectPhotoGridPage aboutToDisappear');
    this.broadCast.off(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, this.updateShoeCloseFun);
    this.broadCast.off(Constants.UPDATE_SHEET_STATE, this.updateSheetStateFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
  }

  private onWindowSizeChanged(): void {
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
  }

  onPageShow() {
    this.pageStatus = true;
    LocalStorage.getShared().setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
  }

  onPageHide() {
    this.pageStatus = false;
    LocalStorage.getShared().setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);
  }

  onBackPress() {
    if (this.browserController.isBrowserShow) {
      this.browserController.browserBackFunc?.();
      return true;
    }
    if (this.onBackFunc) {
      this.onBackFunc();
      return !this.param?.isFromPickerView;
    }
    return false;
  }

  private updateShoeCloseStatue(showClose: boolean) {
    this.showClose = showClose;
  }

  private updateSheetState(isSheetShow: boolean) {
    this.isSheetShow = isSheetShow;
  }

  private bindSheetStatusBarHeight(): Length | SheetSize {
    if (!this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable()) {
      // 适配合一编辑器场景，避让摄像头
      if (this.param.bundleName === 'com.ohos.sceneboard') {
        // 底部弹窗距离信号栏为8vp
        return getScreen().getWinHeight() - this.defaultCameraHeight - this.defaultAvoidHeight;
      }
      // 适配其他场景，避让摄像头
      const relativePos = getScreen().calcActualArea();
      return getScreen().getWinHeight() - relativePos.top - this.defaultAvoidHeight;
    }
    return SheetSize.LARGE;
  }

  bindBackFunc(backFunc: Function): void {
    this.onBackFunc = backFunc;
  }

  private bindSheetOnWillDismiss(dismissSheetAction: DismissSheetAction): boolean {
    if (this.browserController.isBrowserShow &&
      dismissSheetAction.reason == DismissReason.PRESS_BACK) {
      this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
      return true;
    }
    return false;
  }

  @Builder
  PickerContents() {
    Stack() {
      Column() {
        ThirdSelectPhotoGridBase({
          pageStatus: this.pageStatus,
          backFuncBinder: (backFunc: Function): void => this.bindBackFunc(backFunc),
          browserController: this.browserController,
          param: this.param,
          actionBarController: this.actionBarController,
          navPageInfos: this.navPageInfos,
          searchKeyword: this.searchKeyword,
          controller: this.thirdSelectGridController,
        })
          .transition({ type: TransitionType.All, opacity: 0 })
          .onAppear((): void => {
            Log.info(TAG, 'ThirdSelectPhotoGridBase onAppear');
          })
      }
      .enabled(!this.browserController.isAnimating)

      if (this.isBrowserShow) {
        this.selectBrowserLoader({
          replaceUriManager: undefined,
          broadCast: this.broadCast,
          pageStatus: this.pageStatus,
          browserController: this.browserController,
          thirdSelectController: this.thirdSelectGridController,
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
    .margin({
      left: this.isHorizontal || this.browserController.isBrowserShow ? 0 : getScreen()
        .getLeftSafePadding($r('sys.float.ohos_id_card_margin_start'), false),
      right: this.isHorizontal || this.browserController.isBrowserShow ? 0 : getScreen()
        .getRightSafePadding($r('sys.float.ohos_id_card_margin_end'), false)
    })
  }

  @Builder
  SheetContainer() {
    Stack() {
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .bindSheet($$this.isSheetShow, this.PickerContents(), {
      showClose: this.showClose && !(DeviceInfo.isPhone() || DeviceInfo.isTablet()),
      preferType: SheetType.CENTER,
      backgroundColor: $r('sys.color.ohos_id_color_panel_bg'),
      height: this.bindSheetHeight,
      onAppear: () => {
        Log.info(TAG, `onAppear height: ${ScreenManager.getInstance().getWinHeight() - ScreenManager.getInstance()
          .getStatusBarHeight()},` + `the Screen Height is ${ScreenManager.getInstance().getWinHeight()},` +
          `the Screen Width is ${ScreenManager.getInstance().getWinWidth()}`);
      },
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        Log.info(TAG, 'bind sheet onWillDismiss');
        if (this.bindSheetOnWillDismiss(dismissSheetAction)) {
          return;
        }
        dismissSheetAction.dismiss();
        setTimeout((): void => {
          let context: common.UIAbilityContext =
            LocalStorage.getShared().get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
          context?.terminateSelf().then((result: void) => {
            Log.info(TAG, 'terminateSelfWithResult for handleBindSheetDisappear');
          });
        }, 100)
      }),
      onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
        //没有注册springBack, 下拉半模态页面无回弹行为
      }),
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.param.isFromPickerView) {
        this.PickerContents();
      } else {
        this.SheetContainer();
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .id('modalRoot')
    .onAppear((): void => {
      Log.info(TAG, 'onRootAppear');
      this.isSheetShow = true;
    })
    .onAreaChange((): void => {
      Log.info(TAG, 'onRootAreaChange');
    })
    .width('100%')
    .height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
    PageTransitionExit({ type: RouteType.Push, duration: BrowserConstants.PHOTO_GRID_ANIMATION_DURATION })
      .opacity(1)
  }

  /**
   * @Watch browserController
   */
  private updateAnimationStatus(): void {
    this.loadBrowserComponent();
  }

  private async loadBrowserComponent(): Promise<void> {
    try {
      let loader = await import('./ThirdSelectBrowserViewLoader');
      this.selectBrowserLoader = loader.ThirdSelectBrowserViewLoader;
      this.isBrowserShow = this.browserController.isBrowserShow;
    } catch (error) {
      Log.error(TAG, `loadBrowserComponent error: ${error}`);
    }
  }
}