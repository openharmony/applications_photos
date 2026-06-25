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

import lazy {
  ThirdSelectGridController,
  ThirdSelectPhotoGridBase
} from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { getScreen, isOrientationHorizontal, } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { BreakpointSystem } from '@ohos/common/src/main/ets/default/utils/BreakPointSystem';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { AppPresenceStatus, PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { ThirdSelectBrowserParams } from './ThirdSelectBrowserParams';
import lazy { PickerViewWarningToast } from '@ohos/common/src/main/ets/default/view/dialog/PickerViewWarningToast';
import lazy { common } from '@kit.AbilityKit';
import lazy { PickerOrientation } from '@ohos.file.PhotoPickerComponent';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { PickerMediaDataSource } from '@ohos/thirdselect/src/main/ets/default/common/PickerMediaDataSource';
import lazy { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';

/* instrument ignore file */
const TAG: string = 'PickerSheetContent';
const PICKER_VIEW_TOAST_SAFETY_DISTANCE: number = 62;
const SINGLE_LINE_MODE_PICKER_VIEW_TOAST_DY: number = -8;

@Component
export struct PickerSheetContent {
  private replaceUriManager: ReplaceUriManager = new ReplaceUriManager();
  @Prop private pageStatus: boolean = false;
  @State @Watch('updateAnimationStatus') private browserController: BrowserController = new BrowserController(true);
  @Provide private broadCast: BroadCast = new BroadCast();
  @Provide private isImmersiveCompared: boolean = false;
  @Provide private ifCollagePageEnter: boolean = false;
  @Provide private isSelectedMode: boolean = true;
  @Provide private isShow: boolean = true;
  @StorageLink('isHorizontal') private isHorizontal: boolean = isOrientationHorizontal();
  @Provide private displaySearchWords: string = '';
  @State private actionBarController: ActionBarController = new ActionBarController();
  @State private isBrowserShow: boolean = false;
  @State private thirdSelectGridController: ThirdSelectGridController = new ThirdSelectGridController();
  @BuilderParam selectBrowserLoader: ($$: ThirdSelectBrowserParams) => void;
  private param: SelectParams = new SelectParams();
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  private storage: LocalStorage = LocalStorage.getShared();
  private backFuncBinder: Function | undefined = undefined;
  private isToastShowed: boolean = false;
  private toastController?: CustomDialogController;
  @Link private searchKeyword: string;
  private isPhotoBrowserLoad: boolean = false;
  private photoDataImpl: PhotoDataImpl | undefined;
  private dataSource: PickerMediaDataSource | undefined;
  private networkConnectionStatus: boolean = true;
  private navigationHeightFunc: Function = (navigationHeight: number): void => {

    this.buildPickerViewToast(navigationHeight);
  };
  private disableScrollToAnchorFunc: Function = (): void => {
    this.disableScrollToAnchor();
  };

  aboutToAppear() {
    Log.info(TAG, 'PickerSheetContent aboutToAppear');
    LocalStorage.getShared()?.setOrCreate<string>('geometryTransitionBrowserId', '');
    if (this.storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.param = this.storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    }
    LocalStorage.getShared()?.setOrCreate(Constants.PHOTO_PICKER_FROM_PHOTOS,
      this.isImmersiveCompared || this.ifCollagePageEnter);
    Log.info(TAG, `PickerSheetContent AboutToAppear param: ${JSON.stringify(this.param)}`);
    if (this.storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.breakpointSystem.registerOrientationChange();
    }
    this.broadCast.on(Constants.UPDATE_NAVIGATION_HEIGHT, this.navigationHeightFunc);
    this.broadCast.on(Constants.DISABLE_SCROLL_TO_ANCHOR, this.disableScrollToAnchorFunc);
  }

  aboutToDisappear() {
    Log.info(TAG, 'PickerSheetContent aboutToDisappear');
    if (this.storage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      this.breakpointSystem.unregisterOrientationChange();
    }
    if (this.isToastShowed) {
      AppStorage.delete(Constants.HAS_PICKER_VIEW_WARNING_SHOW + this.param.bundleName);
    }
    LocalStorage.getShared()?.setOrCreate(Constants.PHOTO_PICKER_FROM_PHOTOS, false);
    this.broadCast.off(Constants.UPDATE_NAVIGATION_HEIGHT, this.navigationHeightFunc);
    this.broadCast.off(Constants.DISABLE_SCROLL_TO_ANCHOR, this.disableScrollToAnchorFunc);
  }

  /**
   * @Watch browserController
   */
  private updateAnimationStatus(): void {
    this.loadBrowserComponent();
  }

  private bindBackFunc(backFunc: Function): void {
    this.backFuncBinder = backFunc;
  }

  private buildPickerViewToast(navigationHeight: number): void {
    if (!this.param.isFromPickerView) {
      return;
    }
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      return;
    }
    this.toastController = new CustomDialogController({
      builder: PickerViewWarningToast({}),
      autoCancel: false,
      customStyle: true,
      isModal: false,
      alignment: !this.param.singleLineConfig ? DialogAlignment.Default : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: !this.param.singleLineConfig ? (navigationHeight / 2 - PICKER_VIEW_TOAST_SAFETY_DISTANCE) :
          SINGLE_LINE_MODE_PICKER_VIEW_TOAST_DY,
      },
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        Log.info(TAG, 'PickerViewWarningToast, bind sheet onWillDismiss.');
        if (this.browserController.isBrowserShow && dismissSheetAction.reason == DismissReason.PRESS_BACK) {
          Log.info(TAG, 'PickerViewWarningToast, back to grid view.');
          this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
        }
        dismissSheetAction.dismiss();
      }),
    })
  }

  private disableScrollToAnchor(): void {
    Log.info(TAG, `disableScrollToAnchor`);
    this.param.recoverSceneEnabled = false;
  }

  private showPickerViewToast(): void {
    this.isToastShowed = true;
    if (this.toastController != undefined || this.toastController != null) {
      this.toastController.open();
      AppStorage.setOrCreate(Constants.HAS_PICKER_VIEW_WARNING_SHOW + this.param.bundleName, true);
    }
    setTimeout((): void => {
      if (this.toastController != undefined || this.toastController != null) {
        this.toastController.close();
      }
    }, 4150);
  }

  private checkIfNeedPickerViewToast(): void {
    let pickerShowFlag = AppStorage.get<boolean>(Constants.HAS_PICKER_VIEW_WARNING_SHOW + this.param.bundleName);
    if (!this.param.isFromPickerView || pickerShowFlag) {
      return;
    }

    PickerUtil.isAppExist(this.param.bundleName, Constants.ACCESSING_PICKER_VIEW_APP_LIST)
      .then((result: AppPresenceStatus) => {
        if (result !== AppPresenceStatus.NOT_EXIST || this.checkIfNeedPickerViewToastUnderLayout()) {
          this.showPickerViewToast();
        }
      });
  }

  private checkIfNeedPickerViewToastUnderLayout(): boolean {
    return this.param.orientation === PickerOrientation.HORIZONTAL || this.param.singleLineConfig !== undefined;
  }

  @Builder
  PickerContents() {
    Stack() {
      Column() {
        ThirdSelectPhotoGridBase({
          replaceUriManager: this.replaceUriManager,
          pageStatus: this.pageStatus,
          backFuncBinder: (backFunc: Function): void => this.bindBackFunc(backFunc),
          browserController: this.browserController,
          param: this.param,
          actionBarController: this.actionBarController,
          controller: this.thirdSelectGridController,
          searchKeyword: this.searchKeyword,
          photoDataImpl: this.photoDataImpl,
          inputDataSource: this.dataSource,
          storage: this.storage,
        })
          .accessibilityLevel('no')
          .transition({ type: TransitionType.All, opacity: 0 })
          .onAppear((): void => {
            Log.info(TAG, 'ThirdSelectPhotoGridBase onAppear');
          })
      }

      if (this.isBrowserShow) {
        this.selectBrowserLoader({
          replaceUriManager: this.replaceUriManager,
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
    .onAppear((): void => {
      this.checkIfNeedPickerViewToast();
      setTimeout((): void => {
        CommonUtil.registerProgDispSwitchObserver(getContext(this));
        this.loadBrowserComponent();
      }, 500); // 提前加载大图布局，优化进大图响应时延同时避免影响picker启动完成时延
    })
  }

  build() {
    Stack() {
      this.PickerContents();
    }
    .width('100%')
    .height('100%')
  }

  private async loadBrowserComponent(): Promise<void> {
    if (this.isPhotoBrowserLoad) {
      this.isBrowserShow = this.browserController.isBrowserShow;
      return;
    }
    try {
      let loader = await import('./ThirdSelectBrowserViewLoader');
      this.selectBrowserLoader = loader.ThirdSelectBrowserViewLoader;
      this.isBrowserShow = this.browserController.isBrowserShow;
      this.isPhotoBrowserLoad = true;
    } catch (error) {
      Log.error(TAG, `loadBrowserComponent error: ${error}`);
    }
  }
}
